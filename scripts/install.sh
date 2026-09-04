#!/usr/bin/env bash
# install.sh — copy or symlink every skill in this repo into the local agent skills dir.
# Usage:
#   bash scripts/install.sh          # symlink into ~/.agents/skills  (DSH)
#   bash scripts/install.sh --copy   # copy (no repo dependency)
#   bash scripts/install.sh --claude # also install to ~/.claude/skills (Claude Code)
set -euo pipefail
REPO_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$REPO_PATH/skills"
TARGET="${SKILLS_TARGET:-$HOME/.agents/skills}"
if [ ! -d "$SKILL_DIR" ]; then echo "error: skills/ not found under $REPO_PATH" >&2; exit 1; fi

CLAUDE=0; COPY=0
for arg in "$@"; do
  case "$arg" in
    --claude) CLAUDE=1 ;;
    --copy)   COPY=1 ;;
  esac
done
if [ "$COPY" = 1 ]; then MODE="copy"; else MODE="link"; fi

install_into () {
  local dest="$1"
  mkdir -p "$dest"
  local count=0
  for d in "$SKILL_DIR"/*/ ; do
    [ -d "$d" ] || continue
    local name; name="$(basename "$d")"
    local link="$dest/$name"
    if [ -L "$link" ]; then rm -f "$link"; fi
    if [ -e "$link" ]; then echo "skip (exists): $link"; continue; fi
    if [ "$COPY" = 1 ]; then
      cp -R "$d" "$link"
      echo "  copy $name"
    else
      ln -s "$d" "$link"
      echo "  link $name"
    fi
    count=$((count+1))
  done
  echo "done: $count skills ($MODE) -> $dest"
}

echo "mode: $MODE"
install_into "$TARGET"
if [ "$CLAUDE" = 1 ]; then install_into "$HOME/.claude/skills"; fi
echo "Done."
