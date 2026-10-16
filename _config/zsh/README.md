# ZSH Configuration

Modern, XDG-compliant ZSH configuration following ZSH conventions.

## Overview

This configuration follows the standard ZSH startup file structure and best practices:

- **`~/.zshenv`** - Essential environment variables (sourced by all shells)
- **`.zprofile`** - Login shell PATH setup (sourced for login shells before `.zshrc`)
- **`.zshrc`** - Interactive shell configuration (main config file)
- **`functions/`** - Autoloadable functions (one file per function)
- **`completions/`** - Custom completion functions
- **`conf.d/`** - Modular configuration files
- **`local.d/`** - Machine-specific configs (not in git)

## Installation

1. Run the main install script from the dotfiles root:
   ```bash
   ./install.sh
   ```
   This symlinks every `_*` entry in the repo root into `$HOME` with the leading
   underscore replaced by a dot — including `_zshenv` → `~/.zshenv` and the whole
   `_config/` directory → `~/.config/`.

2. The config lives in `~/.config/zsh/` (via `$ZDOTDIR`, set in `.zshenv`)

3. Create your local configuration:
   ```bash
   cd ~/.config/zsh/local.d
   cp local.zsh.example local.zsh
   # Edit local.zsh for your machine
   ```

4. Restart your shell or source the new config:
   ```bash
   exec zsh
   ```

## Directory Structure

```
~/.config/zsh/
├── .zshrc                  # Main interactive shell config
├── .zprofile               # Login shell PATH setup
├── README.md               # This file
├── functions/              # Autoloadable functions (53 of them)
│   ├── README.md           # Conventions and foot-guns — read before adding one
│   ├── beepwhenup
│   ├── goto
│   ├── gitco
│   └── ...
├── completions/            # Custom completions
│   ├── _goto
│   └── _tfplan
├── conf.d/                 # Configuration modules (tracked)
│   ├── 00-environment.zsh
│   ├── 05-ssh-agent.zsh
│   ├── 10-aliases.zsh
│   ├── 20-keybindings.zsh
│   ├── 40-oh-my-zsh.zsh
│   ├── 45-prompt.zsh
│   ├── 50-tools.zsh
│   └── 60-zle.zsh
└── local.d/                # Machine-specific (gitignored)
    ├── README.md
    ├── local.zsh.example
    ├── yobi.zsh.example
    ├── _fpath.zsh          # Optional: fpath additions, sourced before compinit
    └── local.zsh           # Your actual config (create from example)
```

Only `*.example` and `README.md` are tracked under `local.d/`; everything else
there is gitignored.

## How It Works

### Startup Sequence

When you open a new terminal (interactive login shell):

1. **`~/.zshenv`** is sourced
   - Sets XDG environment variables (and creates the directories)
   - Sets `ZDOTDIR=$XDG_CONFIG_HOME/zsh`
   - Sets essential vars like `EDITOR`, `LANG`

2. **`$ZDOTDIR/.zprofile`** is sourced (login shells only)
   - Sets up `PATH`, evaluates `brew shellenv`
   - One-time login initialization

3. **`$ZDOTDIR/.zshrc`** is sourced
   - Puts `functions/` and `completions/` on `$fpath` and autoloads every file
     in `functions/`
   - Sources `local.d/_fpath.zsh` if it exists, so machine-specific completion
     directories land on `$fpath` *before* `compinit`
   - Runs `compinit` (cache in `$XDG_CACHE_HOME/zsh/`)
   - Sources `conf.d/*.zsh` in lexical order
   - Sources `local.d/*.zsh` in lexical order (your machine-specific config)

### Load Order Matters

Two ordering rules are load-bearing. Both have been broken before.

**`local.d/` loads last, so it wins.** Anything set in `local.d/*.zsh` overrides
whatever `conf.d/` set. That is the point — it is how a machine customizes the
tracked config — but it also means a stray `export` in a local file silently
defeats tracked logic. This bit before: a `local.zsh` exporting `SSH_AUTH_SOCK`
clobbered the per-host agent resolution in `conf.d/05-ssh-agent.zsh`, so remote
hosts kept pointing at a dead forwarded socket. If a tracked module already
handles something, do not re-set it in `local.d/` unless you mean to take it over.

**`45-prompt.zsh` must sort after `40-oh-my-zsh.zsh`.** `conf.d/` is globbed and
sourced in lexical order, and `40-oh-my-zsh.zsh` sets `PROMPT` from the
`$ZSH_THEME` when it sources `oh-my-zsh.sh`. The prompt customization used to
live at `30-prompt.zsh`, which ran *first* — oh-my-zsh then overwrote `PROMPT`
on the next line and the custom prompt never took effect. Renaming it to `45`
is the fix, not cosmetics. Do not renumber it below `40`, and keep the same
constraint in mind for anything else that touches `PROMPT`, `RPS1`, or keymaps
(`60-zle.zsh` re-applies `bindkey -v` after oh-my-zsh for the same reason).

### Configuration Modules (conf.d/)

Files in `conf.d/` are sourced in lexical order. The numeric prefix controls that
order:

- **00-environment.zsh** - Environment variables, colors, `GOPATH`, custom vars
- **05-ssh-agent.zsh** - Resolves `SSH_AUTH_SOCK` (1Password locally, pinned
  symlink to the forwarded/host agent remotely)
- **10-aliases.zsh** - Command aliases
- **20-keybindings.zsh** - Key bindings (`^R` history search, `^Space`
  autosuggest-accept, `v` to edit the command line)
- **40-oh-my-zsh.zsh** - Oh-My-Zsh framework setup (theme, plugins); **sets
  `PROMPT`**
- **45-prompt.zsh** - Prompt customization, incl. per-host color; must follow
  oh-my-zsh (see above)
- **50-tools.zsh** - External tool integrations (bun, pnpm, OrbStack, …)
- **60-zle.zsh** - ZSH Line Editor customizations (vi mode, mode indicator)

### Functions

Functions are autoloaded from the `functions/` directory. Each file contains one
function, and the filename *is* the function name — no extension, no shebang, no
`+x` bit.

**Convention**: No `function` keyword needed, just the function body:

```zsh
# File: functions/myfunction
local arg=$1
echo "Hello from myfunction: $arg"
```

**Usage**: Just call the function:
```bash
myfunction "test"
```

ZSH automatically loads it on first use.

Do **not** give a file in `functions/` a leading-underscore name: the directory
is on `$fpath`, so `compinit` would pick up `_name` and try to treat it as a
completion definition. Completions belong in `completions/`.

See [`functions/README.md`](functions/README.md) for the full conventions,
the `main` wrapper pattern, and the foot-guns (`exit` kills your shell, option
and variable leakage) that come from running as a function body rather than a
script.

### Completions

Completion functions go in `completions/` with `_commandname` naming convention:

```zsh
# File: completions/_goto
#compdef goto

# completion logic here
```

Completion directories supplied by other packages (Homebrew's
`site-functions`, for example) have to be on `$fpath` *before* `compinit` runs,
which means they belong in `local.d/_fpath.zsh` — adding them from `conf.d/` is
too late to affect completions.

## Customization

### Adding Your Own Functions

Create a new file in `functions/` with your function name:

```bash
# Create the function file
cat > ~/.config/zsh/functions/myhelper <<'EOF'
# Description of what this does
local arg=$1
echo "Doing something with: $arg"
EOF
```

ZSH will autoload it automatically on next shell start.

### Adding Machine-Specific Config

Edit `~/.config/zsh/local.d/local.zsh`:

```bash
# Add your custom aliases
alias myserver='ssh user@server.com'

# Add custom environment variables
export MY_PROJECT_PATH=$HOME/projects/myproject

# Add custom PATH entries
export PATH=$HOME/custom/bin:$PATH
```

Remember that `local.d/` is sourced after `conf.d/`, so these override the
tracked config.

### Adding a New Configuration Module

Create a new file in `conf.d/`:

```bash
# Use numbering to control load order
cat > ~/.config/zsh/conf.d/70-my-custom-config.zsh <<'EOF'
# My custom configuration

alias foo='bar'
export MY_VAR=value
EOF
```

If the module touches anything oh-my-zsh also sets (`PROMPT`, keymaps,
`$plugins` side effects), number it above `40`.

## Advantages of This Structure

✅ **XDG-Compliant** - Config in `~/.config`, cache in `~/.cache`
✅ **Modular** - Easy to find and edit specific settings
✅ **Fast Loading** - Functions autoloaded only when needed
✅ **Version Control Friendly** - Local configs gitignored
✅ **Conventional** - Follows ZSH best practices
✅ **Portable** - Easy to set up on new machines

## Troubleshooting

### Functions not loading

Check that functions are in `$ZDOTDIR/functions/` and have correct permissions:
```bash
ls -la ~/.config/zsh/functions/
```

### Completion not working

Rebuild completion cache:
```bash
rm ~/.cache/zsh/zcompdump*
exec zsh
```

If a specific tool's completions are missing, check that its completion
directory is added in `local.d/_fpath.zsh` (anything added later is after
`compinit` and has no effect).

### Prompt looks like the stock theme

Something is setting `PROMPT` after `conf.d/45-prompt.zsh`. The usual suspects
are a `local.d/` file or a `conf.d/` module numbered above `45`.

### Config not loading

Check that `ZDOTDIR` is set correctly:
```bash
echo $ZDOTDIR
# Should output: /Users/yourname/.config/zsh
```

## Resources

- [`functions/README.md`](functions/README.md) - Function conventions
- [`local.d/README.md`](local.d/README.md) - What belongs in machine-local config
- [`.cursor/rules/zsh_scripts.md`](.cursor/rules/zsh_scripts.md) - Shell style guide
- [ZSH Startup Files](https://zsh.sourceforge.io/Intro/intro_3.html)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [ZSH Completion System](https://zsh.sourceforge.io/Doc/Release/Completion-System.html)
