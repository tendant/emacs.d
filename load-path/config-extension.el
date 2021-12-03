(message "Begin loading config-extension.org")

(setq my-emacs-load-path (concat (file-name-directory (or load-file-name buffer-file-name))))

(message "my-emacs-load-path:")
(message my-emacs-load-path)

(add-to-list 'load-path my-emacs-load-path)

;; (load-theme 'solarized-dark t)
(load-theme 'nord t)
(setq nord-comment-brightness 20)
;; Use brighter color for comments
(set-face-attribute 'font-lock-comment-face nil
                    :foreground "#81A1C1") ; nord9
(set-face-attribute 'vertical-border nil
                    :foreground "#EBCB8B") ; nord13

;; (load-theme 'dracula t)

(defun xah-syntax-color-hex ()
  "Syntax color text of the form 「#ff1100」 and 「#abc」 in current buffer.
URL `http://ergoemacs.org/emacs/emacs_CSS_colors.html'
Version 2017-03-12"
  (interactive)
  (font-lock-add-keywords
   nil
   '(("#[[:xdigit:]]\\{3\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background
                      (let* (
                             (ms (match-string-no-properties 0))
                             (r (substring ms 1 2))
                             (g (substring ms 2 3))
                             (b (substring ms 3 4)))
                        (concat "#" r r g g b b))))))
     ("#[[:xdigit:]]\\{6\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background (match-string-no-properties 0)))))))
  (font-lock-flush))

(add-hook 'css-mode-hook 'xah-syntax-color-hex)
(add-hook 'php-mode-hook 'xah-syntax-color-hex)
(add-hook 'html-mode-hook 'xah-syntax-color-hex)
(add-hook 'rjsx-mode-hook 'xah-syntax-color-hex)
(add-hook 'js-mode-hook 'xah-syntax-color-hex)

(message "Loaded my-color-theme.el")


