;;
;; 
;;
;;

(menu-bar-mode -1) ;; keep the bar from showing up ever

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

;; global
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
(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

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
		    ("\\<\\(xstring\\|xchar\\)\\>" . font-lock-type-face)
		    ))
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
	(let ((yas-indent-line)))
        (yas-expand-snippet snippet (point-min) (point-max) nil))))






      
(defun rtags-load-database (dir)
  (rtags-call-rc "-J" dir))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(compilation-message-face (quote default))
 '(custom-enabled-themes (quote (mytheme)))
 '(custom-safe-themes
   (quote
    ("8af52c87c130fa6fd280bd9ce6a6712f41af483d2ba5503f4e039b2f9249208b" "3ac266781ee0ac3aa74a6913a1506924cad669f111564507249f0ffa7c5e4b53" "2cb880200e4c59824c3163b46c4c3590b8932cffc8c59b7596f034819ae0af68" "32840b5ff3c59a31f0845602a26e9a47c27d48bfed86b4a09cdbaf3a25167cf4" "43ae3b379a90f65de356964d8e9ec66b5b8ef0460f7c870ccb3f402b851ad905" "7d98d7e7bcdbe9ae8fa4c2200ced1a1352f61c1173b58ed0c8e2276ec4026ef8" "0ec59d997a305e938d9ec8f63263a8fc12e17990aafc36ff3aff9bc5c5a202f0" "7d3e681736e66cd2f9144042ffea45f956385213618fbdf1338324be88d591ec" "7f77f8f41a0ef4359da7b20b3297ab4684c278fd9d7ca5344c6c14c04753ae47" "5390541773eb2bf021f20d9470ce586bee4d7076423f3894e966d5dc7f5e173c" "b7cfc81c1b0e3c37a5adc850c0b2f9d25d6088462c6f08ce2fadb07d299e1ad8" "be75a811e29fbe42de4c49918b999b1e1a2e671e834e7e07bb7f383d6c8cd6b3" "1bdc1013720f16b5692166a53e0333dce14487247a3ade199e5978d39602b1d3" "556bb25f81b735f98e9a21e567cc4ac8b3131c9335d88a72facab4fee6851966" "9a2d2ce7ae4ef225491a308ad6ef600901fbbdf72484dc1edb99c06c3a3aa0aa" "9344059fa6a6f0ab3d07d2fc1c224939b9fd6f5948c30e075b08fb29f6025177" "b5870a5f958aab769848dbafd34dff036340ecf73b0ed6d83dffdf8792a28c7f" "ab274123289f47d4fda6b5f2047d291b9e14f5ce486fe239ea3bd86b391f927f" "a1b2c58f9d1e00217fe9dda8f03c809679555739b53c396f6d2ca0a02bbcf3a3" "7d7815c2bed67d0df1ccaf09187107bce6b11b0c9e8785ca63ac5a765f50b1e6" "a788980c894f9f24e78e8931fe641ae8adc2970fad0c504068552556d25630bc" "4bd7e93b2622780c5f54e877c48b2b53c04f5ec7ffa8ed4fa49601b258a5f943" "cf8c0cdde21ef837f124058d3524d0108477a44b333cffdacc5b7d012a7378a2" "f3cecaf2b776d899d9368b4f72ec73c77be5dc823c44795e354723b23745de37" "8d70db8645040d8197827c2e9767ec5c808924d859069034a51a8ab9dc917517" "4b0f166c6a59ebc067e37b158da6584af03cbc600f72140caadedf6753cd9d62" "328803e844faf04d74b9f4d5032da0e3c127009892d063d50ede842b81cb6f83" "6c035daa6a8f157ef102c54657d5560b34169468380e32ffa10af5c8c0455632" "54751187f29a2990b6c265eb430fbc7712c5a35204974c496f3ea1a6f262fd87" "25a18aaf83c1aca4a2399479d6fdf35e792938abeaac5a35e961f7e77e90bef6" "e57b2357dbd1f56586feac1a572e42bdeb0d04cd8db850cc97d692f5162f6ba1" "3c561ad7ceee37cae2d90e78fbd54cfbcfca5c679d364225742dd0254d7a4f2e" "b5e959ae00e373a436d334b7ba60403302924f8581ea78765a820ec905d54f9a" "c162222291f3cfcca713f56cc6ccd62040b70ec74e18cbcafc0f8758bc50f9fb" "d8705186597d49ba6e151b0c23ce5bf96f927950e70048320aeff19eff6f2220" "1fb9f8441bcc125894b09f5c79ce0419fecac6c3a98521218dc9b8a37f57a298" "4caff53178aece5c8856419af357ed06b8a16ffbf364e954490e3c9e5524240c" "f75a950ca53d04fefd5a19efef03088304a1c9736a0d182d740847e58f81a685" "003ed5f7be6cfdba623b2f276322e3099df986e399bdb7da8cf8db27dd350231" "b5e939d5e92cd618b3c32ee286a794a98afe4895deeb0831073e746af6480f43" "633b1f73837063e8792a7c4dab135fe0fb48eb8847875833aae223bd00ed0aa5" "20792ad267e8d51a23cdca221afa86a6cf74d8c6259c855dde3e4339b8a64249" "5bede4cc9000ebf869ca6db7403feb8f4cfbe8ae64d82ebb8fcf88c92884fbfa" "6963362f4448dd7b7c0d401edb0c59200f027147e6830aa995b3826ff1bfeac8" "5d5f9adbd5617eca9aa138238bc362188899ef2411851856c6c649a6c2c6df2e" "6bc8b2af7f6837f4e81ba386e9a2f0445f6a76669bcff83d6c74bb3d1f4257e9" "9229d58bee72fb79d7c78c810fc22dbecd1b21cb2ea9a6840f343f33b9893da5" "8abee8a14e028101f90a2d314f1b03bed1cde7fd3f1eb945ada6ffc15b1d7d65" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "e80932ca56b0f109f8545576531d3fc79487ca35a9a9693b62bf30d6d08c9aaf" "1edb72cd3b955d24041131ee099f25fd578278635c5c5b5cc9494f0ec4996188" "4dd1b115bc46c0f998e4526a3b546985ebd35685de09bc4c84297971c822750e" "b2fcb018d261b3e4b8bceb6d02799d280133cf4849d9846362efbfd33815c3f4" "6864961a7f204ca90359d58c71c5804e7dea147ac45b5693df855072889eba5e" "c01970c62c935a132e5d3f53cd0898fa07110299c531d4cf21b15984b28923ef" "316753f5aae7d036ce8d2ffcb23356bdaf3d82e06bca56123b6376677758a7e0" "d898b9e456e234d0876558c341d5206bba2cdef328abd0e81a6e9f4b05c29b01" "aa46a9cb431f777563d5e2b93b57d8e8ce077d24a74c00cd72f89aa2b387865f" "e7ac45850d71fc784e56814cdd275f51dc05234adba0846d3003d25337a060ff" "a041a61c0387c57bb65150f002862ebcfe41135a3e3425268de24200b82d6ec9" "08edc807980093760ef6f3467c5d7c2cefeffbf092a2df40f8fc5ca8b73b920a" default)))
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
 '(safe-local-variable-values
   (quote
    ((eval progn
	   (unless
	       (assoc "layers-c-style" c-style-alist)
	     (load
	      (concat "/home/telfer/l/foo/" ".layers-c-style.el"))
	     (c-add-style "layers-c-style" layers-c-style))
	   (c-set-style "layers-c-style")
	   (unless rtags-path
	     (setq rtags-path
		   (concat
		    (projectile-project-p)
		    "build/bin"))
	     (setq rtags-process-flags "-d /home/telfer/l/foo/build/.rtags"))
	   (rtags-start-process-unless-running))
     (eval setenv "ORGANIZATION" "AT&T Services Inc. - MIT License. See LICENSE.txt")
     (eval progn
	   (unless
	       (assoc "layers-style" c-style-alist)
	     (load
	      (concat "~/l/layers/" "tools/layers-style.el"))
	     (c-add-style "layers-style" layers-style))
	   (c-set-style "layers-style")
	   (unless rtags-path
	     (setq rtags-path
		   (concat
		    (projectile-project-p)
		    "build/bin")))
	   (rtags-start-process-unless-running))
     (eval progn
	   (unless
	       (assoc "layers-style" c-style-alist)
	     (load
	      (concat "~/l/layers/" "tools/layers-style.el"))
	     (c-add-style "layers-style" layers-style))
	   (c-set-style "layers-style")
	   (setq rtags-path
		 (concat
		  (projectile-project-p)
		  "build/bin"))
	   (rtags-start-process-unless-running))
     (eval progn
	   (unless
	       (assoc "layers-style" c-style-alist)
	     (load
	      (concat "~/l/layers/" "tools/layers-style.el"))
	     (c-add-style "layers-style" layers-style)
	     (c-set-style "layers-style"))
	   (setq rtags-path
		 (concat
		  (projectile-project-p)
		  "build/bin"))
	   (rtags-start-process-unless-running))
     (eval progn
	   (load
	    (concat "~/l/layers/" "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (c-set-style "layers-style")
	   (setq rtags-path
		 (concat
		  (projectile-project-p)
		  "build/bin"))
	   (rtags-start-process-unless-running))
     (eval progn
	   (load
	    (concat "~/l/layers/" "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (c-set-style "layers-style")
	   (eval setq rtags-path
		 (concat
		  (projectile-project-p)
		  "build/bin"))
	   (eval rtags-start-process-unless-running))
     (eval progn
	   (load
	    (concat "~/l/layers/" "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (c-set-style "layers-style")
	   (eval setq rtags-path
		 (concat
		  (projectile-project-p)
		  "build/bin"))
	   (rtags-start-process-unless-running))
     (eval progn
	   (load
	    (concat "~/l/layers/" "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (c-set-style "layers-style"))
     (eval progn
	   (load
	    (concat "~/l/layers/" "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (setq c-set-style "layers-style"))
     (eval progn
	   (print "HEHEHEHE")
	   (load
	    (concat "~/l/layers/" "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (setq c-default-style "layers-style"))
     (eval progn
	   (load
	    (concat "~/l/layers/" "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (setq c-default-style "layers-style"))
     (eval progn
	   (print "HI"))
     (eval progn
	   (print "HI")
	   (load
	    (concat "~/l/layers/" "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (setq project-style "layers-style"))
     (eval progn
	   (print "HI")
	   (load
	    (concat "~/l/layers/" "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (setq project-style
		 (quote layers-style)))
     (eval progn
	   (print "HI")
	   (load
	    (concat "~/l/layers/" "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (setq c-default-style "layers-style"))
     (eval progn
	   (print "HI")
	   (load
	    (concat default-directory "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (setq c-default-style "layers-style"))
     (eval progn
	   (print "HI")
	   (load
	    (concat default-directory "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (c-set-style "layers-style"))
     (eval progn
	   (print "HI")
	   (load
	    (concat
	     (quote default-directory)
	     "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (c-set-style "layers-style"))
     (eval progn
	   (print "HI")
	   (load
	    (concatenate
	     (quote default-directory)
	     "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (c-set-style "layers-style"))
     (eval progn
	   (print "HI")
	   (load
	    (concatenate default-directory "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (c-set-style "layers-style"))
     (eval progn
	   (print "HI")
	   (load
	    (concatenate
	     (default-directory)
	     "tools/layers-style.el"))
	   (c-add-style "layers-style" layers-style)
	   (c-set-style "layers-style"))
     (eval progn
	   (print "HI")
	   (load "tools/layers-style.el")
	   (c-add-style "layers-style" layers-style)
	   (c-set-style "layers-style"))
     (eval lambda nil
	   (print "HI")
	   (load "tools/layers-style.el")
	   (c-add-style "layers-style" layers-style)
	   (c-set-style "layers-style"))
     (eval lambda nil
	   (load "tools/layers-style.el")
	   (c-add-style "layers-style" layers-style)
	   (c-set-style "layers-style"))
     (eval setq rtags-compile-db "build/compile_commands.json")
     (rtags-compile-db quote
		       ("build/compile_commands.json"))
     (eval setq rtags-path
	   (concat
	    (projectile-project-p)
	    "build/bin"))
     (eval setq rtags-path
	   (quote
	    (concat
	     (projectile-project-p)
	     "build/bin")))
     (eval setq rtags-path
	   (append rtags-path
		   (quote
		    (concat
		     (projectile-project-p)
		     "build/bin"))))
     (eval setenv "PATH"
	   (concat
	    (getenv "PATH")
	    ":"
	    (projectile-project-p)
	    "build/bin"))
     (eval setq exec-path
	   (append exec-path
		   (quote
		    (concat
		     (projectile-project-p)
		     "build/bin"))))
     (eval setq exec-path
	   (append exec-path
		   (concat
		    (projectile-project-p)
		    "build/bin")))
     (eval setq exec-path
	   (append exec-path
		   (concat ": "
			   (projectile-project-p)
			   "build/bin")))
     (eval setenv "PATH"
	   (concat
	    (getenv "PATH")
	    ": "
	    (projectile-project-p)
	    "build/bin"))
     (eval setenv "ORGANIZATION" "AT&T Services Inc. MIT License. See LICENSE.txt"))))
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

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
