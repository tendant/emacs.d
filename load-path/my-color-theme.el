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

(load-theme 'dracula t)

(provide 'my-color-theme)
(message "Loaded my-color-theme.el")
