---
name: gtd-organize
description: GTD 结构卫生（AI 自动）— 机械类（孤儿/stalled/情境/死勾/重复）自动修，只把需你拍板的浮上来
argument-hint: "[可选：'someday 月度扫描' 或指定清单]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
---
<objective>
GTD 第三步结构卫生（AI-native）：这是最该 AI 全自动的一步。机械类记账（孤儿、stalled、情境归位、死勾、去重）自动修；只有真需用户拍板的（补不出的 stalled / 该砍 / someday 启动）才浮上来。
</objective>

<execution_context>
@__VAULT__/.cursor/skills/gtd-harness/SKILL.md
@__VAULT__/.cursor/skills/gtd-harness/organize/SKILL.md
</execution_context>

<context>
$ARGUMENTS
</context>

<process>
按 organize/SKILL.md 执行：1) 机械类直接修——孤儿挂回、错情境归位、@议程按人聚组、情境过载拆细、清死勾去重；2) stalled 项目 AI 起草下一步写入并挂钩（act-then-surface），起草不出的批量问；3) 月度标出 someday 成熟候选批量问启动；4) 一行汇总自动改了什么 + 把需拍板的一次性列出。不逐条打断、不替用户做承诺/砍项目判断。
</process>
