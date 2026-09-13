# Oh-My-ZSH configuration

# ------------------------------------------------------------------------
# Oh-My-ZSH Setup
# ------------------------------------------------------------------------

export HOME=~

# Path to your oh-my-zsh configuration
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="gozilla"

# Source any plugins that have been installed by Homebrew
[[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Settings required prior to sourcing oh-my-zsh:

# nvm is installed via Homebrew, so the plugin needs to be pointed at that prefix.
# Derived from $HOMEBREW_PREFIX (exported by `brew shellenv` in .zprofile) rather
# than `brew --prefix nvm`, which would fork a subprocess on every shell startup.
[[ -d ${HOMEBREW_PREFIX:-/opt/homebrew}/opt/nvm ]] && \
    export NVM_HOMEBREW=${HOMEBREW_PREFIX:-/opt/homebrew}/opt/nvm

#  lazy nvm
zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' lazy-cmd eslint prettier typescript # these commands will also trigger loading nvm

#  automatically `nvm use` when entering a directory with an .nvmrc
zstyle ':omz:plugins:nvm' autoload yes
zstyle ':omz:plugins:nvm' silent-autoload yes # suppress the output NVM generates when autoloading

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git github macos dotenv nvm zsh-autosuggestions)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh
