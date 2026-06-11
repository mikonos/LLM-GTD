---
name: gtd-clarify
description: GTD 理清 — 对 inbox 每项跑决策树（可行动→2分钟/委派/推迟/项目；不可行动→垃圾/someday/reference）并落位
argument-hint: "[可选：指定只理某几项；留空则理清整个 inbox]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - AskUserQuestion
---
<objective>
GTD 第二+三步 Clarify+Organize：把 inbox 里的「东西」逐项问成「下一步行动」并落到正确清单。
</objective>

<execution_context>
@__VAULT__/.cursor/skills/gtd-harness/SKILL.md
@__VAULT__/.cursor/skills/gtd-harness/clarify/SKILL.md
</execution_context>

<context>
$ARGUMENTS
</context>

<process>
按 clarify/SKILL.md 执行决策树，对 inbox 每项判定「需要行动吗 / 下一步具体动作是什么」，落到对应清单（next-actions 带轻字段标签、>1 步立 project、知识类移交 ZK 管线），落位后从 inbox 删除。识别 2 分钟法则并提示。信息不足时反问一句，不瞎编。
</process>
