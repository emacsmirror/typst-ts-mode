;;; typst-ts-core.el --- core functions for typst-ts-mode -*- lexical-binding: t; -*-
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

;; Utility functions for typst-ts-mode

;;; Code:

(require 'treesit)

;; don't use 'treesit.c' since package Emacs distribution may separate the source
;; code from Emacs binary
(declare-function treesit-parser-list "treesit" t t)

(defun typst-ts-core-get-node-bol (node)
  "Get the NODE's indentation offset (at node beginning)."
  (save-excursion
    (goto-char (treesit-node-start node))
    (back-to-indentation)
    (point)))


;; code is from treesit.el inside Emacs Source
(defun typst-ts-core-local-parsers-at (&optional pos language with-host)
  "Return all the local parsers at POS.
It's a copy of Emacs 30's `treesit-local-parsers-at' function.
POS LANGUAGE WITH-HOST."
  (if (fboundp 'treesit-local-parsers-at)
      (funcall #'treesit-local-parsers-at pos language with-host)
    (let ((res nil))
      (dolist (ov (overlays-at (or pos (point))))
        (when-let ((parser (overlay-get ov 'treesit-parser))
                   (host-parser (overlay-get ov 'treesit-host-parser)))
          (when (or (null language)
                    (eq (treesit-parser-language parser)
                        language))
            (push (if with-host (cons parser host-parser) parser) res))))
      (nreverse res))))

(defun typst-ts-core-node-get (node instructions)
  "Get things from NODE by INSTRUCTIONS.
It's a copy of Emacs 30's `treesit-node-get' function."
  (declare (indent 1))
  (if (fboundp 'treesit-node-get)
      (treesit-node-get node instructions)
    (while (and node instructions)
      (pcase (pop instructions)
        ('(field-name) (setq node (treesit-node-field-name node)))
        ('(type) (setq node (treesit-node-type node)))
        (`(child ,idx ,named) (setq node (treesit-node-child node idx named)))
        (`(parent ,n) (dotimes (_ n)
                        (setq node (treesit-node-parent node))))
        (`(text ,no-property) (setq node (treesit-node-text node no-property)))
        (`(children ,named) (setq node (treesit-node-children node named)))
        (`(sibling ,step ,named)
         (dotimes (_ (abs step))
           (setq node (if (> step 0)
                          (treesit-node-next-sibling node named)
                        (treesit-node-prev-sibling node named)))))))
    node))

(provide 'typst-ts-core)

;;; typst-ts-core.el ends here
