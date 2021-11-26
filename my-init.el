(message "current directory")

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
;; (add-to-list 'package-archives
;;              '("melpa" . "https://melpa.org/packages/"))

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("org" . "http://orgmode.org/elpa/")
	("melpa" . "http://melpa.org/packages/")
	;; ("melpa-stable" . "http://stable.melpa.org/packages/")
	))

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  ;; ((and )dd-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
  (add-to-list 'package-archives
               '("melpa-stable" . "https://stable.melpa.org/packages/") t))
;; (package-initialize) ;; You might already have this line
  

(defvar my-packages '(ac-cider
                      org-chef
                      cider
                      clojure-mode
                      clojure-snippets
                      cnfonts
                      company
                      company-ansible
                      company-web
                      ;; company-lsp
                      counsel
                      dart-mode
                      default-text-scale
                      dockerfile-mode
                      dracula-theme
                      edwina
                      ein
                      ejc-sql
                      ;; el-get
                      exec-path-from-shell
                      flycheck
                      flycheck-clojure
                      flycheck-rust
                      go-mode
                      graphql-mode
                      graphviz-dot-mode
                      helm
                      helm-ls-git
                      ivy
                      js2-mode
                      rjsx-mode
                      ledger-mode
                      lsp-mode
                      lsp-ui
                      magit
                      magit-svn
                      markdown-mode
                      mu4e-alert
                      notmuch
                      nord-theme
                      org
                      org-gcal
                      org-plus-contrib
                      org-roam
                      ox-hugo
                      ox-reveal
                      plantuml-mode
                      pyim
                      pyim-basedict
                      restclient
                      rego-mode
                      rg
                      rust-mode
                      ;; rust-cargo
                      flycheck-rust
                      skeletor
                      sis
                      smartparens
                      smtpmail-multi
                      solarized-theme
                      solidity-mode
                      swift-mode
                      use-package
                      vterm
                      w3m
                      web-mode
                      ws-butler
                      yaml-mode
                      yasnippet
                      yasnippet-snippets))

(defvar my-emacs26-packages '(posframe))

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

(setq n 0)                                  ; set n as 0
(dolist (pkg my-packages)               ; for each pkg in list
  (unless (or                               ; unless
           (package-installed-p pkg)        ; pkg is installed or
           (assoc pkg                       ; pkg is in the archive list
                  package-archive-contents))
    (setq n (+ n 1))))                      ; add one to n
(when (> n 0)                               ; if n > 0,
  (package-refresh-contents))               ; refresh packages

(dolist (p my-packages)
  (unless (package-installed-p p)
    (package-install p)))

(if (not (version< emacs-version "26"))
    (dolist (p my-emacs26-packages)
      (unless (package-installed-p p)
	(package-install p))))


;;; Add el-get
;; (add-to-list 'load-path "~/.emacs.d/el-get/el-get")

;; (unless (require 'el-get nil 'noerror)
;;   (require 'package)
;;   (add-to-list 'package-archives
;;                '("melpa" . "http://melpa.org/packages/"))
;;   (package-refresh-contents)
;;   (package-initialize)
;;   (package-install 'el-get)
;;   (require 'el-get))

;; (add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

;; (el-get-bundle ox-hugo
;;                :url "https://github.com/your-nick/ox-hugo.git"
;;                :checkout "master"
;;                :feature ox-hugo)

;; (el-get 'sync)


(if (and
     (< (string-to-number (car (split-string (org-version) "\\."))) 8)
     (y-or-n-p "Package org-mode does not meet requirement. Install it? "))
    (package-install 'org))


(let ((current-dir (file-name-directory load-file-name)))

  ;; (defun load-config(conf)
  ;;   "Load the configuration in literate 'org-mode' elisp."
  ;;   (interactive)
  ;;   (org-babel-load-file (concat current-dir conf)))

  ;; (load-config "load-path/basic-conf.org")

  (load (concat current-dir "load-path/my-basic-config.el"))
  (message "Loaded my-basic-config.el")
  (load (concat current-dir "load-path/my-extensions.el"))
  (message "Loaded my-extensions.el"))
