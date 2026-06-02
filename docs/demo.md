# Demo — a day with LLM-GTD

[中文](demo.zh-CN.md) | English

A realistic transcript of the five steps. Examples are illustrative; your wording can be natural.

---

## Featured: a project that advances as you report back

This is the move generic to-do tools can't make. You don't hand the agent a tidy task — you hand it
an *intention*. It recognizes a multi-step **project**, sets the *right first action*, and when you
come back with progress, it **closes the old next action and derives the next one** — keeping the
project alive without you re-planning.

**Turn 1** — a vague intention:

> You:
```
/gtd I want to get my daughter into table tennis
```
> LLM-GTD:
```
Filed per GTD.

Made it a project:  📁 "Daughter's table-tennis interest & training path"

First action → Next Actions @home:
  Talk with her for 10 min — does she want to try it, current level,
  how many sessions/week she'd accept, what she does/doesn't enjoy.

I did NOT enroll, schedule, contact a coach, or write to the calendar.
GTD state verified: Inbox 0, Projects 3, Next Actions 3, stalled 0.

Note: the organizer suggests a later @computer action — "shortlist 3 nearby kids'
table-tennis options". My call: ask her first, then research providers.
```
*It refused to jump to enrollment. The right first action for a project about a *person* is to talk
to that person — and it deferred the research step on purpose.*

**Turn 2** — later, you report back:

> You:
```
/gtd Talked with my daughter — she's really into table tennis, can do two sessions/week, ~1h each
```
> LLM-GTD:
```
Clarified and filed.

Your "talk with her 10 min" is checked off Next Actions; the project advances to its next action:
  Shortlist 2-3 table-tennis classes suitable for her — record slots for two
  sessions/week (~1h each), price, distance, and trial-class options.
  → next-actions.md

Project support material updated: she's interested, OK with two sessions/week;
I read your "~1h" as the session length but marked it needs-confirmation.
  → projects.md + reference.md

Check: Inbox 0, Projects 3, no stalled.
```
*The project moved one step forward on its own. The completed action was closed, the new next action
was derived from what you learned, support material captured the facts, and an inferred detail
("~1h") was flagged rather than assumed.*

**Why this matters:** a project without a current next action is a stalled promise. Here the harness
keeps the promise live across days, doing the bookkeeping, while you only ever supply judgment and
report reality.

---

## 0. Set up (once)

```bash
./install.sh ~/my-vault
```
```
✅ skill 包 → .cursor/skills/gtd-harness/
✅ Claude Code 命令 → .claude/commands/（/gtd-* ）
✅ Codex slash 命令 → ~/.codex/prompts/
✅ Codex agent → .codex/agents/gtd-orchestrator.toml
── 初始化 memory/gtd/ ──  ✅ 八清单已建
```

---

## 1. Capture → auto-clarify (single item)

> You:
```
/gtd-capture Renew passport before the summer trip
```
> LLM-GTD:
```
已记并理清：「Renew passport before the summer trip」
→ projects.md「Renew passport」（成果：有效护照在出行前到手）
→ next-actions @errands：查最近的受理点与所需材料
要改归类/动作就说一声。
```
*It captured first (never lost), then clarified one item and filed it. A multi-step outcome became a
project with a concrete next action.*

---

## 2. Mind sweep (bulk → captured first, then batch-clarified)

> You:
```
Help me clear my head.
```
> LLM-GTD walks a trigger list, dumps everything to `inbox.md` **without interrupting**, then:
```
捕捉了 14 项到 inbox。要我现在逐条理清吗？（批量）
```
*High-volume capture stays zero-friction; clarify happens as a batch afterward.*

---

## 3. Engage — what to do now

> You:
```
/gtd-engage  I have 30 minutes, low energy, at my computer
```
> LLM-GTD (silently runs organize hygiene first, then):
```
@电脑 · 30 分钟 · 低精力 —— 现在最值得做：
1. 回邮件确认下周评审时间（~5 分钟）
2. 把护照材料清单整理进 reference（~10 分钟）
3. 草拟周报开头三段（~20 分钟）
（今天硬约定：16:00 与团队同步 · 该催：上周委派给同事的数据还没回）
```
*Filtered by context + time + energy; priority cross-checked against Horizons. You choose.*

---

## 4. Review — the weekly keystone

> You:
```
/gtd-review
```
> LLM-GTD generates a read-only prep package, cleans mechanical drift, then walks you through:
```
── 系统全景 ── inbox 0 · next-actions 9 · projects 4（stalled 0）· waiting 2 · someday 6
① Get Clear   ✅ inbox 已清空
② Get Current 销项 3；该催 1（同事数据）；项目都挂着有效下一步
③ Get Creative someday「学钢琴」看起来还不到启动时机，保留
④ Horizons    「重写个人网站」项目不服务于本季任何目标 → 建议砍或移 someday
下周聚焦 3 件：①… ②… ③…
```
*The AI preps and cleans; **you** do the reflection — that part can't be outsourced.*

---

## What stayed human

Capture, clarify, and mechanical organize were automated. **Engage** (what to do now) and
**Review** (is this still the right direction) kept you in the loop by design — which is exactly
where GTD's value lives.
