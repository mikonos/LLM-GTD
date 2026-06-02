#!/usr/bin/env bash
# gtd_review_prep.sh — 只读生成每周回顾预处理包，不修改任何清单。
# 用法：bash gtd_review_prep.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/gtd_env.sh"
VAULT_ROOT="$GTD_WORKSPACE_ROOT"
GTD_DIR="$VAULT_ROOT/memory/gtd"

if [ ! -d "$GTD_DIR" ]; then
  echo "memory/gtd/ 不存在。先跑：bash .cursor/skills/gtd-harness/scripts/gtd_init.sh"
  exit 1
fi

file() {
  printf "%s/%s" "$GTD_DIR" "$1"
}

section() {
  echo ""
  echo "## $1"
}

open_items() {
  local path="$1"
  if [ -f "$path" ]; then
    grep -nE '^- \[ \] |^- ' "$path" 2>/dev/null || true
  fi
}

stalled_projects() {
  local f
  f="$(file projects.md)"
  [ -f "$f" ] || return 0
  awk '
    /^## / {
      if (in_project && !has_valid_next) print project
      in_project=1
      has_valid_next=0
      project=$0
      sub(/^## /, "", project)
      next
    }
    in_project && /^- 下一步行动：/ {
      if ($0 !~ /下一步行动：([[:space:]]*)?(无|没有|无需|不需要|已完成|安排已确认|none|None|N\/A)/) {
        has_valid_next=1
      }
    }
    END {
      if (in_project && !has_valid_next) print project
    }
  ' "$f"
}

vague_next_actions() {
  local f
  f="$(file next-actions.md)"
  [ -f "$f" ] || return 0
  grep -nE '^- \[ \] .*(跟进|处理|推进|研究|看看|了解|想想|弄一下|搞一下)' "$f" 2>/dev/null || true
}

today="$(date +%Y-%m-%d)"

echo "GTD Review Prep · $today"
echo "只读预回顾包：用于 review 前扫描，不修改 memory/gtd/。"

if [ -x "$SCRIPT_DIR/gtd_status.sh" ]; then
  echo ""
  "$SCRIPT_DIR/gtd_status.sh"
else
  section "Dashboard"
  echo "未找到 gtd_status.sh。"
fi

section "Inbox 待理清"
inbox_items="$(open_items "$(file inbox.md)")"
if [ -n "$inbox_items" ]; then
  echo "$inbox_items" | sed -n '1,12p'
  inbox_total="$(printf "%s\n" "$inbox_items" | wc -l | tr -d ' ')"
  [ "$inbox_total" -gt 12 ] && echo "... 另有 $((inbox_total - 12)) 项"
else
  echo "无。"
fi

section "Stalled Projects"
stalled="$(stalled_projects)"
if [ -n "$stalled" ]; then
  echo "$stalled" | sed 's/^/- /'
else
  echo "无。"
fi

section "Waiting For"
waiting_items="$(open_items "$(file waiting-for.md)")"
if [ -n "$waiting_items" ]; then
  echo "$waiting_items"
else
  echo "无。"
fi

section "Next Action 卫生"
vague="$(vague_next_actions)"
if [ -n "$vague" ]; then
  echo "疑似空动词 / 模糊动作："
  echo "$vague"
else
  echo "未发现明显空动词。"
fi

section "Someday/Maybe 候选"
someday_items="$(open_items "$(file someday-maybe.md)")"
if [ -n "$someday_items" ]; then
  echo "$someday_items"
else
  echo "无。"
fi

section "确认队列"
echo "- 清空 inbox：逐项 clarify 到零。"
echo "- stalled projects：为每个项目补一个具体下一步，或确认砍掉。"
echo "- waiting-for：确认哪些要催，AI 可先起草中性话术。"
echo "- someday/maybe：确认是否启动、删除或继续孵化。"
echo "- 下周 3 件事：由 AI 给候选，用户最后确认。"
