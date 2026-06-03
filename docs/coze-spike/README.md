# Coze Spike Pack

This pack turns the 2026-06-03 project note into an executable Hosted Coze
spike. The goal is not to build a GTD chatbot. The goal is to test whether
Hosted Coze can carry the LLM-GTD trusted-system state machine:

```text
capture -> clarify suggestion -> confirm -> write state -> GCal read/write -> audit -> undo
```

## Current Status

Local preparation is complete when this directory exists and validates:

- `schema.json`: eight Coze tables, enums, safety gates, and invariants.
- `clarify-system-prompt.txt`: model node prompt for `clarify_gtd_item`.
- `workflows.md`: workflow contracts for capture, clarify, confirm, calendar,
  audit, and undo.
- `acceptance-samples.jsonl`: the 20-sample spike test set.
- `results-template.md`: a manual run log for the Coze console.
- `run_local_baseline.py`: deterministic local mock baseline for the same 20
  samples.
- `console-build-runbook.md`: step-by-step Hosted Coze console build guide.

Hosted Coze console setup is not completed by these files. It requires a Coze
workspace, a test Google Calendar, and OAuth/API credentials inside the user's
account. No Coze or Google Calendar credentials were present in the local
environment during pack creation.

## Hosted Coze Login

Official international entry:

- https://www.coze.com/sign?redirect=%2Fhome

Current visible login options:

- Continue with Google.
- Phone number, then Next.

Use Google login for this spike if possible. The spike later needs Google
Calendar read/write on a dedicated test calendar, so using the same Google
account for Coze login and calendar authorization reduces account mismatch
risk.

Current login status checked from local Chrome:

- URL: `https://www.coze.com/home`
- Title: `Home - Coze`
- Google Calendar connector account: `nancheng.liu@gmail.com`

After login, the expected route is:

1. Enter Coze home/workspace.
2. Create or select an LLM-GTD Spike workspace.
3. Create a test bot/project.
4. Create the eight data tables from `schema.json`.
5. Create the workflows from `workflows.md`.
6. Connect only a dedicated test Google Calendar.

Use `console-build-runbook.md` for the exact table fields and Day 1 smoke test.

If another operator is helping from outside the Coze account, hand them one of
these post-login states before continuing:

- "I am on Coze home and can see workspace/project cards."
- "I am inside workspace `<name>`."
- "I am inside project/bot `<name>`."
- "I see an onboarding step asking for profile/workspace setup."
- "Login failed with `<error text>`."

## Local Baseline

Before building in the Coze console, run the deterministic local baseline:

```bash
python3 docs/coze-spike/run_local_baseline.py --write-results
```

This writes:

- `local-baseline-results.json`
- `local-baseline-results.md`

Current local baseline result:

- 20 samples passed.
- 5 confirmation rows.
- 83 audit logs.
- 0 global invariant failures.
- Undo checks passed for normal table writes and calendar compensation.

The baseline uses a mock calendar connector and does not call Google Calendar.
It proves only the reference state-machine path: capture, clarify, confirmation
gate, state write, audit, and undo semantics. The product verdict still comes
from the Hosted Coze run recorded in `results-template.md`.

## Source Note Requirements

The source note defines these hard requirements:

- Use Hosted Coze first, not self-hosted Coze Studio.
- Build a closed-loop spike, not a full product.
- Use a test Google Calendar only.
- Never write GCal when title/date/start time is missing, outside the test calendar, or when the connector failed.
- Never show a failed GCal write as successful.
- Keep AI suggestions separate from state writes.
- Write audit logs for every state change.
- Provide undo for normal state writes.
- Route GCal undo to a compensation path instead of silently deleting events.
- Run all 20 samples before deciding whether Coze can be the v1 main system.

The note also includes two expected categories that are not in its first enum
list: `two_minute_suggestion` and `delete_request`. This pack makes both
explicit so the spike can test them instead of losing them in generic actions.

## 3-5 Day Execution Plan

### Day 0: Account and Safety Preflight

- Create or select a Hosted Coze workspace.
- Create a dedicated test Google Calendar.
- Confirm the test calendar id.
- Confirm no production calendar, family calendar, medical item, school item,
  or payment item will be used in the spike.
- Check Coze docs and console support for table schema, select, update, delete,
  filtering, export, and workflow multi-table writes.

### Day 1: Tables and Clarify

- Create the eight tables from `schema.json`.
- Create a test bot and workflow.
- Add the prompt from `clarify-system-prompt.txt` to the model node.
- Implement `capture_gtd_item`.
- Implement `clarify_gtd_item`.
- Run samples 1-5.
- Pass condition: each input first lands in `inbox_items`; clarify output is
  fixed JSON; no final GTD table is mutated by clarify.

### Day 2: Confirmation and State Writes

- Implement `apply_or_confirm_suggestion`.
- Test next action, project, waiting-for, discard, two-minute, and delete
  request paths.
- Enforce project -> at least one next action.
- Write audit logs on every state change.
- Pass condition: high-risk non-calendar paths enter `confirmation_queue`, complete
  calendar intents auto-apply, and all state writes are traceable.

### Day 3: Google Calendar

- Connect the test Google Calendar path.
- Implement `calendar_list_hard_landscape`.
- Implement `calendar_write_ready`.
- Run calendar samples 6, 7, 16, and 18.
- Pass condition: complete calendar intents write to the test GCal without a
  per-event confirmation; incomplete intents never call GCal; failed writes
  store `failed` with `failure_reason`.

### Day 4: Audit and Undo

- Implement `undo_last_operation`.
- Verify normal table writes can roll back using `before_json`.
- Verify GCal undo moves to `manual_compensation_required` or a confirmation
  queue path.
- Pass condition: the user can see what was undone, what was not undone, and why.

### Day 5: Full Sample Run and Decision

- Run all 20 samples using `acceptance-samples.jsonl`.
- Record every row in `results-template.md`.
- Decide one of:
  1. Coze one-stop route can continue.
  2. Coze can be the workflow layer, but main state needs Supabase/Postgres.
  3. Coze is demo-only and not fit for productized LLM-GTD.

## Failure Gates

Stop treating Coze as the v1 main system if any of these happens and cannot be
stably fixed:

- State errors across samples.
- AI bypasses confirmation for high-consequence actions.
- GCal write fails but UI shows success.
- Project and next action cannot stay reliably linked.
- Operations cannot be audited by a user.
- Data cannot be exported or migrated clearly.

UI polish is not a failure gate in this spike.

## Official Capability Checks

Use these official Coze pages as live capability checkpoints before and during
the console build:

- Database select node: https://www.coze.com/open/docs/guides/database_select_node
- Database update node: https://www.coze.com/open/docs/guides/database_update_node
- Database delete node: https://www.coze.com/open/docs/guides/database_delete_node
- Workflow stream run API: https://www.coze.com/open/docs/developer_guides/workflow_stream_run
- Personal access tokens: https://www.coze.com/open/api

These links are not a substitute for console verification. The spike verdict
comes from the 20-row run log, not from documentation claims.
