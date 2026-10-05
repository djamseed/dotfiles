# Enable color support for BSD `ls`
export CLICOLOR=1
export LSCOLORS=GxFxCxDxCxegedabagaced

# used with eza output (cached, regenerated when vivid is updated)
if (($+commands[vivid])); then
    _ls_colors=$ZCACHEDIR/ls_colors
    [[ -s $_ls_colors && $_ls_colors -nt ${commands[vivid]} ]] || vivid generate ansi >| $_ls_colors
    export LS_COLORS=$(<$_ls_colors)
    unset _ls_colors
fi
