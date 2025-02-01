#
# .zshrc - Zsh file loaded for interactive shell sessions.
#

# Skip loading for non-interactive shells
case $- in
    *i*) ;;
    *) return ;;
esac
[ -z "$PS1" ] && return

# Lazy-load (autoload) Zsh function files from a directory.
ZFUNCDIR=$ZDOTDIR/zfunctions
fpath=($ZFUNCDIR $fpath)
autoload -Uz $ZFUNCDIR/*(.:t)

for file in $ZDOTDIR/rc.d/*; do
    source $file
done
unset file

# Set default permissions for files and directories
# files: 644, directories: 755
umask 002

# Enable Vi keybindings
bindkey -v
