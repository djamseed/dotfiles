;;; $DOOMDIR/+bindings.el -*- lexical-binding: t; -*-
;;
;; Loaded from the end of config.el.
;;
;; Extending an existing Doom prefix requires a *string* prefix. A cons like
;; (:prefix ("r" . "roam")) creates a NEW keymap at that key, silently wiping
;; every binding Doom already put there. Use a cons only for a new group.

(map! :leader
      (:prefix-map ("TAB" . "workspace")
       :desc "Switch to last workspace" "," #'+workspace/other))

;; SPC n j is free: Doom's journal prefix is guarded by `+journal', which is off.
(map! :leader
      (:prefix "n"
       (:prefix ("j" . "journal")
        :desc "Today"         "j" #'+journal/today
        :desc "Yesterday"     "y" #'+journal/yesterday
        :desc "Tomorrow"      "t" #'+journal/tomorrow
        :desc "Go to date"    "d" #'+journal/goto-date
        :desc "Previous log"  "p" #'+journal/previous-day
        :desc "Next log"      "n" #'+journal/next-day
        :desc "This week"     "w" #'+journal/this-week
        :desc "Last week"     "W" #'+journal/last-week
        :desc "Browse journal" "b" #'+journal/browse)))

;; Doom owns a/f/F/g/i/n/r/R/s and the d sub-prefix here.
(map! :leader
      (:prefix "n"
       (:prefix "r"
        :desc "Roam UI (graph in browser)" "u" #'org-roam-ui-open
        :desc "Search roam (ripgrep)"      "/" #'consult-org-roam-search
        :desc "Backlinks"                  "b" #'consult-org-roam-backlinks
        :desc "Forward links"              "l" #'consult-org-roam-forward-links)))

(map! :leader
      (:prefix "n"
       (:prefix ("g" . "google calendar")
        :desc "Sync (two-way)"        "s" #'+gcal/sync
        :desc "Fetch only"            "f" #'org-gcal-fetch
        :desc "Post event at point"   "p" #'org-gcal-post-at-point
        :desc "Delete event at point" "d" #'org-gcal-delete-at-point)))

;; Doom owns a/t/m/v under SPC o a.
(map! :leader
      (:prefix "o"
       (:prefix "a"
        :desc "Calendar (calfw)" "c" #'+calendar/open-calendar)))
