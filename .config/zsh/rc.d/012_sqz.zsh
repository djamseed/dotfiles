# sqz — context intelligence layer (auto-installed)

sqz_run() {
    "$@" 2>&1 | SQZ_CMD="$*" sqz compress
}
sqz_sudo() {
    sudo "$@" 2>&1 | SQZ_CMD="sudo $*" sqz compress
}
_sqz_preexec() {
    export __SQZ_CMD="$1"
}
autoload -Uz add-zsh-hook
add-zsh-hook preexec _sqz_preexec
# sqz — end of auto-installed block
