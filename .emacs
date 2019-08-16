(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
  '(custom-safe-themes
     '("251348dcb797a6ea63bbfe3be4951728e085ac08eee83def071e4d2e3211acc3" "a2cde79e4cc8dc9a03e7d9a42fabf8928720d420034b66aecc5b665bbf05d4e9" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" default))
  '(package-selected-packages
     '(monokai-theme use-package slime-repl-ansi-color powerline-evil minions helm-company evil-numbers evil-leader editorconfig airline-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight semi-bold :height 120 :width normal :foundry "adobe" :family "SauceCodePro Nerd Font")))))


;;: GENERAL CONFIGURATION

(column-number-mode t)      ;; Enable column information in the modeline.
(save-place-mode t)         ;; Save our place in each file.
(show-paren-mode t)         ;; Highlight matching braces.
(size-indication-mode t)    ;; Show the size of the buffer in the modeline.
(tool-bar-mode nil)         ;; Disable the tool bar in the GUI.
(setq vc-follow-symlinks t) ;; Always follow symlinks.

;; Enable line numbers for Emacs >= 26.1
(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))


;;; PACKAGES

;; Add MELPA to the package archives
(require 'package)
(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/") t)
(package-initialize)

;; Use the "use-package" package to manage packages.
;; Make sure it's loaded *after* package.el but *before* anything else.
(eval-when-compile
  (require 'use-package))
;; If a package "used" below doesn't exist, install it.
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Evil-mode, for vi-like emulation and keybindings.
(use-package evil
  :config (evil-mode 1))
(use-package evil-numbers
  :requires evil)
(use-package evil-leader
  :requires evil)

;; Company mode is an in-buffer text-completion framework.
(use-package company
  :hook (after-init . global-company-mode))

;; Editorconfig reads .editorconfig files and configures settings accordingly.
(use-package editorconfig
  :config (editorconfig-mode 1))

;; Minions is a minor mode helper.
(use-package minions
  :config (minions-mode 1))

;; Helm is an "incremental completion and selection-narrowing framework"
(use-package helm
  :config (helm-mode 1))

;; Rebind M-x to use Helm mode.
(global-set-key (kbd "M-x") 'helm-M-x)
;; Remap various functions to the Helm equivalent
(define-key global-map [remap find-file] 'helm-find-files)
(define-key global-map [remap occur] 'helm-occur)
(define-key global-map [remap list-buffers] 'helm-buffers-list)
(define-key global-map [remap dabbrev-expand] 'helm-dabbrev)
(define-key global-map [remap execute-extended-command] 'helm-M-x)
(unless (boundp 'completion-in-region-function)
  (define-key lisp-interaction-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point)
  (define-key emacs-lisp-mode-map       [remap completion-at-point] 'helm-lisp-completion-at-point))

;; Use 'rg' instead of 'ag' in Helm
(setq helm-grep-ag-command "rg --color=always --colors 'match:fg:black' --colors 'match:bg:yellow' --smart-case --no-heading --line-number %s %s %s")
(setq helm-grep-ag-pipe-cmd-switches '("--colors 'match:fg:black'" "--colors 'match:bg:yellow'"))


;;; THEMES AND UI

(use-package monokai-theme
  :config (load-theme 'monokai))

;; doom-modeline is a modeline taken from the Doom Emacs project.
;;(use-package doom-modeline
;;  :custom
;;  (doom-modeline-buffer-file-name-style 'relative-from-project)
;;  (doom-modeline-icon (display-graphic-p))
;;  (doom-modeline-icon nil)
;;  (doom-modeline-indent-info t)
;;  :hook (after-init . doom-modeline-mode))

;; A port of the Vim airline themes to Emacs.
(use-package airline-themes
  :config (load-theme 'airline-cool))

;; powerline-evil expands Powerline with Evil-mode information
(use-package powerline-evil)

;; Powerline is the venerable status line configurator from Vim.
(use-package powerline
  :after (powerline-evil)
  :config (powerline-default-theme))
