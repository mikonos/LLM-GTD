#!/usr/bin/env bash
# gtd-harness installer — 把 GTD harness 装到一个工作区（vault），并打通三平台触发。
#
# 用法：
#   ./install.sh [VAULT_DIR]        # 默认 VAULT_DIR = 当前目录
#   ./install.sh ~/notes            # 装到指定工作区
#
# 装什么：
#   1. skill 包          → <VAULT>/.cursor/skills/gtd-harness/
#   2. Claude Code 命令  → <VAULT>/.claude/commands/gtd*.md      （/gtd-* slash 命令）
#   3. Codex slash 命令  → ${CODEX_HOME:-~/.codex}/prompts/gtd*.md（全局，Codex 限制）
#   4. Codex agent       → <VAULT>/.codex/agents/gtd-orchestrator.toml
#   5. 跑 gtd_init.sh    → 建 <VAULT>/memory/gtd/ 八清单（幂等）
#   Cursor 关键词触发 + AGENTS.md 自动路由为手动步骤（见末尾提示）。

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT="${1:-$(pwd)}"
VAULT="$(cd "$VAULT" && pwd)"   # 绝对化
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"

echo "GTD Harness installer"
echo "  仓库：$REPO"
echo "  工作区（VAULT）：$VAULT"
echo ""

# 1. skill 包
mkdir -p "$VAULT/.cursor/skills/gtd-harness"
cp -R "$REPO/src/skill/." "$VAULT/.cursor/skills/gtd-harness/"
# 同步 Codex prompt 模板进 skill 包，保证单独跑 gtd_init.sh 也能安装/刷新 /gtd*。
mkdir -p "$VAULT/.cursor/skills/gtd-harness/templates/codex-prompts"
cp "$REPO"/src/codex-prompts/gtd*.md "$VAULT/.cursor/skills/gtd-harness/templates/codex-prompts/"
echo "✅ skill 包 → .cursor/skills/gtd-harness/"

# 2. Claude Code 命令（把 __VAULT__ 占位替换成真实绝对路径）
mkdir -p "$VAULT/.claude/commands"
for f in "$REPO"/src/claude-commands/gtd*.md; do
  sed "s|__VAULT__|$VAULT|g" "$f" > "$VAULT/.claude/commands/$(basename "$f")"
done
echo "✅ Claude Code 命令 → .claude/commands/（/gtd-* ）"

# 3. Codex slash 命令（全局；Codex prompts 只支持 CODEX_HOME 级）
mkdir -p "$CODEX_HOME_DIR/prompts"
cp "$REPO"/src/codex-prompts/gtd*.md "$CODEX_HOME_DIR/prompts/"
echo "✅ Codex slash 命令 → $CODEX_HOME_DIR/prompts/（全局 /gtd-* ）"

# 4. Codex agent
mkdir -p "$VAULT/.codex/agents"
cp "$REPO"/src/codex-agents/*.toml "$VAULT/.codex/agents/"
echo "✅ Codex agent → .codex/agents/gtd-orchestrator.toml"

# 5. 初始化可信系统
echo ""
echo "── 初始化 memory/gtd/ ──"
bash "$VAULT/.cursor/skills/gtd-harness/scripts/gtd_init.sh"

# 手动步骤提示
cat <<'NOTE'

── 两步手动接线（可选，让「说人话即触发」）──

A) Cursor 关键词触发：把 snippets/cursor-skill-rules.json 里的 "gtd-harness" 条目
   合并进你的 <VAULT>/.cursor/skill-rules.json 的 "skills" 对象。

B) Codex「说人话即触发」：把 snippets/AGENTS.routing.md 的内容追加到你的
   <VAULT>/AGENTS.md（放在工具/命令约定一节，避开任何 mirror 块）。

完成。用法：
  Claude Code：  /gtd-init  /gtd-capture  /gtd-clarify  /gtd-engage  /gtd-review
  Codex：        /gtd-*  或说人话；或 rtk cat .cursor/skills/gtd-harness/SKILL.md
  全景仪表盘：    bash .cursor/skills/gtd-harness/scripts/gtd_status.sh
NOTE
