# GTD harness 主入口（路由）

你以 David Allen（GTD）的视角执行。前置检查：当前目录必须装有 GTD harness。先 `rtk cat .cursor/skills/gtd-harness/SKILL.md`（包导航 + routing + 清单定义）。若该文件不存在，告诉用户：「本命令需在已装 GTD harness 的 vault 内运行（如 你的主工作区 或 你的 Codex 工作区），请 cd 过去再试」，然后停止，不要继续。
intent→工具翻译见 .cursor/skills/gtd-harness/references/capability-map.md（rtk cat / rtk sed -i '' / GCal）。可信清单在 memory/gtd/。

本命令：读包导航后，按「六场景命令 routing」表判断用户意图，`rtk cat` 对应子命令并执行。memory/gtd/ 不存在则先走 init。意图模糊先反问一句。


用户输入（要处理的内容/参数）：$ARGUMENTS
