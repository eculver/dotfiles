# Environment variables for interactive shells
# (Essential env vars are in ~/.zshenv)

# ------------------------------------------------------------------------
# Globals
# ------------------------------------------------------------------------

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export HOSTNAME
HOSTNAME=$(hostname)

# ------------------------------------------------------------------------
# Formatting Escape Sequences
# ------------------------------------------------------------------------

autoload colors
if [[ "$terminfo[colors]" -gt 8 ]]; then
    colors
fi
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
    eval $COLOR='$fg_no_bold[${(L)COLOR}]'
    eval BOLD_$COLOR='$fg_bold[${(L)COLOR}]'
done
eval RESET='$reset_color'

# ------------------------------------------------------------------------
# Common color formatting aliases
# ------------------------------------------------------------------------

export INFO_COLOR="${bg[white]}${fg[black]}"
export WARNING_COLOR="${bg[yellow]}${fg[black]}"
export ERROR_COLOR="${bg[red]}${fg[black]}"

# ------------------------------------------------------------------------
# Custom environment variables for tools/functions
# ------------------------------------------------------------------------

# Default GitHub user for goto/clone functions
export GO_DEFAULT=eculver

# Worklog and support log directories
export TXT_HOME=$HOME/txt
export WORKLOG_HOME=$TXT_HOME/worklog
export SUPPORTLOG_HOME=$TXT_HOME/support
