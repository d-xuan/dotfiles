;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "d-xuan"
      user-mail-address "darren@example.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

;; (setq doom-gruvbox-light-comment-bg nil)
(setq doom-gruvbox-dark-variant "hard")
(setq kaolin-themes-italic-comments t)
(setq kaolin-themes-comments-style 'contrast)
(setq kaolin-ocean-alt-bg nil)
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/wfa/timetracker")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;
;; Begin user config below
(load! "funcs.el")
(load! "framemove.el")

(use-package! exwm-randr)
(use-package! windmove)
(use-package! framemove
  :after windmove
  :init
  (setq framemove-hook-into-windmove t)
  (map! "s-H" #'windmove-swap-states-left)
  (map! "s-J" #'windmove-swap-states-down)
  (map! "s-K" #'windmove-swap-states-up)
  (map! "s-L" #'windmove-swap-states-right)
  )

(use-package! exwm
  :after (exwm-randr windmove)
  :init
  (wednesday/exwm-config)

  ;; Start new X window process
  (add-to-list 'exwm-input-global-keys
               `(,(kbd "s-SPC") .
                 ,(lambda (command) (interactive (list (read-shell-command "$ ")))
                    (start-process-shell-command command nil command))))
  ;; Allow switching out of X windows with M-o
  (add-to-list 'exwm-input-global-keys
               `(,(kbd "M-o") . (lambda () (interactive) (other-window 1 t t))))
  ;; Allow switching to X window buffers on other workspaces
  (setq exwm-layout-show-all-buffers t)
  (map! "C-x b" #'exwm-workspace-switch-to-buffer)
  ;; randr support
  ;; (setq exwm-randr-workspace-monitor-plist (seq-mapcat (lambda (n) (list n (if (= (% n 2) 0) "DP-1" "HDMI-0"))) (number-sequence 0 9)))
  (setq exwm-randr-workspace-monitor-plist '(0 "DP-1" 1 "HDMI-0"))
  (add-hook 'exwm-randr-screen-change-hook
            (lambda ()
              (start-process-shell-command
               "xrandr" nil "xrandr --output DP-1 --primary --left-of HDMI-0 --auto")))
  (exwm-randr-enable))

(use-package! emacs
  :init
  (setq doom-font (font-spec :family "Iosevka Comfy" :size 13))
  (map! "C-x 2" #'wednesday/split-and-follow-horizontally)
  (map! "C-x 3" #'wednesday/split-and-follow-vertically)
  (map! "M-o" #'other-window)
  (setq-default tab-width 4)
  (setq set-mark-command-repeat-pop t)
  (setq tab-always-indent 'complete)
  (setq window-combination-resize t)
  (setq x-stretch-cursor t)
  (setq scroll-preserve-screen-position 'always)
  (setq scroll-margin 2)
  (display-time-mode 1)                 ; time on the modeline
  (setq display-time-day-and-date t)    ; display day and date as well
  (setq line-move-visual nil)
  (setq frame-title-format '("%b - GNU Emacs"))
  ;; (setq fancy-splash-image "~/Downloads/FYbDXRkaAAUoxHU_cropped_waifu2x_photo_noise1.png")
  (advice-add 'hide-mode-line-mode :around (lambda (orig &optional args) nil))
  (global-subword-mode 1)
  (setq inhibit-splash-screen nil))

(use-package! tab-bar
  :config
  (setq tab-bar-select-tab-modifiers '(super)))

(use-package! dired
  :config
  (setq dired-isearch-filenames t)
  (setq dired-kill-when-opening-new-dired-buffer t)
  (setq wdired-allow-to-change-permissions t))

(use-package! org-super-agenda
  :config
  (org-super-agenda-mode))

(use-package! org
  :after org
  :commands (org-agenda org-capture)
  :config
  (setq org-capture-templates '(("t" "New TODO" entry
                                 (file "~/org/inbox.org")
                                 "* TODO %?")))
  (setq org-refile-targets '(("~/org/todo.org" :level . 1)))
  (setq org-todo-keywords '((sequence "TODO(t)" "PROG(p)" "INTR(i)" "DONE(d)")))
  (setq org-agenda-span 'day)
  (setq org-agenda-todo-ignore-scheduled 'future)
  (setq org-agenda-todo-ignore-time-comparison-use-seconds t)
  (setq org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)
  (setq org-agenda-files '("~/org/todo.org"))
  (setq org-agenda-custom-commands
        '(("a" "Agenda / INTR / PROG / NEXT"
           ((agenda "" nil)
            (todo "INTR" nil)
            (todo "PROG" nil)
            (todo "TODO" nil)))))
  (setq org-agenda-window-setup 'current-window)
  (setq org-use-property-inheritance t))


(use-package! avy
  :commands (avy-goto-char-2)
  :init
  (map! "M-s" #'avy-goto-char-2)
  (map! :map isearch-mode-map "M-'" #'avy-isearch)
  :config
  (setq avy-all-windows 'all-frames))

(use-package! apheleia
  :config
  (setf (alist-get 'black apheleia-formatters)
        '("black" "-l" "130" "-"))
  (push `(julia . ("/opt/julia-1.9.1/bin/julia"
                   ,(concat "-e "
                            "using JuliaFormatter; "
                            "format_text(read(stdin, String), "
                            "indent = 2, "
                            "join_lines_based_on_source = false, "
                            "indent_submodule = :module) "
                            "|> print")))
        apheleia-formatters)
  (push '(leptosfmt "leptosfmt" "-r" "--stdin") apheleia-formatters)
  (push '(julia-mode . julia) apheleia-mode-alist)
  (apheleia-global-mode))

(use-package! julia-mode
  :after lsp-mode
  :config
  (setq julia-indent-offset 2))

(use-package! csv-mode
  :after csv-mode
  :hook
  ((csv-mode . (lambda ()
                 (highlight-indent-guides-mode -1)
                 (font-lock-mode -1)
                 (+word-wrap-mode -1)))))

(use-package! org-clock-csv
  :config
  (setq org-clock-csv-header "Staff,StartTime,EndTime,EnterTime,Duration,Category,r_d,Client,Project,Activity,Notes")
  (setq org-clock-csv-row-fmt #'wednesday/wfa-timetracker-parse))

(use-package! vterm
  :after  vterm
  :config
  (setq vterm-shell "/usr/bin/zsh")
  :hook
  ((vterm-mode . (lambda ()
                   (smartparens-mode -1)))))


(use-package! company
  :after company
  :config
  (map! :map company-active-map "<tab>" #'company-complete-selection)
  (setq company-idle-delay 0)
  )

(use-package! better-jumper
  :after better-jumper
  :config
  (advice-add #'+default/search-project :around #'doom-set-jump-a)
  (advice-add #'projectile-find-file :around #'doom-set-jump-a)
  (advice-add #'exwm-workspace-switch-to-buffer :around #'doom-set-jump-a))

(use-package! projectile
  :after projectile
  :config
  (setq projectile-switch-project-action #'magit-status))

(use-package! dumb-jump
  :after dumb-jump
  :config
  (setq dumb-jump-selector 'completing-read))

;; (use-package! spaceline
;;   :config
;;   (setq powerline-default-separator 'wave)
;;   (setq powerline-height 15)
;;   (setq spaceline-minor-modes-p nil)
;;   (spaceline-spacemacs-theme))

(use-package! svelte-mode)

(use-package! emms
  :config
  (emms-all)
  (setq emms-player-list '(emms-player-mpv))
  (setq emms-info-functions '(emms-info-native emms-info-metaflac emms-info-exiftool)))

(use-package! multi-vterm
  :config
  (setq multi-vterm-buffer-name "vterm")
  (map! :map doom-leader-map "o t" #'multi-vterm)
  (map! :map vterm-mode-map "C-M-n" #'multi-vterm-next)
  (map! :map vterm-mode-map "C-M-p" #'multi-vterm-prev))

(use-package! hl-line
  :config
  (global-hl-line-mode -1))

(use-package! envrc
  :config
  (envrc-global-mode))
