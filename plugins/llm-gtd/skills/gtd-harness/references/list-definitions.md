# 核心八清单 + 扩展清单定义（是什么 / 不是什么）

可信系统的边界。每张清单职责单一，混入异物就失去可信。

| 清单 | 是什么 | **不是**什么 | 组织方式 |
|---|---|---|---|
| `inbox.md` | 未理清的捕捉入口 | 不是待办清单（这里的东西还没被判定） | 先进先出 |
| `next-actions.md` | 已理清的单步可执行动作行动池 | 不是项目、不是特定时间事，也不是按软工具标签维护的分类系统 | 行动池 + 轻字段：预计时长 / 精力档 / 真实约束；旧 @电脑/@电话/@外出/@家/@议程 分组仅兼容历史 |
| `projects.md` | >1 步的期望成果 | 不是单步动作、不是模糊愿望、不是完整任务树 | 每条 ## 块 = 成果 + 一个或多个当前下一步 block link + 支持材料指针 |
| `waiting-for.md` | 委派出去/在等别人的 | 不是自己的下一步 | [人名] + 在等什么 + 约定 + 委派日期 |
| `calendar.md` | **仅**特定日/时才有意义的硬约定 | 不是普通待办（日历神圣，杂事会毁掉它的可信度） | 按日期 |
| `someday-maybe.md` | 暂不承诺、孵化中 | 不是已承诺要做的 | 触发条件（什么情况下值得启动） |
| `product-ideas.md` | 产品、功能、场景、机会域的原始机会与假设；每条还应有 project / next-action 可见性 | 不是普通人生愿望，也不是没有下一步的冷藏 backlog | 机会 / 用户场景 / 假设 / 证据状态 / 升级条件 / GTD 可见性 |
| `reference.md` | 无需行动的备查 + 项目支持材料 | 不是知识/洞察笔记（那走 ZK 管线） | 备查 / 项目支持两段 |
| `horizons.md` | 六个高度视野 | 不是任务清单（是方向校准） | 50k→跑道 六层 |

## 三条最易违反的边界
1. **next-actions 里塞了多步成果** → 应拆：成果进 projects，第一步留 next-actions。
2. **calendar 里塞了普通待办** → 日历只放「这天/这点才做」的，其余进 next-actions。
3. **product-ideas 和 someday 混用** → 产品机会进 `product-ideas.md` 并同步到 project / next-action；普通“也许以后做”进 `someday-maybe.md`。
4. **GTD 清单里塞了知识笔记** → 知识/洞察走 `fleeting-note` → ZK 管线，不进任何 GTD 清单。
5. **projects 里塞完整任务树** → 只保留当前可并行的 next-action / waiting-for block links；里程碑、依赖和任务树进 `reference.md` 或项目文档。

## 动作权限表

| 动作 | 权限档 | 口径 |
|---|---|---|
| 读取清单、生成 dashboard、生成预回顾包 | 只读 | 不改变 GTD state |
| 新输入追加到 `inbox.md` | 可自动 | capture 永远先落盘 |
| 单条 capture 后 clarify 归位 | 可自动 | 只在行动/知识、承诺本身、期望成果不清时问一句 |
| 从 `inbox.md` 删除已 clarify 的原条目 | 可自动 | 必须已写入目标清单或明确移交 ZK |
| 移动明显错位条目 | 可自动 | 追加到目标清单后再从原位删除 |
| 补预计时长 / 精力档 / 真实约束 | 可自动 | 明显不确定时列为待确认 |
| 删除已完成 next action | 可自动 | 用户明确宣告完成或有强证据 |
| 删除已完成 project 块 | 可自动 | 期望成果已达成且无仍需推动的下一步 |
| 起草 stalled project 下一步 | 可自动 | 可 act-then-surface，用户可一句话改 |
| 启动 someday / 删除 product idea / 砍项目 | 需确认 | 这是承诺判断，不自动拍板 |
| 写入外部 calendar provider | 条件自动 | 日程信息完整、目标时段无冲突、provider 可达；tool 成功前不得声称完成 |
| 删除 `calendar.md` 兜底项 | 条件自动 | 已确认写入外部日历，或已移回其他 GTD 清单 |
| 发消息、催办、通知、委派他人 | 需确认 | 可起草话术，不自动发送 |
| approve / reject / withdraw / cc approval | 禁止自动 | Approval Radar 只能只读扫描 |
| 把 Engage 候选排进日历 | 需确认 | 候选是菜单，不是今日承诺 |

## Obsidian 链接规则

- 指向 `memory/gtd/` 某个文件内标题：用 `[[文件名#标题|标题]]`，例如 `[[reference#项目支持材料|项目支持材料]]`。
- 指向 `next-actions.md` / `waiting-for.md` 某条具体行动：优先用 block link，例如 action 行末加 `^na-short-id-YYYYMMDD`，project 里写一个或多个 `[[next-actions#^na-short-id-YYYYMMDD|具体下一步行动]]（约束：需要电脑）`；等待项写 `[[waiting-for#^wf-short-id-YYYYMMDD|等待某人交付什么]]（等待）`。
- 指向真实独立文件：才用裸 `[[文件名]]`。
- 不要把清单内标题写成裸 `[[标题]]`，否则 Obsidian 会把它当成待创建的新文件。
