# Make `nvim` the default editor
(($+commands[nvim])) && export EDITOR=nvim VISUAL=nvim || export EDITOR=vim VISUAL=vim

# Better experience for `less`
#    -F: Exit if contents fit on one screen.
#    -Q: Quiet mode .
#    -M: Long prompt.
#    -R: Display raw control characters.
#    -X: Disable screen clearing.
#    -i: Case-insensitive search.
#    -g: Highlight only the match, not the entire line.
#    -s: Squeeze multiple blank lines into one.
#    -x4: Set tab stops every 4 spaces.
#    -z-2: Scroll by 2 lines at a time
export LESS='-F -Q -M -R -X -i -g -s -x4 -z-2'

# Use `less` as the default pager
export PAGER=less

# Use `bat` as the default pager for man pages
(($+commands[bat])) && export MANPAGER='col -bx | bat -l man -p' || export MANPAGER=less

# Ensure Homebrew-installed binaries for curl take precedence
if (($+commands[brew])); then
    LIBCURL_CFLAGS="-L$HOMEBREW_PREFIX/opt/curl/lib"
    LIBCURL_LIBS="-I$HOMEBREW_PREFIX/opt/curl/include"
    export LIBCURL_CFLAGS LIBCURL_LIBS
fi

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$TTY

# Enable color support for BSD `ls`
export CLICOLOR=1
export LSCOLORS=GxFxCxDxCxegedabagaced

# Enable color support for GNU `ls`
(($+commands[gls])) && (($+commands[vivid])) && export LS_COLORS=$(vivid generate rose-pine-dawn)

# Reconfigure applications to use the XDG Base Directory structure
export CARGO_HOME=$XDG_DATA_HOME/cargo
export DOCKER_CONFIG=$XDG_CONFIG_HOME/docker
export DOTNET_CLI_HOME=$XDG_DATA_HOME/dotnet
export GOPATH=$XDG_DATA_HOME/go
export LESSHISTFILE=$XDG_STATE_HOME/less/history
export NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm
export NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm
export NPM_CONFIG_INIT_MODULE=$XDG_CONFIG_HOME/npm/config/npm-init.js
export NUGET_PACKAGES=$XDG_DATA_HOME/NugetPackages
export OMNISHARPHOME=$XDG_CONFIG_HOME/omnisharp
export PYENV_ROOT=$XDG_DATA_HOME/pyenv
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export TLRC_CONFIG=$XDG_CONFIG_HOME/tldr/config.toml

# .NET environment variables
export DOTNET_ROOT=/usr/local/share/dotnet

# Go environment variables
export GOBIN=$GOPATH/bin
