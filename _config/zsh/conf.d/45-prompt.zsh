# Prompt configuration - must load AFTER 40-oh-my-zsh.zsh, which sets PROMPT
# from the theme and would otherwise overwrite everything below.

# ------------------------------------------------------------------------
# Per-host colour
# ------------------------------------------------------------------------
#
# The hostname was always in the prompt, but drawn in the same colour as the
# username, so it read as decoration rather than information. Deriving a stable
# colour from the hostname makes each machine distinguishable at a glance, and
# means a newly provisioned box gets its own colour with no per-host setup.
#
# To pin a specific colour for a machine, set PROMPT_HOST_COLOR in local.d -
# the prompt reads it at render time, so a later override still wins.

if [[ -z $PROMPT_HOST_COLOR ]]; then
    if (( ${terminfo[colors]:-8} >= 256 )); then
        # readable on a dark background, and clear of the green/cyan/blue/red
        # already used elsewhere in this prompt. Kept wide because a hash will
        # otherwise hand two hosts the same colour surprisingly often.
        # Hue families are interleaved rather than grouped, so that two hosts
        # landing on neighbouring slots still get visibly different colours.
        _host_palette=(
            39 135 208  45 141 178  69 147 179
            75 170 203  81 176 209 111 183 215
            117 207 221 213 222 166
        )
    else
        _host_palette=(1 2 3 4 5 6)
    fi

    # cheap deterministic hash of the short hostname, done in-shell so we do
    # not fork anything at startup
    _host_hash=0
    _host_short=${HOST%%.*}
    for (( _i = 1; _i <= ${#_host_short}; _i++ )); do
        _host_char=$_host_short[_i]
        (( _host_hash = (_host_hash * 31 + #_host_char) % 100003 ))
    done

    PROMPT_HOST_COLOR=$_host_palette[$(( (_host_hash % ${#_host_palette}) + 1 ))]

    unset _host_palette _host_hash _host_short _host_char _i
fi

# Modify prompt -- this is theme-specific for gozilla
export PROMPT='%{$fg_bold[green]%}%n%{$reset_color%}%B%F{$PROMPT_HOST_COLOR}@%m%f%b %{$fg_bold[red]%}➜%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$reset_color%}%{$fg_bold[blue]%} % %{$reset_color%}'
