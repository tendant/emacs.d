;; from: http://riddell.us/tutorial/slime_swank/slime_swank.html
;; clojure-mode
;; (add-to-list 'load-path "~/emacs.d/load-path/clojure-mode")
;; (add-to-list 'load-path "~/emacs.d/load-path/nrepl.el")
;; (add-to-list 'load-path "~/emacs.d/load-path/dash.el")
;; (add-to-list 'load-path "~/emacs.d/load-path/pkg-info.el")
;; (add-to-list 'load-path "~/emacs.d/load-path/s.el")

(require 'cider)

;; (add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)

;; Enable eldoc in Clojure buffers:
(add-hook 'cider-mode-hook #'eldoc-mode)

;; (setq nrepl-hide-special-buffers t)

;; To auto-select the error buffer when it's displayed:
(setq cider-auto-select-error-buffer t)

(setq cider-repl-pop-to-buffer-on-connect t)

;; The REPL buffer name can also display the port on which the nREPL
;; server is running. Buffer name will look like cider
;; project-name:port.
(setq nrepl-buffer-name-show-port t)

;; Make C-c C-z switch to the CIDER REPL buffer in the current window:
;; (setq cider-repl-display-in-current-window t)


(require 'paredit)
(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code."
  t)


(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'subword-mode)
(add-hook 'clojure-mode-hook 'cider-mode)

(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'subword-mode)
(add-hook 'cider-repl-mode-hook 'cider-mode)

(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'subword-mode)

;; added for lazytest
;; (eval-after-load 'clojure-mode
;;   '(define-clojure-indent
;;      (describe 'defun)
;;      (testing 'defun)
;;      (given 'defun)
;;      (using 'defun)
;;      (with 'defun)
;;      (it 'defun)
;;      (do-it 'defun)))

(setq slime-net-coding-system (quote utf-8-unix))

(add-hook 'clojure-mode-hook
          (lambda ()
            (local-set-key (kbd "<f5>") 'cider-eval-buffer)))

;; use slime's C-c C-k before switching to the REPL, for
;; slime-compile-and-load-file. It will prompt you to save the file if
;; you haven't already. When it's done, the things which you've
;; redefined should be available at the SLIME REPL in the new
;; versions. Then you should use C-c C-z to bring up the REPL (close
;; it with C-x 0 when you don't need it anymore)

(setq auto-mode-alist
      (cons '("\\.dtm$" . clojure-mode) auto-mode-alist))

(defun cider-namespace-refresh ()
  (interactive)
  (cider-interactive-eval
   "(require 'clojure.tools.namespace.repl)
    (clojure.tools.namespace.repl/refresh)"))

;; Install clojure-mode and slime-repl using package.el
(provide 'my-clojure)
(message "Loaded my-clojure")
