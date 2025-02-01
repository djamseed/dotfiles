#
# .zshenv - Zsh environment file, loaded for all shell sessions.
#

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# XDG Base Directory Specification
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# Load Zsh configuration files from $ZDOTDIR
export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# Disable global Zsh configuration
unsetopt GLOBAL_RCS
