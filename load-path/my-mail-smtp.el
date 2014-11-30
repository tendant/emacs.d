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

;; ;;; configuration for smtpmail
;; (load-library "smtpmail")


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
;; (require 'starttls)

(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      mail-from-style nil
      user-full-name "Your Name"
      ;; user-mail-address "account2@gmail.com" ; MS Exchange server
      ;; will check this.
      ;; message-signature-file "~/.emacs.d/signature"
      smtpmail-debug-info t
      smtpmail-debug-verb t
      smtpmail-queue-mail nil
      smtpmail-queue-dir  "~/.Mail/queue/cur")
;; mu mkdir ~/.Mail/queue
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

;;  You can either use the built-in support (in Emacs 24.1 and later), or the starttls.el Lisp library. The built-in support uses the GnuTLS 1 library. If your Emacs has GnuTLS support built-in, the function gnutls-available-p is defined and returns non-nil. Otherwise, you must use the starttls.el library (see that file for more information on customization options, etc.). The Lisp library requires one of the following external tools to be installed:
;; (defun gnutls-available-p ()
;;   "Function redefined in order not to use built-in GnuTLS support"
;;   nil)

;; Require to install gnutls-bin for tls
(defun set-smtp-ssl (user password server port key cert)
  "Set related SMTP and SSL variables for supplied parameters."
  (setq
   ;; starttls-use-gnutls t
   ;; starttls-gnutls-program "gnutls-cli"
   ;; starttls-extra-arguments nil
        smtpmail-stream-type 'tls
        smtpmail-smtp-server server
        smtpmail-smtp-service port
        smtpmail-starttls-credentials (list (list server port key cert))
        ;; smtpmail-auth-credentials "~/.authinfo")
        smtpmail-auth-credentials (list (list server port user password))
        user-mail-address address
        smtpmail-local-domain "gmail.com")
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
          ( (or (eql acc-type 'ssl) (eql acc-type 'tls))
           (progn
             (message "using ssl or tls")
             (return (apply 'set-smtp-ssl auth-spec))
                   ))
          (t (error "Unrecognized SMTP account type: `%s'." acc-type)))
      finally (message "Cannot interfere SMTP information."))))

(add-hook 'message-send-hook 'change-smtp)

(provide 'my-mail-smtp)
