;;; helm-git-project
;; forked from https://gist.github.com/eiel/2717956
(require 'cl)
(require 'helm-config)
(require 'helm-files)

(defvar helm-git-project-dir nil)

(defun git-project:root-dir ()
  (file-name-directory (file-truename
                        (shell-command-to-string "git rev-parse --git-dir"))))

(defun helm-git-project:create-source (name options)
  `((name . ,(concat "Git Project " name))
    (init . (lambda ()
              (setq helm-git-project-dir (git-project:root-dir))
              (let ((buffer (helm-candidate-buffer 'global))
                    (args (format "ls-files --full-name %s %s"
                                  ,options helm-git-project-dir)))
                (call-process-shell-command "git" nil buffer nil args))
              ))
    (display-to-real . (lambda (c) (concat helm-git-project-dir c)))
    (candidates-in-buffer)
    (action ("Find File" . find-file))))

(defvar helm-c-source-git-project-for-modified
  (helm-git-project:create-source "Modified files" "--modified"))
(defvar helm-c-source-git-project-for-untracked
  (helm-git-project:create-source "Untracked files" "--others --exclude-standard"))
(defvar helm-c-source-git-project-for-all
  (helm-git-project:create-source "All files" ""))

(defun helm-git-project ()
  (interactive)
  (let ((sources '(helm-c-source-git-project-for-modified
                   helm-c-source-git-project-for-untracked
                   helm-c-source-git-project-for-all)))
    (helm-other-buffer sources
                       (format "*Helm git project in %s*" default-directory))))

(global-set-key [f4] 'helm-ls-git-ls)

(provide 'my-helm)
  
