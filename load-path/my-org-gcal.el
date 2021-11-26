;; (require 'org-gcal)

(if mac-osx-p
    (setq alert-default-style 'osx-notifier))

(setq org-gcal-client-id "my-gcal-oauth-client-id"
      org-gcal-client-secret "my-gcal-oauth-client-secret"
      org-gcal-fetch-file-alist '(("account2@gmail.com" .  "~/.emacs.d/calendars/your-nick.org")
                                  ;; ("family-calendar@group.calendar.google.com" . "~/.emacs.d/calendars/family.org")
                                  ("calendar1@group.calendar.google.com" . "~/.emacs.d/calendars/calendar2.org")
                                  ("calendar2@group.calendar.google.com" . "~/.emacs.d/calendars/calendar3.org")
                                  ("account3@example.com" . "~/.emacs.d/calendars/calendar4.org")))

(setq org-gcal-remove-api-cancelled-events 'delete)

(setq org-gcal-local-timezone "America/Los_Angeles")
;; Create Event response: (:kind "calendar#event" :etag "\"3216479761812000\"" :id "f6br3pp3ggbjgvnecf1as6tgko" :status "confirmed" :htmlLink "https://www.google.com/calendar/event?eid=ZjZicjNwcDNnZ2JqZ3ZuZWNmMWFzNnRna28gZmFtaWx5MTc4MDk1MjY1MTczODU3ODM2MjZAZw" :created "2020-12-17T21:18:00.000Z" :updated "2020-12-17T21:18:00.906Z" :summary "timezone test 5" :creator (:email "account2@gmail.com") :organizer (:email "family-calendar@group.calendar.google.com" :displayName "Family" :self t) :start (:dateTime "2020-12-18T03:07:00Z") :end (:dateTime "2020-12-18T03:12:00Z") :iCalUID "f6br3pp3ggbjgvnecf1as6tgko@google.com" :sequence 0 :reminders (:useDefault t))

;; restart sync completely: org-gcal-sync-tokens-clear

(setq org-gcal-up-days 7)

(setq org-gcal-down-days 60)

(provide 'my-org-gcal)