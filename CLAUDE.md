# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Important: ZSH Configuration Structure

**The ZSH configuration follows modern conventions** (refactored Jan 2026):

- **Location**: `~/.config/zsh/` (XDG-compliant), tracked here as `_config/zsh/`
- **Entry point**: `~/.zshenv` (tracked as `_zshenv`) sets `ZDOTDIR=$XDG_CONFIG_HOME/zsh`
- **Main config**: `~/.config/zsh/.zshrc` → `_config/zsh/.zshrc`
- **Modules**: `_config/zsh/conf.d/*.zsh`, sourced in lexical order
- **Machine-specific**: `_config/zsh/local.d/*.zsh`, gitignored, sourced last

There is no `~/.zshrc.d/` and no `_zshrc`/`_zshrc.d/` anymore — the old
`common.zsh` / `$HOSTNAME` / `utils.zsh` layout was deleted in that refactor.

See `_config/zsh/README.md` for complete documentation.

## Overview

This is a personal dotfiles repository using a symlink-based installation approach. Files prefixed with `_` are automatically symlinked to `$HOME` with the underscore replaced by a dot (e.g., `_bashrc` becomes `~/.bashrc`).

## Installation

```bash
./install.sh
```

This script creates symlinks for all files matching `_*` in the repository root to `$HOME` with the first underscore replaced by a dot.

## Architecture

### Shell Configuration Structure

**ZSH (`_zshenv` + `_config/zsh/`)**
- `_zshenv` → `~/.zshenv` runs for every shell. Keep it minimal: XDG vars,
  `ZDOTDIR`, locale, `EDITOR`/`VISUAL`.
- `_config/zsh/.zprofile` runs for login shells only: the PATH reset,
  `$XDG_BIN_HOME`, `brew shellenv`, and a source of any app-written `~/.zprofile`
  (installers write there, but `ZDOTDIR` means zsh would otherwise ignore it).
- `_config/zsh/.zshrc` runs for interactive shells. It puts `functions/` and
  `completions/` on `$fpath`, autoloads every file in `functions/`, runs
  `compinit`, then sources `conf.d/*.zsh` followed by `local.d/*.zsh`.
- Uses Oh-My-ZSH as the framework with `gozilla` theme
- Plugins: git, gh, macos, dotenv, nvm (lazy-loaded), zsh-autosuggestions
- Uses vi keybindings with custom readline settings (^R for history search, ^Space for autosuggest)

**Bash (_bashrc)**
- Lightweight alternative for production environments
- Sources common configuration from `~/.bashrc.d/common.bash`
- Loads hostname-specific config from `~/.bashrc.d/$HOSTNAME`
- This is the *old* pattern and survives only in bash; zsh does not do this.

### ZSH Directory Layout

- **`conf.d/*.zsh`** — tracked modules, sourced in lexical order:
  `00-environment`, `05-ssh-agent`, `10-aliases`, `20-keybindings`,
  `40-oh-my-zsh`, `45-prompt`, `50-tools`, `60-zle`.
  **The numbering is load-bearing.** `45-prompt.zsh` must stay after
  `40-oh-my-zsh.zsh`: sourcing oh-my-zsh sets `PROMPT` from the theme and
  silently overwrites anything set before it. `60-zle.zsh` runs `bindkey -v`
  after oh-my-zsh for the same reason.
- **`functions/`** — one autoloaded function per file; **the filename is the
  function name**. No shebang, no `+x`, no extension; use `return` not `exit`
  (the body runs inside your shell). See `_config/zsh/functions/README.md`.
- **`completions/`** — completion functions only, `_name` with `#compdef name`.
  These are a separate directory from `functions/` and must be on `$fpath`
  before `compinit`.
- **`local.d/`** — gitignored except `*.example` and `README.md`. Sourced last,
  so it can override anything in `conf.d/`.

### Configuration Loading Pattern

1. `~/.zshenv` (all shells)
2. `.zprofile` (login shells)
3. `.zshrc`: fpath + autoload → `local.d/_fpath.zsh` if present → `compinit`
4. `conf.d/*.zsh` in lexical order
5. `local.d/*.zsh` — machine-specific and private, last word wins

Anything tracked functions depend on belongs in `conf.d/`, not `local.d/` —
leaving it to a gitignored file means it silently breaks on a fresh machine.

### Key Environment Variables

**XDG Base Directory Specification** (set in `_zshenv`, which also creates the dirs):
- `XDG_CONFIG_HOME=$HOME/.config`
- `XDG_CACHE_HOME=$HOME/.cache`
- `XDG_STATE_HOME=$HOME/.local/state`
- `XDG_DATA_HOME=$HOME/.local/share`
- `XDG_BIN_HOME=$HOME/.local/bin`

**Development Tools**:
- `EDITOR`/`VISUAL` = `nvim` (`_zshenv`)
- `GOPATH=$HOME/dev` (`conf.d/00-environment.zsh`) — tracked here, not in
  `local.d`, because `goto`/`clone`/`nav`/`scaffold_challenge` and the `_goto`
  completion all dereference it
- `GO_DEFAULT=eculver` — default GitHub owner for `goto`/`clone`
- `TXT_HOME`/`WORKLOG_HOME`/`SUPPORTLOG_HOME`, `TDT_*` — consumed by the
  `worklog`, `supportlog`, and `tdt_*` functions
- `CARGO_HOME`/`RUSTUP_HOME` under `$XDG_DATA_HOME` — set in
  `local.d/local.zsh.example`, not tracked config
- `SSH_AUTH_SOCK` — **resolved per host** in `conf.d/05-ssh-agent.zsh`; never
  hardcode it, and never set it in `local.d` (which is sourced later and would
  win)

**SSH Agent**:
The Mac running 1Password is the single root of trust; it holds every private
key and forwards its agent to remote hosts. `conf.d/05-ssh-agent.zsh`:
- 1Password socket present (`~/.1password/agent.sock`) → use it directly
- otherwise → pin the live forwarded socket to `~/.ssh/agent.sock` and export
  that stable path, so long-lived tmux panes survive a reconnect (sshd hands out
  a fresh socket path per login)
- no live forwarded agent → fall back to the host's own systemd user agent at
  `$XDG_RUNTIME_DIR/openssh_agent`, loading `~/.ssh/id_ed25519` once per boot

`_ssh/config` mirrors this: `IdentityAgent` is set only under a
`Match exec "test -S ~/.1password/agent.sock"` guard so Linux skips it, and
`ForwardAgent` is deliberately *not* set under `Host *` — it goes in
`~/.ssh/config.d/*.conf` per trusted host.

**Secrets Management**:
Secrets are 1Password references (e.g. `op://Private/OpenAI/api key`) injected at
runtime with `op run`. They live in `local.d/`, which is gitignored — this repo
is public. See `local.d/local.zsh.example`.

### Git Configuration

**Signing**: SSH signing (`gpg.format = ssh`) with `gpg.ssh.program` deliberately
**unset**, so git uses its default `ssh-keygen`. That signs through whatever
agent `$SSH_AUTH_SOCK` points at — 1Password on the Mac, the forwarded agent on
a remote host. 1Password's `op-ssh-sign` was removed because it is macOS-only;
this is what makes signing work on Linux. `gpg.ssh.allowedSignersFile` points at
`~/.config/git/allowed_ssh_signers`, which must list the key `user.signingkey`
actually signs with or git reports your own commits as unknown-signer.

The Linux devenv is the exception: `_gitconfig-devenv` (included for repos under
`/home/eculver/`) sets `gpg.ssh.program = ~/.config/git/devenv-ssh-sign`, a
shim that pins `SSH_AUTH_SOCK` to the host's systemd user agent before exec'ing
`ssh-keygen`, because that host signs with its own key rather than a forwarded one.

**Diff/Merge**: Uses `delta` as pager with custom theme (`custom-theme`) featuring:
- Line numbers enabled
- Monokai Extended syntax theme
- diff3 conflict style
- Color-moved support

**Conditional Includes** (order matters, first match for a path wins per key):
- `gitdir:/home/eculver/` → `.gitconfig-devenv` (Linux devenv signing identity)
- `gitdir:~/dev/src/github.com/sfcompute/` → `.gitconfig-sfc` (work identity)
- `~/.config/git/config.local` — untracked per-machine overrides, silently
  ignored when absent

**Notable Aliases**:
- `lg` - Pretty log with graph
- `pu` - Fetch and merge from upstream
- `oldest-ancestor` - Find merge base between branches

### Vim/Neovim Configuration

Uses Vundle for plugin management with these key plugins:
- Auto-completion: neocomplete.vim + neosnippet.vim
- Syntax checking: Syntastic (configured for Go, Python, JavaScript, Puppet)
- Language support: vim-go (with goimports fmt), vim-puppet, vim-javascript, vim-json
- Go-specific: Uses goimports for formatting, quickfix for error lists

### Tmux Configuration

- Prefix: `CTRL+a` (screen-like)
- Mouse support enabled (pane switching, scrolling, copy-mode)
- Vi mode-keys
- 10,000 line scrollback
- Custom status line with session, date/time, uptime, battery, ping, hostname
- Key bindings: `+` horizontal split, `_` vertical split, `Tab` last pane, `C-b` last window
- Plugins via tpm: battery, ping, date, resurrect + continuum

### Custom Shell Functions

These are autoloaded from `_config/zsh/functions/` (zsh only — bash does not get
them). Filename = function name.

**Networking**:
- `lsportpids <port>` - List PIDs listening on a port
- `lsports` - List all listening ports with process info
- `int2ip <int>` - Convert integer to IP address string

**Git Helpers**:
- `gitco <branch>` - Checkout new branch tracking origin/master
- `gitsha [ref]` - Print commit SHA (defaults to HEAD)
- `gitshacp` - Copy HEAD SHA to clipboard

**Docker**:
- `docker_rm_dead_images` - Remove exited containers and dangling images
- `docker_rm_dead_resources` - Remove all containers, volumes, and networks

**Date/Time**:
Multiple aliases for timestamps: `tsnow`, `tsnowutc`, `epochnow`, `epochnowms`, `epochnowutc`, `epochnowutcms`, etc.

**Validation**:
- `validate-yaml <file>` - Validate YAML using Ruby
- `validate-hcl <file>` - Validate HCL using hclfmt

## Development Tools Integration

Tracked in `conf.d/`:
- **Node.js**: NVM via the oh-my-zsh plugin, lazy-loaded and pointed at
  `$HOMEBREW_PREFIX/opt/nvm`; `.nvmrc` autoload is the plugin's own
  `zstyle ':omz:plugins:nvm' autoload yes` (`conf.d/40-oh-my-zsh.zsh`). The
  `nvm-load-nvmrc` function is a leftover fallback and is not hooked up.
- **bun, pnpm, uv/rust env, OrbStack**: sourced guardedly in `conf.d/50-tools.zsh`

Untracked, shown in `local.d/local.zsh.example` — do not assume these are active
on a given machine:
- **1Password CLI**: completions plus `$OP_PLUGINS_FILE` =
  `$XDG_CONFIG_HOME/op/plugins.sh`
- **Kubernetes**: aliases `kc`, `kctx`, `kns`, `ktail`
- **fzf**: `~/.fzf.zsh`
- **Java/Rust/CMake** environment variables

Bash only (`_bashrc`, `_bashrc.d/`), not present in the zsh config:
virtualenvwrapper (`WORKON_HOME`), rbenv, and `PYTHONSTARTUP=~/.pythonrc.py`.

## Environment-Specific Files

Machine-specific, host-specific, and private zsh config all goes in
`_config/zsh/local.d/` — it is gitignored except `*.example` and `README.md`, and
is sourced after `conf.d/`, so it can override anything. Add a
`local.d/*.zsh.example` when documenting a new knob (see
`local.zsh.example` for `PROMPT_HOST_COLOR`, machine PATH entries, secrets).

There is no hostname-dispatch mechanism in zsh anymore; `_bashrc.d/$HOSTNAME`
still exists for bash.

## Important Notes

- tmux is aliased to force UTF-8 and 256 colors: `tmux -u -2`
- vim is aliased to nvim throughout
- Git always uses SSH for GitHub (via url.insteadOf)
- All commits are signed (`commit.gpgsign = true`) with an SSH key, through
  whatever agent `$SSH_AUTH_SOCK` resolves to
- System paths are reset in `.zprofile` (not `.zshrc`) to prioritize
  user-installed tools over system defaults
- The prompt colors the hostname from a hash of the hostname so machines are
  distinguishable; override with `PROMPT_HOST_COLOR` in `local.d/`
