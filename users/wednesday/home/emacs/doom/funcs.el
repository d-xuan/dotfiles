;;; funcs.el -*- lexical-binding: t; -*-
(defun wednesday/split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))

(defun wednesday/split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))

(defun wednesday/wfa-timetracker-parse (plist)
  (let* ((staff "D Xuan")
         (properties (plist-get plist ':properties))
         (start-time (plist-get plist ':start))
         (end-time (plist-get plist ':end))
         (enter-time "")
         (duration "")
         (category (plist-get properties "CATEGORY" #'string-equal))
         (r-d (plist-get properties "R_AND_D" #'string-equal))
         (client (plist-get properties "CLIENT" #'string-equal))
         (project (plist-get properties "PROJECT" #'string-equal))
         (activity (plist-get properties "ACTIVITY" #'string-equal))
         (notes (plist-get plist ':task)))
    (mapconcat (lambda (s) (concat "\"" s "\""))
               (list staff start-time end-time enter-time duration category r-d client project activity notes) ",")))

(defun wednesday/tab-bar-init ()
  (interactive)
  (tab-bar-mode)
  (wednesday/exwm-workspace-switch-monitor 1)
  (dotimes (number 3) (tab-new))
  (wednesday/exwm-workspace-switch-monitor 2)
  (dotimes (number 3) (tab-new)))

(defun wednesday/exwm-workspace-switch-monitor (n)
  "If n is 1, switch to left screen of current workspace pair. If n
is 2, switch to right screen of current workspace pair."
  (interactive)
  (let* ((exwm-idx (exwm-workspace--position exwm-workspace--current))
         (current-screen (% exwm-idx 2)) ;0 is left screen, 1 is right screen
         (new-exwm-idx (cond ((and (= n 1) (= current-screen 1)) ; currently on right screen, move to left
                              (- exwm-idx 1))
                             ((and (= n 2) (= current-screen 0)) ;current on left screen, move to right
                              (+ exwm-idx 1))
                             (t exwm-idx))))
    (exwm-workspace-switch new-exwm-idx)))

(defun wednesday/tab-bar-select (n)
  (interactive)
  (let* ((current-idx (exwm-workspace--position exwm-workspace--current))
         (opposite-idx (% (+ current-idx 1) 2)))
    (exwm-workspace-switch opposite-idx)
    (tab-bar-select-tab n)
    (exwm-workspace-switch current-idx)
    (tab-bar-select-tab n)))

(defun wednesday/exwm-config ()
  "Default configuration of EXWM, with some tweaks"
  ;; Set the initial workspace number.
  (unless (get 'exwm-workspace-number 'saved-value)
    (setq exwm-workspace-number 2))
  ;; Make class name the buffer name
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (exwm-workspace-rename-buffer exwm-class-name)))
  ;; Global keybindings.
  (unless (get 'exwm-input-global-keys 'saved-value)
    (setq exwm-input-global-keys
          `(
            ;; 's-r': Reset (to line-mode).
            ([?\s-r] . exwm-reset)
            ;; ;; windmove/framemove
            ([?\s-h] . windmove-left)
            ([?\s-j] . windmove-down)
            ([?\s-k] . windmove-up)
            ([?\s-l] . windmove-right)
            ([?\s-H] . windmove-swap-states-left)
            ([?\s-J] . windmove-swap-states-down)
            ([?\s-K] . windmove-swap-states-up)
            ([?\s-L] . windmove-swap-states-right)
            ;; 's-w': Switch workspace.
            ([?\s-w] . exwm-workspace-switch)
            ;; 's-&': Launch application.
            ([?\s-&] . (lambda (command)
                         (interactive (list (read-shell-command "$ ")))
                         (start-process-shell-command command nil command)))
            ([?\s-o] . (lambda () (wednesday/exwm-workspace-switch-monitor 1)))
            ;; 's-N': Switch to different tabs
            ,@(mapcar (lambda (i)
                        `(,(kbd (format "s-%d" i)) .
                          (lambda ()
                            (interactive)
                            (wednesday/tab-bar-select ,i))))
                      (number-sequence 1 4))
            )))
  ;; Line-editing shortcuts
  (unless (get 'exwm-input-simulation-keys 'saved-value)
    (setq exwm-input-simulation-keys
          '(([?\C-b] . [left])
            ([?\C-f] . [right])
            ([?\C-p] . [up])
            ([?\C-n] . [down])
            ([?\C-a] . [home])
            ([?\C-e] . [end])
            ([?\M-v] . [prior])
            ([?\C-v] . [next])
            ([?\C-d] . [delete])
            ([?\C-k] . [S-end delete]))))
  ;; Enable EXWM
  (exwm-enable)
  ;; Other configurations
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (fringe-mode 1))
