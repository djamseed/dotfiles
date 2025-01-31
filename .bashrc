#!/usr/bin/env bash

# shellcheck disable=SC1090,SC1091

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Source dotfiles
for file in ~/.{paths,exports,aliases,functions,extra,dockerfuncs}; do
    if [[ -r "$file" ]] && [[ -f "$file" ]]; then
        # shellcheck source=/dev/null
        source "$file"
    fi
done
unset file

# Starship prompt
command -v starship &>/dev/null && eval "$(starship init bash)"

# History settings.
HISTCONTROL=ignoreboth:erasedups    # Ignore and erase duplicates
HISTFILE=$HOME/.cache/.bash_history # Custom history file
HISTFILESIZE=99999                  # Max size of history file
HISTIGNORE='?:??'                   # Ignore one and two letter commands
HISTSIZE=99999                      # Amount of history to preserve

# Disable /etc/bashrc_Apple_Terminal Bash sessions on Mac, it does not play
# nice with normal bash history. Also, create a ~/.bash_sessions_disable
# file to be double sure to disable Bash sessions.
export SHELL_SESSION_HISTORY=0

# Enable useful shell options:
#  - autocd - change directory without no need to type 'cd' when changing directory
#  - cdspell - automatically fix directory typos when changing directory
#  - direxpand - automatically expand directory globs when completing
#  - dirspell - automatically fix directory typos when completing
#  - globstar - ** recursive glob
#  - histappend - append to history, don't overwrite
#  - histverify - expand, but don't automatically execute, history expansions
#  - nocaseglob - case-insensitive globbing
#  - no_empty_cmd_completion - do not TAB expand empty lines
shopt -s autocd cdspell direxpand dirspell globstar histappend histverify \
    nocaseglob no_empty_cmd_completion

# Prevent file overwrite on stdout redirection.
# Use `>|` to force redirection to an existing file.
set -o noclobber

# Set preferred umask.
umask 002

# Enable vi mode
set -o vi

# Add tab completion for many Bash commands
if which brew &>/dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
    # Ensure existing Homebrew v1 completions continue to work
    BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
    export BASH_COMPLETION_COMPAT_DIR
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

# Add fzf keybinding
if which brew &>/dev/null && [ -r "$(brew --prefix)/opt/fzf/shell/key-bindings.bash" ]; then
    source "$(brew --prefix)/opt/fzf/shell/key-bindings.bash"
fi

# Execute pyenv
command -v pyenv &>/dev/null && eval "$(pyenv init -)"
