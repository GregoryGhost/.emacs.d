;; Time-stamp: <2017-09-10 14:41:11 csraghunandan>

;; racket-mode: major mode for editing racket files
;; https://github.com/greghendershott/racket-mode
(use-package racket-mode :defer t
  :config
  (defun my-racket-mode-hook ()
    (set (make-local-variable 'company-backends)
         '((company-capf company-dabbrev-code company-files company-yasnippet))))
  (defun my-racket-mode-hook2 ()
    (set (make-local-variable 'company-backends)
         '((company-capf company-dabbrev-code company-yasnippet))))
  (add-hook 'racket-mode-hook 'my-racket-mode-hook)
  (add-hook 'racket-mode-hook 'company-mode)
  (add-hook 'racket-repl-mode-hook 'my-racket-mode-hook2)
  (add-hook 'racket-repl-mode-hook 'company-mode))

(provide 'setup-racket)
