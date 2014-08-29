(defvar yas/temp-snippet nil
  "Content of the temporary snippet")

(defun yas/save-temp-snippet ()
  "Saves the temporary snippet"
  (interactive)
  (setq yas/temp-snippet
        (buffer-substring (region-beginning) (region-end))))

(defun yas/expand-temp-snippet ()
  "Expands the temporary snippet"
  (interactive)
  (yas/expand-snippet yas/temp-snippet))

(provide 'yas-temp-snippet)
