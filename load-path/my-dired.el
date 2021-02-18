;; ----------------------- set for dired -------------
;; 进入退出不同 dir 时，不生成新的 dired buffer
(require 'dired-single)
(defun my-dired-init ()
  "Bunch of stuff to run for dired, either immediately or when it's
         loaded."
  ;; <add other stuff here>
  (define-key dired-mode-map [return] 'joc-dired-single-buffer)
  (define-key dired-mode-map [mouse-1] 'joc-dired-single-buffer-mouse)
  (define-key dired-mode-map (kbd ".") 
    '(lambda () 
       (interactive)
       (let ((current-dir (dired-current-directory)))
         (joc-dired-single-buffer "..")
         (dired-goto-file current-dir))))
  (define-key dired-mode-map "^"
    ;;           (lambda nil (interactive) (joc-dired-single-buffer "..")))))
    (lambda nil (interactive) 
      ((dired-jump)
       (revert-buffer)))))

;; if dired's already loaded, then the keymap will be bound
(if (boundp 'dired-mode-map)
    ;; we're good to go; just add our bindings
    (my-dired-init)
  ;; it's not loaded yet, so add our bindings to the load-hook
  (add-hook 'dired-load-hook 'my-dired-init))

;; dired 能删一个目录吗
(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)

;; extend find-dired
(require 'find-dired-)
(require 'find-dired)
(require 'find-dired+)

;; extend dired+
;(require 'dired+)

;; set the default history
(setq find-args-history '(" -name '.svn' -prune -type f -o -name "))


;allow diffing marked dired files using ediff

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

;; dired-dwim-target is a variable defined in `dired.el'. Its value is nil
;; 
;; Documentation: If non-nil, Dired tries to guess a default target
;; directory. This means: if there is a Dired buffer displayed in the
;; next window, use its current directory, instead of this Dired
;; buffer's current directory.
;;
;; The target is used in the prompt for file copy, rename etc.
(setq dired-dwim-target t)


(defun my-dired-mode-hook ()
  (local-set-key "E" 'dired-ediff-marked-files))

(setq dired-listing-switches "-alh")

(add-hook 'dired-mode-hook 'my-dired-mode-hook)

(provide 'my-dired)
(message "Loaded my-dired.el")
