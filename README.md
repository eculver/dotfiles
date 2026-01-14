## Overview

Personal dotfiles using a symlink-based installation approach.

## Shell Configuration

**ZSH**: Modern, XDG-compliant configuration in `_config/zsh/`
- See `_config/zsh/README.md` for detailed documentation
- Autoloadable functions, modular configs, completions
- Machine-specific configs in `local.d/` (gitignored)

**Bash**: Lightweight alternative for production environments in `_bashrc` and `_bashrc.d/`

## Other Configurations

- **Vim/Neovim**: `_vimrc`, `_vim/`
- **Tmux**: `_tmux.conf`
- **Git**: `_gitconfig` with delta, SSH signing via 1Password
- **Screen**: `_screenrc`
- **WeeChat**: `_config/weechat/`
- **GIMP**: `_gimp/`

## Instructions
### Creating source files
Any file which matches the shell glob `_*` will be linked into `$HOME` as a symlink with the first `_`  replaced with a `.`

For example:

    _bashrc

becomes

    ${HOME}/.bashrc

### Installing source files
It's as simple as running:

    ./install.sh

From this top-level directory.

## Requirements
* bash
