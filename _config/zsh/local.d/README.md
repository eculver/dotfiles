# local.d/

This directory contains machine-specific and private configuration files.

**These files are not tracked by git** (see `.gitignore`).

## Usage

Copy the `.example` files to create your own local configurations:

```bash
cp local.zsh.example local.zsh
cp yobi.zsh.example work.zsh  # or yobi.zsh
```

Then customize them for your specific machine or work environment.

## What Goes Here

- Machine-specific PATH additions
- Private aliases or functions
- Work-related configurations
- API keys and secrets (preferably as 1Password references)
- SSH host shortcuts
- Tool configurations specific to this machine

## Example Files

- `local.zsh.example` - Template for local machine configuration
- `yobi.zsh.example` - Template for work-specific configuration

These examples show the typical configurations you might want to customize.
