;; Use this file to load all extensions. 
;; Usage: Add below line into ~/.emacs file. 
;; (load "~/.emacs.d/load-path/my-extensions.el")

(setq my-emacs-load-path (concat (file-name-directory (or load-file-name buffer-file-name))))

(message "my-emacs-load-path:")
(message my-emacs-load-path)

(add-to-list 'load-path my-emacs-load-path)

(require 'my-hooks)
 
;; color-themes
(require 'my-color-theme)

(require 'my-font)

(require 'my-backups)

(require 'my-ido)

(require 'my-dired)

;; (require 'unicad nil t)

;;ibus
;; This is not needed. Start emacs using below command.
;; 
;; LC_CTYPE=zh_CN.UTF-8 emacs
;; 
;; python-xlib is required. 
; (add-to-list 'load-path (concat my-emacs-load-path "ibus-el-0.3.2"))
; (require 'ibus) ;; Use "C-\" to toggle input method.
; (add-hook 'after-init-hook 'ibus-mode-on)
; ;; (global-set-key (kbd "M-<SPC>") 'set-mark-command)
; (global-set-key (kbd "S-<SPC>") 'ibus-toggle)

(setq recent-jump-threshold 4)
(setq recent-jump-ring-length 100)
(global-set-key (kbd "C-o") 'recent-jump-jump-backward)
(global-set-key (kbd "M-o") 'recent-jump-jump-forward)
(require 'recent-jump)
(message "Loaded recent-jump")

;; (require 'sdcv-mode)
;; (global-set-key (kbd "C-c d") 'sdcv-search)

;; (require 'my-muse)

;; (require 'my-eshell)

;; (debug-time "jde"
 (require 'my-jde)
;; )

(require 'my-jdibug)

(require 'my-flymake)

;;; DEFERRED, cause nxml-mode is coming with emacs 23.
;; exhume mode is not compatible with ruby-mode, so have to use below
;; configuration as a work around.
;(setq ad-redefinition-action 'discard)
;(load "~/.emacs.d/load-path/nxhtml/autostart.el")
;(setq nxhtml-skip-welcome t)
;; Do not use the jsp-*-mode which are too slow. Just use nxhtml-mode
;; for jsp file.
;(require 'nxhtml-mode)
;(setq auto-mode-alist (cons '(".jsp" . nxhtml-mode) auto-mode-alist)) 
(add-hook 'nxml-mode-hook
          (lambda () (rng-validate-mode 0) )
          t)
(setq rng-nxml-auto-validate-flag nil)


;; Add below line in header of snippet file to prevent new line at the end of file.
;; # -*- mode: ruby; require-final-newline: nil -*-
(debug-time "yasnippet"
(message "Loading yasnippet")
(require 'yasnippet)
(setcdr yas-snippet-dirs (cons (concat my-emacs-load-path "my-snippets") (rest yas-snippet-dirs))) 
(yas/global-mode 1)
;; below hook may indent your snippet region after you finish your
;; snippet. That is, the indent is not done after you expand the
;; snippet, but after you filled $1 and jumped to $0. At that time,
;; all overlays are removed, so there's no chance to get Emacs
;; confused.  
;;;
;; If you don’t like ido (though “flex matching” was made for this
;; sort of thing) then just replace ido-completing-read with
;; completing-read and you’re good to go.
;; (setq yas/window-system-popup-function
;;       (setq yas/text-popup-function
;;             (lambda (templates)
;;               (ido-completing-read "snippet: "
;;                (mapcar (lambda (i)
;;                          (yas/template-name
;;                           (cdr i)))
;;                 templates)))))
(message "Loaded yasnippet")
)

(debug-time "Loaded org-mode"
            (require 'my-org))

;; (require 'my-gnus)

;(load "~/.emacs.d/load-path/bitlbee.el")

(debug-time (require 'my-erc))
(message "Loaded erc-mode")

;; (add-to-list 'load-path "~/.emacs.d/load-path/emacs-svn")
;; (require 'psvn)

(add-to-list 'load-path (concat my-emacs-load-path "magit"))
(require 'magit)
(setq magit-last-seen-setup-instructions "1.4.0")
(require 'magit-svn)

;; git minor mode
;(add-to-list 'load-path "~/.emacs.d/load-path/egg")
;(require 'egg)

;;; customize the csv-mode
(debug-time "csv-mode"
(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
   "Major mode for editing comma-separated value files." t)
(add-hook 'csv-mode-hook 'my-csv-mode-init)
(defun my-csv-mode-init ()
  "Configure the csv mode not to truncate lines."
  (setq truncate-lines t))
(message "Loaded csv-mode"))

;; (require 'webjump)
;; (global-set-key [f4] 'webjump)
;; (setq browse-url-generic-program "firefox")
;; (setq webjump-sites
;;       (append '(
;;                 ("Java 5" .
;;                  [simple-query "www.google.com" "http://www.google.com/search?hl=en&as_sitesearch=http://java.sun.com/j2se/1.5.0/docs/&q=" ""])
;;                 ;; ("Java 6 API" .
;;                 ;; [simple-query "www.google.com" "http://www.google.com/search?hl=en&as_sitesearch=http://java.sun.com/javase/6/docs/api/&q=" ""])
;;                 ("elisp-reference-manual" . 
;;                  "http://www.gnu.org/software/emacs/elisp/html_node/index.html")
;;                 ("elispcode" . "http://www.emacswiki.org/cgi-bin/wiki/Cat%c3%a9gorieCode")
;;                 ("rails" . 
;;                  [simple-query "www.google.com" "http://www.google.com/search?hl=en&as_sitesearch=http://api.rubyonrails.org/&q=" ""])
;;                 ("ruby" . 
;;                  [simple-query "www.google.com" "http://www.google.com/search?hl=en&as_sitesearch=http://www.ruby-doc.org/core/&q=" ""])
;;                 ("wicket" . 
;;                  [simple-query "www.google.com" "http://www.google.com/search?hl=en&as_sitesearch=http://wicket.apache.org/docs/1.4/&q=" ""])
;;                 )
;;               webjump-sample-sites))

;; Xrefactory configuration part ;;
;; some Xrefactory defaults can be set here
;; (if (= emacs-major-version 23)
;;     (progn
;;       (add-to-list 'load-path "~/.emacs.d/load-path/xrefactory-1.6.10-emacs23/emacs")
;;       (add-to-list 'exec-path "~/.emacs.d/load-path/xrefactory-1.6.10-emacs23"))
;;   (progn
;;     (add-to-list 'load-path "~/.emacs.d/load-path/xrefactory-1.6.10/xref/emacs")
;;     (add-to-list 'exec-path "~/.emacs.d/load-path/xrefactory-1.6.10/xref")
;;   ))

;; (if (not win32p)
;;     (progn
;;       (defvar xref-current-project nil) ;; can be also "my_project_name"
;;       (defvar xref-key-binding 'local) ;; can be also 'local or 'none
;;       (load "xrefactory")
;;       ;; end of Xrefactory configuration part ;;
;;       (message "Loaded xrefactory")))

(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)


;;(add-to-list 'load-path  "~/.emacs.d/load-path/predictive")
;;(autoload 'predictive-mode "predictive" "predictive" t)

;(setq load-path (cons "~/.emacs.d/load-path/g-client" load-path))
;(load-library "g")

;; (require 'decompile)

;;rgr: Note : this does not work in Emacs 23.0 - git is included.
;; (add-to-list 'load-path "~/.emacs.d/load-path/git")
;; (require 'vc-git)
;; (when (featurep 'vc-git) (add-to-list 'vc-handled-backends 'git))
;; (require 'git)
(autoload 'git-blame-mode "git-blame"
  "Minor mode for incremental blame for Git." t)
;; (message "Loaded git")

;; Configuration for SQL*PLUS
; for sqlplus
;; (if mac-osx-p
;;     (setenv "ORACLE_HOME" "/Applications/oracle/product/10.2.0.4/client/ohome"))
;; (if linuxp
;;     (progn
;;       (setenv "ORACLE_HOME" "~/.emacs.d/Dev/instantclient_11_1")
;;       (add-to-list 'exec-path "~/.emacs.d/Dev/instantclient_11_1")
;; ;;       (setenv "PATH" (concat (getenv "ORACLE_HOME") ":" (getenv "PATH")))
;; ))
(autoload 'sqlplus "sqlplus" "sqlplus-mode" t)
(add-to-list 'auto-mode-alist '("\\.sqp\\'" . sqlplus-mode))
(setq sqlplus-session-cache-dir "~/.emacs.d/sqlplus-sessions/")
(setq sqlplus-save-passwords  't)
(setq sqlplus-pagesize 100)

;; for e-blog
;(load "~/.emacs.d/load-path/e-blog/e-blog.el")
;(message "Loaded e-blog")

;; for flex 
;(load "~/.emacs.d/load-path/my-flex.el")
;(message "Loaded flex")

;; for lua
;;(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
;;(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
;;(message "Loaded lua")

;; for ruby 
;;(load "~/.emacs.d/load-path/my-ruby.el")
;;(message "Loaded ruby")

;; for scala
;; (load "~/.emacs.d/load-path/my-scala.el")
;; (message "Finished Loading extensions.")


;; for javascript
;; (setq js-indent-level 2)
(setq js-indent-level 4)
(add-to-list 'auto-mode-alist '("\\.js.\\'" . js-mode))
(message "Configured for javascript")
;; (autoload 'js2-mode "js2-mode" nil t)
;; (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
;; (setq js2-consistent-level-indent-inner-bracket-p t)
;; (setq js2-pretty-multiline-decl-indentation-p t)
;; (put 'narrow-to-region 'disabled nil)


;; for gdb
;;; start gdb with "gdb -interp=mi a.out" or gud-gdb.
;; (setq gdb-show-main t)
;; (setq gdb-many-windows t)
;; (setq gud-gdb-command-name "gdb -i=mi")

;;; for markdown
;; (add-to-list 'load-path "~/.emacs.d/load-path/markdown-mode")
;; (autoload 'markdown-mode "markdown-mode.el"
;;   "Major mode for editing Markdown files" t)
;; (setq auto-mode-alist
;;       (cons '("\\.text" . markdown-mode) auto-mode-alist))

;; for anything
;; (require 'my-anything)


;; for gist
;; (add-to-list 'load-path "~/.emacs.d/load-path/gist.el")
;; (require 'gist)

;; html-mode and js-mode
(add-hook 'html-mode-hook
          (lambda ()
            (local-set-key (kbd "<f8>") 'js-mode)
            (set (make-local-variable 'sgml-basic-offset) 4)))
(add-hook 'js-mode-hook
          (lambda ()
            (local-set-key (kbd "<f8>") 'html-mode)))

;; multi-web-mode
(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '( ;;(php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)

;; (require 'my-clojure)

;; octave-mode
(autoload 'octave-mode "octave-mode" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(message "Loading my-mail")
(require 'my-mail-smtp)
(require 'my-mail-mu4e)
(require 'my-ldap)
(message "Loaded my-mail")

;; (message "Loading mustache-mode")
;; (add-to-list 'load-path "~/emacs.d/load-path/mustache-mode.el")
;; ;; (require 'mustache-mode)
;; (autoload 'mustache-mode "mustache-mode" nil t)
;; (setq auto-mode-alist
;;       (cons '("\\.handlebars$" . mustache-mode) auto-mode-alist))
;; (message "Loaded mustache-mode.")

;; (message "Start loading bbdb...")
;; (require 'my-bbdb)
;; (message "Finished loading bbdb.")

(require 'graphviz-dot-mode)

;; (require 'my-eclim)

(defun my-fixup (p1 p2)
  "Prints region starting and ending positions. And take some actions on the region" 
  (interactive "r")
  (message "Region starts: %d, end at: %d" p1 p2)
  (flush-lines "^$" p1 p2)
  (indent-region p1 p2)
  )

(defun utc-time ()
  (interactive)
  (message (format-time-string "%Y-%m-%d %H:%M:%S %Z" (current-time) t)))

(require 'my-helm)
