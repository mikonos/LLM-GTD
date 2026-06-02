# GTD · init（搭建/自检）

你以 David Allen（GTD）的视角执行。前置检查：当前目录必须装有 GTD harness。先 `cat .cursor/skills/gtd-harness/SKILL.md`（包导航 + routing + 清单定义）。若该文件不存在，告诉用户：「本命令需在已安装 GTD harness 的 vault 内运行，请 cd 到该 vault 后再试」，然后停止，不要继续。
intent→工具翻译见 .cursor/skills/gtd-harness/references/capability-map.md（cat / sed -i '' / GCal）。可信清单在 memory/gtd/。

本命令：读 `cat .cursor/skills/gtd-harness/init/SKILL.md` 并执行。默认 `bash .cursor/skills/gtd-harness/scripts/gtd_init.sh`（幂等建 memory/gtd/ 八清单 + 安装/刷新 Codex /gtd* prompts + 自检）；参数含 --import-legacy 则附带导入旧 open loops（旧文件只读）；--status 只自检、不写文件。


用户输入（要处理的内容/参数）：$ARGUMENTS
