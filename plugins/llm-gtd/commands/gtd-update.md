---
name: gtd-update
description: GTD 更新 — 处理已完成、进展、等待项回应、日程变化、取消或纠错，并推进可信清单
argument-hint: "[已发生的变化，如 '护照材料交了' '对方回了' '会议改到周三 3 点' '这个项目取消']"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
---
<objective>
GTD Update：把用户汇报的现实变化同步到可信系统。不是捕捉新任务，而是关闭已完成行动、推进项目、处理 waiting-for 回应、更新日历或纠正既有状态。
</objective>

<execution_context>
@__VAULT__/.cursor/skills/gtd-harness/SKILL.md
@__VAULT__/.cursor/skills/gtd-harness/update/SKILL.md
</execution_context>

<context>
$ARGUMENTS
</context>

<process>
按 update/SKILL.md 执行：
1. 先读相关清单：next-actions.md / projects.md / waiting-for.md；涉及日程先查外部 calendar provider。
2. 明确已完成的 next-action → 删除该行，并推进或闭环关联 project。
3. waiting-for 有回应 → 删除等待项，把回应理清为下一步、支持材料或项目闭环。
4. 日程细节变化 → 可唯一识别则更新 external calendar provider；信息完整但无事件则新建；不确定问一句。
5. 取消/纠错 → 最小删除、移动或替换对应状态。
6. 改完必须检索或读回验证，再简短报告。
</process>
