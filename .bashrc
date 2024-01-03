#!/usr/bin/env bash

# shellcheck disable=SC1090,SC1091

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

for file in ~/.{paths,exports,aliases,functions,extra,dockerfuncs}; do
    if [[ -r "$file" ]] && [[ -f "$file" ]]; then
        # shellcheck source=/dev/null
        source "$file"
    fi
done
unset file

# Starship prompt
command -v starship &>/dev/null && eval "$(starship init bash)"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2>/dev/null
done

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
