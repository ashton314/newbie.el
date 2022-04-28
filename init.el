;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs config for the newest of the new users ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Early init stuff
(setq package-enable-at-startup nil)
(setq byte-compile-warnings nil)
(setq warning-suppress-log-types '((comp)))

(setq modus-themes-mode-line '(moody)
      modus-themes-syntax '(green-strings)
      modus-themes-hl-line '(underline accented)
      modus-themes-prompts '(background gray))

(load-theme 'modus-vivendi)

(blink-cursor-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(setq column-number-mode t)
(setq display-time-default-load-average nil)
(setq inhibit-startup-screen t)

;;; Setup package manager
(defvar bootstrap-version)

(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;; Essentials kit

(use-package diminish
  :config
  (diminish 'visual-line-mode " w")
  (diminish 'eldoc-mode "")
  (diminish 'flyspell-mode ""))

(use-package which-key
  :diminish ""
  :config
  (which-key-mode))

(use-package mlscroll
  :config
  (mlscroll-mode))

(use-package vertico
  :defer t
  :init
  (vertico-mode))

(use-package consult
  :defer t
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (("C-x M-:"	.	consult-complex-command)
         ("C-c h"	.	consult-history)
         ("C-c m"	.	consult-mode-command)
         ("C-c k"	.	consult-keep-lines)
         ("C-x b"	.	consult-buffer)
         ("C-x 4 b"	.	consult-buffer-other-window)
         ("C-x 5 b"	.	consult-buffer-other-frame)
         ("C-x r x"	.	consult-register)
         ("C-x r b"	.	consult-bookmark)
         ("M-g g"	.	consult-goto-line)
         ("M-g M-g"	.	consult-goto-line)
         ("M-g o"	.	consult-outline)       ;; "M-s o" is a good alternative.
         ("C-s"		.	consult-line)          ;; "M-s l" is a good alternative.
         ("M-g m"	.	consult-mark)          ;; I recommend to bind Consult navigation
         ("M-g k"	.	consult-global-mark)   ;; commands under the "M-g" prefix.
         ("M-g r"	.	consult-git-grep)      ;; or consult-grep, consult-ripgrep
         ("s-r r"	.	consult-ripgrep)
         ("s-f" 	.	consult-ripgrep)
         ("s-l" 	.	consult-line-multi)
         ("s-r l"	.	consult-line-multi)    ;; s-l is used by LSP mode
         ("C-s-f"	.	consult-line-multi)    ;; Cmd-f is affe-grep; Cmd-F is consult-line-multi
         ("M-g f"	.	consult-find)          ;; or consult-locate, my-fdfind
         ("M-g i"	.	consult-project-imenu) ;; or consult-imenu
         ("M-g e"	.	consult-error)
         ("M-s m"	.	consult-multi-occur)
         ("M-y"		.	consult-yank-pop)
         ("<help> a"	.	consult-apropos))

  :init
  (fset 'multi-occur #'consult-multi-occur)
  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  ;; Preview immediately on M-., on up/down after 0.3s, on any other key after 0.5s
  (consult-customize consult-theme consult-bookmark
                     :preview-key
                     (list (kbd "M-.")
                           :debounce 0.3 (kbd "<up>") (kbd "<down>")
                           :debounce 0.5 'any))
  (setq consult-narrow-key "<") ;; Another viable option: (kbd "C-+")
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-root-function #'projectile-project-root))

(use-package orderless
  :config
  (setq completion-styles '(orderless flex)
        completion-category-overrides '((file (styles partial-completion basic)))))

(use-package marginalia
  :config
  (marginalia-mode)
  (setq marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light)))

(use-package projectile
  :defer t
  :diminish ""
  :init
  (projectile-mode +1)
  :bind (("C-x p" . projectile-command-map)))

(use-package smartparens
  :defer t
  :diminish "(s)"
  :hook ((elixir-mode rust-mode cperl-mode) . smartparens-mode))
