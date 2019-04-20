;;; php-lang.el --- PHP related configuration. -*- lexical-binding: t; -*-

;; Copyright (C) 2019 Serghei Iakovlev <sadhooklay@gmail.com>

;; Author: Serghei Iakovlev <sadhooklay@gmail.com>
;; URL: https://github.com/sergeyklay/.emacs.d
;;
;; This file is not part of GNU Emacs.
;;
;; License: GPLv3

;;; Commentary:

;; PHP related configuration for GNU Emacs.

;;; Code:

(require 'rx)

(defconst my--php-imports-start-regexp
  (rx (group (and bol "use"))))

(defconst my--php-imports-end-regexp
  (rx (or (and bol "use") (and bol (* space) eol))))

(defun my--php--search-beg-point (&optional end)
  "Search the first import line until reach the END point."
  (save-excursion
    (goto-char (point-min))
    (and (re-search-forward my--php-imports-start-regexp end t)
         (match-beginning 1))))

(defun my--php-search-end-point (begin)
  "Search the last import line starting from BEGIN point."
  (let (end)
    (save-excursion
      (goto-char begin)
      (goto-char (point-at-bol))
      (catch 'eof
        (while (re-search-forward my--php-imports-end-regexp (point-at-eol) t)
          (when (eobp)
            (throw 'eof "End of file."))
          (setq end (point-at-eol))
          (forward-line 1))))
    end))

(defun my/php-optimize-imports ()
  "Sort PHP imports from current buffer."
  (interactive)
  (let* ((begin (my--php--search-beg-point))
         (end (and begin (my--php-search-end-point begin))))
    (when (and begin end)
      (sort-lines nil begin end))))

(defun my--php-locate-executable ()
  "Search for the PHP executable using ’phpenv’.

This function will try to find the PHP executable by calling ’phpenv’.
If it is not available, the function will utilize `executable-find'.
The function will set `php-executable' to the actual PHP if found
or nil otherwise."
  (let ((phpenv (executable-find "phpenv")))
    (if phpenv
        (replace-regexp-in-string
         "\n\\'" ""
         (shell-command-to-string (concat phpenv " which php")))
      (executable-find "php"))))

(defun my|common-php-hook ()
  "The hook to configure `php-mode' as well as `company-php'."
  (let ((php-path (my--php-locate-executable)))
    (setq
       ;; Setting up actual path to the executable
       php-executable php-path
       ac-php-php-executable php-path)

      (flycheck-mode)
      (subword-mode)
      (yas-minor-mode)

      ;; Jump to definition (optional)
      (define-key php-mode-map (kbd "M-]")
        'ac-php-find-symbol-at-point)

      ;; Return back (optional)
      (define-key php-mode-map (kbd "M-[")
        'ac-php-location-stack-back)

      ;; Toggle debug mode for `ac-php'
      (define-key php-mode-map (kbd "C-a C-c d")
        'ac-php-toggle-debug)))

(use-package php-mode
  :defer t
  :mode "\\.php[ts354]?\\'"
  :hook
  (php-mode . my|common-php-hook)
  :config
  (setq php-mode-coding-style 'psr2
        php-manual-path "/usr/local/share/php/doc/html")
  :bind
  (:map php-mode-map
        ("C-c C--" . #'php-current-class)
        ("C-c C-=" . #'php-current-namespace)))

(use-package company-php
  :defer t
  :pin melpa
  :init
  (progn
    (setq ac-php-tags-path (concat user-cache-dir "ac-php/")
          ;; My development version
          ac-php-ctags-executable (expand-file-name "~/work/phpctags/phpctags"))

    (my/add-all-to-hook
     #'php-mode-hook
     '(company-mode
       turn-on-eldoc-mode
       ac-php-core-eldoc-setup))

    (add-company-backends!!
     :modes php-mode
     :backends (company-ac-php-backend company-capf))))

(provide 'php-lang)
;;; php-lang.el ends here

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
