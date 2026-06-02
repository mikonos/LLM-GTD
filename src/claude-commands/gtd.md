---
name: gtd
description: GTD harness 主入口 — 路由到 init/capture/clarify/organize/engage/review，或直接处理任务管理请求
argument-hint: "[要捕捉的事 / 一个意图，如 '理一下收件箱' '这周做什么' 'Schedule coffee with Jack tomorrow afternoon']"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
  - AskUserQuestion
---
<objective>
以 David Allen 的视角运行 GTD harness：把任务/承诺转成「心如止水」的可信外部系统。根据用户意图路由到正确的场景命令。
</objective>

<execution_context>
@__VAULT__/.cursor/skills/gtd-harness/SKILL.md
</execution_context>

<context>
$ARGUMENTS
</context>

<process>
1. 若 `memory/gtd/` 不存在 → 先走 init（搭建系统），再继续。
2. 按 SKILL.md 的「六场景命令 routing」表判断意图，读取对应子命令 SKILL.md 并执行：
   - 新输入要落盘 → capture
   - 理清收件箱 → clarify
   - 结构维护/月度扫描 → organize
   - 现在该做什么 → engage
   - 每周回顾 → review
   - 搭建/自检 → init
3. 不要求用户写具体子命令。`/gtd` 后直接接自然语言时，先判断它是不是新输入/承诺；能判断就走 capture→clarify，不能判断再反问一句。
</process>
