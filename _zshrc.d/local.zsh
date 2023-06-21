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
# not running so start it
if ! pgrep -x "ssh-agent" > /dev/null; then
  echo "Starting ssh-agent"
  eval `ssh-agent -a $SSH_AUTH_SOCK`
fi

ssh-add -l > /dev/null 2>&1
# running but no identities, add them
if [ $? -ge 1 ]; then
  ssh-add --apple-load-keychain
fi

# ------------------------------------------------------------------------
# fasd
# ------------------------------------------------------------------------

fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  echo "fasd cache..."
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
# NVM (lazy)
# ------------------------------------------------------------------------

nvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

  # initialze autoloading,
  autoload -U add-zsh-hook
  add-zsh-hook chpwd nvm-load-nvmrc

  nvm ${@:2}
}

# this will trigger an `nvm use` when entering a directory with an .nvmrc
nvm-load-nvmrc() {
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
    RUBIES+=($HOME/.rbenv/versions/*)
    chruby "ruby-$(find "$HOME/.rubies" -maxdepth 1 -name 'ruby-*' | tail -n1 | egrep -o '\d+\.\d+\.\d+')"
fi


# ------------------------------------------------------------------------
# Tmuxinator
# ------------------------------------------------------------------------

[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
[[ -s $HOME/.tmuxinator/completion ]] && source $HOME/.tmuxinator/completion/tmuxinator.zsh


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

# tmuxinator/project aliases
alias gousc='mux start usc'
alias goufogrid='mux start ufogrid'
alias godio='mux start dio'
alias goeio='mux start eio'
alias goculvers='mux start culvers'
alias golsm='mux start lsm'
alias gotdt='mux start tdt'

# Lazy-use $GOVERSION
_gvm_use() {
    [[ -z "$gvm_go_name" ]] && gvm use $GOVERSION 2>&1 > /dev/null
}

# Golang + Github projects
# TODO(idiot): make better
gogods() {
    _gvm_use
    gvm pkgset use gods
    cd $GOPATH/src/github.com/emirpasic/gods || return
}

goplay() {
    # _gvm_use
    # gvm pkgset use play
    # export GOPATH=$GVM_ROOT/pkgsets/go$GOVERSION/play
    # cd $HOME/src/go-play

    export GOPATH=$HOME/sync/src/gocode
    cd $GOPATH/src/github.com/eculver/go-play
}

# turn off correction for these
alias npm='nocorrect npm'
alias ack='nocorrect ack'
alias cap='nocorrect cap'
alias grb='nocorrect grb'
alias evan='nocorrect evan'
alias task='nocorrect task'
alias pwgen='nocorrect pwgen'
alias leeroy='nocorrect leeroy'

# bower: noglob
alias bower='noglob bower'

# aliases for executables that aren't in $PATH
alias espresso='/Users/evanculver/Downloads/The-M-Project_v1.0.0/Espresso/bin/espresso.js'

# cURL via Tor
alias torcurl='curl --socks4a localhost:9150'

# fasd
alias v='f -e vim' # quick opening files with vim

# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------

# kill all django runserver instances
killmanage(){
    ps -ef | grep "manage\.py runserver" | awk '{print $2}' | xargs kill -9
}

# reminder of how I setup WeeChat to work with Matrix
weechat-matrix-install () {
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

# migrate project to different version of Go, works both ways
gvmmigrate() {
    local usage='usage: gvmmigrate <pkg> <current_version> <new_version> [pkgset]'
    local example='gvm migrate go.uber.org/dosa go1.7.1 go1.7.4 dosa2'

    local pkg=$1
    [[ -z "$pkg" ]] && echo "${usage}" && return

    local current_version=$2
    [[ -z "$current_version" ]] && echo "${usage}" && return

    local new_version=$3
    [[ -z "$new_version" ]] && echo "${usage}" && return

    local pkgset=$4
    [[ -z "$pkgset" ]] && pkgset=$(echo "${pkg%\.git}" | rev | cut -d '/' -f1 | rev)

    local current_home="${GVM_ROOT}/pkgsets/${current_version}/${pkgset}"
    local new_home="${GVM_ROOT}/pkgsets/${new_version}/${pkgset}"

    # debug
    echo "pkg: ${pkg}"
    echo "current_version: ${current_version}"
    echo "new_version: ${new_version}"
    echo "pkgset: ${pkgset}"
    echo "current_home: ${current_home}"
    echo "new_home: ${new_home}"

    # validate package exists where it should
    if [ ! -d  "${current_home}" ]; then
        echo "${RED}[ERROR]${RESET} Could not find existing project at ${current_home}"
        return
    fi

    # remove symlink if exists
    if [ -h "$UBER_HOME/${pkgset}" ]; then
        echo "${GREEN}[INFO]${RESET} Found symlink at $UBER_HOME/${pkgset}, removing"
        rm "$UBER_HOME/${pkgset}"
    fi

    # install new version if not exists
    if [ ! $(gvm listall | grep "${new_version}") ]; then
        echo "${RED}[ERROR]${RESET} ${new_version} is not a valid go version. Try \`gvm listall\` for a list of valid versions"
        return
    fi

    if [ ! -d "$GVM_ROOT/pkgsets/${new_version}" ]; then
        echo "${RED}[ERROR]${RESET} ${new_version} is not installed. Installing now..."
        if ! gvm install "${new_version}"; then
            echo "${RED}[ERROR]${RESET} Install failed"
            return
        fi
    fi

    export GOVERSION=${new_version#go}

    # switch to new version
    gvm use "${new_version}" || (echo "${RED}[ERROR]${RESET} Could not use new version ${new_version}" && return)

    # create new pkgset
    gvm pkgset create "${pkgset}" || (echo "${RED}[ERROR]${RESET} Could not create new pkgset ${pkgset}" && return)

    # setup new pkgset
    # echo "go-use ${pkgset}"
    go-use "${pkgset}"

    # echo "mkdir -p ${new_home}/src"
    mkdir -p "${new_home}/src"

    # echo "mv ${current_home}/src/* ${new_home}/src/"
    mv ${current_home}/src/* ${new_home}/src/

    echo "${GREEN}[INFO]${RESET} Successfully moved all source code in ${current_home}/src to ${new_home}/src"

    if [ -d "$current_home/bin" ] && [ $(ls "${current_home}/bin" | wc -l) -gt "0" ]; then
        echo "${WHITE}[INFO]${RESET} These binaries will need to be re-built using ${new_version}:"
        ls -l "${current_home}/bin"
    fi

    local create_symlink
    echo -n "${BOLD_WHITE}Create ${pkgset} symlink in $UBER_HOME? (Y/n) ${RESET}"
    read -r create_symlink
    if [ "${create_symlink}" == "Y" ]; then
        ln -s "${new_home}/src/${pkg}" "$UBER_HOME/${pkgset}"
        echo "${GREEN}[INFO]${RESET} Created symlink"
    fi

    echo "${GREEN}[INFO]${RESET} DONE"
}
