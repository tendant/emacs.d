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
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)

;; for javascript
(setq js-indent-level 2)
(setq-default js2-basic-offset 2)
;; (setq js-indent-level 4)
;; (add-to-list 'auto-mode-alist '("\\.js.\\'" . js-mode))
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)) ; \' will match empty string only at the end of the string or buffer; \$ will match end of line
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
;; (setq js2-consistent-level-indent-inner-bracket-p t)
;; (setq js2-pretty-multiline-decl-indentation-p t)
;; (put 'narrow-to-region 'disabled nil)
(message "Configured for javascript")

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
