# ~/.config/zsh/.zshrc
#
# Executed for interactive shells
# This is where most of your configuration should live

# ------------------------------------------------------------------------
# Function Autoloading
# ------------------------------------------------------------------------

# Add functions and completions to fpath
fpath=($ZDOTDIR/functions $ZDOTDIR/completions $fpath)
typeset -U fpath  # Keep fpath entries unique

# Autoload all functions from functions directory
autoload -Uz $ZDOTDIR/functions/*(.:t)

# Make add-zsh-hook available so conf.d/ and local.d/ can register hooks
autoload -Uz add-zsh-hook

# ------------------------------------------------------------------------
# Completion System
# ------------------------------------------------------------------------

# Source local fpath configuration before initializing completions
# This allows machine-specific completion paths (e.g., homebrew) to be added
if [[ -f $ZDOTDIR/local.d/_fpath.zsh ]]; then
  source $ZDOTDIR/local.d/_fpath.zsh
fi

# Initialize completion system
# Store completion cache in XDG-compliant location
autoload -Uz compinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

# ------------------------------------------------------------------------
# Source Configuration Files
# ------------------------------------------------------------------------

# Source all configuration files in conf.d/ in order
# Files are prefixed with numbers to control load order:
#   00-environment.zsh  - Environment variables and colors
#   05-ssh-agent.zsh    - SSH agent resolution
#   10-aliases.zsh      - Command aliases
#   20-keybindings.zsh  - Key bindings
#   40-oh-my-zsh.zsh    - Oh-My-Zsh setup (sets PROMPT from the theme)
#   45-prompt.zsh       - Prompt customization (must follow oh-my-zsh)
#   50-tools.zsh        - External tool integrations
#   60-zle.zsh          - ZLE customizations

for config in $ZDOTDIR/conf.d/*.zsh(N); do
  source $config
done

# ------------------------------------------------------------------------
# Local/Machine-Specific Configuration
# ------------------------------------------------------------------------

# Source local configuration files (not in version control)
# These files should contain machine-specific or private configurations
# Examples: local.zsh, work.zsh, secrets.zsh

if [[ -d $ZDOTDIR/local.d ]]; then
  for config in $ZDOTDIR/local.d/*.zsh(N); do
    source $config
  done
fi
