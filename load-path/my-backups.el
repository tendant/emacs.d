;;backups.el
(require 'backups)
(move-backups t)
(setq backup-directory "~/.emacs.d/backup")


(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))
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

(provide 'my-backups)
(message "Loaded backups")