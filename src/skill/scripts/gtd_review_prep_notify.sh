#!/usr/bin/env bash
# gtd_review_prep_notify.sh — run the read-only weekly review prep and notify locally.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORT="$VAULT_ROOT/memory/gtd-review-prep-latest.md"
LOG="$VAULT_ROOT/memory/gtd-review-prep-launchd.log"

{
  echo "# GTD 每周预回顾"
  echo ""
  echo "- 生成时间：$(date '+%Y-%m-%d %H:%M:%S %Z')"
  echo "- 边界：只读扫描；不修改 memory/gtd/；不写日历；不发消息；不删除或移动清单。"
  echo ""
  "$SCRIPT_DIR/gtd_review_prep.sh"
} > "$REPORT"

{
  echo "[$(date '+%Y-%m-%d %H:%M:%S %Z')] wrote $REPORT"
} >> "$LOG"

if command -v osascript >/dev/null 2>&1; then
  osascript -e 'display notification "预回顾包已生成：memory/gtd-review-prep-latest.md" with title "GTD 每周回顾"' >/dev/null 2>&1 || true
fi
