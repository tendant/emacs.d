(setq skeletor-user-directory "~/emacs.d/load-path/skeletor")

(skeletor-define-template "ox-reveal-presentation"
  :title "OX Reveal Presentation"
  ;; :default-license (rx bol "DWTFYW")
  :default-license (rx bol "gpl")
  :no-eval-embedded-elisp? t
  :skip-file ".*js$"
  :no-license? t)

(add-to-list 'skeletor-global-substitutions
             (cons "__TIME__" (lambda () (format-time-string "%Y-%m-%d"))))

(provide 'my-skeletor)