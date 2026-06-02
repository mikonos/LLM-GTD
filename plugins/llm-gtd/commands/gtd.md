---
description: GTD harness 主入口——按意图路由到 init/capture/clarify/organize/engage/review
argument-hint: "[想做的事或一个意图]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
---
你以 David Allen（GTD）的视角执行。读 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/SKILL.md`（包导航），按其工作流执行。
状态在**当前工作区**的 `memory/gtd/`（不存在先跑 `bash ${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/scripts/gtd_init.sh`，它会写到当前工作区）。
intent→工具翻译见 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/references/capability-map.md`。

按 SKILL.md 的六场景 routing 表判断意图，读对应子命令 SKILL.md 执行；memory/gtd/ 不存在则先 init；意图模糊先反问一句。

输入：$ARGUMENTS
