;; html-mode and js-mode
(add-hook 'html-mode-hook
          (lambda ()
            (local-set-key (kbd "<f8>") 'js2-mode)
            (set (make-local-variable 'sgml-basic-offset) 2)))
(add-hook 'js2-mode-hook
          (lambda ()
            (local-set-key (kbd "<f8>") 'mhtml-mode)))

;; multi-web-mode
(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '( ;;(php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "ctp" "phtml" "php4" "php5"))
;; (multi-web-global-mode 1) ; use web-mode for html instead

;;; for html
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.htm\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(setq web-mode-enable-auto-closing t)
(setq web-mode-enable-auto-pairing t)
(setq web-mode-enable-auto-indentation t)
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

(require 'emmet-mode) ; use Ctrl-j
(add-hook 'sgml-mode-hook 'emmet-mode)

;; for javascript
(setq js-indent-level 2)
(setq-default js2-basic-offset 2)
;; (setq js-indent-level 4)
;; (add-to-list 'auto-mode-alist '("\\.js.\\'" . js-mode))
(autoload 'js2-mode "js2-mode" nil t)

(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode)) ; \' will match empty string only at the end of the string or buffer; \$ will match end of line
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))
;; (setq js2-consistent-level-indent-inner-bracket-p t)
;; (setq js2-pretty-multiline-decl-indentation-p t)
;; (put 'narrow-to-region 'disabled nil)
(message "Configured for javascript")

(setq css-indent-offset 2)

(require 'flycheck)

(flycheck-define-checker jsxhint-checker
  "A JSX syntax and style checker based on JSXHint."

  :command ("jsxhint" source)
  :error-patterns
  ((error line-start (1+ nonl) ": line " line ", col " column ", " (message) line-end))
  :modes (web-mode))

(add-hook 'web-mode-hook
          (lambda ()
            (when (equal web-mode-content-type "jsx")
              ;; enable flycheck
              (flycheck-select-checker 'jsxhint-checker)
              (flycheck-mode))))

(provide 'my-web)
