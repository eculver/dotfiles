# ========================================================================
# ZSH conf specific to local environment
# ========================================================================

# ------------------------------------------------------------------------
# Virtualenv
# ------------------------------------------------------------------------

export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/Cellar/python/2.7.1/bin/python
export VIRTUALENVWRAPPER_LOG_DIR=$WORKON_HOME
export VIRTUALENVWRAPPER_HOOK_DIR=$WORKON_HOME
source /usr/local/bin/virtualenvwrapper.sh


# ------------------------------------------------------------------------
# Postgres (Mac)
# ------------------------------------------------------------------------

export PGHOST=/tmp


# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

alias wdapp='ssh -t evan tmux -u -2 at -t app'
alias wdirc='ssh -t evan tmux -u -2 at -t irc'
alias wddocs='ssh -t evan tmux -u -2 at -t apidocs'
alias wdapi='ssh -t evan tmux -u -2 at -t api'
alias wddata='ssh -t evan tmux -u -2 at -t data'
alias mdr='ssh -t mdr tmux -u -2 att'
alias irc='ssh -t leeroy tmux -u -2 at -t irc'
alias dio='ssh -t leeroy tmux -u -2 at -t base'

# WD-related
alias update_sprite='scp /Volumes/Work\ Drive/Development/Graphic\ Library/Icon\ sprite/icon_sprite.png evan:~/projects/wd-legacy/resource/wd/web/theme/default/assets/'

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
alias gototb='mux start totb'
alias godio='mux start dio'
alias goeio='mux start eio'
alias gojute='cd ~/dev/JUTE/backend/nodejute'
alias godpp='mux start dpp'
alias gotamoshunas='mux tamoshunas'
alias goculvers='mux start culvers'
alias gocompcard='mux start compcard'
alias gobnj='mux staet bnj'
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

# aliases for executables that aren't in $PATH
alias espresso='/Users/evanculver/Downloads/The-M-Project_v1.0.0/Espresso/bin/espresso.js'


# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------

# kill all django runserver instances
killmanage(){
    ps -ef | grep "manage\.py runserver" | awk '{print $2}' | xargs kill -9
}
