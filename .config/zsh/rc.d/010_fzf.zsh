# fzf options

(($+commands[fzf])) && {
    export FZF_DEFAULT_OPTS='
          --height 75% --multi --reverse --margin=0,1
          --bind ctrl-d:page-down,ctrl-u:page-up
          --bind pgdn:preview-page-down,pgup:preview-page-up
          --marker="✚" --pointer="▶" --prompt="❯ "
          --no-separator --scrollbar="█" --border
          --color bg+:#262626,fg+:#dadada,hl:#f09479,hl+:#f09479
          --color border:#303030,info:#cfcfb0,header:#80a0ff,spinner:#36c692
          --color prompt:#87afff,pointer:#ff5189,marker:#f09479'

    if (($+commands[fd])); then
        export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=never'
        export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
        export FZF_ALT_C_COMMAND='fd --type directory --hidden --exclude .git . --color=never'
    fi

    if (($+commands[bat])); then
        export FZF_CTRL_T_OPTS='--preview "bat --color=always --line-range :500 {}"'
    fi

    if (($+commands[eza])); then
        export FZF_ALT_C_OPTS='--preview "eza -T | head -n 100"'
    fi

    # Enable fzf keybindings
    (($+commands[brew])) && [ -r $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh ] && source $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh
}
