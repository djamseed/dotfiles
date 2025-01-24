#
# .zshenv - Zsh environment file, always loaded for every shell sessions.
#

# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/latest/
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Locale
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'

# Ensure path arrays do not have duplicates
typeset -U path fpath manpath

# Set the list of directories that Zsh searches for programs
path=(
    /opt/{homebrew,local}/{,s}bin(N)
    /usr/local/{,s}bin(N)
    $path
)

# Zsh configuration directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
