# Enable color support for BSD `ls`
export CLICOLOR=1
export LSCOLORS=GxFxCxDxCxegedabagaced

# Enable color support for GNU `ls`
(($+commands[gls])) && (($+commands[vivid])) && export LS_COLORS=$(vivid generate rose-pine-dawn)
