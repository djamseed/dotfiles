# sqz — context intelligence layer (auto-installed)

sqz_run() {
    "$@" 2>&1 | SQZ_CMD="$*" sqz compress
}
sqz_sudo() {
    sudo "$@" 2>&1 | SQZ_CMD="sudo $*" sqz compress
}
preexec() {
    export __SQZ_CMD="$1"
}
# sqz — end of auto-installed block


