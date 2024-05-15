(message "Begin loading config-extension.org")

;; This is only needed once, near the top of the file
  ;; (eval-when-compile
  ;;   ;; Following line is not needed if use-package.el is in ~/.emacs.d
  ;;   ;; (add-to-list 'load-path "<path where use-package is installed>")
  ;;   (require 'use-package))
(unless (package-installed-p 'use-package)
  ;; only fetch the archives if you don't have use-package installed
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(when (memq window-system '(mac ns x))
  (use-package exec-path-from-shell
    :ensure t
    :init
    (exec-path-from-shell-initialize)))

(setq my-emacs-load-path (concat (file-name-directory (or load-file-name buffer-file-name))))

(message "my-emacs-load-path:")
(message my-emacs-load-path)

(add-to-list 'load-path my-emacs-load-path)

(use-package company
  :ensure t
  :init
  ;; https://github.com/clojure-emacs/cider/issues/2009
  (setq company-dabbrev-char-regexp "\sw\|-")

  ;; make company-mode to be compatible with TAB
  ;; https://github.com/company-mode/company-mode/issues/94#issuecomment-365701801
  (global-set-key (kbd "TAB") #'company-indent-or-complete-common)
  ;; Use company-mode in all buffers
  (add-hook 'after-init-hook 'global-company-mode)
  )

;; Save all backups to one folder
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq-default make-backup-file t)
(setq make-backup-files t)
;; The choice of single backup or numbered backups is controlled by
;; the variable version-control
(setq version-control t)
(setq kept-old-versions 3)
(setq kept-new-versions 10)
(setq delete-old-versions t)

;; For files managed by a version control system (see section M.7
;; Version Control), the variable vc-make-backup-files determines
;; whether to make backup files. By default it is nil, since backup
;; files are redundant when you store all the previous versions in a
;; version control system.
(setq vc-make-backup-files t)

;; Backup file after each save
(use-package backup-each-save
  :ensure t
  :init
  (add-hook 'after-save-hook 'backup-each-save))

;; (load-theme 'solarized-dark t)
(use-package nord-theme
  :ensure t
  :config
  (load-theme 'nord t)
  (setq nord-comment-brightness 20))
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

(add-hook 'css-mode-hook 'xah-syntax-color-hex)
(add-hook 'php-mode-hook 'xah-syntax-color-hex)
(add-hook 'html-mode-hook 'xah-syntax-color-hex)
(add-hook 'rjsx-mode-hook 'xah-syntax-color-hex)
(add-hook 'js-mode-hook 'xah-syntax-color-hex)

(message "Loaded my-color-theme.el")

(ido-mode t)
;; always create the new buffer without prompt
(setq ido-create-new-buffer "always")
;; ido will match if the inserted text is an arbitrary substring
(setq ido-enable-prefix nil)
(setq ido-max-dir-file-cache 0)

;; A Hint About "Too Big" from emacswiki
 (setq ido-max-directory-size 100000)

;; Non-nil means that `ido' will do flexible string
;; matching. Flexible matching means that if the entered string does
;; not match any item, any item containing the entered characters in
;; the given sequence will match."
(setq ido-enable-flex-matching t)

;; Non-nil means that `ido' will do regexp matching.  Value can be
;; toggled within `ido' using `ido-toggle-regexp' (C-t)
(setq ido-enable-regexp t)

;; do not enable tramp completion with ido
(setq ido-enable-tramp-completion nil)

(use-package rg
  :ensure t)

(use-package dired-single
  :ensure t
  :init
(defun my-dired-init ()
  "Bunch of stuff to run for dired, either immediately or when it's
   loaded."
  ;; <add other stuff here>
  (define-key dired-mode-map [remap dired-find-file]
    'dired-single-buffer)
  (define-key dired-mode-map [remap dired-mouse-find-file-other-window]
    'dired-single-buffer-mouse)
  (define-key dired-mode-map [remap dired-up-directory]
    'dired-single-up-directory)
  (define-key dired-mode-map (kbd ".")
    'dired-single-up-directory))

(setq dired-listing-switches "-alh")
(setq dired-recursive-copies 'always)

(setq dired-dwim-target t)

;; if dired's already loaded, then the keymap will be bound
(if (boundp 'dired-mode-map)
    ;; we're good to go; just add our bindings
    (my-dired-init)
  ;; it's not loaded yet, so add our bindings to the load-hook
  (add-hook 'dired-load-hook 'my-dired-init)))

(defun dired-ediff-marked-files ()
  "Run ediff on marked ediff files."
  (interactive)
  (set 'marked-files (dired-get-marked-files))
  (when (= (safe-length marked-files) 2)
    (ediff-files (nth 0 marked-files) (nth 1 marked-files)))
  
  (when (= (safe-length marked-files) 3)
    (ediff3 (buffer-file-name (nth 0 marked-files))
            (buffer-file-name (nth 1 marked-files)) 
            (buffer-file-name (nth 2 marked-files)))))

;; (use-package yasnippet
  ;;   :ensure t
  ;;   :config
  ;;   (setcdr yas-snippet-dirs (cons (concat my-emacs-load-path "my-snippets") (rest yas-snippet-dirs)))
  ;;   (yas/global-mode 1))
(use-package yasnippet                  ; Snippets
  :ensure t
  :config
  (setq yas-verbosity 1)                      ; No need to be so verbose
  (setq yas-wrap-around-region t)

  ;; (with-eval-after-load 'yasnippet
  ;;   (setq yas-snippet-dirs '(yasnippet-snippets-dir)))
  (add-hook 'prog-mode-hook #'yas-minor-mode)

  (yas-reload-all)
  (yas-global-mode))

(use-package yasnippet-snippets         ; Collection of snippets
  :ensure t)

(message "Loading org-mode")

  ;; This option is only relevant at load-time of Org-mode, and must be
  ;; set *before* org.el is loaded.
  ;; (setq org-CUA-compatible t)

  ;; This line only if Org is not part of the X/Emacs distribution. This line is not needed for git version.
  ;; (require 'org-install)

  ;; The following lines are always needed. Choose your own keys.
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
  (global-set-key "\C-cl" 'org-store-link)
  (global-set-key "\C-cc" 'org-capture)
  (global-set-key "\C-ca" 'org-agenda)
  (global-set-key "\C-cb" 'org-iswitchb)

  (add-hook 'org-mode-hook 'turn-on-font-lock) ; (XEmacs user must use this option)

  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)
  (setq org-clock-idle-time 10)
  (if linux-x-p
      (setq org-x11idle-program-name 'xprintidle))

  ;; (setq org-agenda-files (append '("~/.emacs.d/gcal.org"
  ;;                                  "~/.emacs.d/gcal-work.org")
  ;;                                (file-expand-wildcards "~/.emacs.d/org-gtd/*.org")))
  (setq org-agenda-files (append (file-expand-wildcards "~/.emacs.d/org-gtd/*.org")
                                 (file-expand-wildcards "~/.emacs.d/calendars/*.org")))

  (defun org-all ()
    (interactive)
    (setq org-agenda-files
          (file-expand-wildcards
           "~/.emacs.d/org-gtd/[a-zA-Z]*.org"))
    (org-agenda-redo))

  (defun org-work ()
    (interactive)
    (setq org-agenda-files
          (list
           "~/.emacs.d/org-gtd/work.org"
           ))
    (org-agenda-redo))

  (defun org-personal ()
    (interactive)
    (setq org-agenda-files
          (list
           "~/.emacs.d/org-gtd/personal.org"
           ))
    (org-agenda-redo))

  ;; Then each time you turn an entry from a TODO (not-done) state into
  ;; any of the DONE states, a line 'CLOSED: [timestamp]' will be
  ;; inserted just after the headline. If you turn the entry back into a
  ;; TODO item through further state cycling, that line will be removed
  ;; again.  The corresponding in-buffer setting is #+STARTUP: logdone

  (setq org-log-done 'time)

  ;; C-u C-c C-t: to switch the status quickly.

  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                (sequence "IDEA(i)" "DRAFT(f)")
                (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "red" :weight bold)
                ("NEXT" :foreground "blue" :weight bold)
                ("DRAFT" :foreground "blue" :weight bold)
                ("DONE" :foreground "forest green" :weight bold)
                ("WAITING" :foreground "orange" :weight bold)
                ("HOLD" :foreground "magenta" :weight bold)
                ("CANCELLED" :foreground "forest green" :weight bold)
                ("MEETING" :foreground "forest green" :weight bold)
                ("IDEA" :foreground "yellow" :weight bold)
                ("PHONE" :foreground "forest green" :weight bold))))

  (define-key global-map [(f9)] 'org-agenda)

  ;; Fast todo selection allows changing from any task todo state to any
  ;; other state directly by selecting the appropriate key from the fast
  ;; todo selection key menu. Changing a task state is done with C-c C-t
  ;; KEY, where KEY is the appropriate fast todo state selection key as
  ;; defined in org-todo-keywords.
  (setq org-use-fast-todo-selection t)

  ;; Moving a task to CANCELLED adds a CANCELLED tag
  ;; Moving a task to WAITING adds a WAITING tag
  ;; Moving a task to HOLD adds WAITING and HOLD tags
  ;; Moving a task to a done state removes WAITING and HOLD tags
  ;; Moving a task to TODO removes WAITING, CANCELLED, and HOLD tags
  ;; Moving a task to NEXT removes WAITING, CANCELLED, and HOLD tags
  ;; Moving a task to DONE removes WAITING, CANCELLED, and HOLD tags
  (setq org-todo-state-tags-triggers
        (quote (("CANCELLED" ("CANCELLED" . t))
                ("WAITING" ("WAITING" . t))
                ("HOLD" ("WAITING") ("HOLD" . t))
                (done ("WAITING") ("HOLD"))
                ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
                ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))



  ;; To keep the overview over the fraction of subtasks that are already
  ;; completed, insert either '[/]' or '[%]' anywhere in the
  ;; headline. These cookies will be updates each time the todo status
  ;; of a child changes.

  ;; If you would like a TODO entry to automatically change to DONE when
  ;; all chilrden are done, you can use the following setup
  (defun org-summary-todo (n-done n-not-done)
    "Switch entry to DONE when all subentries are done, to TODO otherwise."
    (let (org-log-done org-log-states) ; turn off logging
      (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
  (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

  (setq org-special-ctrl-k t)
  (setq org-special-ctrl-a/e "reversed")

  (add-to-list 'file-coding-system-alist (cons "\\.org$"  'utf-8))


  ;;; Configuration of Remember
  (setq org-directory "~/.emacs.d/org-gtd/")
  (setq org-default-notes-file "~/.emacs.d/org-gtd/refile.org")

  ;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
  (setq org-capture-templates
        (quote (("t" "todo" entry (file+headline "~/.emacs.d/org-gtd/personal.org" "Tasks")
                 "** TODO %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%U \n")
                ("c" "todo" entry (file+headline "~/.emacs.d/org-gtd/weimill.org" "Tasks")
                 "** TODO %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%U \n")
                ("E" "local event" entry (file+headline "~/.emacs.d/org-gtd/personal.org" "Events")
                 "** %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%U \n")
                ("e" "your-nick google Calendar" entry (file "~/.emacs.d/calendars/your-nick.org")
                 "* %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%U \n")
                ("f" "family google Calendar" entry (file "~/.emacs.d/calendars/calendar2.org")
                 "* %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%U \n")
                ("w" "wish google Calendar" entry (file "~/.emacs.d/calendars/calendar4.org")
                 "* %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\")) %a\n")
                ("b" "blog" entry (file+headline "~/.emacs.d/org-wiki/draft/tech/blog.org" "Blog")
                 "** %?\n   :PROPERTIES:\n   :EXPORT_FILE_NAME: \n   :EXPORT_DATE: %(format-time-string \"%Y-%m-%d\")\n   :END:\n\n")
                ("z" "blog" entry (file+headline "~/.emacs.d/org-wiki/draft/tech/blog.org" "中文")
                 "** %?\n   :PROPERTIES:\n   :EXPORT_FILE_NAME: \n   :EXPORT_DATE: %(format-time-string \"%Y-%m-%d\")\n   :END:\n\n")
                ("r" "reading" entry (file+headline "~/.emacs.d/org-gtd/personal.org" "Reading")
                 "* NEXT %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%U\n%a\n")
                ("n" "note" entry (file "~/.emacs.d/org-gtd/refile.org")
                 "* %? :NOTE:\n%U\n%a\n")
                ("i" "idea" entry (file "~/.emacs.d/org-gtd/refile.org")
                 "* IDEA %T %?\n")
                ("j" "Journal" entry (file+datetree "~/.emacs.d/org-gtd/diary.org")
                 "* %?\n%U\n")
                ;; ("m" "Meeting" entry (file "~/.emacs.d/org-gtd/refile.org")
                ;;  "* MEETING with %? :MEETING:\n%U")
                ("p" "Phone call" entry (file "~/.emacs.d/org-gtd/refile.org")
                 "* PHONE %? :PHONE:\n%U")
                ("h" "Habit" entry (file "~/.emacs.d/org-gtd/refile.org")
                 "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")
                ("c" "Cookbook" entry (file "~/.emacs.d/org-gtd/cookbook.org")
                 "%(org-chef-get-recipe-from-url)")
                ("m" "Manual Cookbook" entry (file "~/.emacs.d/org-gtd/cookbook.org")
                 "* %^{Recipe title: }\n  :PROPERTIES:\n  :source-url:\n  :servings:\n  :prep-time:\n  :cook-time:\n  :ready-in:\n  :END:\n** Ingredients\n   %?\n** Directions\n\n"))))


  ;;; Refile http://doc.norang.ca/org-mode.html#Refiling

  ; Targets include this file and any file contributing to the agenda - up to 9 levels deep
  (setq org-refile-targets (quote ((nil :maxlevel . 2)
                                   (org-agenda-files :maxlevel . 2))))

  ; Use full outline paths for refile targets - we file directly with IDO
  (setq org-refile-use-outline-path t)

  ; Targets complete directly with IDO
  (setq org-outline-path-complete-in-steps nil)

  ; Allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes (quote confirm))

  ; Use IDO for both buffer and file completion and ido-everywhere to t
  (setq org-completion-use-ido t)
  (setq ido-everywhere t)
  (setq ido-max-directory-size 100000)
  (ido-mode (quote both))
  ; Use the current window when visiting files and buffers with ido
  (setq ido-default-file-method 'selected-window)
  (setq ido-default-buffer-method 'selected-window)
  ; Use the current window for indirect buffer display
  (setq org-indirect-buffer-display 'current-window)

  ;;;; Refile settings
  ; Exclude DONE state tasks from refile targets
  (defun bh/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets"
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))

  (setq org-refile-target-verify-function 'bh/verify-refile-target)


  ;;; auto save all org files after hook, Doesn't work, ERROR: apply: Wrong number of arguments: (1 . 2), 0
  ;; (advice-add 'org-refile :after 'org-save-all-org-buffers)
  ;; (advice-add 'org-deadline :after 'org-save-all-org-buffers)
  ;; (advice-add 'org-schedule :after 'org-save-all-org-buffers)
  ;; (advice-add 'org-store-log-note :after 'org-save-all-org-buffers)
  ;; (advice-add 'org-todo :after 'org-save-all-org-buffers)
  (add-hook 'org-after-tags-change-hook 'org-save-all-org-buffers nil t)


  ;; update agenda file after changes to org files
  (defun org-mode-init ()
    (add-hook 'after-save-hook 'org-update-agenda-file t t))

  ;; export function to temporary file for window manager.
  (defun org-update-agenda-file (&optional force)
    (interactive)
    (save-excursion
      (save-window-excursion
        (let ((file "/tmp/org-agenda.txt"))
          (org-agenda-list)
          (org-write-agenda file)))))

  ;; Up date the temporary Org Agenda file?
  (if (and linuxp mac-osx-p)
      (progn
        (org-update-agenda-file t)
        (add-hook 'org-mode-hook 'org-mode-init)))

  ;; saves all org buffers at 1 minute before the hour
  ; (run-at-time "00:59" 3600 'org-save-all-org-buffers)

  (setq org-publish-project-alist
        '(

          ("org-myblog"
           ;; Path to your org files.
           :base-directory "~/workspace/blog/leiwang/resources/org"
           :base-extension "org"

           ;; Path to your Jekyll project.
           :publishing-directory "~/workspace/blog/leiwang/resources/content"
           :recursive t
           :publishing-function org-html-export-to-html
           :headline-levels 4
           :html-extension "html"
           :body-only t ;; Only export section between <body> </body>
           )

          ("org-static-myblog"
           :base-directory "~/Documents/myblog/org/static/"
           :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php"
           :publishing-directory "~/Documents/myblog/jekyll/_site/"
           :recursive t
           :publishing-function org-publish-attachment)

          ("myblog" :components ("org-myblog" "org-static-myblog"))
          )
        )

  ;; Make windmove work in org-mode
  (add-hook 'org-shiftup-final-hook 'windmove-up)
  (add-hook 'org-shiftleft-final-hook 'windmove-left)
  (add-hook 'org-shiftdown-final-hook 'windmove-down)
  (add-hook 'org-shiftright-final-hook 'windmove-right)

  ;; Configure for latex fragment
  ;;; usage in buffer: C-c C-x C-l to generate preview and C-c C-c to
  ;;; remove preview image.
  ;; (require 'cdlatex)
  ;; (require 'texmathp)
  ;; (add-hook 'org-mode-hook 'turn-on-org-cdlatex)
  ;; (setq org-format-latex-options
  ;;       '(:foreground default
  ;;                     :background default
  ;;                     :scale 1.2
  ;;                     :html-foreground "Black"
  ;;                     :html-background "Transparent"
  ;;                     :html-scale 1.2
  ;;                     :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
  ;; (setq org-export-with-LaTeX-fragments t)

  ;; (require 'ob-tangle)
  ;; (org-babel-do-load-languages  ; use 'make' to compile org-mode
  ;;                               ; first.
  ;;  'org-babel-load-languages
  ;;  '((emacs-lisp . t)
  ;;    (latex . t)  ; this is the entry to activate LaTeX
  ;;    (python . t)))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (clojure . t)
     ;; (ledger . t)
     (python . t)))

  (setq org-export-html-style
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"org.css\" />")

  ;;; snippets for org-mode
  ;; (yas/define-snippets 'org-mode
  ;; '(
  ;;   ("isrc" "#+BEGIN_SRC ${1:name}
  ;;    $2
  ;;    #+END_SRC
  ;; " "#SRC : #+BEGIN_...#+END_" nil nil)
  ;;   ("iexp" "#+BEGIN_EXAMPLE
  ;;    $1
  ;;    #+END_EXAMPLE
  ;; " "#EXAMPLE : #+BEGIN_...#+END_" nil nil)
  ;;   ("iver" "#+BEGIN_VERSE
  ;;    $1
  ;;    #+END_VERSE
  ;; " "#VERSE : #+BEGIN_...#+END_" nil nil)
  ;;   ("iquo" "#+BEGIN_QUOTE
  ;;    $1
  ;;    #+END_QUOTE
  ;; " "#QUOTE : #+BEGIN_...#+END_" nil nil)
  ;;   ("ihtml" "#+BEGIN_HTML
  ;;    $1
  ;;    #+END_HTML
  ;; " "#HTML : #+BEGIN_...#+END_" nil nil)
  ;;   ("icod" "#+BEGIN_HTML
  ;;   <pre class=\"brush: ${1:bash};fontsize: ${2:50}; first-line: ${3:1}; ${4:collapse: true; }\">
  ;;   $0</pre>
  ;; #+END_HTML " "#HTMLCODE : #+BEGIN_...#+END_" nil nil)
  ;;  )
  ;; 'text-mode)

;;   (use-package ox-latex
;;  :ensure t)
;;   (use-package ox-beamer
;;   :ensure t)

  ;; (add-to-list 'org-latex-classes
  ;;              '("beamer"
  ;;                "\\documentclass\[presentation\]\{beamer\}"
  ;;                ("\\section\{%s\}" . "\\section*\{%s\}")
  ;;                ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
  ;;                ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

  ;; colorized code block in beamer using minted
  (setq org-latex-listings 'minted)
  (add-to-list 'org-latex-packages-alist '("" "minted"))
  (setq org-latex-pdf-process
        '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

  ;; Resolve the conflict between yasnippet and org-mode
  (defun yas/org-very-safe-expand ()
    (let ((yas/fallback-behavior 'return-nil)) (yas/expand)))

  ;; To save the clock history across Emacs sessions, use:
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)

  (defun my-org-mode-keys ()
    "my keys for `org-mode'"
    (interactive)
    ;; (local-set-key (kbd "<f7>") 'org-clock-in)
    ;; (local-set-key (kbd "<f8>") 'org-clock-out)
    (make-variable-buffer-local 'yas/trigger-key)
    (setq yas/trigger-key [tab])
    (add-to-list 'org-tab-first-hook 'yas/org-very-safe-expand)
    (define-key yas/keymap [tab] 'yas/next-field))

  (add-hook 'org-mode-hook 'my-org-mode-keys)

  ;; 防止org-mode在导出HTML时把行末的回车输出为空格
  (defadvice org-html-paragraph (before fsh-org-html-paragraph-advice
                                        (paragraph contents info) activate)
    "Join consecutive Chinese lines into a single long line without
  unwanted space when exporting org-mode to html."
    (let ((fixed-contents)
          (orig-contents (ad-get-arg 1))
          (reg-han "[[:multibyte:]]"))
      (setq fixed-contents (replace-regexp-in-string
                            ;; 这一行是匹配上一行末和下一行头都是中文的情况, 但是这样的话遇上"中文\nenglish"就仍然有空格
                            ;; (concat "\\(" reg-han "\\) *\n *\\(" reg-han "\\)")
                            (concat "\\(" reg-han "\\) *\n *")
                            "\\1" orig-contents))
      (ad-set-arg 1 fixed-contents)))

  ;; Set default column view headings: Task Total-Time Time-Stamp
  ;; Activate org-columns with C-c C-x C-c while on a top-level heading
  (setq org-columns-default-format "%50ITEM(Task) %10CLOCKSUM %16TIMESTAMP_IA")

  (add-to-list 'load-path "~/emacs.d/load-path/ox-hugo")
  (use-package ox-hugo
    :ensure t)
  (setq org-hugo-date-format "%Y-%m-%d")
  (setq org-hugo-content-folder "src/pages")

  ;; When t (the default), the user is asked before every code block
  ;; evaluation.  When ‘nil’, the user is not asked.  When set to a
  ;; function, it is called with two arguments (language and body of the
  ;; code block ) and should return t to ask and ‘nil’ not to ask.
  (setq org-confirm-babel-evaluate nil)


  (setq org-agenda-custom-commands
        '(("c" "My agenda view"
           ((agenda "")
            (tags "PRIORITY={A}"
                  ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                   (org-agenda-overriding-header "High-Priority tasks:")))
            (alltodo "")))))

  ;;; org babel clojure
  (setq org-babel-clojure-backend 'cider)

  ;; edit code block C-c ', org-edit-src-code, org-edit-src-abort

;; (use-package sqlite3
;;   :ensure t)
(use-package emacsql-libsqlite3
  :ensure t)
(use-package org-roam
      :ensure t
      :init
      (setq org-roam-v2-ack t)
      ;; (setq org-roam-database-connector 'libsqlite3) ; unique key constraint issue
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

(use-package magit
    :ensure t
    :init
    (setq magit-auto-revert-mode nil)
    ;; (setq magit-revert-buffers nil)
    (setq auto-revert-buffer-list-filter
          'magit-auto-revert-repository-buffers-p)
    (setq vc-handled-backends (delq 'Git vc-handled-backends))
    (global-set-key [f4] 'magit-status)
    (setq magit-section-initial-visibility-alist '((stashes . show)
                                                   (unstaged . show)
                                                   (unpushed . show)
                                                   (recent . show)))
    (setq magit-diff-refine-hunk 'all))

(use-package git-blamed
  :ensure t
  :init 
  (autoload 'git-blame-mode "git-blame"
    "Minor mode for incremental blame for Git." t))

(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
   "Major mode for editing comma-separated value files." t)
(add-hook 'csv-mode-hook 'my-csv-mode-init)
(defun my-csv-mode-init ()
  "Configure the csv mode not to truncate lines."
  (setq truncate-lines t))

(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(setq flycheck-check-syntax-automatically '(save
                                            idle-change
                                            new-line
                                            idle-buffer-switch
                                            mode-enabled))

(flycheck-define-checker jsxhint-checker
  "A JSX syntax and style checker based on JSXHint."

  :command ("jsxhint" source)
  :error-patterns
  ((error line-start (1+ nonl) ": line " line ", col " column ", " (message) line-end))
  :modes (web-mode))

(use-package rjsx-mode
  :ensure t)
(setq auto-mode-alist
    (append '((".*\\.astro\\'" . js-jsx-mode))
        auto-mode-alist))

;; html-mode and js-mode
(add-hook 'html-mode-hook
          (lambda ()
            (local-set-key (kbd "<f8>") 'js2-mode)
            (set (make-local-variable 'sgml-basic-offset) 2)))
(add-hook 'js2-mode-hook
          (lambda ()
            (local-set-key (kbd "<f8>") 'mhtml-mode)))

;; multi-web-mode
(use-package multi-web-mode
  :ensure t)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '( ;;(php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "ctp" "phtml" "php4" "php5"))
;; (multi-web-global-mode 1) ; use web-mode for html instead

;;; for html
(use-package web-mode
  :ensure t)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.htm\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(setq web-mode-enable-auto-closing t)
(setq web-mode-enable-auto-pairing t)
(setq web-mode-enable-auto-indentation t)
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; (require 'emmet-mode) ; use Ctrl-j
;; (add-hook 'sgml-mode-hook 'emmet-mode)

;; for javascript
(setq js-indent-level 2)
(setq-default js2-basic-offset 2)
;; (setq js-indent-level 4)
;; (add-to-list 'auto-mode-alist '("\\.js.\\'" . js-mode))
(autoload 'js2-mode "js2-mode" nil t)

(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode)) ; \' will match empty string only at the end of the string or buffer; \$ will match end of line
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))
;; (setq js2-consistent-level-indent-inner-bracket-p t)
;; (setq js2-pretty-multiline-decl-indentation-p t)
;; (put 'narrow-to-region 'disabled nil)
(message "Configured for javascript")

(setq css-indent-offset 2)

(add-hook 'web-mode-hook
          (lambda ()
            (when (equal web-mode-content-type "jsx")
              ;; enable flycheck
              (flycheck-select-checker 'jsxhint-checker)
              (flycheck-mode))))

;; from: http://riddell.us/tutorial/slime_swank/slime_swank.html
;; clojure-mode
;; (add-to-list 'load-path "~/emacs.d/load-path/clojure-mode")
;; (add-to-list 'load-path "~/emacs.d/load-path/nrepl.el")
;; (add-to-list 'load-path "~/emacs.d/load-path/dash.el")
;; (add-to-list 'load-path "~/emacs.d/load-path/pkg-info.el")
;; (add-to-list 'load-path "~/emacs.d/load-path/s.el")

(use-package cider
  :ensure t)

(setenv "JAVA_HOME" "~/workspace/jdk/jdk-11.0.5/Contents/Home")

;; (add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)

;; Enable eldoc in Clojure buffers:
(add-hook 'cider-mode-hook #'eldoc-mode)

;; (setq nrepl-hide-special-buffers t)

;; To auto-select the error buffer when it's displayed:
(setq cider-auto-select-error-buffer t)

(setq cider-repl-use-pretty-printing t)

(setq cider-repl-pop-to-buffer-on-connect t)

;; The REPL buffer name can also display the port on which the nREPL
;; server is running. Buffer name will look like cider
;; project-name:port.
(setq nrepl-buffer-name-show-port t)

;; Make C-c C-z switch to the CIDER REPL buffer in the current window:
;; (setq cider-repl-display-in-current-window t)

(setq cider-preferred-build-tool "clojure-cli")
;; (setq cider-clojure-cli-global-options "-M:env/dev:env/test")
;; https://practical.li/spacemacs/clojure-projects/project-configuration.html
(setq cider-clojure-cli-aliases "-M:env/dev:env/test")


(use-package paredit
  :ensure t)
(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code."
  t)
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)


(add-hook 'clojure-mode-hook 'subword-mode)
(add-hook 'clojure-mode-hook 'cider-mode)

(add-hook 'cider-repl-mode-hook 'subword-mode)
(add-hook 'cider-repl-mode-hook 'cider-mode)

(add-hook 'emacs-lisp-mode-hook 'subword-mode)

(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)

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
(eval-after-load 'clojure-mode
  '(define-clojure-indent
     (for-all 1)))

(setq slime-net-coding-system (quote utf-8-unix))

(add-hook 'clojure-mode-hook
          (lambda ()
            (local-set-key (kbd "<f7>") 'cider-eval-buffer)))

;; use slime's C-c C-k before switching to the REPL, for
;; slime-compile-and-load-file. It will prompt you to save the file if
;; you haven't already. When it's done, the things which you've
;; redefined should be available at the SLIME REPL in the new
;; versions. Then you should use C-c C-z to bring up the REPL (close
;; it with C-x 0 when you don't need it anymore)

(setq auto-mode-alist
      (cons '("\\.dtm\\'" . clojure-mode) auto-mode-alist))

(defun cider-namespace-refresh ()
  (interactive)
  (cider-interactive-eval
   "(require 'clojure.tools.namespace.repl)
    (clojure.tools.namespace.repl/refresh)"))

(autoload 'octave-mode "octave-mode" nil t)
(setq auto-mode-alist
      (cons '("\\.m\\'" . octave-mode) auto-mode-alist))



(use-package ox-reveal
  :ensure t)
(setq org-reveal-root "file://~/.emacs.d/load-path/ox-reveal/reveal.js")

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

;; trim white space in changed area during save except for final new line
(use-package ws-butler
  :ensure t
  :init 
  (ws-butler-global-mode 1))

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

;;; helm-git-project
;; forked from https://gist.github.com/eiel/2717956
;; (use-package cl
;;   :ensure t)
;; (use-package helm-config
;;   :ensure t)
;; (use-package helm-files
;;   :ensure t)

(defvar helm-git-project-dir nil)

(defun git-project:root-dir ()
  (file-name-directory (file-truename
                        (shell-command-to-string "git rev-parse --git-dir"))))

(defun helm-git-project:create-source (name options)
  `((name . ,(concat "Git Project " name))
    (init . (lambda ()
              (setq helm-git-project-dir (git-project:root-dir))
              (let ((buffer (helm-candidate-buffer 'global))
                    (args (format "ls-files --full-name %s %s"
                                  ,options helm-git-project-dir)))
                (call-process-shell-command "git" nil buffer nil args))
              ))
    (display-to-real . (lambda (c) (concat helm-git-project-dir c)))
    (candidates-in-buffer)
    (action ("Find File" . find-file))))

(defvar helm-c-source-git-project-for-modified
  (helm-git-project:create-source "Modified files" "--modified"))
(defvar helm-c-source-git-project-for-untracked
  (helm-git-project:create-source "Untracked files" "--others --exclude-standard"))
(defvar helm-c-source-git-project-for-all
  (helm-git-project:create-source "All files" ""))

(defun helm-git-project ()
  (interactive)
  (let ((sources '(helm-c-source-git-project-for-modified
                   helm-c-source-git-project-for-untracked
                   helm-c-source-git-project-for-all)))
    (helm-other-buffer sources
                       (format "*Helm git project in %s*" default-directory))))

(global-set-key [f8] 'counsel-git)

(use-package ivy
  :ensure t)
(use-package swiper
  :ensure t)
(use-package counsel
  :ensure t)

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


;; Set ivy mini buffer selection color
(custom-set-faces
 '(ivy-current-match
   ((((class color) (background light))
     :background "#0EA5E9" :foreground "white")
    (((class color) (background dark))
     :background "#0EA5E9" :foreground "black"))))

;; (progn
;;   (set-face-attribute 'ivy-current-match nil :foreground "white")
;;   (set-face-attribute 'ivy-minibuffer-match-face-2 nil :foreground "white" :background "red")
;;   (set-face-attribute 'ivy-minibuffer-match-face-3 nil :foreground "white" :background "darkgreen")
;;   (set-face-attribute 'ivy-minibuffer-match-face-4 nil :foreground "white" :background "blue")
;;   ;;
;;   (set-face-attribute 'swiper-match-face-2         nil :foreground "white" :background "red")
;;   (set-face-attribute 'swiper-match-face-3         nil :foreground "white" :background "darkgreen")
;;   (set-face-attribute 'swiper-match-face-4         nil :foreground "white" :background "blue"))

;; https://github.com/abo-abo/swiper/issues/1172#issuecomment-633148859
(defun swiper-C-r (&optional arg)
  "Move cursor vertically down ARG candidates.
If the input is empty, select the previous history element instead."
  (interactive "p")
  (if (string= ivy-text "")
      (ivy-next-history-element 1)
    (ivy-previous-line arg)))

(defun xah-user-buffer-q ()
  "Return t if current buffer is a user buffer, else nil.
Typically, if buffer name starts with *, it's not considered a user buffer.
This function is used by buffer switching command and close buffer command, so that next buffer shown is a user buffer.
You can override this function to get your idea of “user buffer”.
version 2016-06-18"
  (interactive)
  (if (string-equal "*" (substring (buffer-name) 0 1))
      nil
    (if (string-equal major-mode "dired-mode")
        nil
      t
      )))

(defun xah-next-user-buffer ()
  "Switch to the next user buffer.
“user buffer” is determined by `xah-user-buffer-q'.
URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'
Version 2016-06-19"
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (< i 20)
      (if (not (xah-user-buffer-q))
          (progn (next-buffer)
                 (setq i (1+ i)))
        (progn (setq i 100))))))

(defun xah-previous-user-buffer ()
  "Switch to the previous user buffer.
“user buffer” is determined by `xah-user-buffer-q'.
URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'
Version 2016-06-19"
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (< i 20)
      (if (not (xah-user-buffer-q))
          (progn (previous-buffer)
                 (setq i (1+ i)))
        (progn (setq i 100))))))

(defun xah-next-emacs-buffer ()
  "Switch to the next emacs buffer.
“emacs buffer” here is buffer whose name starts with *.
URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'
Version 2016-06-19"
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (not (string-equal "*" (substring (buffer-name) 0 1))) (< i 20))
      (setq i (1+ i)) (next-buffer))))

(defun xah-previous-emacs-buffer ()
  "Switch to the previous emacs buffer.
“emacs buffer” here is buffer whose name starts with *.
URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'
Version 2016-06-19"
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (not (string-equal "*" (substring (buffer-name) 0 1))) (< i 20))
      (setq i (1+ i)) (previous-buffer))))

(global-set-key (kbd "<C-f11>") 'xah-previous-user-buffer)
(global-set-key (kbd "<C-f12>") 'xah-next-user-buffer)

(global-set-key (kbd "<M-f11>") 'xah-previous-emacs-buffer)
(global-set-key (kbd "<M-f12>") 'xah-next-emacs-buffer)

(use-package pyim
  :ensure t)
(use-package pyim-basedict
  :ensure t) ; 拼音词库设置，五笔用户 *不需要* 此行设置
(pyim-basedict-enable)   ; 拼音词库，五笔用户 *不需要* 此行设置

(setq pyim-page-style 'one-line)
(setq pyim-page-tooltip 'popup)
;; (setq pyim-page-tooltip 'pos-tip)
;; (if linuxp
;;     (setq pyim-page-tooltip 'pos-tip))
;; (if linuxp
;;     (setq x-gtk-use-system-tooltips t))

(setq pyim-page-length 5)
(setq default-input-method "pyim")

(pyim-isearch-mode 1)

;; (setq pyim-page-tooltip 'popup)
(if (not (version< emacs-version "26")) ; posframe require emacs version 26+
    (setq pyim-page-tooltip 'posframe)) ; require manual install posframe

(setq pyim-default-scheme 'quanpin)

;; (setq-default pyim-english-input-switch-functions
;;                 '(pyim-probe-dynamic-english
;;                   pyim-probe-isearch-mode))

;; Font configuration when using Emacs
(add-hook 'after-make-window-system-frame-hooks
          (lambda ()
            (my-font-config)))

(when (display-graphic-p)
  (setq my-font-options
        (cond ((eq system-type 'darwin)     '("Source Code Pro"     "STHeiti"))
              ;; ((eq system-type 'darwin)     '("Monaco"     "STHeiti"))
              ((eq system-type 'gnu/linux)  '("Menlo"     "WenQuanYi Zen Hei"))
              ((eq system-type 'windows-nt) '("Consolas"  "Microsoft Yahei")))))

;; I don't know why I need these two.
;; (setq face-font-rescale-alist '(("STHeiti" . 1) ("Microsoft Yahei" . 1) ("WenQuanYi Zen Hei" . 1)))
;; (set-face-attribute 'default nil :font
;;                    (format "%s:pixelsize=%d" (car my-font-options) 12))

;;; 等款字体
;; (when (display-graphic-p)
;;   (setq fonts
;;         (cond ((eq system-type 'darwin)     '("Monaco" "STHeiti"))
;;               ((eq system-type 'gnu/linux)  '("Monaco" "WenQuanYi Micro Hei Mono"))
;;               ((eq system-type 'windows-nt) '("Consolas" "Microsoft Yahei"))))
;;   (setq face-font-rescale-alist '(("STHeiti" . 1.05) ("STFangsong" . 1.2) ("Microsoft Yahei" . 1.2) ("WenQuanYi Micro Hei Mono" . 1.2)))
;;   (set-face-attribute 'default nil :font
;;                       (format "%s:pixelsize=%d" (car fonts) 14))
;;   (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;     (set-fontset-font (frame-parameter nil 'font) charset
;;                       (font-spec :family (car (cdr fonts)) :size 16))))

(defun fix-mac-osx-issue ()
  "Fix mac osx Chinese font issue"
  (if mac-osx-x-p
      (set-frame-font "Menlo" nil t) ; Menlo, Monaco
      ;; this is good for all
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font (frame-parameter nil 'font) charset
                          (font-spec :family "STHeiti")))))

(defun my-font-config ()
  "Configure font for Linux."
  (if linuxp
      (progn
        ;; (set-frame-font "Bitstream Vera Sans Mono-8")
        ;; (set-frame-font "DejaVu Sans Mono-8")
        (set-frame-font "Inconsolata-11") ; sudo apt-get install fonts-inconsolata
        ;; set the default font for chinese.
        (set-fontset-font "fontset-default"
                          'unicode '("Microsoft YaHei" . "unicode-bmp"))
        (message "my-font.el: configured font for emacs 23")))
  (fix-mac-osx-issue))




;; configure font, if current process is not daemon.
(if (or
     (not (boundp 'daemonp))
     (not (daemonp)))
    (progn
      (my-font-config)
      (message "Loaded my-font.el")))

;; (require 'cnfonts)
;; ;; (setq cfs-profiles '("program" "org-mode" "read-book"))
;; (cnfonts-enable)
;; (cnfonts-switch-profile "profile1") ; use cfs-edit-profile to create profile
;; (setq cfs--profiles-steps (quote (("profile1" . 1)))) ; set font size
;; (setq cfs-use-face-font-rescale t)
;; ;; (cfs-set-spacemacs-fallback-fonts) ; fix unicode icon display in spacemacs mode-line
;; ;; (set-face-italic 'font-lock-comment-face nil)

;; (defun zoom-font (n)
;;   "with positive N, increase the font size, otherwise decrease it"
;;   (set-face-attribute 'default (selected-frame) :height
;;     (+ (face-attribute 'default :height) (* (if (> n 0) 1 -1) 10)))
;;   ;; need this for mac osx Chinese font issue after zooming
;;   (fix-mac-osx-issue))

;; (global-set-key (kbd "C-=")      '(lambda nil (interactive) (if linuxp
;;                                                                 (cfs-increase-fontsize)
;;                                                               (zoom-font 1))))
;; (global-set-key [C-kp-add]       '(lambda nil (interactive) (if linuxp
;;                                                                 (cfs-increase-fontsize)
;;                                                               (zoom-font 1))))
;; (global-set-key (kbd "C--")      '(lambda nil (interactive) (if linuxp
;;                                                                 (cfs-decrease-fontsize)
;;                                                               (zoom-font -1))))
;; (global-set-key [C-kp-subtract]  '(lambda nil (interactive) (if linuxp
;;                                                                 (cfs-decrease-fontsize)
;;                                                               (zoom-font -1))))

;; Change current buffer font size
(global-set-key (kbd "C-=") 'text-scale-increase)

(global-set-key (kbd "C--") 'text-scale-decrease)

;; use default-text-scale-mode
(use-package default-text-scale
  :ensure t)
(global-set-key (kbd "C-M-=") 'default-text-scale-increase)
(global-set-key (kbd "C-M--") 'default-text-scale-decrease)

;; restclient
(use-package restclient
  :ensure t)
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

(setq ledger-init-file-name "~/workspace/linux-conf/_ledgerrc")
(add-hook 'ledger-mode-hook
               (lambda ()
                 (setq-local tab-always-indent 'complete)
                 (setq-local completion-cycle-threshold t)
                 (setq-local ledger-complete-in-steps t)))
;; (use-package ledger-complete
;;   :ensure t)

;; golang go-mode
  ;; (use-package go-mode
  ;;   :ensure t)
  (add-hook 'go-mode-hook
            (lambda ()
              ;; golang prefer to use gofmt, instead of customized style
              (add-hook 'before-save-hook 'gofmt-before-save)
              ;; (setq-default)
              (setq tab-width 4)
              ;; (setq standard-indent 2)
              (setq indent-tabs-mode t)

              (local-set-key (kbd "M-.") #'godef-jump)
              ;; gotest
              (define-key go-mode-map (kbd "C-c f") 'go-test-current-file)
              (define-key go-mode-map (kbd "C-c t") 'go-test-current-test)
              (define-key go-mode-map (kbd "C-c p") 'go-test-current-project)
              (define-key go-mode-map (kbd "C-c b") 'go-test-current-benchmark)
              (define-key go-mode-map (kbd "C-c x") 'go-run)

              ;; (flymake-mode -1)
              (setq gofmt-command "goimports")
              (add-hook 'before-save-hook 'gofmt-before-save)

              ))

  ;; gotest
  (use-package gotest
    :ensure t)

(defun custom/find-go-dir (dir)
  (if (equal dir "/") nil
    (if (member "go.mod" (directory-files dir)) dir
      (custom/find-go-dir (file-name-directory (string-trim-right did "/"))))))


  (defun lsp-go-install-save-hooks ()
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))

  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

  (add-hook 'go-mode-hook #'yas-minor-mode)
  (add-hook 'go-mode-hook #'flycheck-mode)

  ;; (add-hook 'go-mode-hook 'eglot-ensure) ; don't use, it will enable flymake-mode
  ;; (add-hook 'go-mode-hook 'eglot-ensure)
  ;; replace flymake with flycheck
  ;; (use-package flymake-flycheck
  ;;   :ensure t)

  ;; (put 'eglot-node 'flymake-overlay-control nil)
  ;; (put 'eglot-warning 'flymake-overlay-control nil)
  ;; (put 'eglot-error 'flymake-overlay-control nil)
  ;; (push '(face . nil) (get :note 'flymake-overlay-control))
  ;; (push '(face . nil) (get :error 'flymake-overlay-control))
  ;; (push '(face . nil) (get :warning 'flymake-overlay-control))
  ;; (setq flymake-diagnostic-functions (flymake-flycheck-all-chained-diagnostic-functions))


  ;; lsp-mode
  (use-package lsp-mode
    :ensure t
    :init
    ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
    ;; (setq lsp-keymap-prefix "C-c l")
    :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
           (go-mode . lsp)
           ;; if you want which-key integration
           (lsp-mode . lsp-enable-which-key-integration))
    :commands lsp)

  (use-package which-key
    :ensure t)

  ;; lsp-ui
  (use-package lsp-ui
    :ensure t
    :commands lsp-ui-mode)

  ;; if you are ivy user
  (use-package lsp-ivy
    :ensure t
    :commands lsp-ivy-workspace-symbol)
  (use-package lsp-treemacs
    :ensure t
    :commands lsp-treemacs-errors-list)

  (setq lsp-gopls-staticcheck t)
  (setq lsp-eldoc-render-all t)
  (setq lsp-gopls-complete-unimported t)

  (setq lsp-ui-doc-enable nil
        lsp-ui-peek-enable t
        lsp-ui-sideline-enable t
        lsp-ui-imenu-enable t
        lsp-ui-flycheck-enable t
        lsp-enable-snippet t
        company-lsp-enable-snippet t)

;; Projectile
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  ;; Recommended keymap prefix on macOS
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map))

;; (add-to-list 'projectile-project-root-files-functions 'custom/find-go-dir)

(use-package yaml-mode
  :ensure t)

(use-package markdown-mode
  :ensure t)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package tss
  :ensure t)
(use-package typescript-mode
  :ensure t)
(setq typescript-indent-level 2)

(use-package tree-sitter
  :ensure t)
(use-package tree-sitter-langs
  :ensure t)
(straight-use-package '(tsi :type git :host github :repo "orzechowskid/tsi.el"))
(require 'tsi-typescript)
(require 'tsi-css)
(require 'tsi-json)
(use-package coverlay
  :ensure t)

(straight-use-package '(tsx-mode :type git :host github :repo "orzechowskid/tsx-mode.el"))
(require 'tsx-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-mode))
(setq standard-indent 2) ; Fix indent-region issue: https://github.com/orzechowskid/tsi.el/issues/40
(add-hook 'tsx-mode-hook #'lsp)

(use-package highlight-indent-guides
  :ensure t)

(defun toggle-indent-fold ()
  "Toggle fold all lines larger than indentation on current line"
  (interactive)
  (let ((col 1))
    (save-excursion
      (back-to-indentation)
      (setq col (+ 1 (current-column)))
      (set-selective-display
       (if selective-display nil (or col 1))))))
(global-set-key [(M C i)] 'aj-toggle-fold)

(straight-use-package
 '(lsp-tailwindcss
   :type git :host github :repo "merrickluo/lsp-tailwindcss"))

(use-package lsp-tailwindcss
:init
(setq lsp-tailwindcss-add-on-mode t)
:config
(add-to-list 'lsp-tailwindcss-major-modes 'tsx-mode))

(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (eshell 'N))

(electric-pair-mode 1)
;; Emacs has a concept of Syntax Table. The basic idea is, each
;; character (every Unicode character), is categorized into a
;; class. Classes are: letters, punctuations, brackets, programing
;; language identifiers, comment character, string delimiters, etc.
;; http://xahlee.info/emacs/emacs/elisp_syntax_table.html
;; make electric-pair-mode work on more brackets
(setq electric-pair-pairs
      '(
        (?\" . ?\")
        (?\' . ?\')
        (?\< . ?\>)
        (?\[ . ?\])
        (?\{ . ?\})))

(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(use-package dap-mode)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode

  (require 'dap-cpptools)
  (yas-global-mode))
