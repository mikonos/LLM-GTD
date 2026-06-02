---
name: gtd-review
description: GTD harness 场景命令 · 每周回顾（关键成功因子）。Get Clear / Get Current / Get Creative 三段 + Horizons 巡检。GTD 第四步 Reflect。
parent: gtd-harness
---


# GTD · review（每周回顾 / Reflect）

**视角**：David Allen 原话——「The Weekly Review is the critical success factor.」没有它，前四步全部坍塌，系统在两周内失去可信、退回大脑焦虑。回顾不是补做事，是**保养系统的信任**。

## 何时跑
- 每周固定一次（建议周五；节律见 `references/weekly-review-checklist.md`）。
- 用户说「做每周回顾」「周复盘」「过一遍我的系统」「weekly review」。
- 系统感觉乱了/不信任了——这正是该回顾的信号。

## 三段式 + 纵轴（Allen 标准流程）

### ① Get Clear（清空）
- 清空 `inbox.md`：逐项 clarify 到零（调用 clarify 工作流）。
- 收拢散落各处的「东西」（笔记、脑中悬而未决）一并捕捉进系统。

### ② Get Current（更新）
- 过 `next-actions.md`：已完成的销项；不再相关的删；每条仍是有效的下一步吗？
- 过**日历（hard landscape）**：上周遗留/本周将至的硬约定。先读**真实 GCal**（可达则唯一真源，见 `references/capability-map.md`）；不可达再读 `calendar.md` 兜底并注明可能不全。**不把 GCal 抄进 calendar.md**（单一日历）。
- 过 `waiting-for.md`：哪些该催了？逐条看委派日期。
- 过 `projects.md`：先问**项目成果是否已经达成**；已达成就删除整个项目块（不归档、不写「下一步行动：无」）。未达成的项目再问是否挂着有效下一步；stalled 的当场补。项目成果是否仍想要？

### ③ Get Creative（创造）
- 过 `someday-maybe.md`：有哪条成熟了，值得拉进 active？
- 本周有没有任何新念头/项目想加进来？

### ④ Horizons 巡检（纵轴，回顾的升华）
- 抬升到 30k+：读 `horizons.md`，问「当前项目是否仍服务于我的目标 / 责任领域？」
- 有没有「高效地做着不该做的事」的项目？该砍的砍。

## 工作流
1. 跑 `bash .cursor/skills/gtd-harness/scripts/gtd_status.sh` 拿全景，识别 inbox 积压 / stalled 项目。
2. 按 ①②③④ 顺序逐段执行，每段产出明确动作（销项/补下一步/移动）。
3. 用 `templates/weekly-review-template.md` 记一份当周回顾快照（落 `05_每日记录/` 或项目目录，**非** memory/gtd/）。
4. 收尾给用户一句「系统状态」总结 + 下周最该推进的 3 件事。

## 质量检查
- [ ] inbox 清空到零
- [ ] 已完成 project 已删除；剩余每个 project 都挂着有效下一步（无 stalled 残留）
- [ ] waiting-for 该催的已点出
- [ ] 做了 Horizons 巡检，不只是横向理清
- [ ] 给出了下周聚焦的 3 件事
