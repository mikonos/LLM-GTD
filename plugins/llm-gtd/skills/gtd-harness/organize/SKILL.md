---
name: gtd-organize
description: GTD skill 场景命令 · 组织（结构卫生）。AI 自动跑机械记账（孤儿/stalled/约束镜头/死勾），只把需用户拍板的浮上来。在 engage/review 前自动先扫。GTD 第三步。
parent: gtd-harness
---


# GTD · organize（结构卫生）

**视角**：David Allen，AI-native。clarify 已做每条即时落位；organize 只修复结构漂移，不重新发明分类。

## 何时跑

- engage 之前自动先扫，避免 stalled 项目漏出。
- review 的 Get Current 阶段自动跑。
- 外部 calendar provider 从不可达恢复为可达后，对账 `calendar.md` 兜底项。
- 月度 someday / product ideas 重估。
- 用户单独要求 `/gtd-organize`、清理结构、卡住项目、重复项、情境/约束归位。

## 加载与边界

- 先读 `references/list-definitions.md`：清单边界、动作权限、Obsidian 链接规则以它为唯一真源。
- 涉及外部日历读写时，再读 `references/capability-map.md`。
- 自动化边界：机械卫生可自动；承诺判断、高后果外部动作、发消息、approval 操作不能自动。

## 自动 vs 需确认

| 类别 | 可自动做 | 需用户确认 |
|---|---|---|
| 孤儿 | 检出 next-action / project 失链；能唯一匹配时补 block link | 多个可能归属或结果不明 |
| 完成项目 | 成果明确达成且无仍需推动的下一步 → 删除项目块 | 成果是否达成不确定、项目该不该砍 |
| stalled 项目 | 起草一个具体下一步并挂回 project | 起草不出、需要改变承诺 |
| 约束/镜头卫生 | 补明显缺失的预计时长 / 精力档 / 真实约束；旧 @ 分组转为兼容信号 | 需要用户判断场景或优先级 |
| 死勾/重复 | 清理已完成残留、明显重复项 | 疑似重复但语义不同 |
| calendar 兜底 | 已确认进入外部日历的兜底项可删除；普通待办移回 next-actions | 外部日历不可达、过期但状态不明、冲突/疑似重复 |
| someday / product ideas | 标出成熟候选；为缺可见性的 product idea 起草下一步 | 是否启动 / 删除 / 降级 |

## 工作流

1. 扫描 `memory/gtd/` 核心清单和 `product-ideas.md`。
2. 按 `list-definitions.md` 判断每条是否在正确清单；机械错位直接移动，判断不明的收集起来。
3. 对 projects 做三问：成果是否已达成？是否有有效 next-actions / waiting-for block link？多条下一步是否真正可并行？
4. 对 next-actions 补轻字段：预计时长 / 精力档 / 真实约束；旧 `@电脑/@电话` 仅保留为工具约束信号。
5. 对 `calendar.md` 兜底项按外部 calendar provider 可达性对账；成功外部化后删除本地副本，失败则保留并浮上来。
6. 对 someday / product ideas 做月度重估；product ideas 缺 project / next-action 可见性时起草候选。
7. 输出一行自动处理汇总 + 一组需确认问题；不要逐条打断。

## 质量检查

- [ ] 已先读 `references/list-definitions.md`，没有在本文件复制另一套清单定义
- [ ] 机械类（孤儿、缺轻字段、死勾、明显重复）已自动修并汇总
- [ ] 已完成 project 已删除；未完成 project 有有效 next-action / waiting-for block link，或已列入待确认
- [ ] `calendar.md` 已对账：已同步项移出、普通待办归位、未确认硬日程保留并浮上来
- [ ] 判断类批量问，未替用户做承诺判断
- [ ] 未执行发消息、自动 approval、未确认外部写入等高后果动作
