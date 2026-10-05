#
# .zshrc - Zsh file loaded for interactive shell sessions.
#

# Skip loading for non-interactive shells
case $- in
    *i*) ;;
    *) return ;;
esac

# Lazy-load (autoload) Zsh function files from a directory.
ZFUNCDIR=$ZDOTDIR/zfunc
fpath=($ZFUNCDIR $fpath)
autoload -Uz $ZFUNCDIR/*(.:t)

# Cache directory for compdump and generated init scripts
ZCACHEDIR=$XDG_CACHE_HOME/zsh
[[ -d $ZCACHEDIR ]] || mkdir -p $ZCACHEDIR

# Source the output of an init command, regenerated only when its binary changes.
# Delete $ZCACHEDIR/*.zsh to force a refresh.
# usage: _cache_eval <command> [args...]
_cache_eval() {
    local bin=${commands[$1]} cache=$ZCACHEDIR/${1}_init.zsh
    [[ -n $bin ]] || return 1
    if [[ ! -s $cache || $bin -nt $cache ]]; then
        "$@" >| $cache || { rm -f $cache; return 1; }
    fi
    source $cache
}

for file in $ZDOTDIR/rc.d/*; do
    [ -r $file ] && source $file
done
unset file
unfunction _cache_eval

# Set default permissions for files and directories
# files: 644, directories: 755
umask 022

# Source .privaterc if present
[ -r $HOME/.privaterc ] && source $HOME/.privaterc
