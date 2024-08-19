;;; typst-ts-misc-commands.el --- core functions for typst-ts-mode -*- lexical-binding: t; -*-
;; Copyright (C) 2023-2024 The typst-ts-mode Project Contributors

;; This file is NOT part of Emacs.
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

;; Miscellaneous commands

;;; Code:

;; (defgroup typst-ts-mc nil
;;   "Typst ts miscellaneous commands."
;;   :prefix "typst-ts-misc-commands"
;;   :group 'typst-ts)


(defun typst-ts-mc-export-to-markdown ()
  (interactive)
  
  ;; for simplicity
  (unless buffer-file-name
    (user-error "You should save the file first!"))

  (when (equal (file-name-extension buffer-file-name) "md")
    (user-error "Couldn't operate on a Typst file with `md' as its extension!"))

  (let* ((base-path (file-name-directory buffer-file-name))
         (file-name (file-relative-name buffer-file-name base-path))
         (output-file-name
          (file-name-with-extension file-name "md")))
    (async-shell-command
     (concat "pandoc -o " output-file-name " " file-name))))


(provide 'typst-ts-misc-commands)

;;; typst-ts-misc-commands.el ends here
