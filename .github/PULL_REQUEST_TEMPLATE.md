<!-- Thanks for contributing to LLM-GTD. -->

**What & why**
What does this change and what problem does it solve?

**Which layer(s)**
- [ ] State (`memory/gtd/`)
- [ ] Logic (skill `SKILL.md`)
- [ ] Adapter (Claude Code / Cursor / Codex)
- [ ] Cadence / scripts
- [ ] Docs

**Design checklist**
- [ ] `SKILL.md` stays platform-neutral (no hard-coded tool names; translations live in `references/capability-map.md`)
- [ ] No personal data / absolute paths leaked (paths use `__VAULT__` where install-substituted)
- [ ] Keeps engage & review human-led; calendar/high-consequence writes stay confirmation-gated, fail-closed
- [ ] If multi-surface, behavior parity across Claude Code / Cursor / Codex
- [ ] CHANGELOG / evolution-log updated if user-facing

**Tested on**
- [ ] Claude Code  - [ ] Cursor  - [ ] Codex
