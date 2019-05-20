;;; irc.el --- IRC tools. -*- lexical-binding: t; -*-

;; Copyright (C) 2019 Serghei Iakovlev <sadhooklay@gmail.com>

;; Author: Serghei Iakovlev <sadhooklay@gmail.com>
;; URL: https://github.com/sergeyklay/.emacs.d
;;
;; This file is not part of GNU Emacs.
;;
;; License: GPLv3

;;; Commentary:

;; IRC tool

;;; Code:

(require 'core-dirs)
(require 'erc)
(require 'erc-log)
(require 'erc-track)

(defun my|erc-logging ()
  "Setting up channel logging for `erc'."
  (let ((log-channels-directory (concat user-local-dir "logs/erc/")))
    (setq erc-log-channels-directory log-channels-directory
          erc-log-insert-log-on-open t)
    (unless (file-exists-p log-channels-directory)
      (make-directory log-channels-directory t))))

;; https://www.reddit.com/r/emacs/comments/8ml6na/tip_how_to_make_erc_fun_to_use
(use-package erc
  :after (auth-source password-store)
  :defer t
  :custom
  (erc-autojoin-channels-alist
   '(("freenode.net"
      "#emacs" "#i3" "#latex" "#org-mode"
      "#phalcon" "#zephir")))

  (erc-autojoin-timing 'ident)
  (erc-fill-function 'erc-fill-static)
  (erc-fill-static-center 22)
  (erc-hide-list '("JOIN" "PART" "QUIT"))
  (erc-lurker-hide-list '("JOIN" "PART" "QUIT"))
  (erc-lurker-threshold-time 43200)
  (erc-prompt-for-nickserv-password nil)
  (erc-server-reconnect-attempts 5)
  (erc-server-reconnect-timeout 3)
  (erc-track-exclude-types '("JOIN" "MODE" "NICK" "PART" "QUIT"
                             "324" "329" "332" "333" "353" "477"))
  :config
  (add-to-list 'erc-modules 'notifications)
  (add-to-list 'erc-modules 'spelling)
  (add-to-list 'erc-modules 'log)
  (erc-services-mode 1)
  (erc-update-modules)
  :hook
  (erc-mode . my|erc-logging))

(use-package erc-hl-nicks
  :after erc)

(use-package erc-image
  :after erc)

(defun my/erc-start-or-switch ()
  "Connects to ERC, or switch to last active buffer."
  (interactive)
  (if (get-buffer "irc.freenode.net:6667")
      (erc-track-switch-buffer 1)
    (when (y-or-n-p "Start ERC? ")
      (erc :server "irc.freenode.net" :port 6667 :nick "klay"))))

(provide 'irc)
;;; irc.el ends here
