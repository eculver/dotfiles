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
