---
name: gtd-clarify
description: GTD skill 场景命令 · 理清。对 inbox 每一项跑决策树（可行动吗→2分钟/委派/推迟/项目；不可行动→垃圾/someday/reference），并落位。GTD 第二+三步（理清即归位）。
parent: gtd-harness
---


# GTD · clarify（理清 + 归位）

**视角**：David Allen。Clarify 是 GTD 最锋利的工序——把模糊的「东西（stuff）」逐项问成可执行的结论。多数人的待办系统瘫痪，就因为收件箱里堆的是没被理清的「东西」，而不是「下一步行动」。理清和归位（organize）通常一气呵成，故本命令兼做落位。

## 加载与边界

- 清单去向和动作权限：先读 `references/list-definitions.md`。
- 下一步含糊或需要解释标准：读 `references/clarify-decision-tree.md`。
- 涉及 hard landscape / 写日历：读 `references/capability-map.md`。
- 自动化边界：清楚的条目可自动归位；承诺本身、最终完成口径或外部写入冲突不清时问一句。

## 何时跑
- `inbox.md` 有待理清项（dashboard 提示）。
- 用户说「帮我理一理收件箱」「这些待办怎么归」「逐条过一遍」。
- 导入旧数据后「待补轻字段」段需要重判。

## 决策树（对 inbox 每一项逐条问）

```
这是什么？它需要行动吗？
├── 否 → 三个去向：
│   ├── 没用/过期        → 删除（垃圾桶）
│   ├── 暂不做但不愿忘   → someday-maybe.md
│   ├── 产品/功能/场景机会 → product-ideas.md（保留机会原文）+ projects/next-actions（日常可见）
│   └── 备查/支持材料    → reference.md（知识/想法类 → 移交 ZK 管线 fleeting-note）
│
└── 是 → 下一步具体的物理动作是什么？
    ├── < 2 分钟         → 立刻做（two-minute rule），做完即销项
    ├── 该别人做         → 委派 → waiting-for.md（记人名+约定+日期）
    └── 自己做、>2 分钟  →
         ├── 特定时间/日才做  → hard landscape（日历）：先查目标时间窗；无冲突且信息完整时写入可达的 calendar provider；不可达或信息缺关键字段则降级
         └── 尽快做          → next-actions.md（行动池；写清预计时长 / 精力档 / 真实约束）
    ※ 若完成需要 >1 步 → 同时在 projects.md 立项（成果+下一步），下一步进 next-actions
```

## 工作流

1. 读 `inbox.md`，逐项跑决策树。一次理清一项，不跳。
2. **关键问题**：
   - 「需要行动吗？」——这道闸把行动与知识分开（知识 → ZK 管线，不进 GTD 清单）。
   - 「下一步具体的物理动作是什么？」——必须是可见的物理动作（"打电话给同事 A 确认资料口径"），不是"处理资料"。动词具体，拒绝空动词。
   - 「这条的完成到底算什么？」——先定义 **outcome / 完成口径**，再决定它该进 `waiting-for`、`next-actions`、`projects` 还是可以闭环。不要把“approval passed”“约上时间”“拿到回复”这类里程碑，自动当成最终完成，除非用户明确这样定义。
   - 「这条行动的预计时长 / 精力档 / 真实约束是什么？」——只写轻字段，不把镜头变成复杂标签系统。默认由 AI 估计，明显拿不准才问一句。
3. **落位**：按决策树把该项追加到目标清单对应分组末尾（格式见各清单模板）。
   - 进 next-actions 必带三类轻字段：`预计时长`（2分钟 / 10分钟 / 30分钟 / 60-90分钟）、`精力档`（低精力 / 中精力 / 深工作 / 情绪耗能低）、`真实约束`（硬地点/场景、工具/渠道、人在场、准备链、采购、会议前、证件/付款/文件/设备等）。旧 `@电脑/@电话/@外出/@家/@议程-人` 分组仅作兼容，不再默认当主分类。
   - 明确是产品想法/功能机会/场景机会时，进 `product-ideas.md` 保留原始机会，并默认同步创建 `projects.md` + `next-actions.md` 的可见工作项；只有用户明确说「先存不处理 / 只捕捉」才暂不升级。
   - 立项时在 projects.md 写成果 + 下一步，并把下一步同步进 next-actions。项目里的「下一步行动」不要只写「见 next-actions」或泛泛情境；应链接到 next-actions 的具体条目 block，例如先在 action 行末加 `^na-short-id-YYYYMMDD`，再在 project 写 `[[next-actions#^na-short-id-YYYYMMDD|具体下一步行动]]（约束：需要电脑）`。
   - GTD 内部标题引用用 Obsidian heading link：项目引用写 `[[projects#项目名|项目名]]`；支持材料引用写 `[[reference#条目名|条目名]]`。裸 `[[标题]]` 只用于真实独立文件。
   - 更新既有项目时，若期望成果已经达成且没有仍需推动的下一步 → 从 projects.md 删除整个项目块；不要写「下一步行动：无」或把已完成项目留作记录。
   - **等待项（waiting-for）要同时写清两层**：`当前在等什么` 与 `最终什么才算完成`。尤其是 payment flow、approval flow、法务流转、退款、返款这类事项，`approval passed / 已提交 / 对方回复 / 技术评估开始` 往往只是里程碑，不等于闭环。若最终完成口径是“到账 / 签字完成 / 实物收到 / 真正约成并发生”，就必须在 waiting-for 文案或约定里写明，避免提前删项。
   - 2 分钟能做完的，提示用户「这条 <2 分钟，建议现在就做」。
   - **特定时间事 → 日历（hard landscape）**：单一日历铁律——外部 calendar provider 可达时优先写外部 provider，全部不可达才写 `calendar.md` 兜底；**不抄副本**。写外部日历是高后果操作，但日程信息完整时可自动写入；写入前先读目标时间段的 hard landscape，若同时间段已有事件或前后缓冲不足以履约，列出冲突并停止写入，提示改期、取消、委派或降级为 next-action/someday；外部 tool 返回成功才报「已写入」，失败/不可达则按 `references/capability-map.md` 逐级降级并如实说明，**绝不谎报**。缺日期、时间、标题/对象等关键字段时，只问缺失字段；会议缺时长时默认 60 分钟。
4. 落位后**从 inbox 删除该项**（理清完就不该再留收件箱）。
5. 信息不足以判断下一步 → 落 next-actions 写「TBD + 缺什么信息」，或反问用户一句。

## session 状态输入的理清口径

- session 状态不是一个待办项目本身；先拆成原子条目，再逐条过 clarify 决策树。
- 新承诺 / 项目阻塞 → `projects.md` + `next-actions.md`；等别人 → `waiting-for.md`；特定日/时才有意义 → calendar provider / `calendar.md` 逐级兜底；产品机会 → `product-ideas.md` + `projects.md` + `next-actions.md`；活跃项目支持材料 → `reference.md`；纯知识洞察 → ZK 管线。
- 不把“今日总结 / 本轮总结”作为一整条留在 `inbox.md` 或 `reference.md`。GTD 只承载承诺系统的变化，不承载聊天流水账。
- 完成 clarify 后按 `templates/session-close-template.md` 输出固定五段；没有内容的段落写“无”，不要省略。

## 质量检查
- [ ] inbox 每项都有了明确去向（六去向之一），无残留
- [ ] 进 next-actions 的都是**具体物理动作** + 带预计时长 / 精力档 / 真实约束；project 的「下一步行动」能直达具体 action block
- [ ] >1 步的都立了 project 且挂了下一步（无 stalled）
- [ ] GTD 内部标题引用使用 `[[文件名#标题|标题]]`，未把清单内标题误写成独立文件链接
- [ ] 期望成果已达成的 project 已删除，未留下「下一步行动：无」
- [ ] waiting-for 条目已写清当前等待对象/里程碑，以及最终何时才算完成；未把中间里程碑误判为闭环
- [ ] 写硬日程前已检查目标时间段冲突；有冲突时未直接写入
- [ ] 知识/想法类已移交 ZK 管线，未污染 GTD 清单
- [ ] session 状态已拆成原子 GTD 条目，未把整段总结塞进清单，并用固定五段收尾
- [ ] 2 分钟法则被识别并提示
