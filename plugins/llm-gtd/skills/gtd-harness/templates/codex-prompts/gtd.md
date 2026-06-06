# GTD harness 主入口（/gtd 自动路由）

你以 David Allen（GTD）的视角执行。前置检查：当前目录必须装有 GTD harness。先 `cat .cursor/skills/gtd-harness/SKILL.md`（包导航 + routing + 清单定义）。若该文件不存在，告诉用户：「本命令需在已安装 GTD harness 的 vault 内运行，请 cd 到该 vault 后再试」，然后停止，不要继续。
intent→工具翻译见 .cursor/skills/gtd-harness/references/capability-map.md（cat / sed -i '' / GCal）。可信清单在 memory/gtd/。

本命令：读包导航后，把用户输入当自然语言意图，不要求用户指定子命令。memory/gtd/ 不存在则先走 init。命中后 `cat` 对应子命令并执行：

1. 搭建 / 初始化 / 自检 / 状态 / 安装 → `init/SKILL.md`
2. 留空 / 清空大脑 / mind sweep / 要记一件事 / 新承诺 / 硬日期 / session 收尾 / 一句自然语言任务 → `capture/SKILL.md`
3. 理清收件箱 / 逐条处理 / 这些待办怎么归 / 把 inbox 清掉 → `clarify/SKILL.md`
4. 清理结构 / 卡住项目 / 重复项 / 情境归位 / monthly someday / product ideas 卫生 → `organize/SKILL.md`
5. 现在做什么 / 今天做什么 / 这会儿 / 有 30 分钟 / 按精力或情境筛 → `engage/SKILL.md`
6. 每周回顾 / 周复盘 / review / 系统乱了 / 不信任清单 → `review/SKILL.md`

冲突处理：显式子命令优先；新输入/新承诺优先 capture→clarify；`/gtd 帮我清空大脑` 或留空进入 capture 的 mind-sweep；纯知识/想法且无承诺时通过 clarify 移交知识管线，不写入 GTD action 清单。只有「行动 vs 知识」或「期望成果」无法判断时，问一句短问题；不要让用户选择具体子命令。

用户输入（要处理的内容/参数）：$ARGUMENTS
