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
  (require 'package) ;; You might already have this line
  (add-to-list 'package-archives
	       '("melpa" . "https://melpa.org/packages/"))
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    ;; (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
    (add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
    )
  (package-initialize) ;; You might already have this line
  

(defvar my-packages '(cider clojure-mode solarized-theme dracula-theme yasnippet w3m magit magit-svn notmuch graphviz-dot-mode helm helm-ls-git clojure-snippets yaml-mode exec-path-from-shell js2-mode web-mode flycheck flycheck-clojure swift-mode ac-cider ox-reveal chinese-fonts-setup))

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
