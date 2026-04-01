# Tool integrations and external configurations

# ------------------------------------------------------------------------
# External site-functions
# ------------------------------------------------------------------------

# From external packages (Homebrew, etc.)
[[ -d /usr/local/share/zsh/site-functions ]] && source /usr/local/share/zsh/site-functions

# ------------------------------------------------------------------------
# bun
# ------------------------------------------------------------------------

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
. "$HOME/.local/bin/env"

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
