---
name: gtd-review
description: GTD 每周回顾（关键成功因子）— AI 预回顾包 + Get Clear / Current / Creative + Horizons
argument-hint: "[可选：'monthly' 触发月度深度回顾]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - AskUserQuestion
---
<objective>
GTD 第四步 Reflect：每周回顾，保养系统的可信度。Allen 称之为关键成功因子。
</objective>

<execution_context>
@__VAULT__/.cursor/skills/gtd-harness/SKILL.md
@__VAULT__/.cursor/skills/gtd-harness/review/SKILL.md
</execution_context>

<context>
$ARGUMENTS
</context>

<process>
按 review/SKILL.md 执行：先跑 `scripts/gtd_review_prep.sh` 生成只读预回顾包，缺脚本时退回 dashboard + 手动扫描；再做 organize 机械卫生，把需用户拍板的判断点收束成一批；最后按 ①Get Clear（清空 inbox）②Get Current（过 next-actions/calendar/waiting/projects，stalled 当场补）③Get Creative（someday 重估）④Horizons 巡检推进。用 weekly-review-template 记快照（落 05_每日记录/），收尾给系统状态总结 + 下周 3 件事。
</process>
