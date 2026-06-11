# Changelog

All notable changes.

## v1.12 — Update command for reported reality
Added `gtd-update` for progress reports and corrections: completed next actions,
waiting-for replies, project facts, calendar changes, cancellations, and minimal
state edits. The `/gtd` router now treats "done / confirmed / replied / changed"
wording as an update instead of recapturing it as a new inbox item.

## v1.11 — Multiple current next actions per project
Projects can now list multiple current next-action / waiting-for block links
when the actions can proceed in parallel. Stalled-project detection now requires
a concrete `next-actions` or `waiting-for` block link, so empty headings and
generic "see next-actions" pointers no longer count as coverage.

## v1.10 — Calendar-provider auto-write
Complete schedule items now write directly to an available calendar provider
without per-event confirmation. Missing date/time/title fields are clarified
first; unavailable or failed provider writes fall back to `memory/gtd/calendar.md`
and are never reported as successful.

## v1.9 — Codex plugin package
Added a repo-scoped Codex plugin package under `plugins/llm-gtd/` plus
`.agents/plugins/marketplace.json`, generated from `src/skill/` by
`scripts/sync_codex_plugin.sh`. GTD scripts now support `LLM_GTD_ROOT`, legacy
`.cursor` installs, and Codex plugin mode where the current workspace is the
state root.

## v1.8 — Init installs Codex slash prompts
`gtd_init.sh` now installs or refreshes `~/.codex/prompts/gtd*.md` from bundled templates,
so running init alone can restore the Codex `/gtd` command set.

## v1.7 — Obsidian heading links for internal GTD references
Internal references to headings inside `memory/gtd/` now use `[[file#heading|heading]]`
to avoid accidentally creating standalone Obsidian files.

## v1.6 — Weekly review prep package
Weekly review now starts with an AI prep pass. Added read-only `gtd_review_prep.sh`
and optional local notification helper; updated review flow and snapshot template.

## v1.5 — Project auto-closure
Completed project blocks (outcome met, no live next action) are deleted, not archived.
Organize/review check "is it done?" before drafting a next action.

## v1.4 — Organize as AI structural hygiene
Mechanical bookkeeping (orphans / stalled / contexts / dead checkboxes) runs silently;
only genuine judgment calls (uncraftable stalled, kill?, someday promotion) are batched to you.
Auto-runs before engage and inside review.

## v1.3 — Capture auto-clarifies (AI-native)
Single captures are clarified and filed immediately (act-then-surface, one-line report, correct in one sentence).
Bulk / mind-sweep is captured first, then batch-clarified. Off-switch: "capture only".

## v1.2 — Codex slash commands + three-platform triggers
Global `~/.codex/prompts/gtd*.md` (vault-aware fail-soft), AGENTS.md routing,
plus Claude Code commands and Cursor keyword rules. One source, one `memory/gtd/` state.

## v1.1 — Calendar reuse (provider read + confirmed write)
An available calendar provider becomes the single hard landscape; `calendar.md` is fallback only.
Writes are drafted, confirmed, and only claimed done on tool success — fail-closed.

## v1.0 — Initial
Four-layer harness: `memory/gtd/` eight lists, six-command skill package, three-platform adapter,
weekly review cadence. GTD-native, context-grouped next actions, self-initializing `init`.
