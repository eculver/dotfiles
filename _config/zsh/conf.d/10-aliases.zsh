# Common aliases for interactive shells

# ------------------------------------------------------------------------
# Terminal & Tools
# ------------------------------------------------------------------------

# force tmux to use UTF-8 and 256 colors
alias tmux='tmux -u -2'

# tmuxinator
alias mux='tmuxinator'

# use GNU gawk extension in place of awk
alias awk='gawk'

# use NeoVIM instead of vim
alias vim='nvim'

# ------------------------------------------------------------------------
# Services
# ------------------------------------------------------------------------

alias memcached-stat='echo stats | nc 127.0.0.1 11211'
alias start-memcached='memcached -m 64 -p 11211 -u `whoami` -l 127.0.0.1'
alias start-ssh-agent='eval `ssh-agent`; ssh-add ~/.ssh/id_(rsa|ed25519) ; ssh-add -l'
alias start-ssh-agent-apple='eval `ssh-agent`; ssh-add --apple-load-keychain'

# ------------------------------------------------------------------------
# Find/Grep Magic
# ------------------------------------------------------------------------

alias rmdotunder='find . -type f -name "._*" -exec rm -f {} \; -print'
alias exclude-svn='grep -v "/\.svn/"'
alias svnst='rmdotunder&&svn st'

# ------------------------------------------------------------------------
# Handy Date Formatters
# ------------------------------------------------------------------------

# (ms) means "in milliseconds"
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

# ------------------------------------------------------------------------
# Convenience
# ------------------------------------------------------------------------

alias confdir='cd $ZDOTDIR'

alias uuidgen='/usr/bin/uuidgen | tr "[:upper:]" "[:lower:]"'

# ------------------------------------------------------------------------
# Development (generic, move project-specific ones to local.d/)
# ------------------------------------------------------------------------

alias dbshell='./manage.py dbshell'
alias shell='./manage.py shell_plus'
alias buildr='watchr static.watchr'

# ------------------------------------------------------------------------
# Cassandra Helpers
# ------------------------------------------------------------------------

alias ifup-cassandra='for i in {2..10}; do sudo ifconfig lo0 alias 127.0.0.$i up; done'
