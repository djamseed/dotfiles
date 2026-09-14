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
      doom-font (font-spec :family "FiraCode Nerd Font" :size 15)
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
;;   journal/      one file per day, flat. `org-agenda-files' expands a
;;                 directory non-recursively, so flat it stays.
;;   notes/        org-roam knowledge base — atomic, MoC, people. Flat, mirroring
;;                 the Obsidian vault's Notes/.
;;   archive/      archived subtrees, datetree'd.
;;   calendar.org  org-gcal's fetch target.
;;

(setq org-directory "~/org/")

(defvar +org-journal-dir
  (file-name-as-directory (expand-file-name "journal" org-directory)))
(defvar +org-notes-dir
  (file-name-as-directory (expand-file-name "notes" org-directory)))
(defvar +org-archive-dir
  (file-name-as-directory (expand-file-name "archive" org-directory)))
(defvar +org-calendar-file (expand-file-name "calendar.org" org-directory))

(defun +org-ensure-tree ()
  "Create the `org-directory' subtree if any of it is missing.
org-capture, org-roam and org-archive all assume their target directory exists —
a buffer visiting a file in a missing one is read-only, so the save fails partway
through a capture. Running this at startup is what makes a fresh clone of this
repo enough to set up a new machine."
  (dolist (dir (list +org-journal-dir +org-notes-dir +org-archive-dir))
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

(defvar +org-template-time nil
  "Time a template expansion is relative to, for `%(...)' escapes.
Bound by `+org-template-expand-time'; nil means now.")

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
  "Expand the org-capture escapes %(sexp), %<...> and %U in STR, as of TIME.
The journal helpers write their own file head, outside `org-capture', which is
what would normally do this. TIME is visible to a %(sexp) as
`+org-template-time', so the same template renders correctly for any date."
  (let ((+org-template-time (or time (current-time))))
    (let ((s (with-temp-buffer
               (insert str)
               (goto-char (point-min))
               (while (search-forward "%(" nil t)
                 (let ((start (- (point) 2))
                       (sexp-start (1- (point))))
                   (goto-char sexp-start)
                   (forward-sexp)
                   (let ((value (eval (car (read-from-string
                                            (buffer-substring sexp-start (point))))
                                      t)))
                     (delete-region start (point))
                     (insert (format "%s" value)))))
               (buffer-string))))
      (setq s (replace-regexp-in-string
               "%<\\([^>]*\\)>"
               (lambda (m) (format-time-string (match-string 1 m) +org-template-time))
               s t t))
      (replace-regexp-in-string
       "%U" (format-time-string "[%Y-%m-%d %a %H:%M]" +org-template-time) s t t))))

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
        ;; Within the current file only. There is no projects.org to refile
        ;; into — that road leads back to GTD.
        org-refile-targets               '((nil :maxlevel . 2))
        org-refile-use-outline-path      'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm)

  ;; Tasks live inside the day they were written, as ordinary headings. CANCELLED
  ;; exists because org-gcal needs a keyword to mark a deleted event with; see
  ;; `org-gcal-cancelled-todo-keyword' below.
  ;;
  ;; `!' (timestamp) not `@' (note): a note prompt blocks bulk agenda actions,
  ;; since org cannot cope with simultaneous prompts.
  (setq org-todo-keywords
        '((sequence "TODO(t)" "|" "DONE(d!)" "CANCELLED(x!)")))

  (setq org-todo-keyword-faces
        '(("CANCELLED" . +org-todo-cancel)))

  ;; A = today, B = default, C = when it happens.
  (setq org-priority-default ?B
        org-priority-lowest  ?C)

  (setq org-enforce-todo-dependencies t
        org-enforce-todo-checkbox-dependencies t))

;;; ─── Journal — files ────────────────────────────────────────────────────────

;; Doom's file-templates expands a yasnippet with a live `${1:...}' field into
;; every new empty .org file. In the journal that fires before our own head is
;; written and then blocks on the field. Doom special-cases `org-journal-mode'
;; the same way; new rules are pushed to the front of `+file-templates-alist'.
(when (modulep! :editor file-templates)
  (set-file-template! "/org/journal/.*\\.org\\'" :ignore t))

(defvar +journal-agenda-days 90
  "How far back the agenda reaches into the journal.
Also what keeps it from scanning every file ever written.")

(defun +journal-pretty-date (&optional time)
  "Return TIME as \"June 15th, 2026\" — the vault's daily-note title format.
Called from templates as %(+journal-pretty-date); with no argument it uses
`+org-template-time', which `+org-template-expand-time' binds, so the title is
right for a day other than today."
  (let* ((time (or time +org-template-time (current-time)))
         (day  (string-to-number (format-time-string "%d" time)))
         (suffix (cond ((memq day '(11 12 13)) "th")
                       ((= 1 (mod day 10)) "st")
                       ((= 2 (mod day 10)) "nd")
                       ((= 3 (mod day 10)) "rd")
                       (t "th"))))
    (format-time-string (format "%%B %d%s, %%Y" day suffix) time)))

(defun +journal-daily-file (&optional time)
  "Absolute path of the daily log for TIME (default today)."
  (expand-file-name (format-time-string "%Y-%m-%d.org" time) +org-journal-dir))

(defun +journal--file-date (file)
  "Parse a YYYY-MM-DD daily FILE name into a time value, or nil."
  (let ((base (file-name-base file)))
    (when (string-match "\\`\\([0-9]\\{4\\}\\)-\\([0-9]\\{2\\}\\)-\\([0-9]\\{2\\}\\)\\'" base)
      (encode-time (list 0 0 12
                         (string-to-number (match-string 3 base))
                         (string-to-number (match-string 2 base))
                         (string-to-number (match-string 1 base))
                         nil -1 nil)))))

(defun +journal--day-offset (time n)
  "Return TIME shifted by N days.
Via `encode-time' rather than 86400-second arithmetic, which breaks on DST."
  (let ((d (decode-time time)))
    (encode-time (list 0 0 12
                       (+ (nth 3 d) n) (nth 4 d) (nth 5 d)
                       nil -1 nil))))

(defun +journal--iso-week-monday (week)
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

(defun +journal--daily-files ()
  "Every daily log on disk, oldest first."
  (sort (cl-remove-if-not
         #'+journal--file-date
         (and (file-directory-p +org-journal-dir)
              (directory-files +org-journal-dir t +org-file-regexp)))
        #'string<))

(defun +journal--ensure-file (file template &optional time)
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

(defun +journal--goto-notes-heading ()
  "Move point onto the `* Notes' heading line. Return non-nil if it was found.
Falls back to end of buffer."
  (goto-char (point-min))
  (or (re-search-forward "^\\* Notes[ \t]*$" nil t)
      (ignore (goto-char (point-max)))))

(defun +journal--goto-notes ()
  "Move point under the `* Notes' heading, ready to type.
Lands on the blank line *below* the heading, not at its end — otherwise typing
straight after `SPC n j j' appends to the heading text instead of the body.
`+journal-capture-target' deliberately does NOT use this: org-capture files an
entry as a child only when point is on the heading itself, and as a top-level
entry at end of file otherwise."
  (when (+journal--goto-notes-heading)
    (forward-line 1)
    ;; Guard the one case the template does not cover: a `* Notes' heading
    ;; immediately followed by the next heading or by EOF.
    (when (or (eobp) (org-at-heading-p))
      (save-excursion (insert "\n")))
    (goto-char (line-beginning-position))))

(defun +journal/goto-day (&optional time)
  "Open the daily log for TIME, creating it if needed. Defaults to today."
  (interactive)
  (switch-to-buffer
   (+journal--ensure-file (+journal-daily-file time) "journal/daily-head.org" time))
  (+journal--goto-notes))

(defun +journal/today ()     (interactive) (+journal/goto-day))
(defun +journal/yesterday () (interactive) (+journal/goto-day (+journal--day-offset (current-time) -1)))
(defun +journal/tomorrow ()  (interactive) (+journal/goto-day (+journal--day-offset (current-time)  1)))

(defun +journal/goto-date (date)
  "Open the daily log for DATE, prompting with the org date picker."
  (interactive (list (org-read-date nil t)))
  (+journal/goto-day date))

(defun +journal--adjacent (n)
  "Return the daily log N positions from the current one on disk, or nil.
Walks existing files rather than the calendar, so it skips days you did not
write — the job the vault's yesterday/tomorrow link line did by hand."
  (let* ((files (+journal--daily-files))
         (base  (and buffer-file-name (file-name-base buffer-file-name)))
         (idx   (and base (cl-position base files
                                       :key #'file-name-base :test #'string=))))
    (unless idx (user-error "Not visiting a daily log"))
    (let ((target (+ idx n)))
      (and (>= target 0) (< target (length files)) (nth target files)))))

(defun +journal/previous-day ()
  "Open the previous daily log that exists."
  (interactive)
  (if-let* ((f (+journal--adjacent -1))) (find-file f)
    (user-error "No earlier log")))

(defun +journal/next-day ()
  "Open the next daily log that exists."
  (interactive)
  (if-let* ((f (+journal--adjacent 1))) (find-file f)
    (user-error "No later log")))

(defun +journal/browse ()
  "Open the journal directory."
  (interactive)
  (make-directory +org-journal-dir t)
  (dired +org-journal-dir))

;;; ─── Journal — capture ──────────────────────────────────────────────────────

(defun +journal-capture-target ()
  "org-capture target: under `* Notes' in today's daily.
Does not call `org-roam-dailies--capture' — nesting a capture inside a capture
hangs."
  (let ((file (+journal-daily-file))
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
    ;; On the heading, not under it — see `+journal--goto-notes'.
    (+journal--goto-notes-heading)))

(after! org
  ;; One target, no filing decision at capture time: today's log.
  (setq org-capture-templates
        `(("t" "Task" entry (function +journal-capture-target)
           ,(+org-template "capture/task.org") :empty-lines 1)
          ("n" "Note" entry (function +journal-capture-target)
           ,(+org-template "capture/note.org") :empty-lines 1))))

;;; ─── Journal — week review ──────────────────────────────────────────────────

;; The vault's weekly note was worth keeping only because dataview filled it in.
;; Without a query engine a weekly *file* is seven links to maintain by hand, so
;; there isn't one: the week is generated on demand into a scratch buffer and
;; thrown away. org-transclusion pulls each day's `* Notes' in live, so nothing
;; is ever duplicated on disk and nothing can go stale.

(defun +journal--week-buffer-name (week)
  (format "*week %s*" week))

(defun +journal/goto-week (&optional time)
  "Build a review buffer for TIME's ISO week (default this week)."
  (interactive)
  (require 'org-transclusion)
  (let* ((week   (format-time-string "%G-W%V" time))
         (monday (+journal--iso-week-monday week))
         (buf    (get-buffer-create (+journal--week-buffer-name week))))
    (with-current-buffer buf
      (when (bound-and-true-p org-transclusion-mode)
        (org-transclusion-remove-all))
      (erase-buffer)
      (unless (derived-mode-p 'org-mode) (org-mode))
      ;; Absolute links throughout, but org-transclusion resolves relative to
      ;; `default-directory' in a buffer with no file.
      (setq default-directory +org-journal-dir)
      (insert "#+title: " week "\n#+startup: showall\n\n")
      (let ((found nil))
        (dotimes (i 7)
          (let* ((day  (+journal--day-offset monday i))
                 (file (+journal-daily-file day)))
            (when (file-readable-p file)
              (setq found t)
              (insert (format "* %s  [[file:%s][%s]]\n"
                              (format-time-string "%a %-d %b" day)
                              file (file-name-base file)))
              ;; No :only-contents — it strips the day's sub-headings while
              ;; keeping their SCHEDULED lines, so tasks vanish from the review.
              (insert (format "#+transclude: [[file:%s::*Notes]] :level 2\n\n"
                              file)))))
        (unless found
          (insert "No daily logs this week.\n")))
      (goto-char (point-min))
      (org-transclusion-add-all))
    (switch-to-buffer buf)))

(defun +journal/this-week () (interactive) (+journal/goto-week))
(defun +journal/last-week () (interactive) (+journal/goto-week (+journal--day-offset (current-time) -7)))

;;; ─── Org — agenda ───────────────────────────────────────────────────────────

(defun +journal-agenda-files ()
  "Agenda scope: recent dailies plus the calendar."
  (let ((cutoff (float-time (+journal--day-offset (current-time)
                                                  (- +journal-agenda-days)))))
    (append
     (cl-remove-if
      (lambda (f) (< (float-time (+journal--file-date f)) cutoff))
      (+journal--daily-files))
     (and (file-readable-p +org-calendar-file) (list +org-calendar-file)))))

(defun +journal-refresh-agenda-files (&rest _)
  "Recompute `org-agenda-files'. The set changes every midnight."
  (setq org-agenda-files (+journal-agenda-files)))

(advice-add 'org-agenda :before #'+journal-refresh-agenda-files)
;; `g' in the agenda calls `org-agenda-redo', which does not route through
;; `org-agenda' — without this, a session left open past midnight would keep
;; using yesterday's file list. `org-agenda-redo-all' delegates to it.
(advice-add 'org-agenda-redo :before #'+journal-refresh-agenda-files)

(after! org-agenda
  (+journal-refresh-agenda-files)
  (setq org-agenda-span              'week
        org-agenda-start-on-weekday  1
        ;; Doom defaults this to "-3d", shifting every block three days into the
        ;; past. nil starts today; weekly views still snap to Monday.
        org-agenda-start-day         nil
        org-agenda-start-with-log-mode '(closed)
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
        "◀ ─────────────────────────────────── now"))

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

  ;; Mirrors the Obsidian vault: a flat notes/ directory, sentence-case filenames
  ;; with spaces, and type/topic/status/created as file-level properties, which
  ;; org-roam indexes into its DB (unlike #+keywords).
  (setq org-roam-capture-templates
        `(("a" "atomic" plain ,(+org-template "roam/atomic.org")
           :target (file+head "notes/${title}.org" ,(+org-template-head "roam/atomic-head.org"))
           :unnarrowed t :empty-lines-before 1)
          ("m" "map of content" plain ,(+org-template "roam/moc.org")
           :target (file+head "notes/${title}.org" ,(+org-template-head "roam/moc-head.org"))
           :unnarrowed t :empty-lines-before 1)
          ("p" "person" plain ,(+org-template "roam/person.org")
           :target (file+head "notes/${title}.org" ,(+org-template-head "roam/person-head.org"))
           :unnarrowed t :empty-lines-before 1)))

  ;; Same head as `SPC X' and the journal commands, so all three entry points
  ;; produce identical files.
  (setq org-roam-dailies-capture-templates
        `(("d" "note" entry ,(+org-template "capture/note.org")
           :target (file+head+olp "%<%Y-%m-%d>.org"
                                  ,(+org-template-head "journal/daily-head.org")
                                  ("Notes"))
           :empty-lines 1)
          ("t" "task" entry ,(+org-template "capture/task.org")
           :target (file+head+olp "%<%Y-%m-%d>.org"
                                  ,(+org-template-head "journal/daily-head.org")
                                  ("Notes"))
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

(defun +gcal--security (&rest args)
  "Run security(1) with ARGS, returning trimmed stdout, or nil on failure."
  (with-temp-buffer
    (when (zerop (apply #'call-process "/usr/bin/security" nil t nil args))
      (let ((out (string-trim (buffer-string))))
        (unless (string-empty-p out) out)))))

(defun +gcal-load-credentials ()
  "Load the OAuth client id/secret from the macOS Keychain.
The generic-password item's service is `gcal.googleapis.com\=', its account
field holds the client id and its password the client secret.
Returns non-nil when both were found.

Shells out to security(1) rather than using `auth-source\=': as of Emacs 31
the `macos-keychain-generic\=' backend hands its default collection to
`call-process\=' as a symbol and dies with a `wrong-type-argument\=', and it
maps :host onto the item\='s creator field rather than its service."
  (when-let* ((attrs  (+gcal--security "find-generic-password"
                                       "-s" "gcal.googleapis.com"))
              (id     (and (string-match "^ *\"acct\"<blob>=\"\\(.*\\)\"$" attrs)
                           (match-string 1 attrs)))
              (secret (+gcal--security "find-generic-password"
                                       "-s" "gcal.googleapis.com" "-w")))
    (setq org-gcal-client-id id
          org-gcal-client-secret secret)
    t))

;; Must run before org-gcal loads: the package registers its oauth2-auto
;; provider at load time from these two variables, and warns if they are still
;; unset then. `after!' would be too late.
(+gcal-load-credentials)

(after! org-gcal
  (setq org-gcal-fetch-file-alist `((,+gcal-calendar-id . ,+org-calendar-file))
        org-gcal-recurring-events-mode 'nested
        org-gcal-remove-api-cancelled-events t
        org-gcal-update-cancelled-events-with-todo t
        org-gcal-cancelled-todo-keyword "CANCELLED"
        org-gcal-notify-p nil
        org-gcal-up-days   30
        org-gcal-down-days 180
        org-gcal-strip-html-descriptions t
        ;; Otherwise every sync re-prompts for the plstore passphrase.
        plstore-cache-passphrase-for-symmetric-encryption t
        ;; Homebrew ships only the curses/tty pinentry, which a GUI Emacs
        ;; cannot drive; read the plstore passphrase in the minibuffer instead.
        epg-pinentry-mode 'loopback)
  ;; Idempotent, and picks up credentials that weren't readable at startup.
  (when (+gcal-load-credentials)
    (org-gcal-reload-client-id-secret)))

(defun +gcal/sync ()
  "Two-way sync with Google Calendar, if credentials are configured."
  (interactive)
  (require 'org-gcal)
  (if (+gcal-load-credentials)
      (progn (org-gcal-reload-client-id-secret)
             (org-gcal-sync))
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
