# 能力映射表（适配层的成文契约）

> GTD harness 的 SKILL.md 用 **intent 语言**（"读取该清单"/"追加一行"/"扫描全部清单"），**不写平台工具名**。
> 各平台在运行时把 intent 翻译成原生工具——这张表就是翻译契约。三平台共享同一份 skill 逻辑与同一份 `memory/gtd/` 状态。

## 三平台调用入口（同一真源，三套薄入口）

| 平台 | 发现机制 | 调用 | 真源解析 |
|---|---|---|---|
| **Claude Code** | SessionStart 加载 skill 列表（读 description） | Skill tool；或 `.claude/commands/gtd*.md` 薄命令 | `.claude/commands/` → `.cursor/skills/` |
| **Cursor** | `beforeSubmitPrompt` Hook 读 `.cursor/skill-rules.json` 的 `gtd-harness` 关键词/意图 → 写 `skill-suggestions.md` → `auto-activation.mdc` 强制消费 | 读 `.cursor/skills/gtd-harness/SKILL.md` 按流程执行 | `.cursor/skills/`（真源原位） |
| **Codex** | 安装 `llm-gtd` 插件；旧路径可继续用全局 `/gtd*` prompts | 直接调用插件 skill；旧 prompt 读取 `.cursor/skills/gtd-harness/SKILL.md` | 插件内 `skills/gtd-harness/`；旧安装为 `.cursor/skills/` |

## intent 动词 → 各平台原生工具

| GTD intent 动词 | Claude Code | Cursor | Codex |
|---|---|---|---|
| 读取一张清单 | Read | 原生读文件 | `cat memory/gtd/<list>.md` |
| 追加 / 勾销一行 | Edit / Write | 原生编辑 | `python3` 追加 / `sed -i ''`（macOS 需空串） |
| 扫描全部清单 | Glob + Read | 原生 | `ls memory/gtd/` + `cat` |
| 跑 dashboard / init / 预回顾脚本 | Bash | 原生 terminal | Bash 运行 skill 内脚本；旧安装可用 `bash .cursor/skills/gtd-harness/scripts/<x>.sh` |
| 调度每周回顾提醒 | loop / cron，只触发预回顾包 | 手动节律 | launchd / cron，只调用 `gtd_review_prep.sh` |
| 反问澄清 | AskUserQuestion | 原生提问 | 文本提问 |
| **读取 hard landscape（日历）** | google_calendar MCP（list events，需 OAuth）| 原生 GCal 集成 | 已连接的 GCal / MCP |
| **写入日历事件（自动）** | google_calendar MCP（create event）| 原生 | 已连接的 GCal / MCP |

## 日历源适配 + 自动写入契约（v1.10）

GTD 铁律：**绝不维护双日历。** 一旦真实 Google Calendar 可达，它就是唯一的 hard landscape；`calendar.md` 只在 GCal 不可达时兜底，**不抄副本**。

**日历源解析（按可达性降级）**：
```
需要 hard landscape（engage 今天 / review 本周）时：
1. 真实 GCal 可达？（该平台已接 + 已授权）→ 读 GCal，它是唯一真源
2. 不可达 → 读 calendar.md（本地兜底），并提示「GCal 未接/未授权，按本地兜底，可能不全」
```
> cc 会话内 GCal MCP 需先 OAuth（`mcp__…google_calendar__authenticate`）才出现 list/create 工具；未授权即视为不可达，自动降级。

**自动写入契约**：
- 写入 = **高后果操作**，但日程信息完整时直接调用 GCal create，不再先问确认；**不得**在 tool 返回成功前声称已写入。
- 可写入的最小信息：**事项标题 + 日期 + 开始时间**。地点、涉及人、来源、备注有则写入描述/地点；会议缺时长时默认 60 分钟。
- 缺日期、开始时间、事项标题/对象等关键字段时，只问缺失字段，不写入猜测事件。
- 返回成功 → 报「已写入 GCal」；失败/不可达 → 报「未写入(原因)」并把该时间事记入 `calendar.md` 兜底待手动补，**不谎报**。
- 区分四态：未尝试 / 尝试失败 / 部分完成 / tool 确认完成。

## 不变量（保证三平台一致）

1. **状态层零适配**：`memory/gtd/` 是纯 markdown 文件——文件就是文件，三平台读写同一份，无需翻译。多机可经云盘同步（与既有 `open loops.md` 同一风险模型）。
2. **逻辑层单一真源**：公开仓库只改 `src/skill/`，再同步到 Codex plugin；旧安装仍复制到 `.cursor/skills/gtd-harness/`。
3. **SKILL.md 中立**：主流程不绑定某个本机命令；新增步骤只写 intent，翻译查本表。
4. **插件状态隔离**：`plugins/llm-gtd/` 只打包 skill 逻辑，不打包任何用户 `memory/gtd/` 状态。

## 自检命令

```bash
bash .codex/scripts/check-agent-dirs.sh          # 符号链接 + skill 计数一致
cat .cursor/skills/gtd-harness/SKILL.md        # codex 路径可达
find -L .claude/skills -name gtd-harness -type d   # cc 符号链接解析
bash .cursor/skills/gtd-harness/scripts/gtd_init.sh --status   # 三入口自检报告
bash .cursor/skills/gtd-harness/scripts/gtd_review_prep.sh     # 只读生成 review 预回顾包
LLM_GTD_ROOT=/tmp/llm-gtd-test bash plugins/llm-gtd/skills/gtd-harness/scripts/gtd_init.sh
```
