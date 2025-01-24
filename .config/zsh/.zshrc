#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac
[ -z "$PS1" ] && return

zmodload zsh/zprof

# Set up Homebrew's environment variables
(($+commands[brew])) && eval "$($(arch | grep -q arm64 && echo /opt/homebrew/bin/brew || echo /usr/local/bin/brew) shellenv)"

# Enable Starship prompt
(($+commands[starship])) && eval "$(starship init zsh)"

source "$ZDOTDIR/rc.d/aliases"

zprof
