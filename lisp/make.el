
(require 'projectile)

(defun make-project ()
  (interactive)
  (let* ((args (cond
	       ((projectile-project-p) (concat "-C " (projectile-project-root)))
	       (t "")))
	 (command (concat "make " args)))
    (compile command)))

(defun make-target-from-current ()
  (interactive)
  (let ((hint make-target-use-current-buffer-as-hint))
    (setq make-target-use-current-buffer-as-hint t)
    (call-interactively 'make-target)
    (setq make-target-use-current-buffer-as-hint hint)))

(defvar make-target-use-current-buffer-as-hint nil)

(defun make-target-dir-args ()
  (if (projectile-project-p)
      (concat " -j" " -C " (projectile-project-root))
    (error "Not a project")))

(defun make-get-target ()
  (let ((target-exclude-regexp "\\(^\\.\\)\\|[\\$\\%]")
	(initial (if make-target-use-current-buffer-as-hint
		     (file-name-sans-extension (buffer-name)) nil)))
    (save-window-excursion
      (with-output-to-temp-buffer "*make-targets*"
	(let* ((make-dir-args (make-target-dir-args))
	       (command (concat "make -np" make-dir-args)))
	  (shell-command command "*make-targets*")
	  (pop-to-buffer "*make-targets*")
	  (goto-char (point-max))
	  (let ((targets nil))
	    (while (re-search-backward "^\\(build/[^:\n#[:space:]]+?\\):"
				       (not 'bound) 'noerror)
	      (unless (string-match target-exclude-regexp
				    (match-string 1))
		(setq targets (cons (match-string 1) targets))))
	    (delete-windows-on "*make-targets*")
	    ;; (setq target (completing-read "target: " targets nil nil initial)))))))
	    (completing-read "target: " targets nil nil initial)))))))

(defun make-target (&optional target)
  (interactive (list (make-get-target)))
  (message "%s" target)
  (let ((command (concat "make" (make-target-dir-args) " " target)))
    (compile command)))

(provide 'make)
