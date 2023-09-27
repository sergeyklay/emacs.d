;;; init.el --- Initialization file. -*- lexical-binding: t; -*-

;; Copyright (C) 2019-2023 Serghei Iakovlev <egrep@protonmail.ch>

;; Author: Serghei Iakovlev <egrep@protonmail.ch>
;; URL: https://github.com/sergeyklay/.emacs.d

;; This file is NOT part of Emacs.

;;;; License

;; This file is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;   The guiding philosophy behind this Emacs configuration is that it should
;; be a direct extension of my own memory.  This project serves as a
;; representation of what I can actively recall and understand.
;;
;; As a result, you won't find overly complex settings or esoteric designs here.
;; The aim is to keep everything as straightforward and transparent as possible.
;; This ensures that the configuration can be easily read, understood, and held
;; mentally.
;;
;; If you come across this project, bear in mind that it's molded to fit what I
;; can keep "in my head" rather than what Emacs is capable of doing.  The
;; simplicity is intentional and serves as a mnemonic aid for me.
;;
;;   This file bootstraps the configuration, which is divided into a number of
;; other files.
;;
;; I started this project on 4 March 2019 from this commit:
;; eb11ce25b0866508e023db4b8be6cca536cd3044

;;; Code:

;;;; Prelude

;; Measure the current start up time.
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;;;; Emacs Server

;; Declare the function `server-running-p' from the "server" module.
;;
;; This declaration informs the Emacs Lisp compiler that the function
;; `server-running-p' exists, but is defined in an external module ("server").
;; This prevents compile-time warnings and helps in generating better bytecode.
;; The `declare-function' acts as a forward declaration, essentially saying:
;; "Trust me, this function will be available at runtime, even if you can't see
;; it now at compile time."
;;
;; Note: This is not a substitute for `(require 'server)` or `(load "server")`,
;; it is only for the compiler's benefit.
(declare-function server-running-p "server")

(add-hook 'after-init-hook
          #'(lambda ()
              (require 'server)
              (unless (server-running-p)
                (server-start))))

;;;; Custom Variables and Faces

;; The `custom-set-variables' and `custom-set-faces' blocks are placed at the
;; end of this file for several reasons:
;;
;; 1. Dependency Handling: Some custom variables might depend on packages that
;; are initialized earlier in this file. Placing the custom blocks at the end
;; ensures all required packages are already loaded.
;;
;; 2. Readability: These blocks are often auto-generated by the Emacs customize
;; interface and can become quite large. Keeping them at the end improves the
;; readability of the config file.
;;
;; 3. Overriding: If there are manual settings scattered through the init file
;; that conflict with custom settings, placing custom blocks at the end allows
;; them to take precedence.
;;
;; If you're an aspiring Emacs hacker, consider these points when deciding
;; where to place your own custom variables and faces.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(leuven))
 '(global-visual-line-mode t)
 '(inhibit-startup-screen t)
 '(initial-major-mode 'text-mode)
 '(initial-scratch-message nil)
 '(ring-bell-function 'ignore))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
