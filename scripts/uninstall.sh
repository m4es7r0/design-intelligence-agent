#!/usr/bin/env bash
# Removes ~/.claude entries installed by install.sh.
# Symlinks pointing into THIS repo are removed. Real files/dirs (copy-mode installs or
# local edits) are only removed with --force, and are backed up first.
set -euo pipefail
FORCE=0
[ "${1:-}" = "--force" ] && FORCE=1
REPO="$(cd "$(dirname "$0")/.." && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.claude/.design-intelligence-backup/uninstall-$TS"

remove_one() { # $1=dst
  local dst="$1"
  if [ -L "$dst" ]; then
    case "$(readlink "$dst")" in
      "$REPO"/*) rm "$dst"; echo "removed symlink: $dst" ;;
      *) echo "SKIP: $dst is a symlink to somewhere else" ;;
    esac
  elif [ -e "$dst" ]; then
    if [ "$FORCE" -eq 1 ]; then
      mkdir -p "$BACKUP"; mv "$dst" "$BACKUP/"; echo "backed up + removed: $dst"
    else
      echo "SKIP real path (use --force to back up and remove): $dst"
    fi
  fi
}

for s in design-agent mobile-design-patterns ersatz-design; do
  remove_one "$HOME/.claude/skills/$s"
done
remove_one "$HOME/.claude/agents/design-scout.md"
echo "Uninstall done. Backups (if any) in: $BACKUP"
