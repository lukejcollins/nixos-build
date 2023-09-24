(require 'use-package)

;; Theme
(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-light t))

;; Startup appearance
(setq fancy-splash-image "~/Pictures/gnu_color.png")

;; Clipboard Configuration
(setq select-enable-clipboard t
      select-enable-primary t)

;; Disable tooltip mode
(tooltip-mode -1)

;; Helm configuration
(use-package helm
  :ensure t
  :config (helm-mode 1)
  :bind (("M-x" . helm-M-x)))

;; Treemacs configuration
(use-package treemacs
  :ensure t
  :bind (("C-x t" . treemacs))
  :custom (treemacs-theme "all-the-icons")
  :config
  (use-package treemacs-all-the-icons
    :ensure t))

;; Vterm configuration
(use-package vterm
  :ensure t
  :config
  (setq vterm-max-scrollback 5000))

;; Linting with Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(python-pycompile))
  (add-hook 'python-mode-hook (lambda () (flycheck-select-checker 'python-flake8)))
  (add-hook 'sh-mode-hook (lambda () (flycheck-select-checker 'sh-shellcheck)))
  (add-hook 'dockerfile-mode-hook (lambda () (flycheck-select-checker 'dockerfile-hadolint)))
  (add-hook 'nix-mode-hook (lambda () (flycheck-select-checker 'nix-statix)))
  (add-hook 'terraform-mode-hook (lambda () (flycheck-select-checker 'terraform-tflint))))

(use-package flycheck-inline
  :ensure t
  :after flycheck
  :hook (flycheck-mode . flycheck-inline-mode))

;; Modes for various file types
(use-package terraform-mode :ensure t)
(use-package dockerfile-mode :ensure t)
(use-package nix-mode :ensure t)

;; Python configuration
(use-package blacken
  :ensure t
  :hook (python-mode . blacken-mode)
  :config
  (setq blacken-line-length 79))

;; Formatting keybinding
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (cond ((eq major-mode 'python-mode) (blacken-buffer))
                                     ((eq major-mode 'sh-mode) (shell-command-on-region (point-min) (point-max) "shfmt" (current-buffer) t))
                                     ((eq major-mode 'nix-mode) (shell-command-on-region (point-min) (point-max) "nixpkgs-fmt" (current-buffer) t))
                                     ((eq major-mode 'terraform-mode) (shell-command-on-region (point-min) (point-max) "terraform fmt" nil t))
                                     (t (message "No formatter specified for %s" major-mode)))))
