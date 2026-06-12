# functions/

Autoloaded zsh functions. One file per function; **the filename is the function name** (no extension).

## How autoloading works

`.zshrc` adds this directory to `$fpath` and registers every file as an autoloadable function:

```zsh
fpath=($ZDOTDIR/functions $ZDOTDIR/completions $fpath)
autoload -Uz $ZDOTDIR/functions/*(.:t)
```

When you first invoke `myfunc`, zsh reads `functions/myfunc` and wraps its contents in a function named `myfunc`. The file body itself does **not** need a `function name() { ... }` declaration — autoload supplies that wrapper for you.

Concrete consequence: these files are loaded as *function bodies*, not executed as *scripts*. That distinction drives every convention below.

## Conventions

- **No `#!` shebang.** Autoload reads the file; nothing ever `exec`'s it. A shebang is just a dead comment line.
- **No `+x` bit.** Same reason. Directory listings should be `-rw-r--r--`.
- **No file extension.** The filename is the function name verbatim.
- **One function per file.** Helper subfunctions can live inside the body.

## The `main` pattern (for non-trivial functions)

Per `.cursor/rules/zsh_scripts.md`, anything beyond a one-liner helper should be wrapped in a `main` function:

```zsh
main() {
  emulate -L zsh
  setopt err_exit no_unset pipe_fail

  local arg1="${1:?usage: myfunc <arg>}"
  # ...
}

main "$@"
```

This gives you a clean function body to put `local` declarations, early `return`s, and scoped `setopt` calls in. See `refresh-ssh-agent`, `aws-login`, and `git-rmbr` for full examples.

## Foot-guns to avoid

These bite specifically because the file runs as a function body inside your interactive shell, not as a separate script process.

### `exit` kills your shell — use `return`

`exit N` terminates the shell *process*, no matter how deeply nested inside functions you are. There's no function boundary that catches it. Inside an autoloaded function, always use `return N` for early exits.

```zsh
# WRONG — kills your terminal
if [[ -z "$1" ]]; then
  echo "usage: ..." >&2
  exit 1
fi

# RIGHT
if [[ -z "$1" ]]; then
  echo "usage: ..." >&2
  return 1
fi
```

### Shell options leak — use `emulate -L zsh`

`set -e`, `set -u`, `set -o pipefail`, and `setopt` calls inside a function persist in the caller's shell unless you opt into local scoping. `emulate -L zsh` does two things:

1. Resets zsh to a clean baseline (so your function isn't subtly affected by the caller's options).
2. The `-L` flag implies `LOCAL_OPTIONS` + `LOCAL_TRAPS`, so any `setopt` you make afterwards is automatically reverted on return.

Always put it at the top of `main` if you're touching options.

### Variables leak — use `local`

Bare assignments like `profile="admin"` create *global* shell variables. Declare with `local` (or `local -a` for arrays) inside `main` to keep them scoped.

## Adding a new function

```bash
cat > ~/.config/zsh/functions/myfunc <<'EOF'
main() {
  emulate -L zsh
  setopt err_exit no_unset pipe_fail

  local arg="${1:?usage: myfunc <arg>}"
  echo "doing something with: ${arg}"
}

main "$@"
EOF
```

It will be autoloaded on the next shell start. To pick it up in the current shell without restarting:

```zsh
autoload -Uz myfunc
```

## `tfplan` — collect terragrunt plan output

`tfplan -o <outfile> [-j <n>] [-p <profile>] <workspace> [<workspace> ...]` runs
`terragrunt plan -no-color` in each workspace directory (as `AWS_PROFILE=admin`
by default) and writes the combined output to `<outfile>` as Markdown. Each
workspace's plan is wrapped in a collapsible `<details>` block headed by the
workspace name — the directory's absolute path with everything up to and
including the top-level `terraform/` stripped (e.g.
`infra-platform/aws/production/eks/...`).

- `-j/--jobs <n>` runs up to `n` plans in parallel (default: all at once);
  `-j 1` forces sequential.
- `-p/--profile <name>` overrides the AWS profile.
- Captured output is de-noised (terragrunt timestamps and `STDOUT/STDERR
  terraform:` prefixes stripped) before writing.
- On a non-zero terragrunt exit the error is printed to stderr (not just buried
  in the file), the run continues to the remaining workspaces, and `tfplan`
  returns non-zero if any workspace failed.
- The combined Markdown is copied to the clipboard via `pbcopy` when available.

Tab completion lives in [`../completions/_tfplan`](../completions/_tfplan).

## Related

- Parent: [`../README.md`](../README.md) — overall zsh config structure
- Style: [`../.cursor/rules/zsh_scripts.md`](../.cursor/rules/zsh_scripts.md) — Google shell style + `main` pattern
- Completions go in [`../completions/`](../completions/), not here (use `_commandname` naming with `#compdef commandname`)
