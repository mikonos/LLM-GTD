# Coze Spike Results Template

Base date for relative sample interpretation: 2026-06-03 Asia/Shanghai.

Test calendar id:

Coze workspace:

Bot/workflow:

Operator:

Run date:

| # | Input | Expected type | AI suggestion | Confirmation row | State change | GCal result | Audit | Undo | Verdict |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Open Laura support material and weekly-plan material | next_action |  |  |  | N/A |  |  |  |
| 2 | Search existing notes for "quick capture" feature | next_action |  |  |  | N/A |  |  |  |
| 3 | Shortlist 2-3 table tennis class options | next_action |  |  |  | N/A |  |  |  |
| 4 | Build daughter's table tennis path | project |  |  |  | N/A |  |  |  |
| 5 | Laura weekly-plan constraints | reference_or_zk_route |  |  |  | N/A |  |  |  |
| 6 | Tomorrow 15:00 GTD Spike review on test calendar | calendar_intent |  |  |  |  |  |  |  |
| 7 | Next Friday 10:00 check Coze table state | calendar_intent |  |  |  |  |  |  |  |
| 8 | Write a clarify prompt for Coze test bot | next_action |  |  |  | N/A |  |  |  |
| 9 | Ask Ye Yun how to configure GCal connector OAuth | next_action or waiting_for |  |  |  | N/A |  |  |  |
| 10 | Wait for Coze docs to confirm database update/delete | waiting_for |  |  |  | N/A |  |  |  |
| 11 | Write a Coze vs Supabase decision card | project or next_action |  |  |  | N/A |  |  |  |
| 12 | Coze source of truth export risk | reference_or_zk_route |  |  |  | N/A |  |  |  |
| 13 | Maybe personal productivity SaaS later | someday |  |  |  | N/A |  |  |  |
| 14 | Delete all old GTD test data | delete_request |  |  |  | N/A |  |  |  |
| 15 | Help me handle Coze | needs_clarification |  |  |  | N/A |  |  |  |
| 16 | Create fake meeting on 2026-06-10 14:00-15:00 | calendar_intent |  |  |  |  |  |  |  |
| 17 | Open Coze console to check workspace exists | two_minute_suggestion |  |  |  | N/A |  |  |  |
| 18 | Review GTD productization monthly | calendar_intent or someday |  |  |  |  |  |  |  |
| 19 | Compare Hosted Coze and self-hosted Postgres risks | project or next_action |  |  |  | N/A |  |  |  |
| 20 | Expired reminder from 2026-06-02 | discard or needs_clarification |  |  |  | N/A |  |  |  |

## Verdict

Choose exactly one after all 20 samples:

- [ ] Coze one-stop route can continue.
- [ ] Coze can be the workflow layer, but main state needs Supabase/Postgres.
- [ ] Coze is demo-only and not fit for productized LLM-GTD.

## Blocking Findings

- State errors:
- Confirmation bypass:
- Calendar false success:
- Project linkage failure:
- Audit failure:
- Export or migration risk:

