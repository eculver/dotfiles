# ========================================================================
# Bash conf common to all environments
# ========================================================================


# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

# force tmux to use UTF-8 and 256 colors
alias tmux='tmux -u -2'

# ssh agent forwarding made easy
alias start-ssh-agent='eval `ssh-agent`; ssh-add ~/.ssh/id_rsa ; ssh-add -l'

# just handy
alias tsnow='date +%Y%m%d%H%M%S'