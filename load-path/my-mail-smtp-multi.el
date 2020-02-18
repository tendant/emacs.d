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

(require 'smtpmail-multi)

(setq smtpmail-multi-accounts
      (quote ((gmail-your-nick . ("account2@gmail.com"
                                  "smtp.gmail.com"
                                  465
                                  "account2@gmail.com"
                                  ssl nil nil nil))
              (gmail-account1 . ("account1@gmail.com"
                                     "smtp.gmail.com"
                                     465
                                     "account1@gmail.com"
                                     ssl nil nil nil))
              (account3 . ("account3@example.com"
                               "smtp.gmail.com"
                               465
                               "account3@example.com"
                               ssl nil nil nil)))))

(setq smtpmail-multi-associations
      (quote (("account2@gmail.com" gmail-your-nick)
              ("account1@gmail.com" gmail-account1)
              ("account3@example.com" account3))))

(setq smtpmail-multi-default-account 'gmail-account1)
(setq message-send-mail-function 'smtpmail-multi-send-it)
(setq smtpmail-debug-info t)

(provide 'my-mail-smtp-multi)