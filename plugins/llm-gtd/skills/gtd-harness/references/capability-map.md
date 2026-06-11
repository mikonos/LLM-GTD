# 能力映射表（公开包适配契约）

> GTD skill 的 SKILL.md 用 **intent 语言**（"读取该清单" / "追加一行" / "扫描全部清单"），不绑定单一平台工具。
> 运行时由 Claude Code、Cursor、Codex 或其他 agent 把 intent 翻译成自己的读写、日历和 automation 能力。

## 运行形态

| 形态 | Skill 位置 | 状态位置 | 说明 |
|---|---|---|---|
| Source package | `src/skill/` | 测试时由 `LLM_GTD_ROOT` 或当前目录指定 | 仓库维护真源 |
| Legacy install | `<workspace>/.cursor/skills/gtd-harness/` | `<workspace>/memory/gtd/` | `install.sh` 复制后运行，兼容 Cursor / 手动安装 / 旧 Codex prompts |
| Plugin install | plugin read-only skill directory | 当前工作区 `memory/gtd/` | 插件只携带 skill，不携带用户状态 |

## intent 动词 → 运行时能力

| GTD intent 动词 | 需要的能力 | 降级口径 |
|---|---|---|
| 读取一张清单 | 读 `memory/gtd/<list>.md` | 文件缺失时先走 init |
| 追加 / 删除 / 最小替换一行 | 文件编辑 | 高风险或多匹配时问一句 |
| 扫描全部清单 | 遍历 `memory/gtd/` | 只读扫描失败时报告缺口 |
| 跑 dashboard / init / 预回顾脚本 | shell/script execution | 脚本不可用时手动读清单 |
| 调度 GTD 自动节律 | 平台 automation/reminder 能力 | 不手写未知平台状态；只输出 handoff |
| 读取 hard landscape（日历） | calendar provider adapter | 全部 provider 不可达时读 `calendar.md` 兜底 |
| 写入日历事件 | calendar provider adapter create/update | tool 成功前不得声称完成；失败写 fallback |
| 读取 approval radar | approval provider read-only adapter | provider 不可达时说明缺口，继续 Engage |
| 发消息 / 催办 / 委派他人 | messaging provider | 只能起草，发送前必须确认 |

## 日历源适配 + 自动写入契约

GTD 铁律：**绝不维护双日历。** 一旦外部 calendar provider 可达，它就是 hard landscape；首选 provider 失败时按 fallback chain 降级；`calendar.md` 只在全部外部 provider 都不可达时兜底，**不抄副本**。

**日历源解析（按可达性降级）**：

```text
需要 hard landscape（engage 今天 / review 本周）时：
1. 首选 calendar provider 可达？→ 读取该 provider
2. 首选 provider 不可达？→ 读取 fallback calendar provider
3. 全部外部 provider 都不可达？→ 读 calendar.md（本地兜底），并提示「按本地兜底，可能不全」
```

> 具体 provider 名称、认证方式、CLI 命令和本机偏好属于本地 personalized overlay，不写进通用 skill。

**冲突与容量判断**：

- `clarify` 写硬日程前：读取目标时间段及必要缓冲；若已有事件重叠或缓冲不足，停止写入并提示改期 / 取消 / 委派 / 降级。
- `engage` 选下一步前：读取今天 hard landscape，计算到下一个硬约定前的自由时间窗；用这个窗口过滤 next-actions。
- `review` 选下周焦点前：扫描下周 hard landscape，识别明显承诺过载；只给重谈建议，不自动排布普通 next-actions。

**自动写入契约**：

- 写入 = **高后果操作**，但日程信息完整且目标时间段无冲突时可调用首选 calendar provider create/update；不得在 tool 返回成功前声称已写入。
- 可写入的最小信息：**事项标题 + 日期 + 开始时间**。地点、涉及人、来源、备注有则写入描述 / 地点；会议缺时长时默认 60 分钟。
- 缺日期、开始时间、事项标题 / 对象等关键字段时，只问缺失字段，不写入猜测事件。
- 首选 provider 返回成功 → 报「已写入外部日历」。
- 首选 provider 失败 / 不可达 → 尝试 fallback calendar provider；fallback 返回成功 → 报「已写入 fallback calendar provider」。
- 全部外部 provider 都失败 / 不可达 → 报「未写入外部日历（原因）」并把该时间事记入 `calendar.md` 兜底待手动补，**不谎报**。
- 区分四态：未尝试 / 尝试失败 / 部分完成 / tool 确认完成。

## 不变量

1. **状态层零适配**：用户状态只在 `memory/gtd/`，纯 markdown，不打包进插件。
2. **逻辑层单一来源**：公开仓库维护 `src/skill/`；插件 skill 由同步脚本生成。
3. **运行层中立**：子技能写 intent，不把某个本机 provider 当成默认事实。
4. **自动节律显式安装**：Weekly Review / Monthly Reflect / Daily Engage + Approval Radar 的边界见 `references/automation-profiles.md`；`gtd_init.sh --status` 只检查现状，`--install-cron` 在 agent 场景中触发平台 automation 工具创建或更新。

## 自检命令

```bash
bash src/skill/scripts/gtd_eval_check.sh
bash src/skill/scripts/gtd_init.sh --status
LLM_GTD_ROOT="$(mktemp -d)" bash src/skill/scripts/gtd_init.sh
```
