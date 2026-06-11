---
name: gtd-capture
description: GTD skill 场景命令 · 收集。把输入零摩擦落盘 inbox，然后（默认）AI 自动 clarify 归位；也用于 session 状态收尾。GTD 第一+（自动）第二步。
parent: gtd-harness
---


# GTD · capture（收集 → 默认自动理清）

**视角**：David Allen，AI-native 改良。Allen 当年把 capture / clarify 刻意分开，是为「人脑」——人切到决策模式有成本，所以捕捉只管零摩擦倒出来，理清留到专门 session。**但 AI 切换成本≈0、能瞬间起草下一步**，所以这里默认 **capture 后自动 clarify**——前提是不破坏 Allen 的两条真智慧：① **落盘永远第一步**（先保证不丢）；② **批量/mind-sweep 不逐条打断**（高量时摩擦最致命）。

## 加载与边界

- session 收尾：先读 `templates/session-close-template.md`。
- 单条默认自动 clarify：按 `clarify/SKILL.md` 执行；清单边界不明时读 `references/list-definitions.md`。
- 自动化边界：capture 可自动落 inbox；是否承诺、期望成果不清、行动/知识不清时问一句。

## 何时跑
- 用户冒出待办、想法、提醒、承诺、未决问题、「别忘了…」。
- 用户说「记一下」「丢进收件箱」「帮我捕捉」。
- 用户要整理“今天 / 本轮 session 状态 / 本轮 session 收尾”：把会话里的承诺、阻塞、等待、硬日期、项目状态变化整理成 GTD 输入，并按固定五段输出。
- 一次性倒空大脑（mind sweep）：「我脑子太乱，帮我清空」。

## 工作流

1. **零摩擦落盘（永远先做，保证不丢）**：把每项原样追加到 `memory/gtd/inbox.md`「待理清」段末尾，一项一行，保留原始措辞：
   ```
   - 原始措辞 · 捕捉日期：YYYYMMDD
   ```

2. **session 状态预处理（不是写日志）**：用户说“整理今天 / 本轮 session 状态 / 收尾”时，先读 `templates/session-close-template.md`，再把会话压缩成 3-5 条 GTD-relevant deltas：新承诺、待确认、等待别人、硬日期、项目状态变化或阻塞。每条按原始事实写成独立 inbox item；不要把完整聊天摘要、情绪流水账或知识洞察塞进 `memory/gtd/`。知识/洞察移交 ZK 管线；只有和活跃项目直接相关的支持材料才进 `reference.md`。收尾前跑 `scripts/gtd_status.sh`，最终按模板五段输出。

3. **分流判断量级**：
   - **单条 / 少量（≤3 条）→ 默认自动 clarify**：落盘后立即对每条跑 `clarify` 决策树（见 `clarify/SKILL.md`），把它**理清归位**到正确清单 + 定下一步，然后从 inbox 删除，**一行回报**：「已理清:〈原话〉→ 〈清单〉〈情境〉（下一步:〈具体动作〉）。要改归类/动作说一声。」——act-then-surface，不逐条问答（markdown 可秒改，乐观归位 + 易纠错优于事前盘问）。
   - **批量 / mind sweep（多条）→ 先全落盘，不逐条打断**：用触发清单帮用户扫完、全丢 inbox，**然后**一次性问「要我现在逐条理清吗?」批量 clarify。保留 Allen 的零摩擦捕捉。

4. **人类判断守卫（仅这几种才停下问一句，否则别打断）**：
   - 分不清「行动 vs 知识/想法」（知识该走 ZK 管线 `fleeting-note`，不进 GTD）；
   - 明确是产品/功能/场景机会 → 自动归 `product-ideas.md` 保留原始机会，并默认同步生成 `projects.md` + `next-actions.md` 可见项，不混进 `someday-maybe.md`；只有用户明确说「先存不处理 / 只捕捉」才暂不升级；
   - 推不出具体下一步动作（信息不足）；
   - 它隐含一个「你未必想承诺」的承诺（该不该做本身要你定）；
   - 是 >1 步项目但期望成果不清。
   这几种：先落盘，再问一句确认，**不自行替用户拍板**。

5. **off-switch**：用户说「只捕捉 / 先别理 / just record」→ 纯落盘 inbox，不自动 clarify，留给之后 `/gtd-clarify`。

## 质量检查
- [ ] 落盘永远先于理清（任何情况不丢）
- [ ] 单条默认自动理清并归位 + 一行回报去向，可一句话纠错
- [ ] mind-sweep 未被逐条打断（先全捕捉，再批量理清）
- [ ] 只在四类「需你拍板」时停下问一句，其余不打断
- [ ] session 状态只提取会影响承诺系统的变化，未制造第二套日志/日报，并按五段模板输出
- [ ] 知识/想法类移交 ZK，未污染 GTD 清单
