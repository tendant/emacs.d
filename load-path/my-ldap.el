(require 'ldap)

(require 'eudc)

;; (setq eudc-default-return-attributes nil)
(setq eudc-default-return-attributes '(cn mail givenName name telephoneNumber))

(setq eudc-strict-return-matches nil)

(setq ldap-ldapsearch-args (quote ("-tt" "-LLL" "-x")))

(setq eudc-inline-query-format '((firstname)
                                 (name)
                                 (firstname name)
                                 (mail)
                                 ))

(setq eudc-query-form-attributes '(firstname
                                   name
                                   mail
                                   ))

;; loaded from ~/.authinfo.el
(setq ldap-host-parameters-alist
      (quote (("ldap-server.com"
               base "DC=server,DC=com"
               binddn "CN=user,OU=Employees,DC=company,DC=com"
               passwd "password"))))
;; loaded from ~/.authinfo.el
(eudc-set-server "ldap-server.com" 'ldap t)
;; loaded from ~/.authinfo.el
(setq eudc-server-hotlist '(("ldap-server.com" . ldap)))

;; (require 'authinfo "~/.authinfo.el")

(setq eudc-inline-expansion-servers 'hotlist)

(defun enz-eudc-expand-inline()
  (interactive)
  (move-end-of-line 1)
  (insert "*")
  (unless (condition-case nil
              (eudc-expand-inline)
            (error nil))
    (backward-delete-char-untabify 1))
  )

;; (eval-after-load "message"
;;   '(define-key message-mode-map (kbd "TAB") 'enz-eudc-expand-inline))
;; (eval-after-load "sendmail"
;;   '(define-key mail-mode-map (kbd "TAB") 'enz-eudc-expand-inline))
;; (eval-after-load "post"
;;   '(define-key post-mode-map (kbd "TAB") 'enz-eudc-expand-inline))

(provide 'my-ldap)