;; -------------- ido.el -------------------
(require 'filecache)  ;; added file name cache for ido
(require 'ido)
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

(defun file-cache-save-cache-to-file (file)
  "Save contents of `file-cache-alist' to FILE.
For later retrieval using `file-cache-read-cache-from-file'"
  (interactive "FFile: ")
  (with-temp-file (expand-file-name file)
    (prin1 file-cache-alist (current-buffer))))

(defun file-cache-read-cache-from-file (file)
  "Clear `file-cache-alist' and read cache from FILE.
  The file cache can be saved to a file using
  `file-cache-save-cache-to-file'."
  (interactive "fFile: ")
  (file-cache-clear-cache)
  (save-excursion
    (set-buffer (find-file-noselect file))
    (beginning-of-buffer)
    (setq file-cache-alist (read (current-buffer)))
    (kill-buffer (current-buffer))))

;; Using ido to open files from file name cache
(defun file-cache-ido-find-file (file)
  "Using ido, interactively open file from file cache'.
First select a file, matched using ido-switch-buffer against the contents
in `file-cache-alist'. If the file exist in more than one
directory, select directory. Lastly the file is opened."
  (interactive (list (file-cache-ido-read "File: "
                                          (mapcar
                                           (lambda (x)
                                             (car x))
                                           file-cache-alist))))
  (let* ((record (assoc file file-cache-alist)))
    (find-file
     (expand-file-name
      file
      (if (= (length record) 2)
          (car (cdr record))
        (file-cache-ido-read
         (format "Find %s in dir: " file) (cdr record)))))))

(defun file-cache-ido-read (prompt choices)
  (let ((ido-make-buffer-list-hook
	 (lambda ()
	   (setq ido-temp-list choices))))
    (ido-read-buffer prompt)))

;; Change this to filter out your version control files 
(add-to-list 'file-cache-filter-regexps "\\.svn/.*$")

(add-to-list 'file-cache-filter-regexps "*.class")
(add-to-list 'file-cache-filter-regexps "uitests/.*")
(add-to-list 'file-cache-filter-regexps "build/classes/.*")
(add-to-list 'file-cache-filter-regexps "build/testclasses/.*")
(add-to-list 'file-cache-filter-regexps ".*\\.log$")

;; global variable to keep track of current project
(defvar file-cache-current-jde-project nil)

(defun file-cache-get-file-name-for-jde-project ()
  "Get the file-cache for current jde-project"
  (if (stringp file-cache-current-jde-project)
      (progn 
        (setq jde-project-files-name-cache
              (concat (file-name-directory jde-current-project) ".file_cache"))
        (if (file-writable-p jde-project-files-name-cache)
            (concat jde-project-files-name-cache)))))
 
(defun file-cache-change-jde-project ()
  "Reload the file cache for current jde project when the project changes."
  (interactive)
  (if (and (not (string= jde-current-project file-cache-current-jde-project))
           (stringp jde-current-project))
      (progn
        (setq file-cache-current-jde-project jde-current-project)
        (setq jde-project-files-name-cache (file-cache-get-file-name-for-jde-project))
        (if (stringp jde-project-files-name-cache)
              (file-cache-read-cache-from-file jde-project-files-name-cache)
          (message (format "Cannot find the %s file for current jde project!" 
                           jde-project-files-name-cache))))))

(defun file-cache-update-jde-project ()
  "Update current jde project file cache."
  (interactive)
  (if (stringp file-cache-current-jde-project)
      (progn
        (setq jde-project-files-name-cache (file-cache-get-file-name-for-jde-project))
        (if (stringp jde-project-files-name-cache)
            (progn
              (file-cache-clear-cache)
              (file-cache-add-directory-using-find 
               (directory-file-name 
                (file-name-directory jde-project-files-name-cache)))
              (file-cache-save-cache-to-file jde-project-files-name-cache)
              (message (format "Files name cache have been updated in %s." jde-project-files-name-cache)))))))

;; from http://www.emacswiki.org/emacs/ImenuMode
(defun ido-goto-symbol ()
  "Will update the imenu index and then use ido to select a symbol to navigate to"
  (interactive)
  (imenu--make-index-alist)
  (let ((name-and-pos '())
        (symbol-names '()))
    (flet ((addsymbols (symbol-list)
                       (when (listp symbol-list)
                         (dolist (symbol symbol-list)
                           (let ((name nil) (position nil))
                             (cond
                              ((and (listp symbol) (imenu--subalist-p symbol))
                               (addsymbols symbol))
                              
                              ((listp symbol)
                               (setq name (car symbol))
                               (setq position (cdr symbol)))
                              
                              ((stringp symbol)
                               (setq name symbol)
                               (setq position (get-text-property 1 'org-imenu-marker symbol))))
                             
                             (unless (or (null position) (null name))
                               (add-to-list 'symbol-names name)
                               (add-to-list 'name-and-pos (cons name position))))))))
      (addsymbols imenu--index-alist))
    (let* ((selected-symbol (ido-completing-read "Symbol? " symbol-names))
           (position (cdr (assoc selected-symbol name-and-pos))))
      (cond
       ((overlayp position)
        (goto-char (overlay-start position)))
       (t
        (goto-char position))))))

(defun helloworld ()
  "Hello world description."
  (interactive)
  (message "Hello world!"))

;; do not enable tramp completion with ido 
(setq ido-enable-tramp-completion nil)
 
;; add the hook for jde project...
(add-hook 'jde-project-hooks 'file-cache-change-jde-project)

;; Configure the key bind for opening file in file name cache, change
;; it according to your own perferences.
(global-set-key "\C-xg" 'file-cache-ido-find-file)

;; Stop ido temporarily
;; You can either press C-j to accept what you have typed so far, or C-f which will drop you into regular find-file

;; disable automatic file search in ido mode
;; https://stackoverflow.com/questions/17986194/emacs-disable-automatic-file-search-in-ido-mode
(setq ido-auto-merge-work-directories-length -1)

(provide 'my-ido)
(message "Loaded my-ido.el")
