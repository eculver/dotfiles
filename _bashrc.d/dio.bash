# ========================================================================
# Bash conf specific to DIO environment
# ========================================================================

# Virtual env
export WORKON_HOME=/usr/local/dio/.virtualenvs

# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

# show versions marked for upgrade
alias pkg_upgrade='sudo apt-get -uV upgrade'

# tail all app's uwsgi logs
alias tailall='sudo tail -n400 -f /var/log/uwsgi/app/*.log'


# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------

# tail an app's uwsgi log
tailapp(){
    sudo tail -n400 -f /var/log/uwsgi/app/$1.log
}

# cd to an app's project home directory
goapp(){
    cd /usr/local/dio/$1
}
