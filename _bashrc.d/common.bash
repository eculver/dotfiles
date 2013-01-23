# ========================================================================
# Bash conf common to all environments
# ========================================================================

# Add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin

# Load RVM function
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Load Tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# Virtualenv wrapper functions
source /usr/local/bin/virtualenvwrapper.sh


# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

# force tmux to use UTF-8 and 256 colors
alias tmux='tmux -u -2'

# ssh agent forwarding made easy
alias memcached-stat='echo stats | nc 127.0.0.1 11211'
alias start-memcached='memcached -m 64 -p 11211 -u `whoami` -l 127.0.0.1'
alias start-ssh-agent='eval `ssh-agent`; ssh-add ~/.ssh/id_rsa ; ssh-add -l'
alias runserver='./manage.py runserver 0.0.0.0:8000'

# just handy
alias tsnow='date +%Y%m%d%H%M%S'
