# ~/.config/zsh/.zprofile
#
# Executed for login shells (SSH sessions, initial terminal login)
# This runs BEFORE .zshrc
# Use for PATH extensions and one-time login setup

# ------------------------------------------------------------------------
# PATH Configuration
# ------------------------------------------------------------------------

# Reset path to ensure user-installed programs take precedence over system defaults
export PATH=/usr/local/sbin:/usr/local/bin:$HOME/bin:$PATH

# Add user local bin
[[ -d $HOME/.local/bin ]] && export PATH=$HOME/.local/bin:$PATH

# Add local/share bin
[[ -d $HOME/.local/share/../bin/env ]] && source $HOME/.local/share/../bin/env

# Homebrew (installers write to ~/.zprofile, but ZDOTDIR ignores that path)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# App installers (Obsidian, etc.) append to ~/.zprofile by default
[[ -f ~/.zprofile ]] && source ~/.zprofile
