# Coze Workflow Contracts

These contracts define what the Hosted Coze spike must prove. Use them as the
workflow implementation checklist and as the audit basis for the 20 samples.

## `capture_gtd_item`

Input:

- `raw_text`
- `source`

Required behavior:

1. Create an `inbox_items` row with `status=captured`.
2. Call `clarify_gtd_item` with the new inbox id.
3. Return the inbox id and the AI suggestion summary.

Pass condition:

- If clarify fails, the inbox row still exists.

Forbidden:

- Do not write final GTD state from this workflow.
- Do not call Google Calendar from this workflow.

## `clarify_gtd_item`

Input:

- `inbox_item_id`

Required behavior:

1. Read the captured inbox row.
2. Run the clarify model node with `clarify-system-prompt.txt`.
3. Validate fixed JSON output.
4. Write one `ai_suggestions` row.
5. If `needs_confirmation=true`, write one `confirmation_queue` row. Complete
   calendar intents do not require confirmation; missing date/time/title should
   return `needs_clarification`.

Pass condition:

- Suggestion type distinguishes action, project, waiting, calendar, someday,
  reference, discard, needs clarification, two-minute, and delete request.

Forbidden:

- Do not mutate `projects`, `next_actions`, `waiting_for`, or
  `calendar_intents`; final state writes happen in the apply/confirmation path.
- Do not call Google Calendar.

## `apply_or_confirm_suggestion`

Input:

- `suggestion_id`
- `decision` (`confirmed`, `rejected`, or `auto_apply` for suggestions that do
  not need confirmation)

Required behavior:

1. Read the suggestion and pending confirmation row if one exists.
2. If rejected, mark confirmation as rejected and leave final GTD state unchanged.
3. If the suggestion does not need confirmation, apply it directly.
4. If confirmed or auto-applied, write to the target final state table:
   - `next_action` -> `next_actions`
   - `two_minute_suggestion` -> `next_actions` with a two-minute marker in payload or title
   - `project` -> `projects` and at least one `next_actions` row
   - `waiting_for` -> `waiting_for`
   - `calendar_intent` -> `calendar_intents` with `status=confirmed` (validated
     as complete, not a per-event user confirmation)
   - `someday` -> no active project unless the user explicitly confirms start
   - `reference_or_zk_route` -> no GTD action list write
   - `discard` -> mark inbox discarded only when the reason is clear
   - `delete_request` -> do not delete data automatically; keep confirmation/audit trail
4. Mark the inbox row `clarified` or `discarded` as appropriate.
5. Write `audit_logs`.

Pass condition:

- Every final state mutation has an audit row.
- Every project has at least one next action.

Forbidden:

- Do not call Google Calendar.
- Do not delete records silently.

## `calendar_write_ready`

Input:

- `calendar_intent_id`

Required behavior:

1. Read the calendar intent.
2. Continue only if `status=confirmed` and the intent has title, start time,
   end time, and test calendar id.
3. Set `status=writing`.
4. Call Google Calendar `create_event` for the test calendar only.
5. On success, store `google_event_id` and set `status=written`.
6. On failure, set `status=failed` and store `failure_reason`.
7. Write `audit_logs`.

Pass condition:

- Incomplete intents never call GCal.
- Failed writes never appear successful.

Forbidden:

- Do not write production calendars.
- Do not maintain a local duplicate of GCal events.

## `calendar_list_hard_landscape`

Input:

- `date_range`

Required behavior:

1. Read the test Google Calendar for the requested range.
2. Return the events as read-only hard landscape.
3. If unavailable, return `calendar_unavailable`.

Pass condition:

- The workflow reads GCal as the source of truth and does not copy events into a
  local table as a second calendar.

## `undo_last_operation`

Input:

- `audit_log_id` or `last_operation`

Required behavior:

1. Read the relevant `audit_logs` row.
2. For normal table writes, use `before_json` to roll back.
3. For GCal writes, do not silently delete the event. Mark the calendar intent
   `manual_compensation_required` or create a confirmation queue row.
4. Write a new `audit_logs` row for the undo attempt.

Pass condition:

- The user can see what was undone, what still needs compensation, and why.
