---
name: gtd-capture
description: GTD 收集 — 零摩擦落盘 inbox，然后默认自动 clarify 归位（单条）；批量/mind-sweep 先全捕捉再批量理清
argument-hint: "[要捕捉的事，可多条；留空进 mind sweep；说『只捕捉』则不自动理清]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
---
<objective>
GTD 第一步 Capture（AI-native）：先零摩擦落盘 memory/gtd/inbox.md（保证不丢），然后默认替用户自动 clarify 归位——你是 AI，切换成本≈0，不该让用户手动跑第二步。
</objective>

<execution_context>
@__VAULT__/.cursor/skills/gtd-harness/SKILL.md
@__VAULT__/.cursor/skills/gtd-harness/capture/SKILL.md
</execution_context>

<context>
$ARGUMENTS
</context>

<process>
按 capture/SKILL.md 执行：
1. 先把 $ARGUMENTS 每项原样落盘 inbox.md（保证不丢）。
2. 单条/少量 → 默认自动跑 clarify 决策树，理清归位到正确清单 + 定下一步，从 inbox 删除，一行回报去向（act-then-surface，可一句话纠错）。
3. 批量/留空 mind sweep → 先全捕捉，再一次性问「要现在逐条理清吗」。
4. 仅四类需拍板时停下问一句（行动vs知识/推不出下一步/隐含承诺/项目成果不清）。
5. 用户说「只捕捉/先别理」→ 纯落盘不自动理清。
</process>
