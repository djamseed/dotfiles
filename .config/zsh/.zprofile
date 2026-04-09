#
# .zprofile - Zsh file loaded for login shells.
#

# Disable Zsh session for macOS Terminal.app
export SHELL_SESSION_DISABLE=1

# Setup Homebrew's environment variables
_brew_env_cache=$XDG_CACHE_HOME/brew_shellenv.zsh
{ [[ ! -f $_brew_env_cache ]] || [[ /opt/homebrew/bin/brew -nt $_brew_env_cache ]]; } && /opt/homebrew/bin/brew shellenv >| $_brew_env_cache
source $_brew_env_cache
unset _brew_env_cache
