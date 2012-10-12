# ========================================================================
# ZSH conf specific to plow (personal server) environment
# ========================================================================

# location where all scm-backed repos live
export PROJECTS_HOME=$HOME/projects

# for various apps like vim to display correctly
export LANG=en_US.UTF-8

# ------------------------------------------------------------------------
# Virtualenv
# ------------------------------------------------------------------------

export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
export VIRTUALENVWRAPPER_LOG_DIR=$WORKON_HOME
export VIRTUALENVWRAPPER_HOOK_DIR=$WORKON_HOME
source /usr/local/bin/virtualenvwrapper.sh

# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

alias cpumine='$PROJECTS_HOME/cpumine/minerd -t 2 --url http://btcmine.com:8332 --userpass eculver@plow:reallyreallyawesomepassword'
alias gpumine='$PROJECTS_HOME/poclbm/poclbm.py -d 0 -w 64 -a 5 -f 60 -u eculver@plow --pass reallyreallyawesomepassword -o btcmine.com -p 8332'


# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------
