(require 'org-gcal)

(if mac-osx-p
    (setq alert-default-style 'osx-notifier))

(setq org-gcal-client-id my-gcal-oauth-client-id
      org-gcal-client-secret my-gcal-oauth-client-secret
      org-gcal-fetch-file-alist '(("account2@gmail.com" .  "~/.emacs.d/calendars/your-nick.org")
                                  ("family-calendar@group.calendar.google.com" . "~/.emacs.d/calendars/family.org")
                                  ("calendar2@group.calendar.google.com" . "~/.emacs.d/calendars/calendar3.org")
                                  ("account3@example.com" . "~/.emacs.d/calendars/calendar4.org")))