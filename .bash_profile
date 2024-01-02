#!/usr/bin/env bash

# Load .bashrc, which loads: ~/.{paths,exports,aliases,functions,extra,dockerfuncs}
if [[ -r "${HOME}/.bashrc" ]]; then
    # shellcheck source=/dev/null
    source "${HOME}/.bashrc"
fi
