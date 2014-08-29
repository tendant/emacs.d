(message "Loading org-mode")

(setq my-emacs-load-path (concat (file-name-directory (or load-file-name buffer-file-name))))

(add-to-list 'load-path (concat my-emacs-load-path "org-mode/lisp"))
(add-to-list 'load-path (concat my-emacs-load-path "org-mode/contrib/lisp"))

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

(setq org-agenda-files (file-expand-wildcards "~/.emacs.d/org-gtd/*.org"))

(defun org-all ()
  (interactive)
  (setq org-agenda-files 
        (list
         "~/.emacs.d/org-gtd/sfsf.org"
         "~/.emacs.d/org-gtd/personal.org"
         ))
  (org-agenda-redo))

(defun org-work ()
  (interactive)
  (setq org-agenda-files 
        (list
         "~/.emacs.d/org-gtd/sfsf.org"
         ))
  (org-agenda-redo))

(defun org-life ()
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
;; #+SEQ_TODO: TODO(t) STARTED(!) WAITING(w@/!) DELEGATED(l!) APPT | DONE(d!) DEFERRED(D!) CANCELLED(c@)
(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(!)" "WAITING(w@/!)" "DELEGATED(l!)" "APPT" "|" "DONE(d!)" "CANCELED(c@)")))

(define-key global-map [(f9)] 'org-agenda)

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

(add-to-list 'file-coding-system-alist (cons "\\.org$"  'utf-8))


;;; Configuration of Remember
(setq org-directory "~/.emacs.d/org-gtd/")
(setq org-default-notes-file "~/.emacs.d/org-gtd/notes.org")
;; (setq remember-annotation-functions '(org-remember-annotation))
;; (setq remember-handler-functions '(org-remember-handler))
;; (add-hook 'remember-mode-hook 'org-remember-apply-template)
;; ;; (define-key global-map "\C-cr" 'org-remember)
;; ;; templates
;; (setq org-remember-templates
;;      '(("Todo" ?t "* TODO %? %^g\n %i\n " "~/.emacs.d/org-gtd/personal.org" "Tasks")
;;       ("Journal" ?j "\n* %^{topic} %T \n%i%?\n" "~/.emacs.d/org-gtd/personal.org" "Journal")
;;       ("Book" ?b "\n* %^{Book Title} %t :READING: \n%\n" 
;;               "~/.emacs.d/org-gtd/personal.org" "Book")
;;       ("Contact" ?c "\n* %^{Name} :CONTACT:\n%\n" 
;;                "~/.emacs.d/org-gtd/personal.org" "Contact")
;;       ("Work" ?w "* TODO %? %^g\n %i\n " "~/.emacs.d/org-gtd/sfsf.org" "Tasks")
;;       ))

(setq org-capture-templates
     '(("t" "Todo" entry (file+headline "~/.emacs.d/org-gtd/personal.org" "Tasks") "* TODO %? %^g\n CREATED: %U %i\n ")
       ("j" "Journal" entry (file+datetree "~/.emacs.d/org-gtd/personal.org") "* %?\nEntered on %U\n %i\n  %a")
       ("b" "Book" entry (file+headline "~/.emacs.d/org-gtd/personal.org" "Book") "\n* %^{Book Title} \n Entered on %U\n :READING: \n%\n")
       ("c" "Contact" entry (file+headline "~/.emacs.d/org-gtd/personal.org" "Contact") "\n* %^{Name} :CONTACT:\n%\n")
       ("w" "Work" entry (file+headline "~/.emacs.d/org-gtd/sfsf.org" "Tasks") "* TODO %? %^g\n CREATED: %U\n%i\n ")
       ("h" "HANA" entry (file+headline "~/.emacs.d/org-gtd/sfsf.org" "HANA") "* %? %^g\n CREATED: %U\n%i\n ")
      ))

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
         :base-directory "~/Documents/myblog/org/"
         :base-extension "org"
         
         ;; Path to your Jekyll project.
         :publishing-directory "~/Documents/myblog/jekyll/"
         :recursive t
         :publishing-function org-publish-org-to-html
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
(require 'cdlatex)
(require 'texmathp)
(add-hook 'org-mode-hook 'turn-on-org-cdlatex)
(setq org-format-latex-options 
      '(:foreground default 
                    :background default 
                    :scale 1.2
                    :html-foreground "Black" 
                    :html-background "Transparent" 
                    :html-scale 1.2
                    :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
(setq org-export-with-LaTeX-fragments t)

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

(provide 'my-org)
(message "Loaded org-mode successfully")