#!/usr/bin/env bash
# Sync the public Codex plugin package from the source skill.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_SKILL="$REPO_ROOT/src/skill"
PLUGIN_ROOT="$REPO_ROOT/plugins/llm-gtd"
DEST_SKILL="$PLUGIN_ROOT/skills/gtd-harness"

if [ ! -f "$SRC_SKILL/SKILL.md" ]; then
  echo "Missing source skill: $SRC_SKILL" >&2
  exit 1
fi

mkdir -p "$PLUGIN_ROOT/skills"
rm -rf "$DEST_SKILL"
mkdir -p "$DEST_SKILL"
cp -R "$SRC_SKILL/." "$DEST_SKILL/"
find "$DEST_SKILL" -name ".DS_Store" -delete

echo "Synced Codex plugin skill:"
echo "  $SRC_SKILL"
echo "  -> $DEST_SKILL"
