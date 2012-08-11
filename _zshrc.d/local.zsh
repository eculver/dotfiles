# ========================================================================
# ZSH conf specific to local environment
# ========================================================================


# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

alias wdvim='ssh -t evan tmux -u -2 at -t vim'
alias wdirc='ssh -t evan tmux -u -2 at -t irc'
alias irc='ssh -t leeroy tmux -u -2 at -t irc'

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
alias mdr='nocorrect mdr'
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
