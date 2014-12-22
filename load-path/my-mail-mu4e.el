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

;; my-mu4e-account-alist will be redefined by loading ~/.authinfo.el file.
(defvar my-mu4e-account-alist
  '(("Account1"
     (mu4e-sent-folder "/Account1/Saved Items")
     (mu4e-drafts-folder "/Account1/Drafts")
     (user-mail-address "my.address@account1.tld")
     (smtpmail-default-smtp-server "smtp.account1.tld")
     (smtpmail-local-domain "account1.tld")
     (smtpmail-smtp-user "username1")
     (smtpmail-smtp-server "smtp.account1.tld")
     (smtpmail-stream-type starttls)
     (smtpmail-smtp-service 25))
    ("Account2"
     (mu4e-sent-folder "/Account2/Saved Items")
     (mu4e-drafts-folder "/Account2/Drafts")
     (user-mail-address "my.address@account2.tld")
     (smtpmail-default-smtp-server "smtp.account2.tld")
     (smtpmail-local-domain "account2.tld")
     (smtpmail-smtp-user "username2")
     (smtpmail-smtp-server "smtp.account2.tld")
     (smtpmail-stream-type starttls)
     (smtpmail-smtp-service 587))))

(defun my-mu4e-set-account ()
  "Set the account for composing a message."
  (require 'authinfo "~/.authinfo.el") ; load my-mu4e-account-alist from private file
  (let* ((account
          (if mu4e-compose-parent-message
              (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
                (string-match "/\\(.*?\\)/" maildir)
                (match-string 1 maildir))
            (completing-read (format "Compose with account: (%s) "
                                     (mapconcat #'(lambda (var) (car var))
                                                my-mu4e-account-alist "/"))
                             (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
                             nil t nil nil (caar my-mu4e-account-alist))))
         (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
        (mapc #'(lambda (var)
                  (set (car var) (cadr var)))
              account-vars)
      (error "No email account found"))))

(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

;; enable inline images
(setq mu4e-view-show-images t)

(setq mu4e-get-mail-command "true") ; not fetch mail using mu4e
;; (setq mu4e-get-mail-command "mbsync -a")  ; using mbsync to fetch mail
(setq mu4e-update-interval 180) ; update every 180 seconds

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
;; https://groups.google.com/forum/#!topic/mu-discuss/gr1cwNNZnXo
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
