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
;; (require 'my-jde)
;; )

;; (require 'my-jdibug)

;; (require 'my-flymake)

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

(require 'magit)
;; (setq magit-last-seen-setup-instructions "1.4.0") ; delete me
;; (setq magit-refresh-status-buffer nil)
(setq magit-auto-revert-mode nil)
;; (setq magit-revert-buffers nil)
(setq auto-revert-buffer-list-filter
      'magit-auto-revert-repository-buffers-p)
(setq vc-handled-backends (delq 'Git vc-handled-backends))
(global-set-key [f5] 'magit-status)
(setq magit-section-initial-visibility-alist '((stashes . show)
                                               (unstaged . show)
                                               (unpushed . show)
                                               (recent . show)))
(setq magit-diff-refine-hunk 'all)
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

;; Emacs SQL client uses Clojure JDBC.
(require 'ejc-sql)
;; Enable autocomplete for ejc-sql minor mode:
(add-hook 'ejc-sql-minor-mode-hook
          (lambda ()
            (auto-complete-mode t)
            (ejc-ac-setup)))
;; Enable ElDoc for ejc-sql minor mode:
(add-hook 'ejc-sql-minor-mode-hook
          (lambda ()
            (ejc-eldoc-setup)))

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
;; use command-line to preview: $ flavor.rb file | bcat
;; (setq markdown-command "~/bin/flavor.rb")

;; for anything
;; (require 'my-anything)


;; for gist
;; (add-to-list 'load-path "~/.emacs.d/load-path/gist.el")
;; (require 'gist)

(require 'my-web)


(require 'my-clojure)

;; octave-mode
(autoload 'octave-mode "octave-mode" nil t)
(setq auto-mode-alist
      (cons '("\\.m\\'" . octave-mode) auto-mode-alist))

;; (message "Loading my-mail")
;; (require 'my-mail-smtp)
(require 'my-mail-mu4e)
(require 'my-mail-smtp-multi)
;; (require 'my-ldap)
;; (message "Loaded my-mail")

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

(require 'my-reveal)

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

(defun yank-append-lines (&optional without-space)
  "Yank each line of the current kill at the end of each subsequent line.

A space will be added between each line unless WITHOUT-SPACE which can
be passed in via a prefix arg."
  (interactive "P")
  (save-excursion
    (let ((lines (split-string (current-kill 0) "\n")))
      (dolist (line lines)
        (goto-char (line-end-position))
        (unless without-space
          (just-one-space))
        (insert line)
        (unless (zerop (forward-line))
          (insert "\n"))))))

(require 'my-helm)
;; configuration for ivy, swiper and counsel
(ivy-mode 1)
(setq ivy-use-selectable-prompt t) ; make the prompt line selectable
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)
;; (global-set-key "\C-r" 'swiper-isearch-backward)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
;; (global-set-key (kbd "M-x") 'counsel-M-x)
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)

;; https://github.com/abo-abo/swiper/issues/1172#issuecomment-633148859
(defun swiper-C-r (&optional arg)
  "Move cursor vertically down ARG candidates.
If the input is empty, select the previous history element instead."
  (interactive "p")
  (if (string= ivy-text "")
      (ivy-next-history-element 1)
    (ivy-previous-line arg)))

;; (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
;; (define-key minibuffer-local-map (kbd "C-r") 'swiper-C-r)

(require 'my-buffers)

(require 'my-im)

(if (not androidp)
    (require 'my-font))

;; trim white space in changed area during save except for final new line
(ws-butler-global-mode 1)

;; restclient
(require 'restclient)
(defvar my-restclient-token nil)
(defun my-restclient-hook ()
  "Update token from a request."
  (message "Update token and id from response.")
  (save-excursion
    (save-match-data
      ;; update regexp to extract required data
      (when (re-search-forward "\"token\":\"\\(.*?\\)\"" nil t)
        (setq my-restclient-token (match-string 1)))
      (if (re-search-forward "\"id\":\"\\(.*?\\)\"" nil t)
        (setq my-restclient-id (match-string 1))
        (setq my-restclient-id "NO-ID")))))

(add-hook 'restclient-response-received-hook #'my-restclient-hook)

;; dart-mode
(setq dart-enable-analysis-server t)
(add-hook 'dart-mode-hook 'flycheck-mode)


;; rust-mode
(add-hook 'rust-mode-hook 'flycheck-mode)
(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;; plantuml-mode
(setq plantuml-jar-path "~/bin/plantuml.jar")
(setq org-plantuml-jar-path plantuml-jar-path)
;; Enable plantuml-mode for PlantUML files
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
;; plantuml Integration with org-mode
(add-to-list
  'org-src-lang-modes '("plantuml" . plantuml))
;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . nil)
   (plantuml . t)
   (emacs-lisp . t)))

;; ledger-mode
(setq ledger-init-file-name "~/workspace/linux-conf/_ledgerrc")
(add-hook 'ledger-mode-hook
               (lambda ()
                 (setq-local tab-always-indent 'complete)
                 (setq-local completion-cycle-threshold t)
                 (setq-local ledger-complete-in-steps t)))
(require 'ledger-complete)

;; skeletor
;; (require 'my-skeletor)

;; exec-path-from-shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; golang go-mode
(add-hook 'go-mode-hook
          (lambda ()
            ;; golang prefer to use gofmt, instead of customized style
            (add-hook 'before-save-hook 'gofmt-before-save)
            ;; (setq-default)
            (setq tab-width 4)
            ;; (setq standard-indent 2)
            ;; (setq indent-tabs-mode nil)
            ))

(require 'valign)

(require 'my-golang)


;;; configure smart-input-source, require 'smart-input-source
;; (when mac-osx-p
;;   ;; set the english input source
;;   (setq smart-input-source-english
;;         "com.apple.keylayout.US")
;;   ;; set the default other language input source for all buffer
;;   (setq-default smart-input-source-other
;;                 "com.apple.inputmethod.SCIM.ITABC")

;;   ;; enable the /respect/ mode
;;   (smart-input-source-global-respect-mode t)

;;   ;; enable the /follow context/ and /inline english/ mode for all buffers
;;   (smart-input-source-global-follow-context-mode t)
;;   (smart-input-source-global-inline-english-mode t)

;;   ;; enable the /follow context/ and /inline english/ mode for specific buffers
;;   ;; :hook
;;   ;; (((text-mode prog-mode) . smart-input-source-follow-context-mode)
;;   ;;  ((text-mode prog-mode) . smart-input-source-inline-english-mode))
;;   )


(defun find-first-non-ascii-char ()
  "Find the first non-ascii character from point onwards."
  (interactive)
  (let (point)
    (save-excursion
      (setq point
            (catch 'non-ascii
              (while (not (eobp))
                (or (eq (char-charset (following-char))
                        'ascii)
                    (throw 'non-ascii (point)))
                (forward-char 1)))))
    (if point
        (goto-char point)
        (message "No non-ascii characters."))))

;;;;; vterm
(setq vterm-buffer-name-string "vterm %s")
;;; zsh
;; autoload -U add-zsh-hook
;; add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%m:%2~\a"}

;;; bash
;; PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}:${PWD}\007"'

;; org-roam
;;; config org-roam
;; (setq org-roam-directory "~/.emacs.d/org-roam")
;; (add-hook 'after-init-hook 'org-roam-mode)
(require 'sqlite3)
(use-package org-roam
      :ensure t
      :init
      (setq org-roam-v2-ack t)
      (setq org-roam-database-connector 'libsqlite3)
      :custom
      (org-roam-directory (file-truename "~/.emacs.d/org-roam"))
      :bind (("C-c n l" . org-roam-buffer-toggle)
             ("C-c n f" . org-roam-node-find)
             ("C-c n g" . org-roam-graph)
             ("C-c n i" . org-roam-node-insert)
             ("C-c n c" . org-roam-capture)
             ;; Dailies
             ("C-c n j" . org-roam-dailies-capture-today))
      :config
      (org-roam-setup))

;; Projectile
(projectile-mode +1)
;; Recommended keymap prefix on macOS
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)