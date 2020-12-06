(defvar cy/default-font-size 180)
(defvar cy/default-variable-font-size 180)
(defvar cy/frame-transparency '(90 . 90))

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

(require 'server)
(unless (server-running-p)
  (server-start))
(setq org-image-actual-width nil)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package for non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package auto-package-update
   :ensure t
   :config
   (setq auto-package-update-delete-old-versions t
         auto-package-update-interval 4)
   (auto-package-update-maybe))

(set-face-attribute 'default nil
                    :family "M+ 1mn"
                    :height 110
                    :weight 'normal
                    :width 'normal)

(custom-set-faces
  '(org-level-8 ((t (:family "M+ 1mn" :weight bold :height 1.15 :foreground "#539afc"))))
  '(org-level-7 ((t (:family "M+ 1mn" :weight bold :height 1.15 :foreground "#5ec4ff"))))
  '(org-level-6 ((t (:family "M+ 1mn" :weight bold :height 1.15 :foreground "#d95468"))))
  '(org-level-5 ((t (:family "M+ 1mn" :weight bold :height 1.25 :foreground "#ebbf83"))))
  '(org-level-4 ((t (:family "M+ 1mn" :weight bold :height 1.25 :foreground "#8bd49c"))))
  '(org-level-3 ((t (:family "M+ 1mn" :weight bold :height 1.50 :foreground "#33ccdd"))))
  '(org-level-2 ((t (:family "M+ 1mn" :weight bold :height 1.75 :foreground "#ee7788"))))
  '(org-level-1 ((t (:family "M+ 1mn" :weight bold :height 1.9 :foreground "#bb2266"))))
)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboad-escape-quit)

;; Set up a leader key
(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps `(normal insert visual emacs)
    :prefix ","
    :global-prefix "C-,"))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init 'dashboard))
(use-package org-evil
  :after evil
  :ensure t)

;(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
;(define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)

(global-evil-leader-mode)
(evil-leader/set-leader ",")

(evil-leader/set-key
  "e" 'find-file
  "t" 'treemacs
)

(use-package command-log-mode)

(use-package doom-themes
    :config
    (setq doom-themes-enable-bold t
          doom-themes-enable-italic t)
    ;; (load-theme 'doom-vibrant t)
    ;; (load-theme 'doom-pale-night t)
    (load-theme 'doom-city-lights t)

    (doom-themes-org-config))

(use-package all-the-icons) ; Maybe don't use this. I can't decide if it makes Org worse or better.

(use-package smart-mode-line
  :config
  (setq sml/theme 'atom-one-dark)
  (sml/setup))
(use-package smart-mode-line-atom-one-dark-theme)

(use-package which-key
  :init (which-key-mode)
  :config
  (setq which-key-separator " "
        which-key-prefix-prefix "+"
        which-key-idle-delay 0.8))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)  ; Maybe remove this, I think I use C-l for something else.
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))


(use-package ivy-rich
  :init
  (ivy-rich-mode 1))


(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

; My old Ivy configuration
;(use-package ivy
;  :config
;    (ivy-mode 1)
;    (setq ivy-use-virtual-buffers nil ; show recentf and bookmarks?
;          ;enable-recursive-minibuffers t
;          ;ivy-count-format "(%d/%d) "
;          ;ivy-height 20
;          ;ivy-truncate-lines t  ; truncate or wrap
;          ;ivy-wrap t            ; cycle
;    ))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  ;; Remap whatever key is bound to these functions to go to these other functions instead.
  ;; This doesn't change the keybinding itself, only its target.
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(defun cy/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))))

;; Set faces for heading levels
(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
  (set-face-attribute (car face) nil :font "M+ 1mn" :weight 'regular :height (cdr face)))

;; Ensure that anything that should be fixed-pitch in Org files appears that way.
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil :foreground nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-table nil :foreground nil :inherit '(shadow-fixed-pitch))
(set-face-attribute 'org-verbatim nil :foreground nil :inherit '(shadow-fixed-pitch))
(set-face-attribute 'org-special-keyword nil :foreground nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :foreground nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :foreground nil :inherit 'fixed-pitch)
;; Old settings
;(custom-set-faces
;  '(org-level-8 ((t (:family "M+ 1mn" :weight bold :height 1.15 :foreground "#539afc"))))
;  '(org-level-7 ((t (:family "M+ 1mn" :weight bold :height 1.15 :foreground "#5ec4ff"))))
;  '(org-level-6 ((t (:family "M+ 1mn" :weight bold :height 1.15 :foreground "#d95468"))))
;  '(org-level-5 ((t (:family "M+ 1mn" :weight bold :height 1.25 :foreground "#ebbf83"))))
;  '(org-level-4 ((t (:family "M+ 1mn" :weight bold :height 1.25 :foreground "#8bd49c"))))
;  '(org-level-3 ((t (:family "M+ 1mn" :weight bold :height 1.50 :foreground "#33ccdd"))))
;  '(org-level-2 ((t (:family "M+ 1mn" :weight bold :height 1.75 :foreground "#ee7788"))))
;  '(org-level-1 ((t (:family "M+ 1mn" :weight bold :height 1.9 :foreground "#bb2266"))))
;)

(defun cy/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :pin org
  :hook (org-mode . cy/org-mode-setup)
  :config
  (setq org-ellipses " ▾")

  ;; Agenda
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
        '("~/OneDrive/Notes/Tasks.org"
          "~/OneDrive/Notes/Habits.org"
          "~/OneDrive/Notes/Birthdays.org"))

  ;; @todo Examine this 
  (require 'org-habit) 
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  ;; Set up the keywords that I use for todo tasks.
  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(t)" "|" "DONE(d!)")
      (sequence "BACKLOG(b" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  ;; @todo learn what refiling is.
  ;; Refiling Settings
  (setq org-refile-targets
    '(("Archive.org" :maxlevel . 1)
      ("Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  ;; Define my personal task taxonomy
  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
    '(("d" "Dashboard"
      ((agenda "" ((org-deadline-warning-days 7)))
       (todo "NEXT"
         ((org-agenda-overriding-header "Next Tasks")))
       (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))
     ("n" "Next Tasks"
      ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))
     ("W" "Work Tasks" tags-todo "+work-email")

     ;; Low-effort next-actions
     ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
      ((org-agenda-overriding-header "Low Effort Tasks")
       (org-agenda-max-todos 20)
       (org-agenda-files org-agenda-files)))

     ("w" "Workflow Status"
      ((todo "WAIT"
             ((org-agenda-overriding-header "Waiting on External")
              (org-agenda-files org-agenda-files)))
       (todo "REVIEW"
             ((org-agenda-overriding-header "In Review")
              (org-agenda-files org-agenda-files)))
       (todo "PLAN"
             ((org-agenda-overriding-header "In Planning")
              (org-agenda-files org-agenda-files)))
       (todo "BACKLOG"
             ((org-agenda-overriding-header "Project Backlog")
              (org-agenda-files org-agenda-files)))
       (todo "READY"
             ((org-agenda-overriding-header "Ready for Work")
              (org-agenda-files org-agenda-files)))
       (todo "ACTIVE"
             ((org-agenda-overriding-header "Active Projects")
              (org-agenda-files org-agenda-files)))
       (todo "COMPLETED"
             ((org-agenda-overriding-header "Completed Projects")
              (org-agenda-files org-agenda-files)))
       (todo "CANC"
             ((org-agenda-overriding-header "Cancelled Projects")
              (org-agenda-files org-agenda-files)))))))

  ;; Org capture templates
  (setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/OneDrive/Notes/Tasks.org" "Inbox")
           "* TODO %?\n %U\n %a\n %i" :empty-lines 1)
      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/OneDrive/Notes/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/OneDrive/Notes/Templates/Daily.org") ;; What did this used to do?
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/OneDrive/Notes/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/OneDrive/Notes/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/OneDrive/Notes/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))

  (cy/org-font-setup))

;; Avoid #file.org#
(auto-save-visited-mode)
(setq create-lockfiles nil)
;; Avoid filename.ext~
(setq make-backup-files nil)

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun cy/org-mode-visual-fill ()
  (setq visual-fill-column-width 80
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

;  (use-package olivetti
;     :config
;     (add-hook 'text-mode-hook 'olivetti-mode)
;     ;(add-hook 'text-mode-hook (lambda () (setq indent-line-function #'indent-relative)))
;     (setq-default olivetti-body-width 120))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python .t)))
(push '("conf-unix" . conf-unix) org-src-lang-modes)

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

;; Automatically tangle Settings.org when saved
(defun efs/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(setq org-startup-with-inline-images t)
(add-hook
  'org-babel-after-execute-hook
  (lambda ()
    (when org-inline-image-overlays
      (org-redisplay-inline-images))))

(setq org-src-fontify-natively t)

(use-package org-roam
  :ensure t
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/OneDrive/Notes/org-roam")
  (org-roam-index "~/OneDrive/Notes/org-roam/Index.org")
  (org-roam-graph-executable "neato")
  (org-roam-buffer-window-parameters '((no-delete-other-windows . t)))
  (org-roam-dailies-directory "daily/")
  (org-roam-dailies-capture-templates
    '(("l" "lab" entry
        #'org-roam-capture--get-point
        "* %?"
        :file-name "daily/%<%Y-%m-%d>"
        :head "#+title: %<%Y-%m-%d>\n"
        :olp ("Lab notes"))

      ("j" "journal" entry
        #'org-roam-capture--get-point
        "* %?"
        :file-name "daily/%<%Y-%m-%d>"
        :head "#+title: %<%Y-%m-%d>\n"
        :olp ("Journal"))))

  (org-roam-graph-exclude-matcher '("dailies"))
  ; (org-roam-graph-viewer 'eww-open-file)
  :bind (:map org-roam-mode-map
      (("C-c n l" . org-roam)
       ("C-c n f" . org-roam-find-file)
       ("C-c n g" . org-roam-graph-show))
      :map org-mode-map
      (("C-c n i" . org-roam-insert))
      (("C-c n I" . org-roam-insert-immediate))))
  ;; Leader shortcuts
  (evil-leader/set-key
    "arl" 'org-roam
    "ardt" 'org-roam-today
    "ardct" 'org-roam-dailies-capture-today
    "ardT" 'org-roam-dailies-find-tomorrow
    "ardcT" 'org-roam-dailies-capture-tomorrow
    "ardy" 'org-roam-dailies-find-yesterday
    "arf" 'org-roam-find-file
    "arg" 'org-roam-show-graph-show
    "ari" 'org-roam-insert)

(use-package org-roam-server
  :ensure t
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))

(use-package org-roam-protocol)

(defun cy/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))
;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . cy/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

;;;; OLD LSP-MODE SETTINGS ;;;;
;(use-package lsp-mode
;    :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
;            (js2-mode . lsp-deferred)
;            (prog-mode . lsp-deferred)
;            ;; if you want which-key integration
;            (lsp-mode . lsp-enable-which-key-integration))
;    :commands lsp lsp-deferred
;    :config (setq lsp-headerline-breadcrumb-enable t
;                  lsp-enable-on-type-formatting nil
;                  lsp-enable-indentation nil
;                  lsp-enable-semantic-highlighting t ; experimental
;                  lsp-keep-workspace-alive t
;                  lsp-enable-completion-at-point
;                  lsp-enable-xref))
;
;;; optionally
;(use-package lsp-ui :commands lsp-ui-mode)
;;; if you are helm user
;(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;;; if you are ivy user
;;(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;(use-package lsp-treemacs
;  :commands lsp-treemacs-errors-list
;            lsp-treemacs-symbols
;            lsp-treemacs-references
;            lsp-treemacs-implementations
;  :config
;    (lsp-treemacs-sync-mode 1))
;
;;; optionally if you want to use debugger
;;(use-package dap-mode)
;;; (use-package dap-LANGUAGE) to load the dap adapter for your language
;
;;; optional if you want which-key integration

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

;(add-to-list 'company-backends 'company-lsp)
(use-package company-lsp
  :config (setq company-lsp-cache-candidates 'auto
                company-lsp-async nil
                company-lsp-enable-snippet nil ; Set to non-nil if you want snippet expansion on completion.
                company-lsp-enable-recompletion nil))
;(add-hook 'js2-mode-hook (lambda ()
;                            (tern-mode)
;                            (company-mode)))

(use-package dap-mode
  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed.

  (require 'dap-chrome)
  (dap-chrome-setup)

  ;; Bind `C-c l d` to `dap-hydra` for easy access.
  (general-define-key
    :keymaps 'lsp-mode-map
    :prefix lsp-keymap-prefix
    "d" '(dap-hydra t :wk "debugger")))

;(use-package dap-mode)
;(use-package dap-mode
;  :config
;  (dap-mode 1)
;  (dap-ui-mode 1)
;  (dap-tooltip-mode 1)
;  (tooltip-mode 1)
;  (dap-ui-controls-mode 1))
;
;(use-package dap-php)
;(use-package dap-node)
;(use-package dap-firefox)
;(use-package dap-chrome
;  :config
;  (setq browse-url-chrome-program "/usr/bin/google-chrome-stable"
;        browse-url-chrome-arguments "--profile-directory=Default"))

(use-package js2-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (add-hook 'js2-mode-hook #'js2-imenu-extras-mode))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
:mode (("README\\.md\\'" . gfm-mode)
       ("\\.md\\'" . gfm-mode)
       ("\\.markdown\\'" . markdown-mode))
:init (setq markdown-command "multimarkdown"))

(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
(add-to-list 'auto-mode-alist '("\\.esdoc\\.json\\'" . json-mode))

(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\.twig\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.module\\'" . php-mode))

(add-hook 'php-mode-hook '(lambda ()
                            (setq c-basic-offset 2)))
(add-hook 'php-mode-hook '(lambda ()
                            (setq display-line-numbers 'absolute)))

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  ;; Set these if python3 is called "python3" on the system.
  ;; (python-shell-interpreter "python3")
  ;; (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

;(use-package pyvenv
;  :config
;  (pyvenv-mode 1))

(show-paren-mode 1)

(setq require-final-newline t)

(use-package flycheck
 :ensure t 
 :init (global-flycheck-mode))

(use-package company
  :ensure t
  :after lsp-mode
  ;:init (global-company-mode)     ;; This gets pretty annoying when you're writing regular files and notes.
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
          ("<tab>" . company-select-next)
          ("<tab>" . company-select-previous))
  :config (setq company-idle-delay 0.0
            company-tooltip-align-annotations t
            company-minimum-prefix-length 1
            create-lockfiles nil   ;; Lock file creation can crash debuggers.
            ;; Easy navigation to candidates with M-<n>
            company-show-numbers t
            company-dabbrev-downcase nil)
  :diminish company-mode)

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy)) ; Possibly swap to helm
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; Note: Set this to the folder where you keep your Git repos.
  (when (file-directory-p "~/Projects/")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))
; Old configuration
;(projectile-mode +1)
;(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
;(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Note: Make sure to configure a GitHub token before using this package.
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
;; (use-package forge)

(use-package evil-nerd-commenter
  :bind ("C-/" . evilnc-comment-or-uncomment-lines))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs               (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay    0.5
          treemacs-display-in-side-window      t
          treemacs-indentation                 2
          treemacs-indentation-string          " "
          treemacs-no-delete-other-windows     t
          treemacs-position                    'left
          treemacs-width                       35
          ; treemacs-resize-icons 44
          treemacs-follow-mode                 t
          treemacs-filewatch-mode              t
          treemacs-fringe-indicator-mode       t)
          (pcase (cons (not (null (executable-find "git")))
                       (not (null treemacs-python-executable)))
            (`(t . t)
              (treemacs-git-mode 'deferred))
            (`(t . _)
              (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after treemacs evil
  :ensure t)

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

;(use-package treemacs-magit
;  :after treemacs-magit
;  :ensure t)

(use-package term
  :config
  (setq explicit-shell-file-name "zsh")
  ;;(setq explicit-zsh-args '())        ;; Use explicit-<shell>-args for shell-specific configs

  ;; Set up the prompt:
 (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

;(use-package deft
;  :after org
;  :bind
;  ("C-c n d" . deft)
;  :custom
;  (deft-recursive t)
;  (deft-use-filter-string-for-filename t)
;  (deft-default-extension "org")
;  (deft-directory "~/OneDrive/Notes/"))
;  (evil-leader/set-key
;    "d" 'deft)

(add-to-list 'auto-mode-alist '("\\.service\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.timer\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.target\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.mount\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.automount\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.slice\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.socket\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.path\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.netdev\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.network\\'" . conf-unix-mode))
(add-to-list 'auto-mode-alist '("\\.link\\'" . conf-unix-mode))

(setq org-latex-toc-command "\\tableofcontents \\clearpage")

;;; package --- Org mode basic setup.
;;; Commentary:
;;; Tries to normalize the src block indentation.  Also hides leading stars.
;;; Code:
;(use-package org
;  :config
;  (setq org-edit-src-content-indentation 0
;        org-src-tab-acts-natively t
;        org-src-preserve-indentation t
;        org-adapt-indentation nil)
;  (add-hook 'org-mode-hook 'org-indent-mode))

;(setq org-fontify-quote-and-verse-blocks t)

;(customize-set-variable 'org-blank-before-new-entry
;                        '((heading . nil)
;                          (plain-list-item . nil)))
;(setq org-cycle-separator-lines 1)

;(setq org-hide-emphasis-markers nil)

; (setq org-indent-indention-per-level 1)
; (setq org-hide-leading-stars t)

;(setq org-agenda-custom-commands
;  '(("e" "todos in nearby notes"
;     ((todo "" ((org-agenda-files
;                 (org-roam-db--links-with-max-distance
;    buffer-file-name
;    3))))))))

;(setq org-todo-keywords
;    '((sequence "TODO(t)" "|" "DONE(d!)")))
;(setq org-log-done 'time)

;(require 'org-bullets)
;(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(global-page-break-lines-mode)

(use-package dashboard
  :ensure t
  ;;:mode ("\\*dashboard*\\" . dashboard-mode)
  ;;:interpreter ("dashboard" . dashboard-mode)
  :config
  ;; Set the title
  (setq dashboard-banner-logo-title "Carwin's Dashboard")
  ;; Show the logo in the banner
  (setq dashboard-startup-banner 'logo)
  ;; Show package load / init time
  (setq dashboard-set-init-info t)
  ;; Icons
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-items '((recents . 5)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 5)))
  (dashboard-setup-startup-hook))
