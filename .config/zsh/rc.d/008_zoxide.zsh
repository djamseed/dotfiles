# Initialize zoxide

export _ZO_DATA_DIR=$XDG_DATA_HOME/zoxide
(($+commands[zoxide])) && eval "$(zoxide init zsh --cmd cd)"
