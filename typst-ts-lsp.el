;;; typst-ts-lsp.el --- Eglot tinymist integration  -*- lexical-binding: t; -*-

;; Copyright (C) 2023-2025 The typst-ts-mode Project Contributors

;; This file is NOT part of GNU Emacs.
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; NOTE we don't provide `eglot-server-programs' configuration here, because
;; user may have already defined entries before typst-ts-mode load, which will
;; be override by our provided configuration.  If we want to detect whether
;; users have their own entries, we can use `eglot--lookup-mode', but the name
;; of the function means it's an private function and subject to change in the
;; in the future.
;; It's better to send a patch to eglot upstream to add the Typst language server.

;;; Code:

(defgroup typst-ts-lsp nil
  "Typst TS eglot integration with tinymist."
  :prefix "typst-ts-compile"
  :group 'typst-ts)

(defcustom typst-ts-lsp-download-path
  (file-name-concat (locate-user-emacs-file ".cache")
                    "lsp" "tinymist" "tinymist")
  "Install path for the language server."
  :type 'file
  :group 'typst-ts-lsp)

;;;###autoload
(defun typst-ts-lsp-download-binary ()
  "Download latest tinymist binary to `typst-ts-lsp-download-path'.
Will override old versions."
  (interactive)
  (unless (file-exists-p typst-ts-lsp-download-path)
    (make-directory (file-name-directory typst-ts-lsp-download-path) t))
  (let ((url "https://github.com/Myriad-Dreamin/tinymist/releases/latest/download/tinymist-installer.sh")
        (file (make-temp-file "script-" nil ".sh"))
        (process-environment (append '("TINYMIST_NO_MODIFY_PATH=1")
                                     process-environment))
        (buf "*tinymist-installer-output*")
        (binary-location (or (getenv "XDG_BIN_HOME")
                             (when-let ((xdg (getenv "XDG_DATA_HOME")))
                               (expand-file-name "bin" (expand-file-name ".." xdg)))
                             (expand-file-name "~/.local/bin"))))
    (url-copy-file url file t)
    (set-file-modes file #o755)
    (start-process file buf file)
    (display-buffer buf '((display-buffer-reuse-window
                           display-buffer-pop-up-window)))
    (message "Moving %s to %s" binary-location typst-ts-lsp-download-path)
    (rename-file binary-location typst-ts-lsp-download-path t)))

(provide 'typst-ts-lsp)
;;; typst-ts-lsp.el ends here
