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
#  lazy nvm
zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' lazy-cmd eslint prettier typescript # these commands will also trigger loading nvm

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git github macos dotenv nvm zsh-autosuggestions)

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh
