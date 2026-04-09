#
# .zshenv - Zsh environment file, loaded for all shell sessions.
#

# XDG Base Directory Specification
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# Load Zsh configuration files from $ZDOTDIR
export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# Disable global Zsh configuration
unsetopt GLOBAL_RCS

# Load environment variables from env.d
for file in $XDG_CONFIG_HOME/zsh/env.d/*.zsh(N); do
    source $file
done
unset file
