# LLM-GTD

中文 | [English](README.md)

**给 LLM Agent 用的可移植 GTD skill。**

它不是 todo app，也不是又一个效率提示词。LLM-GTD 是一套可信外部系统，让 Claude Code、Cursor 和 Codex 可以帮你收集、理清、组织、选择和回顾任务，同时不把你的生活变成一堆半处理的待办。

> 可安装的 Codex 插件名叫 `llm-gtd`。
> 旧版 skill 包继续叫 `gtd-harness`，用于兼容 Cursor 和手动安装。

## 一个例子先感受下

你交给它的不是一条任务，而是一个**意图**：

> **你：** 我要培养我家女儿的乒乓球
> **LLM-GTD：** 把它建成一个**项目**；第一步 → *「和女儿聊 10 分钟，确认她想不想尝试、已有水平、每周能接受的频率…」*。它**没有**报名、排课或联系教练。

过了一会儿你回来汇报：

> **你：** 我跟女儿聊完了，她很有兴趣，每周可以上两次课、每次约 1 小时
> **LLM-GTD：** 把「聊 10 分钟」销项；**推进项目**到 *「筛选 2-3 个乒乓球课——时段、费用、距离、试课」*；把事实记进支持材料；把你说的「~1 小时」标成**待确认**。

一个没有当前下一步的项目，就是一个卡住的承诺。LLM-GTD 跨天把承诺**一直挂活**——你提供判断、汇报现实，它替你做记账。
→ [完整走查](docs/demo.zh-CN.md)

## 一句话

大多数 AI 效率工作流失败，原因和人类 GTD 系统失败一样：收件箱越来越满，下一步行动太模糊，项目没有当前推进动作，每周回顾被跳过。

LLM-GTD 给 agent 一套 skill 化的可信系统：

- `memory/gtd/` 里的纯 Markdown 状态
- 完整 GTD 工作流，而不只是 inbox triage
- 一个 `/gtd` 自动路由入口，加六个工作流命令：`init`、`capture`、`clarify`、`organize`、`engage`、`review`
- Claude Code、Cursor、Codex 共用同一套可信系统
- 日程信息完整时自动写入 Google Calendar，失败按 fail-closed 报告

模型负责它擅长的事：起草下一步行动、清理结构、发现停滞项目、准备每周回顾。

你保留应该由人决定的事：承诺、优先级、反思和最终选择。

## 为什么需要它

公开的 GTD agent skills 大致有两类：

1. **单点工作流 skill**，比如 inbox processing 或 weekly review。
2. **大型 Life OS / second-brain 系统**，GTD 只是其中一部分。

这些都 useful，但经常漏掉最难的部分：一套 agent 每天都能维护的、不会把状态散落到工具、聊天和半成品笔记里的可信系统。

LLM-GTD 更窄，也更深。它把 GTD 做成可复用的 agent skill：

```text
LLM = 判断、语言、起草
Skill = 状态、工作流、节律、适配层、安全边界
```

David Allen 给了我们管理承诺的操作系统。LLM-GTD 把这套操作系统改造成 agent-native 的形态。

## 它能做什么

| 你想要 | 命令 | 它会做什么 |
|---|---|---|
| 搭建可信系统 | `gtd-init` | 创建八张 GTD 清单并检查接线；旧安装模式还会刷新 Codex slash prompts |
| 捕捉一个想法或任务 | `gtd-capture` | 先写入 inbox，再自动理清小输入 |
| 清理收件箱 | `gtd-clarify` | 把模糊的 stuff 变成 next action、project、waiting-for、reference 或 someday |
| 整理系统结构 | `gtd-organize` | 修复机械漂移：孤儿行动、停滞项目、错误情境、重复项 |
| 判断现在做什么 | `gtd-engage` | 基于情境、时间、精力和优先级给 3-5 个候选行动 |
| 做每周回顾 | `gtd-review` | 先生成只读预回顾包，清理机械漂移，再回顾 inbox/calendar/waiting/projects/horizons |

核心设计选择：**capture、clarify 和机械 organize 可以尽量自动；engage 和 review 仍由人主导。**

## 可信状态

LLM-GTD 的运行状态存在八个纯 Markdown 文件里：

| 文件 | GTD 清单 | 用途 |
|---|---|---|
| `memory/gtd/inbox.md` | Inbox | 零摩擦收集入口 |
| `memory/gtd/next-actions.md` | Next Actions | 按情境分组的具体单步行动 |
| `memory/gtd/projects.md` | Projects | 需要多步完成的成果，每个项目必须有当前下一步 |
| `memory/gtd/waiting-for.md` | Waiting For | 委派或等待中的事项，记录人和约定 |
| `memory/gtd/someday-maybe.md` | Someday/Maybe | 暂不承诺但不想忘掉的事 |
| `memory/gtd/calendar.md` | Calendar fallback | 只放 hard landscape；真实日历不可达时才兜底 |
| `memory/gtd/reference.md` | Reference | 无需行动的支持材料 |
| `memory/gtd/horizons.md` | Horizons | 目的、愿景、目标、责任领域、项目和跑道 |

没有数据库。没有隐藏状态。没有 vendor lock-in。文件就是文件。

## 它怎么工作

LLM-GTD 有四层：

```text
LLM
  负责判断、解释、起草下一步行动

Skill package
  State      memory/gtd/*.md
  Logic      src/skill/SKILL.md + sub-skills
  Adapter    Claude Code commands、Cursor skill rules、Codex prompts
  Cadence    weekly review workflow and optional reminders
```

同一套 skill 包和同一份 `memory/gtd/` 状态可以被多个 agent 界面共用：

| 平台 | 入口 | 状态 |
|---|---|---|
| Claude Code | 插件 `llm-gtd`（skill + `/gtd` + `/gtd-*`）；或 `.claude/commands/gtd*.md`（手动） | 同一份 `memory/gtd/` |
| Cursor | `.cursor/skills/gtd-harness/` + keyword rules | 同一份 `memory/gtd/` |
| Codex | Codex 插件 `llm-gtd`；旧版 `~/.codex/prompts/gtd*.md` 仍可用 | 同一份 `memory/gtd/` |

## 它和普通方案有什么不同

**它是完整 GTD 闭环，不是 inbox prompt。**
Capture、Clarify、Organize、Engage、Review 都是一等公民。

**它把 GTD 封装成 skill，而不是 chatbot persona。**
agent 可以替换，状态和工作流留下来。

**它把知识和行动分开。**
行动进 GTD。想法、笔记和研究应该进你的知识系统，比如 Zettelkasten。

**它只在 AI 真有帮助的地方使用 AI。**
起草具体下一步、发现停滞项目、清理清单结构，是好的 AI 任务。
决定你要承诺什么、重视什么，不是。

**它对日历写入 fail closed。**
如果 Google Calendar 已连接，它就是唯一 hard landscape。日程信息完整时自动写入 Google Calendar；缺日期、时间、事项标题等关键字段时先澄清。工具失败时，LLM-GTD 不会假装已经完成。

## 安装

### 作为 Claude Code 插件安装

本仓库同时是一个 Claude Code 插件 marketplace。在 Claude Code 里：

```text
/plugin marketplace add mikonos/LLM-GTD
/plugin install llm-gtd@llm-gtd
```

内置的 GTD skill 会在你说 GTD 相关话时自动激活，并加上 `/gtd` 自动路由入口和 `/gtd-*` 命令
（`/gtd`、`/gtd-init`、`/gtd-capture`、`/gtd-clarify`、`/gtd-organize`、`/gtd-engage`、`/gtd-review`）。
状态只写到你**当前工作区**的 `memory/gtd/`——绝不打包进插件（`${CLAUDE_PLUGIN_ROOT}` 是只读的 skill，
你的清单在你的项目里）。在你想存放 GTD 清单的工作区里跑 `/gtd-init`（或直接说）即可。

### 作为 Codex 插件安装

LLM-GTD 现在包含 repo 级 Codex 插件包：

```text
.agents/plugins/marketplace.json
plugins/llm-gtd/
```

把这个仓库加入 Codex 插件 marketplace，然后在 Codex 插件目录里安装 `llm-gtd`：

```bash
codex plugin marketplace add https://github.com/mikonos/LLM-GTD.git
codex plugin add llm-gtd@llm-gtd
```

安装后，在你想存放 GTD 状态的工作区里启动 Codex，并让它使用 LLM-GTD：

```text
Set up my GTD trusted system
Capture and clarify this task: renew passport before summer
Run my weekly GTD review
```

插件只会把用户状态写到当前工作区的 `memory/gtd/`，不会打包任何个人 GTD 数据，也不会内置
Google Calendar app/MCP。如果你的 Codex 环境已经有 Google Calendar 能力，LLM-GTD 会把它当真实
hard landscape；否则降级到 `memory/gtd/calendar.md`。

### 使用旧版多平台安装器

```bash
git clone <your-fork-url> LLM-GTD
cd LLM-GTD
./install.sh /path/to/your/vault
```

如果省略 vault 路径，安装器会使用当前目录：

```bash
./install.sh
```

安装器会复制：

- `src/skill/` 到 `<vault>/.cursor/skills/gtd-harness/`
- Claude Code commands 到 `<vault>/.claude/commands/`
- Codex prompts 到 `~/.codex/prompts/`
- Codex orchestrator 到 `<vault>/.codex/agents/`
- 初始 GTD 状态到 `<vault>/memory/gtd/`

安装结束时会提示两个可选手动接线步骤：

- 把 `snippets/cursor-skill-rules.json` 合并进 Cursor skill rules
- 把 `snippets/AGENTS.routing.md` 合并进工作区 `AGENTS.md`

## 依赖

- Bash
- Python 3，用于 status/dashboard 辅助脚本
- Claude Code、Cursor 或 Codex，取决于你使用哪个界面
- 可选：Google Calendar 访问权限，用于真实日历读取和确认后写入

## 快速开始

初始化：

```bash
./install.sh /path/to/your/vault
```

然后在 agent 里试这些命令：

```text
/gtd-capture Renew passport before the summer trip
/gtd-clarify
/gtd-engage
/gtd-review
```

也可以直接说自然语言：

```text
Help me clear my head.
Help me sort through these pending items.
I have 30 minutes right now. What should I do?
Run a weekly review.
```

你也可以把 `/gtd` 当成通用入口，不必选择具体子命令：

```text
/gtd Schedule coffee with Jack tomorrow afternoon at the Starbucks near my home.
```

查看系统状态：

```bash
bash .cursor/skills/gtd-harness/scripts/gtd_status.sh
```

## 示例流程

你说：

```text
/gtd-capture Ask Mei about the school form, renew passport, maybe learn piano, save the tax PDF
```

LLM-GTD 会先捕捉所有内容，再理清可以安全推断的部分：

- `Ask Mei about the school form` 会变成具体 next action 或 waiting-for。
- `renew passport` 如果需要多步，会变成 project。
- `maybe learn piano` 会进入 someday/maybe，除非你明确承诺现在要做。
- `save the tax PDF` 会进入 reference，除非它隐含行动。

如果 agent 无法安全判断你的承诺，它会问，而不是装作知道。

→ 完整五步走查 + 头牌案例（一个会随你汇报而自动推进的项目）：[docs/demo.zh-CN.md](docs/demo.zh-CN.md)。

## 仓库结构

```text
src/skill/            GTD 核心 skill 包
plugins/llm-gtd/      由 src/skill/ 生成的 Codex 插件包
.agents/plugins/      repo 级 Codex marketplace
scripts/              仓库维护脚本
src/claude-commands/  Claude Code slash commands
src/codex-prompts/    Codex slash prompts
src/codex-agents/     Codex orchestrator agent
snippets/             Cursor 和 AGENTS.md 的可选路由片段
docs/design.md        架构和设计说明
docs/demo.zh-CN.md    五步走查 + 头牌案例（中文）
install.sh            安装脚本
CHANGELOG.md          项目更新日志
```

## 设计边界

- **Inbox 不是系统。** 它只是收集入口。
- **下一步行动必须具体、可见。** “处理税务”不是 next action；“把 W-2 PDF 发给 CPA”才是。
- **项目必须有当前下一步。** 没有下一步的项目就是停滞承诺。
- **日历是神圣的。** 只有特定日期/时间才有意义的承诺放日历。
- **每周回顾不能跳过。** 没有 review，GTD 会退化成任务堆。
- **没有隐藏写入。** 日历写入和其它高后果动作必须确认。
- **知识不是行动。** 笔记、洞察和研究属于知识系统，不属于 `next-actions.md`。

## 相关项目

LLM-GTD 参考过一些公开 agent-skill 模式：

- [natea/ExoMind](https://github.com/natea/ExoMind/tree/main/skills) 包含 Life OS skills，比如 inbox processing、email inbox processing 和 weekly review。
- [huytieu/COG-second-brain](https://github.com/huytieu/COG-second-brain) 是更大的 agentic second-brain 系统，包含 capture 和 weekly check-in workflow。
- [openai/skills](https://github.com/openai/skills) 展示了当前 Codex skill packaging 模式。

LLM-GTD 故意比 Life OS 小，又比单个 inbox skill 完整。它只做一件事：把 GTD commitment loop 封装成可移植 skill。

## 语言

英文 README 用于开源发现。

中文版 README 用于中文用户快速理解。skill prompts 目前也是中文，因为原始运行环境是中文。方法论来自 David Allen 的 GTD，具体语言可以本地化。

## License

MIT. See [LICENSE](LICENSE).
