(setq org-directory "~/OneDrive/Notes")

(setq org-agenda-files `(,org-directory))

(defun cy/org-path (path)
  (expand-file-name path org-directory))

(setq org-default-notes-file (cy/org-path "Inbox.org"))

(setq org-todo-keywords
  '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
    (sequence "|" "WAIT(w)" "BACK(b)")))

;; @todo: org-todo-keyword-faces
(setq org-todo-keyword-faces
'(("NEXT" . (:foreground "orange red" :weight bold))
  ("WAIT" . (:foreground "HotPink2" :weight bold))
  ("BACK" . (:foreground "MediumPurple3" :weight bold))))
(setq org-global-properties
    '(("Effort_ALL". "0 0:10 0:30 1:00 2:00 3:00 4:00")))

;; Configure common tags
(setq org-tag-alist
  '((:startgroup)
   ; Put mutually exclusive tags here
   (:endgroup)
   ("@home" . ?H)
   ("@work" . ?W)
   ("batch" . ?b)
   ("followup" . ?f)))

(setq org-agenda-window-setup 'current-window)
(setq org-agenda-span 'day)
(setq org-agenda-start-with-log-mode t)

(setq org-agenda-custom-commands
      `(("d" "Dashboard"
         ((agenda "" ((org-deadline-warning-days 7)))
          (tags-todo "+PRIORITY=\"A\""
                      ((org-agenda-overriding-header "High Priority")))
          (tags-todo "+followup" ((org-agenda-overriding-header "Needs Follow Up")))
          (todo "NEXT"
                 ((org-agenda-overriding-header "Next Actions")))
          (todo "TODO"
                 ((org-agenda-overriding-header "Unprocessed Inbox Tasks")
                  (org-agenda-files '(,(cy/org-path "Inbox.org")))
                  (org-agenda-text-search-extra-files nil)))))
       ("n" "Next Tasks"
        ((agenda "" ((org-deadline-warning-days 7)))
         (todo "NEXT"
               ((org-agenda-overriding-header "Next Tasks")))))

        ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
        ((org-agenda-overriding-header "Low Effort Tasks")
         (org-agenda-max-todos 20)
         (org-agenda-files org-agenda-files)))))

(setq org-capture-templates
  `(("t" "Tasks / Projects")
    ("tt" "Task" entry (file+olp+datetree ,(cy/org-path "Inbox.org") "Projects" "Inbox")
         "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
    ("ts" "Clocked Entry Subtask" entry (clock)
         "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
    ("tp" "New Project" entry (file+olp ,(cy/org-path "Inbox.org") "Projects" "Inbox")
         "* PLAN %?\n  %U\n  %a\n  %i" :empty-lines 1)))

(provide 'cy-workflow)
