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

(setq
 ;; send-mail-function 'smtpmail-send-it
 ;;      message-send-mail-function 'smtpmail-send-it
 ;;      mail-from-style nil
 ;;      user-full-name "Your Name"
      ;; user-mail-address "account2@gmail.com" ; MS Exchange server
      ;; will check this.
      ;; message-signature-file "~/.emacs.d/signature"
      smtpmail-debug-info nil
      smtpmail-debug-verb nil)
;; The Debug options is also nice so that you get some feedback about
;; what is happening while Gnus is sending the e-mail for you.


;; https://www.gnu.org/software/emacs/manual/html_node/smtpmail/Authentication.html#Authentication
;; The basic format of the ~/.authinfo file is one line for each set
;; of credentials. Each line consists of pairs of variables and
;; values. A simple example would be:
;;
;;     machine mail.example.org port 25 login myuser password mypassword
;;
;; This specifies that when using the SMTP server called
;; ‘mail.example.org’ on port 25, Emacs should send the user name
;; ‘myuser’ and the password ‘mypassword’. Either or both of the
;; login and password fields may be absent, in which case Emacs
;; prompts for the information when you try to send mail. (This
;; replaces the old smtpmail-auth-credentials variable used prior to
;; Emacs 24.1.)
;; 
;; When the SMTP library connects to a host on a certain port, it
;; searches the ~/.authinfo file for a matching entry. If an entry is
;; found, the authentication process is invoked and the credentials
;; are used. If the variable smtpmail-smtp-user is set to a non-nil
;; value, then only entries for that user are considered. For more
;; information on the ~/.authinfo file, see auth-source.

;; (setq smtpmail-stream-type 'ssl) ;; If using TLS/SSL.  Use C-h v smtpmail-stream-type RET to see possible values

;; .authinfo.el
;; (setq smtp-accounts
;;   '(("email1@example.com" "Name" "smtp.gmail.com" 587)
;;     ("email2@example.com" "Name" "smtp.gmail.com" 587)))

(defun my-change-smtp ()
  (require 'authinfo "~/.authinfo.el")
  (save-excursion
    (loop with from = (save-restriction
                        (message-narrow-to-headers)
                        (message-fetch-field "from"))
          for (addr fname server port) in smtp-accounts
          when (string-match addr from)
          do (progn
               (message "match found")
               (message from)
               (setq user-mail-address addr
                     user-full-name fname
                     smtpmail-smtp-user addr
                     smtpmail-smtp-server server
                     smtpmail-smtp-service port)))))

(defadvice smtpmail-via-smtp
  (before change-smtp-by-message-from-field (recipient buffer &optional ask) activate)
  (with-current-buffer buffer (my-change-smtp)))

;;  You can either use the built-in support (in Emacs 24.1 and later), or the starttls.el Lisp library. The built-in support uses the GnuTLS 1 library. If your Emacs has GnuTLS support built-in, the function gnutls-available-p is defined and returns non-nil. Otherwise, you must use the starttls.el library (see that file for more information on customization options, etc.). The Lisp library requires one of the following external tools to be installed:

(provide 'my-mail-smtp)
