;; Time-stamp: <2017-12-02 15:03:48 csraghunandan>

;; view the list recently opened files
(use-package recentf :defer 1
  :config
  (recentf-mode)
  (setq recentf-max-menu-items 150)
  (setq recentf-max-saved-items 150)
  (setq recentf-exclude
        '("/elpa/" ;; ignore all files in elpa directory
          "recentf" ;; remove the recentf load file
          ".*?autoloads.el$"
          "company-statistics-cache.el" ;; ignore company cache file
          "/intero/" ;; ignore script files generated by intero
          "/journal/" ;; ignore daily journal files
          ".gitignore" ;; ignore `.gitignore' files in projects
          "/tmp/" ;; ignore temporary files
          "NEWS" ;; don't include the NEWS file for recentf
          "bookmarks"  "bmk-bmenu" ;; ignore bookmarks file in .emacs.d
          "loaddefs.el")))

(provide 'setup-recentf)
