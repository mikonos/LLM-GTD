---
name: gtd-harness
description: |
  GTD skill（兼容包名：gtd-harness）主入口。把任务/承诺转成可信外部系统。
  七场景命令：init（搭建/自检）· capture（收集）· clarify（理清）· update（状态更新）· organize（组织）· engage（执行）· review（每周回顾）。
  Use when: GTD、任务管理、收集、理清、更新任务状态、完成待办、下一步行动、每周回顾、weekly review、项目组织、清空大脑、session 状态收尾、心如止水、horizons of focus、gtd-harness。
  也触发：「帮我把这些待办理一理」「这周该做什么」「我脑子太乱了帮我清空」「搭一个 GTD 系统」。
  不触发：纯知识/想法消化（走 fleeting-note → ZK 管线）；具体某条 open loop 的临时记录（旧 open-loops skill 仍可用）。
---


# GTD Skill · 主入口

**身份视角**：以 David Allen 的视角执行。目标不是维护待办清单，而是把承诺放进一个用户信任的外部系统，让大脑不用记忆。

## 状态层

核心清单在 `memory/gtd/`，纯 markdown，不打包进插件，也不进入知识索引。

| 文件 | 用途 |
|---|---|
| `inbox.md` | 未理清输入的唯一入口 |
| `next-actions.md` | 已理清的单步行动池 |
| `projects.md` | >1 步的期望成果 |
| `waiting-for.md` | 委派 / 等别人 |
| `calendar.md` | hard landscape；外部 calendar provider 不可达时才兜底 |
| `someday-maybe.md` | 暂不承诺但不愿忘 |
| `reference.md` | 无需行动的备查 / 项目支持材料 |
| `horizons.md` | 六高度方向校准 |
| `product-ideas.md` | 产品 / 功能 / 场景机会入口 |

## 路由

| 用户意图 | 必读 | 动作 |
|---|---|---|
| 搭建、自检、状态、安装、初始化 | `init/SKILL.md` | 建清单、自检入口、只读检查 automation；显式 `--install-cron` 才安装 |
| 新输入、清空大脑、session 收尾 | `capture/SKILL.md` | 先落 inbox；单条默认自动 clarify，批量先全捕捉 |
| 理清 inbox、逐条处理、归位 | `clarify/SKILL.md` | 可行动吗 → 下一步 / 等待 / 项目 / 日历 / someday / reference |
| 做完了、对方回了、日程改了、取消了 | `update/SKILL.md` | 同步现实变化；销项、推进项目、处理 waiting-for 回应或纠错 |
| 清理结构、卡住项目、重复项 | `organize/SKILL.md` | 机械卫生自动做，只把需确认项浮上来 |
| 现在做什么、10 分钟、低精力、采购、准备、该催办 | `engage/SKILL.md` | 按情境 / 时间 / 精力 / 优先级选 3-5 条候选 |
| 每周回顾、系统乱了、不信任清单 | `review/SKILL.md` | 预回顾包 + Get Clear / Current / Creative + Horizons |

## Reference 加载表

| 需要判断什么 | 何时读取 |
|---|---|
| 清单边界、动作权限、Obsidian 链接 | `references/list-definitions.md`；clarify / organize / review 涉及移动、删除、写入时先读 |
| 具体下一步是否合格 | `references/clarify-decision-tree.md`；下一步含糊或用户要理清时读 |
| 日历 provider、自动写入、fallback | `references/capability-map.md`；涉及 hard landscape 或写日历时读 |
| 自动节律 / cron / Approval Radar | `references/automation-profiles.md`；仅 init `--install-cron` 或 Daily Engage 自动节律时读 |
| 周回顾步骤 | `references/weekly-review-checklist.md`；review 时读 |
| 项目纵向规划 | `references/natural-planning-model.md`；项目成果、里程碑、下一步不清时读 |
| Horizons 纵轴校准 | `references/horizons-of-focus.md`；review 或优先级冲突时读 |
| 回归评测 | `references/evals.md`；改 skill 前后或做 public sync 前读 |

## 默认规则

- 系统未搭建（`memory/gtd/` 不存在）→ 先跑 init。
- 单条输入默认 capture → clarify；批量 mind sweep 先全捕捉，再批量理清。
- 明确是产品 / 功能 / 场景机会 → `product-ideas.md` + project / next-action 可见性；用户明确“只捕捉”时例外。
- `next-actions.md` 是行动池，不按 `@电脑/@电话` 主导分类；新行动写清预计时长 / 精力档 / 真实约束。
- 用户宣告完成 → 从清单删除对应 next action；项目成果已达成且无下一步 → 删除项目块。
- 用户汇报现实变化（完成、回应、改期、取消、纠错）→ 走 update，不重新 capture 成新 inbox。
- 日历是 hard landscape；普通待办不得进 `calendar.md`。
- knowledge / idea 无承诺 → 移交 ZK 管线，不写 GTD action 清单。
- `memory/gtd/personalized.md` 可存本机偏好和私人映射；通用 skill 不依赖它。

## 红线

- 不维护双日历；外部 provider 成功后不在 `calendar.md` 抄副本。
- 不在外部 tool 返回成功前声称已写日历。
- 不把 3-5 条 Engage 候选说成今日承诺。
- 不自动 approve / reject / withdraw / remind / cc。
- 不把 approval passed、已提交、拿到回复等中间状态误判为最终完成。
- 不让用户面对全清单；Engage 只给少数可做菜单。
