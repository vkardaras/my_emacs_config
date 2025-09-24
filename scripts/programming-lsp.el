;;; programming.el --- Setings for programming -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 Vasilis
;;
;; Author: Vasilis <vasilis@vasilis-MacBookPro>
;; Maintainer: Vasilis <vasilis@vasilis-MacBookPro>
;; Created: September 23, 2025
;; Modified: September 23, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/vasilis/programming
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

;; completion
(use-package company)

;; Git timemachine
(use-package git-timemachine
  :after git-timemachine
  :hook (evil-normalize-keymaps . git-timemachine-hook)
  :config
    (evil-define-key 'normal git-timemachine-mode-map (kbd "C-j") 'git-timemachine-show-previous-revision)
    (evil-define-key 'normal git-timemachine-mode-map (kbd "C-k") 'git-timemachine-show-next-revision)
)
;; Magit
(use-package magit)

;; Perspective
(use-package perspective
  :ensure t
  :custom
  ;; NOTE! I have also set 'SCP =' to open the perspective menu.
  ;; I'm only setting the additional binding because setting it
  ;; helps suppress an annoying warning message.
  (persp-mode-prefix-key (kbd "C-c M-p"))
  :init
  (persp-mode)
  :config
  ;; Sets a file to write to when we save states
  (setq persp-state-default-file (concat user-emacs-directory "sessions")))

;; This will group buffers by persp-name in ibuffer.
(add-hook 'ibuffer-hook
          (lambda ()
            (persp-ibuffer-set-filter-groups)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))

;; Automatically save perspective states to file when Emacs exits.
(add-hook 'kill-emacs-hook #'persp-state-save)

;; Project management
(use-package project
  :bind-keymap
  (("C-c p" . project-prefix-map)))

;; treemacs
(use-package treemacs
  :config (treemacs-project-follow-mode t))
(add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :config (treemacs-set-scope-type 'Perspectives))

;; LSP
(use-package lsp-mode
  :init (setq lsp-keymap-prefix "C-c l")
  :bind
  (:map lsp-mode-map
        (("\C-\M-b" . lsp-find-implementation)
         ("M-RET" . lsp-execute-code-action)))
  :hook ((lsp-mode . lsp-enable-which-key-integration)))
(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))
(use-package lsp-ui)
(use-package lsp-treemacs)
(use-package consult-lsp)

;; DAP
(use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
(use-package dap-java
  :straight (lsp-java)
  :config
  (global-set-key (kbd "<f7>") 'dap-step-in)
  (global-set-key (kbd "<f8>") 'dap-next)
  (global-set-key (kbd "<f9>") 'dap-continue))
(add-hook 'compilation-filter-hook
          (lambda () (ansi-color-apply-on-region (point-min) (point-max))))
(use-package yasnippet :config (yas-global-mode))


(provide 'programming-lsp)
;;; programming.el ends here
