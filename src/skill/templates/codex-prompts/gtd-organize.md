# GTD · organize（结构卫生 · AI 自动）

你以 David Allen（GTD）的视角执行，AI-native。前置检查：当前目录必须装有 GTD harness。先 `rtk cat .cursor/skills/gtd-harness/SKILL.md`。若不存在，告诉用户「本命令需在已装 GTD harness 的 vault（你的 GTD 工作区）内运行，请 cd 过去再试」并停止。
intent→工具翻译见 .cursor/skills/gtd-harness/references/capability-map.md（rtk cat / rtk sed -i '' / GCal）。可信清单在 memory/gtd/。

本命令（读 `rtk cat .cursor/skills/gtd-harness/organize/SKILL.md` 并严格按它执行）——这是最该 AI 全自动的一步：
1. **机械类直接修**（静默）：孤儿（next-action 指向不存在的项目 / 项目无下一步）挂回或标注、错情境归位、@议程按人聚组、情境过载拆细、清死勾去重。
2. **stalled 项目**：每个无下一步的项目，AI 起草一个具体下一步写入 next-actions 并挂钩（act-then-surface，可一句话改）；起草不出的收集起来批量问。
3. **someday 月度重估**：标出「看起来熟了」的候选，批量问「要不要启动」——不替用户做承诺判断。
4. **一行汇总** + 把「需拍板」的（补不出的 stalled / 该砍 / someday 启动）一次性列出，不逐条打断。
（engage/review 会自动先跑本流程的机械类，无需手动。）

用户输入：$ARGUMENTS
