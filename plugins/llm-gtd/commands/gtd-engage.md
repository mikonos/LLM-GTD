---
name: gtd-engage
description: GTD 执行 — 按情境/可用时间/精力/优先级，从清单给出「现在该做什么」
argument-hint: "[可选：当前情境/可用时间/精力，如 '@电脑 有1小时 精力中']"
allowed-tools:
  - Read
  - Bash
---
<objective>
GTD 第五步 Engage：用四要素模型从 next-actions 筛出「此刻最该做」的候选。
</objective>

<execution_context>
@__VAULT__/.cursor/skills/gtd-harness/SKILL.md
@__VAULT__/.cursor/skills/gtd-harness/engage/SKILL.md
</execution_context>

<context>
$ARGUMENTS
</context>

<process>
按 engage/SKILL.md 执行：问清/推断情境+时间+精力，从 next-actions 筛 3-5 条候选并标时长，优先级向上对照 horizons，顺带点出今天的硬约定与该催的等待项。缺要素时反问一句。
</process>
