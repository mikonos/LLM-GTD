---
name: gtd-init
description: GTD skill 场景命令 · 搭建/自检可信系统。幂等建 memory/gtd/ 核心八清单 + 产品想法扩展清单 + 适配层自检 + 自动节律只读检查/显式安装 + 可选导入旧 open loops。首次运行入口。
parent: gtd-harness
---


# GTD · init（搭建 / 自检）

**视角**：David Allen。GTD 的第一道工序是**把可信系统的盒子摆好**——一个不能自我初始化的系统等于让用户手工搭建，违反「降低进入门槛」。

## 加载与边界

- 只搭建或 `--status`：运行脚本即可，不读额外 reference。
- 涉及 `--install-cron` / 初始化自动节律：先读 `references/automation-profiles.md`。
- 适配层或 calendar provider 有疑问：读 `references/capability-map.md`。
- 自动化边界：默认只读检查；只有用户显式要求才创建/更新 automation。

## 何时跑
- 首次启用 GTD skill（`memory/gtd/` 不存在）。
- 任何命令自检报告清单缺失。
- 想确认三平台适配层是否打通（`--status`）。
- 想确认 GTD 自动节律（Weekly Review / Monthly Reflect / Daily Engage）是否已安装。
- 用户明确要求安装 / 初始化 GTD cron / automation（`--install-cron`）。

## 工作流

1. **运行初始化脚本**（幂等、零破坏，已存在的清单跳过不覆盖）：
   ```
   bash <this-skill>/scripts/gtd_init.sh
   ```
   它会建齐 `memory/gtd/` 核心八清单（含 next-actions 行动池兼容骨架与 Horizons 模板）和产品想法扩展清单，自检适配层，并只读检查自动节律安装现状。

2. **只自检不写文件**：`bash …/scripts/gtd_init.sh --status`

   `--status` 会检查：
   - GTD skill 真源和三平台入口是否可达。
   - Weekly Review / Monthly Reflect / Daily Engage 是否已有本机 automation。
   - 它只报告现状，不创建、不暂停、不修改 cron。

3. **自动节律安装**（只在用户显式要求时执行，例如 `/gtd init --install-cron` / “初始化 GTD cron”）：
   - 先读 `references/automation-profiles.md`。
   - 先检查现有 `$CODEX_HOME/automations/*/automation.toml`，优先更新已有 automation，不创建重复项。
   - 在 Codex 中必须调用 `automation_update` 创建/更新；不要用 shell 手写 `~/.codex/automations`。
   - 默认安装/更新：Weekly Review、Monthly Reflect、Daily Engage + Approval Radar。
   - Daily Engage 若本机已有上午或晚间入口，沿用并更新已有入口；若都没有，默认创建上午入口。若用户明确选了晚间，则创建/更新晚间入口。
   - Session Clarify 仅在用户明确要自动扫描 Codex session 时安装。
   - 安装后运行 `bash …/scripts/gtd_init.sh --status` 验证。

4. **可选一次性导入旧数据**（默认不跑；旧 `open loops.md` 只读不改）：
   ```
   bash <this-skill>/scripts/gtd_init.sh --import-legacy
   ```
   把旧 @自己→next-actions、@等待→waiting-for、@项目→projects，标注 marker 防重复导入。导入项落在「待补轻字段」段，需逐条 `clarify` 补预计时长 / 精力档 / 真实约束。

5. **读就绪报告**：确认新建/跳过数、适配层自检结果、自动节律现状，按提示引导用户跑第一次 `capture`。

## 质量检查
- [ ] 核心八清单 + 产品想法扩展清单文件齐全（`bash …/scripts/gtd_status.sh` 能跑出 dashboard）
- [ ] 重跑只跳过、不覆盖（幂等）
- [ ] `--status` 能只读报告 Weekly Review / Monthly Reflect / Daily Engage 的安装现状
- [ ] 只有用户显式要求 `--install-cron` / 初始化 cron 时才创建或修改 automation
- [ ] Codex 场景通过 `automation_update` 创建/更新，不手写 automation 文件
- [ ] 若导入：旧 `open loops.md` 字节不变（可 `md5` 前后比对）
- [ ] 自检如报「真源/入口缺失」→ 提示先确认 skill 安装路径或插件入口是否可达
