# LLM-GTD

[中文](README.zh-CN.md) | English

**A portable GTD harness for LLM agents.**

Not a todo app. Not another productivity prompt. LLM-GTD is a trusted external system that lets
Claude Code, Cursor, and Codex help you capture, clarify, organize, choose, and review your work
without turning your life into a pile of half-processed tasks.

> The installable skill is named `gtd-harness`.
> **LLM-GTD** is the project and repository name.

## The Short Version

Most AI productivity workflows fail for the same reason most human GTD systems fail: the inbox fills,
the next action is vague, the project has no current move, and the weekly review gets skipped.

LLM-GTD gives the agent a harness:

- plain Markdown state in `memory/gtd/`
- a full GTD workflow, not just inbox triage
- six commands: `init`, `capture`, `clarify`, `organize`, `engage`, `review`
- one shared trusted system across Claude Code, Cursor, and Codex
- confirmation gates for calendar writes and other high-consequence actions

The model does what it is good at: drafting next actions, cleaning structure, spotting stale items,
and preparing reviews.

You keep what should stay human: commitment, priority, reflection, and final choice.

## Why This Exists

Public agent skills around GTD tend to fall into two buckets:

1. **Single workflow skills** such as inbox processing or weekly review.
2. **Broad Life OS / second-brain systems** that include GTD as one part of a larger personal OS.

Those are useful, but they often miss the hardest part: a durable trusted system that an agent can
maintain every day without scattering state across tools, chats, and half-written notes.

LLM-GTD is narrower and deeper. It turns GTD into a reusable agent harness:

```
LLM = judgment, language, drafting
Harness = state, workflow, cadence, adapter, safety boundary
```

David Allen gave us the operating system for commitments. LLM-GTD makes that operating system
agent-native.

## What It Does

| You want to... | Command | What happens |
|---|---|---|
| set up the trusted system | `gtd-init` | creates the eight GTD lists, installs/refreshes Codex slash prompts, and checks wiring |
| capture a thought or task | `gtd-capture` | writes it to inbox first, then auto-clarifies small inputs |
| process inbox items | `gtd-clarify` | turns vague "stuff" into next actions, projects, waiting-for, reference, or someday |
| clean the system | `gtd-organize` | fixes mechanical drift: orphan actions, stalled projects, bad contexts, duplicates |
| decide what to do now | `gtd-engage` | suggests 3-5 context-fit next actions based on context, time, energy, and priority |
| run the weekly review | `gtd-review` | generates a read-only prep package, cleans mechanical drift, then reviews inbox/calendar/waiting/projects/horizons |

The important design choice: **capture, clarify, and mechanical organize can be mostly automated;
engage and review stay human-led.**

## The Trusted State

LLM-GTD stores its operating state in eight plain Markdown files:

| File | GTD list | Purpose |
|---|---|---|
| `memory/gtd/inbox.md` | Inbox | zero-friction capture sink |
| `memory/gtd/next-actions.md` | Next Actions | concrete single-step actions grouped by context |
| `memory/gtd/projects.md` | Projects | outcomes that require more than one action, each with a current next action |
| `memory/gtd/waiting-for.md` | Waiting For | delegated or pending items, with person and agreement |
| `memory/gtd/someday-maybe.md` | Someday/Maybe | things you do not commit to now but do not want to lose |
| `memory/gtd/calendar.md` | Calendar fallback | hard landscape only, used only when the real calendar is unavailable |
| `memory/gtd/reference.md` | Reference | non-actionable support material |
| `memory/gtd/horizons.md` | Horizons | purpose, vision, goals, areas, projects, and runway |

No database. No hidden app state. No vendor lock-in. A file is a file.

## How It Works

LLM-GTD has four layers:

```
LLM
  does judgment, interpretation, next-action drafting

Harness
  State      memory/gtd/*.md
  Logic      src/skill/SKILL.md + sub-skills
  Adapter    Claude Code commands, Cursor skill rules, Codex prompts
  Cadence    weekly review workflow and optional reminders
```

The same skill package and the same `memory/gtd/` state can be used from multiple agent surfaces:

| Platform | Front end | State |
|---|---|---|
| Claude Code | `.claude/commands/gtd*.md` | same `memory/gtd/` |
| Cursor | `.cursor/skills/gtd-harness/` plus keyword rules | same `memory/gtd/` |
| Codex | `~/.codex/prompts/gtd*.md` plus optional `gtd-orchestrator` | same `memory/gtd/` |

## Why It Is Different

**It is a complete GTD loop, not an inbox prompt.**
Capture, clarify, organize, engage, and review are all first-class.

**It treats GTD as a harness, not a chatbot personality.**
The agent can be replaced. The state and workflow remain.

**It keeps knowledge and action separate.**
Actions go to GTD. Ideas and notes should go to your note system, such as a Zettelkasten.

**It uses AI where AI actually helps.**
Drafting a concrete next action, finding stale projects, and cleaning list structure are good AI jobs.
Choosing what you value and what you commit to are not.

**It fails closed around calendar writes.**
If Google Calendar is connected, it is the only hard landscape. Calendar writes require a checkable
proposal and explicit confirmation. If the tool fails, LLM-GTD does not pretend anything happened.

## Install

```bash
git clone <your-fork-url> LLM-GTD
cd LLM-GTD
./install.sh /path/to/your/vault
```

If you omit the vault path, the installer uses the current directory:

```bash
./install.sh
```

The installer copies:

- `src/skill/` to `<vault>/.cursor/skills/gtd-harness/`
- Claude Code commands to `<vault>/.claude/commands/`
- Codex prompts to `~/.codex/prompts/`
- the Codex orchestrator to `<vault>/.codex/agents/`
- the initial GTD state to `<vault>/memory/gtd/`

It also prints two optional manual wiring steps:

- merge `snippets/cursor-skill-rules.json` into your Cursor skill rules
- merge `snippets/AGENTS.routing.md` into your workspace `AGENTS.md`

## Requirements

- Bash
- Python 3 for status/dashboard helpers
- Claude Code, Cursor, or Codex, depending on which surface you use
- Optional: Google Calendar access if you want real calendar reads and confirmed writes

## Quick Start

Initialize:

```bash
./install.sh /path/to/your/vault
```

Then try one of these from your agent:

```text
/gtd-capture Renew passport before the summer trip
/gtd-clarify
/gtd-engage
/gtd-review
```

Natural-language triggers are supported by the skill prompts, for example:

```text
Help me clear my head.
Help me sort through these pending items.
I have 30 minutes right now. What should I do?
Run a weekly review.
```

You can also use `/gtd` as a general entry point. You do not have to pick a specific sub-command:

```text
/gtd Schedule coffee with Jack tomorrow afternoon at the Starbucks near my home.
```

Check the system state:

```bash
bash .cursor/skills/gtd-harness/scripts/gtd_status.sh
```

## Example Flow

You say:

```text
/gtd-capture Ask Mei about the school form, renew passport, maybe learn piano, save the tax PDF
```

LLM-GTD first captures everything, then clarifies what can be safely inferred:

- `Ask Mei about the school form` becomes a concrete next action or waiting-for item.
- `renew passport` becomes a project if it needs multiple steps.
- `maybe learn piano` goes to someday/maybe unless you commit to it.
- `save the tax PDF` goes to reference unless it implies an action.

If the agent cannot safely infer your commitment, it asks instead of pretending.

→ Full five-step walkthrough (capture → clarify → engage → review): [docs/demo.md](docs/demo.md).

## Repository Layout

```text
src/skill/            core gtd-harness skill package
src/claude-commands/  Claude Code slash commands
src/codex-prompts/    Codex slash prompts
src/codex-agents/     Codex orchestrator agent
snippets/             optional routing snippets for Cursor and AGENTS.md
docs/design.md        architecture and design notes
docs/demo.md          a day-with-LLM-GTD walkthrough (the five steps)
install.sh            installer
CHANGELOG.md          project changelog
```

## Design Boundaries

- **The inbox is not the system.** It is only the capture sink.
- **A next action must be physical and concrete.** "Handle taxes" is not a next action. "Email CPA the W-2 PDF" is.
- **Projects must have a current next action.** A project without a next action is a stalled promise.
- **Calendar is sacred.** Only time-specific commitments belong there.
- **Weekly review is not optional.** Without review, GTD decays into a task pile.
- **No hidden writes.** Calendar writes and other high-consequence actions need confirmation.
- **Knowledge is not action.** Notes, insights, and research belong in your knowledge system, not in `next-actions.md`.

## Related Work

LLM-GTD was shaped by looking at existing public agent-skill patterns:

- [natea/ExoMind](https://github.com/natea/ExoMind/tree/main/skills) includes Life OS skills such as inbox processing, email inbox processing, and weekly review.
- [huytieu/COG-second-brain](https://github.com/huytieu/COG-second-brain) is a broader agentic second-brain system with capture and weekly check-in workflows.
- [openai/skills](https://github.com/openai/skills) shows the current Codex skill packaging pattern.

LLM-GTD is deliberately smaller than a Life OS and more complete than a single inbox skill. It is the
GTD commitment loop, packaged as a portable harness.

## Language

The README is in English for open-source discovery.

The skill prompts are currently written in Chinese because the original operating environment is Chinese.
The methodology is David Allen's GTD; the implementation language can be localized.

## License

MIT. See [LICENSE](LICENSE).
