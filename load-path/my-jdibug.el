(add-to-list 'load-path (concat (file-name-directory (or load-file-name buffer-file-name)) "jdibug-0.5"))

(require 'jdibug)

;; (jdibug-debug-config
;;  (interactive)
;;  (let (server (read-from-minibuffer "Server: " "localhost"))
;;    (port (read-from-minibuffer "Listen port: " "5005"))

(provide 'my-jdibug)
(message "Loaded my-jdibug.el")
