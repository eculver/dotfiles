# Key bindings for interactive shells

# ------------------------------------------------------------------------
# Vi key bindings
# ------------------------------------------------------------------------

bindkey -v

# ------------------------------------------------------------------------
# Emacs-like convenience bindings in vi mode
# ------------------------------------------------------------------------

# make reverse search work as though we're in emacs mode
bindkey '^R' history-incremental-search-backward

# make CTRL+SPACE accept completion (for zsh-autosuggestions)
bindkey '^ ' autosuggest-accept

# ------------------------------------------------------------------------
# Enable editing via v command in vi mode
# ------------------------------------------------------------------------

autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
