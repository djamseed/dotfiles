#
# .zprofile - Zsh file loaded on interactive/non-interactive login shell sessions.
#

# Disable Zsh shell sessions
export SHELL_SESSION_DISABLE=1

[ -f "$ZDOTDIR/.zshrc" ] && source "$ZDOTDIR/.zshrc"
