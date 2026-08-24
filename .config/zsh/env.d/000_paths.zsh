# Ensure path arrays have unique values
typeset -U path cdpath fpath manpath

# Set the list of directories that zsh searches for commands
path=(
    /usr/local/{,s}bin(N)
    $DOTNET_CLI_HOME/.dotnet/tools(N)
    $HOMEBREW_PREFIX/opt/curl/bin(N)
    $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin(N)
    $HOMEBREW_PREFIX/opt/make/libexec/gnubin(N)
    $XDG_CONFIG_HOME/emacs/bin
    $XDG_DATA_HOME/bin(N)
    $XDG_DATA_HOME/go/bin(N)
    $path
)

# Set the list of directories where the `man` command searches for man pages
manpath=(
    /usr/local/share/man(N)
    /usr/share/man(N)
    $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnuman(N)
    $HOMEBREW_PREFIX/opt/make/libexec/gnuman(N)
    $manpath
)
