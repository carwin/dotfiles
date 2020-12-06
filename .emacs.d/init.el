(setq debug-on-error t)
  (defvar cy/default-font-size 110)
  (defvar cy/default-variable-font-size 110)
  (defvar cy/frame-transparency '(95 . 95))

(use-package server)
(unless (server-running-p)
  (server-start))
(setq org-image-actual-width nil)

(setq custom-file
  (if (boundp 'server-socket-dir)
      (expand-file-name "custom.el" server-socket-dir)
      (expand-file-name (format "emacs-custom-%s.el" (user-uid)) temporary-file-directory)))
(load custom-file t)

(require 'server)
(unless (server-running-p)
  (server-start))
(setq org-image-actual-width nil)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

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

(global-set-key (kbd "<escape>") 'keyboad-escape-quit)

(global-set-key (kbd "C-M-u") 'universal-argument)

(use-package general
  :config
  (general-create-definer cy/leader-key-def
    :keymaps `(normal insert visual emacs org-roam)
    :prefix ","
    :global-prefix "C-,"))

;; Tell me when I do a bad thing.
(defun cy/dont-arrow-me-bro ()
  (interactive)
  (message "Arrow keys are bad, m'kay?"))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  ;(setq evil-want-C-i-jump t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  ;; Disable arrow keys in normal and visual modes.
  (define-key evil-normal-state-map (kbd "<left>") 'cy/dont-arrow-me-bro)
  (define-key evil-normal-state-map (kbd "<down>") 'cy/dont-arrow-me-bro)
  (define-key evil-normal-state-map (kbd "<up>") 'cy/dont-arrow-me-bro)
  (define-key evil-normal-state-map (kbd "<right>") 'cy/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<left>") 'cy/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<down>") 'cy/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<up>") 'cy/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<right>") 'cy/dont-arrow-me-bro)
  ;; Make sure we're in normal mode, not insert mode when we are in these Emacs modes.
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))


(use-package evil-collection
    :after evil
    :ensure t
    :config
    (evil-collection-init 'dashboard)) ;Make sure Evil bindings work on the Dashboard.

(use-package which-key
  :init (which-key-mode)
  :diminish (which-key-mode)
  :config
  (setq which-key-separator " "
        which-key-prefix-prefix "+"
        which-key-idle-delay 0.2))

;; No startup message.
(setq inhibit-startup-message t)

(scroll-bar-mode -1)      ; Disable scroll bar.
(tool-bar-mode -1)        ; Disable the toolbar.
(tooltip-mode -1)         ; Disable tooltips.
(menu-bar-mode -1)        ; Disable the menu bar.
(set-fringe-mode 0)       ; Define the width of the fringe. Useful for breakpoints, but not much else.

(set-frame-parameter (selected-frame) 'alpha cy/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,cy/frame-transparency))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Turn on column number mode and display line numbers for everything by default.
(column-number-mode)

;; Enable line numbers for certain modes.
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

;; Disable line numbers for certain modes that are sub-modes of the above.
(dolist (mode '(org-mode-hook
                term-mode-hook
                treemacs-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq large-file-warning-threshold nil)

(setq vc-follow-symlinks t)

(setq ad-redefinition-action 'accept)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  ;; (load-theme 'doom-vibrant t)
  (load-theme 'doom-palenight t)
  ;;(load-theme 'doom-city-lights t)

  (doom-themes-org-config))

(set-face-attribute 'default nil
                    ;; :family "M+ 1mn"
                    :family "Dank Mono"
                    :height cy/default-font-size
                    ;; :height 100
                    :weight 'normal
                    :width 'normal)

(set-face-attribute 'fixed-pitch nil :font "Dank Mono" :height cy/default-font-size)
;;(set-face-attribute 'fixed-pitch nil :font "Dank Mono" :height cy/default-font-size :weight 'bold)
;; (set-face-attribute 'fixed-pitch nil :font "Monoid" :height cy/default-font-size :weight 'regular)

(set-face-attribute 'variable-pitch nil :font "M+ 1c" :height cy/default-variable-font-size :weight 'regular)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;(defun cy/replace-unicode-font-mapping (block-name old-font new-font)
;  (let* ((block-idx (cl-position-if
;                                          (lambda (i) (string-equal (car i) block-name))
;                                          unicode-fonts-block-font-mapping))
;              (block-fonts (cadr (nth block-idx unicode-fonts-block-font-mapping)))
;              (updated-block (cl-substitute new-font old-font block-fonts :test 'string-equal)))
;      (setf (cdr (nth block-idx unicode-fonts-block-font-mapping))
;                 (,updated-block))))

(use-package unicode-fonts
  :ensure t
  :custom
  (unicode-fonts-skip-font-groups '(low-quality-glyphs))
  (unicode-fonts-setup))

(setq display-time-format "%l:%M %p %b %y"
      display-time-default-load-average nil)

(use-package diminish)

(use-package all-the-icons) ; Maybe don't use this. I can't decide if it makes Org worse or better.
(use-package smart-mode-line
  :disabled
  :config
  (setq sml/no-confirm-load-theme t)
  (sml/setup)
  (sml/apply-theme 'respectful)  ; Respect the theme colors
  (setq sml/mode-width 'right
      sml/name-width 60)

  (setq-default mode-line-format
  `("%e"
      mode-line-front-space
      evil-mode-line-tag
      mode-line-mule-info
      mode-line-client
      mode-line-modified
      mode-line-remote
      mode-line-frame-identification
      mode-line-buffer-identification
      sml/pos-id-separator
      (vc-mode vc-mode)
      " "
      ;mode-line-position
      sml/pre-modes-separator
      mode-line-modes
      " "
      mode-line-misc-info))

  (setq rm-excluded-modes
    (mapconcat
      'identity
      ; These names must start with a space!
      '(" GitGutter" " MRev" " company"
      " Helm" " Undo-Tree" " Projectile.*" " Z" " Ind"
      " Org-Agenda.*" " ElDoc" " SP/s" " cider.*")
      "\\|")))

;; My original SML configuration.
;(use-package smart-mode-line
;  :config
;  (setq sml/theme 'atom-one-dark)
;  (sml/setup))
;(use-package smart-mode-line-atom-one-dark-theme :defer t)

;; Run (all-the-icons-install-fonts) after this.

(use-package minions
  :diminish
  :hook (doom-modeline-mode . minions-mode)
  :custom
  (minions-mode-line-lighter ""))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom-face
  (mode-line ((t (:height 0.85))))
  (mode-line-inactive ((t (:height 0.85))))
  :custom
  (doom-modeline-height 15)
  (doom-modeline-bar-width 6)
  (doom-modeline-lsp t)
  (doom-modeline-github nil)
  (doom-modeline-mu4e nil)
  (doom-modeline-irc nil)
  (doom-modeline-minor-modes t)
  (doom-modeline-persp-name nil)
  (doom-modeline-buffer-file-name-style 'truncate-except-project)
  (doom-modeline-major-mode-icon nil))

(use-package super-save
  :ensure t
  :defer 1
  :diminish super-saver-mode
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t))

(global-auto-revert-mode 1)
;; This can support messages if they get annoying
;; (setq auto-revert-verbose nil)

;(cy/leader-key-def
;  "e" 'find-file)

(cy/leader-key-def
  "t"  '(:ignore t :which-key "toggle")
  "tt" '(treemacs :which-key "treemacs")
  "tw" 'whitespace-mode
  "tc" '(counsel-load-theme :which-key "choose theme"))

(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

;(setq epa-pinentry-mode 'loopback)
;(pinentry start)

(setq custom-tab-width 2)
(setq-default evil-shift-width tab-width)

(setq-default indent-tabs-mode nil)

(use-package evil-nerd-commenter
  :bind ("C-/" . evilnc-comment-or-uncomment-lines))

(use-package ws-butler
  :hook ((text-mode . ws-butler-mode)
  (prog-mode . ws-butler-mode)))

(setq require-final-newline t)

(defun cy/org-file-jump-to-heading (org-file heading-title)
  (interactive)
  (find-file (expand-file-name org-file))
  (goto-char (point-min))
  (search-forward (concat "* " heading-title))
  (org-overview)
  (org-reveal)
  (org-show-subtree)
  (forward-line))

(defun cy/org-file-show-headings (org-file)
  (interactive)
  (find-file (expand-file-name org-file))
  (counsel-org-goto)
  (org-overview)
  (org-reveal)
  (org-show-subtree)
  (forward-line))

(cy/leader-key-def
  "fd" '(:ignore t :which-key "dotfiles")
  "fde" '((lambda () (interactive) (find-file (expand-file-name "~/Projects/dotfiles/Emacs.org"))) :which-key "edit config")
  "fdE" '((lambda () (interactive) (cy/org-file-show-headings "~/Projects/dotfiles/Emacs.org")) :which-key "edit config")
  "fdW" '((lambda () (interactive) (find-file (expand-file-name "~/Projects/dotfiles/Workflow.org"))) :which-key "workflow"))

(use-package hydra
  :defer 1)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

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
  :init
  (ivy-mode 1)
  :config
  (setq ivy-user-virtual-buffers t)
  (setq ivy-wrap t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  ;; Use different regex strategies per completion command.
  (push '(completion-at-point . ivy--regex-fuzzy) ivy-re-builders-alist) ;; this doesn't seem to work.
  (push '(swiper . ivy--regex-ignore-order) ivy-re-builders-alist)
  (push '(counsel-M-x . ivy--regex-ignore-order) ivy-re-builders-alist)
  ;; Set minibuffer height for different commands.
  (setf (alist-get 'counsel-projectile-ag ivy-height-alist) 15)
  (setf (alist-get 'counsel-projectile-rg ivy-height-alist) 15)
  (setf (alist-get 'swiper ivy-height-alist) 15)
  (setf (alist-get 'counsel-switch-buffer ivy-height-alist) 7))

(use-package ivy-hydra
  :defer t
  :after hydra)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1)
  :config
  (setq ivy-format-function #'ivy-format-function-line)
  (setq ivy-rich-display-transformers-list
      (plist-put ivy-rich-display-transformers-list
                 'ivy-switch-buffer
                 '(:columns
                   ((ivy-rich-candidate (:width 40))
                    (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right)); return the buffer indicators
                    (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))          ; return the major mode info
                    (ivy-rich-switch-buffer-project (:width 15 :face success))             ; return project name using `projectile'
                    (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))  ; return file path relative to project root or `default-directory' if project is nil
                   :predicate
                   (lambda (cand)
                     (if-let ((buffer (get-buffer cand)))
                         ;; Don't mess with EXWM buffers if there are any.
                         (with-current-buffer buffer
                           (not (derived-mode-p 'exwm-mode)))))))))




(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^
  ;; (counsel-mode 1))

(use-package flx ;; Improves sorting for fuzzy-matched results.
  :defer t
  :init
  (setq ivy-flx-limit 10000))

(use-package smex ;; Adds M-x recent command sorting for counsel-M-x
  :defer 1
  :after counsel)

(use-package wgrep)

;(use-package ivy-posframe
;  :custom
;  (ivy-posframe-width       115)
;  (ivy-posframe-min-width   115)
;  (ivy-posframe-height      10)
;  (ivy-posframe-min-height  10)
;  :config
;  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-center)))
;  (setq ivy-posframe-parameters '((parent-frame . nil)
;                                   (left-fringe . 8)
;                                   (right-fringe . 8)))
;
;
;
;;;(defun wrappee (num str)
;;;  "Nontrivial wrappee."
;;;  ;; (interactive "nNumber:\nsString:")
;;;  (message "The number is %d.\nThe string is \"%s\"." num str))
;
;(fset 'cy/fix-ivy-posframe-mode-i3 (list 'lambda
;                               '(&rest args)
;                               (concat (documentation 'ivy-posframe-mode t) "\n WEEE.")
;                               (interactive-form 'ivy-posframe-mode)
;                               '(prog1 (apply 'ivy-posframe-mode args)
;                               (message "The wrapper does more. \"%s\"." args)
;                               (x-change-window-property "WM_CLASS" "ZOWIE" (selected-frame) nil nil t))))
;
;
;(cy/fix-ivy-posframe-mode-i3))
  ;; (x-change-window-property "WM_CLASS" "ZOWIE" (selected-frame) nil nil t))

(cy/leader-key-def
  ;; "y"  #'(,(cy/fix-ivy-posframe-mode-i3) :which-key "WTF")
  "r"   '(ivy-resume :which-key "ivy resume")
  "f"   '(:ignore t :which-key "files")
  "ff"  '(counsel-find-file :which-key "open file")
  "C-f" 'counsel-find-file
  "fr"  '(counsel-recentf :which-key "recent files")
  "fR"  '(revert-buffer :which-key "revert file")
  "fj"  '(counsel-file-jump :which-key "jump to file"))

(use-package ace-window
  :bind (("M-o" . ace-window))
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(winner-mode)
(define-key evil-window-map "u" 'winner-undo)
;; (define-key evil-window-map "???" 'winner-redo)

(defun cy/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :defer t
  :hook (org-mode . cy/org-mode-visual-fill))

(use-package expand-region
  :bind (("C-e" . er/expand-region)
         ("C-(" . er/mark-outside-pairs)))

(use-package dired
  :ensure nil
  :defer 1
  :commands (dired dired-jump)
  :config
  (setq dired-listing-switches "-agho --group-directories-first"
        dired-omit-files "^\\.[^.].*"
        dired-omit-verbose nil)

  (autoload 'dired-omit-mode "dired-x")

  (add-hook 'dired-load-hook
    (lambda ()
     (interactive)
     (dired-collapse)))

  (add-hook 'dired-mode-hook
    (lambda ()
      (interactive)
       (dired-omit-mode 1)
       (expand-file-name default-directory)
       (all-the-icons-dired-mode 1)
       (hl-line-mode 1)))

  ; @todo Had to run this once to get the icons.
  ;(use-package all-the-icons-dired
  ;  :hook (dired-mode . all-the-icons-dired-mode))

  ;(add-hook 'dired-mode-hook
  ;  (lambda ()
  ;   (interactive)
  ;   (dired-omit-mode 1)
  ;   (unless
  ;         (s-equals? "/gnu/store/" (expand-file-name default-directory))
  ;         (all-the-icons-dired-mode 1))
  ;   (hl-line-mode 1)))

  (use-package dired-rainbow
    :defer 2
    :config
    (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
    (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
    (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
    (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
    (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
    (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
    (dired-rainbow-define media "#de751f" ("mp3" "mp4" "mkv" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
    (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
    (dired-rainbow-define log "#c17d11" ("log"))
    (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
    (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
    (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
    (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
    (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
    (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
    (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
    (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
    (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
    (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
    (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*"))

  (use-package dired-single
    :ensure t
    :defer t)

  (use-package dired-ranger
    :defer t)

  (use-package dired-collapse
    :defer t)

  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "H" 'dired-omit-mode
    "l" 'dired-single-buffer
    "y" 'dired-ranger-copy
    "X" 'dired-ranger-move
    "p" 'dired-ranger-paste)) ; End of use-package dired

(defun cy/dired-link (path)
  (lexical-let ((target path))
    (lambda () (interactive) (message "Path: %s" target) (dired target))))

(cy/leader-key-def
  "d"   '(:ignore t :which-key "dired")
  "dd"  '(dired :which-key "Here")
  "dh"  `(,(cy/dired-link "~") :which-key "Home")
  "dn"  `(,(cy/dired-link "~/Notes") :which-key "Notes")
  "do"  `(,(cy/dired-link "~/Downloads") :which-key "Downloads")
  "dp"  `(,(cy/dired-link "~/Pictures") :which-key "Pictures")
  "dv"  `(,(cy/dired-link "~/Videos") :which-key "Videos")
  "d."  `(,(cy/dired-link "~/.dotfiles") :which-key "dotfiles")
  "de"  `(,(cy/dired-link "~/.emacs.d") :which-key ".emacs.d"))

;;(use-package openwith
;;  :config
;;  (setq openwith-associations
;;    (list
;;      (list (openwith-make-extension-regexp
;;             '("mpg" "mpeg" "mp3" "mp4"
;;               "avi" "wmv" "wav" "mov" "flv"
;;               "ogm" "ogg" "mkv"))
;;             "mpv"
;;             '(file))
;;      (list (openwith-make-extension-regexp
;;             '("xbm" "pbm" "pgm" "ppm" "pnm"
;;               "png" "gif" "bmp" "tif" "jpeg" "jpg"))
;;             "feh"
;;             '(file))
;;      (list (openwith-make-extension-regexp
;;             '("pdf"))
;;             "google-chrome-stable"
;;             '(file))))
;;  (openwith-mode 1))

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

;; @todo: Move this to another section.
(setq-default fill-column 80)

;; Turn on indentation and auto-fill mode for Org files.
(defun cy/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil)
  (diminish org-indent-mode))

(use-package org
  :defer t
  :hook (org-mode . cy/org-mode-setup)
  :config
  (setq org-ellipses " ▾"
        org-hide-emphasis-markers t
        org-src-fontify-natively t
        org-src-tab-acts-natively t ; Really? @todo
        org-edit-src-content-indentation 0
        org-hide-block-startup nil
        org-src-preserve-indentation nil
        org-startup-folded 'content
        org-cycle-separator-lines 2)
  (setq org-modules
    '(org-habit))
  ;; @todo: Investigate this.
  (setq org-refile-targets '((nil :maxlevel . 3)
                            (org-agenda-files :maxlevel . 3)))
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-use-outline-path t) ;; @todo: This seems dangerous.

  ;; A little evil tweaking.
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-j") 'org-next-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-k") 'org-previous-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "s-j") 'org-metadown)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "s-k") 'org-metaup)

  ;; @IMPORTANT: Subsequent sections are still part of this use-package block.

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python .t)
    (ledger . t))) ; @todo: Ledger for accounting, forgot about that program.
(push '("conf-unix" . conf-unix) org-src-lang-modes)

;(require 'cy-org)
(require 'cy-workflow "~/Projects/dotfiles/.emacs.d/elisp/cy-workflow.el")

;; Automatically tangle when saved without having to worry about org-confirm-babel-evaluate all.
;; Instead, do it around the after-save hook.
(defun cy/org-babel-tangle-dont-ask ()
  ;; (when (string-equal (file-name-directory (buffer-file-name))
  ;;                     (expand-file-name user-emacs-directory))
  ;; Dynamic scoping to the rescue
  (let ((org-confirm-babel-evaluate nil))
    (org-babel-tangle)))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'cy/org-babel-tangle-dont-ask
                                              'run-at-end 'only-in-org-mode)))

(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  (org-superstar-headline-bullets-list '("☰" "☷" "☵" "☲"  "☳" "☴"  "☶"  "☱")))

;; Turn the list hyphen into a dot.
;; (font-lock-add-keywords 'org-mode
;;                           '(("^ *\\([-]\\) "
;;                              (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; Set faces for heading levels
(dolist (face '((org-level-1 . 1.35)
                (org-level-2 . 1.2)
                (org-level-3 . 1.15)
                (org-level-4 . 1.1)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :font "M+ 1p" :weight 'regular :height (cdr face)))

;; Make sure org-indent face is available.
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way.
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil :foreground nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-table nil :foreground nil :inherit '(shadow-fixed-pitch))
(set-face-attribute 'org-verbatim nil :foreground nil :inherit '(shadow-fixed-pitch))
(set-face-attribute 'org-special-keyword nil :foreground nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :foreground nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :foreground nil :inherit 'fixed-pitch)

;; @todo: Others to consider
;; '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
;; '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;; '(org-property-value ((t (:inherit fixed-pitch))) t)
;; '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;; '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
;; '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
;; '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))


;; Using org-bullets
;; (use-package org-bullets
;;   :after org
;;   :hook (org-mode . org-bullets-mode)
;;   :custom
;;   (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
(add-to-list 'org-structure-template-alist '("js" . "src javascript"))
(add-to-list 'org-structure-template-alist '("jsn" . "src json"))
(add-to-list 'org-structure-template-alist '("php" . "src php"))

(use-package org-pomodoro
  :after org
  :config
  (setq org-pomodoro-start-sound "~/.emacs.d/sounds/focus_bell.wav")
  (setq org-pomodoro-short-break-sound "~/.emacs.d/sounds/three_beeps.wav")
  (setq org-pomodoro-long-break-sound "~/.emacs.d/sounds/three_beeps.wav")
  (setq org-pomodoro-finished-sound "~/.emacs.d/sounds/meditation_bell.wav")

  (cy/leader-key-def
    "op" '(org-pomodoro :which-key "pomodoro")))

(require 'org-protocol)

(defun cy/search-org-files ()
  (interactive)
  (counsel-rg "" "~/OneDrive/Notes" nil "Search Notes: "))

(use-package evil-org
  :after org
  :hook ((org-mode . evil-org-mode)
         (org-agenda-mode . evil-org-mode)
         (evil-org-mode . (lambda () (evil-org-set-key-theme '(navigation todo insert textobjects additional)))))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(cy/leader-key-def
  "o"   '(:ignore t :which-key "org-mode")
  "oi"  '(:ignore t :which-key "insert")
  "oil" '(:ignore t :which-key "insert link")
  "on"  '(org-toggle-narrow-to-subtree :which-key "toggle narrow")
  "os"  '(cy/counsel-rg-org-files :which-key "search notes")
  "oa"  '(org-agenda :which-key "status")
  "oc"  '(org-capture t :which-key "capture")
  "ox"  '(org-export-dispatch t :which-key "export"))

;(use-package org-evil
;  :after evil
;  :ensure t)

;; This ends the use-package org-mode block.
)

(use-package org-make-toc
  :hook (org-mode . org-make-toc-mode))

;; Avoid #file.org#
(auto-save-visited-mode)
(setq create-lockfiles nil)
;; Avoid filename.ext~
(setq make-backup-files nil)

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

  (cy/leader-key-def
    "or"    '(:ignore t :which-key "roam")
    "orl"   '(org-roam :which-key "backlinks window")
    "ord"   '(:ignore t :which-key "dailies")
    "ordt"  'org-roam-dailies-today
    "ordT"  'org-roam-dailies-find-tomorrow
    "ordy"  'org-roam-dailies-find-yesterday
    "ordc"  '(:ignore t :which-key "capture")
    "ordcT" 'org-roam-dailies-capture-tomorrow
    "ordct" 'org-roam-dailies-capture-today
    "orf"   'org-roam-find-file
    "org"   'org-roam-show-graph-show
    "ori"   'org-roam-insert
    "orf"   'org-roam-find-file)

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

(require 'org-roam-protocol)

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package evil-magit
  :after magit)

;; Add a super-convenient global binding for magit-status since
;; I use it 8 million times a day.
(global-set-key (kbd "C-M-;") 'magit-status)

(cy/leader-key-def
  "g"   '(:ignore t :which-key "git")
  "gs"  'magit-status
  "gd"  'magit-diff-unstaged
  "gc"  'magit-branch-or-checkout
  "gl"  '(:ignore t :which-key "log")
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb"  'magit-branch
  "gP"  'magit-push-current
  "gp"  'magit-pull-branch
  "gf"  'magit-fetch
  "gF"  'magit-fetch-all
  "gr"  'magit-rebase)

;; Note: Make sure to configure a GitHub token before using this package.
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
;; (use-package forge)

(use-package magit-todos
  :defer t)

(use-package git-link
  :commands git-link
  :config
  (setq git-link-open-in-browser t)
  (cy/leader-key-def
    "gL"  'git-link))

;; @todo Git gutter fringe doesn't get pulled in from MELPA unless I grab it with `use-package' first.
(use-package git-gutter-fringe)
(use-package git-gutter
  :diminish
  :hook ((text-mode . git-gutter-mode)
         (prog-mode . git-gutter-mode))
  :config
  (setq git-gutter:update-interval 2)
    (require 'git-gutter-fringe)
    (set-face-foreground 'git-gutter-fr:added "LightGreen")
    (fringe-helper-define 'git-gutter-fr:added nil
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      ".........."
      ".........."
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      ".........."
      ".........."
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX")

    (set-face-foreground 'git-gutter-fr:modified "LightGoldenrod")
    (fringe-helper-define 'git-gutter-fr:modified nil
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      ".........."
      ".........."
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      ".........."
      ".........."
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX")

    (set-face-foreground 'git-gutter-fr:deleted "LightCoral")
    (fringe-helper-define 'git-gutter-fr:deleted nil
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      ".........."
      ".........."
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      ".........."
      ".........."
      "XXXXXXXXXX"
      "XXXXXXXXXX"
      "XXXXXXXXXX")

  ;; These characters are used in terminal mode
  (setq git-gutter:modified-sign "≡")
  (setq git-gutter:added-sign "≡")
  (setq git-gutter:deleted-sign "≡")
  (set-face-foreground 'git-gutter:added "LightGreen")
  (set-face-foreground 'git-gutter:modified "LightGoldenrod")
  (set-face-foreground 'git-gutter:deleted "LightCoral"))

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

(use-package counsel-projectile
  :after projectile)

(cy/leader-key-def
  "pf" 'counsel-projectile-find-file
  "ps" 'counsel-projectile-switch-project
  "pF" 'counsel-projectile-rg
  "pp" 'counsel-projectile
  "pc" 'projectile-compile-project
  "pd" 'projectile-dired)  ;; @todo: Consider switching to deft for this.

; Old configuration
;(projectile-mode +1)
;(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
;(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; (dir-locals-set-class-variables 'Atom
;;   `((nil . ((projectile-project-name . "Atom")
;;             (projectile-project-compilation-dir . nil)
;;             (projectile-project-compilation-cmd . "script/build")))))
;;
;; (dir-locals-set-directory-class (expand-file-name "~/Projects/Home/atom") 'Atom)

(use-package ivy-xref
  :init (if (< emacs-major-version 27)
          (setq xref-show-xrefs-function #'ivy-xref-show-xrefs )
          (setq xref-show-definitions-function #'ivy-xref-show-defs )))

(use-package lsp-mode
  :commands lsp
  :hook ((typescript-mode js2-mode web-mode) . lsp)
  :bind (:map lsp-mode-map
         ("TAB" . completion-at-point))
  :config (setq lsp-headerline-breadcrumb-enable t
                lsp-enable-on-type-formatting nil
                lsp-enable-indentation nil
                lsp-enable-semantic-highlighting t ; experimental
                lsp-keep-workspace-alive t
                lsp-enable-completion-at-point
                lsp-enable-xref))

(cy/leader-key-def
  "l"   '(:ignore t :which-key "lsp")
  "ld"  'xref-find-definitions
  "lr"  'xref-find-references
  "ln"  'lsp-ui-find-next-reference
  "lp"  'lsp-ui-find-prev-reference
  "ls"  'counsel-imenu
  "le"  'lsp-ui-flycheck-list
  "lS"  'lsp-ui-sideline-mode
  "lX"  'lsp-execute-code-action)

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)

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
  :ensure t
  :hook (lsp-mode . dap-mode)
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (tooltip-mode 1)
  (dap-ui-controls-mode 1)

  (require 'dap-node)
  (dap-node-setup)
  (require 'dap-php)
  (dap-php-setup)
  (require 'dap-firefox)
  (dap-firefox-setup)
  (require 'dap-chrome)
  (dap-chrome-setup))

  ;; Example template.
  ;(dap-register-debug-template: "Node: Attach"
  ;  (list :type "node"
  ;        :cwd nil
  ;        :request "attach"
  ;        :program "nil"
  ;        :port 9002 ;9229?
  ;        :name "Node::Run")))

(use-package nvm
   :defer t)

(use-package add-node-modules-path
  :disabled
  :after js2-mode
  :hook (js2-mode-hook . add-node-modules-path)
        (js-mode-hook . add-node-modules-path))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :config
  (setq typescript-indent-level 2))

(defun cy/set-js-indentation ()
  (setq js-indent-level 2)
  (setq evil-shift-width js-indent-level)
  (setq default-tab-width 2))

(use-package js2-mode
  :mode "\\.jsx?\\'"
  :config

  ;; Use js2-mode for Node scripts
  (add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))

  ;; Don't use built-in syntax checking.
  ;; @todo Why not?
  (setq js2-mode-show-strict-warnings nil)

  ;; Set up proper indentation in JavaScript and JSON files
  (add-hook 'js2-mode-hook #'cy/set-js-indentation)
  (add-hook 'json-mode-hook #'cy/set-js-indentation))

;; I can't get prettier to work, it won't find my global install or the node_modules bin.
;;(use-package prettier-js
;;  :after add-node-modules-path
;;  :hook ((js2-mode . prettier-js-mode)
;;         (typescript-mode . prettier-js-mode))
;;  :config
;;  (setq prettier-js-show-errors nil))

;
;(use-package typescript-mode
;  :mode "\\.ts\\'"
;  :hook (typescript-mode . lsp-deferred)
;  :config
;  (setq typescript-indent-level 2))

(add-hook 'emacs-lisp-mode-hook #'flycheck-mode)

;; Improved help in Emacs.
(use-package helpful
  :ensure t
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

(cy/leader-key-def
  "e"   '(:ignore t :which-key "eval")
  "eb"  '(eval-buffer :which-key "eval buffer"))

(cy/leader-key-def
  :keymaps   '(visual)
  "er"  '(eval-region :which-key "eval region"))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
(add-to-list 'auto-mode-alist '("\\.esdoc\\.json\\'" . json-mode))
(add-to-list 'auto-mode-alist '("\\.*\\.json\\'" . json-mode))

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

(use-package web-mode
  :mode "(\\.\\(html?\\|ejs\\|tsx\\|jsx\\)\\'"
  :config
  (setq-default web-mode-code-indent-offset 2)
  (setq-default web-mode-markup-indent-offset 2)
  (setq-default web-mode-attribute-indent-offset 2))

;; 1. Start the server with `httpd-start'
;; 2. Use `impatient-mode' on any buffer
(use-package impatient-mode
  :ensure t)
(use-package skewer-mode
  :ensure t)

(use-package yaml-mode
  :mode "\\.ya?ml\\'")

(use-package lispy
  :hook ((emacs-lisp-mode . lispy-mode)
         (scheme-mode . lispy-mode)))

(use-package lispyville
  :disabled
  :hook ((lispy-mode . lispyville-mode))
  :config
  (lispyville-set-key-theme '(operators c-w additional)))

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

(use-package flycheck
 :ensure t
 :init (global-flycheck-mode))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package smartparens
  :hook (prog-mode . smartparens-mode))

(show-paren-mode 1)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode
  :defer t
  :hook (org-mode
         emacs-lisp-mode
         web-mode
         typescript-mode
         js2-mode))

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

(use-package treemacs
  :ensure t
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
          treemacs-resize-icons 44
          treemacs-follow-mode
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

(use-package know-your-http-well
  :defer t)

(use-package olivetti
   :config
   (add-hook 'text-mode-hook 'olivetti-mode)
   ;(add-hook 'text-mode-hook (lambda () (setq indent-line-function #'indent-relative)))
   (setq-default olivetti-body-width 120))

(setq org-latex-toc-command "\\tableofcontents \\clearpage")

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

(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

(use-package term
  :config
  (setq explicit-shell-file-name "zsh")
  ;;(setq explicit-zsh-args '())        ;; Use explicit-<shell>-args for shell-specific configs

  ;; Set up the prompt:
 (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package ledger-mode
  :mode "\\.lgr\\'"
  :bind (:map ledger-mode-map
              ("TAB" . completion-at-point)))

(use-package calfw
  :commands cfw:open-org-calendar
  :config
  (setq cfw:fchar-junction ?╋
        cfw:fchar-vertical-line ?┃
        cfw:fchar-horizontal-line ?━
        cfw:fchar-left-junction ?┣
        cfw:fchar-right-junction ?┫
        cfw:fchar-top-junction ?┯
        cfw:fchar-top-left-corner ?┏
        cfw:fchar-top-right-corner ?┓)

  (use-package calfw-org
    :config
    (setq cfw:org-agenda-schedule-args '(:timestamp))))

(cy/leader-key-def
  "cc"  '(cfw:open-org-calendar :which-key "calendar"))
