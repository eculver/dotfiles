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
   This creates symlinks for `_zshenv` → `~/.zshenv`

2. The new config lives in `~/.config/zsh/` (via `$ZDOTDIR` set in `.zshenv`)

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
├── .zprofile              # Login shell PATH setup
├── functions/             # Autoloadable functions
│   ├── beepwhenup
│   ├── goto
│   ├── gitco
│   └── ... (40+ functions)
├── completions/           # Custom completions
│   └── _goto
├── conf.d/                # Configuration modules
│   ├── 00-environment.zsh
│   ├── 10-aliases.zsh
│   ├── 20-keybindings.zsh
│   ├── 30-prompt.zsh
│   ├── 40-oh-my-zsh.zsh
│   ├── 50-tools.zsh
│   └── 60-zle.zsh
└── local.d/               # Machine-specific (gitignored)
    ├── README.md
    ├── local.zsh.example
    ├── yobi.zsh.example
    └── local.zsh          # Your actual config (create from example)
```

## How It Works

### Startup Sequence

When you open a new terminal (interactive login shell):

1. **`~/.zshenv`** is sourced
   - Sets XDG environment variables
   - Sets `ZDOTDIR=$XDG_CONFIG_HOME/zsh`
   - Sets essential vars like `EDITOR`, `LANG`

2. **`$ZDOTDIR/.zprofile`** is sourced (login shells only)
   - Sets up `PATH`
   - One-time login initialization

3. **`$ZDOTDIR/.zshrc`** is sourced
   - Autoloads functions from `functions/`
   - Initializes completions
   - Sources `conf.d/*.zsh` in numerical order
   - Sources `local.d/*.zsh` (your machine-specific config)

### Configuration Modules (conf.d/)

Files in `conf.d/` are sourced in alphabetical order. The numbering controls load order:

- **00-environment.zsh** - Environment variables, colors, custom vars
- **10-aliases.zsh** - Command aliases
- **20-keybindings.zsh** - Key bindings (vi mode, special keys)
- **30-prompt.zsh** - Prompt customization
- **40-oh-my-zsh.zsh** - Oh-My-Zsh framework setup
- **50-tools.zsh** - External tool integrations
- **60-zle.zsh** - ZSH Line Editor customizations

### Functions

Functions are autoloaded from `functions/` directory. Each file contains one function with the filename matching the function name.

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

### Completions

Completion functions go in `completions/` with `_commandname` naming convention:

```zsh
# File: completions/_goto
#compdef goto

# completion logic here
```

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

## Migrating from Old Config

The old configuration is still in place:
- `_zshrc` - Old main config
- `_zshrc.d/` - Old modular configs

To switch to the new config, the `_zshenv` file sets `ZDOTDIR` which tells ZSH to use `~/.config/zsh/.zshrc` instead of `~/.zshrc`.

You can keep both configs and switch between them by modifying `ZDOTDIR` in `~/.zshenv`.

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

### Config not loading

Check that `ZDOTDIR` is set correctly:
```bash
echo $ZDOTDIR
# Should output: /Users/yourname/.config/zsh
```

## Resources

- [ZSH Startup Files](https://zsh.sourceforge.io/Intro/intro_3.html)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [ZSH Completion System](https://zsh.sourceforge.io/Doc/Release/Completion-System.html)
