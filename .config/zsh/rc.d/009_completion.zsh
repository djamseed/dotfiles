# Completion tweaks

zstyle ':completion:*'              list-colors         "${(s.:.)LS_COLORS}"
zstyle ':completion:*'              list-dirs-first     true
zstyle ':completion:*'              verbose             true
zstyle ':completion:*'              menu                select
zstyle ':completion:*'              matcher-list        'm:{[:lower:]}={[:upper:]}'
zstyle ':completion::complete:*'    use-cache           true
zstyle ':completion::complete:*'    cache-path          $XDG_CACHE_HOME/zsh/compcache
zstyle ':completion:*:descriptions' format              [%d]
zstyle ':completion:*:manuals'      separate-sections   true

# Make sure complist is loaded
zmodload zsh/complist

# Init completions, but regenerate compdump only once a day.
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+20' matches files (or directories or whatever) that are older than 20 hours.
autoload -Uz compinit
compdump_path="${XDG_CACHE_HOME}/zsh/compdump"

if [[ -n ${compdump_path}(#qN.mh+20) ]]; then
    compinit -i -u -d "$compdump_path"
    {
        autoload -Uz zrecompile
        zrecompile -pq "$compdump_path"
    } &!
else
    compinit -i -u -C -d "$compdump_path"
fi

# Use h/j/k/l in menu selection (during completion)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# zsh parameter completion for the dotnet CLI

_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}

compdef _dotnet_zsh_complete dotnet
