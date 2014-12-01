;;; Configuration for mu4e mail client, install mu before using it

;; Install mu with mu4e in Mac OSX
;; EMACS=$(which emacs) brew install mu --with-emacs
;; mu index --maildir=~/Maildir
(require 'mu4e)
;; top-level Maildir
(setq mu4e-maildir "~/.Mail")

(setq mu4e-sent-folder "/account2@gmail.com/sent" ;; folder for sent messages
      mu4e-drafts-folder "/account2@gmail.com/drafts" ;; unfinished messages
      mu4e-trash-folder "/account2@gmail.com/trash" ;; trashed messages
      mu4e-refile-folder "/account2@gmail.com/archive" ;; saved messages
      user-mail-address "account2@gmail.com")

;; enable inline images
(setq mu4e-view-show-images t)
;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

;; emacs 24.4 and later versions include the eww browser which uses
;; the shr html renderer; mu4e includes a little snippet to uses this
;; with mu4e-html2text-command; for this, add the following to your
;; configuration:
;; 
;; Add below function temporarily, since this function is not released
;; in mu4e yet. It is only available in master.
(defun mu4e-shr2text () 
  "Html to text using the shr engine; this can be used in 
`mu4e-html2text-command' in a new enough emacs. Based on code by 
Titus von der Malsburg." 
  (interactive) 
  (let ((dom (libxml-parse-html-region (point-min) (point-max))) 
        (shr-inhibit-images t)) 
    (erase-buffer) 
    (shr-insert-document dom) 
    (goto-char (point-min)))) 

(require 'mu4e-contrib)
(setq mu4e-html2text-command 'mu4e-shr2text)

(provide 'my-mail-mu4e)
