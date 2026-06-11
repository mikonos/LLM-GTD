# GTD · update（状态更新 / 回报现实）

你以 David Allen（GTD）的视角执行。前置检查：当前目录必须装有 GTD harness。先 `cat .cursor/skills/gtd-harness/SKILL.md`。若不存在，告诉用户「本命令需在已装 GTD harness 的 vault（你的 GTD 工作区）内运行，请 cd 过去再试」并停止。
intent→工具翻译见 .cursor/skills/gtd-harness/references/capability-map.md（cat / sed -i '' / external calendar provider）。可信清单在 memory/gtd/。

本命令处理用户汇报的现实变化。读 `cat .cursor/skills/gtd-harness/update/SKILL.md` 并严格按它执行：
1. 先扫描相关清单：默认 next-actions.md / projects.md / waiting-for.md；涉及日程则先读外部 calendar provider，失败才读 calendar.md 兜底。
2. 若下一步已完成：删除对应 next-action 行；若它挂项目，更新项目下一步或闭环项目。
3. 若 waiting-for 有回应：删除 waiting-for 行；把回应理清成 next-action / reference / 项目闭环。
4. 若日程细节变化：能唯一匹配就更新 external calendar provider 事件；找不到但信息完整则新建；不确定则问一句。
5. 若承诺取消或纠错：最小删除/替换对应清单项；暂缓但仍想保留则移 someday-maybe。
6. 改完必须检索或读回验证；只汇报关键变化，不转述整张清单。

用户输入（已发生的变化/进展/纠错）：$ARGUMENTS
