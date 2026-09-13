# Tool integrations and external configurations

# ------------------------------------------------------------------------
# External site-functions
# ------------------------------------------------------------------------

# From external packages (Homebrew, etc.)
# Note: this is a directory of completion functions, so it belongs on fpath -
# it cannot be sourced. To affect completions it must be added before compinit
# runs, i.e. from local.d/_fpath.zsh; this is here only to keep $fpath complete.
[[ -d /usr/local/share/zsh/site-functions ]] && fpath+=(/usr/local/share/zsh/site-functions)

# ------------------------------------------------------------------------
# bun
# ------------------------------------------------------------------------

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ------------------------------------------------------------------------
# uv / rust installers (they append an env script here)
# ------------------------------------------------------------------------

[ -s "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# ------------------------------------------------------------------------
# pnpm
# ------------------------------------------------------------------------

export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ------------------------------------------------------------------------
# OrbStack
# ------------------------------------------------------------------------

source ~/.orbstack/shell/init.zsh 2>/dev/null || :
