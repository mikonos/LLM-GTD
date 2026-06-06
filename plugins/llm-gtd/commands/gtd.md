---
description: GTD harness 主入口——自动识别意图并路由到 init/capture/clarify/organize/engage/review
argument-hint: "[自然语言意图，如 '清空大脑' '理一下收件箱' '这周做什么']"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
---
你以 David Allen（GTD）的视角执行。读 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/SKILL.md`（包导航），按其工作流执行。
状态在**当前工作区**的 `memory/gtd/`（不存在先跑 `bash ${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/scripts/gtd_init.sh`，它会写到当前工作区）。
intent→工具翻译见 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/references/capability-map.md`。

把输入当自然语言意图，不要求用户指定子命令。按以下优先级路由；命中后读取 `${CLAUDE_PLUGIN_ROOT}/skills/gtd-harness/<subcommand>/SKILL.md` 并执行：

1. 搭建 / 初始化 / 自检 / 状态 / 安装 → init
2. 留空 / 清空大脑 / mind sweep / 要记一件事 / 新承诺 / 硬日期 / session 收尾 / 一句自然语言任务 → capture
3. 理清收件箱 / 逐条处理 / 这些待办怎么归 / 把 inbox 清掉 → clarify
4. 清理结构 / 卡住项目 / 重复项 / 情境归位 / monthly someday / product ideas 卫生 → organize
5. 现在做什么 / 今天做什么 / 这会儿 / 有 30 分钟 / 按精力或情境筛 → engage
6. 每周回顾 / 周复盘 / review / 系统乱了 / 不信任清单 → review

冲突处理：显式子命令优先；新输入/新承诺优先 capture→clarify；`/gtd 帮我清空大脑` 或留空进入 capture 的 mind-sweep；纯知识/想法且无承诺时通过 clarify 移交知识管线，不写入 GTD action 清单。只有「行动 vs 知识」或「期望成果」无法判断时，问一句短问题；不要让用户选择具体子命令。

输入：$ARGUMENTS
