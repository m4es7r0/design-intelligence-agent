#!/usr/bin/env bash
# Idempotent installer for the design-intelligence-agent bundle.
# Default: symlink mode (repo = source of truth). --copy = portable copy mode.
# --force  = allow replacing an existing REAL file/dir — required in BOTH modes;
#            the replaced path is backed up first.
# Re-running is always safe: existing correct symlinks are left untouched.
set -euo pipefail
MODE=link; FORCE=0
for a in "$@"; do
  case "$a" in
    --copy) MODE=copy ;;
    --force) FORCE=1 ;;
    -h|--help) echo "usage: scripts/install.sh [--copy] [--force]"; exit 0 ;;
    *) echo "unknown argument: $a"; exit 2 ;;
  esac
done
REPO="$(cd "$(dirname "$0")/.." && pwd)"
[ -f "$REPO/skills/design-agent/SKILL.md" ] || { echo "FATAL: run from the repo (skills/design-agent/SKILL.md not found)"; exit 2; }
TS="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.claude/.design-intelligence-backup/$TS"
mkdir -p "$HOME/.claude/skills" "$HOME/.claude/agents"
FAIL=0

install_one() { # $1=src $2=dst
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    if [ "$(readlink "$dst")" = "$src" ] && [ "$MODE" = link ]; then
      echo "ok (already linked): $dst"; return
    fi
    mkdir -p "$BACKUP"; mv "$dst" "$BACKUP/"; echo "backed up old symlink: $dst"
  elif [ -e "$dst" ]; then
    if [ "$FORCE" -ne 1 ]; then
      echo "REFUSING to replace real path $dst — re-run with --force (it will be backed up)"; FAIL=1; return
    fi
    mkdir -p "$BACKUP"; mv "$dst" "$BACKUP/"; echo "backed up: $dst -> $BACKUP/"
  fi
  if [ "$MODE" = link ]; then ln -s "$src" "$dst"; echo "linked: $dst"
  else cp -R "$src" "$dst"; echo "copied: $dst"; fi
}

for s in design-agent mobile-design-patterns ersatz-design; do
  install_one "$REPO/skills/$s" "$HOME/.claude/skills/$s"
done
install_one "$REPO/agents/design-scout.md" "$HOME/.claude/agents/design-scout.md"

[ "$FAIL" -eq 0 ] || { echo "Install incomplete — see REFUSING lines above."; exit 1; }
"$REPO/scripts/validate.sh" "$REPO"
echo "Install complete ($MODE mode). Backups (if any) in: $BACKUP"
