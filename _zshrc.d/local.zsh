# ========================================================================
# ZSH conf specific to local environment
# ========================================================================

# rbenv
export RBENV_ROOT=$HOME/.rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Add rbenv to PATH for scripting
PATH=$PATH:$RBENV_ROOT/bin

# And enable rbenv shims, completion and local gems
eval "$(rbenv init -)"
eval "$(rbenv usergems-init -)"

# Load Tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# Load Resty
source /usr/local/bin/resty

# ------------------------------------------------------------------------
# Z
# ------------------------------------------------------------------------

source-if-exists $HOME/devel/z/z.sh


# ------------------------------------------------------------------------
# Virtualenv
# ------------------------------------------------------------------------

export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/Cellar/python/2.7.6_1/bin/python
export VIRTUALENVWRAPPER_LOG_DIR=$WORKON_HOME
export VIRTUALENVWRAPPER_HOOK_DIR=$WORKON_HOME
source /usr/local/bin/virtualenvwrapper.sh


# ------------------------------------------------------------------------
# NVM
# ------------------------------------------------------------------------

[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"
#NVM_SOURCE=
#NVM_DIR=
#NVM_PROFILE=

# ------------------------------------------------------------------------
# GVM
# ------------------------------------------------------------------------
#
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# ------------------------------------------------------------------------
# Postgres (Mac)
# ------------------------------------------------------------------------

export PGHOST=/tmp
export PATH="/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH"


# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

alias mdr='ssh -t mdr tmux -u -2 att'
alias nero='ssh -t nero tmux -u -2 at -t base'
alias irc='ssh -t nero tmux -u -2 at -t irc'
alias dio='ssh -t util1.ca tmux -u -2 at -t base'

# home
alias plow='ssh -t plow tmux -u -2 at -t base'
alias plow.miner='ssh -t plow tmux -u -2 at -t miner'
alias plow.remote='ssh -t plow.remote tmux -u -2 at -t base'
alias plow.remote.miner='ssh -t plow.remote tmux -u -2 at -t miner'
alias miner='ssh -t miner tmux -u -2 at -t miner'
alias miner.remote='ssh -t miner.remote tmux -u -2 at -t miner'
alias miner2='ssh -t miner2 tmux -u -2 at -t miner'
alias miner2.remote='ssh -t miner2.remote tmux -u -2 at -t miner'

# d.io Linode hosts
alias app1.ca='ssh -t app1.ca tmux -u -2 at -t base'
alias db1.ca='ssh -t db1.ca tmux -u -2 at -t base'
alias util1.ca='ssh -t util1.ca tmux -u -2 at -t base'

# tmuxinator/project aliases
alias gousc='mux start usc'
alias goufogrid='mux start ufogrid'
alias godio='mux start dio'
alias goeio='mux start eio'
alias goculvers='mux start culvers'
alias golsm='mux start lsm'
alias gotdt='mux start tdt'

# turn off correction for these
alias npm='nocorrect npm'
alias ack='nocorrect ack'
alias cap='nocorrect cap'
alias grb='nocorrect grb'
alias evan='nocorrect evan'
alias task='nocorrect task'
alias pwgen='nocorrect pwgen'
alias leeroy='nocorrect leeroy'

# bower: noglob
alias bower='noglob bower'

# aliases for executables that aren't in $PATH
alias espresso='/Users/evanculver/Downloads/The-M-Project_v1.0.0/Espresso/bin/espresso.js'

# cURL via Tor
alias torcurl='curl --socks4a localhost:9150'

# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------

# kill all django runserver instances
killmanage(){
    ps -ef | grep "manage\.py runserver" | awk '{print $2}' | xargs kill -9
}

beepwhenup () { echo 'Enter host you want to ping:'; read PHOST; if [[ "$PHOST" == "" ]]; then exit; fi; while true; do ping -c1 -W2 $PHOST 2>&1 >/dev/null; if [[ "$?" == "0" ]]; then for j in $(seq 1 4); do beep; done; ping -c1 $PHOST; break; fi; done; }


# ------------------------------------------------------------------------
# Completions
# ------------------------------------------------------------------------

