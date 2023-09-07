#!/usr/local/bin/zsh

# ========================================================================
# ZSH conf specific to local/laptop environment
# ========================================================================

# For building CPython libraries
export LIBRARY_PATH=/usr/local/lib

# For building things that depend on readline
export LDFLAGS=-L/usr/local/opt/readline/lib
export CPPFLAGS=-I/usr/local/opt/readline/include

# For JABA (sic)
export JAVA_HOME=$(/usr/libexec/java_home)

# For Go when not using GVM
export GOPATH=$HOME/dev
export PATH=$GOPATH/bin:$PATH

# Add Cmake to PATH
export CMAKE_HOME=/Applications/CMake.app/Contents
[[ -s "$CMAKE_HOME" ]] && export PATH="$CMAKE_HOME/bin":"$PATH"

# Set SSH_AUTH_SOCK rather than a randomly generated one, for shells to share an agent
export SSH_AUTH_SOCK=$HOME/.ssh/ssh-agent.$HOSTNAME.sock

# 1password completions
eval "$(op completion zsh)"; compdef _op op

# 1password plugins
export OP_PLUGINS_FILE=$XDG_CONFIG_HOME/op/plugins.sh
[[ -f $OP_PLUGINS_FILE ]] && source $OP_PLUGINS_FILE


# -------------------------------------------------------------------------
# Secrets -- these are 1password references that are meant to be used with
# `op run` to be injected at runtime
# -------------------------------------------------------------------------

export OPENAI_APIKEY="op://Private/OpenAI/api key"


# -------------------------------------------------------------------------
# ssh-agent - ensure running and identities are loaded
# -------------------------------------------------------------------------


# ------------------------------------------------------------------------
# fasd
# ------------------------------------------------------------------------

fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache


# ------------------------------------------------------------------------
# fzf
# ------------------------------------------------------------------------

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh


# ------------------------------------------------------------------------
# Python
# ------------------------------------------------------------------------

[[ -s "$HOME/.pythonrc.py" ]] && export PYTHONSTARTUP=$HOME/.pythonrc.py


# ------------------------------------------------------------------------
# Virtualenv
# ------------------------------------------------------------------------

export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
export VIRTUALENVWRAPPER_LOG_DIR=$WORKON_HOME
export VIRTUALENVWRAPPER_HOOK_DIR=$WORKON_HOME


# ------------------------------------------------------------------------
# NVM - lazy loading of .nvmrc loading
# note: this overrides the other lazy-loading of NVM which is why it's
# deferred by a function call
# ------------------------------------------------------------------------

# this will trigger an `nvm use` when entering a directory with an .nvmrc
function nvm-load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}


# ------------------------------------------------------------------------
# chruby (greedy for Vim)
# ------------------------------------------------------------------------

export CHRUBY_HOME=/usr/local/share/chruby
if [ -s "$CHRUBY_HOME" ]; then
    local latest_ruby
    source "$CHRUBY_HOME/chruby.sh"
    source "$CHRUBY_HOME/auto.sh"
    [[ -f $HOME/.rbenv/versions ]] && RUBIES+=($HOME/.rbenv/versions/*)
    chruby "ruby-$(find "$HOME/.rubies" -maxdepth 1 -name 'ruby-*' | tail -n1 | egrep -o '\d+\.\d+\.\d+')"
fi


# ------------------------------------------------------------------------
# Arkade
# ------------------------------------------------------------------------

export PATH=$HOME/.arkade/bin/:$PATH


# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------

# vim == neovim
alias vim='nvim'

alias mdr='ssh -t mdr tmux -u -2 att'
alias nero='ssh -t nero tmux -u -2 at -t base'
alias irc='ssh -t nero tmux -u -2 at -t irc'
alias dio='ssh -t util1.ca tmux -u -2 at -t base'

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
alias util01-linode='ssh -t util01-linode tmux -u -2 at -t base'

# Kubernetes
alias kc=kubectl
alias kctx=kubectx
alias kns=kubens
alias ktail=kubetail
# dump all resources
alias kc-dump-all='for i in $(kc api-resources | tail -n +2 | cut -f 1 -d ' ') ; do kc get $i -A ; done'

# kubectl completions
# source <(kubectl completion zsh)
# complete -F __start_kubectl kc

# switch to my Go "playground" repo
alias goplay='goto eculver/go-play'

# turn off correction for these
alias npm='nocorrect npm'
alias ack='nocorrect ack'
alias cap='nocorrect cap'
alias grb='nocorrect grb'
alias evan='nocorrect evan'
alias task='nocorrect task'
alias pwgen='nocorrect pwgen'
alias leeroy='nocorrect leeroy'

# cURL via Tor
alias torcurl='curl --socks4a localhost:9150'

# fasd
alias v='f -e vim' # quick opening files with vim


# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------

# start SSH agent if it's not running
function ensure-ssh-agent() {
    # if not running, start it
    if  ! pgrep -x "ssh-agent" > /dev/null; then
        # make sure there isn't a sock file left around
        if [[ -f $SSH_AUTH_SOCK ]]; then
            rm $SSH_AUTH_SOCK
        fi
        echo "Starting ssh-agent"
        eval `ssh-agent -a $SSH_AUTH_SOCK`
    fi

    ssh-add -l > /dev/null 2>&1

    # running but no identities, add them
    if [ $? -eq 1 ]; then
        echo "Adding SSH identities from Keychain"
        ssh-add --apple-load-keychain
    fi

    # Our SSH_AUTH_SOCK is probably messed up, cleanup and be done
    if [[ $? -eq 2 ]]; then
        echo "Could not list identities for sock at $SSH_AUTH_SOCK, killing existing processes and bailing. Try starting agent manually with start-ssh-agent-apple"
        pkill "ssh-agent"
    fi
}

# reminder of how I setup WeeChat to work with Matrix
function weechat-matrix-install() {
    echo "git clone git@github.com:torhve/weechat-matrix-protocol-script ~/src/weechat-matrix-protocol-script"
    echo "mkdir ~/.weechat/lua"
    echo "ln -s ~/src/weechat-matrix-protocol-script/matrix.lua ~/.weechat/lua/matrix.lua"
    echo "ln -s ~/.weechat/lua/matrix.lua ~/.weechat/lua/autoload"

    echo "then, to install lua deps..."
    echo "sudo luarocks install lua-cjson"

    echo "then fire up weechat"
    echo "weechat"
    echo "/lua load matrix.lua"
    echo "/set plugins.var.lua.matrix.user @eculver:matrix.org"
    echo "/set plugins.var.lua.matrix.password ******"
    echo "/matrix connect"
    echo "/join #<remote address>"
}

# cleanup all exited and dangling docker images
function docker_rm_dead_images() {
    docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
    docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

# cleanup all docker resources except built images
function docker_rm_dead_resources() {
    docker ps -a --format "{{.ID}}" | xargs docker stop
    docker ps -a --format "{{.ID}}" | xargs docker rm
    docker volume ls --format "{{.Name}}" | xargs docker volume rm
    docker network prune -f
}
