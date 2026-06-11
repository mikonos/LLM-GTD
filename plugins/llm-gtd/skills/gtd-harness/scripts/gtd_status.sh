#!/usr/bin/env bash
# gtd_status.sh — 读 memory/gtd/ 全部清单，产出 GTD dashboard（纯 bash，三平台通用）
# 用法：bash gtd_status.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/gtd_env.sh"
VAULT_ROOT="$GTD_WORKSPACE_ROOT"
GTD_DIR="$VAULT_ROOT/memory/gtd"

if [ ! -d "$GTD_DIR" ]; then
  echo "memory/gtd/ 不存在。先跑：bash gtd_init.sh"
  exit 1
fi

# grep -c 在 0 命中时仍打印 "0" 但退出码为 1 —— 用 || true 吞掉退出码，单值返回
cnt() {
  local n
  n=$(grep -cE "$1" "$2" 2>/dev/null) || true
  echo "${n:-0}"
}

# 统计某文件中 "- [ ] " 开头的未完成项
count_open() {
  local f="$GTD_DIR/$1"
  [ -f "$f" ] || { echo 0; return; }
  cnt '^- \[ \] ' "$f"
}

# inbox 待理清：bullet 行
count_inbox() {
  local f="$GTD_DIR/inbox.md"
  [ -f "$f" ] || { echo 0; return; }
  cnt '^- ' "$f"
}

# projects：## 项目块数（GTD-native 项目用 ## ）
count_projects() {
  local f="$GTD_DIR/projects.md"
  [ -f "$f" ] || { echo 0; return; }
  cnt '^## ' "$f"
}

# stalled projects：无有效「下一步行动」block link 的项目；「下一步行动：无」按残留处理
count_stalled() {
  local f="$GTD_DIR/projects.md"
  [ -f "$f" ] || { echo 0; return; }
  awk '
    function has_action_link(line) {
      return line ~ /\[\[(next-actions|waiting-for)#\^/
    }
    function invalid_next_heading(line) {
      return line ~ /下一步行动：([[:space:]]*)?(无|没有|无需|不需要|已完成|安排已确认|none|None|N\/A)/
    }
    /^## / {
      if (in_project && !has_valid_next) stalled++
      in_project=1
      has_valid_next=0
      in_next_section=0
      next
    }
    in_project && /^- 下一步行动：/ {
      in_next_section=1
      if (has_action_link($0)) {
        has_valid_next=1
      }
      if (invalid_next_heading($0)) {
        in_next_section=0
      }
      next
    }
    in_project && in_next_section && /^- / {
      in_next_section=0
    }
    in_project && in_next_section && has_action_link($0) {
      has_valid_next=1
    }
    END {
      if (in_project && !has_valid_next) stalled++
      print stalled + 0
    }
  ' "$f"
}

# calendar：日期行
count_calendar() {
  local f="$GTD_DIR/calendar.md"
  [ -f "$f" ] || { echo 0; return; }
  cnt '^- [0-9]{4}-[0-9]{2}-[0-9]{2}' "$f"
}

echo "════════════════════════════════════"
echo "  GTD Dashboard · memory/gtd/"
echo "════════════════════════════════════"
printf "  📥 Inbox 待理清       : %s\n" "$(count_inbox)"
printf "  ✅ Next Actions       : %s\n" "$(count_open next-actions.md)"
printf "  🎯 Projects           : %s（其中 stalled≈ %s）\n" "$(count_projects)" "$(count_stalled)"
printf "  ⏳ Waiting For        : %s\n" "$(count_open waiting-for.md)"
printf "  📅 Calendar 硬地形    : %s\n" "$(count_calendar)"
printf "  💭 Someday/Maybe      : %s\n" "$(count_open someday-maybe.md)"
printf "  💡 Product Ideas      : %s\n" "$(count_open product-ideas.md)"
echo "────────────────────────────────────"

# 提醒信号
inbox_n=$(count_inbox)
stalled_n=$(count_stalled)
[ "$inbox_n" -gt 0 ] && echo "  ⚠️  收件箱有 $inbox_n 项未理清 → 跑 /gtd-clarify"
[ "$stalled_n" -gt 0 ] && echo "  ⚠️  约 $stalled_n 个项目缺有效下一步或为已完成残留 → /gtd-organize"
echo "  🔭 每周回顾（Reflect）是关键成功因子 → /gtd-review"
echo "════════════════════════════════════"
