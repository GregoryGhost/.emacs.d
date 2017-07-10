;;; -*- lexical-binding: t -*-
;; Time-stamp: <2017-07-11 01:20:47 csraghunandan>

;; counsel: ivy backends for a lot more commands
;; https://github.com/abo-abo/swiper
(use-package counsel
  :diminish counsel-mode
  :bind*
  (("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   :map ivy-minibuffer-map
   ("M-y" . ivy-next-line-and-call))

  :init (counsel-mode)
  :config
  ;; ignore case sensitivity for counsel grep
  (setq counsel-grep-base-command "grep -nEi \"%s\" %s")

  (defun reloading (cmd)
    (lambda (x)
      (funcall cmd x)
      (ivy--reset-state ivy-last)))
  (defun given-file (cmd prompt) ; needs lexical-binding
    (lambda (source)
      (let ((target
             (let ((enable-recursive-minibuffers t))
               (read-file-name
                (format "%s %s to:" prompt source)))))
        (funcall cmd source target 1))))
  (defun confirm-delete-file (x)
    (dired-delete-file x 'confirm-each-subdirectory))

  (ivy-add-actions
   'counsel-find-file
   `(("c" ,(given-file #'copy-file "Copy") "copy")
     ("d" ,(reloading #'confirm-delete-file) "delete")
     ("m" ,(reloading (given-file #'rename-file "Move")) "move")))
  (ivy-add-actions
   'counsel-projectile-find-file
   `(("c" ,(given-file #'copy-file "Copy") "copy")
     ("d" ,(reloading #'confirm-delete-file) "delete")
     ("m" ,(reloading (given-file #'rename-file "Move")) "move")
     ("b" counsel-find-file-cd-bookmark-action "cd bookmark")))

  ;; counsel-rg
  ;; Redefine `counsel-rg-base-command' with my required options, especially
  ;; the `--follow' option to allow search through symbolic links (part of
  ;; `modi/rg-arguments').
  (when (executable-find "rg")
    (setq counsel-rg-base-command
          "rg --line-number --smart-case --follow --mmap --no-heading %s"))

  (defun rag/counsel-rg-project-at-point ()
    "use counsel rg to search for the word at point in the project"
    (interactive)
    (counsel-rg (thing-at-point 'symbol) (projectile-project-root)))

  ;; find file at point
  (setq counsel-find-file-at-point t)

  ;; ignore . files or temporary files
  (setq counsel-find-file-ignore-regexp
        (concat
         ;; File names beginning with # or .
         "\\(?:\\`[#.]\\)"
         ;; File names ending with # or ~
         "\\|\\(?:\\`.+?[#~]\\'\\)"))

  (bind-keys
   ("C-c g g" . counsel-git-grep)
   ("C-c m r" . counsel-mark-ring)
   ("C-c f" . counsel-imenu)
   ("M-y" . counsel-yank-pop)
   ("C-c F" . ivy-imenu-anywhere)
   ("C-c d s" . describe-symbol)
   ("C-c d f" . counsel-faces)
   ("C-c d d" . counsel-descbinds)
   ("C-c r g" . counsel-rg)
   ("C-c s p" . rag/counsel-rg-project-at-point)))

(provide 'setup-counsel)

;; interesting counsel commands
;; `counsel-file-jump' -> get all the files in a directory recursively
;; `counsel-dired-jump' -> Jump to a directory (in dired) from a list of all
;;                         directories below the current one.
;; `counsel-colors-emacs' -> list all the colors emacs recognises
;; `counsel-colors-web' -> list all the colors that the web browser recognises
;; `counsel-command-history' -> browse through all the commands entered in `M-x'
;; `counsel-yank-pop' -> access the kill ring using ivy
;; `counsel-unicode-char' -> search through Unicode characters using ivy
;; `counsel-rg' -> search the all files in the current directory using `ripgrep'
;; `rag/counsel-rg-project-at-point' -> search all files in the current project
;; `counsel-descbinds' -> lists all the key bindings in the current buffer
;; `counsel-mark-ring' -> access the mark ring for the current buffer using ivy
;; `counsel-faces' -> lists all the face colours in emacs
