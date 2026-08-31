;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; ─── Personal ───────────────────────────────────────────────────────────────

;; Warn rather than default quietly: without this file Emacs falls back to
;; user@hostname, which would silently give org-gcal the wrong calendar id.
(unless (load! "local/personal" nil t)
  (message "doom: local/personal.el missing — copy local/personal.el.example and set your name/email"))

(setq default-directory "~/")

;;; ─── Server ─────────────────────────────────────────────────────────────────

(setq server-window 'pop-to-buffer-same-window
      server-raise-frame t
      server-kill-new-buffers nil)

;;; ─── Frame ──────────────────────────────────────────────────────────────────

(when (featurep 'ns)
  (setq ns-use-thin-smoothing t
        ns-use-native-fullscreen nil
        ns-use-fullscreen-animation nil))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;; ─── Theme & font ───────────────────────────────────────────────────────────

(setq doom-theme 'oxocarbon
      doom-font (font-spec :family "BlexMono Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "iA Writer Quattro V" :size 15)
      mixed-pitch-set-height t)

(add-hook! (org-mode gfm-mode markdown-mode) #'mixed-pitch-mode)

;; oxocarbon's bold is too dim to read as emphasis.
(custom-set-faces!
  '(bold :foreground "#82cfff" :weight bold))

;;; ─── Editor ─────────────────────────────────────────────────────────────────

(setq scroll-margin 0
      display-line-numbers-type 'relative
      x-underline-at-descent-line t
      truncate-string-ellipsis "..."
      select-enable-clipboard t
      confirm-kill-emacs nil)

(setq-default fill-column 120)

(setq auto-save-visited-interval 60)
(auto-save-visited-mode t)

(setq evil-cross-lines t
      evil-vsplit-window-right t
      evil-split-window-below t
      evil-want-fine-undo t)

(after! which-key
  (setq which-key-idle-delay 0.3))

(after! smartparens-config
  (dolist (mode '(markdown-mode gfm-mode markdown-ts-mode))
    (sp-local-pair mode "`" "`" :actions '(insert wrap navigate)))
  ;; Redefined without `autoskip' so typing a quote before an existing one
  ;; inserts rather than jumping over it.
  (dolist (p '(("\"" . "\"") ("'" . "'")))
    (sp-pair (car p) (cdr p) :actions '(insert wrap navigate))))

;;; ─── Projects ───────────────────────────────────────────────────────────────

(setq +workspaces-on-switch-project-behavior t)

(after! projectile
  (setq projectile-indexing-method 'alien
        projectile-project-search-path '("~/.dotfiles" "~/code")))

;; A branch switch changes the file set, so the cache is stale immediately.
(defun +private/projectile-invalidate-cache (&rest _args)
  (projectile-invalidate-cache nil))
(advice-add 'magit-checkout :after #'+private/projectile-invalidate-cache)
(advice-add 'magit-branch-and-checkout :after #'+private/projectile-invalidate-cache)

;;; ─── Dired ──────────────────────────────────────────────────────────────────

(after! dired
  (setq dired-dwim-target t
        delete-by-moving-to-trash t)
  (add-hook! 'dired-mode-hook 'dired-hide-details-mode))

;;; ─── Treemacs ───────────────────────────────────────────────────────────────

(after! treemacs
  (setq doom-themes-treemacs-enable-variable-pitch t
        doom-themes-treemacs-line-spacing 0
        doom-themes-treemacs-theme "doom-colors"
        treemacs-width 40
        ;; Doom disables popups here, which also breaks switching in and out of
        ;; the tree with the evil window bindings. This restores it.
        treemacs-is-never-other-window nil)
  (treemacs-resize-icons 14)
  (treemacs-follow-mode 1))

;;; ─── Modeline ───────────────────────────────────────────────────────────────

;; Text tags instead of doom-modeline's circle icons for the modal state.
(setq doom-modeline-modal t
      doom-modeline-modal-icon nil)

(after! evil
  (setq evil-normal-state-tag   (propertize "  N " 'face 'evil-normal-state-tag)
        evil-insert-state-tag   (propertize "  I " 'face 'evil-insert-state-tag)
        evil-visual-state-tag   (propertize "  V " 'face 'evil-visual-state-tag)
        evil-operator-state-tag (propertize "  O " 'face 'evil-operator-state-tag)
        evil-replace-state-tag  (propertize "  R " 'face 'evil-replace-state-tag)))

(after! doom-modeline
  (setq doom-modeline-buffer-file-name-style 'file-name
        doom-modeline-buffer-size t
        doom-modeline-lsp t
        doom-modeline-check-icon t
        doom-modeline-vcs-max-length 50
        doom-modeline-buffer-encoding t
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-workspace-name nil
        doom-modeline-env-version nil))

;;; ─── Org — layout ───────────────────────────────────────────────────────────

;; ~/org/
;;   journal/      one file per day, plus one per ISO week. Flat, because
;;                 `org-agenda-files' expands a directory non-recursively.
;;   collections/  habits, reading list — the only refile target.
;;   notes/        org-roam knowledge base.
;;   archive/      archived subtrees, datetree'd.
;;   calendar.org  org-gcal's fetch target.
;;
;; No inbox, deliberately: the daily log is the capture target and migration is
;; the only triage step. An inbox would just be a queue to drain.

(setq org-directory "~/org/")

(defvar +org-journal-dir
  (file-name-as-directory (expand-file-name "journal" org-directory)))
(defvar +org-collections-dir
  (file-name-as-directory (expand-file-name "collections" org-directory)))
(defvar +org-notes-dir
  (file-name-as-directory (expand-file-name "notes" org-directory)))
(defvar +org-archive-dir
  (file-name-as-directory (expand-file-name "archive" org-directory)))
(defvar +org-calendar-file (expand-file-name "calendar.org" org-directory))
(defvar +org-habits-file   (expand-file-name "habits.org" +org-collections-dir))

(defun +org-ensure-tree ()
  "Create the `org-directory' subtree if any of it is missing.
org-capture, org-roam and org-archive all assume their target directory exists —
a buffer visiting a file in a missing one is read-only, so the save fails partway
through a capture. Running this at startup is what makes a fresh clone of this
repo enough to set up a new machine."
  (dolist (dir (list +org-journal-dir +org-collections-dir +org-archive-dir
                     +org-notes-dir
                     (expand-file-name "people" +org-notes-dir)
                     (expand-file-name "ref" +org-notes-dir)))
    (make-directory dir t)))

(+org-ensure-tree)

(defvar +org-file-regexp "\\`[^.].*\\.org\\'"
  "Match .org files, skipping dotfiles.
A plain \"\\\\.org\\\\'\" also matches Emacs lock files (.#name.org) — dangling
symlinks that exist for every modified buffer and that org-agenda chokes on.")

(defvar +org-templates-dir
  (expand-file-name "templates/" doom-user-dir)
  "Directory holding org-capture / org-roam template bodies, one per file.
Kept out of `+snippets-dir' because Doom adds that to `yas-snippet-dirs', where
yasnippet would try to read these as snippet definitions.")

(defun +org-template (name)
  "Return a `(file ...)' org-capture template body for NAME.
Org re-reads the file on every capture, so edits apply without a restart."
  (list 'file (expand-file-name name +org-templates-dir)))

(defun +org-template-string (name)
  "Return the contents of NAME under `+org-templates-dir' as a string."
  (let ((f (expand-file-name name +org-templates-dir)))
    (if (file-readable-p f)
        (org-file-contents f)
      (format "#+title: ${title}\n# Template file %s not found\n" name))))

(defun +org-template-head (name)
  "Return a function yielding NAME's contents, for an org-roam `:target' head.
A function keeps the live-editing that a literal string would lose."
  (lambda () (+org-template-string name)))

(defun +org-template-expand-time (str &optional time)
  "Expand the org-capture escapes %<...> and %U in STR, as of TIME.
The journal helpers write their own file head, outside `org-capture'."
  (let ((s (replace-regexp-in-string
            "%<\\([^>]*\\)>"
            (lambda (m) (format-time-string (match-string 1 m) time))
            str t t)))
    (replace-regexp-in-string
     "%U" (format-time-string "[%Y-%m-%d %a %H:%M]" time) s t t)))

(defun +org-collection-files ()
  "Every file in `+org-collections-dir'.
A function, not a list: `org-refile-targets' funcalls an `fboundp' symbol, so
the targets stay current as collections are added."
  (and (file-directory-p +org-collections-dir)
       (directory-files +org-collections-dir t +org-file-regexp)))

;; Read at load time, so it must be set before org-roam loads. The whole tree is
;; the graph, which is what lets a log entry link to [[Someone]] and show up as a
;; backlink on that person's note.
(setq org-roam-directory (file-truename org-directory))

;;; ─── Org — core ─────────────────────────────────────────────────────────────

(after! org
  (setq org-ellipsis                     " ▾ "
        org-startup-folded               'content
        org-image-actual-width           '(600)
        org-use-property-inheritance     t
        org-catch-invisible-edits        'show-and-error
        org-special-ctrl-a/e             t
        org-insert-heading-respect-content t
        org-log-done                     'time
        org-log-redeadline               'time
        org-log-reschedule               'time
        org-log-into-drawer              t
        org-archive-location             (concat +org-archive-dir "%s::datetree/")
        ;; Collections and the current file only. No projects.org to refile
        ;; into — that road leads back to GTD.
        org-refile-targets               '((+org-collection-files :maxlevel . 2)
                                           (nil :maxlevel . 2))
        org-refile-use-outline-path      'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm)

  ;; Signifiers: TODO = open, DONE = done, FWD = migrated, DROP = struck out.
  ;; Events and notes are not TODOs — an event is a heading with an active
  ;; timestamp and an :event: tag, a note is a bare heading.
  ;;
  ;; `!' (timestamp) not `@' (note): a note prompt makes `B t' bulk migration
  ;; unusable, since org cannot cope with simultaneous prompts.
  (setq org-todo-keywords
        '((sequence "TODO(t)" "|" "DONE(d!)" "FWD(f!)" "DROP(x!)")))

  (setq org-todo-keyword-faces
        '(("FWD"  . +org-todo-onhold)
          ("DROP" . +org-todo-cancel)))

  ;; A = today, B = default, C = when it happens.
  (setq org-priority-default ?B
        org-priority-lowest  ?C)

  (setq org-enforce-todo-dependencies t
        org-enforce-todo-checkbox-dependencies t)

  ;; Required explicitly rather than relying on org-super-agenda pulling it in.
  ;; Doom sizes the consistency graph on `org-agenda-mode-hook'.
  (require 'org-habit)
  (setq org-habit-show-habits-only-for-today t
        org-habit-show-all-today nil))

;;; ─── Journal — files ────────────────────────────────────────────────────────

;; Doom's file-templates expands a yasnippet with a live `${1:...}' field into
;; every new empty .org file. In the journal that fires before our own head is
;; written and then blocks on the field. Doom special-cases `org-journal-mode'
;; the same way; new rules are pushed to the front of `+file-templates-alist'.
(when (modulep! :editor file-templates)
  (set-file-template! "/org/journal/.*\\.org\\'" :ignore t))

(defvar +bujo-agenda-days 90
  "How far back the agenda reaches into the journal.
An entry not migrated in three months is a diary line, not a task.")

(defun +bujo-daily-file (&optional time)
  "Absolute path of the daily log for TIME (default today)."
  (expand-file-name (format-time-string "%Y-%m-%d.org" time) +org-journal-dir))

(defun +bujo-weekly-file (&optional time)
  "Absolute path of the weekly review for TIME's ISO week."
  (expand-file-name (format-time-string "%G-W%V.org" time) +org-journal-dir))

(defun +bujo--file-date (file)
  "Parse a YYYY-MM-DD daily FILE name into a time value, or nil."
  (let ((base (file-name-base file)))
    (when (string-match "\\`\\([0-9]\\{4\\}\\)-\\([0-9]\\{2\\}\\)-\\([0-9]\\{2\\}\\)\\'" base)
      (encode-time (list 0 0 12
                         (string-to-number (match-string 3 base))
                         (string-to-number (match-string 2 base))
                         (string-to-number (match-string 1 base))
                         nil -1 nil)))))

(defun +bujo--day-offset (time n)
  "Return TIME shifted by N days.
Via `encode-time' rather than 86400-second arithmetic, which breaks on DST."
  (let ((d (decode-time time)))
    (encode-time (list 0 0 12
                       (+ (nth 3 d) n) (nth 4 d) (nth 5 d)
                       nil -1 nil))))

(defun +bujo--iso-week-monday (week)
  "Return the time value for the Monday of WEEK, a \"YYYY-Www\" string.
ISO 8601 anchors week 1 on the week containing January 4th."
  (unless (string-match "\\`\\([0-9]\\{4\\}\\)-W\\([0-9]\\{1,2\\}\\)\\'" week)
    (user-error "Not an ISO week designator: %S" week))
  (let* ((year (string-to-number (match-string 1 week)))
         (n    (string-to-number (match-string 2 week)))
         (jan4 (encode-time (list 0 0 12 4 1 year nil -1 nil)))
         (dow  (string-to-number (format-time-string "%u" jan4))))
    ;; `encode-time' normalises an out-of-range day, so no month arithmetic.
    (encode-time (list 0 0 12 (+ (- 4 dow) 1 (* 7 (1- n))) 1 year nil -1 nil))))

(defun +bujo--ensure-file (file template &optional time)
  "Return FILE's buffer, creating it from TEMPLATE (expanded as of TIME) if new.
The file-level :ID: is what makes this an org-roam node with backlinks, rather
than merely an indexed file."
  (make-directory (file-name-directory file) t)
  (let* ((+file-templates-inhibit t)   ; see `set-file-template!' above
         (buf (find-file-noselect file)))
    (with-current-buffer buf
      (unless (derived-mode-p 'org-mode) (org-mode))
      (when (= (buffer-size) 0)
        (insert (+org-template-expand-time (+org-template-string template) time))
        (goto-char (point-min))
        (org-id-get-create)
        (save-buffer)))
    buf))

(defun +bujo--goto-log ()
  "Move point to the `* Log' heading, or to end of buffer if there is none."
  (goto-char (point-min))
  (unless (re-search-forward "^\\* Log[ \t]*$" nil t)
    (goto-char (point-max))))

(defun +bujo/goto-day (&optional time)
  "Open the daily log for TIME, creating it if needed. Defaults to today."
  (interactive)
  (switch-to-buffer
   (+bujo--ensure-file (+bujo-daily-file time) "journal/daily-head.org" time))
  (+bujo--goto-log))

(defun +bujo/today ()     (interactive) (+bujo/goto-day))
(defun +bujo/yesterday () (interactive) (+bujo/goto-day (+bujo--day-offset (current-time) -1)))
(defun +bujo/tomorrow ()  (interactive) (+bujo/goto-day (+bujo--day-offset (current-time)  1)))

(defun +bujo/goto-date (date)
  "Open the daily log for DATE, prompting with the org date picker."
  (interactive (list (org-read-date nil t)))
  (+bujo/goto-day date))

(defun +bujo/goto-week (&optional time)
  "Open the weekly review for TIME's ISO week, creating it if needed."
  (interactive)
  (switch-to-buffer
   (+bujo--ensure-file (+bujo-weekly-file time) "journal/weekly-head.org" time))
  (org-update-all-dblocks))

(defun +bujo/this-week () (interactive) (+bujo/goto-week))
(defun +bujo/last-week () (interactive) (+bujo/goto-week (+bujo--day-offset (current-time) -7)))

(defun +bujo/browse ()
  "Open the journal directory."
  (interactive)
  (make-directory +org-journal-dir t)
  (dired +org-journal-dir))

;;; ─── Journal — capture ──────────────────────────────────────────────────────

(defun +bujo-capture-target ()
  "org-capture target: under `* Log' in today's daily.
Does not call `org-roam-dailies--capture' — nesting a capture inside a capture
hangs."
  (let ((file (+bujo-daily-file))
        (+file-templates-inhibit t))
    (make-directory +org-journal-dir t)
    (set-buffer (org-capture-target-buffer file))
    (unless (derived-mode-p 'org-mode) (org-mode))
    (widen)
    (when (= (buffer-size) 0)
      (insert (+org-template-expand-time
               (+org-template-string "journal/daily-head.org")))
      (goto-char (point-min))
      (org-id-get-create))
    (+bujo--goto-log)))

;; Global capture frame, opened by bin/org-capture (alt-c in aerospace.toml).
;; An explicit `title' parameter is what lets the window manager float it:
;; `+org-capture/open-frame' binds `frame-title-format' to "", and a frame
;; parameter overrides that.
(after! org
  (setf (alist-get 'title  +org-capture-frame-parameters) "org-capture"
        (alist-get 'width  +org-capture-frame-parameters) 90
        (alist-get 'height +org-capture-frame-parameters) 20
        ;; `default-frame-alist' maximises every new frame; a capture popup is
        ;; the one place that is wrong.
        (alist-get 'fullscreen +org-capture-frame-parameters) nil)
  ;; Doom sets `window-system' here only on Linux. Without it a daemon with no
  ;; GUI frame open builds a tty frame instead and dies with "Unknown terminal
  ;; type" — which is exactly the state the machine is in after closing the last
  ;; window.
  (when (featurep :system 'macos)
    (setf (alist-get 'window-system +org-capture-frame-parameters) 'ns)))

(after! org
  ;; One capture target for everything but habits: no filing decision at
  ;; capture time.
  (setq org-capture-templates
        `(("t" "Task"    entry (function +bujo-capture-target)
           ,(+org-template "capture/task.org")    :empty-lines 1)
          ("e" "Event"   entry (function +bujo-capture-target)
           ,(+org-template "capture/event.org")   :empty-lines 1)
          ("n" "Note"    entry (function +bujo-capture-target)
           ,(+org-template "capture/note.org")    :empty-lines 1)
          ("m" "Meeting" entry (function +bujo-capture-target)
           ,(+org-template "capture/meeting.org") :empty-lines 1)
          ("h" "Habit"   entry (file+headline ,+org-habits-file "Habits")
           ,(+org-template "capture/habit.org")   :empty-lines 1))))

;;; ─── Journal — metrics ──────────────────────────────────────────────────────

;; A dynamic block, org's answer to the vault's dataviewjs chart.

(defvar +bujo-metrics
  '(("ENERGY"  . "Energy")
    ("MOOD"    . "Mood")
    ("SLEEP"   . "Sleep")
    ("WEIGHT"  . "Weight")
    ("READING" . "Read"))
  "Daily file-level properties collected into the weekly table.
Each entry is (PROPERTY . COLUMN-HEADING).")

(defun +bujo--numeric (s)
  "Return S as a number when it looks like one, else nil."
  (and (stringp s)
       (let ((s (string-trim s)))
         (and (string-match-p "\\`[0-9]+\\(\\.[0-9]+\\)?\\'" s)
              (string-to-number s)))))

(defun +bujo--daily-properties (file)
  "Return an alist of FILE's file-level `+bujo-metrics' properties."
  (with-temp-buffer
    (delay-mode-hooks (org-mode))
    (insert-file-contents file)
    (mapcar (lambda (cell)
              (cons (car cell) (org-entry-get (point-min) (car cell))))
            +bujo-metrics)))

(defun +bujo--count-open (file)
  "Count open TODO headings in FILE."
  (with-temp-buffer
    (insert-file-contents file)
    (how-many "^\\*+ TODO " (point-min) (point-max))))

(defun org-dblock-write:bujo-metrics (params)
  "Write the week's daily logs and their metrics as an org table.
PARAMS may carry :week \"YYYY-Www\"; otherwise the buffer's :WEEK: property,
then the current week."
  (let* ((week   (or (plist-get params :week)
                     (org-entry-get (point-min) "WEEK")
                     (format-time-string "%G-W%V")))
         (monday (+bujo--iso-week-monday week))
         (keys   (mapcar #'car +bujo-metrics))
         (sums   (make-vector (length keys) 0))
         (counts (make-vector (length keys) 0))
         (open-total 0)
         (rows   '()))
    (dotimes (i 7)
      (let* ((time   (+bujo--day-offset monday i))
             (file   (+bujo-daily-file time))
             (exists (file-readable-p file))
             (props  (and exists (+bujo--daily-properties file)))
             (open   (if exists (+bujo--count-open file) 0))
             (cells  '()))
        (cl-incf open-total open)
        (dotimes (n (length keys))
          (let* ((raw (cdr (assoc (nth n keys) props)))
                 (num (+bujo--numeric raw)))
            (when num
              (cl-incf (aref sums n) num)
              (cl-incf (aref counts n) 1))
            (push (or raw "") cells)))
        (push (append
               (list (if exists
                         (format "[[file:%s][%s]]"
                                 (file-name-nondirectory file)
                                 (format-time-string "%a %d" time))
                       (format-time-string "%a %d" time)))
               (nreverse cells)
               (list (if (> open 0) (number-to-string open) "")))
              rows)))
    (insert "| Day | " (mapconcat #'cdr +bujo-metrics " | ") " | Open |\n|-\n")
    (dolist (row (nreverse rows))
      (insert "| " (mapconcat #'identity row " | ") " |\n"))
    (insert "|-\n| Avg | "
            (mapconcat
             (lambda (n)
               (if (> (aref counts n) 0)
                   (format "%.1f" (/ (aref sums n) (float (aref counts n))))
                 ""))
             (number-sequence 0 (1- (length keys)))
             " | ")
            " | " (number-to-string open-total) " |")
    (org-table-align)))

;;; ─── Org — agenda ───────────────────────────────────────────────────────────

(defun +bujo-agenda-files ()
  "Agenda scope: recent dailies, every collection, and the calendar.
Bounding this by `+bujo-agenda-days' also keeps the agenda from scanning every
file ever written."
  (let ((cutoff (float-time (+bujo--day-offset (current-time)
                                               (- +bujo-agenda-days)))))
    (append
     (cl-remove-if
      (lambda (f)
        (let ((date (+bujo--file-date f)))
          ;; Undated files (the weeklies) are always kept.
          (and date (< (float-time date) cutoff))))
      (and (file-directory-p +org-journal-dir)
           (directory-files +org-journal-dir t +org-file-regexp)))
     (+org-collection-files)
     (and (file-readable-p +org-calendar-file) (list +org-calendar-file)))))

(defun +bujo-past-daily-files ()
  "Daily logs strictly before today — the migration pool."
  (let ((today (format-time-string "%Y-%m-%d")))
    (cl-remove-if-not
     (lambda (f) (and (+bujo--file-date f)
                      (string< (file-name-base f) today)))
     (+bujo-agenda-files))))

(defun +bujo-refresh-agenda-files (&rest _)
  "Recompute `org-agenda-files'. The set changes every midnight."
  (setq org-agenda-files (+bujo-agenda-files)))

(advice-add 'org-agenda :before #'+bujo-refresh-agenda-files)
;; `g' in the agenda calls `org-agenda-redo', which does not route through
;; `org-agenda' — without this, a session left open past midnight would keep
;; using yesterday's file list. `org-agenda-redo-all' delegates to it.
(advice-add 'org-agenda-redo :before #'+bujo-refresh-agenda-files)

(after! org-agenda
  (+bujo-refresh-agenda-files)
  (setq org-agenda-span              'week
        org-agenda-start-on-weekday  1
        ;; Doom defaults this to "-3d", shifting every block three days into the
        ;; past. nil starts today; weekly views still snap to Monday.
        org-agenda-start-day         nil
        org-agenda-start-with-log-mode '(closed clock)
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done  t
        org-agenda-skip-scheduled-if-deadline-is-shown t
        org-agenda-tags-column       'auto
        org-agenda-window-setup      'current-window
        org-agenda-compact-blocks    nil
        org-agenda-block-separator   ?─
        org-deadline-warning-days    14
        ;; Marks survive a bulk action, so one migration pass can reschedule,
        ;; retag and archive without re-marking.
        org-agenda-bulk-persistent-marks t
        org-agenda-time-grid
        '((daily today require-timed)
          (800 1000 1200 1400 1600 1800 2000)
          " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
        org-agenda-current-time-string
        "◀ ─────────────────────────────────── now")

  ;; Values here are `eval'd when the view is built, so the file lists stay
  ;; current rather than freezing at load time.
  (setq org-agenda-custom-commands
        '(("d" "Today"
           ((agenda "" ((org-agenda-span 'day)
                        (org-agenda-overriding-header "Today")
                        (org-super-agenda-groups
                         '((:name "Overdue"  :deadline past :scheduled past :order 1)
                           (:name "Due"      :deadline today :order 2)
                           (:name "Habits"   :habit t        :order 3)
                           (:name "Schedule" :time-grid t    :order 4)))))
            (todo "TODO" ((org-agenda-overriding-header "Open in today's log")
                          (org-agenda-files (list (+bujo-daily-file)))))))

          ("m" "Migration"
           ((todo "TODO"
                  ((org-agenda-overriding-header
                    "Open tasks in past logs — m to mark, then B s (reschedule) · B S (scatter) · B r (refile) · B t (state) · B $ (archive)")
                   (org-agenda-files (+bujo-past-daily-files))
                   (org-super-agenda-groups
                    '((:name "Unscheduled" :scheduled nil  :order 1)
                      (:name "This week"   :scheduled past :order 2)))))))

          ("w" "This week"
           ((agenda "" ((org-agenda-span 'week)
                        (org-agenda-overriding-header ""))))))))

(use-package! org-super-agenda
  :after org-agenda
  :config
  ;; Its header keymap otherwise shadows evil motions in the agenda.
  (setq org-super-agenda-header-map (make-sparse-keymap))
  (org-super-agenda-mode +1))

;;; ─── Org — clock ────────────────────────────────────────────────────────────

(after! org-clock
  (setq org-clock-persist              'history
        org-clock-in-resume            t
        org-clock-out-remove-zero-time-clocks t
        org-clock-out-when-done        t
        org-clock-report-include-clocking-task t
        org-clock-history-length       20)
  (org-clock-persistence-insinuate))

;;; ─── Org — roam ─────────────────────────────────────────────────────────────

(after! org-roam
  (setq org-roam-db-location       (concat doom-data-dir "org-roam.db")
        org-roam-dailies-directory "journal/"
        org-roam-node-display-template
        (concat "${title:*} " (propertize "${tags:24}" 'face 'org-tag))
        org-roam-completion-everywhere t
        ;; Matched against the path *relative* to `org-roam-directory', so these
        ;; must be anchored with \\` and carry no leading slash — an absolute
        ;; pattern silently never matches.
        org-roam-file-exclude-regexp
        '("\\`archive/" "\\`\\.attach/" "\\`calendar\\.org\\'"))

  ;; Mirrors the Obsidian vault's schema so the two stay legible to each other:
  ;; type/topic/status/created as file-level properties, which org-roam indexes
  ;; into its DB (unlike #+keywords).
  (setq org-roam-capture-templates
        `(("d" "atomic" plain ,(+org-template "roam/atomic.org")
           :target (file+head "notes/${slug}.org" ,(+org-template-head "roam/atomic-head.org"))
           :unnarrowed t :empty-lines-before 1)
          ("m" "map of content" plain ,(+org-template "roam/moc.org")
           :target (file+head "notes/${slug}.org" ,(+org-template-head "roam/moc-head.org"))
           :unnarrowed t :empty-lines-before 1)
          ("p" "person" plain ,(+org-template "roam/person.org")
           :target (file+head "notes/people/${slug}.org" ,(+org-template-head "roam/person-head.org"))
           :unnarrowed t :empty-lines-before 1)
          ("r" "reference" plain ,(+org-template "roam/reference.org")
           :target (file+head "notes/ref/${slug}.org" ,(+org-template-head "roam/reference-head.org"))
           :unnarrowed t :empty-lines-before 1)))

  ;; Same head as `SPC X' and the journal commands, so all three entry points
  ;; produce identical files.
  (setq org-roam-dailies-capture-templates
        `(("d" "log entry" entry ,(+org-template "capture/note.org")
           :target (file+head+olp "%<%Y-%m-%d>.org"
                                  ,(+org-template-head "journal/daily-head.org")
                                  ("Log"))
           :empty-lines 1)
          ("t" "task" entry ,(+org-template "capture/task.org")
           :target (file+head+olp "%<%Y-%m-%d>.org"
                                  ,(+org-template-head "journal/daily-head.org")
                                  ("Log"))
           :empty-lines 1))))

(use-package! consult-org-roam
  :after org-roam
  :config
  (setq consult-org-roam-grep-func #'consult-ripgrep
        consult-org-roam-buffer-narrow-key ?r
        consult-org-roam-buffer-after-buffers t)
  (consult-org-roam-mode +1))

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil))

;;; ─── Org — calendar ─────────────────────────────────────────────────────────

;; Credentials live in the macOS Keychain, never in this repo. Add them once:
;;
;;   security add-generic-password -s gcal.googleapis.com \
;;     -a "<CLIENT_ID>.apps.googleusercontent.com" -w "<CLIENT_SECRET>"
;;
;; Create the id/secret as an OAuth 2.0 "Desktop app" client in a Google Cloud
;; project with the Calendar API enabled. The token is stored in an encrypted
;; plstore, which needs GnuPG: brew install gnupg

(defvar +gcal-calendar-id user-mail-address
  "Google Calendar id to sync. Override in `local/personal.el'.")

(defun +gcal-load-credentials ()
  "Load the OAuth client id/secret from `auth-sources'.
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
        org-gcal-cancelled-todo-keyword "DROP"
        org-gcal-notify-p nil
        org-gcal-up-days   30
        org-gcal-down-days 180
        org-gcal-strip-html-descriptions t
        ;; Otherwise every sync re-prompts for the plstore passphrase.
        plstore-cache-passphrase-for-symmetric-encryption t)
  (+gcal-load-credentials))

(defun +gcal/sync ()
  "Two-way sync with Google Calendar, if credentials are configured."
  (interactive)
  (require 'org-gcal)
  (if (+gcal-load-credentials)
      (org-gcal-sync)
    (message "org-gcal: no credentials in the keychain — see config.el for setup")))

;; Inert until credentials exist, so this is a no-op on a fresh machine.
(defvar +gcal-sync-timer nil)
(after! org
  (unless +gcal-sync-timer
    (setq +gcal-sync-timer
          (run-with-idle-timer
           (* 30 60) t
           (lambda ()
             (when (and (require 'org-gcal nil t) (+gcal-load-credentials))
               (ignore-errors (org-gcal-fetch))))))))

;;; ─── Org — preview ──────────────────────────────────────────────────────────

(defun +org-markdown-preview-browse-right (url)
  "Force the xwidget preview of URL into a split window on the right."
  (let ((win (or (window-in-direction 'right)
                 (split-window-right))))
    (with-selected-window win
      (xwidget-webkit-browse-url url))))

(use-package! org-markdown-preview
  :defer t
  :config
  (setq org-markdown-preview-use-github-api nil
        org-markdown-preview-browse-fn #'+org-markdown-preview-browse-right))

;;; ─── Keybindings ────────────────────────────────────────────────────────────

(load! "+bindings")
