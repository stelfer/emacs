(deftheme dark
  "Created 2016-03-15.")

(custom-theme-set-variables
 'dark
 '(compilation-message-face (quote default))
 '(ansi-color-names-vector (quote (vector "#c5c8c6" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#8abeb7" "#1d1f21")))
 '(ansi-color-faces-vector [default bold shadow italic underline bold bold-italic bold]))

(custom-theme-set-faces
 'dark
 '(bold ((((class color) (min-colors 89)) (:weight bold))))
 '(bold-italic ((((class color) (min-colors 89)) (:slant italic :weight bold))))
 '(underline ((((class color) (min-colors 89)) (:underline t))))
 '(italic ((((class color) (min-colors 89)) (:slant italic))))
 '(font-lock-builtin-face ((((class color) (min-colors 89)) (:foreground "#b294bb"))))
 '(font-lock-comment-delimiter-face ((((class color) (min-colors 89)) (:foreground "#969896" :slant italic))))
 '(font-lock-comment-face ((((class color) (min-colors 89)) (:foreground "#969896" :slant italic))))
 '(font-lock-constant-face ((((class color) (min-colors 89)) (:foreground "#81a2be"))))
 '(font-lock-doc-face ((((class color) (min-colors 89)) (:foreground "#b294bb"))))
 '(font-lock-function-name-face ((((class color) (min-colors 89)) (:foreground "#de935f"))))
 '(font-lock-keyword-face ((((class color) (min-colors 89)) (:foreground "#b5bd68"))))
 '(font-lock-negation-char-face ((((class color) (min-colors 89)) (:foreground "#81a2be"))))
 '(font-lock-preprocessor-face ((((class color) (min-colors 89)) (:foreground "#b294bb"))))
 '(font-lock-regexp-grouping-backslash ((((class color) (min-colors 89)) (:foreground "#f0c674"))))
 '(font-lock-regexp-grouping-construct ((((class color) (min-colors 89)) (:foreground "#b294bb"))))
 '(font-lock-string-face ((((class color) (min-colors 89)) (:foreground "#8abeb7"))))
 '(font-lock-type-face ((((class color) (min-colors 89)) (:foreground "#81a2be"))))
 '(font-lock-variable-name-face ((((class color) (min-colors 89)) (:foreground "#f0c674"))))
 '(font-lock-warning-face ((((class color) (min-colors 89)) (:weight bold :foreground "#cc6666"))))
 '(shadow ((((class color) (min-colors 89)) (:foreground "#969896"))))
 '(success ((((class color) (min-colors 89)) (:foreground "#b5bd68"))))
 '(error ((((class color) (min-colors 89)) (:foreground "#cc6666"))))
 '(warning ((((class color) (min-colors 89)) (:foreground "#de935f"))))
 '(match ((((class color) (min-colors 89)) (:foreground "#81a2be" :background "#1d1f21" :inverse-video t))))
 '(isearch ((((class color) (min-colors 89)) (:foreground "#f0c674" :background "#1d1f21" :inverse-video t))))
 '(lazy-highlight ((((class color) (min-colors 89)) (:foreground "#8abeb7" :background "#1d1f21" :inverse-video t))))
 '(isearch-fail ((((class color) (min-colors 89)) (:background "#1d1f21" :inherit font-lock-warning-face :inverse-video t))))
 '(cursor ((((class color) (min-colors 89)) (:background "#cc6666"))))
 '(fringe ((((class color) (min-colors 89)) (:foreground "#c5c8c6"))))
 '(linum ((((class color) (min-colors 89)) (:foreground "#444444" :italic nil))))
 '(vertical-border ((((class color) (min-colors 89)) (:foreground "#282a2e"))))
 '(border ((((class color) (min-colors 89)) (:background "#373b41" :foreground "#282a2e"))))
 '(highlight ((((class color) (min-colors 89)) (:inverse-video nil :background "#282a2e"))))
 '(mode-line ((((class color) (min-colors 89)) (:foreground nil :background "#373b41" :weight normal :box (:line-width 1 :color "#969896")))))
 '(mode-line-buffer-id ((((class color) (min-colors 89)) (:foreground "#b294bb" :background nil))))
 '(mode-line-inactive ((((class color) (min-colors 89)) (:inherit mode-line :foreground "#969896" :background "#373b41" :weight normal :box (:line-width 1 :color "#373b41")))))
 '(mode-line-emphasis ((((class color) (min-colors 89)) (:foreground "#c5c8c6" :slant italic))))
 '(mode-line-highlight ((((class color) (min-colors 89)) (:foreground "#b294bb" :box nil :weight bold))))
 '(minibuffer-prompt ((((class color) (min-colors 89)) (:foreground "#81a2be"))))
 '(region ((((class color) (min-colors 89)) (:background "#373b41" :inverse-video nil))))
 '(secondary-selection ((((class color) (min-colors 89)) (:background "#282a2e"))))
 '(header-line ((((class color) (min-colors 89)) (:inherit mode-line :foreground "#b294bb" :background nil))))
 '(trailing-whitespace ((((class color) (min-colors 89)) (:background "#de935f" :foreground "#f0c674"))))
 '(show-paren-match ((((class color) (min-colors 89)) (:background "#b294bb" :foreground "#1d1f21"))))
 '(show-paren-mismatch ((((class color) (min-colors 89)) (:background "#cc6666" :foreground "#1d1f21"))))
 '(link ((((class color) (min-colors 89)) (:foreground nil :underline t))))
 '(widget-button ((((class color) (min-colors 89)) (:underline t))))
 '(widget-field ((((class color) (min-colors 89)) (:background "#373b41" :box (:line-width 1 :color "#c5c8c6")))))
 '(compilation-column-number ((((class color) (min-colors 89)) (:foreground "#f0c674"))))
 '(compilation-line-number ((((class color) (min-colors 89)) (:foreground "#f0c674"))))
 '(compilation-mode-line-exit ((((class color) (min-colors 89)) (:foreground "#b5bd68"))))
 '(compilation-mode-line-fail ((((class color) (min-colors 89)) (:foreground "#cc6666"))))
 '(compilation-mode-line-run ((((class color) (min-colors 89)) (:foreground "#81a2be"))))
 '(helm-buffer-saved-out ((((class color) (min-colors 89)) (:inherit warning))))
 '(helm-buffer-size ((((class color) (min-colors 89)) (:foreground "#f0c674"))))
 '(helm-buffer-not-saved ((((class color) (min-colors 89)) (:foreground "#de935f"))))
 '(helm-buffer-process ((((class color) (min-colors 89)) (:foreground "#8abeb7"))))
 '(helm-buffer-directory ((((class color) (min-colors 89)) (:foreground "#81a2be"))))
 '(helm-ff-directory ((((class color) (min-colors 89)) (:foreground "#8abeb7"))))
 '(helm-candidate-number ((((class color) (min-colors 89)) (:foreground "#cc6666"))))
 '(helm-match ((((class color) (min-colors 89)) (:inherit match))))
 '(helm-selection ((((class color) (min-colors 89)) (:inherit highlight))))
 '(helm-separator ((((class color) (min-colors 89)) (:foreground "#b294bb"))))
 '(helm-source-header ((((class color) (min-colors 89)) (:weight bold :foreground "#de935f"))))
 '(company-preview ((((class color) (min-colors 89)) (:foreground "#969896" :background "#373b41"))))
 '(company-preview-common ((((class color) (min-colors 89)) (:inherit company-preview :foreground "#cc6666"))))
 '(company-preview-search ((((class color) (min-colors 89)) (:inherit company-preview :foreground "#81a2be"))))
 '(company-tooltip ((((class color) (min-colors 89)) (:background "#373b41"))))
 '(company-tooltip-selection ((((class color) (min-colors 89)) (:background "#282a2e"))))
 '(company-tooltip-common ((((class color) (min-colors 89)) (:inherit company-tooltip :foreground "#cc6666"))))
 '(company-tooltip-common-selection ((((class color) (min-colors 89)) (:inherit company-tooltip-selection :foreground "#cc6666"))))
 '(company-tooltip-search ((((class color) (min-colors 89)) (:inherit company-tooltip :foreground "#81a2be"))))
 '(company-tooltip-annotation ((((class color) (min-colors 89)) (:inherit company-tooltip :foreground "#b5bd68"))))
 '(company-scrollbar-bg ((((class color) (min-colors 89)) (:inherit (quote company-tooltip) :background "#282a2e"))))
 '(company-scrollbar-fg ((((class color) (min-colors 89)) (:background "#373b41"))))
 '(company-echo-common ((((class color) (min-colors 89)) (:inherit company-echo :foreground "#cc6666"))))
 '(custom-variable-tag ((((class color) (min-colors 89)) (:foreground "#81a2be"))))
 '(custom-group-tag ((((class color) (min-colors 89)) (:foreground "#81a2be"))))
 '(custom-state ((((class color) (min-colors 89)) (:foreground "#b5bd68"))))
 '(default ((((class color) (min-colors 89)) (:foreground "#c5c8c6" :background "#1d1f21")))))

(provide-theme 'dark)
