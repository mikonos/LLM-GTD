# gtd-harness 演化日志

## v1.0 — 首版
David Allen GTD × Karpathy「Agent = LLM + harness」。四层 harness：
- **状态层**：`memory/gtd/` 八清单（GTD-native，next-actions 按情境分组）
- **逻辑层**：六命令 SKILL.md（平台中立，无工具名）
- **适配层**：三平台薄入口 + `capability-map.md`
- **节律层**：每周回顾命令（cron 可选，不默认开）

设计原则：
- 按 GTD 第一性原理独立建系统；若工作区已有别的待办系统，本包独立共存，可选 `init --import-legacy` 一次性导入。
- next-actions 按情境分组（@电脑/@电话/@外出/@家/@议程-人），回归真正的 GTD 模型。
- `init` 作为首次运行/重装入口（幂等自检）——harness 必须能自我初始化。
- **Allen × Luhmann 接缝**：捕捉共享、clarify 分流。行动进 GTD，知识进笔记系统。不重造捕捉。

## v1.1 — 日历复用（GCal 读+确认写）
- **单一日历**：真实 Google Calendar 可达时为唯一 hard landscape，`calendar.md` 退为不可达兜底，不抄副本（Allen 双日历铁律）。
- **读**：engage 读今天硬约定、review 读本周 hard landscape，先 GCal、不可达降级。
- **写（旧策略）**：v1.1 曾采用确认门；当前写入规则已由 v1.10 改为完整日程自动写入。

## v1.2 — Codex slash 命令 + 三平台触发齐活
- Codex `~/.codex/prompts/gtd*.md`（7 条），vault 感知 fail-soft（Codex prompts 仅全局，无项目级）。
- AGENTS.md 自动路由，Codex「说人话即触发」。
- 三平台触发：cc `/gtd-*`（项目级命令）· Cursor 关键词（skill-rules）· Codex `/gtd-*` + AGENTS 路由 + orchestrator agent。同一真源、同一 `memory/gtd/`。

## v1.3 — capture 默认自动 clarify（AI-native）
- Allen 原把 capture/clarify 分开是为人脑（切决策模式有成本）；AI 切换成本≈0，故默认 capture→自动 clarify。
- 保留两条真智慧：① 落盘永远第一步（不丢）；② 批量/mind-sweep 不逐条打断。
- 单条 act-then-surface：理清归位 + 一行回报 + 可一句话纠错。
- 人类判断守卫：仅「行动vs知识 / 推不出下一步 / 隐含承诺 / 项目成果不清」四类停下问。

## v1.4 — organize 改为 AI 自动结构卫生
- organize = 结构卫生（per-item 落位已在 clarify 完成）。最该 AI 全自动：大部分纯机械记账。
- 机械类静默自动做（孤儿/错情境/死勾/重复/stalled 补下一步），一行汇总；判断类批量问。
- engage 前置自动扫一遍；review 的 Get Current 内跑。

## v1.5 — 完成项目自动闭环
- **硬规则**：项目期望成果已达成且无仍需推动的下一步 → 删除整个项目块；不归档、不写「下一步行动：无」。
- **顺序修正**：organize/review 先判断项目是否已完成；未完成才补 stalled 下一步，避免给已闭环项目硬造动作。
- **防回归**：`gtd_status.sh` 把「下一步行动：无/已完成/安排已确认」视为无有效下一步，提示跑 `/gtd-organize`。

## v1.6 — review 升级为 AI 预回顾包
- **边界重画**：review 不再只是提醒用户翻清单；AI 先做系统体检、机械整理、候选动作、话术草稿，用户只确认少数承诺判断。
- **新增只读脚本**：`scripts/gtd_review_prep.sh` 生成预回顾包：dashboard、inbox 摘要、stalled projects、waiting-for、模糊 next-action、someday 候选、确认队列。
- **流程升级**：review 先跑预回顾包 + organize 机械卫生，再进入 Get Clear / Get Current / Get Creative / Horizons。
- **定时边界**：未来 cron / loop / launchd 只能提醒并调用预回顾脚本；不自动删改清单、不写日历、不发消息、不确定下周重点。
- **模板同步**：weekly review 快照新增「AI 预回顾包」与「确认后已落盘」两段。

## v1.7 — GTD 内部链接改为 Obsidian heading link
- **规则**：指向 `memory/gtd/` 文件内标题时，统一写 `[[文件名#标题|标题]]`。
- **例子**：项目引用 `[[projects#项目名|项目名]]`；支持材料引用 `[[reference#条目名|条目名]]`。
- **边界**：裸 `[[文件名]]` 仍用于真实独立文件，例如 `[[projects]]`、`[[next-actions]]`。

## v1.8 — init 内置 Codex slash 命令安装/刷新
- `gtd_init.sh` 新增 `~/.codex/prompts/gtd*.md` 安装/刷新逻辑，从 skill 包内 `templates/codex-prompts/` 读取模板。
- `--status` 自检会报告 Codex slash 命令是否齐全。
- `install.sh` 会把 `src/codex-prompts/` 同步进已安装 skill 包，保证单独跑 init 也能补齐 `/gtd*`。

## v1.9 — Codex plugin package
- 新增公开 Codex plugin 打包路径：repo marketplace 指向 `plugins/llm-gtd/`，插件 skill 由 `src/skill/` 同步生成。
- 脚本状态根解析改为三段：`LLM_GTD_ROOT` 明确指定 → 旧 `.cursor/skills/gtd-harness/` 安装自动定位 vault → 否则使用当前工作区，适配 Codex 插件模式。
- 插件包只包含 skill 逻辑，不包含用户 `memory/gtd/` 状态；Google Calendar 仍是可选外部能力，不内置 app/MCP。

## v1.10 — GCal 自动写入
- **写**：clarify 出特定时间事且日程信息完整 → 直接写 GCal，不再逐次确认。
- **缺字段**：缺日期、开始时间、事项标题/对象等关键字段时，只问缺失字段；会议缺时长时默认 60 分钟。
- **失败降级**：GCal 不可达或 tool 失败 → 如实报告，并把时间事记入 `calendar.md` 兜底，继续遵守“不维护双日历”。

## v1.11 — Projects 支持多个当前 next action
- **格式升级**：`projects.md` 的 `下一步行动` 可写成多行 block links，指向 `next-actions.md` 或 `waiting-for.md`。
- **边界保留**：只挂当前可并行推进的物理动作；有先后依赖的任务树仍放支持材料/自然计划模型，不把 `projects.md` 变成项目管理软件。
- **防回归**：`gtd_status.sh` 与 `gtd_review_prep.sh` 的 stalled 检查改为识别有效 block link；空标题、「下一步行动：无」或泛泛 `见 next-actions` 不再算有效下一步。

---

**AI 自动化总览**：capture→clarify 自动、organize（机械）自动；review 先预处理；engage 给候选，用户保留承诺、选择与反思。

## 待办 / v2 候选
- `calendar.md` 接 Apple Reminders + 双向对账。
- review 自动节律：cron / 定时提醒（默认不开，需用户同意）。
- engage 挂接每日例程。
