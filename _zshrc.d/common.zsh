# ========================================================================
# ZSH conf common to all environments
# ========================================================================


# ------------------------------------------------------------------------
# Key bindings
# ------------------------------------------------------------------------

# vi key bindings
bindkey -v

# make reverse search work as though we're in emacs mode
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward


# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

# force tmux to use UTF-8 and 256 colors
alias tmux='tmux -u -2'

# services
alias memcached-stat='echo stats | nc 127.0.0.1 11211'
alias start-memcached='memcached -m 64 -p 11211 -u `whoami` -l 127.0.0.1'
alias start-ssh-agent='eval `ssh-agent`; ssh-add ~/.ssh/id_rsa ; ssh-add -l'

# find/grep magic
alias rmdotunder='find . -type f -name "._*" -exec rm -f {} \; -print'
alias exclude-svn='grep -v "/\.svn/"'
alias svnst='rmdotunder&&svn st'

# just handy
alias tsnow='date +%Y%m%d%H%M%S'

# dev
alias dbshell='./manage.py dbshell'
alias shell='./manage.py shell_plus'
alias buildr='watchr static.watchr'

# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------

function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}

# ZSH Line Editor selections
zle -N zle-line-init
zle -N zle-keymap-select


# django devserver helper
# `devserver <port>` - defaults to 8000
devserver () {
    port=8000
    if  (( $# > 0 )) then
        port=$1;
    fi

    if [[ -e manage.py ]] then
        ./manage.py runserver 0.0.0.0:$port
    else
        echo "No manage.py found in current directory. Change to project home first."
    fi
}

# generate a random character string
random () {
    len=32
    if (( $# > 0 )) then
        len=$1;
    fi

    python -c "import md5; from datetime import datetime; print md5.new(datetime.now().strftime(\"%s\")).hexdigest()[:$len]"
}
