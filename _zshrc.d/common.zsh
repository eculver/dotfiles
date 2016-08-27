# ========================================================================
# ZSH conf common to all environments
# ========================================================================


# ------------------------------------------------------------------------
# Key bindings
# ------------------------------------------------------------------------

# vi key bindings
bindkey -v

# make reverse search work as though we're in emacs mode
# bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward


# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

# force tmux to use UTF-8 and 256 colors
alias tmux='tmux -u -2'

# tmuxinator
alias mux='tmuxinator'

# use GNU gawk extension in place of awk
alias awk='gawk'

# services
alias memcached-stat='echo stats | nc 127.0.0.1 11211'
alias start-memcached='memcached -m 64 -p 11211 -u `whoami` -l 127.0.0.1'
alias start-ssh-agent='eval `ssh-agent`; ssh-add ~/.ssh/id_rsa ; ssh-add -l'

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

# dev
alias dbshell='./manage.py dbshell'
alias shell='./manage.py shell_plus'
alias buildr='watchr static.watchr'

# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------

zle-line-init () {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}

zle-keymap-select () {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}

# ZSH Line Editor selections
zle -N zle-line-init
zle -N zle-keymap-select

# django devserver helper
# `devserver <port>` - defaults to 8000
# devserver () {
    # port=8000
    # if  (( $# > 0 )); then
        # port=$1;
    # fi

    # if [[ -e manage.py ]] then
        # ./manage.py runserver 0.0.0.0:$port
    # else
        # echo "No manage.py found in current directory. Change to project home first."
    # fi
# }

# generate a random character string
random () {
    len=32
    if (( $# > 0 )) then
        len=$1;
    fi

    python -c "import md5; from datetime import datetime; print md5.new(datetime.now().strftime(\"%s\")).hexdigest()[:$len]"
}

# get pids listening on a specific port
port-pids () {
  local port=$1
  [ "$port" == "" ] && echo "usage: port-pids <port>" && return
  lsof -n -i4TCP:$port | grep LISTEN
}

portsopen () {
  local port=$1
  sudo netstat -plant --extend | grep $port | grep EST
}


# ------------------------------------------------------------------------
# C* Helpers
# ------------------------------------------------------------------------

alias ifup-cassandra='for i in {2..10}; do sudo ifconfig lo0 alias 127.0.0.$i up; done'

function jc {
    host=$1
    proxy_port=${2:-9999}
    jconsole_host=localhost
    ssh -f -D$proxy_port $host 'while true; do sleep 1; done'
    ssh_pid=$(ps ax | grep "[s]sh -f -D$proxy_port" | awk '{print $1}')
    jconsole -J-DsocksProxyHost=localhost -J-DsocksProxyPort=$proxy_port service:jmx:rmi:///jndi/rmi://${jconsole_host}:8181/jmxrmi
    kill $ssh_pid
}

cassie-keyspaces () {
    for cf in $(ccm node1 nodetool cfstats | grep Keyspace | grep -v system | cut -d ' ' -f2); do echo $cf; done
}

cassie-tables () {
    cfs=$(cassie-keyspaces)
    for cf in $cfs; do
        for t in $(ccm node1 nodetool cfstats $cf | grep -E 'Table:' | cut -d ' ' -f2); do
            echo "$cf.$t"
        done
    done
}
