;;; init.el --- Initialization file. -*- lexical-binding: t; -*-

;; Copyright (C) 2019-2020 Serghei Iakovlev <egrep@protonmail.ch>

;; Author: Serghei Iakovlev <egrep@protonmail.ch>
;; URL: https://github.com/sergeyklay/.emacs.d
;;
;; This file is NOT part of GNU Emacs.
;;
;; License: GPLv3

;;; Commentary:

;;   This file is used to initialize GNU Emacs for my daily needs.
;; I started this project on 4 March 2019 from this commit:
;; eb11ce25b0866508e023db4b8be6cca536cd3044
;;
;; This configuration is partially based on the following user
;; configurations:
;;
;; - Sacha Chua (sachac)
;;   (see URL `https://github.com/sachac')
;; - Daniel Mai (danielmai)
;;   (see URL `https://github.com/danielmai')
;; - Terencio Agozzino (rememberYou)
;;   (see URL `https://github.com/rememberYou')
;;
;; Thanks to them for their incredible work!

;;; Code:

;;; Begin initialization

;; Turn off mouse interface early in startup to avoid momentary display.
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))     ; Disable the menu bar
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))     ; Disable the tool bar
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1)) ; Disable the scroll bar
(if (fboundp 'tooltip-mode) (tooltip-mode -1))       ; Disable the tooltips

;; Don't save customizations at all, prefer to set things explicitly.
(setq custom-file null-device)

;; One less file to load at startup.
(setq site-run-file nil)

;; Disable start-up screen.
(setq inhibit-startup-screen t)

;; Actually this project is my personal configuration
;; so I use GNU Emacs 26.1 now.
(eval-when-compile
  (and (version< emacs-version "26.1")
       (error
        (concat
         "Detected Emacs %s. "
         "This configuration is designed to work "
         "only with Emacs 26.1 and higher. I'm sorry.")
        emacs-version)))

(defconst emacs-debug-mode (or (getenv "DEBUG") init-file-debug)
  "If non-nil, all Emacs will be verbose.
Set DEBUG=1 in the command line or use --debug-init to enable this.")

(require 'directories (concat user-emacs-directory "settings/directories"))

;;; Bootstrap packaging system

(require 'package)

(setq package--init-file-ensured t)
(setq package-user-dir
      (concat
       (substitute-in-file-name "$HOME/.local/lib/emacs/")
       "packages/" emacs-version "/elpa"))

(unless (file-exists-p package-user-dir)
  (make-directory package-user-dir t))

(setq package-gnupghome-dir
      (expand-file-name "gnupg" user-local-dir))

(setq package-archives
      '(("org"      . "http://orgmode.org/elpa/")
        ("melpa"    . "http://melpa.org/packages/")
        ("m-stable" . "http://stable.melpa.org/packages/")
        ("elpa"     . "https://elpa.gnu.org/packages/")))

;; Priorities. Default priority is 0.
(setq package-archive-priorities
      '(("m-stable" . 10)
        ("melpa" . 20)))

;; Initialize package manager.
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-verbose emacs-debug-mode)

(require 'bind-key)

;;; Utilities for `list-packages' menu

;; Add functions to filter the list by status (s new), or filter to see only
;; marked packages.

(defun klay/package-menu-find-marks ()
  "Find packages marked for action in *Packages*."
  (interactive)
  (occur "^[A-Z]"))

(defun klay/package-menu-filter-by-status (status)
  "Filter the *Packages* buffer by STATUS."
  (interactive
   (list (completing-read
          "Status : " '("new" "installed" "dependency" "obsolete"))))
  (package-menu-filter (concat "status:" status)))

(define-key package-menu-mode-map "s" #'klay/package-menu-filter-by-status)
(define-key package-menu-mode-map "a" #'klay/package-menu-find-marks)

;; Setting up the dependencies, features and packages
(add-to-list 'load-path user-host-dir)
(add-to-list 'load-path user-site-lisp-dir)
(add-to-list 'load-path user-settings-dir)

;;; Personal information

(setq user-full-name "Serghei Iakovlev"
      user-mail-address "egrep@protonmail.ch")

;; Set up appearance early
(require 'appearance)
(require 'backup)

;;; Languages Support

;; Add support for the configuration like languages for GNU Emacs.

;; `yaml-mode' gives me the possibility to easily manage .yml files
(use-package yaml-mode
  :mode "\\.ya?ml\\'"
  :interpreter ("yml" . yml-mode))

;;; init.el ends here
