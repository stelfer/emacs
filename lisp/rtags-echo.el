


(defvar rtags-echo-idle-delay 0.5)
(defvar rtags-echo-timer nil)

(defun rtags-echo-do ()
  (eldoc-message (rtags-symbol-type)))

(defun rtags-echo-update-timer (value)
  (when rtags-echo-timer
    (cancel-timer rtags-echo-timer))
  (setq rtags-echo-timer
	(run-with-idle-timer value t 'rtags-echo-do)))

(define-minor-mode rtags-echo-mode
  "Minor mode that displays `rtags-symbol-type' after `rtags-echo-idle-delay'."
  nil " echo" nil
  (if rtags-echo-mode
      (progn
	(require 'eldoc)
	(rtags-echo-update-timer rtags-echo-idle-delay))
    (when rtags-echo-timer
      (print "CANCELING")
      (cancel-timer rtags-echo-timer))))

(provide 'rtags-echo)
