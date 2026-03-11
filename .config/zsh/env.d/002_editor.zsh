# Make `nvim` the default editor
(($+commands[nvim])) && export EDITOR=nvim VISUAL=nvim || export EDITOR=vim VISUAL=vim
