#!/usr/bin/env bash
#
# install.sh - symlink this repo's dotfiles into $HOME.
#
# Every top-level `_*` entry is linked into $HOME with the first `_` replaced
# by a `.`, so `_vimrc` becomes `~/.vimrc`.
#
# Two entries are special. `_config` and `_ssh` map onto `~/.config` and
# `~/.ssh`, directories that plenty of other programs already own. For those we
# link the *contents* (`~/.config/zsh -> _config/zsh`) rather than the
# directory. Linking the directory would be wrong twice over: it would hand the
# whole directory to this repo, and `ln -sf DIR TARGET` does not even replace
# an existing directory - it quietly creates `TARGET/DIR` *inside* it, which is
# how you end up with `~/.config/_config`.
#
# Nothing real is ever clobbered: an existing non-symlink file or directory is
# moved aside to `<name>.backup.<timestamp>` first. Re-running is a no-op.
#
# Usage:
#   ./install.sh              install
#   ./install.sh --dry-run    print what would happen, change nothing

set -u

REPO="$(cd "$(dirname "$0")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"
DRY_RUN=0

# Top-level entries whose $HOME counterpart is shared with other programs.
# These get their contents linked instead of the directory itself.
SHARED="_config _ssh"

created=0
updated=0
unchanged=0
backed_up=0

usage() {
    echo "usage: $0 [--dry-run]"
}

case "${1:-}" in
    -n|--dry-run) DRY_RUN=1 ;;
    -h|--help)    usage; exit 0 ;;
    "")           ;;
    *)            echo "$0: unknown option: $1" >&2; usage >&2; exit 1 ;;
esac

if [ -z "${HOME:-}" ] || [ ! -d "$HOME" ]; then
    echo "$0: HOME is not set to a directory" >&2
    exit 1
fi

say() {
    printf '%s\n' "$*"
}

# Short names for output, relative to $HOME and to the repo.
rel() {
    printf '%s' "${1#"$HOME"/}"
}

src() {
    printf '%s' "${1#"$REPO"/}"
}

# Run a command unless we're in dry-run mode.
run() {
    [ "$DRY_RUN" -eq 1 ] && return 0
    "$@"
}

is_shared() {
    case " $SHARED " in
        *" $1 "*) return 0 ;;
        *)        return 1 ;;
    esac
}

# Move an existing real file/directory out of the way.
backup() {
    local target="$1" dest="$1.backup.$STAMP"
    say "backup    $(rel "$target") -> $(rel "$dest")"
    run mv "$target" "$dest"
    backed_up=$((backed_up + 1))
}

# link <source> <target> - point <target> at <source>.
link() {
    local source="$1" target="$2" current

    if [ -L "$target" ]; then
        current="$(readlink "$target")"
        # -ef follows symlinks, so this also catches links that reach the same
        # file by a different path (e.g. a symlink checked into the repo).
        if [ "$current" = "$source" ] || [ "$target" -ef "$source" ]; then
            say "ok        $(rel "$target")"
            unchanged=$((unchanged + 1))
            return 0
        fi
        say "update    $(rel "$target") -> $(src "$source") (was $current)"
        # -n so an existing symlink-to-directory is replaced, not followed.
        run ln -sfn "$source" "$target"
        updated=$((updated + 1))
        return 0
    fi

    [ -e "$target" ] && backup "$target"

    say "create    $(rel "$target") -> $(src "$source")"
    run ln -sfn "$source" "$target"
    created=$((created + 1))
}

# link_contents <source dir> <target dir> - link each entry of <source dir>
# into <target dir>, which is created if missing. Recurses when the target
# entry is itself an existing real directory, so we never take ownership of a
# directory something else is already using.
link_contents() {
    local source="$1" target="$2" entry name

    if [ ! -d "$target" ]; then
        { [ -e "$target" ] || [ -L "$target" ]; } && backup "$target"
        say "mkdir     $(rel "$target")/"
        run mkdir -p "$target"
    fi

    for entry in "$source"/* "$source"/.[!.]*; do
        [ -e "$entry" ] || [ -L "$entry" ] || continue
        name="${entry##*/}"
        if [ -d "$entry" ] && [ ! -L "$entry" ] \
           && [ -d "$target/$name" ] && [ ! -L "$target/$name" ]; then
            link_contents "$entry" "$target/$name"
        else
            link "$entry" "$target/$name"
        fi
    done
}

cd "$REPO" || exit 1

[ "$DRY_RUN" -eq 1 ] && say "dry run: nothing will be changed"
say "repo: $REPO"
say "home: $HOME"
say ""

for entry in _*; do
    [ -e "$entry" ] || continue
    if is_shared "$entry"; then
        say "shared    $(rel "$HOME/${entry/_/.}")/ (linking contents)"
        link_contents "$REPO/$entry" "$HOME/${entry/_/.}"
    else
        link "$REPO/$entry" "$HOME/${entry/_/.}"
    fi
done

say ""
say "created: $created  updated: $updated  unchanged: $unchanged  backed up: $backed_up"
[ "$DRY_RUN" -eq 1 ] && say "dry run: nothing was changed"

exit 0
