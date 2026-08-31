;;; $DOOMDIR/init.el -*- lexical-binding: t; -*-

(doom! :completion
       (corfu +orderless +icons)  ; complete with cap(f), cape and a flying feather!
       (vertico +icons)           ; the search engine of the future

       :ui
       doom                ; what makes DOOM look the way it does
       dashboard           ; a nifty splash screen for Emacs
       hl-todo             ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       indent-guides       ; highlighted indent columns
       modeline            ; snazzy, Atom-inspired modeline, plus API
       ophints             ; highlight the region an operation acts on
       (popup +defaults)   ; tame sudden yet inevitable temporary windows
       smooth-scroll       ; So smooth you won't believe it's not butter
       treemacs            ; a project drawer, like neotree but cooler
       (vc-gutter +pretty) ; vcs diff in the fringe
       workspaces          ; tab emulation, persistence & separate workspaces
       zen                 ; distraction-free coding or writing

       :editor
       (evil +everywhere)        ; come to the dark side, we have cookies
       file-templates            ; auto-snippets for empty files
       fold                      ; (nigh) universal code folding
       format                    ; automated prettiness
       snippets                  ; my elves. They type so I don't have to
       (whitespace +guess +trim) ; a butler for your whitespace
       word-wrap                 ; soft wrapping with language-aware indent

       :emacs
       (dired +icons) ; making dired pretty [functional]
       electric       ; smarter, keyword-based electric-indent
       tramp          ; remote files at your arthritic fingertips
       undo           ; persistent, smarter undo for your inevitable mistakes
       vc             ; version-control and Emacs, sitting in a tree


       :checkers
       syntax            ; tasing you for every semicolon you forget
       spell             ; tasing you for misspelling mispelling

       :tools
       ;;debugger        ; stepping through code, to help you add bugs
       (eval +overlay)   ; run code, run (also, repls)
       (lookup +docsets) ; navigate your code and its documentation
       ;;llm             ; when I said you needed friends, I didn't mean...
       magit             ; a git porcelain for Emacs
       tree-sitter       ; syntax and parsing, sitting in a tree...

       :os
       (:if (featurep :system 'macos) macos)  ; improve compatibility with macOS
       ;;tty               ; improve the terminal Emacs experience

       :lang
       emacs-lisp                             ; drown in parentheses
       (go +lsp +tree-sitter)                 ; the hipster dialect
       (json +tree-sitter)                    ; At least it ain't XML
       (markdown +tree-sitter)                ; writing docs for people to ignore
       (org +pretty +roam +dragndrop +pandoc) ; organize your plain life in plain text
       (sh +lsp)                              ; she sells {ba,z,fi}sh shells on the C xor
       (yaml +tree-sitter)                    ; JSON, but readable


       :app
       calendar

       :config
       (default +bindings +smartparens))
