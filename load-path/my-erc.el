;; For erc
(add-to-list 'load-path "~/.emacs.d/load-path/erc-5.3-extras")

(require 'erc-notify)
(require 'erc-log)

(setq erc-echo-notices-in-minibuffer-flag t)
(setq erc-auto-query 'window-noselect)
(setq erc-save-buffer-on-part t)
(setq erc-hide-timestamps nil)
(erc-timestamp-mode t)
(setq erc-timestamp-format "[%R %m/%d/%Y]")
;; Don't track server buffer
(setq erc-track-exclude-server-buffer t)
;; Don't track join/quit
(setq erc-track-exclude-types '("NICK" "333" "353" "JOIN" "PART" "QUIT"))
;; Spell check
(erc-spelling-mode 1)
;; Nickname align
(setq erc-fill-function 'erc-fill-static)
(setq erc-fill-static-center 15)

;; logging:
(setq erc-log-channels t
      erc-log-channels-directory "~/.irclogs"
      erc-log-insert-log-on-open nil
      erc-log-file-coding-system 'utf-8)
;; end logging

(setq erc-file-name-invalid-regexp "[\/\:\*\?\"\<\>\|\!]")
(defun my-erc-log-standardize-name (filename)
  (interactive)
  "Make FILENAME safe to use as the name of an ERC log.
This will not work with full paths, only names.

;;; Patch the below function to use `file-name-invalid-regexp
Any unsafe characters in the name are replaced with \"!\".  The
filename is downcased."
  (downcase (erc-replace-regexp-in-string
             erc-file-name-invalid-regexp "!" 
             (convert-standard-filename filename))))
(setq erc-log-standardize-name 'my-erc-log-standardize-name)

;; end logging


(defvar freenode-your-nick-pass "")
(defvar oftc-your-nick-pass "")

(if (file-readable-p "~/.ercpass")
    (load "~/.ercpass"))

(require 'erc-services)
(erc-services-mode 1)
(setq erc-prompt-for-nickserv-password t)
(setq erc-nickserv-passwords
      `((freenode     (("your-nick" . ,freenode-your-nick-pass)))
        (oftc         (("your-nick" . ,oftc-your-nick-pass)))))

(defun erc-oftc () 
  (interactive)
  (erc :server "irc.oftc.net" 
       :port "6667"
       :nick "your-nick"))


(defun erc-freenode ()
  (interactive)
  (erc :server "irc.freenode.net"
       :port "6667"
       :nick "your-nick"))

(defun erc-local ()
  (interactive)
  (erc :server "localhost"
       :port "6667"
       :nick "your-nick"))


;; bitlbee add gtalk account
;; account add jabber username@gmail.com mypasswd talk.google.com:5223:ssl
;; For some unknown reason, some people must connect on 5222 and others must connect on 5223. 

;; Join the #emacs and #erc channels whenever connecting to Freenode.
(setq erc-autojoin-channels-alist '(
                                    ("oftc.net" "#awesome-cn" "#awesome")
                                    ("freenode.net" "#emacs" 
                                     "#cassandra"
                                     "#clojure")))

;; Freenode cloaking and ERC
(erc-autojoin-mode 0)
(add-hook 'erc-server-NOTICE-functions 'ted-post-cloak-autojoin)
(defun ted-post-cloak-autojoin (proc parsed)
  "Autojoin iff NickServ tells us to."
  (with-current-buffer (process-buffer proc)
    (when
        (and (string-match ".*You are successfully identified as.*"
                           (erc-response.contents parsed))
             (string-match ".*You are now identified for.*"
                           (erc-response.contents parsed)))
      (erc-autojoin-channels erc-session-server (erc-current-nick))
      nil)))


(defun erc-busy () 
  (interactive)
  (setq erc-auto-query 'bury))

(defun erc-online () 
  (interactive)
  (setq erc-auto-query 'window-noselect))

(defun erc-say-ni (str)
  "Play the Ni! sound file if STR contains Ni!"
  (when (string-match "\\byour-nick" str)
    (if linuxp 
        (play-sound-file "~/emacs.d/sounds/alert.wav"))))

(add-hook 'erc-insert-pre-hook 'erc-say-ni)
(add-hook 'erc-send-pre-hook 'erc-say-ni)

(provide 'my-erc)
(message "Loaded my-erc.el")
