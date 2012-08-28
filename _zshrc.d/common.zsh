# ========================================================================
# ZSH conf common to all environments
# ========================================================================


# vi key bindings
bindkey -v


# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

# force tmux to use UTF-8 and 256 colors
alias tmux='tmux -u -2'

# services
alias start-memcached='memcached -m 64 -p 11211 -u `whoami` -l 127.0.0.1'
alias start-ssh-agent='eval `ssh-agent`; ssh-add ~/.ssh/id_rsa ; ssh-add -l'

# find/grep magic
alias rmdotunder='find . -type f -name "._*" -exec rm -f {} \; -print'
alias exclude-svn='grep -v "/\.svn/"'
alias svnst='rmdotunder&&svn st'

# just handy
alias tsnow='date +%Y%m%d%H%M%S'
