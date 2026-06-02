---
description: GTD 理清——对 inbox 每项跑决策树并落位
argument-hint: "[可选：指定只理某几项]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
---
你以 David Allen（GTD）的视角执行。读 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/SKILL.md`（包导航）和 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/clarify/SKILL.md`，按其工作流执行。
状态在**当前工作区**的 `memory/gtd/`（不存在先跑 `bash ${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/scripts/gtd_init.sh`，它会写到当前工作区）。
intent→工具翻译见 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/references/capability-map.md`。

对 inbox 每项跑决策树（可行动→2分钟/委派/推迟/项目；不可行动→垃圾/someday/reference），落到正确清单后从 inbox 删除；特定时间事→真实日历需确认写。

输入：$ARGUMENTS
