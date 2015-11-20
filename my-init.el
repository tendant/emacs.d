(message "current directory")

(let ((current-dir (file-name-directory load-file-name)))

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
  ;; For emacs 23 only.
  ;; (when
  ;;     (load
  ;;      (expand-file-name (concat current-dir "load-path/package.el")))
  ;;   (package-initialize))
  ;; (add-to-list 'package-archives
  ;;              '("marmalade" . "http://marmalade-repo.org/packages/") t)
  (when (>= emacs-major-version 24)
    (message "initizing package")
    (require 'package)
    (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
    (package-initialize)
    (message "Done initialization"))

;; (mapc
;;  (lambda (package)
;;    (or (package-installed-p package)
;;        (if (y-or-n-p (format "Package %s is missing. Install it? " package)) 
;;            (package-install package))))
;;  '(clojure-mode cider solarized-theme yasnippet w3m magit magit-svn ac-nrepl notmuch graphviz-dot-mode helm clojure-snippets slamhound yaml-mode exec-path-from-shell))

(defvar my-packages '(cider clojure-mode solarized-theme yasnippet w3m magit magit-svn ac-nrepl notmuch graphviz-dot-mode helm helm-ls-git clojure-snippets slamhound yaml-mode exec-path-from-shell js2-mode web-mode flycheck flycheck-clojure swift-mode cider))

(dolist (p my-packages)
  (unless (package-installed-p p)
    (package-install p)))

(if (and
     (< (string-to-number (car (split-string (org-version) "\\."))) 8)
     (y-or-n-p "Package org-mode does not meet requirement. Install it? "))
    (package-install 'org))


  (load (concat current-dir "load-path/my-basic-config.el"))
  (message "Loaded my-basic-config.el")
  (load (concat current-dir "load-path/my-extensions.el"))
  (message "Loaded my-extensions.el"))
