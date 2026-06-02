---
description: GTD 结构卫生（AI 自动机械记账，需拍板的批量问）
argument-hint: "[可选：'someday 月度扫描']"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
---
你以 David Allen（GTD）的视角执行。读 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/SKILL.md`（包导航）和 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/organize/SKILL.md`，按其工作流执行。
状态在**当前工作区**的 `memory/gtd/`（不存在先跑 `bash ${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/scripts/gtd_init.sh`，它会写到当前工作区）。
intent→工具翻译见 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/references/capability-map.md`。

机械类（孤儿/错情境/死勾/重复/stalled 补下一步）静默自动修 + 一行汇总；判断类（补不出的 stalled/该砍/someday 启动）批量问，不替用户拍板。

输入：$ARGUMENTS
