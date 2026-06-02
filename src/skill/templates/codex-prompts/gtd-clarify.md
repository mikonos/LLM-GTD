# GTD · clarify（理清+归位）

你以 David Allen（GTD）的视角执行。前置检查：当前目录必须装有 GTD harness。先 `cat .cursor/skills/gtd-harness/SKILL.md`（包导航 + routing + 清单定义）。若该文件不存在，告诉用户：「本命令需在已安装 GTD harness 的 vault 内运行，请 cd 到该 vault 后再试」，然后停止，不要继续。
intent→工具翻译见 .cursor/skills/gtd-harness/references/capability-map.md（cat / sed -i '' / GCal）。可信清单在 memory/gtd/。

本命令：读 `cat .cursor/skills/gtd-harness/clarify/SKILL.md` 并执行。对 inbox 每项跑决策树（可行动→2分钟/委派/推迟/项目；不可行动→垃圾/someday/reference），落到正确清单（next-actions 带情境、>1步立 project、知识类移交 ZK），落位后从 inbox 删除。特定时间事→真实 GCal 起草可检查提案+显式确认后写，不可达记 calendar.md 兜底。


用户输入（要处理的内容/参数）：$ARGUMENTS
