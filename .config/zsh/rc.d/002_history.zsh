# History settings

HISTFILE=$XDG_STATE_HOME/zsh/history
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS     # Do not record an event that was just recorded again
setopt HIST_IGNORE_SPACE    # Do not record an event starting with a space
setopt HIST_REDUCE_BLANKS   # Trim superfluous blanks from each event
setopt HIST_VERIFY          # Do not execute immediately upon history expansion
setopt SHARE_HISTORY        # Share history between all sessions
