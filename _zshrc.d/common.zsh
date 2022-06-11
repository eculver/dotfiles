# ========================================================================
# ZSH conf common to all environments
# ========================================================================

# ------------------------------------------------------------------------
# VIM!
# ------------------------------------------------------------------------

export EDITOR='nvim'

# ------------------------------------------------------------------------
# Key bindings
# ------------------------------------------------------------------------

# vi key bindings
bindkey -v

# make reverse search work as though we're in emacs mode
# bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward

# make CTRL+SPACE accept completion
bindkey '^ ' autosuggest-accept

# ------------------------------------------------------------------------
# Formatting Escape Sequences
# ------------------------------------------------------------------------

autoload colors
if [[ "$terminfo[colors]" -gt 8 ]]; then
    colors
fi
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
    eval $COLOR='$fg_no_bold[${(L)COLOR}]'
    eval BOLD_$COLOR='$fg_bold[${(L)COLOR}]'
done
eval RESET='$reset_color'


# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

# force tmux to use UTF-8 and 256 colors
alias tmux='tmux -u -2'

# tmuxinator
alias mux='tmuxinator'

# use GNU gawk extension in place of awk
alias awk='gawk'

# use NeoVIM instead of vim
alias vim='nvim'

# services
alias memcached-stat='echo stats | nc 127.0.0.1 11211'
alias start-memcached='memcached -m 64 -p 11211 -u `whoami` -l 127.0.0.1'
alias start-ssh-agent='eval `ssh-agent`; ssh-add ~/.ssh/id_rsa ; ssh-add -l'
alias start-ssh-agent-apple='eval `ssh-agent`; ssh-add --apple-load-keychain'

# find/grep magic
alias rmdotunder='find . -type f -name "._*" -exec rm -f {} \; -print'
alias exclude-svn='grep -v "/\.svn/"'
alias svnst='rmdotunder&&svn st'

# handy date formatters -- (ms) means "in milliseconds"
alias tsnow='date +%Y%m%d%H%M%S'
alias tsnowutc='date -u +%Y%m%d%H%M%S'

alias today='date +%Y%m%d'
alias todayutc='date -u +%Y%m%d'

alias epochnow='date +%s'       # epoch for local tz
alias epochnowms='date +%s000'  # epoch (ms) for local tz

alias epochnowutc='date -u +%s'      # epoch UTC
alias epochnowutcms='date -u +%s000' # epoch (ms) UTC

alias epochtoday='date -j -f "%Y%m%d%H%M%S" "`today`000000" +%s'      # epoch for today at 00:00:00 local tz
alias epochtodayms='date -j -f "%Y%m%d%H%M%S" "`today`000000" +%s000' # epoch (ms) for today at 00:00:00 local tz

alias epochtodayutc='date -u -j -f "%Y%m%d%H%M%S" "`todayutc`000000" +%s'      # epoch for today at 00:00:00 UTC
alias epochtodayutcms='date -u -j -f "%Y%m%d%H%M%S" "`todayutc`000000" +%s000' # epoch (ms) for today at 00:00:00 UTC

alias confdir='cd $CONFDIR'

alias uuidgen='/usr/bin/uuidgen | tr "[:upper:]" "[:lower:]"'

# dev
alias dbshell='./manage.py dbshell'
alias shell='./manage.py shell_plus'
alias buildr='watchr static.watchr'


# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------

source $HOME/.zshrc.d/utils.zsh

# TODO: move these to utils.zsh

zle-line-init() {
    RPS1="${${KEYMAP/vicmd/N}/(main|viins)/ }"
    RPS2=$RPS1
    zle reset-prompt
}

zle-keymap-select() {
    RPS1="${${KEYMAP/vicmd/N}/(main|viins)/ }"
    RPS2=$RPS1
    zle reset-prompt
}

# ZSH Line Editor selections
zle -N zle-line-init
zle -N zle-keymap-select

# generate a random character string
random() {
    len=32
    if (( $# > 0 )) then
        len=$1;
    fi

    python -c "import md5; from datetime import datetime; print md5.new(datetime.now().strftime(\"%s\")).hexdigest()[:$len]"
}

# get pids listening on a specific port
port-pids() {
  local port=$1
  [ "$port" == "" ] && echo "usage: port-pids <port>" && return
  lsof -n -i4TCP:$port | grep LISTEN
}

portsopen() {
  local port=$1
  sudo netstat -plant --extend | grep $port | grep EST
}

# helper for doing a string join on all args
function join { local IFS="$1"; shift; echo "$*"; }

# convert integers to ip address strings
int2ip() {
    num="$1"
    [[ -z "${num}" ]] && echo "usage: int2ip <integer>" && return
    (( pt1 = ($num & 255) ))
    (( pt2 = (($num >> 8) & 255) ))
    (( pt3 = (($num >> 16) & 255) ))
    (( pt4 = (($num >> 24) & 255) ))
    echo "${pt4}.${pt3}.${pt2}.${pt1}";
}

# convert base64 encoded UUIDs to valid UUID strings
b64uuid() {
    encoded="$1"
    [[ -z "${encoded}" ]] && echo "usage: base64uuid <b64string>" && return
    echo "${encoded}" | base64 -D | od -t x1 | cut -d ' ' -f2- | head -n1 | awk '{print $1$2$3$4"-"$5$6"-"$7$8"-"$9$10"-"$11$12$13$14$15$16}'
}

# convert an .rtf file to .txt and remove common, non-web-friendly characters along the way
rtf2txt() {
    f="$1"
    [[ -z "${f}" ]] && echo "usage: rtf2txt <filename>" && return

    # convert to plaintext, write to tmpfs
    ftmp="/tmp/.rtf2txt.$(tsnow).txt"
    textutil -convert txt -output "${ftmp}" "${f}"
    [[ $? -ne "0" ]] && echo "could not convert ${f} to plain-text" && return

    # .txt filename, use same basename
    dname="$(dirname ${f})"
    fname="${dname}/$(cut -d "." -f1 <<< $(basename ${f})).txt"

    # replace junk chars
    cat "${ftmp}" | sed "s/’/'/g" | sed "s/‘/'/g" | sed 's/”/"/g' | sed 's/“/"/g' | sed 's/-/-/g' | sed 's/•//g' > "${fname}"
    rm "${ftmp}"
    echo "Wrote ${fname}"
}

# validate YAML
validate-yaml() {
    local p=$1
    ruby -e "require 'yaml';puts YAML.load_file('${p}')" > /dev/null 2>&1; [[ $? -eq 0 ]] && echo "valid" || echo "not valid"
}

# ------------------------------------------------------------------------
# Git Helpers
# ------------------------------------------------------------------------

gitco() {
    local branch="$1"
    if [ -z "${branch}" ]; then
        echo "gitco: checkout a branch and set upstream to origin/master"
        echo
        echo "usage: gitco <branch>"
        return
    fi
    git checkout -b "${branch}" origin/master
}


# ------------------------------------------------------------------------
# C* Helpers
# ------------------------------------------------------------------------

alias ifup-cassandra='for i in {2..10}; do sudo ifconfig lo0 alias 127.0.0.$i up; done'

jc() {
    host=$1
    proxy_port=${2:-9999}
    jconsole_host=localhost
    ssh -f -D$proxy_port $host 'while true; do sleep 1; done'
    ssh_pid=$(ps ax | grep "[s]sh -f -D$proxy_port" | awk '{print $1}')
    jconsole -J-DsocksProxyHost=localhost -J-DsocksProxyPort=$proxy_port service:jmx:rmi:///jndi/rmi://${jconsole_host}:8181/jmxrmi
    kill $ssh_pid
}

cassie-keyspaces() {
    for cf in $(ccm node1 nodetool cfstats | grep Keyspace | grep -v system | cut -d ' ' -f2); do echo $cf; done
}

cassie-tables() {
    cfs=$(cassie-keyspaces)
    for cf in $cfs; do
        for t in $(ccm node1 nodetool cfstats $cf | grep -E 'Table:' | cut -d ' ' -f2); do
            echo "$cf.$t"
        done
    done
}

_join() {
    local IFS=$1
    shift
    echo "${*}"
}
