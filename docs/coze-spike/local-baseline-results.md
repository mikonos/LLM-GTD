# Local Baseline Results

> This is a local mock baseline. It is not a Hosted Coze run and it does not write Google Calendar.

## Summary

- Samples: 20
- Passed: 20
- Failed: 0
- Confirmation rows: 1
- Audit logs: 77
- Global invariant failures: 0

## Sample Results

| # | Expected | Actual | Confirmation | State change | GCal | Verdict |
|---|---|---|---|---|---|---|
| 1 | next_action | next_action |  | next_actions | N/A | PASS |
| 2 | next_action | next_action |  | next_actions | N/A | PASS |
| 3 | next_action | next_action |  | next_actions | N/A | PASS |
| 4 | project | project |  | projects+next_actions | N/A | PASS |
| 5 | reference_or_zk_route | reference_or_zk_route |  | route_only:reference_or_zk_route | N/A | PASS |
| 6 | calendar_intent | calendar_intent |  | calendar_intents | mock_written_no_external_call | PASS |
| 7 | calendar_intent | calendar_intent |  | calendar_intents | mock_written_no_external_call | PASS |
| 8 | next_action | next_action |  | next_actions | N/A | PASS |
| 9 | next_action_or_waiting_for | next_action |  | next_actions | N/A | PASS |
| 10 | waiting_for | waiting_for |  | waiting_for | N/A | PASS |
| 11 | project_or_next_action | next_action |  | next_actions | N/A | PASS |
| 12 | reference_or_zk_route | reference_or_zk_route |  | route_only:reference_or_zk_route | N/A | PASS |
| 13 | someday | someday |  | route_only:someday | N/A | PASS |
| 14 | delete_request | delete_request | confirmation_014 | delete_request_requires_confirmation_no_delete | N/A | PASS |
| 15 | needs_clarification | needs_clarification |  | route_only:needs_clarification | N/A | PASS |
| 16 | calendar_intent | calendar_intent |  | calendar_intents | mock_written_no_external_call | PASS |
| 17 | two_minute_suggestion | two_minute_suggestion |  | two_minute_next_action | N/A | PASS |
| 18 | needs_clarification | needs_clarification |  | route_only:needs_clarification | N/A | PASS |
| 19 | project_or_next_action | next_action |  | next_actions | N/A | PASS |
| 20 | discard_or_needs_clarification | needs_clarification |  | route_only:needs_clarification | N/A | PASS |

## Undo Checks

- Normal table write: PASS - Removed next_action_001 in cloned state.
- Calendar write: PASS - Marked calendar_intent_006 for manual compensation in cloned state.

