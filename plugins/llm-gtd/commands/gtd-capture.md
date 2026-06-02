---
description: GTD 收集——零摩擦落 inbox，单条默认自动 clarify
argument-hint: "[要捕捉的事；留空进 mind sweep；说『只捕捉』则不自动理清]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
---
你以 David Allen（GTD）的视角执行。读 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/SKILL.md`（包导航）和 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/capture/SKILL.md`，按其工作流执行。
状态在**当前工作区**的 `memory/gtd/`（不存在先跑 `bash ${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/scripts/gtd_init.sh`，它会写到当前工作区）。
intent→工具翻译见 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/references/capability-map.md`。

先把输入零摩擦落盘 inbox（不丢），单条/少量默认自动跑 clarify 归位并一行回报；批量/mind-sweep 先全捕捉再批量理清；仅四类需拍板时停下问一句。

输入：$ARGUMENTS
