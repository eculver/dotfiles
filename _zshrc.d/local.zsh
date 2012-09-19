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
# Aliases
# ------------------------------------------------------------------------

alias wdvim='ssh -t evan tmux -u -2 at -t vim'
alias wdirc='ssh -t evan tmux -u -2 at -t irc'
alias mdr='ssh -t mdr tmux -u -2 att'
alias irc='ssh -t leeroy tmux -u -2 at -t irc'
alias dio='ssh -t leeroy tmux -u -2 at -t base'

# d.io Linode hosts
alias app1.ca='ssh -t app1.ca tmux -u -2 at -t base'
alias db1.ca='ssh -t db1.ca tmux -u -2 at -t base'

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

function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
