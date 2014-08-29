(setq my-emacs-load-path (concat (file-name-directory (or load-file-name buffer-file-name))))
(setq my-cedet-path (concat my-emacs-load-path "cedet-1.1"))
(add-to-list 'load-path (concat my-cedet-path "/common"))
(add-to-list 'load-path (concat my-cedet-path "/semantic"))
(add-to-list 'load-path (concat my-cedet-path "/speedbar"))
(add-to-list 'load-path (concat my-cedet-path "/eidio"))
(add-to-list 'load-path (concat my-cedet-path "/cogre"))
(add-to-list 'load-path (concat my-cedet-path "/ede"))
;; (add-to-list 'load-path "~/.emacs.d/load-path/elib-1.0") ; not needed anymore.
(load-file (concat my-cedet-path "/common/cedet.el"))
(load-file (concat my-cedet-path "/semantic/bovine/semantic-java.el"))

(add-to-list 'load-path (concat my-emacs-load-path "jdee-2.4.1/lisp"))

;; If you want Emacs to defer loading the JDE until you open a 
;; Java file, edit the following line
(setq defer-loading-jde nil)
;; to read:
;;
;;  (setq defer-loading-jde t)
;;
(if defer-loading-jde
    (progn
      (autoload 'jde-mode "jde" "JDE mode." t)
      (setq auto-mode-alist
            (append
             '(("\\.java\\'" . jde-mode))
             auto-mode-alist)))
  (progn
    (require 'jde)
    (require 'jde-help))
  )

;; disable check CEDET version
(setq jde-check-version-flag nil)

;;; Global Setting
(setq gud-gdb-command-name "gdb --annotate=1")
(setq jde-compiler (quote ("javac" "")))
(setq jde-debugger (quote ("jdb")))

(setq jde-enable-senator nil)
;; The JDEE uses the browsers or browsers specified by the
;; customization variable browse-url-browser-funcion
(setq jde-help-browser-function 'w3m-browse-url)

(if linuxp 
    (progn
      (setq jde-global-classpath 
          (quote ("/usr/local/jdk1.6.0_29/lib/tools.jar")))
      (setq jde-jdk-registry 
            (quote (("1.6" . "/usr/local/jdk1.6.0_29"))))
      (setq jde-jdk-doc-url "")
      (setq jde-jdk (quote ("1.6")))
      ))
(if mac-osx-p 
    (progn
      (setq jde-global-classpath 
            (quote ("/System/Library/Frameworks/JavaVM.framework/Classes/classes.jar")))
      (setq jde-jdk-registry 
            (quote (("1.5" . "/System/Library/Frameworks/JavaVM.framework/Versions/1.5"))))
      (setq jde-jdk (quote ("1.5")))
      ))


(setq jde-built-class-path (quote ("./build/classes")))
(setq jde-sourcepath (quote  ("./src" "./test")))


;;; Project Specific Setting, should be put into correspondingly prj.el
;(setq jde-sourcepath 
;      (quote ("/Users/lwang/Workspaces/workspace/V4-trunk/src")))
;(setq jde-db-sourcepath 
;      (quote ("/Users/lwang/Workspaces/workspace/V4-trunk/src")))
;(setq jde-db-option-connect-socket (quote ("localhost" "5005"))) The
;; JDEE customization variable jde-db-option-attach-address allows you
;; to specify a default debuggee address. If you set this variable,
;; the JDEE does not prompt you to enter an address.
;; (setq jde-db-option-connect-socket "5005")
(setq jde-db-option-connect-socket nil)

;;; Read jde project values from eclipse .classpath config file
 ;; (defun jde-load-project-values-from-eclipse-config-file (cp)
 ;; "Read jde project values from eclipse .classpath config file"
 ;;   (interactive "f")
 ;;   (setq cp (xml-parse-file cp))
 
 ;;   (let (src-path class-path)
 ;;     (walk-classpath-xml (lambda (type path ex) 
 ;;                           (setq path (if (file-name-absolute-p path)
 ;;                                          path
 ;;                                        (concat "./" path)))
 ;;                           (if (not ex)
 ;;                               (cond 
 ;;                                ((equal type "src")
 ;;                                 (setq src-path (cons path src-path)))
 ;;                                ((or (equal type "lib") 
 ;;                                     (equal type "output") 
 ;;                                     (equal type "var"))
 ;;                                 (setq class-path (cons path class-path)))
 ;;                                )))
 ;;                         cp)
 ;;     (setq jde-global-classpath class-path)
 ;;     (setq jde-sourcepath src-path)))

 ;; (defun walk-classpath-xml (f e) 
 ;;   (if (listp e)
 ;;       (if  (eq (car e) 'classpathentry)
 ;;           (let ((entry (cadr e)))
 ;;             (funcall f (cdr (assoc 'kind entry)) (cdr (assoc 'path entry)) (assoc 'excluding entry)))
 ;;         (mapc (lambda (x) (walk-classpath-xml f x)) e))))


(require 'java-mode-indent-annotations)

;; define indent as 2 spaces.
(defun my-jde-mode-hook ()
  (c-add-style
    "my-java"
    '("java"
      (c-basic-offset . 2)
      (c-offsets-alist 
       . ((inexpr-class . 0)))    ;; No indention for the class is inside an
                                  ;; expression.  Used e.g. for java
                                  ;; anonymous classes.
       ))
  (c-set-style "my-java")
  (message "my-java style!")
  ;; Indetation for Java 5 annotations.
  (java-mode-indent-annotations-setup)
  ;; configure the key for code completion
  (local-set-key "\M-t" 'jde-complete)
  (local-set-key [f5] 'jdibug-step-into)
  (local-set-key [f6] 'jdibug-step-over)
  (local-set-key [f7] 'jdibug-step-out)
  (local-set-key [f8] 'jdibug-resume)
  )

(add-hook 'jde-mode-hook 'my-jde-mode-hook)
;(add-hook 'jde-mode-hook 'java-mode-indent-annotations-setup)

;; using semanticd to expand
;(setq semanticdb-project-roots 
;      (list
;       (expand-file-name "/")))

;(autoload 'senator-try-expand-semantic "senator")

;(setq hippie-expand-try-functions-list
;      '(
;        senator-try-expand-semantic
;        try-expand-dabbrev
;        try-expand-dabbrev-visible
;        try-expand-dabbrev-all-buffers
;        try-expand-dabbrev-from-kill
;        try-expand-list
;        try-expand-list-all-buffers
;        try-expand-line
;        try-expand-line-all-buffers
;        try-complete-file-name-partially
;        try-complete-file-name
;        try-expand-whole-kill
;        ))


;; Something that might annoy you under certain X window managers
;; (WindowMaker?, for example) and in Carbon Emacs when speedbar
;; starts is that it’s window will appear to have focus but keyboard
;; input goes to the original Emacs window. You can make things look
;; right again by defining this mode hook before starting speedbar: If
;; this fails, you can call other-frame right after you call speedbar.
 ;; (setq speedbar-mode-hook '(lambda ()
 ;;    (interactive)
 ;;    (other-frame 0)))


;;; The default behavior of speedbar is to create a second emacs
;;; frame, separate from the main editing frame. As with all things
;;; emacs, this default behavior can be modified so that no separate
;;; frame is created, and the speedbar becomes just another buffer
;;; within a single emacs frame.  
;;; 
;;; The following function will only work with the latest versions of
;;; speedbar (I have tested it with the version that comes bundled as
;;; part of cedet-1.0beta2a):
;;   (require 'speedbar)
;;   (defconst my-speedbar-buffer-name "SPEEDBAR")
;;   ; (defconst my-speedbar-buffer-name " SPEEDBAR") ; try this if you get "Wrong type argument: stringp, nil"

;; (defun speedbar-no-separate-frame ()
;;   (interactive)
;;   (when (not (buffer-live-p speedbar-buffer))
;;     (setq speedbar-buffer (get-buffer-create my-speedbar-buffer-name)
;;           speedbar-frame (selected-frame)
;;           dframe-attached-frame (selected-frame)
;;           speedbar-select-frame-method 'attached
;;           speedbar-verbosity-level 0
;;           speedbar-last-selected-file nil)
;;     (set-buffer speedbar-buffer)
;;     (speedbar-mode)
;;     (speedbar-reconfigure-keymaps)
;;     (speedbar-update-contents)
;;     (speedbar-set-timer 1)
;;     (make-local-hook 'kill-buffer-hook)
;;     (add-hook 'kill-buffer-hook
;;               (lambda () (when (eq (current-buffer) speedbar-buffer)
;;                            (setq speedbar-frame nil
;;                                  dframe-attached-frame nil
;;                                  speedbar-buffer nil)
;;                            (speedbar-set-timer nil)))))
;;   (set-window-buffer (selected-window) 
;;                      (get-buffer my-speedbar-buffer-name)))

;(setq jde-enable-abbrev-mode t)

;; customized the mode-line for jde-mode, just copied from
;; jde-which-method.el, and added `mode-line-modes' into it. 

(setq jde-mode-line-format 
  '("-" 
    mode-line-mule-info
    mode-line-modified
    mode-line-frame-identification
    mode-line-buffer-identification
    "  "
    global-mode-string
    mode-line-modes
;; removed below line, because it is duplicated with mode-line-modes
;    "   %[(" mode-name mode-line-process minor-mode-alist "%n" ")%]--"
    (line-number-mode "L%l--")
    (column-number-mode "C%c--")
    (-3 . "%p")
    (jde-which-method-mode
     ("--" jde-which-method-format "--"))
    "-%-"))

(provide 'my-jde)
(message "Loaded my-jde.el")
