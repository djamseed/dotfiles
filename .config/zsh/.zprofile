#
# .zprofile - Zsh file loaded for login shells.
#

# Disable Zsh session for macOS Terminal.app
export SHELL_SESSION_DISABLE=1

# Setup Homebrew's environment variables
(($+commands[brew])) && eval "$($(arch | grep -q arm64 && echo /opt/homebrew/bin/brew || echo /usr/local/bin/brew) shellenv)"
