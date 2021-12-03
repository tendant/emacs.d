(message "Begin loading config-extension.org")

;; This is only needed once, near the top of the file
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))

(setq my-emacs-load-path (concat (file-name-directory (or load-file-name buffer-file-name))))

(message "my-emacs-load-path:")
(message my-emacs-load-path)

(add-to-list 'load-path my-emacs-load-path)

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
(load-theme 'nord t)
(setq nord-comment-brightness 20)
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
    'dired-single-up-directory))

;; if dired's already loaded, then the keymap will be bound
(if (boundp 'dired-mode-map)
    ;; we're good to go; just add our bindings
    (my-dired-init)
  ;; it's not loaded yet, so add our bindings to the load-hook
  (add-hook 'dired-load-hook 'my-dired-init)))


