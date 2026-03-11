# Ensure path arrays have unique values
typeset -U path cdpath fpath manpath

# Set the list of directories that zsh searches for commands
path=(
    /Applications/Docker.app/Contents/Resources/bin(N)
    /opt/{homebrew,local}/{,s}bin(N)
    /usr/local/{,s}bin(N)
    $HOMEBREW_PREFIX/opt/curl/bin(N)
    $HOMEBREW_PREFIX/opt/make/libexec/gnubin(N)
    $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin(N)
    $GOPATH(N)
    $GOBIN(N)
    $CARGO_HOME/bin(N)
    $PYENV_ROOT/bin(N)
    $path
)

# Set the list of directories where the `man` command searches for man pages
manpath=(
    /usr/local/share/man(N)
    /usr/share/man(N)
    $HOMEBREW_PREFIX/opt/make/libexec/gnuman(N)
    $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnuman(N)
    $manpath
)
