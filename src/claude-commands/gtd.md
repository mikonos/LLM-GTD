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
1. 先读 GTD harness 包导航。若 `memory/gtd/` 不存在，先读取 `init/SKILL.md` 并执行 init，再继续处理用户输入。
2. 把 $ARGUMENTS 当自然语言意图，不要求用户指定子命令。按以下优先级路由；命中后读取对应子命令 `SKILL.md` 并执行：
   - 搭建 / 初始化 / 自检 / 状态 / 安装 → `init/SKILL.md`
   - 留空 / 清空大脑 / mind sweep / 要记一件事 / 新承诺 / 硬日期 / session 收尾 / 一句自然语言任务 → `capture/SKILL.md`
   - 理清收件箱 / 逐条处理 / 这些待办怎么归 / 把 inbox 清掉 → `clarify/SKILL.md`
   - 清理结构 / 卡住项目 / 重复项 / 情境归位 / monthly someday / product ideas 卫生 → `organize/SKILL.md`
   - 现在做什么 / 今天做什么 / 这会儿 / 有 30 分钟 / 按精力或情境筛 → `engage/SKILL.md`
   - 每周回顾 / 周复盘 / review / 系统乱了 / 不信任清单 → `review/SKILL.md`
3. 冲突处理：
   - 用户显式写了子命令意图时尊重显式意图。
   - 句子本身是新输入/新承诺时，优先 capture→clarify，不先讲 GTD 理论。
   - `/gtd 帮我清空大脑` 或 `/gtd` 留空时，进入 capture 的 mind-sweep 流程，先请用户逐行倾倒。
   - 纯知识/想法且无承诺时，通过 clarify 闸口移交 ZK 管线，不写入 GTD action 清单。
4. 只有「行动 vs 知识」或「期望成果」无法判断时，问一句短问题；不要让用户选择具体子命令。
</process>
