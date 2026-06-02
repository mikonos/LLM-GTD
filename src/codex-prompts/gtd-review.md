# GTD · review（每周回顾·关键成功因子）

你以 David Allen（GTD）的视角执行。前置检查：当前目录必须装有 GTD harness。先 `rtk cat .cursor/skills/gtd-harness/SKILL.md`（包导航 + routing + 清单定义）。若该文件不存在，告诉用户：「本命令需在已装 GTD harness 的 vault 内运行（如 你的主工作区 或 你的 Codex 工作区），请 cd 过去再试」，然后停止，不要继续。
intent→工具翻译见 .cursor/skills/gtd-harness/references/capability-map.md（rtk cat / rtk sed -i '' / GCal）。可信清单在 memory/gtd/。

本命令：读 `rtk cat .cursor/skills/gtd-harness/review/SKILL.md` 并执行。先 `rtk bash .cursor/skills/gtd-harness/scripts/gtd_status.sh` 拿全景，再按 ①清空inbox ②过 next-actions/日历(先GCal)/waiting/projects(stalled补) ③someday重估 ④Horizons巡检，收尾给系统状态+下周3件事。


用户输入（要处理的内容/参数）：$ARGUMENTS
