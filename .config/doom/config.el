;;; ~/.config/doom/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
(fringe-mode 16)

(setq-default truncate-lines nil)
(setq doom-font (font-spec :family "Hack" :size 24)
      doom-theme 'spacemacs-light
      spacemacs-theme-comment-bg nil
      yas-indent-line 'fixed
      lsp-ui-sideline-enable nil
      org-startup-truncated nil
      flycheck-display-errors-delay 0.5)
(remove-hook! (prog-mode text-mode conf-mode) #'display-line-numbers-mode)
(add-to-list '+doom-solaire-themes '(spacemacs-light . t))

(after! lsp-ui
  (setq lsp-eldoc-enable-hover t))

(defun vj/enforce-git-commit-conventions ()
    (setq fill-column nil
          git-commit-summary-max-length 72
          git-commit-style-convention-checks '(overlong-summary-line non-empty-second-line)))

(after! git-commit
  (remove-hook 'git-commit-mode-hook #'+vc|enforce-git-commit-conventions)
  (add-hook 'git-commit-mode-hook #'vj/enforce-git-commit-conventions))

(map!
 :i "C-w" 'evil-window-map)


(defconst python-f-string-regexp
  "{\\s-*\\(\\sw\\|\\s_\\)+\\.?\\(\\sw\\|\\s_\\)+\\s-*}"
  "Spaces following by underscores or words following by optional dot and
words/underscores again.")

(defun python-f-string-font-lock-find (limit)
  (while (re-search-forward python-f-string-regexp limit t)
      (when (python-syntax-comment-or-string-p)
        (put-text-property (match-beginning 0) (match-end 0)
                           'face 'font-lock-variable-name-face)))
  nil)

(after! python
  (setq python-indent-def-block-scale 1)
  (progn (font-lock-add-keywords
          'python-mode
          `((python-f-string-font-lock-find))
          'append)))