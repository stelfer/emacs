;;
;; 
;;
;;

(menu-bar-mode -1)
; keep the bar from showing up ever

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;;;;
;;;; Modules and configuration
;;;;
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'indent-file)
(require 'saveplace)
(require 'rtags-echo)
(require 'workspace)
(require 'build)

(add-hook 'window-setup-hook
	  (lambda()
	    ;; Blank the terminal background, so themes will work nicely
	    (unless (display-graphic-p (selected-frame))
	      (set-face-background 'default "unspecified-bg" (selected-frame)))

	    (setq visible-bell nil)
	    
	    ;; Setup anything using a windows-system
	    (unless window-system
	      (require 'mouse)
	      (xterm-mouse-mode t)
	      (global-set-key [mouse-4] '(lambda ()
					   (interactive)
					   (scroll-down 1)))
	      (global-set-key [mouse-5] '(lambda ()
					   (interactive)
					   (scroll-up 1)))
	      (defun track-mouse (e))
	      (setq mouse-sel-mode t)
	      (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
	      (setq mouse-wheel-progressive-speed nil)		  ;; don't accelerate scrolling
	      (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
	      (setq scroll-step 1)		 ;; keyboard scroll one line at a tim
					;  (tool-bar-mode -1)
	      (menu-bar-mode -1))

	    (when window-system
	      (tool-bar-mode -1)
	      (windmove-default-keybindings)
	      (scroll-bar-mode -1))))


(add-hook 'after-init-hook
	  (lambda()
	    (global-company-mode t)
	    (global-font-lock-mode t)))


(put 'upcase-region 'disabled nil)
(setq-default save-place t
	      fill-column 100)

(setq x-select-enable-clipboard t
      x-select-enable-primary t
      save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      visible-bell t
      load-prefer-newer t
      ediff-window-setup-function 'ediff-setup-windows-plain
      save-place-file (concat user-emacs-directory "places")
      backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
      transient-mark-mode t
      linum-format "%4d "
      indent-tabs-mode nil
      comment-auto-fill-only-comments t
      font-lock-maximum-decoration t
      ad-redefinition-action 'accept)

;; company
(setq company-idle-delay 0.5
      company-minimum-prefix-length 1)

;; yasnippet
(require 'yasnippet)
(yas-reload-all)

;; helm
(require 'helm)
(require 'helm-config)
(helm-mode 1)
(setq helm-split-window-in-side-p           nil
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(defun my-helm-split-window (window)
  (if (one-window-p t)
      ;; With just window helm does the right thing
      (split-window
       (selected-window) nil (if (eq helm-split-window-default-side 'other)
                                 'below helm-split-window-default-side))

    ;; If there are multiple windows, select the bottom-left window
    (while (window-in-direction 'left)
      (select-window (window-in-direction 'left)))
    (while (window-in-direction 'below)
      (select-window (window-in-direction 'below)))

    (selected-window)))
(setq helm-split-window-preferred-function #'my-helm-split-window)


(require 'helm-descbinds)
(helm-descbinds-mode)

;; projectile and helm-projectile
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;; eshell
(setq eshell-where-to-jump 'begin
      eshell-review-quick-commands nil
      eshell-smart-space-goes-to-end t)

;; desktop
(setq desktop-restore-frames t
      desktop-restore-in-current-display t
      desktop-restore-forces-onscreen nil)

;;;;
;;;; Custome modelines
;;;;
(defface projectile-mode-line-face '((t (:foreground "#ff1493" :weight normal)))  "Red highlight")
(setq projectile-mode-line
      '(:propertize 
	(:eval
      	(if (file-remote-p default-directory)
      	    " P"
      	  (format " [%s]" (projectile-project-name)))) face projectile-mode-line-face))


;;;;
;;;; Custom keymaps
;;;;
(global-set-key (kbd "s-{") 'previous-buffer)
(global-set-key (kbd "s-}") 'next-buffer)
(global-set-key (kbd "s-<") 'beginning-of-buffer)
(global-set-key (kbd "s->") 'end-of-buffer)
(global-set-key (kbd "C-x g") 'goto-line)
(global-set-key (kbd "M-%") 'query-replace-regexp)
(global-set-key (kbd "C-c C-f") 'helm-projectile-find-file)
(global-set-key (kbd "C-c C-g") 'helm-projectile-grep)
(global-set-key "\C-\M-i" 'helm-projectile-find-other-file)

;; helm
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

;; prog-mode
(define-prefix-command 'my-prog-mode-map)
(define-key my-prog-mode-map (kbd "g") 'magit-status)

;; c-mode
(define-prefix-command 'my-c-mode-map)
(define-key my-c-mode-map (kbd "g") 'magit-status)
(define-key my-c-mode-map (kbd "C-c") 'build)
(define-key my-c-mode-map (kbd "m") 'build-target-from-current)
(define-key my-c-mode-map (kbd "C-s") 'rtags-imenu)
(define-key my-c-mode-map (kbd "C-r") 'rtags-rename-symbol)
(define-key my-c-mode-map (kbd "s") 'rtags-find-symbol)
(define-key my-c-mode-map (kbd "d") 'my-rtags-create-doxygen-comment)
(define-key my-c-mode-map (kbd "C-i r") 'rtags-find-references-at-point)
(define-key my-c-mode-map (kbd "C-i h") 'rtags-print-class-hierarchy)
(define-key my-c-mode-map (kbd "C-i i") 'rtags-symbol-info)
(define-key my-c-mode-map (kbd "C-i t") 'rtags-symbol-type)
(define-key my-c-mode-map (kbd "C-i d") 'rtags-dependency-tree)

;;;;
;;;; Hooks
;;;;
(add-hook 'window-setup-hook
	  (lambda()
	    ;; Blank the terminal background, so themes will work nicely
	    (unless (display-graphic-p (selected-frame))
	      (set-face-background 'default "unspecified-bg" (selected-frame)))

	    ;; Setup anything using a windows-system
	    (unless window-system
	      (require 'mouse)
	      (xterm-mouse-mode t)
	      (global-set-key [mouse-4] '(lambda ()
					   (interactive)
					   (scroll-down 1)))
	      (global-set-key [mouse-5] '(lambda ()
					   (interactive)
					   (scroll-up 1)))
	      (defun track-mouse (e))
	      (setq mouse-sel-mode t)
	      (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
	      (setq mouse-wheel-progressive-speed nil)		  ;; don't accelerate scrolling
	      (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
	      (setq scroll-step 1)		 ;; keyboard scroll one line at a tim
	      (tool-bar-mode -1)
	      (menu-bar-mode -1))))


(require 'ansi-color)
(add-hook 'compilation-filter-hook (lambda ()
				     (toggle-read-only)
				     (ansi-color-apply-on-region compilation-filter-start (point))
				     (toggle-read-only)))

;; (defun eshell-handle-ansi-color ()
;;   (ansi-color-apply-on-region eshell-last-output-start
;; 			      eshell-last-output-end))
;; (add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color)

(ansi-color-for-comint-mode-on)

;; (add-hook 'compilation-filter-hook (lambda ()
;; 				     (toggle-read-only)
;; 				     (ansi-color-apply-on-region compilation-filter-start (point))
;; 				     (toggle-read-only)))

(add-hook 'after-init-hook
	  (lambda()
	    (global-company-mode t)
	    (global-font-lock-mode t)))

(add-hook 'prog-mode-hook #'yas-minor-mode)

(add-hook 'prog-mode-hook
	  (lambda()
	    (auto-insert-mode t)
	    (linum-mode t)
	    (local-set-key (kbd "C-c") 'my-prog-mode-map)))

;; Treat .h as c++ by default
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(add-hook 'c-mode-common-hook
	  (lambda()
	    (c-toggle-auto-newline 1)
	    (c-toggle-hungry-state 1)
	    (electric-pair-mode 1)
	    (auto-fill-mode 1)
	    (local-set-key (kbd "C-c") 'my-c-mode-map)
	    (local-set-key "\C-\M-i" 'helm-projectile-find-other-file)
	    (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
	    (local-set-key (kbd "M-,") 'rtags-location-stack-back)
	    (local-set-key (kbd "M-/") 'rtags-location-stack-forward)
	    (local-set-key (quote [f5]) 'recompile)
	    
	    (highlight-symbol-mode 1)
	    (add-to-list 'c-doc-comment-style '(c++-mode . javadoc))
	    (setq rtags-autostart-diagnostics t)
	    (rtags-diagnostics)
	    (rtags-echo-mode 1)
	    (setq rtags-completions-enabled t)

	    (add-hook 'before-save-hook (lambda ()
					  (when (or (eq major-mode 'c++-mode) (eq major-mode 'c-mode))
					    (clang-format-buffer))))
	    
	    (add-to-list 'company-backends 'company-rtags)

	    (setq company-frontends '(company-pseudo-tooltip-unless-just-one-frontend company-preview-if-just-one-frontend company-echo-metadata-frontend company-preview-frontend))
	    
	    (setq yas-indent-line 'fixed)))

(add-hook 'c++-mode-hook
	  '(lambda()
	     (font-lock-add-keywords
	      nil '(;; complete some fundamental keywords
		    ("\\<\\(void\\|unsigned\\|signed\\|char\\|short\\|bool\\|int\\|long\\|float\\|double\\)\\>" . font-lock-keyword-face)
		    ;; add the new C++11 keywords
		    ("\\<\\(alignof\\|alignas\\|constexpr\\|decltype\\|noexcept\\|nullptr\\|static_assert\\|thread_local\\|override\\|final\\)\\>" . font-lock-keyword-face)
		    ("\\<\\(char[0-9]+_t\\)\\>" . font-lock-keyword-face)
		    ;; PREPROCESSOR_CONSTANT
		    ("\\<[A-Z]+[A-Z_]+\\>" . font-lock-constant-face)
		    ;; hexadecimal numbers
		    ("\\<0[xX][0-9A-Fa-f]+\\>" . font-lock-constant-face)
		    ;; integer/float/scientific numbers
		    ("\\<[\\-+]*[0-9]*\\.?[0-9]+\\([ulUL]+\\|[eE][\\-+]?[0-9]+\\)?\\>" . font-lock-constant-face)
		    ;; user-types (customize!)
		    ("\\<[A-Za-z_]+[A-Za-z_0-9]*_\\(t\\|type\\|ptr\\)\\>" . font-lock-type-face)
		    ("\\<\\(xstring\\|xchar\\)\\>" . font-lock-type-face)))
	     ) t)


(defun my-rtags-create-doxygen-comment ()
  "Creates doxygen comment for function at point Comment will be
inserted before current line. It uses yasnippet to let the user
enter missing field manually."
  (interactive)
  (save-some-buffers) ;; it all kinda falls apart when buffers are unsaved
  (let ((symbol (rtags-symbol-info-internal)))
    (unless symbol
        (error "Can't find symbol here"))
      (let* ((type (cdr (assoc 'type symbol)))
             (return-val (and (string-match "^\\([^)]*\\) (.*" type)
                              (match-string 1 type)))
             ;;           (args (mapcar (lambda (arg) (cdr (assoc 'symbolName arg))) (cdr (assoc 'arguments symbol))))
             (index 2)
             (snippet (concat "/** @Brief ${1:Function description}\n"
                              (mapconcat (lambda (arg)
                                           (let* ((complete-name (cdr (assoc 'symbolName arg)))
                                                  (symbol-type (cdr (assoc 'type arg)))
                                                  (symbol-name (substring complete-name (- 0 (cdr (assoc 'symbolLength arg)))))
                                                  (ret (format " * @param %s <b>{%s}</b> ${%d:Parameter description}"
                                                               symbol-name symbol-type index)))
                                             (incf index)
                                             ret))
                                         (cdr (assoc 'arguments symbol))
                                         "\n")
                              (unless (string= return-val "void")
                                (format "%s * @return <b>{%s}</b> ${%d:Return value description}\n"
                                        (if (eq index 2)
                                            ""
                                          "\n")
                                        return-val index))
                              "\n */\n")))
        (back-to-indentation)
	;; (let ((yas-indent-line t))
	(yas-expand-snippet snippet (point) (point) nil))))






      
(defun rtags-load-database (dir)
  (rtags-call-rc "-J" dir))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(compilation-message-face (quote default))
 '(custom-safe-themes
   (quote
    ("725ce977637586feabe7418392fc3c01edd32c0934f1563c158051a0a2c45a8c" default)))
 '(fci-rule-color "#49483E")
 '(highlight-changes-colors ("#FD5FF0" "#AE81FF"))
 '(highlight-tail-colors
   (("#49483E" . 0)
    ("#67930F" . 20)
    ("#349B8D" . 30)
    ("#21889B" . 50)
    ("#968B26" . 60)
    ("#A45E0A" . 70)
    ("#A41F99" . 85)
    ("#49483E" . 100)))
 '(markdown-command "multimarkdown")
 '(org-agenda-files (quote ("~/l/layers/test.org")))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#F92672")
     (40 . "#CF4F1F")
     (60 . "#C26C0F")
     (80 . "#E6DB74")
     (100 . "#AB8C00")
     (120 . "#A18F00")
     (140 . "#989200")
     (160 . "#8E9500")
     (180 . "#A6E22E")
     (200 . "#729A1E")
     (220 . "#609C3C")
     (240 . "#4E9D5B")
     (260 . "#3C9F79")
     (280 . "#A1EFE4")
     (300 . "#299BA6")
     (320 . "#2896B5")
     (340 . "#2790C3")
     (360 . "#66D9EF"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (unspecified "#272822" "#49483E" "#A20C41" "#F92672" "#67930F" "#A6E22E" "#968B26" "#E6DB74" "#21889B" "#66D9EF" "#A41F99" "#FD5FF0" "#349B8D" "#A1EFE4" "#F8F8F2" "#F8F8F0")))

(load-theme 'dark)

(require 'helm-descbinds)
(helm-descbinds-mode)


(defun my-rtags-create-doxygen-comment ()
  "Creates doxygen comment for function at point Comment will be
inserted before current line. It uses yasnippet to let the user
enter missing field manually."
  (interactive)
  (when (or (not (rtags-called-interactively-p)) (rtags-sandbox-id-matches))
    (save-some-buffers) ;; it all kinda falls apart when buffers are unsaved
    (let ((symbol (rtags-symbol-info-internal)))
      (unless symbol
        (error "Can't find symbol here"))
      (let* ((type (cdr (assoc 'type symbol)))
             (return-val (and (string-match "^\\([^)]*\\) (.*" type)
                              (match-string 1 type)))
             ;;           (args (mapcar (lambda (arg) (cdr (assoc 'symbolName arg))) (cdr (assoc 'arguments symbol))))
             (index 2)
             (snippet (concat "/** @Brief ${1:Function description}\n"
                              (mapconcat (lambda (arg)
                                           (let* ((complete-name (cdr (assoc 'symbolName arg)))
                                                  (symbol-type (cdr (assoc 'type arg)))
                                                  (symbol-name (substring complete-name (- 0 (cdr (assoc 'symbolLength arg)))))
                                                  (ret (format " * @param %s <b>{%s}</b> ${%d:Parameter description}"
                                                               symbol-name symbol-type index)))
                                             (incf index)
                                             ret))
                                         (cdr (assoc 'arguments symbol))
                                         "\n")
                              (unless (string= return-val "void")
                                (format "%s * @return <b>{%s}</b> ${%d:Return value description}\n"
                                        (if (eq index 2)
                                            ""
                                          "\n")
                                        return-val index))
                              "\n */\n")))
        (back-to-indentation)
        (yas-expand-snippet snippet (point) (point) nil)))))


(setq eshell-where-to-jump 'begin)
(setq eshell-review-quick-commands nil)
(setq eshell-smart-space-goes-to-end t)

(setq desktop-restore-frames t)
(setq desktop-restore-in-current-display t)
(setq desktop-restore-forces-onscreen nil)

(require 'workspace)

(require 'build)

      
(defun rtags-load-database (dir)
  (rtags-call-rc "-J" dir))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rtags-errline ((t (:background "#ff8080"))))
 '(rtags-fixitline ((t (:background "#ff8080")))))
