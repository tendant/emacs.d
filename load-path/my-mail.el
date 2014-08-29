(require 'notmuch)
(setq notmuch-search-oldest-first nil)

;; When starting notmuch, a list of saved searches and message counts
;; is displayed, replacing the older notmuch-folders command. The set
;; of saved searches displayed can be modified directly from the
;; notmuch interface (using the [save] button next to a previous
;; search) or by customising the variable notmuch-saved-searches.
;;;
;; you can have any number of saved searches, each configured with any
;; supported search terms (see "notmuch help search-terms").
(setq notmuch-saved-searches '(("Doing" . "tag:Doing")
                               ("SAP" . "tag:sap AND not tag:deleted AND tag:unread")
                               ("Wanglei" . "tag:wanglei AND not tag:deleted AND tag:unread")
                               ("your-nick" . "tag:your-nick AND not tag:deleted AND tag:unread")
                               ("TODO" . "tag:TODO and not tag:deleted")
                               ("unread" . "tag:inbox AND tag:unread AND not tag:deleted")
                               ("Later" . "tag:Later and not tag:deleted")
                               ("inbox" . "tag:inbox AND not tag:deleted")
                               ("Algorithm" . "tag:algorithm AND not tag:deleted")
                               ))


(define-key notmuch-show-mode-map "L"
  (lambda ()
    "toggle Later tag for message"
    (interactive)
    (notmuch-show-tag
     (if (member "Later" (notmuch-show-get-tags))
         "-Later" "+Later"))))

(define-key notmuch-show-mode-map "T"
  (lambda ()
    "toggle TODO tag for message"
    (interactive)
    (notmuch-show-tag
     (if (member "TODO" (notmuch-show-get-tags))
         '("-TODO" "+DONE")
       '("+TODO" "-DONE")
       ))))

(define-key notmuch-show-mode-map "D"
  (lambda ()
    "toggle DONE tag for message"
    (interactive)
    (notmuch-show-tag
     (if (member "DONE" (notmuch-show-get-tags))
         "-DONE" "+DONE"))))

(define-key notmuch-show-mode-map "I"
  (lambda ()
    "toggle doIng tag for message"
    (interactive)
    (notmuch-show-tag
     (if (member "Doing" (notmuch-show-get-tags))
         "-Doing" "+Doing"))))

(define-key notmuch-show-mode-map "F"
  (lambda ()
    "toggle flagged tag for message"
    (interactive)
    (notmuch-show-tag
     (if (member "flagged" (notmuch-show-get-tags))
         "-flagged" "+flagged"))))

(define-key notmuch-show-mode-map "d"
  (lambda ()
    "toggle deleted tag for message"
    (interactive)
    (notmuch-show-tag
     (if (member "deleted" (notmuch-show-get-tags))
         "-deleted" "+deleted"))))

(define-key notmuch-search-mode-map "L"
  (lambda ()
    "toggle Later tag for message"
    (interactive)
    (notmuch-search-tag
     (if (member "Later" (notmuch-search-get-tags))
         "-Later" "+Later"))))

(define-key notmuch-search-mode-map "T"
  (lambda ()
    "toggle TODO tag for message"
    (interactive)
    (notmuch-search-tag
     (if (member "TODO" (notmuch-search-get-tags))
         "-TODO" "+TODO"))))

(define-key notmuch-search-mode-map "D"
  (lambda ()
    "toggle DONE tag for message"
    (interactive)
    (notmuch-search-tag
     (if (member "DONE" (notmuch-search-get-tags))
         "-DONE" "+DONE"))))

(define-key notmuch-search-mode-map "I"
  (lambda ()
    "toggle Doing tag for message"
    (interactive)
    (notmuch-search-tag
     (if (member "Doing" (notmuch-search-get-tags))
         "-Doing" "+Doing"))))

(define-key notmuch-search-mode-map "F"
  (lambda ()
    "toggle flagged tag for message"
    (interactive)
    (notmuch-search-tag
     (if (member "flagged" (notmuch-search-get-tags))
         "-flagged" "+flagged"))))

(define-key notmuch-search-mode-map "d"
  (lambda ()
    "toggle delete tag for message"
    (interactive)
    (notmuch-search-tag
     (if (member "deleted" (notmuch-search-get-tags))
         "-deleted" "+deleted"))))

(require 'notmuch-address)
(setq notmuch-address-command "~/emacs.d/load-path/notmuch_addresses.py")
(notmuch-address-message-insinuate)

;;; configuration for message-mode

;; One annoying standard configuration of message mode is that it will
;; hide the sent mail in your emacs frame stack, but it will not close
;; it. If you type several mails in an emacs session they will
;; accumulate and make switching between buffers more annoying. You
;; can avoid that behavior by adding (setq message-kill-buffer-on-exit
;; t) in your .emacs file (or doing M-x
;; customize-variable<RET>message-kill-buffer-on-exit<RET>) which will
;; really close the mail window after sending it.
(setq message-kill-buffer-on-exit t)

;;; configuration for smtpmail
(load-library "smtpmail")

;;; Begin configure SMTP 
;;; Copied from http://rsw.digi.com.br/blog/2008/01/21/gnus-gmail-part-ii-adding-multiple-smtp-accounts/
;;; and http://www.emacswiki.org/cgi-bin/wiki/MultipleSMTPAccounts
;; Available SMTP accounts.
(defvar smtp-accounts
  '(
    ;; real information will be find in ~/.authinfo.el file.
    ;; (type-plain address user password server port)
    ;; (type-ssl address user password server port key cert)
    (ssl "account2@gmail.com" "account2@gmail.com" "password" "smtp.gmail.com" 587 "key" nil)
    ))
;; This lists my SMTP accounts, one line for each server

;; http://emacswiki.org/emacs/MultipleSMTPAccounts
;;;
;; You may have to consider two more variables if your MTA checks your
;; mail address specified in “MAIL FROM:” SMTP header line to decide
;; whether you are allowed to send mail (Exchange does this). By
;; default ‘smtpmail-mail-address’ is used if it is specified,
;; otherwise ‘user-mail-address’. However, you probably don’t set
;; ‘smtpmail-mail-address’ and your ‘user-mail-address’ contains
;; your default e-mail address that is different from the one you use
;; for a particular SMTP server. If you want to direct smtpmail.el to
;; use the From field of the mail, set ‘mail-specify-envelope-from’
;; to t and ‘mail-envelope-from’ to header.

;; Default smtpmail.el configurations.
(require 'smtpmail)
(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      mail-from-style nil
      user-full-name "Your Name"
      ;; user-mail-address "account2@gmail.com" ; MS Exchange server
      ;; will check this.
      message-signature-file "~/.emacs.d/signature"
      smtpmail-debug-info nil
      smtpmail-debug-verb nil)
;; The code above just sets some default values. My mail signature is
;; found on the file ~/emacs/signature, I also specify my user name
;; user-full-name and my e-mail address user-mail-address so that Gnus
;; can fill the From header field automatically for me.

;; The Debug options is also nice so that you get some feedback about
;; what is happening while Gnus is sending the e-mail for you.

(defun set-smtp-plain (user password server port)
  "Set related SMTP variables for supplied parameters."
  (setq smtpmail-smtp-server server
    smtpmail-smtp-service port
    ;; smtpmail-auth-credentials "~/.authinfo"
    smtpmail-auth-credentials (list (list server port user password))
    smtpmail-starttls-credentials nil
    user-mail-address address
    )
  (message "Setting SMTP server to `%s:%s' for `%s'."
       server port address))

;; Need to install gnutls-bin for ttl
(defun set-smtp-ssl (user password server port key cert)
  "Set related SMTP and SSL variables for supplied parameters."
  (setq starttls-use-gnutls t
    starttls-gnutls-program "gnutls-cli"
    starttls-extra-arguments nil
    smtpmail-smtp-server server
    smtpmail-smtp-service port
    smtpmail-starttls-credentials (list (list server port key cert))
    ;; smtpmail-auth-credentials "~/.authinfo")
    smtpmail-auth-credentials (list (list server port user password))
    user-mail-address address
    )
  (message
   "Setting SMTP server to `%s:%s' for `%s'. (SSL enabled.)"
   server port address))
;; Those are two functions used to send mail, one with and one without
;; SSL support. Note that smtpmail-auth-credentials is telling Gnus
;; where to find the username and password.

(defun change-smtp ()
  "Change the SMTP server according to the current from line."
  (require 'authinfo "~/.authinfo.el")
  (save-excursion
    (loop with from = (save-restriction
            (message-narrow-to-headers)
            (message-fetch-field "from"))
      for (acc-type address . auth-spec) in smtp-accounts
      when (string-match address from)
      do (cond
          ((eql acc-type 'plain)
           (progn
             (message "Using plain")
             (message (car auth-spec))
             (return (apply 'set-smtp-plain auth-spec))
                     ))
          ((eql acc-type 'ssl)
           (progn
             (message "using ssl")
             (return (apply 'set-smtp-ssl auth-spec))
                   ))
          (t (error "Unrecognized SMTP account type: `%s'." acc-type)))
      finally (message "Cannot interfere SMTP information."))))

(add-hook 'message-send-hook 'change-smtp)

(provide 'my-mail)
