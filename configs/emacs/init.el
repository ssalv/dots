;;; -*- lexical-binding: t -*-

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

(require 'package)
(setq package-archives
      '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
	("MELPA Stable" . "https://stable.melpa.org/packages/")
	("MELPA"        . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("MELPA" . 10)
	("GNU ELPA"     . 5)
	("MELPA Stable"        . 0)))


(package-initialize)

(when (< emacs-major-version 29)
  (unless (package-installed-p 'use-package)
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'use-package)))

(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

  (setq make-backup-files nil)
  (setq backup-inhibited nil) ; Not sure if needed, given `make-backup-files'
  (setq create-lockfiles nil)

;; Make native compilation silent.
(when (native-comp-available-p)
  (setq native-comp-async-report-warnings-errors 'silent))

(setq-default line-spacing 0.1)
(visual-line-mode)

(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)

;; Confortable buffers
(keymap-global-set "C-c b" 'ibuffer)

;; Recent Files
(recentf-mode 1)
(keymap-global-set "C-c r" 'recentf)

;; Magit
(use-package magit
  :ensure t
  :config
  (setq magit-auto-revert-mode nil)
  (setq magit-save-repository-buffers 'dontask)
  :bind (("C-x g" . magit-status)))

;; http://stackoverflow.com/questions/13794433/how-to-disable-autosave-for-tramp-buffers-in-emacs
;; Don't use VC on remote (TRAMP) files
(setq vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))
(with-eval-after-load 'tramp
  (setq tramp-auto-save-directory "/tmp")
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  (setq remote-file-name-inhibit-cache nil)
  (setq remote-file-name-inhibit-locks t)
  (setq tramp-verbose 1)
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  (setq tramp-direct-async-process t))

(use-package dired
  :ensure nil
  :commands (dired)
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode))
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t))

(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrides nil))

(use-package savehist
  :ensure nil ; it is built-in
  :hook (after-init . savehist-mode))

(use-package org-modern
  :ensure t
  :config
  (setq org-modern-hide-stars nil)
  (add-hook 'org-mode-hook #'org-modern-mode)
  (add-hook 'org-agenda-finalize-hook #'org-modern-agenda))

(setq org-startup-indented t)

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Notes/roam"))
  (org-roam-completion-everywhere t)
  (org-roam-dailies-capture-templates
   '(("d" "default" entry "* %<%I:%M %p>: %?"
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
	 :map org-mode-map
	 ("C-M-i" . completion-at-point)
	 :map org-roam-dailies-map
	 ("Y" . org-roam-dailies-capture-yesterday)
	 ("T" . org-roam-dailies-capture-tomorrow))
  :config
  (org-roam-setup)
  
  (require 'org-roam-protocol)
  (require 'org-roam-dailies) ;; Ensure the keymap is available

  (org-roam-db-autosync-mode))

(setq org-return-follows-link t)

(add-to-list 'load-path "~/.emacs.d/packages/nano-emacs")
(require 'nano-layout)



(setq nano-font-family-monospaced "Iosevka Term Curly")
(setq nano-font-family-proportional "Iosevka Etoile")
(setq nano-font-size 14)

;; Theme
(require 'nano-faces)
(require 'nano-theme)
(require 'nano-theme-dark)
(require 'nano-theme-light)


;; Theming Command line options (this will cancel warning messages)
(add-to-list 'command-switch-alist '("-dark"   . (lambda (args))))
(add-to-list 'command-switch-alist '("-light"  . (lambda (args))))
(add-to-list 'command-switch-alist '("-default"  . (lambda (args))))
(add-to-list 'command-switch-alist '("-no-splash" . (lambda (args))))
(add-to-list 'command-switch-alist '("-no-help" . (lambda (args))))
(add-to-list 'command-switch-alist '("-compact" . (lambda (args))))
(cond
 ((member "-default" command-line-args) t)
 ((member "-dark" command-line-args) (nano-theme-set-dark))
 (t (nano-theme-set-light)))
(call-interactively 'nano-refresh-theme)

(with-eval-after-load 'org
  (defun my/style-org-header-sizes ()
    (interactive)
    "Set custom heights for org-level faces to work with nano-emacs."
    (let ((levels '(1.5 1.3 1.15 1.05))) ; Heights: 150%, 130%, 115%, 105%
      (dotimes (i (length levels))
        (let ((face (intern (format "org-level-%d" (1+ i))))
              (size (nth i levels)))
          (set-face-attribute face nil :height size :weight 'bold)))))

  ;; Apply the sizes
  (my/style-org-header-sizes))
(set-face-attribute 'org-level-1 nil 
                    :height 1.6 
                    :weight 'bold
                    :overline t)

;; Nano default settings (optional)
(require 'nano-defaults)

;; Nano session saving (optional)
(require 'nano-session)

;; Nano header & mode lines (optional)
(require 'nano-modeline)

;; Splash (optional)
(unless (member "-no-splash" command-line-args)
  (require 'nano-splash))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(which-key-mode 1)

(use-package spacious-padding
  :ensure nil
  :load-path "~/.emacs.d/packages/spacious-padding"
  :config
  ;; These are the default values, but I keep them here for visibility.
  ;; Also check `spacious-padding-subtle-frame-lines'.
  (setq spacious-padding-widths
        '( :internal-border-width 16
           :header-line-width 0
           :mode-line-width 0
           :custom-button-width 3
           :tab-width 4
           :right-divider-width 16
           :scroll-bar-width 8
           :fringe-width 8))

  (spacious-padding-mode 1)

  ;; Set a key binding if you need to toggle spacious padding.
  (define-key global-map (kbd "<f8>") #'spacious-padding-mode))

(use-package nyan-mode
  :ensure t
  :config
  (nyan-mode))
