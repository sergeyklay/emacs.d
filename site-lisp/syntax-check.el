;;; syntax-check.el --- Syntax checkers. -*- lexical-binding: t; -*-

;; Copyright (C) 2019-2020 Serghei Iakovlev <egrep@protonmail.ch>

;; Author: Serghei Iakovlev <egrep@protonmail.ch>
;; URL: https://github.com/sergeyklay/.emacs.d
;;
;; This file is NOT part of GNU Emacs.
;;
;; License: GPLv3

;;; Commentary:

;; Syntax checkers for GNU Emacs.

;;; Code:

;;;; Flycheck

;; Flycheck is a general syntax highlighting framework which
;; other packages hook into.  It's an improvment on the built
;; in flymake.
(use-package flycheck
  :if (not (equal system-type 'windows-nt))
  :diminish flycheck-mode
  :preface
  (defun my/adjust-flycheck-automatic-syntax-eagerness ()
    "Adjust how often we check for errors based on if there are any.

This lets us fix any errors as quickly as possible, but in a clean
buffer we're an order of magnitude laxer about checking."
    (setq flycheck-idle-change-delay
	  (if flycheck-current-errors 0.5 30.0)))
  :custom
  (flycheck-indication-mode 'right-fringe)
  (flycheck-standard-error-navigation nil)
  (flycheck-emacs-lisp-load-path 'inherit)
  ;; Remove ‘new-line’ checks, since they would trigger an immediate
  ;; check when we want the idle-change-delay to be effect while
  ;; editing.
  (flycheck-check-syntax-automatically
   '(save idle-change mode-enabled))
  :hook
  ((flycheck-after-sytax-check . my/flycheck-adjust-syntax-eagerness))
  :config
  (progn
    ;; Each buffer gets its own idle-change-delay because of the
    ;; buffer-sensitive adjustment above.
    (make-variable-buffer-local 'flycheck-idle-change-delay)
    (global-flycheck-mode)))

;;;; flycheck-tip

(use-package flycheck-tip
  :after flycheck
  :custom (flycheck-tip-avoid-show-func nil))

;;;; flycheck-pos-tip

(use-package flycheck-pos-tip
  :defer t
  :if (display-graphic-p)
  :after flycheck
  :commands flycheck-pos-tip-mode
  :hook (flycheck-mode . flycheck-pos-tip-mode))

(provide 'syntax-check)
;;; syntax-check.el ends here
