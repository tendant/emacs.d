;; -*- *coding: utf-8 -*-

;;; Check the system types.
(defconst win32p
    (eq system-type 'windows-nt)
  "Are we running on a WinTel system?")

(defconst cygwinp
    (eq system-type 'cygwin)
  "Are we running on a WinTel cygwin system?")

(defconst androidp
  (or (string= system-configuration "arm-unknown-linux-androideabi")
      (string= system-configuration "aarch64-unknown-linux-android")))

(defconst linuxp
    (or (eq system-type 'gnu/linux)
        (eq system-type 'linux))
  "Are we running on a GNU/Linux system?")

(defconst unixp
  (or linuxp
      (eq system-type 'usg-unix-v)
      (eq system-type 'berkeley-unix))
  "Are we running unix")

(defconst mac-osx-p
  (or (eq system-type 'darwin)
      (eq system-type 'macos))
  "Are we running on a mac os system?")

;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Window-Systems.html
(defconst mac-osx-x-p
  (and (display-graphic-p) mac-osx-p)
  "Are we running under window system on a mac os?")

;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Window-Systems.html
(defconst linux-x-p
    (and (display-graphic-p) linuxp)
  "Are we running under X on a GNU/Linux system?")

(defconst xemacsp (featurep 'xemacs)
  "Are we running XEmacs?")

(defconst emacs>=21p (and (not xemacsp) (or (= emacs-major-version 21) (= emacs-major-version 22) (= emacs-major-version 23)))
  "Are we running GNU Emacs 21 or above?")

;; Work around a bug on OS X where system-name is FQDN
(if mac-osx-p
    (setq system-name (car (split-string system-name "\\."))))

;; ID: 6a3f3d99-f0da-329a-c01c-bb6b868f3239
(defmacro measure-time (&rest body)
  "Measure and return the running time of the code block."
  (declare (indent defun))
  (let ((start (make-symbol "start")))
    `(let ((,start (float-time)))
       ,@body
       (- (float-time) ,start))))

(defun debug-time (msg &rest body)
  (message "Time spent on '%s': '%f'." msg 
           (measure-time body)))

(debug-time "all basic"
;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

;; Turn on font-lock mode for Emacs
(global-font-lock-mode t)

;; no bell
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;; splash screen
(setq inhibit-startup-message t)
;; set no tab in indent
(setq-default indent-tabs-mode nil)
(setq default-tab-width 2)
(setq tab-stop-list ())

;; yank point
(setq mouse-yank-at-point t)

;;set default-mode
(setq default-major-mode 'text-mode)

;;cursor avoid
(mouse-avoidance-mode 'animate)

;; blink cursor mode
(blink-cursor-mode)

(setq default-directory "~")

;;
(show-paren-mode t)
(setq show-paren-style 'mixed)

;;ÔÚÐÐÊ× C-k Ê±£¬Í¬Ê±É¾³ý¸ÃÐÐ
(setq-default kill-whole-line t)

;;set frame-title
(setq frame-title-format "emacs@%b")

;; Visual feedback on selections
(setq-default transient-mark-mode t)

;; Always end a file with a newline
;; Documentation:
;; Whether to add a newline automatically at the end of the file.
;; A value of t means do this only when the file is about to be saved.
;; A value of `visit' means do this right after the file is visited.
;; A value of `visit-save' means do it at both of those times.
;; Any other non-nil value means ask user whether to add a newline, when saving.
;; A value of nil means don't add newlines.
(setq require-final-newline nil)
(setq mode-require-final-newline nil)

(add-hook 'after-make-window-system-frame-hooks
          (lambda ()
            ;; Enable wheelmouse support by default for window system
            (mwheel-install)
            ;; disable the tool-bar and menu-bar
            (tool-bar-mode -1)
            (menu-bar-mode -1)
            (scroll-bar-mode -1)))

;; (tool-bar-mode -1)
;; (menu-bar-mode -1)
;; (scroll-bar-mode -1)

;; slow down mouse wheel scroll
(setq mouse-wheel-scroll-amount '(2))
(setq mouse-wheel-progressive-speed nil)

;; À¨ºÅÆ¥Åä
(global-set-key "%" 'match-paren)

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))

(setq kill-ring-max 200)

;; set for the ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-keep-variants nil) ; *nil means prompt to remove
                               ; unmodified buffers A/B/C at session
                               ; end.

;;; ====================== set for global key binding ================
;; upcase selection (C-x C-u) 
(put 'upcase-region 'disabled nil)
;; lowercase selection (C-x C-l)
(put 'downcase-region 'disabled nil)
;(global-set-key (kbd "S-<SPC>") 'set-mark-command)
(global-set-key (kbd "s-u") 'revert-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INSERT A TIMESTAMP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun insert-timestamp ()
  "Insert timestamp at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))
;  (insert (format-time-string "%H:%M")))

(defun insert-fulltimestamp ()
  "Insert timestamp at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))
;  (insert (format-time-string "%H:%M")))

(global-set-key [f10] 'insert-timestamp)
(global-set-key (kbd "M-<f10>") 'insert-fulltimestamp)

(global-set-key [f12] 'org-capture)
 

;; Deprecated, using nxhtml
;; set for AML file
;(add-to-list 'auto-mode-alist '("\\.[Aa][Mm][Ll]\\'" . sgml-mode))
;; set for JSP file 
;(add-to-list 'auto-mode-alist '("\\.[Jj][Ss][Pp]\\'" . sgml-mode))

;;; Begin: for language

;; chiense encoding
;; ;;Prefer not to set language environment as GB. It has been set to UTF-8 in my-basic-config.el
(set-language-environment 'Chinese-GB)
;(setq current-language-environment "UTF-8")
(setq default-input-method "chinese-py") ;; C-\ to switch input method
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; The following stuff added to the file .emacs in your home directory
;; makes GNU Emacs understand utf-8 encoding
(require 'un-define "un-define" t)
(set-buffer-file-coding-system 'utf-8 'utf-8-unix)
(set-default buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)
;; (set-default default-buffer-file-coding-system 'utf-8-unix)

;;; END language setting

;(add-hook 'eshell-mode-hook
;   '(lambda nil
;   (let ((path))
;      (setq path ".")
;      (setq path (concat "C:/username/apps/CommandPromptPortable/bin;" path))
;      (setenv "PATH" path))
;   (local-set-key "\C-u" 'eshell-kill-input))
; )

;(let ((path))
;  (setq path ".")
;  (setq path (concat "C:/username/apps/CommandPromptPortable/bin;" path))
;  (setenv "PATH" path))


;; Configuration for mac osx Leopard
;; If the value of the variable mac-command-key-is-meta is non-nil
;; (its default value), Emacs uses the "command" key as the META
;; key. Otherwise it uses the "option" key as the META key.
;;If you want to use the option key to enter special characters (such as £) instead of functioning as Alt of Meta, you can specify this in your ~/.emacs:
;; (setq mac-option-modifier 'meta) ; Sets the option key as Meta (this is default)
; (setq mac-control-modifier 'meta) ; Sets the control key as Meta
; (setq mac-function-modifier 'meta) ; Sets the function key as Meta (limitations on non-English keyboards)

;; For emacs 23 in mac osx leopard
;; (setq mac-command-modifier 'meta) ; Sets the command key as Meta

;; set grep-find to omit the .svn directory
;;(setq grep-find-command
;(setq find-args-hisotry
;  "find . -path '*/.svn' -prune -o -type f -print | xargs -e grep -I -n -e ")
;; (setenv "GREP_OPTIONS" "--exclude=.#* --exclude=*\~ --exclude=CVS/* --exclude=*/.svn*")

;; NOTE:
;; just go and use M-x global-set-key, then go back and recall that previous command with C-x ESC ESC, to know how to define the key bindings.

;; Convert to Dos or Unix
(defun convert-unix-to-dos ()
  (interactive)
  (set-buffer-file-coding-system 'undecided-dos))

(defun convert-dos-to-unix ()
  (interactive)
  (set-buffer-file-coding-system 'undecided-unix))


(fset 'yes-or-no-p 'y-or-n-p)

;; confirm exit
(setq confirm-kill-emacs 'y-or-n-p)

(message "***** 2")
;;; Customization for psvn.el, The latest version of psvn.el can be
;;; found at: http://www.xsteve.at/prg/emacs/psvn.el
;; Whether `svn-status-update-buffer' should call `svn-status-parse-info'.
(setq svn-status-refresh-info t)
;; Hide unknown files in `svn-status-buffer-name' buffer. This can be
;; toggled with \\[svn-status-toggle-hide-unknown].
(setq svn-status-hide-unknown t)
;; Hide unmodified files in `svn-status-buffer-name' buffer. This can
;; be toggled with \\[svn-status-toggle-hide-unmodified]."
(setq svn-status-hide-unmodified t)

(defun diff-buffer-with-associated-file ()
  "View the differences between BUFFER and its associated file.
This requires the external program \"diff\" to be in your `exec-path'. 
Returns nil if no differences found, 't otherwise."
  (interactive)
  (let ((buf-filename buffer-file-name)
        (buffer (current-buffer)))
    (unless buf-filename
      (error "Buffer %s has no associated file" buffer))
    (let ((diff-buf (get-buffer-create
                     (concat "*Assoc file diff: "
                             (buffer-name)
                             "*"))))
      (with-current-buffer diff-buf
        (setq buffer-read-only nil)
        (erase-buffer))
      (let ((tempfile (make-temp-file "buffer-to-file-diff-")))
        (unwind-protect
            (progn
              (with-current-buffer buffer
                (write-region (point-min) (point-max) tempfile nil 'nomessage))
              (if (zerop
                   (apply #'call-process "diff" nil diff-buf nil
                          (append
                           (when (and (boundp 'ediff-custom-diff-options)
                                      (stringp ediff-custom-diff-options))
                             (list ediff-custom-diff-options))
                           (list buf-filename tempfile))))
                  (progn
                    (message "No differences found")
                    nil)
                (progn
                  (with-current-buffer diff-buf
                    (goto-char (point-min))
                    (if (fboundp 'diff-mode)
                        (diff-mode)
                      (fundamental-mode)))
                  (display-buffer diff-buf)
                  t)))
          (when (file-exists-p tempfile)
            (delete-file tempfile)))))))

(message "Customizing buffer navigation key binds.")
(defun select-next-window ()
  "Switch to the next window" 
  (interactive)
  (select-window (next-window)))

(defun select-previous-window ()
  "Switch to the previous window" 
  (interactive)
  (select-window (previous-window)))

(global-set-key (kbd "M-<right>") 'select-next-window)
(global-set-key (kbd "M-<left>")  'select-previous-window)

;; flyspell, for *nix os. 
(if (not win32p)
    (progn
      (add-hook 'message-mode-hook 'turn-on-flyspell)
      (add-hook 'text-mode-hook 'turn-on-flyspell)
      (add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode)
      (add-hook 'c-mode-common-hook 'flyspell-prog-mode)
      (add-hook 'java-mode-hook 'flyspell-prog-mode)
      (add-hook 'jde-mode-hook 'flyspell-prog-mode)
      (add-hook 'ruby-mode-hook 'flyspell-prog-mode)
      ;; https://lists.gnu.org/archive/html/bug-gnu-emacs/2014-01/msg00840.html
      ;; emacs hangs while deleting comment in xml file with flyspell-mode on
      (add-hook 'nxml-mode-hook
                (lambda ()
                  (flyspell-mode-off)))))


  
;; (defun turn-on-flyspell ()
;;    "Force flyspell-mode on using a positive arg.  For use in hooks."
;;    (interactive)
;;    (if (not win32p)
;;        (flyspell-mode 1)))

;; maximize the emacs in Mac OSX
(defun mac-toggle-max-window ()
  (interactive)
  (if mac-osx-p
      (set-frame-parameter nil 'fullscreen 
                           (if (frame-parameter nil 'fullscreen)
                               nil
                             'fullboth))))

;; On Mac OS X, Emacs sessions launched from the GUI don't always
;; respect your configured $PATH. If Emacs can't find lein, you may
;; need to give it some help. The quickest way is probably to add this
;; elisp to your config:
(if mac-osx-p
    (progn 
      (setenv "PATH" (concat "~/.cargo/bin:"
                             "/opt/local/bin:"
                             (getenv "PATH")))
      (add-to-list 'exec-path "/opt/local/bin")
      (add-to-list 'exec-path "~/.cargo/bin")))

;; Maximize the emacs during startup in Mac OSX
;(mac-toggle-max-window)

;; Winner Mode is a global minor mode. When activated, it allows to
;; “undo” (and “redo”) changes in the window configuration with the
;; key commands ‘C-x left’ and ‘C-x right’. In Emacs 22, these
;; keybindings have been changed to ‘C-c left’ and ‘C-c right’.
(when (fboundp 'winner-mode)
  (winner-mode 1))

(setq outline-minor-mode-prefix [(control o)])

(setq max-lisp-eval-depth 10000) ;; configure the max recursive heap for elisp

(setq large-file-warning-threshold 100000000)


(setq safe-local-variable-values (quote ((*coding . utf-8))))

; Display the time in the Emacs status area (an easy way to test
; that we are picking up our Emacs customizations).
(display-time)
(setq display-time-day-and-date t)

(defun rename-current-file-or-buffer ()
  (interactive)
  (if (not (buffer-file-name))
      (call-interactively 'rename-buffer)
    (let ((file (buffer-file-name)))
      (with-temp-buffer
        (set-buffer (dired-noselect file))
        (dired-do-rename)
        (kill-buffer nil))))
  nil)

(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

(defun transparency-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t,
    decrease the transparency, otherwise increase it in 10%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
          (oldalpha (if alpha-or-nil alpha-or-nil 100))
          (newalpha (if dec (- oldalpha 10) (+ oldalpha 10))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))

;; Set the debug option to enable a backtrace when a
;; problem occurs.
; (setq debug-on-error t)

;; Disabling control-Z from backgrounding emacs 
;; I find emacs' control-Z behavior to be pretty annoying (it backgrounds the program if you're in a shell, or hides the window if you're in X). Add this to your .emacs file:
(global-set-key (kbd "C-z") nil)

;; auto complete
(setq dabbrev-case-fold-search	nil)
(setq dabbrev-case-replace nil)
;; (setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_\\|\\s-")
(setq dabbrev-abbrev-skip-leading-regexp "[^ ]*[<>=.:*]")

;; after copy Ctrl+c in X11 apps, you can paste by `yank' in emacs
(setq x-select-enable-clipboard t)

;; after mouse selection in X11, you can paste by `yank' in emacs
(setq x-select-enable-primary t)

(if (and linuxp (not androidp))
    (setq interprogram-paste-function 'x-cut-buffer-or-selection-value))

(define-key global-map (kbd "RET") 'newline-and-indent)

;; (defun set-newline-and-indent ()
;;   (local-set-key (kbd "RET") 'newline-and-indent))
;; (add-hook 'lisp-mode-hook 'set-newline-and-indent)

(defun toggle-fullscreen ()
  "Toggle full screen for OSX"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

;;; prevent too many split windows opening, prefer splitting window vertically.
;; (setq split-width-threshold (/ (display-pixel-width) 2))
;; (setq split-height-threshold (/ (display-pixel-height) 3))
(setq split-height-threshold nil)
(setq split-width-threshold (/ (display-pixel-width) 2))

;; fix the PATH variable
;; (defun set-exec-path-from-shell-PATH ()
;;   (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PATH'")))
;;     (setenv "PATH" path-from-shell)
;;     (setq exec-path (split-string path-from-shell path-separator))))

;; (if window-system (set-exec-path-from-shell-PATH))

(if (string-equal "darwin" (symbol-name system-type))
    (progn
      (setenv "PATH" (concat (getenv "HOME") "/bin:/usr/local/bin:" (getenv "PATH")))
      (setq exec-path (append (list "/usr/local/bin"
                                    (concat (getenv "HOME") "/bin"))
                              exec-path))
      ;; (setq mac-option-modifier 'super) ; set the Option key as Super
      (setq mac-option-modifier 'meta)
      ;; (setq mac-command-modifier 'meta) ; set the command key as Meta
      (setq mac-command-modifier 'super)
      (eval-after-load "paredit"
        '(progn
           (define-key paredit-mode-map (kbd "<s-left>") 'paredit-forward-barf-sexp)
           (define-key paredit-mode-map (kbd "<s-right>") 'paredit-forward-slurp-sexp))) ; modify the key for paredit mode.
      ))

;; Turn off electric-indent-mode
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

;; Line highlighting/numbering
(global-hl-line-mode 1)
(global-linum-mode 1) ; enable this will cause emacs to hang when opening big org file

(defun nolinum ()
  (interactive)
  (message "Deactivate linum mode")
  ;; (global-linum-mode 0)
  (linum-mode 0))

(add-hook 'org-mode-hook 'nolinum)


;; For dired in mac osx
(setq dired-use-ls-dired nil)

;; delete white space
;; 
;; fixup-whitespace: function fixup white space between objects around
;; point. Leave one space or none, according to the context.
;;
;; delete-indentation: command for joining
;; multiple lines into one line. In your example, put the cursor on
;; the line with "second" and hit M-^ twice. Here are the docs:
;; 
;; M-^ runs the command delete-indentation, which is an interactive compiled Lisp function in simple.el.
;; 
;; It is bound to M-^.
;;
;; (delete-indentation &optional arg)
;; 
;; Join this line to previous and fix up whitespace at join. If there
;; is a fill prefix, delete it from the beginning of this line. With
;; argument, join this line to following line.


;; Avoid outdated byte-compiled elisp files
(setq load-prefer-newer t)


;; Prevent extremely long lines making Emacs slow?
;; https://emacs.stackexchange.com/questions/598/how-do-i-prevent-extremely-long-lines-making-emacs-slow
(setq-default bidi-display-reordering nil)

;; Split window vertically
;; (split-window-right) ; interactive command to open a new buffer and split it vertically.
(setq
   split-width-threshold 260
   split-height-threshold 260)

;; make company-mode to be compatible with TAB
;; https://github.com/company-mode/company-mode/issues/94#issuecomment-365701801
(global-set-key (kbd "TAB") #'company-indent-or-complete-common)

;; disable defautl font setup dialog
(if mac-osx-p
    (global-set-key (kbd "s-t") nil))

(message "Loaded my-basic-config.el")
)
