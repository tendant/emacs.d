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
;; (require 'smtpmail)
;; (require 'starttls)

(setq
 ;; send-mail-function 'smtpmail-send-it
 ;;      message-send-mail-function 'smtpmail-send-it
 ;;      mail-from-style nil
 ;;      user-full-name "Your Name"
      ;; user-mail-address "account2@gmail.com" ; MS Exchange server
      ;; will check this.
      ;; message-signature-file "~/.emacs.d/signature"
      smtpmail-debug-info t
      smtpmail-debug-verb t)
;; mu mkdir ~/.Mail/queue
;; The code above just sets some default values. My mail signature is
;; found on the file ~/emacs/signature, I also specify my user name
;; user-full-name and my e-mail address user-mail-address so that Gnus
;; can fill the From header field automatically for me.

;; The Debug options is also nice so that you get some feedback about
;; what is happening while Gnus is sending the e-mail for you.

;; (setq smtpmail-stream-type 'ssl) ;; If using TLS/SSL.  Use C-h v smtpmail-stream-type RET to see possible values

;; .authinfo.el
;; (setq smtp-accounts
;;   '(("email@example.com" "Name" "smtp.gmail.com")
;;    ("email@example.com" "Name" "smtp.gmail.com")))

(defun my-change-smtp ()
  (require 'authinfo "~/.authinfo.el")
  (save-excursion
    (loop with from = (save-restriction
                        (message-narrow-to-headers)
                        (message-fetch-field "from"))
          for (addr fname server) in smtp-accounts
          when (string-match addr from)
          do (progn
               (message "match found")
               (message from)
               (setq user-mail-address addr
                     user-full-name fname
                     smtpmail-smtp-user addr
                     smtpmail-smtp-server server)))))

(defadvice smtpmail-via-smtp
  (before change-smtp-by-message-from-field (recipient buffer &optional ask) activate)
  (with-current-buffer buffer (my-change-smtp)))

;;  You can either use the built-in support (in Emacs 24.1 and later), or the starttls.el Lisp library. The built-in support uses the GnuTLS 1 library. If your Emacs has GnuTLS support built-in, the function gnutls-available-p is defined and returns non-nil. Otherwise, you must use the starttls.el library (see that file for more information on customization options, etc.). The Lisp library requires one of the following external tools to be installed:

(provide 'my-mail-smtp)
