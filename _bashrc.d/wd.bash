# ========================================================================
# Bash conf specific to WD environment
# ========================================================================

# Virtual env
export WORKON_HOME=~/.virtualenvs

# Dev environment variables
export WEB_ENV='dev'
export AUTH_ENV='dev'

# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

alias atlassian='ssh -t atlassian tmux at -t base'
alias buildconf='time ~/projects/wd-legacy/bin/build-config local'
alias buildwd='time ~/projects/wd-legacy/bin/build-resources -v'
alias buildrt='time ~/projects/wd-legacy/bin/build-resource-tree'

# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------
