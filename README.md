# LLM-GTD

**A GTD (Getting Things Done) agent harness for Claude Code, Cursor, and Codex.**
One source of truth, one trusted-system state, three platform front-ends.

> The installable skill is named `gtd-harness` (its directory and commands keep that name);
> **LLM-GTD** is the project / repo name.

> Agent = LLM + harness. The LLM ships with each platform. This repo is the *harness* —
> the trusted external system that lets your mind go "mind like water": the lists (state),
> the five-step workflow (logic), the review cadence (control flow), and the cross-platform
> adapter (so the same skill plugs into Claude Code, Cursor, and Codex).

> ⚠️ **Language note:** the skill prompts and docs are written in **Chinese (中文)**.
> The methodology is David Allen's GTD; the prose is Chinese. README is English.

---

## Why

Classic GTD separates **Capture** and **Clarify** because the *human* brain pays a cost to
switch into decision mode. An AI pays ~zero. So this harness keeps GTD's discipline but lets
the AI do the mechanical work and surfaces only what genuinely needs *your* judgment.

**AI-automation map** (the core design idea):

| GTD step | Who does it | Why |
|---|---|---|
| Capture  | 🤖 AI, instant | zero-friction, never lose it |
| Clarify  | 🤖 AI auto (single item) + asks on forks | drafting the next action is AI's strength |
| Organize | 🤖 AI auto (mechanical hygiene) + batch-asks | orphans / stalled / contexts = bookkeeping |
| Engage   | 👤 AI offers candidates, **you choose** | "what to do now" is your call |
| Review   | 👤 AI preps, **you reflect** | weekly reflection on direction can't be outsourced |

> AI takes over *maintaining the trusted system*; it cleanly leaves *choosing & reflecting* to you.

---

## Architecture — four layers

```
LLM  (per platform — does Clarify's judgment: actionable? next action?)
└─ HARNESS  (this repo)
   ├─ State    memory/gtd/*.md      — eight lists, plain markdown, identical across platforms
   ├─ Logic    skill/ SKILL.md      — platform-neutral workflow, no tool names
   ├─ Adapter  3 thin front-ends + references/capability-map.md (intent verb → per-platform tool)
   └─ Cadence  weekly review command (cron optional, off by default)
```

**The eight lists** (`memory/gtd/`): `inbox` · `next-actions` (by context) · `projects` ·
`waiting-for` · `someday-maybe` · `calendar` (hard landscape; reuses Google Calendar if connected) ·
`reference` · `horizons` (the six Horizons of Focus).

**Six commands**: `init` · `capture` · `clarify` · `organize` · `engage` · `review`.

---

## Install

```bash
git clone <your-fork-url> LLM-GTD
cd LLM-GTD
./install.sh /path/to/your/vault      # defaults to current dir
```

The installer copies the skill into `<vault>/.cursor/skills/gtd-harness/`, drops Claude Code
commands into `<vault>/.claude/commands/`, Codex prompts into `~/.codex/prompts/`, the Codex
agent into `<vault>/.codex/agents/`, and runs `gtd_init.sh` to create `memory/gtd/`.
Two optional manual steps (Cursor keyword triggers + AGENTS.md routing) are printed at the end —
see `snippets/`.

**Requirements:** bash, Python 3 (for the dashboard counts). Claude Code / Cursor / Codex as you use them.
Codex shell calls in the prompts assume an `rtk`-style proxy; plain shell works too — edit `capability-map.md` if you don't use one.

---

## Usage

| You want to… | Claude Code | Codex |
|---|---|---|
| set up / self-check | `/gtd-init` | `/gtd-init` or `rtk bash …/scripts/gtd_init.sh` |
| capture something | `/gtd-capture <thing>` | `/gtd-capture` or just say it |
| clear the inbox | `/gtd-clarify` | `/gtd-clarify` |
| tidy structure | `/gtd-organize` | `/gtd-organize` |
| what to do now | `/gtd-engage` | `/gtd-engage` |
| weekly review | `/gtd-review` | `/gtd-review` |
| see the dashboard | `bash .cursor/skills/gtd-harness/scripts/gtd_status.sh` | same |

In Cursor, just say "GTD / 收集 / 这周做什么 / 每周回顾" once keyword triggers are wired.
First time: try **"帮我清空大脑" (mind sweep)** to dump everything in, then auto-clarify sorts it.

---

## Platform model (why three front-ends)

| Platform | Discovery | Invocation | Scope |
|---|---|---|---|
| Claude Code | SessionStart loads skills | `/gtd-*` thin commands + Skill tool | project (`.claude/commands/`) |
| Cursor | `skill-rules.json` keyword hook | reads `SKILL.md` | project (`.cursor/`) |
| Codex | `rtk cat` / AGENTS.md routing | `/gtd-*` prompts + `gtd-orchestrator` agent | global prompts (`~/.codex/prompts/`) + project agent |

All three read the **same** `.cursor/skills/gtd-harness/` source and the **same** `memory/gtd/` state.
`references/capability-map.md` is the written contract translating intent verbs to each platform's tools.

---

## Repo layout

```
src/skill/            → installs to .cursor/skills/gtd-harness/   (the core package)
src/claude-commands/  → installs to .claude/commands/            (__VAULT__ filled at install)
src/codex-prompts/    → installs to ~/.codex/prompts/
src/codex-agents/     → installs to .codex/agents/
snippets/             cursor-skill-rules.json · AGENTS.routing.md  (manual merge)
docs/design.md        four-layer design write-up
install.sh            one-shot installer
```

---

## Design boundaries

- **One calendar.** If Google Calendar is connected it is the only hard landscape; `calendar.md`
  is a fallback, never a copy.
- **Writes need confirmation.** Calendar/schedule writes are drafted as a checkable proposal and
  only claimed done after a tool confirms — fail-closed, never fabricated.
- **Knowledge ≠ action.** Ideas/notes route to your note system (e.g. Zettelkasten), not GTD lists.
- **Don't skip the weekly review.** Without Reflect it isn't GTD.

## License

MIT — see [LICENSE](LICENSE).

Built with [Claude Code](https://claude.com/claude-code). Methodology: David Allen, *Getting Things Done*.
