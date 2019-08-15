(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
  '(ansi-color-faces-vector
     [default default default italic underline success warning error])
  '(ansi-color-names-vector
     ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(column-number-mode t)
 '(custom-enabled-themes '(manoj-dark))
  '(custom-safe-themes
     '("1b27e3b3fce73b72725f3f7f040fd03081b576b1ce8bbdfcb0212920aec190ad" "b59d7adea7873d58160d368d42828e7ac670340f11f36f67fa8071dbf957236a" "11e57648ab04915568e558b77541d0e94e69d09c9c54c06075938b6abc0189d8" default))
 '(doom-modeline-buffer-file-name-style 'relative-from-project)
 '(doom-modeline-icon nil)
 '(doom-modeline-indent-info t)
 '(fci-rule-color "#5c5e5e")
 '(jdee-db-active-breakpoint-face-colors (cons "#0d0d0d" "#81a2be"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#0d0d0d" "#b5bd68"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#0d0d0d" "#5a5b5a"))
 '(objed-cursor-color "#cc6666")
  '(package-selected-packages
     '(airline-themes powerline-evil powerline minions doom-themes helm molokai-theme doom-modeline use-package slime-repl-ansi-color evil-numbers evil-leader editorconfig company))
 '(save-place-mode t)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(vc-annotate-background "#1d1f21")
  '(vc-annotate-color-map
     (list
       (cons 20 "#b5bd68")
       (cons 40 "#c8c06c")
       (cons 60 "#dcc370")
       (cons 80 "#f0c674")
       (cons 100 "#eab56d")
       (cons 120 "#e3a366")
       (cons 140 "#de935f")
       (cons 160 "#d79e84")
       (cons 180 "#d0a9a9")
       (cons 200 "#c9b4cf")
       (cons 220 "#ca9aac")
       (cons 240 "#cb8089")
       (cons 260 "#cc6666")
       (cons 280 "#af6363")
       (cons 300 "#936060")
       (cons 320 "#765d5d")
       (cons 340 "#5c5e5e")
       (cons 360 "#5c5e5e")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight semi-bold :height 120 :width normal :foundry "adobe" :family "SauceCodePro Nerd Font")))))


;;: GENERAL CONFIGURATION
(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

;;; PACKAGES

;; this block must come first.
(require 'package)
(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/") t)
(package-initialize)

;; use-package stuff
(eval-when-compile
  (require 'use-package))
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Evil-mode
(use-package evil
  :config (evil-mode 1))
(use-package evil-numbers
  :requires evil)
(use-package evil-leader
  :requires evil)

;; Enable company-mode everywhere
(use-package company
  :hook (after-init . global-company-mode))

(use-package editorconfig
  :config (editorconfig-mode 1))

(use-package minions
  :config (minions-mode 1))

;;(use-package doom-modeline
;;  :custom
;;  (doom-modeline-buffer-file-name-style 'relative-from-project)
;;  (doom-modeline-icon (display-graphic-p))
;;  (doom-modeline-indent-info t)
;;  :hook (after-init . doom-modeline-mode))

(use-package airline-themes
  :config (load-theme 'airline-dark))

(use-package powerline-evil)
(use-package powerline
  :after (powerline-evil)
  :config (powerline-default-theme))

;; helm config
(use-package helm
  :config (helm-mode 1))

(global-set-key (kbd "M-x") 'helm-M-x)
(define-key global-map [remap find-file] 'helm-find-files)
(define-key global-map [remap occur] 'helm-occur)
(define-key global-map [remap list-buffers] 'helm-buffers-list)
(define-key global-map [remap dabbrev-expand] 'helm-dabbrev)
(define-key global-map [remap execute-extended-command] 'helm-M-x)
(unless (boundp 'completion-in-region-function)
  (define-key lisp-interaction-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point)
  (define-key emacs-lisp-mode-map       [remap completion-at-point] 'helm-lisp-completion-at-point))

(setq helm-grep-ag-command "rg --color=always --colors 'match:fg:black' --colors 'match:bg:yellow' --smart-case --no-heading --line-number %s %s %s")
(setq helm-grep-ag-pipe-cmd-switches '("--colors 'match:fg:black'" "--colors 'match:bg:yellow'"))
