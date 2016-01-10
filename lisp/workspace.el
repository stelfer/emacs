
(require 'magit)
(require 'projectile)
(require 'dash)

;; (defcustom workspace-lighter-base "WS"
;;   "Base string to use for the `workspace-mode' lighter."
;;   :type 'string)

(defvar workspace-current-tag nil)

;;;###autoload
(defvar workspace-lighter
  '(" WS["
    (:eval workspace-current-tag) "]"))
(put 'workspace-lighter 'risky-local-variable t)

;;;###autoload
(define-minor-mode workspace-mode
  "A workspace mode
\\{projectile-mode-map}"
  :lighter workspace-lighter
  :keymap (let ((map (make-sparse-keymap)))
	    (define-key map (kbd "C-c w c") 'workspace-create)
	    (define-key map (kbd "C-c w l") 'workspace-load)
	    map)
  ()
  )

;;;###autoload
(add-hook 'projectile-mode-hook 'workspace-mode)

;;;###autoload
(add-hook 'after-init-hook (lambda ()
		       (workspace-start-on-init)))

(defvar workspace-stash-sha nil)
(defvar workspace-helpful-hello "HI")

(defvar workspace-extra-vars '(workspace-stash-sha workspace-helpful-hello))

;;;###autoload
(with-eval-after-load "desktop"
  (mapcar (lambda (x) (add-to-list 'desktop-globals-to-save x)) workspace-extra-vars)
  (message "HI!!!!"))

(defun workspace-prepare-desktop-vars (tag)
  (setq desktop-dirname  (concat (file-name-as-directory (projectile-project-root)) ".desktops"))
  (setq desktop-base-file-name tag)
  (setq desktop-base-lock-name (concat desktop-base-file-name ".lock")))

(defun workspace-get-tags()
  (let* ((desktop-dirname (concat (file-name-as-directory (projectile-project-root)) ".desktops"))
	 (files (directory-files desktop-dirname ))
	 (files-exclude-regexp "^\\.\\|\\..*$"))
    (-remove (lambda (x) (string-match files-exclude-regexp x)) files))
  )


(defun workspace-list-local-branches()
  (magit-list-local-branch-nams))

(defun workspace-current-branch()
  (magit-get-current-branch))


(defun workspace-stash-get-sha ()
  "Return the stash sha or nil if none"
  (let ((sha (magit-rev-parse "stash@{0}")))
    (cond ((not (string= sha "stash@{0}"))
	   sha)
	  (t
	   nil))))

(defun workspace-stash (tag)
  (condition-case err
      (lambda ()
	(magit-stash tag) ;; will throw error
	(workspace-stash-get-sha)
	(user-error nil))))
  
		       
(defun workspace-create (tag)
  (interactive)

  (unless (boundp 'desktop-globals-to-save)
    (error "desktop-save-mode not set"))
  
  (unless (projectile-project-p)
    (error "Not a project"))
  
  (unless (magit-branch-p tag)
    (magit-branch tag "master"))

  (workspace-prepare-desktop-vars tag)
  
  (unless (file-exists-p desktop-dirname)
    (make-directory desktop-dirname))
  
  (let ((desktop-restore-eager t)
	(workspace-stash-sha "2345"))
    (desktop-save desktop-dirname 'RELEASE 'AUTOSAVE))
  )

(defun workspace-create-and-load (&optional tag from)
  (interactive)
  (workspace-load (call-interactively 'workspace-create)))


(defun workspace-load (&optional tag)
  (interactive
   (list (completing-read "tag: " (workspace-get-tags) nil nil)))

  (unless (boundp 'desktop-globals-to-save)
    (error "desktop-save-mode not set"))
  
  (unless (projectile-project-p)
    (error "Not a project"))
  
  (message "TAG = %s" tag)
  (unless (-contains? tag (workspace-get-tags))
    (workspace-create tag))
  
  ;; (unless (magit-branch-p tag)
  ;;     (error "Branch %s doesn't exists" tag))

  (magit-checkout tag)
  
  ;; (message "CHECKING OUT %s" tag)
  (workspace-prepare-desktop-vars tag)
  
  (desktop-clear)
  (desktop-read desktop-dirname)
  (setq workspace-current-tag tag))

;; (defmacro assert (test-form)
;;   `(when (not ,test-form)
;;      (error "Assertion failed: %s" (format "%s" ',test-form))))

(defun workspace-switch-to-tag(branch)
  (let ((current-tag (and branch (-contains? (workspace-get-tags) branch))))
    (unless current-tag
      (when (yes-or-no-p (format "Create workspace for branch:%s: " branch))
	(workspace-create branch)))
    (workspace-load branch)))

(defun workspace-start ()
  (let ((current-branch (workspace-current-branch)))
    (when current-branch
      (workspace-switch-to-tag current-branch))))

(defun workspace-start-on-init ()
  "If emacs started with no command line args, and this mode is loaded, then automatically start"
  (when (< (length command-line-args) 2)
    (setq inhibit-startup-message t)	; If we don't do this, it will put the startup buffer on top
    (workspace-start)))

(provide 'workspace)

;;(workspace-start-on-init)


;; (call-interactively 'my-branch-and-save-desktop)
;; (workspace-create "test")
;; (workspace-load "test")
;; (magit-checkout "test")
;; (global-set-key (kbd "C-c w c") 'workspace-create)
;; (global-set-key (kbd "C-c w l") 'workspace-load)

