;; -*- lexical-binding: t -*-
;; Time-stamp: <2018-01-26 01:33:35 csraghunandan>

;; dired: file system manager for emacs
(use-package dired :ensure nil
  :bind (:map dired-mode-map
              ("S" . ora-dired-get-size))
  :config
  (progn
    ;; mark symlinks
    (setq dired-ls-F-marks-symlinks t)
    ;; Never prompt for recursive copies of a directory
    (setq dired-recursive-copies 'always)
    ;; Never prompt for recursive deletes of a directory
    (setq dired-recursive-deletes 'always)
    ;; makes dired guess the target directory
    (setq dired-dwim-target t)

    ;; Dired listing switches
    ;;  -a : Do not ignore entries starting with .
    ;;  -l : Use long listing format.
    ;;  -h : Human-readable sizes like 1K, 234M, ..
    ;;  -v : Do natural sort .. so the file names starting with . will show up first.
    ;;  -F : Classify filenames by appending '*' to executables,'/' to directories, etc.
    ;; default value for dired: "-al"
    (setq dired-listing-switches (if (is-windows-p)
                                     "-alh"
                                   "-alhvF --group-directories-first"))

    ;; auto-revert dired buffers if file changed on disk
    (setq dired-auto-revert-buffer t)

    (defun rag/dired-rename-buffer-name ()
      "Rename the dired buffer name to distinguish it from file buffers.
It added extra strings at the front and back of the default dired buffer name."
      (let ((name (buffer-name)))
        (if (not (string-match "/$" name))
            (rename-buffer (concat "*Dired* " name "/") t))))

    (add-hook 'dired-mode-hook #'rag/dired-rename-buffer-name))

  ;; dired-quick-sort: hydra to sort files in dired
  ;; Press `S' to invoke dired-quick-sort hydra
  ;; https://gitlab.com/xuhdev/dired-quick-sort
  (use-package dired-quick-sort
    :bind (:map dired-mode-map
                ("s" . hydra-dired-quick-sort/body)))

  (defvar du-program-name (executable-find "du"))
  (defun ora-dired-get-size ()
    "Get the size of a folder recursively"
    (interactive)
    (let ((files (dired-get-marked-files)))
      (with-temp-buffer
        (apply 'call-process du-program-name nil t nil "-sch" files)
        (message
         "Size of all marked files: %s"
         (progn
           (re-search-backward "\\(^[ 0-9.,]+[A-Za-z]+\\).*total$")
           (match-string 1))))))

  ;; dired-x: to hide uninteresting files in dired
  (use-package dired-x :ensure nil
    :config
    (setq dired-omit-verbose nil)
    ;; hide backup, autosave, *.*~ files
    ;; omit mode can be toggled using `C-x M-o' in dired buffer.
    (add-hook 'dired-mode-hook #'dired-omit-mode)
    (setq dired-omit-files
          (concat dired-omit-files "\\|^.DS_STORE$\\|^.projectile$\\|^.git$"))))

;; dired-collapse: collapse unique nested paths in dired listing
;; https://github.com/Fuco1/dired-hacks#dired-collapse
(use-package dired-collapse
  :config
  (add-hook 'dired-mode-hook 'dired-collapse-mode))

;; diredfl:Extra Emacs font lock rules for a more colourful dired
;; https://github.com/purcell/diredfl/tree/085eabf2e70590ec8e31c1e66931d652d8eab432
(use-package diredfl
  :config
  (diredfl-global-mode))

;; https://oremacs.com/2017/03/18/dired-ediff/
(defun ora-ediff-files ()
  (interactive)
  (let ((files (dired-get-marked-files))
        (wnd (current-window-configuration)))
    (if (<= (length files) 2)
        (let ((file1 (car files))
              (file2 (if (cdr files)
                         (cadr files)
                       (read-file-name
                        "file: "
                        (dired-dwim-target-directory)))))
          (if (file-newer-than-file-p file1 file2)
              (ediff-files file2 file1)
            (ediff-files file1 file2))
          (add-hook 'ediff-after-quit-hook-internal
                    (lambda ()
                      (setq ediff-after-quit-hook-internal nil)
                      (set-window-configuration wnd))))
      (error "no more than 2 files should be marked"))))
(define-key dired-mode-map "E" 'ora-ediff-files)

;; make dired use the same buffer when moving up a directory
(define-key dired-mode-map (kbd "^")
  (lambda () (interactive) (find-alternate-file "..")))

(provide 'setup-dired)
