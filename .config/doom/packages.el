;;; $DOOMDIR/packages.el -*- no-byte-compile: t; -*-

;; Theme
(package! autothemer)
(package! oxocarbon-theme
  :recipe (:host github :repo "konrad1977/oxocarbon-emacs"))


;; Org / agenda / roam extras.
;; NOTE: org-modern and org-appear are already pulled (and pinned) by the
;; `+pretty' flag on `:lang org' — don't redeclare them here, an unpinned
;; redeclaration only loses Doom's pin.
(package! org-super-agenda)  ; grouped, categorized agenda views
(package! org-roam-ui)       ; web-based graph view for org-roam
(package! consult-org-roam)  ; org-roam search/backlinks via consult
(package! org-gcal)          ; two-way Google Calendar sync

;; Live preview of org-mode and markdown files (uses xwidgets)
(package! org-markdown-preview
  :recipe (:host github
           :repo "KarimAziev/org-markdown-preview"
           :files ("*.el" "*.html")))
