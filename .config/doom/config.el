;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Personal info — used by gpg, org clocking, email clients, file templates.
;; Kept out of this (public) repo in `local/personal.el', which .gitignore
;; excludes. Same pattern as ~/.config/git/local/user, included by
;; ~/.config/git/config. Copy local/personal.el.example to get started.
;;
;; NOTE: if that file is missing, Emacs falls back to user@hostname rather than
;; erroring, which would silently give org-gcal the wrong calendar id — hence
;; the warning rather than a quiet default.
(unless (load! "local/personal" nil t)
  (message "doom: local/personal.el missing — copy local/personal.el.example and set your name/email"))

;;; --- Theme & font ---
(setq doom-theme 'oxocarbon)
(setq doom-font (font-spec :family "BlexMono Nerd Font" :size 15))

;; Override bold face to use bright colors (oxocarbon theme)
(custom-set-faces!
  '(bold :foreground "#82cfff" :weight bold))

;;; --- UI / editing ---
(setq display-line-numbers-type 'relative
      confirm-kill-emacs nil
      truncate-string-ellipsis "…")
(setq-default fill-column 80)

;; Smooth scrolling settings to prevent the screen from jumping abruptly
;; when you reach the top or bottom of the window.
(setq scroll-step 1
      scroll-margin 2
      hscroll-step 1
      hscroll-margin 2)

;; Make which-key pop up noticeably faster.
(after! which-key
  (setq which-key-idle-delay 0.3))

;;; --- macOS PATH fix ---
;; GUI Emacs (Emacs.app, and the daemon) doesn't source your shell rc files, so
;; PATH can be wrong — this breaks magit, flycheck, LSP servers, gpg, etc.
;; The `:os macos' module does NOT provide this; it comes from packages.el.
(use-package! exec-path-from-shell
  :when (featurep :system 'macos)
  :when (or (daemonp) (display-graphic-p))
  :config
  (setq exec-path-from-shell-arguments '("-l")
        exec-path-from-shell-variables '("PATH" "MANPATH" "GPG_AGENT_INFO" "SSH_AUTH_SOCK"))
  (exec-path-from-shell-initialize))

;;; --- Evil ---
;; Keep Doom's evil defaults, no CUA/C-a overrides.
(setq evil-cross-lines t)

;;; --- Dired ---
(after! dired
  (setq dired-dwim-target t))  ; smart target when two dired windows are open

;;; --- Projectile ---
(when (file-directory-p "~/code")
  (setq projectile-project-search-path '("~/code")))

;;; --- Autosave ---
;; Saves the visited file to disk after idling — good for org files synced
;; elsewhere (Syncthing/iCloud) and for not losing work on daemon crashes.
(setq auto-save-visited-interval 30)
(auto-save-visited-mode 1)


;;; ────────────────────────────────────────────────────────────────────────────
;;; Org — paths
;;; ────────────────────────────────────────────────────────────────────────────
;; Layout:
;;   ~/org/gtd/     agenda files (the GTD system; org-agenda-files points here)
;;   ~/org/roam/    org-roam knowledge base (NOT in the agenda)
;;   ~/org/archive/ archived subtrees, one file per source file, datetree'd

(setq org-directory "~/org/")

(defvar +org-gtd-dir       (file-name-as-directory (expand-file-name "gtd" org-directory)))
(defvar +org-roam-dir      (file-name-as-directory (expand-file-name "roam" org-directory)))
(defvar +org-archive-dir   (file-name-as-directory (expand-file-name "archive" org-directory)))

(defvar +org-inbox-file    (expand-file-name "inbox.org"    +org-gtd-dir))
(defvar +org-projects-file (expand-file-name "projects.org" +org-gtd-dir))
(defvar +org-someday-file  (expand-file-name "someday.org"  +org-gtd-dir))
(defvar +org-habits-file   (expand-file-name "habits.org"   +org-gtd-dir))
(defvar +org-calendar-file (expand-file-name "calendar.org" +org-gtd-dir))

(defvar +org-templates-dir
  (expand-file-name "templates/" doom-user-dir)
  "Directory holding org-capture / org-roam template *bodies*, one per file.

Kept out of `+snippets-dir' (~$DOOMDIR/snippets/~) on purpose: Doom adds that
directory to both `yas-snippet-dirs' and `load-path', so yasnippet would try to
read these as snippet definitions.")

(defun +org-template (name)
  "Return a `(file ...)' org-capture template body for NAME under `+org-templates-dir'.
Org reads the file fresh on every capture, so edits take effect immediately —
no restart, no `doom sync'."
  (list 'file (expand-file-name name +org-templates-dir)))

(defun +org-template-string (name)
  "Return the contents of NAME under `+org-templates-dir' as a string."
  (let ((f (expand-file-name name +org-templates-dir)))
    (if (file-readable-p f)
        (org-file-contents f)
      (format "#+title: ${title}\n# Template file %s not found\n" name))))

(defun +org-template-head (name)
  "Return a function yielding NAME's contents, for an org-roam `:target' head.
org-roam runs the head through `org-roam-capture--fill-template', which accepts
a function as well as a string, so heads get the same live-editing and
${title}/${slug} expansion as the bodies."
  (lambda () (+org-template-string name)))

;; org-roam reads this at load time, so it must be set before the package loads.
(setq org-roam-directory (file-truename +org-roam-dir))


;;; ────────────────────────────────────────────────────────────────────────────
;;; Org — core
;;; ────────────────────────────────────────────────────────────────────────────
(after! org
  (setq org-ellipsis                    " ▾ "
        org-startup-folded              'content
        org-image-actual-width          '(600)
        org-use-property-inheritance    t     ; sub-tasks inherit properties
        org-catch-invisible-edits       'show-and-error
        org-special-ctrl-a/e            t
        org-insert-heading-respect-content t
        ;; Logging: record when + why things change state, keep it in a drawer
        org-log-done                    'time
        org-log-redeadline              'time
        org-log-reschedule              'time
        org-log-into-drawer             t
        ;; Archive each file into its own archive file, under a datetree
        org-archive-location            (concat +org-archive-dir "%s::datetree/")
        ;; Refile anywhere in the GTD system, up to 3 levels deep
        org-refile-targets              '((nil                :maxlevel . 3)
                                          (org-agenda-files   :maxlevel . 3))
        org-refile-use-outline-path     'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm)

  ;; Habit tracking. org-super-agenda already requires org-habit, but relying on
  ;; a transitive dependency is fragile. Doom auto-sizes the consistency graph
  ;; on `org-agenda-mode-hook', so don't set `org-habit-graph-column' here.
  (require 'org-habit)
  (setq org-habit-show-habits-only-for-today t
        org-habit-show-all-today nil)

  ;; Lightweight workflow: five states, one sequence so fast-select keys never
  ;; collide. PROJ exists only so the dashboard can spot projects that have
  ;; stalled (no NEXT beneath them).
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"    ; something to do, not necessarily right now
           "NEXT(n)"    ; the thing you'll actually do next
           "WAIT(w@/!)" ; blocked on someone else
           "PROJ(p)"    ; needs more than one step
           "|"
           "DONE(d!)"
           "KILL(k@/!)")
          (sequence
           "[ ](T)" "[-](S)" "|" "[X](D)")))

  ;; Doom defines intermediary faces that inherit `org-todo'; do the same for
  ;; NEXT so it stands out as the state you actually act on.
  (with-no-warnings
    (custom-declare-face '+org-todo-next
                         '((t (:inherit (bold font-lock-keyword-face org-todo)))) ""))
  (setq org-todo-keyword-faces
        '(("NEXT" . +org-todo-next)
          ("[-]"  . +org-todo-active)
          ("WAIT" . +org-todo-onhold)
          ("PROJ" . +org-todo-project)
          ("KILL" . +org-todo-cancel)))

  ;; Four contexts and one "this is quick" marker. Tag an item only when it
  ;; genuinely helps you pick what to do — untagged is fine.
  (setq org-tag-alist
        '((:startgroup)
          ("@home"     . ?h)
          ("@work"     . ?w)
          ("@errand"   . ?e)
          ("@computer" . ?c)
          (:endgroup)
          ("quick"     . ?q))
        org-use-fast-tag-selection t
        org-fast-tag-selection-single-key 'expert)

  ;; Priorities: A = must happen today, B = default, C = nice to have
  (setq org-priority-default ?B
        org-priority-lowest  ?C)

  ;; A parent PROJ can't be DONE while a child action is open.
  (setq org-enforce-todo-dependencies t
        org-enforce-todo-checkbox-dependencies t))


;;; ────────────────────────────────────────────────────────────────────────────
;;; Org — capture
;;; ────────────────────────────────────────────────────────────────────────────
;; Everything lands in the inbox by default. Clarify + refile during review.
(after! org
  (setq org-capture-templates
        `(("t" "Task → inbox" entry
           (file+headline ,+org-inbox-file "Inbox")
           ,(+org-template "capture/task.org") :empty-lines 1)

          ("n" "Note → inbox" entry
           (file+headline ,+org-inbox-file "Inbox")
           ,(+org-template "capture/note.org") :empty-lines 1)

          ("p" "Project" entry
           (file+headline ,+org-projects-file "Projects")
           ,(+org-template "capture/project.org") :empty-lines 1)

          ("s" "Someday / maybe" entry
           (file+headline ,+org-someday-file "Someday")
           ,(+org-template "capture/someday.org") :empty-lines 1)

          ("b" "Habit" entry
           (file+headline ,+org-habits-file "Habits")
           ,(+org-template "capture/habit.org") :empty-lines 1)

          ("e" "Calendar event (syncs to Google)" entry
           (file+headline ,+org-calendar-file "Events")
           ,(+org-template "capture/event.org") :empty-lines 1)

          ("j" "Journal → today's roam daily" entry
           (function +org-roam-dailies-capture-target)
           ,(+org-template "capture/journal.org") :empty-lines 1))))


;;; ────────────────────────────────────────────────────────────────────────────
;;; Org — agenda
;;; ────────────────────────────────────────────────────────────────────────────
(after! org-agenda
  (setq org-agenda-files             (list +org-gtd-dir)
        org-agenda-span              'week
        org-agenda-start-on-weekday  1
        ;; Doom defaults this to "-3d", which shifts every agenda block three
        ;; days into the past. nil = start today (weekly views still snap to
        ;; Monday via `org-agenda-start-on-weekday').
        org-agenda-start-day         nil
        ;; `state' would add a log line for every TODO→NEXT→WAIT transition, and
        ;; would double-report habit completions that the consistency graph
        ;; already shows. `closed' + `clock' is what's actually worth seeing.
        org-agenda-start-with-log-mode '(closed clock)
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done  t
        org-agenda-skip-scheduled-if-deadline-is-shown t
        org-agenda-tags-column       'auto
        org-agenda-window-setup      'current-window
        org-agenda-compact-blocks    nil
        org-agenda-block-separator   ?─
        org-deadline-warning-days    14
        org-agenda-time-grid
        '((daily today require-timed)
          (800 1000 1200 1400 1600 1800 2000)
          " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
        org-agenda-current-time-string
        "◀ ─────────────────────────────────── now")

  ;; `SPC o a g' — the one view to open every morning.
  (setq org-agenda-custom-commands
        `(("g" "Dashboard"
           ((agenda "" ((org-agenda-span 'day)
                        (org-agenda-overriding-header "Today")
                        (org-super-agenda-groups
                         '((:name "Overdue"   :deadline past :scheduled past :order 1)
                           (:name "Due today" :deadline today :order 2)
                           (:name "Habits"    :habit t        :order 3)
                           (:name "Schedule"  :time-grid t    :order 4)))))
            (todo "NEXT|WAIT"
                  ((org-agenda-overriding-header "Doing")
                   (org-super-agenda-groups
                    '((:name "Next"           :todo "NEXT" :order 1)
                      (:name "Waiting on someone" :todo "WAIT" :order 2)))))
            (todo "PROJ"
                  ((org-agenda-overriding-header "Projects with no next action")
                   (org-agenda-files (list ,+org-projects-file))
                   (org-agenda-skip-function
                    '+org-agenda-skip-if-project-has-next)))
            (todo "TODO"
                  ((org-agenda-overriding-header "Inbox")
                   (org-agenda-files (list ,+org-inbox-file))))))

          ("i" "Inbox"
           ((alltodo "" ((org-agenda-files (list ,+org-inbox-file))
                         (org-agenda-overriding-header "Inbox")))))))

  ;; Used by the "Projects with no next action" block above: a PROJ heading is
  ;; stalled if nothing beneath it is marked NEXT.
  (defun +org-agenda-skip-if-project-has-next ()
    "Skip the current PROJ entry if any of its subtasks is NEXT."
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (save-excursion
        (forward-line 1)
        (if (re-search-forward "^\\*+ NEXT " subtree-end t)
            subtree-end
          nil)))))

(use-package! org-super-agenda
  :after org-agenda
  :config
  ;; org-super-agenda's header keymap shadows evil motions in the agenda.
  (setq org-super-agenda-header-map (make-sparse-keymap))
  (org-super-agenda-mode +1))


;;; ────────────────────────────────────────────────────────────────────────────
;;; Org — clocking
;;; ────────────────────────────────────────────────────────────────────────────
(after! org-clock
  (setq org-clock-persist              'history
        org-clock-in-resume            t
        org-clock-out-remove-zero-time-clocks t
        org-clock-out-when-done        t
        org-clock-report-include-clocking-task t
        org-clock-history-length       20)
  (org-clock-persistence-insinuate))


;;; ────────────────────────────────────────────────────────────────────────────
;;; Org — roam
;;; ────────────────────────────────────────────────────────────────────────────
(after! org-roam
  (setq org-roam-db-location      (concat doom-data-dir "org-roam.db")
        org-roam-dailies-directory "daily/"
        ;; Show the node's file title + tags in the completion UI
        org-roam-node-display-template
        (concat "${title:*} " (propertize "${tags:24}" 'face 'org-tag))
        org-roam-completion-everywhere t)

  ;; Templates mirror the conventions of the Obsidian "Cortex" vault
  ;; (System/Templates/ + its CLAUDE.md schema) so the two systems stay legible
  ;; to each other: type/topic/status/created as file-level properties (which
  ;; org-roam indexes into its DB, unlike #+keywords), and the
  ;; topic/domain/subdomain taxonomy flattened to underscores because org tags
  ;; only accept [:alnum:]_@#% (org.el:677) — no slashes.
  (setq org-roam-capture-templates
        `(("d" "atomic" plain ,(+org-template "roam/atomic.org")
           :target (file+head "${slug}.org" ,(+org-template-head "roam/atomic-head.org"))
           :unnarrowed t :empty-lines-before 1)
          ("m" "map of content" plain ,(+org-template "roam/moc.org")
           :target (file+head "${slug}.org" ,(+org-template-head "roam/moc-head.org"))
           :unnarrowed t :empty-lines-before 1)
          ("p" "person" plain ,(+org-template "roam/person.org")
           :target (file+head "people/${slug}.org" ,(+org-template-head "roam/person-head.org"))
           :unnarrowed t :empty-lines-before 1)
          ("r" "reference" plain ,(+org-template "roam/reference.org")
           :target (file+head "ref/${slug}.org" ,(+org-template-head "roam/reference-head.org"))
           :unnarrowed t :empty-lines-before 1)))

  ;; Dailies use `file+head+olp' so log entries land under the "Notes" heading
  ;; and leave the Reflections section (and its prompts) intact.
  (setq org-roam-dailies-capture-templates
        `(("d" "default" entry ,(+org-template "roam/daily.org")
           :target (file+head+olp "%<%Y-%m-%d>.org"
                                  ,(+org-template-head "roam/daily-head.org")
                                  ("Notes"))
           :empty-lines 1)
          ("l" "log entry" entry ,(+org-template "roam/daily-log.org")
           :target (file+head+olp "%<%Y-%m-%d>.org"
                                  ,(+org-template-head "roam/daily-head.org")
                                  ("Notes"))
           :empty-lines 1)
          ("m" "meeting" entry ,(+org-template "roam/daily-meeting.org")
           :target (file+head+olp "%<%Y-%m-%d>.org"
                                  ,(+org-template-head "roam/daily-head.org")
                                  ("Notes"))
           :empty-lines 1))))

(defun +org-template-expand-time (str)
  "Expand org-capture time escapes %<...> and %U in STR.
Needed because a function capture target inserts its header itself, outside
`org-capture-fill-template'."
  (let ((s (replace-regexp-in-string
            "%<\\([^>]*\\)>"
            (lambda (m) (format-time-string (match-string 1 m)))
            str t t)))
    (replace-regexp-in-string
     "%U" (format-time-string "[%Y-%m-%d %a %H:%M]") s t t)))

;; Capture target used by the "j" org-capture template. Builds the daily from
;; the same templates/roam/daily-head.org that `SPC n r d n' uses, so both
;; entry points produce identically structured files.
(defun +org-roam-dailies-capture-target ()
  "Visit today's org-roam daily and move point to its Notes heading.
Deliberately does NOT call `org-roam-dailies--capture' — nesting a capture
inside a capture hangs."
  (let* ((dir  (expand-file-name (or (bound-and-true-p org-roam-dailies-directory)
                                     "daily/")
                                 org-roam-directory))
         (file (expand-file-name (format-time-string "%Y-%m-%d.org") dir)))
    (make-directory dir t)
    (set-buffer (org-capture-target-buffer file))
    (unless (derived-mode-p 'org-mode) (org-mode))
    (widen)
    (when (= (buffer-size) 0)
      (insert (+org-template-expand-time (+org-template-string "roam/daily-head.org")))
      ;; A file-level :ID: is what makes this a real org-roam *node* (and not
      ;; just an indexed file) — without it there are no backlinks.
      (goto-char (point-min))
      (org-id-get-create))
    (goto-char (point-min))
    (unless (re-search-forward "^\\* Notes[ \t]*$" nil t)
      (goto-char (point-max)))))

;; Fuzzy search across the whole knowledge base via consult/vertico.
(use-package! consult-org-roam
  :after org-roam
  :config
  (setq consult-org-roam-grep-func #'consult-ripgrep
        consult-org-roam-buffer-narrow-key ?r
        consult-org-roam-buffer-after-buffers t)
  (consult-org-roam-mode +1))

;; Interactive graph in the browser: `SPC n r u'.
(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil))


;;; ────────────────────────────────────────────────────────────────────────────
;;; Org — Google Calendar (org-gcal, two-way)
;;; ────────────────────────────────────────────────────────────────────────────
;; Credentials live in the macOS Keychain, never in this repo. Add them once:
;;
;;   security add-generic-password -s gcal.googleapis.com \
;;     -a "<CLIENT_ID>.apps.googleusercontent.com" -w "<CLIENT_SECRET>"
;;
;; The `:os macos' module already adds macos-keychain-generic to `auth-sources',
;; so `auth-source-search' finds it. Get the client id/secret by creating an
;; OAuth 2.0 "Desktop app" client in a Google Cloud project with the Google
;; Calendar API enabled.
;;
;; org-gcal stores its OAuth token in an encrypted plstore, which needs GnuPG:
;;   brew install gnupg

(defvar +gcal-calendar-id user-mail-address
  "Google Calendar id to sync. Set in `local/personal.el' to override.")

(defun +gcal-load-credentials ()
  "Load the Google OAuth client id/secret from `auth-sources'.
Returns non-nil when both were found."
  (when-let* ((entry  (car (auth-source-search :host "gcal.googleapis.com" :max 1)))
              (id     (plist-get entry :user))
              (secret (plist-get entry :secret)))
    (setq org-gcal-client-id id
          org-gcal-client-secret (if (functionp secret) (funcall secret) secret))
    t))

(after! org-gcal
  (setq org-gcal-fetch-file-alist `((,+gcal-calendar-id . ,+org-calendar-file))
        org-gcal-recurring-events-mode 'nested
        org-gcal-remove-api-cancelled-events t
        org-gcal-update-cancelled-events-with-todo t
        org-gcal-cancelled-todo-keyword "KILL"
        org-gcal-notify-p nil            ; no desktop alert on every sync
        org-gcal-up-days   30             ; fetch 30 days back…
        org-gcal-down-days 180            ; …and 6 months forward
        org-gcal-strip-html-descriptions t
        ;; Cache the plstore passphrase so a sync doesn't prompt repeatedly
        plstore-cache-passphrase-for-symmetric-encryption t)
  (+gcal-load-credentials))

(defun +gcal/sync ()
  "Two-way sync with Google Calendar, if credentials are configured."
  (interactive)
  (require 'org-gcal)
  (if (+gcal-load-credentials)
      (org-gcal-sync)
    (message "org-gcal: no credentials in the keychain — see config.el for setup")))

;; Background sync every 30 minutes. No-ops silently until you add credentials
;; to the keychain, so this is inert on a fresh machine.
(defvar +gcal-sync-timer nil)
(after! org
  (unless +gcal-sync-timer
    (setq +gcal-sync-timer
          (run-with-idle-timer
           (* 30 60) t
           (lambda ()
             (when (and (require 'org-gcal nil t) (+gcal-load-credentials))
               (ignore-errors (org-gcal-fetch))))))))


;;; ────────────────────────────────────────────────────────────────────────────
;;; Org — misc
;;; ────────────────────────────────────────────────────────────────────────────
;; Auto-tangle literate config files that carry `#+auto_tangle: t'.
(use-package! org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default nil))

;;; --- Live preview for org and markdown files ---
(defun my-org-markdown-preview-browse-right (url)
  "Force xwidget preview into a split window on the right."
  (let ((win (or (window-in-direction 'right)
                 (split-window-right))))
    (with-selected-window win
      (xwidget-webkit-browse-url url))))

(use-package! org-markdown-preview
  :defer t
  :config
  (setq org-markdown-preview-use-github-api nil)
  (setq org-markdown-preview-browse-fn #'my-org-markdown-preview-browse-right))


;;; ────────────────────────────────────────────────────────────────────────────
;;; Keybindings
;;; ────────────────────────────────────────────────────────────────────────────
;; NOTE: Doom already binds the whole org-roam suite under `SPC n r' (including
;; dailies under `SPC n r d'), and org-capture/agenda under `SPC n' and
;; `SPC o a'. Only the genuinely missing commands are added here — rebinding
;; `SPC n f/i/c/l' would clobber Doom's find-in-notes, org-clock and store-link.
(map! :leader
      ;; NOTE: use *string* prefixes to extend an existing prefix. A cons like
      ;; (:prefix ("r" . "roam")) creates a NEW keymap at that key, silently
      ;; wiping every binding Doom already put there.
      (:prefix "n"
       ;; SPC n r — extend Doom's roam prefix (find/insert/capture/dailies are
       ;; already bound there by Doom; these are the ones it doesn't provide).
       (:prefix "r"
        :desc "Roam UI (graph in browser)" "u" #'org-roam-ui-open
        :desc "Search roam (ripgrep)"      "/" #'consult-org-roam-search
        :desc "Backlinks"                  "b" #'consult-org-roam-backlinks
        :desc "Forward links"              "l" #'consult-org-roam-forward-links)
       ;; SPC n g — new group, so a cons is correct here.
       (:prefix ("g" . "google calendar")
        :desc "Sync (two-way)"        "s" #'+gcal/sync
        :desc "Fetch only"            "f" #'org-gcal-fetch
        :desc "Post event at point"   "p" #'org-gcal-post-at-point
        :desc "Delete event at point" "d" #'org-gcal-delete-at-point))

      ;; SPC o a — extend Doom's org-agenda prefix.
      (:prefix "o"
       (:prefix "a"
        :desc "Dashboard"        "g" (cmd! (org-agenda nil "g"))
        :desc "Inbox"            "i" (cmd! (org-agenda nil "i"))
        :desc "Calendar (calfw)" "c" #'+calendar/open-calendar)))
