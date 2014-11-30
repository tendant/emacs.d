;;; Configuration for mu4e mail client, install mu before using it

;; Install mu with mu4e in Mac OSX
;; EMACS=$(which emacs) brew install mu --with-emacs
;; mu index --maildir=~/Maildir
(require 'mu4e)

;; top-level Maildir
(setq mu4e-maildir "~/.Mail")

(setq mu4e-sent-folder "/account3@example.com/sent"
      mu4e-drafts-folder "/account3@example.com/drafts"
      user-mail-address "account3@example.com")



(provide 'my-mail-mu4e)
