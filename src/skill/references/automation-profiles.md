# GTD 自动节律 Profiles

> 目的：把可复用的 GTD cron/automation 变成少数可信节律，而不是一套后台任务森林。
> 默认 `gtd_init.sh` 只做只读检查；用户显式请求 `--install-cron` 时，由当前 agent / 平台 automation 工具创建或更新，不由 shell 手写 automation 文件。

## 安装原则

1. **显式创建**：只有用户说“安装/初始化 GTD cron”或使用 `--install-cron` 时才创建或更新后台任务。
2. **工具创建**：Codex 场景必须调用 `automation_update`；不要直接写 `~/.codex/automations`。
3. **低频优先**：默认安装 Weekly Review 和 Monthly Reflect；Daily Engage 作为执行入口随 `--install-cron` 一起安装/更新。
4. **一类只装一个默认入口**：Daily Engage 若已有上午或晚间入口，沿用现有入口；若都没有，默认创建上午入口，避免一天被系统打扰两次。
5. **只给菜单，不替承诺**：所有自动节律都不能把普通 next actions 自动排进日历，也不能把 3-5 条候选说成今日承诺。
6. **Approval Radar 只读扫描**：可以发现当前用户相关的 approval 状态变化、待确认项和卡住项，但不能自动同意、拒绝、撤回、催办或抄送。

## Profile 总览

| Profile | 推荐度 | 示例 id | 用途 | 边界 |
|---|---|---|---|---|
| Weekly Review | 推荐安装 | `gtd-ai` | 每周一次真正 AI 判断版回顾：系统可信度、结构问题、下周 3 件事、容量冲突、催办话术 | 不自动删除、不砍项目、不发消息、不写日历、不替用户做高后果承诺 |
| Monthly Reflect | 推荐安装 | `gtd-2` | 每月审查 someday-maybe、product-ideas、horizons 与未来 30 天容量 | 用 Reflect 词汇，不叫 organize；只给启动/保留/删除/补信息建议 |
| Daily Engage + Approval Radar | 随 `--install-cron` 安装/更新 | `gtd` / `gtd-engage` | 每日轻量选择“现在/今晚/明早怎么用第一段时间”，并带 Approval Radar | 不是 daily review；不全量重扫 projects/someday/product-ideas/horizons |
| Session Clarify | 高级可选 | `gtd-session-clarify` | 扫 session 里的真实承诺并 clarify 归位 | session-provider 特化；高频且扫描面大，不进入通用 init 默认建议 |

## Daily Engage + Approval Radar 标准边界

Daily Engage 是 Allen 的 Engage，不是 Review。它只回答“下一段时间怎么用”，输出少数候选菜单。

必须做：
- 读取 hard landscape：优先首选 calendar provider；不可达时按 fallback provider chain 降级；全部不可达时读 `calendar.md` 并说明限制。
- 计算当前/第一段可用时间窗；若与用户口头时间冲突，取更小者。
- 用四标准筛选行动池：情境 / 时间 / 精力 / 优先级。
- 扫 Approval Radar：只保留需要行动或状态变化的 approval item；没有就写“今日无 approval 动作”。
- 输出容量判断：绿 / 黄 / 红；过载时只给删、延期、委派、降级建议。

不得做：
- 不把 ordinary next actions 自动塞进日历。
- 不把 approval passed 误判为最终到账；真实完成条件仍以到账、交付或用户定义的闭环为准。
- 不自动 approve、reject、withdraw、remind 或 cc。
- 不把 Approval Radar 失败当成整个 Engage 失败；缺少只读权限时说明缺口，继续完成 Engage。

## Approval Radar 检查项

运行环境有 approval provider capability 时，Daily Engage 读取对应 approval provider adapter，执行只读扫描：

1. 先检查 approval provider adapter 是否可用；不要输出 token 或 secret。
2. 扫描当前用户提交的 approval，重点看仍进行中的实例和 GTD `waiting-for.md` / `reference.md` 里记录过的 approval id。
3. 扫描他人提交、需要当前用户确认的 approval；缺少只读权限时只报告缺口，不尝试自动授权。
4. 若 approval status 变化会影响 GTD truth，可保守更新 waiting-for/reference：例如从“等 approval”改成“按约定日期核对到账”；但不得把中间状态当成完成。

## init 口径

`gtd_init.sh --status` 只报告这些 profile 的安装现状：
- Weekly Review
- Monthly Reflect
- Daily Engage（上午或晚间）

若用户说“安装 GTD 自动节律 / 创建 cron / 按建议装”或传入 `--install-cron`，再按本文件创建或更新对应 automation。默认安装顺序：
1. Weekly Review
2. Monthly Reflect
3. Daily Engage + Approval Radar（未选择时沿用本机已有 daily engage；无已有入口时创建上午入口）

Session Clarify 不进默认安装序列，只在用户明确要“自动扫描 Codex session / 每日整理 session 承诺”时安装。

## Codex 创建规则

当 `gtd-init` 在 Codex 中执行 `--install-cron`：

1. 先读取现有 automation toml，匹配 `gtd-ai`、`gtd-2`、`gtd`、`gtd-engage`，避免重复创建。
2. 已存在的 profile 用 `automation_update` 更新，保留原有启用状态、模型、工作区，除非 profile 本身需要补关键 prompt 边界。
3. 缺失的 Weekly Review / Monthly Reflect / Daily Engage 用 `automation_update` 创建。
4. 创建或更新后，运行 `gtd_init.sh --status`，确认状态能被 init 看见。
5. 不展示底层调度字符串；只用人话说明节律名称、是否已安装、是否 active。
