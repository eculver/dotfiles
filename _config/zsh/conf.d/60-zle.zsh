# ZSH Line Editor customizations

# ------------------------------------------------------------------------
# Visual mode indicator
# ------------------------------------------------------------------------

zle-line-init() {
    RPS1="${${KEYMAP/vicmd/N}/(main|viins)/ }"
    RPS2=$RPS1
    zle reset-prompt
}

zle-keymap-select() {
    RPS1="${${KEYMAP/vicmd/N}/(main|viins)/ }"
    RPS2=$RPS1
    zle reset-prompt
}

# ZSH Line Editor selections
zle -N zle-line-init
zle -N zle-keymap-select
