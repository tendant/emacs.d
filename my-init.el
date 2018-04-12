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
                      cider
                      clojure-mode
                      clojure-snippets
                      cnfonts
                      dart-mode
                      dockerfile-mode
                      dracula-theme
                      exec-path-from-shell
                      flycheck
                      flycheck-clojure
                      graphql-mode
                      graphviz-dot-mode
                      helm
                      helm-ls-git
                      ivy
                      js2-mode
                      magit
                      magit-svn
                      notmuch
                      org
                      org-plus-contrib
                      ox-hugo
                      ox-reveal
                      pyim
                      pyim-basedict
                      restclient
                      rust-mode
                      solarized-theme
                      solidity-mode
                      swift-mode
                      w3m
                      web-mode
                      ws-butler
                      yaml-mode
                      yasnippet))

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

(if (and
     (< (string-to-number (car (split-string (org-version) "\\."))) 8)
     (y-or-n-p "Package org-mode does not meet requirement. Install it? "))
    (package-install 'org))


(let ((current-dir (file-name-directory load-file-name)))

  (load (concat current-dir "load-path/my-basic-config.el"))
  (message "Loaded my-basic-config.el")
  (load (concat current-dir "load-path/my-extensions.el"))
  (message "Loaded my-extensions.el"))
