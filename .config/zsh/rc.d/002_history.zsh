# History settings

HISTFILE=$XDG_STATE_HOME/zsh/history
HISTSIZE=100000
SAVEHIST=100000

setopt EXTENDED_HISTORY       # Record timestamp and duration of each command
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate events first when trimming history
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate of a newly recorded event
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space
setopt HIST_REDUCE_BLANKS     # Trim superfluous blanks from each event
setopt HIST_VERIFY            # Do not execute immediately upon history expansion
setopt SHARE_HISTORY          # Share history between all sessions
