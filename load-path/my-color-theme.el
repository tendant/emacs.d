;; (add-to-list 'load-path "~/emacs.d/load-path/color-theme")
;; (add-to-list 'load-path "~/emacs.d/load/path/emacs-color-theme-solarized")

;; (require 'color-theme)
;; (color-theme-initialize)
;; (setq color-theme-is-cumulative t)
;; (setq color-theme-is-global nil)


;; (defun my-color-theme ()
;;   "Color subtheme, created 2008-11-23."
;;   (interactive)
;;   (color-theme-install
;;    '(my-color-theme nil nil
;;                     ;; fringe configuration for color-theme-classic
;;                     ;; (fringe ((t (:background "SkyBlue4"))))
;;                     ;; (fringe ((t (:background nil))))
;;                     (flymake-warnline ((t (:background "LightBlue4"))))
;; ;                    (flymake-errline ((t (:background "IndianRed"))))
;;                     (flymake-errline ((t (:underline "Red"))))
;;                     (ido-first-match ((t (:inherit (quote font-lock-string-face)))))
;;                     (ido-subdir ((t (:inherit (quote font-lock-function-name-face)))))
;;                     (highlight ((t (:underline t))))

;;                     ;; For nxhtml jsp mode. 
;;                     ;; Emacs got crashed once mouse over the
;;                     ;; misspelled word in flyspell-mode, if
;;                     ;; "background" was configured to "". So it is
;;                     ;; changed to `nil'.
;;                     (mumamo-background-chunk-submode ((t (:background nil))))
;;                     (mumamo-background-chunk-major ((t (:background nil))))
;;                     )))

;; (add-hook 'after-make-window-system-frame-hooks
;;           (lambda ()
;;             (color-theme-solarized-dark)
;;             ;; (color-theme-classic)
;;             ;; (my-color-theme)
;;             ))


;; (require 'solarized)

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

(provide 'my-color-theme)

(add-hook 'css-mode-hook 'xah-syntax-color-hex)
(add-hook 'php-mode-hook 'xah-syntax-color-hex)
(add-hook 'html-mode-hook 'xah-syntax-color-hex)
(add-hook 'rjsx-mode-hook 'xah-syntax-color-hex)
(add-hook 'js-mode-hook 'xah-syntax-color-hex)

(message "Loaded my-color-theme.el")
