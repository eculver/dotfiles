# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Important: New ZSH Configuration Structure

**The ZSH configuration has been refactored** (Jan 2026) to follow modern conventions:

- **New location**: `~/.config/zsh/` (XDG-compliant)
- **Old location**: `_zshrc` and `_zshrc.d/` (still present for reference)
- **Active config**: Determined by `ZDOTDIR` in `~/.zshenv`

See `_config/zsh/README.md` for the new structure documentation and `MIGRATION.md` for migration details.

## Overview

This is a personal dotfiles repository using a symlink-based installation approach. Files prefixed with `_` are automatically symlinked to `$HOME` with the underscore replaced by a dot (e.g., `_bashrc` becomes `~/.bashrc`).

## Installation

```bash
./install.sh
```

This script creates symlinks for all files matching `_*` in the repository root to `$HOME` with the first underscore replaced by a dot.

## Architecture

### Shell Configuration Structure

The shell configurations follow a modular architecture with common and environment-specific includes:

**ZSH (_zshrc)**
- Uses Oh-My-ZSH as the framework with `gozilla` theme
- Sources common configuration from `~/.zshrc.d/common.zsh`
- Loads hostname-specific config from `~/.zshrc.d/$HOSTNAME`
- Includes utility functions from `~/.zshrc.d/utils.zsh`
- Key environment-specific configs: `local.zsh`, `yobi.zsh`, `miner.zsh`, `plow.zsh`, `wd.zsh`
- Plugins: git, github, macos, dotenv, nvm (lazy-loaded), zsh-autosuggestions
- Uses vi keybindings with custom readline settings (^R for history search, ^Space for autosuggest)

**Bash (_bashrc)**
- Lightweight alternative for production environments
- Sources common configuration from `~/.bashrc.d/common.bash`
- Loads hostname-specific config from `~/.bashrc.d/$HOSTNAME`

### Path Management

Both shells include utility functions for path manipulation:
- `prepend-path <path>` - Adds path to beginning of $PATH (deduplicates first)
- `append-path <path>` - Adds path to end of $PATH (deduplicates first)
- `remove-path <path>` - Removes path from $PATH
- `source-if-exists <file>` - Sources file only if it exists

### Configuration Loading Pattern

The repository uses a hostname-based configuration loading strategy:
1. Load common settings (applies to all environments)
2. Load hostname-specific settings from `$CONFDIR/$HOSTNAME`
3. Hostname files can be symlinks to canonical environment configs (e.g., `mylaptop.local -> local.zsh`)

### Key Environment Variables

**XDG Base Directory Specification** (set in `common.zsh`):
- `XDG_CONFIG_HOME=$HOME/.config`
- `XDG_CACHE_HOME=$HOME/.cache`
- `XDG_STATE_HOME=$HOME/.local/state`
- `XDG_DATA_HOME=$HOME/.local/share`

**Development Tools**:
- `EDITOR='nvim'` - Neovim is the default editor
- `GOPATH=$HOME/dev` - Go workspace
- `CARGO_HOME="$XDG_DATA_HOME"/cargo` - Rust/Cargo
- `RUSTUP_HOME="$XDG_DATA_HOME"/rustup` - Rustup
- `SSH_AUTH_SOCK=$HOME/.1password/agent.sock` - 1Password SSH agent integration

**Secrets Management**:
Secrets are stored as 1Password references in shell configs (e.g., `op://Private/OpenAI/api key`) and injected at runtime using `op run`.

### Git Configuration

**Signing**: Uses SSH signing via 1Password (`gpg.format = ssh`, `gpg.ssh.program` points to 1Password SSH sign)

**Diff/Merge**: Uses `delta` as pager with custom theme (`custom-theme`) featuring:
- Line numbers enabled
- Monokai Extended syntax theme
- diff3 conflict style
- Color-moved support

**Work Context**: Separate git identity for work repos via `includeIf "gitdir:~/dev/src/github.com/yobilabs/"` loading `.gitconfig-yobi`

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
- Custom status line with session, date/time, battery, hostname
- Key bindings: `+` horizontal split, `_` vertical split, `Tab` last pane, `C-b` last window

### Custom Shell Functions

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

**Node.js**: NVM with lazy loading (via oh-my-zsh plugin) + auto `.nvmrc` detection in `local.zsh`

**Python**:
- Virtualenvwrapper with `WORKON_HOME=~/.virtualenvs`
- Custom REPL startup: `~/.pythonrc.py`

**Ruby**: chruby with auto-switching and rbenv integration

**Kubernetes**: Aliases for `kubectl` (`kc`), `kubectx` (`kctx`), `kubens` (`kns`), `kubetail` (`ktail`)

**1Password**: CLI completions loaded, plugins file sourced from `$XDG_CONFIG_HOME/op/plugins.sh`

**fasd**: Fast directory/file navigation with `v` alias for vim

**fzf**: Fuzzy finder integration via `~/.fzf.zsh`

## Environment-Specific Files

When modifying configs for specific environments:
- **Local/Laptop**: Edit `_zshrc.d/local.zsh` or `_bashrc.d/local.bash`
- **Work (Yobi)**: Edit `_zshrc.d/yobi.zsh`
- **Remote hosts**: Create hostname-specific files in `_zshrc.d/` or `_bashrc.d/`

## Important Notes

- tmux is aliased to force UTF-8 and 256 colors: `tmux -u -2`
- vim is aliased to nvim throughout
- Git always uses SSH for GitHub (via url.insteadOf)
- All commits are GPG signed via SSH (1Password)
- System paths are reset in zshrc to prioritize user-installed tools over system defaults
