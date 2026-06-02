---
name: gtd-init
description: GTD harness 场景命令 · 搭建/自检可信系统。幂等建 memory/gtd/ 八清单 + 安装/刷新 Codex slash 命令 + 适配层自检 + 可选导入旧 open loops。首次运行入口。
parent: gtd-harness
---


# GTD · init（搭建 / 自检）

**视角**：David Allen。GTD 的第一道工序是**把可信系统的盒子摆好**——一个不能自我初始化的系统等于让用户手工搭建，违反「降低进入门槛」。

## 何时跑
- 首次启用 GTD harness（`memory/gtd/` 不存在）。
- 任何命令自检报告清单缺失。
- 想确认三平台适配层是否打通（`--status`）。

## 工作流

1. **运行初始化脚本**（幂等、零破坏，已存在的清单跳过不覆盖）：
   ```
   bash .cursor/skills/gtd-harness/scripts/gtd_init.sh
   ```
  它会建齐 `memory/gtd/` 八清单（含情境骨架与 Horizons 模板），安装/刷新 `~/.codex/prompts/gtd*.md`，并自检适配层。

2. **只自检不写文件**：`bash …/scripts/gtd_init.sh --status`

3. **可选一次性导入旧数据**（默认不跑；旧 `open loops.md` 只读不改）：
   ```
   bash .cursor/skills/gtd-harness/scripts/gtd_init.sh --import-legacy
   ```
   把旧 @自己→next-actions、@等待→waiting-for、@项目→projects，标注 marker 防重复导入。导入项落在「待重新归情境」段，需逐条 `clarify` 重新判定。

4. **读就绪报告**：确认新建/跳过数、适配层自检结果，按提示引导用户跑第一次 `capture`。

## 质量检查
- [ ] 八清单文件齐全（`bash …/scripts/gtd_status.sh` 能跑出 dashboard）
- [ ] Codex slash 命令齐全（`~/.codex/prompts/gtd*.md`，含 `/gtd` 主入口）
- [ ] 重跑只跳过、不覆盖（幂等）
- [ ] 若导入：旧 `open loops.md` 字节不变（可 `md5` 前后比对）
- [ ] 自检如报「真源/入口缺失」→ 提示需完成 Phase 2/3（SKILL.md 与符号链接）
