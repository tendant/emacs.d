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

(setq org-agenda-files (cons "~/.emacs.d/gcal.org"
                             (file-expand-wildcards "~/.emacs.d/org-gtd/*.org")))

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
         "~/.emacs.d/org-gtd/wish.org"
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
               "** TODO %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%U\n")
              ("b" "blog" entry (file "~/.emacs.d/org-wiki/draft/tech/blog.org")
               "* %?\n   :PROPERTIES:\n   :EXPORT_FILE_NAME: \n   :EXPORT_HUGO_SECTION: posts\n   :EXPORT_DATE: %(format-time-string \"%Y-%m-%d\")\n   :END:\n")
              ("r" "reading" entry (file+headline "~/.emacs.d/org-gtd/personal.org" "Reading")
               "* NEXT %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%U\n%a\n")
              ("n" "note" entry (file "~/.emacs.d/org-gtd/refile.org")
               "* %? :NOTE:\n%U\n%a\n")
              ("i" "idea" entry (file "~/.emacs.d/org-gtd/refile.org")
               "* IDEA %T %?\n")
              ("j" "Journal" entry (file+datetree "~/.emacs.d/org-gtd/diary.org")
               "* %?\n%U\n")
              ("w" "work" entry (file+headline "~/.emacs.d/org-gtd/wish.org" "Tasks")
               "* TODO %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n")
              ("m" "Meeting" entry (file "~/.emacs.d/org-gtd/refile.org")
               "* MEETING with %? :MEETING:\n%U")
              ("p" "Phone call" entry (file "~/.emacs.d/org-gtd/refile.org")
               "* PHONE %? :PHONE:\n%U")
              ("h" "Habit" entry (file "~/.emacs.d/org-gtd/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))


;;; Refile http://doc.norang.ca/org-mode.html#Refiling

; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

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

(require 'ox-latex)
(require 'ox-beamer)

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

(defun my-org-mode-keys ()
  "my keys for `org-mode'"
  (interactive)
  (local-set-key (kbd "<f7>") 'org-clock-in)
  (local-set-key (kbd "<f8>") 'org-clock-out)
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

(with-eval-after-load 'ox
  (require 'ox-hugo))

;; When t (the default), the user is asked before every code block
;; evaluation.  When ‘nil’, the user is not asked.  When set to a
;; function, it is called with two arguments (language and body of the
;; code block ) and should return t to ask and ‘nil’ not to ask.
(setq org-confirm-babel-evaluate nil)


(setq org-agenda-custom-commands
      '(("c" "My agenda view"
         ((tags "PRIORITY={A}"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-Priority tasks:")))
          (agenda "")
          (alltodo "")))))

(require 'org-gcal)
(setq org-gcal-client-id "683892366933-ujh3diskfq7f4oqt1pg8edorl9868752.apps.googleusercontent.com"
      org-gcal-client-secret "o_hbBcEbH9sXN44rHiN4RQEI"
      org-gcal-file-alist '(("account2@gmail.com" .  "~/.emacs.d/gcal.org")))

(provide 'my-org)
(message "Loaded org-mode successfully")
