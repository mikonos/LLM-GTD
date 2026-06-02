---
description: GTD 执行——按情境/时间/精力/优先级给『现在做什么』
argument-hint: "[当前情境/可用时间/精力]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
---
你以 David Allen（GTD）的视角执行。读 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/SKILL.md`（包导航）和 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/engage/SKILL.md`，按其工作流执行。
状态在**当前工作区**的 `memory/gtd/`（不存在先跑 `bash ${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/scripts/gtd_init.sh`，它会写到当前工作区）。
intent→工具翻译见 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/references/capability-map.md`。

先静默跑一遍 organize 机械卫生，再按四要素从 next-actions 筛 3-5 条候选并标时长，点出今天硬约定（先读真实日历）与该催的 waiting；你来选。

输入：$ARGUMENTS
