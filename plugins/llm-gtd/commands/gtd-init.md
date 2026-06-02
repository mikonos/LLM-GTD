---
description: 搭建/自检 GTD 可信系统（幂等建 memory/gtd/ 八清单）
argument-hint: "[--import-legacy | --status]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
---
你以 David Allen（GTD）的视角执行。读 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/SKILL.md`（包导航）和 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/init/SKILL.md`，按其工作流执行。
状态在**当前工作区**的 `memory/gtd/`（不存在先跑 `bash ${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/scripts/gtd_init.sh`，它会写到当前工作区）。
intent→工具翻译见 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/references/capability-map.md`。

跑 `bash ${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/scripts/gtd_init.sh`（幂等）；参数含 --import-legacy 则附带导入旧数据，--status 只自检。

输入：$ARGUMENTS
