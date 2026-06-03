# Hosted Coze Console Build Runbook

This runbook is for the real Hosted Coze console build. It assumes the user is
already logged in at:

https://www.coze.com/sign?redirect=%2Fhome

Use the same Google account as the test Google Calendar when possible:

`nancheng.liu@gmail.com`

Current confirmed browser state:

- Chrome URL: `https://www.coze.com/home`
- Chrome title: `Home - Coze`
- Automation limitation: Chrome JavaScript from Apple Events and Accessibility
  control are disabled, so a human must click the Coze UI until page state is
  reported back.

## Stop Rules

Stop and report the exact UI state if any of these happens:

- Coze asks for payment, plan upgrade, or irreversible publishing.
- A workflow step would write to a production calendar.
- A delete operation targets real data instead of test rows.
- Coze table fields cannot represent JSON, enum, datetime, or references.
- A Google Calendar connector asks for broader permissions than event read/create
  on a dedicated test calendar.

## Day 1 Target

Build only enough to test:

```text
capture_gtd_item -> clarify_gtd_item -> ai_suggestions + confirmation_queue
```

Do not try to finish calendar or undo on Day 1.

## Console Navigation

Use whichever labels the current Coze UI shows:

1. Home / Development / Create.
2. Create or select workspace: `LLM-GTD Spike`.
3. Create project or bot: `LLM-GTD Spike`.
4. Open Data / Database / Tables.
5. Create the eight tables below.
6. Open Workflow.
7. Create `capture_gtd_item`.
8. Create `clarify_gtd_item`.

## Table Build Order

Build in this order so references have targets:

1. `inbox_items`
2. `ai_suggestions`
3. `confirmation_queue`
4. `projects`
5. `next_actions`
6. `waiting_for`
7. `calendar_intents`
8. `audit_logs`

If Coze cannot create references, use string ids and keep the same field names.

## Tables

### `inbox_items`

Purpose: single capture sink.

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | primary id |
| `raw_text` | text | yes | original user input |
| `source` | string | yes | sample/source name |
| `captured_at` | datetime | yes | capture timestamp |
| `status` | enum/string | yes | `captured`, `clarified`, `discarded`, `failed` |

### `ai_suggestions`

Purpose: AI clarify suggestions; not final GTD state.

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | primary id |
| `inbox_item_id` | string/reference | yes | points to `inbox_items.id` |
| `suggestion_type` | enum/string | yes | see suggestion types below |
| `payload_json` | JSON/text | yes | structured payload |
| `confidence` | number | yes | 0-1 |
| `reason` | text | yes | user-readable reason |
| `needs_confirmation` | boolean | yes | high-risk gate |
| `created_at` | datetime | yes | suggestion timestamp |

Suggestion types:

- `next_action`
- `project`
- `waiting_for`
- `calendar_intent`
- `someday`
- `reference_or_zk_route`
- `discard`
- `needs_clarification`
- `two_minute_suggestion`
- `delete_request`

### `confirmation_queue`

Purpose: gate high-consequence actions and commitment decisions.

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | primary id |
| `suggestion_id` | string/reference | yes | points to `ai_suggestions.id` |
| `action_type` | enum/string | yes | `calendar_write`, `delete_or_discard`, `delegate_or_notify`, `kill_project`, `start_someday`, `change_committed_time`, `manual_compensation` |
| `risk_reason` | text | yes | why confirmation is required |
| `status` | enum/string | yes | `pending`, `confirmed`, `rejected`, `expired`, `failed` |
| `confirmed_at` | datetime | no | only after confirmation |

### `projects`

Purpose: outcomes requiring more than one step.

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | primary id |
| `title` | string | yes | project title |
| `desired_outcome` | text | yes | outcome state |
| `status` | enum/string | yes | `active`, `stalled`, `completed`, `dropped` |
| `created_at` | datetime | yes | project creation |

Invariant: every active project must have at least one `next_actions` row.

### `next_actions`

Purpose: concrete single-step actions.

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | primary id |
| `title` | string | yes | concrete action |
| `context` | enum/string | yes | `@computer`, `@phone`, `@errands`, `@home`, `@agenda-person` |
| `project_id` | string/reference | no | points to `projects.id` |
| `status` | enum/string | yes | `active`, `done`, `dropped` |
| `source_inbox_id` | string/reference | yes | points to `inbox_items.id` |

Reject vague titles using only "handle", "process", "follow up", or "research".

### `waiting_for`

Purpose: delegated or pending items.

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | primary id |
| `title` | string | yes | waiting item |
| `person` | string | yes | person/source being waited on |
| `agreement` | text | yes | expected response or agreement |
| `due_date` | date | no | optional |
| `status` | enum/string | yes | `waiting`, `received`, `cancelled` |

If the workflow would notify or delegate to a real person, it must first enter
`confirmation_queue`.

### `calendar_intents`

Purpose: pending, confirmed, written, or failed calendar intents.

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | primary id |
| `title` | string | yes | calendar title |
| `start_time` | datetime | yes | start |
| `end_time` | datetime | yes | end |
| `calendar_id` | string | yes | test calendar only |
| `status` | enum/string | yes | `draft`, `pending_confirmation`, `confirmed`, `writing`, `written`, `failed`, `manual_fallback`, `manual_compensation_required` |
| `google_event_id` | string | no | only after successful write |
| `failure_reason` | text | no | required when failed |

Invariant: only confirmed calendar intents may call Google Calendar.

### `audit_logs`

Purpose: user-readable product audit.

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | primary id |
| `operation` | string | yes | operation name |
| `before_json` | JSON/text | no | pre-state |
| `after_json` | JSON/text | yes | post-state |
| `actor` | enum/string | yes | `user`, `ai`, `workflow`, `google_calendar` |
| `created_at` | datetime | yes | audit timestamp |

## Workflow 1: `capture_gtd_item`

Input:

- `raw_text`
- `source`

Steps:

1. Create one row in `inbox_items` with `status=captured`.
2. Call `clarify_gtd_item` with the new `inbox_item_id`.
3. Return:
   - `inbox_item_id`
   - suggestion summary
   - failure reason if clarify failed

Pass condition:

- If clarify fails, the inbox row still exists.

## Workflow 2: `clarify_gtd_item`

Input:

- `inbox_item_id`

Steps:

1. Read the matching `inbox_items` row.
2. Send `raw_text` to the model node with `clarify-system-prompt.txt`.
3. Validate that model output is JSON with:
   - `suggestion_type`
   - `title`
   - `payload`
   - `confidence`
   - `reason`
   - `needs_confirmation`
   - `risk_reason`
4. Create one row in `ai_suggestions`.
5. If `needs_confirmation=true`, create one `confirmation_queue` row with
   `status=pending`.

Pass condition:

- Clarify never mutates final GTD tables: `projects`, `next_actions`,
  `waiting_for`, `calendar_intents`.

## Day 1 Smoke Samples

Run only the first five samples first:

1. next action: Laura support material.
2. next action: "随手记" material.
3. next action: table tennis class options.
4. project: daughter's table tennis path.
5. reference route: Laura weekly-plan constraints.

Expected Day 1 result:

- 5 `inbox_items`.
- 5 `ai_suggestions`.
- 0 final GTD state writes.
- 0 Google Calendar calls.
- `confirmation_queue` only if the model marks a high-risk path, which should
  not happen for samples 1-5.

## Evidence To Capture

For each smoke sample, record:

- Input.
- `inbox_items.id`.
- raw model JSON.
- `ai_suggestions.id`.
- whether `confirmation_queue` was created.
- screenshot or copied table row state.

Use `results-template.md` once all 20 samples are ready.
