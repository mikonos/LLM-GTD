---
name: gtd-init
description: 搭建/自检 GTD 可信系统 — 幂等建 memory/gtd/ 八清单 + 适配层自检（可选导入旧 open loops）
argument-hint: "[可选：--import-legacy 导入旧数据 / --status 只自检]"
allowed-tools:
  - Read
  - Bash
  - Glob
---
<objective>
首次启用或重装 GTD harness：幂等搭建 memory/gtd/ 八清单、自检三平台适配层、可选导入旧 open loops。
</objective>

<execution_context>
@__VAULT__/.cursor/skills/gtd-harness/SKILL.md
@__VAULT__/.cursor/skills/gtd-harness/init/SKILL.md
</execution_context>

<context>
$ARGUMENTS
</context>

<process>
按 init/SKILL.md 执行。默认跑幂等初始化；若 $ARGUMENTS 含 --import-legacy 则附带一次性导入（旧文件只读不改）；--status 则只自检不写文件。读就绪报告并引导用户跑第一次 capture。
</process>
