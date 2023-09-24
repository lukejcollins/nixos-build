(require 'use-package)

;; Solarized theme
(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-light t))

;; Change GNU logo
(setq fancy-splash-image "~/Pictures/gnu_color.png")

;; Use Treemacs
(use-package treemacs
  :ensure t
  :config
  (use-package treemacs-all-the-icons
    :ensure t)

  ;; Keybindings (customize as you prefer)
  :bind
  (("C-x t" . treemacs))

  ;; Configure icons (if you have treemacs-all-the-icons installed)
  :custom
  (treemacs-theme "all-the-icons"))

;; Clipboard Configuration
(setq select-enable-clipboard t
      select-enable-primary t)

;; Terraform Mode for syntax highlighting
(use-package terraform-mode :ensure t)

;; Dockerfile Mode for syntax highlighting
(use-package dockerfile-mode :ensure t)

;; Nix Mode for syntax highlighting
(use-package nix-mode :ensure t)

;; Flycheck Configuration for linting
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Flycheck Inline Configuration
(use-package flycheck-inline
  :ensure t
  :after flycheck
  :hook (flycheck-mode . flycheck-inline-mode))

;; Set specific checkers for each mode
(use-package flycheck
  :config
  (setq-default flycheck-disabled-checkers '(python-pycompile))
  (add-hook 'python-mode-hook (lambda () (flycheck-select-checker 'python-flake8)))
  (add-hook 'sh-mode-hook (lambda () (flycheck-select-checker 'sh-shellcheck)))
  (add-hook 'dockerfile-mode-hook (lambda () (flycheck-select-checker 'dockerfile-hadolint)))
  (add-hook 'nix-mode-hook (lambda () (flycheck-select-checker 'nix-statix)))
  (add-hook 'terraform-mode-hook (lambda () (flycheck-select-checker 'terraform-tflint))))

;; Blacken Configuration for Python
(use-package blacken
  :ensure t
  :hook (python-mode . blacken-mode)
  :config
  (setq blacken-line-length 79))

;; Bind F5 to format buffer
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (cond ((eq major-mode 'python-mode) (blacken-buffer))
                                     ((eq major-mode 'sh-mode) (shell-command-on-region (point-min) (point-max) "shfmt" (current-buffer) t))
                                     ((eq major-mode 'nix-mode) (shell-command-on-region (point-min) (point-max) "nixpkgs-fmt" (current-buffer) t))
                                     ((eq major-mode 'terraform-mode) (shell-command-on-region (point-min) (point-max) "terraform fmt" nil t))
                                     (t (message "No formatter specified for %s" major-mode)))))
