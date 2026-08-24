;;; $DOOMDIR/packages.el -*- no-byte-compile: t; -*-

;; Theme
(package! autothemer)
(package! oxocarbon-theme
  :recipe (:host github :repo "konrad1977/oxocarbon-emacs"))

;; macOS PATH fix. GUI/daemon Emacs doesn't source your shell rc files, and the
;; `:os macos' module does not ship this.
(package! exec-path-from-shell)

;; Org / agenda / roam extras.
;; NOTE: org-modern and org-appear are NOT declared here — `:lang org +pretty'
;; already installs and configures them, with pins. Redeclaring them would
;; unpin them and float on upstream HEAD.
;; NOTE: org-gcal and calfw come from `:app calendar'.
(package! org-super-agenda)  ; grouped, categorized agenda views
(package! org-roam-ui)       ; web-based graph view for org-roam
(package! consult-org-roam)  ; org-roam search/backlinks via consult
(package! org-auto-tangle)   ; auto-tangle babel blocks on save

;; Live preview of org-mode and markdown files (uses xwidgets)
(package! org-markdown-preview
  :recipe (:host github
           :repo "KarimAziev/org-markdown-preview"
           :files ("*.el" "*.html")))
