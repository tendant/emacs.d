;; Configuration for mu4e mail client, install mu before using it

;; Install mu with mu4e in Mac OSX
;; EMACS=$(which emacs) brew install mu --with-emacs
;; mu index --maildir=~/Maildir

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e")
(require 'mu4e)
;; top-level Maildir
(setq mu4e-maildir "~/.Maildir")
(setq mu4e-get-mail-command "true") ; not fetch mail using mu4e
;; (setq mu4e-get-mail-command "mbsync -aV")  ; using mbsync to fetch mail
(setq mu4e-update-interval 300) ; update every 300 seconds

;; mbsync error: UID is beyond highest assigned UID
(setq mu4e-change-filenames-when-moving t)

;; Set mu4e as default mail agent
(setq mail-user-agent 'mu4e-user-agent)

;;  If you want to use queued mail, you should create this directory
;;  before starting mu4e. The mu mkdir command may be useful here, so
;;  for example:
;;
;;   $ mu mkdir ~/.Maildir/queue
;;   $ touch ~/.Maildir/queue/.noindex
;;
;; WARNING: when you switch on queued-mode, your messages won’t reach
;; their destination until you switch it off again; so, be careful not
;; to do this accidentally!
;;
;; (setq smtpmail-queue-mail t ;; start in queuing mode
;;      smtpmail-queue-dir  "~/.Maildir/queue/cur")

(defun smtpmail-online ()
  "Switch online mode and send queued email immediately"
  (interactive)
  (setq smtpmail-queue-mail nil)
  (smtpmail-send-queued-mail))

(defun smtpmail-queue ()
  "Queue all outgoing emails"
  (interactive)
  (setq smtpmail-queue-mail t ;; start in queuing mode
        smtpmail-queue-dir  "~/.Maildir/queue/cur"))

(setq mu4e-view-show-addresses t)

(setq mu4e-compose-signature-auto-include nil)

(setq mu4e-compose-dont-reply-to-self t)

;; Enable to view message in browser: aV
(add-to-list 'mu4e-view-actions
  '("ViewInBrowser" . mu4e-action-view-in-browser) t)

(setq mu4e-contexts
    `( ,(make-mu4e-context
	  :name "account1@gmail.com"
	  :enter-func (lambda () (mu4e-message "Entering context: account1@gmail.com"))
          :leave-func (lambda () (mu4e-message "Leaving context: account1@gmail.com"))
	  ;; we match based on the contact-fields of the message
	  :match-func (lambda (msg)
                        (message "match-func: account1")
                        (when msg
                          (if (mu4e-message-contact-field-matches msg
                                                                  '(:to :from :cc :bcc) "account1@gmail.com")
                              (message "MATCHED: account1"))
                          (message "match-func: account1 end")
                          (mu4e-message-contact-field-matches msg
                                                              '(:to :from :cc :bcc) "account1@gmail.com")))
	  :vars '( ( user-mail-address	    . "account1@gmail.com"  )
		   ( user-full-name	    . "Your Name" )
                   ( mu4e-sent-folder       . "/gmail-account1/Sent")
                   ( mu4e-drafts-folder     . "/gmail-account1/Drafts")
                   ( mu4e-trash-folder      . "/gmail-account1/Trash")
                   ;; ( mu4e-refile-folder     .  "/archive")
		   ( mu4e-compose-signature .
		     (concat
		       "Best,\n"
		       "Your Name\n")))))
       ,(make-mu4e-context
	  :name "account2@gmail.com"
	  :enter-func (lambda () (mu4e-message "Switch to context: account2@gmail.com"))
	  :leave-func (lambda () (mu4e-message "Leaving context: account2@gmail.com"))
	  :match-func (lambda (msg)
                        (message "match-func: your-nick: ")
                        (when msg
                          (if (mu4e-message-contact-field-matches msg
                                                                  '(:to :from :cc :bcc) "account2@gmail.com")
                              (message "MATCHED: your-nick"))
                          (message "match-func: your-nick end")
			  (mu4e-message-contact-field-matches msg
			                                      '(:to :from :cc :bcc) "account2@gmail.com")))
	  :vars '( ( user-mail-address	     . "account2@gmail.com" )
		   ( user-full-name	     . "Your Name" )
                   ( mu4e-sent-folder       . "/gmail-your-nick/Sent")
                   ( mu4e-drafts-folder     . "/gmail-your-nick/Drafts")
                   ( mu4e-trash-folder      . "/gmail-your-nick/Trash")
		   ( mu4e-compose-signature  .
		     (concat
		       "Your Name"))))

       ,(make-mu4e-context
	  :name "account3@example.com"
	  :enter-func (lambda () (mu4e-message "Switch to context: account3@example.com"))
	  :leave-func (lambda () (mu4e-message "Leaving context: account3@example.com"))
	  :match-func (lambda (msg)
                        (message "match-func: wish")
                        (when msg
                          (if (mu4e-message-contact-field-matches msg
                                                                  '(:to :from :cc :bcc) "account3@example.com")
                              (message "MATCHED: wish"))
                          (message "match-func: wish end")
			  (mu4e-message-contact-field-matches msg
			    '(:to :from :cc :bcc) "account3@example.com")))
	  :vars '( ( user-mail-address	     . "account3@example.com" )
		   ( user-full-name	     . "Your Name" )
                   ( mu4e-sent-folder       . "/account3/Sent")
                   ( mu4e-drafts-folder     . "/account3/Drafts")
                   ( mu4e-trash-folder      . "/account3/Trash")
		   ( mu4e-compose-signature  . (concat "Best,\n"
                                                       "Your Name"))))))

;; set `mu4e-context-policy` and `mu4e-compose-policy` to tweak when mu4e should
;; guess or ask the correct context, e.g.

;; start with the first (default) context;
;; default is to ask-if-none (ask when there's no context yet, and none match)
(setq mu4e-context-policy 'ask-if-none)

;; compose with the current context is no context matches;
;; default is to ask
;; (setq mu4e-compose-context-policy 'ask-if-none)
(setq mu4e-compose-context-policy nil)

;; enable inline images
(setq mu4e-view-show-images t)

;; (setq mu4e-msg2pdf "~/bin/msg2pdf")

;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

(setq mu4e-attachment-dir  "~/Downloads")

;; (defconst message-cite-style-gmail
;;   '((message-cite-function          'message-cite-original)
;;     (message-citation-line-function 'message-insert-formatted-citation-line)
;;     (message-cite-reply-position    'above)
;;     (message-yank-prefix            "    ")
;;     (message-yank-cited-prefix      "    ")
;;     (message-yank-empty-prefix      "    ")
;;     (message-citation-line-format   "On %e %B %Y %R, %f wrote:\n"))
;;   "Message citation style used by Gmail. Use with `message-cite-style'.")

;; (with-eval-after-load 'message
;;   (setq message-cite-style message-cite-style-gmail))

(setq message-cite-reply-position 'above)

(setq mu4e-enable-mode-line t)

(add-hook 'mu4e-view-mode-hook
  (lambda()
    ;; try to emulate some of the eww key-bindings
    (local-set-key (kbd "<tab>") 'shr-next-link)
    (local-set-key (kbd "<backtab>") 'shr-previous-link)))


;;store org-mode links to messages
(require 'org-mu4e)
;;store link to message if in header view, not to header query
(setq org-mu4e-link-query-in-headers-mode nil)

;; ;; emacs 24.4 and later versions include the eww browser which uses
;; ;; the shr html renderer; mu4e includes a little snippet to uses this
;; ;; with mu4e-html2text-command; for this, add the following to your
;; ;; configuration:
;; ;;
;; ;; Add below function temporarily, since this function is not released
;; ;; in mu4e yet. It is only available in master.
;; ;; https://groups.google.com/forum/#!topic/mu-discuss/gr1cwNNZnXo
;; (defun mu4e-shr2text ()
;;   "Html to text using the shr engine; this can be used in
;; `mu4e-html2text-command' in a new enough emacs. Based on code by
;; Titus von der Malsburg."
;;   (interactive)
;;   (let ((dom (libxml-parse-html-region (point-min) (point-max)))
;;         (shr-inhibit-images t))
;;     (erase-buffer)
;;     (shr-insert-document dom)
;;     (goto-char (point-min))))

;; (require 'mu4e-contrib)
;; (setq mu4e-html2text-command 'mu4e-shr2text)

;; alert
(if mac-osx-p
    (setq mu4e-alert-set-default-style 'osx-notifier))
;; Enable alert
(add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
;; Enable mode line alert
(add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)

(provide 'my-mail-mu4e)
