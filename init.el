
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
  (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
  (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
  (setq scroll-step 1) ;; keyboard scroll one line at a tim
;  (tool-bar-mode -1)
  (menu-bar-mode -1)
  )



(put 'upcase-region 'disabled nil)
(setq transient-mark-mode t)
(global-linum-mode 1)
(setq linum-format "%4d ")
(setq-default fill-column 100)
(setq indent-tabs-mode nil)
(setq comment-auto-fill-only-comments t)
;(setq magit-last-seen-setup-instructions "1.4.0")
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)


(add-to-list 'load-path "~/.emacs.d/lisp")


(require 'whitespace)
(setq whitespace-style '(trailing tabs newline tab-mark newline-mark))

;;(require 'magit)

;; (add-to-list 'load-path "~/.lisp/Fill-Column-Indicator")
(require 'fill-column-indicator)
(setq fci-rule-width 1)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)

;; (require 'ido)
;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;; (ido-mode 1)
;; (setq ido-use-filename-at-point 'guess)

;;(require 'sourcepair)

;; (load-file "~/.lisp/cedet/common/cedet.el")

(require 'cc-mode)

(require 'semantic)
(require 'srecode)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(global-semantic-idle-summary-mode 1)
(global-semantic-stickyfunc-mode 1)
(global-semantic-decoration-mode 1)
(setq company-idle-delay 0.5)
(setq company-minimum-prefix-length 1)

(semantic-mode 1)

(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(setq markdown-command "multimarkdown")

(require 'indent-file)
(require 'erc)
(require 'tls)


(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(require 'saveplace)
(setq-default save-place t)


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
      backup-directory-alist `(("." . ,(concat user-emacs-directory
					       "backups"))))

(defun start-irc ()
   "Connect to IRC."
   (interactive)
   (erc-tls 
    :server "irc.tfoundry.com" :port 6697 
    :nick "soren" 
    :password "crab-ej-eyb-hev"
    :full-name "soren")
   (setq erc-autojoin-channels-alist '(("irc.tfoundry.com" "#core"))))



;;
;;
;; Compilation
;;
(defun my-save-and-compile ()
  "Save current buffer and issue compile."
  (interactive "")
  (save-buffer 0)
  (message compile-command)
  (compile compile-command)
;;  (compile (concat "make -w -j1 -S -C " make-root))
  )


(setq compilation-last-buffer nil)
(setq compilation-scroll-output 'first-error)
(setq compilation-finish-function
      (lambda (buf str)

        (if (string-match "exited abnormally" str)

            ;;there were errors
            (message "compilation errors, press C-x ` to visit")

          ;;no errors, make the compilation window go away in 0.5 seconds
          (run-at-time 0.5 nil 'delete-windows-on buf)
          (message "NO COMPILATION ERRORS!"))))

(defun get-buffers-matching-mode (mode)
  "Returns a list of buffers where their major-mode is equal to MODE"
  (let ((buffer-mode-matches '()))
   (dolist (buf (buffer-list))
     (with-current-buffer buf
       (if (eq mode major-mode)
           (add-to-list 'buffer-mode-matches buf))))
   buffer-mode-matches))
 
(defun multi-occur-in-this-mode ()
  "Show all lines matching REGEXP in buffers with this major mode."
  (interactive)
  (multi-occur
   (get-buffers-matching-mode major-mode)
   (car (occur-read-primary-args))))
 


(require 're-builder)
(setq reb-re-syntax 'string)

(when (require 'browse-kill-ring nil 'noerror)
  (browse-kill-ring-default-keybindings))

(add-hook 'after-init-hook 'global-company-mode)

(defun my-c-mode-hook ()
  (load "/home/telfer/l/layers/tools/layers-style.el")
  (c-add-style "layers-style" layers-style)
  (c-toggle-auto-newline 1)
  (c-toggle-hungry-state 1)
  (electric-pair-mode 1)
  (auto-fill-mode 1)
  (c-set-style "layers-style")
  (local-set-key "\C-\M-i" 'helm-projectile-find-other-file)
  (local-set-key "\C-c\C-c" 'my-save-and-compile)
  (local-set-key "\C-c\C-r" 'recompile)
  ;; (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  ;; (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  (local-set-key "\C-cs" 'semantic-symref)
  (local-set-key "\C-c." 'semantic-ia-fast-jump)
  (local-set-key "\C-cd" 'semantic-ia-show-doc)
  (local-set-key "\C-ci" 'srecode-document-insert-comment)
  (local-set-key (kbd "<M-up>") 'senator-previous-tag)
  (local-set-key (kbd "<M-down>") 'senator-next-tag)
  (local-set-key (kbd "ESC <up>") 'senator-previous-tag)
  (local-set-key (kbd "ESC <down>") 'senator-next-tag)
  (local-set-key (quote [f5]) 'recompile)
  (local-set-key "\C-c\C-r" 'recompile)
  (add-to-list 'c-doc-comment-style '(c++-mode . javadoc))
  (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
    (ggtags-mode 1))
)

(add-hook 'c-mode-common-hook 'my-c-mode-hook)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; (add-hook 'c-mode-common-hook
;; 	  (lambda ()
;; 	    ))

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
		    ("\\<\\(xstring\\|xchar\\)\\>" . font-lock-type-face)
		    ))
	     ) t)


;; (require 'ansi-color)
;; (defun colorize-compilation-buffer ()
;;   (toggle-read-only)
;;   (ansi-color-apply-on-region (point-min) (point-max))
;;   (toggle-read-only))
;; (add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(defun sh ()
  (interactive)
  (ansi-term "/bin/bash"))

;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(require 'nasm-mode)
(add-to-list 'auto-mode-alist '("\\.nasm\\'" . nasm-mode))


(require 'package) ;; You might already have this line
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

(package-initialize) ;; You might already have this line

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)


(defun pbcopy ()
  (interactive)
  (call-process-region (point) (mark) "pbcopy")
  (setq deactivate-mark t))

(defun pbpaste ()
  (interactive)
  (call-process-region (point) (if mark-active (mark) (point)) "pbpaste" t t))

(defun pbcut ()
  (interactive)
  (pbcopy)
  (delete-region (region-beginning) (region-end)))





(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compilation-message-face (quote default))
 '(custom-enabled-themes (quote (leuven)))
 '(custom-safe-themes
   (quote
    ("0ec59d997a305e938d9ec8f63263a8fc12e17990aafc36ff3aff9bc5c5a202f0" "7d3e681736e66cd2f9144042ffea45f956385213618fbdf1338324be88d591ec" "7f77f8f41a0ef4359da7b20b3297ab4684c278fd9d7ca5344c6c14c04753ae47" "5390541773eb2bf021f20d9470ce586bee4d7076423f3894e966d5dc7f5e173c" "b7cfc81c1b0e3c37a5adc850c0b2f9d25d6088462c6f08ce2fadb07d299e1ad8" "be75a811e29fbe42de4c49918b999b1e1a2e671e834e7e07bb7f383d6c8cd6b3" "1bdc1013720f16b5692166a53e0333dce14487247a3ade199e5978d39602b1d3" "556bb25f81b735f98e9a21e567cc4ac8b3131c9335d88a72facab4fee6851966" "9a2d2ce7ae4ef225491a308ad6ef600901fbbdf72484dc1edb99c06c3a3aa0aa" "9344059fa6a6f0ab3d07d2fc1c224939b9fd6f5948c30e075b08fb29f6025177" "b5870a5f958aab769848dbafd34dff036340ecf73b0ed6d83dffdf8792a28c7f" "ab274123289f47d4fda6b5f2047d291b9e14f5ce486fe239ea3bd86b391f927f" "a1b2c58f9d1e00217fe9dda8f03c809679555739b53c396f6d2ca0a02bbcf3a3" "7d7815c2bed67d0df1ccaf09187107bce6b11b0c9e8785ca63ac5a765f50b1e6" "a788980c894f9f24e78e8931fe641ae8adc2970fad0c504068552556d25630bc" "4bd7e93b2622780c5f54e877c48b2b53c04f5ec7ffa8ed4fa49601b258a5f943" "cf8c0cdde21ef837f124058d3524d0108477a44b333cffdacc5b7d012a7378a2" "f3cecaf2b776d899d9368b4f72ec73c77be5dc823c44795e354723b23745de37" "8d70db8645040d8197827c2e9767ec5c808924d859069034a51a8ab9dc917517" "4b0f166c6a59ebc067e37b158da6584af03cbc600f72140caadedf6753cd9d62" "328803e844faf04d74b9f4d5032da0e3c127009892d063d50ede842b81cb6f83" "6c035daa6a8f157ef102c54657d5560b34169468380e32ffa10af5c8c0455632" "54751187f29a2990b6c265eb430fbc7712c5a35204974c496f3ea1a6f262fd87" "25a18aaf83c1aca4a2399479d6fdf35e792938abeaac5a35e961f7e77e90bef6" "e57b2357dbd1f56586feac1a572e42bdeb0d04cd8db850cc97d692f5162f6ba1" "3c561ad7ceee37cae2d90e78fbd54cfbcfca5c679d364225742dd0254d7a4f2e" "b5e959ae00e373a436d334b7ba60403302924f8581ea78765a820ec905d54f9a" "c162222291f3cfcca713f56cc6ccd62040b70ec74e18cbcafc0f8758bc50f9fb" "d8705186597d49ba6e151b0c23ce5bf96f927950e70048320aeff19eff6f2220" "1fb9f8441bcc125894b09f5c79ce0419fecac6c3a98521218dc9b8a37f57a298" "4caff53178aece5c8856419af357ed06b8a16ffbf364e954490e3c9e5524240c" "f75a950ca53d04fefd5a19efef03088304a1c9736a0d182d740847e58f81a685" "003ed5f7be6cfdba623b2f276322e3099df986e399bdb7da8cf8db27dd350231" "b5e939d5e92cd618b3c32ee286a794a98afe4895deeb0831073e746af6480f43" "633b1f73837063e8792a7c4dab135fe0fb48eb8847875833aae223bd00ed0aa5" "20792ad267e8d51a23cdca221afa86a6cf74d8c6259c855dde3e4339b8a64249" "5bede4cc9000ebf869ca6db7403feb8f4cfbe8ae64d82ebb8fcf88c92884fbfa" "6963362f4448dd7b7c0d401edb0c59200f027147e6830aa995b3826ff1bfeac8" "5d5f9adbd5617eca9aa138238bc362188899ef2411851856c6c649a6c2c6df2e" "6bc8b2af7f6837f4e81ba386e9a2f0445f6a76669bcff83d6c74bb3d1f4257e9" "9229d58bee72fb79d7c78c810fc22dbecd1b21cb2ea9a6840f343f33b9893da5" "8abee8a14e028101f90a2d314f1b03bed1cde7fd3f1eb945ada6ffc15b1d7d65" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "e80932ca56b0f109f8545576531d3fc79487ca35a9a9693b62bf30d6d08c9aaf" "1edb72cd3b955d24041131ee099f25fd578278635c5c5b5cc9494f0ec4996188" "4dd1b115bc46c0f998e4526a3b546985ebd35685de09bc4c84297971c822750e" "b2fcb018d261b3e4b8bceb6d02799d280133cf4849d9846362efbfd33815c3f4" "6864961a7f204ca90359d58c71c5804e7dea147ac45b5693df855072889eba5e" "c01970c62c935a132e5d3f53cd0898fa07110299c531d4cf21b15984b28923ef" "316753f5aae7d036ce8d2ffcb23356bdaf3d82e06bca56123b6376677758a7e0" "d898b9e456e234d0876558c341d5206bba2cdef328abd0e81a6e9f4b05c29b01" "aa46a9cb431f777563d5e2b93b57d8e8ce077d24a74c00cd72f89aa2b387865f" "e7ac45850d71fc784e56814cdd275f51dc05234adba0846d3003d25337a060ff" "a041a61c0387c57bb65150f002862ebcfe41135a3e3425268de24200b82d6ec9" "08edc807980093760ef6f3467c5d7c2cefeffbf092a2df40f8fc5ca8b73b920a" default)))
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
 '(safe-local-variable-values
   (quote
    ((eval setenv "ORGANIZATION" "AT&T Services Inc. MIT License. See LICENSE.txt"))))
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

(global-set-key (kbd "s-{") 'previous-buffer)
(global-set-key (kbd "s-}") 'next-buffer)
(global-set-key (kbd "s-<") 'beginning-of-buffer)
(global-set-key (kbd "s->") 'end-of-buffer)
(global-set-key (kbd "C-x g") 'goto-line)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-%") 'query-replace-regexp)
(global-set-key "\C-cm" 'magit-status)
;; (global-set-key "\C-ci" 'ido-goto-symbol) ; or any key you see fit
(global-set-key (kbd "C-c c") 'pbcopy)
(global-set-key (kbd "C-c v") 'pbpaste)
(global-set-key (kbd "C-c x") 'pbcut)
(global-set-key (kbd "M-s") 'multi-occur-in-this-mode)


;; (eval-after-load "cc-mode"
;;   '(define-key c-mode-base-map ";" nil))

(load-theme 'mytheme)

;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(font-lock-constant-face ((t (:foreground "dark red" :weight ultra-bold))))
;;  '(font-lock-doc-face ((t (:foreground "dark gray"))))
;;  '(font-lock-function-name-face ((t (:foreground "gray0" :slant italic :weight bold))))
;;  '(font-lock-keyword-face ((t (:foreground "Purple" :weight bold))))
;;  '(font-lock-type-face ((t (:foreground "#6434A3" :slant italic :weight normal))))
;;  '(font-lock-variable-name-face ((t (:foreground "dark cyan" :weight normal)))))

;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(font-lock-doc-face ((t (:foreground "#8D8D84" :slant italic))))
;;  '(font-lock-function-name-face ((t (:foreground "Black" :weight bold))))
;;  '(font-lock-keyword-face ((t (:foreground "blue3" :weight normal))))
;;  '(font-lock-preprocessor-face ((t (:foreground "#808080" :weight bold))))
;;  '(font-lock-string-face ((t (:foreground "dark slate gray"))))
;;  '(font-lock-type-face ((t (:foreground "sea green" :slant italic :weight normal))))
;;  '(font-lock-variable-name-face ((t (:background "light gray" :foreground "Black" :box (:line-width 1 :color "grey50") :weight normal)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))

(add-hook 'window-setup-hook 'on-after-init)


(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)


(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)



;; (require 'ansi-color)
;; (require 'eshell)
;; (defun eshell-handle-ansi-color ()
;;   (ansi-color-apply-on-region eshell-last-output-start
;; 			      eshell-last-output-end))
;; (add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color)


;(ansi-color-for-comint-mode-on)


;;(add-to-list 'load-path "/path/to/flycheck-clangcheck") ;; if you installed manually
;;(require 'flycheck-clangcheck)


;; ;; enable static analysis
;; (setq flycheck-clangcheck-analyze t)

(require 'flycheck)

(flycheck-define-checker c/c++-clangtidy
  "docstring"
  :command ("clang-check"
	    "-analyze"
	    "-p" "/home/telfer/l/layers/build" 
	    source-inplace)
  :error-patterns
  ((info line-start (file-name) ":" line ":" column
	 ": note: " (message) line-end)
   (warning line-start (file-name) ":" line ":" column
	    ": warning: " (message) line-end)
   (error line-start (file-name) ":" line ":" column
	  ": " (or "fatal error" "error") ": " (message) line-end))
  :modes (c-mode c++-mode))

(add-to-list 'flycheck-checkers 'c/c++-clangtidy)
(provide 'flycheck-clangtidy)

(defun my-select-clangcheck-for-checker ()
  "Select clang-check for flycheck's checker."
  (flycheck-set-checker-executable 'c/c++-clangtidy
				   "/home/telfer/l/layers/build/bin/clang-check")
  (flycheck-select-checker 'c/c++-clangtidy))

(add-hook 'c-mode-hook #'my-select-clangcheck-for-checker)
(add-hook 'c++-mode-hook #'my-select-clangcheck-for-checker)
