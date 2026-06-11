---
name: gtd-review
description: GTD skill 场景命令 · 每周回顾（关键成功因子）。AI 先生成预回顾包，再做 Get Clear / Get Current / Get Creative + Horizons 纵轴巡检 + 三环平衡横轴（Laura Vanderkam）。GTD 第四步 Reflect。
parent: gtd-harness
---


# GTD · review（每周回顾 / Reflect）

**视角**：David Allen 原话——「The Weekly Review is the critical success factor.」没有它，前四步全部坍塌，系统在两周内失去可信、退回大脑焦虑。回顾不是补做事，是**保养系统的信任**。

## 加载与边界

- 回顾步骤：读 `references/weekly-review-checklist.md`。
- 清单边界 / 删除 / 移动权限：读 `references/list-definitions.md`。
- hard landscape / 容量判断：读 `references/capability-map.md`。
- Horizons 冲突或优先级判断：读 `references/horizons-of-focus.md`。
- 自动化边界：预处理和机械卫生可自动；删除不确定条目、砍项目、确定下周 3 件事需用户确认。

## 何时跑
- 每周固定一次（建议周五；节律见 `references/weekly-review-checklist.md`）。
- 用户说「做每周回顾」「周复盘」「过一遍我的系统」「weekly review」。
- 系统感觉乱了/不信任了——这正是该回顾的信号。

## 边界：AI 多做脏活，用户做承诺判断

review 不是让用户从清单里重新翻一遍。AI 应该先把系统体检、机械整理、候选动作、话术草稿尽量准备好，再把少数需要用户判断的点浮上来。

| AI 默认先做 | 必须让用户确认 |
|---|---|
| 跑 dashboard / 预回顾包；扫描 inbox、next-actions、projects、waiting-for、someday、product ideas、horizons；审计 product ideas 是否都有 project / next-action 可见性 | 删除不确定条目、砍项目、启动 someday、推进 product idea 到 PRD / 降级 / 删除、确定下周 3 件事 |
| 调用 organize 做机械卫生：错情境、重复、死勾、明显孤儿、stalled 检出 | 写日历、发消息、通知/委派他人、任何高后果动作 |
| 为 stalled project 起草下一步；为 waiting-for 起草中性催办话术；为下周重点给候选 | 在事实冲突、来源不明、风险较高时替用户拍板 |

原则：**预处理可以自动，承诺判断不自动。** 用户看到的应是一份「待确认的系统体检报告」，不是一堆原始清单。

## 0. AI 预回顾包（默认先做）

- 跑 `scripts/gtd_review_prep.sh`，生成只读预回顾包：全景数字、inbox 摘要、stalled 项目、waiting-for、模糊 next-action、someday 候选、product ideas 可见性审计、确认队列。
- 读外部 calendar provider（可达则优先）；全部不可达再读 `calendar.md` 兜底并注明可能不全。
- 对下周 hard landscape 做容量扫描：哪些天已被硬约定占满，哪些焦点缺少可用时间窗；只提示重谈承诺，不自动把 next-actions 塞进日历。
- 调用 `organize/SKILL.md` 的机械卫生流程：能自动修的先修；需要拍板的批量列出。
- 把 review 压缩成 3 类输出：
  - **已自动处理**：机械整理、去重、补草稿、归位。
  - **建议确认**：删除/启动/砍项目/补下一步/催办。
  - **下周候选**：AI 建议的 3 个焦点 + 理由。

## 三段式 + 纵轴 + 横轴（Allen 三段 + Horizons 纵轴 + Laura 三环横轴）

### ① Get Clear（清空）
- 清空 `inbox.md`：逐项 clarify 到零（调用 clarify 工作流）。
- 收拢散落各处的「东西」（笔记、脑中悬而未决）一并捕捉进系统。

### ② Get Current（更新）
- 过 `next-actions.md`：已完成的销项；不再相关的删；每条仍是有效的下一步吗？
- 过**日历（hard landscape）**：上周遗留/本周将至的硬约定。先读外部 calendar provider（可达则优先，见 `references/capability-map.md`）；全部不可达再读 `calendar.md` 兜底并注明可能不全。**不把外部日历抄进 calendar.md**（单一兜底）。下周 3 件事必须对照可用时间窗；若焦点超过容量，提示删、延期、委派或降级。
- 过 `waiting-for.md`：哪些该催了？逐条看委派日期。
- 过 `projects.md`：先问**项目成果是否已经达成**；已达成就删除整个项目块（不归档、不写「下一步行动：无」）。未达成的项目再问是否挂着至少一个有效 next-actions / waiting-for block link；多条只保留可并行的当前动作；stalled 的当场补。项目成果是否仍想要？
- 过 `product-ideas.md`：每条产品机会是否都有 `GTD 可见性`，且能指向 project / next-action；缺失则当场补一个项目或下一步，不让产品机会留成冷藏 backlog。

### ③ Get Creative（创造）
- 过 `someday-maybe.md`：有哪条成熟了，值得拉进 active？
- 过 `product-ideas.md`：哪些产品机会需要补证据、删除、降级，或推进到 PRD？这里做产品取舍，不再做“是否可见”的结构校验。
- 本周有没有任何新念头/项目想加进来？

### ④ Horizons 巡检（纵轴，回顾的升华）
- 抬升到 30k+：读 `horizons.md`，问「当前项目是否仍服务于我的目标 / 责任领域？」
- 有没有「高效地做着不该做的事」的项目？该砍的砍。

### ⑤ 三环平衡审计（横轴 · Laura Vanderkam，纵轴的补角）

> 纵轴（④）查「每件事该不该做」；横轴查「三大类是否失衡」——纵横互补，一个防做错事、一个防顾此失彼。来源 Laura Vanderkam 的 career / relationships / self 三环（Ringmaster）。

- 把 `horizons.md` 的 20k 责任领域**粗分到 career / relationships / self 三类**，看本周精力是不是全压在 career、relationships / self 两类挂零。
- 对挂零的一类问：**这周这环有没有一件「有名字」的事**（写得出具体活动 + 时间 + 频率，如「周三晚 9:00 陪家人 30 分钟」而非「多陪陪家人」）？写不出 = 这环失声，补一件占进下周。
- **Calm 红线（沿用本 skill 风格）**：三环只做平衡提示，不打分、不评判、用户跳过不催。

## 工作流
1. 跑本 skill 的 `scripts/gtd_review_prep.sh` 拿预回顾包；缺脚本时退回 `gtd_status.sh` + 手动扫描全部清单。
2. 先执行 organize 机械卫生：能安全自动处理的处理完；需拍板的收束成一批问题。
3. 按 ①②③④ 顺序推进 review；每段只把需要判断的点给用户，其他由 AI 先整理、起草、归位。
4. 用户确认后再落盘：清 inbox、销项、补下一步、移动 someday、补齐 product ideas 可见性、推进/降级/删除 product ideas、更新 projects/waiting-for。
5. 用 `templates/weekly-review-template.md` 记一份当周回顾快照（落 `05_每日记录/` 或项目目录，**非** memory/gtd/）。
6. 收尾给用户一句「系统状态」总结 + 下周最该推进的 3 件事。**3 件事用 Laura Vanderkam 三招收口**：① 对没排进的事做一次「我没时间 X = X 不是这周优先级」翻译，确认是主动取舍、不是遗漏；② 给 3 件里最容易被工作挤掉的那件（多在 relationships/self 环）配一个**同周内的 back-up slot**（备用时段，主时段被吃掉时自动跳备份，不重新决策）；③ 重复性的事「三次/周即习惯」，不必每天、别用完美主义否定。

## 质量检查
- [ ] inbox 清空到零
- [ ] 已完成 project 已删除；剩余每个 project 都挂着至少一个有效下一步 block link（无 stalled 残留）
- [ ] 每条 product idea 都有 `GTD 可见性`，且能指向 project / next-action
- [ ] waiting-for 该催的已点出
- [ ] 做了 Horizons 巡检，不只是横向理清
- [ ] 给出了下周聚焦的 3 件事，且已对照 hard landscape 容量
- [ ] 做了三环平衡审计（career/relationships/self 无挂零环；挂零已补一件占进下周）
- [ ] 下周 3 件事已用优先级翻译收口，高价值那件配了同周内 back-up slot
- [ ] 用户只需要确认少数判断点，没有被迫逐项翻原始清单
