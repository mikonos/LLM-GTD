# 每周回顾清单（Weekly Review · Allen 标准）

> **关键成功因子。** 建议固定时段（如周五下午 60–90 分钟）。节律比完美更重要。

## 0. AI 预回顾包（先让系统把脏活做掉）
- [ ] 跑 `scripts/gtd_review_prep.sh`，拿全景数字 + 风险项 + 确认队列
- [ ] 自动执行 organize 的机械卫生：错情境、重复、死勾、明显孤儿、stalled 检出
- [ ] 生成候选：待删/待补下一步/待催办/可能启动的 someday/下周 3 件事
- [ ] 标出哪些是 AI 已自动处理，哪些必须用户确认

## ① Get Clear（清空）
- [ ] 收集散落各处的「东西」（脑中、便签、聊天里答应的事）→ 全部捕捉进 inbox
- [ ] 清空 `inbox.md`：逐项 clarify 到零

## ② Get Current（更新）
- [ ] `next-actions.md`：完成的销项；不再相关的删；每条仍是有效下一步？
- [ ] `calendar.md`：回看上周（有无遗留收尾）+ 前看本周（硬约定准备好了吗）
- [ ] `waiting-for.md`：逐条看委派日期，哪些该催了？
- [ ] `projects.md`：先删掉成果已达成的项目；剩余项目确认挂着至少一个有效下一步 block link；多条只保留可并行动作（stalled 当场补）；成果是否仍想要？

## ③ Get Creative（创造）
- [ ] `someday-maybe.md`：有哪条成熟了，拉进 active？过时的删
- [ ] 本周有无新念头/项目要加入？

## ④ Horizons 巡检（纵轴）
- [ ] 读 `horizons.md`，问：当前项目是否服务于 30k 目标 / 20k 责任领域？
- [ ] 有没有「高效地做着不该做的事」的项目 → 砍或重估

## 收尾
- [ ] 用 `templates/weekly-review-template.md` 记一份快照（落 `05_每日记录/`）
- [ ] 给出下周最该推进的 **3 件事**
- [ ] 确认后再落盘：清 inbox、销项、补下一步、移动 someday、更新 waiting-for/projects

## 触发节律建议
- v1.6：每周固定时段跑 `/gtd-review`；AI 先生成预回顾包，用户只确认少数判断点。
- 可选自动提醒：用 loop / cron / launchd 每周一次调用 `scripts/gtd_review_prep.sh` 并提示开始 review。**需用户明确同意再装**，不默认开启。
- 定时任务只能提醒和生成预回顾包；不自动删改清单、不写日历、不发消息、不确定下周重点。
