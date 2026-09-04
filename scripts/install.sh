#!/usr/bin/env bash
# install.sh — symlink every skill in this repo into the local agent skills dir.
# Usage:
#   bash scripts/install.sh          # link into ~/.agents/skills  (DSH)
#   bash scripts/install.sh --claude # also link into ~/.claude/skills (Claude Code)
set -euo pipefail
REPO_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$REPO_PATH/skills"
TARGET="${SKILLS_TARGET:-$HOME/.agents/skills}"
if [ ! -d "$SKILL_DIR" ]; then echo "error: skills/ not found under $REPO_PATH" >&2; exit 1; fi
CLAUDE=0
if [[ "${1:-}" == "--claude" ]]; then CLAUDE=1; fi

link_into () {
  local dest="$1"
  mkdir -p "$dest"
  local count=0
  for d in "$SKILL_DIR"/*/ ; do
    [ -d "$d" ] || continue
    local name; name="$(basename "$d")"
    local link="$dest/$name"
    if [ -L "$link" ]; then rm -f "$link"; fi
    if [ -e "$link" ]; then echo "skip (exists, not a link): $link"; continue; fi
    ln -s "$d" "$link"
    count=$((count+1))
  done
  echo "linked $count skills into $dest"
}
link_into "$TARGET"
if [ "$CLAUDE" = 1 ]; then link_into "$HOME/.claude/skills"; fi
echo "Done."
