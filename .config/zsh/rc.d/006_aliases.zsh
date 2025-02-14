# Remove all previous environment defined aliases
unalias -a

# Better defaults
alias c=clear
alias cp='cp -iv'
alias cwd='pwd | tr -d "\r\n" | pbcopy'
alias mkdir='mkdir -pv'
alias mv='mv -i'
alias r='exec ${SHELL} -l'
alias sudo='sudo '
alias week='date +%V'
alias zap='rm -i'
(($+commands[bat])) && alias cat=bat
(($+commands[duf])) && alias df=duf
(($+commands[dust])) && alias du='dust -n 30 -X .git'
(($+commands[fd])) && alias fd='fd -H -E .git'
(($+commands[eza])) && {
    alias la='eza -ABghHl --icons --group-directories-first'
    alias lr='eza -T -L 5 --git-ignore --icons'
    alias lsd='eza -lADh'
    alias lsg='eza -lA --git --icons'
}
(($+commands[gls])) && alias ls='gls -lF --group-directories-first --color=auto'
(($+commands[gping])) && alias ping=gping
(($+commands[procs])) && alias ps=procs
(($+commands[rg])) && {
    alias rg='rg -. -S -g "!.git"'
    alias locale='locale -a | rg UTF-8'
    alias ports='sudo lsof -i -P -n | rg LISTEN'

    # View HTTP traffic
    alias httpdump='sudo tcpdump -i en0 -n -s 0 -w - | rg -a -o -P "Host: .*|GET /.*"'
    alias sniff='sudo rg -i -t "^(GET|POST) " -d en1 "tcp and port 80"'
}
(($+commands[btop])) && alias top=btop
(($+commands[nvim])) && {
    alias vi=nvim
    alias vim=nvim
}

# Networking
alias flushdns='sudo killall -HUP mDNSResponder && dscacheutil -flushcache'                  # flushDNS:     Flush out the DNS Cache
alias ipInfo0='ipconfig getpacket en0'                                                       # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'                                                       # ipInfo1:      Get info on connections for en1
alias localip='ipconfig getifaddr en0'                                                       # localip:      Display the local address
alias lsock='sudo lsof -i -P'                                                                # lsock:        Display open sockets
(($+commands[rg])) && alias lsockT='sudo lsof -nP | rg TCP'                                  # lsockT:       Display only open TCP sockets
(($+commands[rg])) && alias lsockU='sudo lsof -nP | rg UDP'                                  # lsockU:       Display only open UDP sockets
alias netCons='lsof -i'                                                                      # netCons:      Show all open TCP/IP sockets
alias nic="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"                 # nic:          Show active network interfaces
alias op='sudo lsof -i -P'                                                                   # op:           List of open ports
alias pubip='curl -s checkip.dyndns.org | sed -e "s/.*Current IP Address: //" -e "s/<.*$//"' # myip:         Public facing IP Address

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias cleanupls='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder'

# Empty the trash on all mounted volumes and the main HDD
alias emptytrash='sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* "delete from LSQuarantineEvent"'

# Upgrade `Homebrew` packages
alias brewupdate='brew update && brew upgrade && brew upgrade --cask --greedy && brew cleanup'

# Get macOS software update
alias sysupdate='sudo softwareupdate -i -a'
