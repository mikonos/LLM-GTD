#!/usr/bin/env python3
"""Run a deterministic local baseline for the Coze spike sample set.

This is not a Hosted Coze test and it does not write Google Calendar.
It is a reference state-machine check for the spike package before the
same 20 samples are run in the Coze console.
"""

from __future__ import annotations

import argparse
import copy
import json
from datetime import datetime
from pathlib import Path
from typing import Any


BASE_DATE = "2026-06-03"
BASE_TIME = "2026-06-03T09:00:00+08:00"
TEST_CALENDAR_ID = "llm-gtd-spike-test-calendar"
BASE = Path(__file__).resolve().parent


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    with path.open(encoding="utf-8") as f:
        for line in f:
            if line.strip():
                rows.append(json.loads(line))
    return rows


def new_id(prefix: str, sample_id: int) -> str:
    return f"{prefix}_{sample_id:03d}"


def audit(
    state: dict[str, list[dict[str, Any]]],
    operation: str,
    before: Any,
    after: Any,
    actor: str = "workflow",
) -> None:
    state["audit_logs"].append(
        {
            "id": f"audit_{len(state['audit_logs']) + 1:03d}",
            "operation": operation,
            "before_json": before,
            "after_json": after,
            "actor": actor,
            "created_at": BASE_TIME,
        }
    )


def infer_suggestion(sample: dict[str, Any]) -> dict[str, Any]:
    sample_id = sample["id"]
    raw = sample["input"]

    if sample_id in {1, 2, 3}:
        return {
            "suggestion_type": "next_action",
            "title": raw,
            "payload": {
                "context": sample["expected_context"],
                "project": sample["expected_project"],
            },
            "confidence": 0.9,
            "reason": "Single concrete computer action tied to an existing project.",
            "needs_confirmation": False,
            "risk_reason": None,
        }

    if sample_id == 4:
        return {
            "suggestion_type": "project",
            "title": raw,
            "payload": {
                "desired_outcome": "Create a live path for the daughter's table tennis interest with options, cadence, and trial next step.",
                "next_action": "Ask daughter for 10 minutes about interest, current level, and acceptable weekly cadence.",
                "context": "@home",
            },
            "confidence": 0.88,
            "reason": "This requires more than one step and needs a current next action.",
            "needs_confirmation": False,
            "risk_reason": None,
        }

    if sample_id == 5:
        return route_only("reference_or_zk_route", raw, "This is support material, not an action.")

    if sample_id == 6:
        return calendar_suggestion(
            raw,
            "2026-06-04T15:00:00+08:00",
            "2026-06-04T15:30:00+08:00",
            "Complete schedule item can auto-write to the test calendar.",
        )

    if sample_id == 7:
        return calendar_suggestion(
            raw,
            "2026-06-12T10:00:00+08:00",
            "2026-06-12T10:30:00+08:00",
            "Complete schedule item can auto-write to the test calendar.",
        )

    if sample_id == 8:
        return next_action(raw, "@computer", None, "Write a prompt draft in the Coze bot workflow.")

    if sample_id == 9:
        return next_action(
            "Ask Ye Yun how to configure Google Calendar connector OAuth.",
            "@computer",
            None,
            "Asking a person can be a next action until the system would send the message itself.",
        )

    if sample_id == 10:
        return {
            "suggestion_type": "waiting_for",
            "title": raw,
            "payload": {
                "person": "Coze official docs/platform capability check",
                "agreement": "Confirm whether database nodes support update/delete.",
                "due_date": None,
            },
            "confidence": 0.82,
            "reason": "The item waits on platform documentation rather than immediate user action.",
            "needs_confirmation": False,
            "risk_reason": None,
        }

    if sample_id == 11:
        return next_action(
            "Write a decision card comparing Coze and Supabase.",
            "@computer",
            None,
            "This can start as one concrete writing action.",
        )

    if sample_id == 12:
        return route_only("reference_or_zk_route", raw, "This is a platform-lock-in insight, not a GTD action.")

    if sample_id == 13:
        return route_only("someday", raw, "The wording says maybe later and should not create an active project.")

    if sample_id == 14:
        return {
            "suggestion_type": "delete_request",
            "title": raw,
            "payload": {"target": "old GTD test data"},
            "confidence": 0.94,
            "reason": "Deleting data is high-consequence and must not be automatic.",
            "needs_confirmation": True,
            "risk_reason": "Delete request.",
        }

    if sample_id == 15:
        return route_only(
            "needs_clarification",
            raw,
            "The action is vague: 'handle Coze' does not name a visible next action.",
        )

    if sample_id == 16:
        return calendar_suggestion(
            raw,
            "2026-06-10T14:00:00+08:00",
            "2026-06-10T15:00:00+08:00",
            "Complete schedule item can auto-write to the test calendar.",
        )

    if sample_id == 17:
        return {
            "suggestion_type": "two_minute_suggestion",
            "title": "Open the Coze console and check whether the workspace exists.",
            "payload": {"context": "@computer", "project": None, "completed": False},
            "confidence": 0.91,
            "reason": "This is under two minutes, but the system must not claim it has already been done.",
            "needs_confirmation": False,
            "risk_reason": None,
        }

    if sample_id == 18:
        return route_only(
            "needs_clarification",
            raw,
            "The recurring schedule is missing start date and start time; ask for missing fields instead of fabricating a calendar event.",
        )

    if sample_id == 19:
        return next_action(
            "Write a risk comparison for Hosted Coze versus self-hosted Postgres.",
            "@computer",
            None,
            "This starts as a concrete writing action.",
        )

    if sample_id == 20:
        return route_only(
            "needs_clarification",
            raw,
            "The requested reminder date is in the past on 2026-06-02, so discard is unsafe without confirmation.",
        )

    raise ValueError(f"Unsupported sample id: {sample_id}")


def next_action(title: str, context: str, project: str | None, reason: str) -> dict[str, Any]:
    return {
        "suggestion_type": "next_action",
        "title": title,
        "payload": {"context": context, "project": project},
        "confidence": 0.86,
        "reason": reason,
        "needs_confirmation": False,
        "risk_reason": None,
    }


def route_only(kind: str, title: str, reason: str) -> dict[str, Any]:
    return {
        "suggestion_type": kind,
        "title": title,
        "payload": {},
        "confidence": 0.8,
        "reason": reason,
        "needs_confirmation": False,
        "risk_reason": None,
    }


def calendar_suggestion(title: str, start: str, end: str, note: str) -> dict[str, Any]:
    return {
        "suggestion_type": "calendar_intent",
        "title": title,
        "payload": {
            "start_time": start,
            "end_time": end,
            "calendar_id": TEST_CALENDAR_ID,
        },
        "confidence": 0.9,
        "reason": f"This is tied to a specific date/time and belongs to hard landscape. {note}",
        "needs_confirmation": False,
        "risk_reason": None,
    }


def apply_suggestion(
    state: dict[str, list[dict[str, Any]]],
    sample: dict[str, Any],
    suggestion: dict[str, Any],
    inbox: dict[str, Any],
    mock_calendar: bool,
) -> dict[str, Any]:
    sample_id = sample["id"]
    kind = suggestion["suggestion_type"]
    result: dict[str, Any] = {
        "state_change": "none",
        "gcal_result": "N/A",
        "final_rows": [],
    }

    if kind in {"reference_or_zk_route", "someday", "needs_clarification"}:
        inbox_before = copy.deepcopy(inbox)
        inbox["status"] = "clarified"
        audit(state, "mark_inbox_clarified_route_only", inbox_before, copy.deepcopy(inbox))
        result["state_change"] = f"route_only:{kind}"
        return result

    if kind == "discard":
        inbox_before = copy.deepcopy(inbox)
        inbox["status"] = "discarded"
        audit(state, "mark_inbox_discarded", inbox_before, copy.deepcopy(inbox))
        result["state_change"] = "discarded"
        return result

    if kind == "delete_request":
        result["state_change"] = "delete_request_requires_confirmation_no_delete"
        return result

    if kind == "next_action":
        row = {
            "id": new_id("next_action", sample_id),
            "title": suggestion["title"],
            "context": suggestion["payload"]["context"],
            "project_id": suggestion["payload"].get("project"),
            "status": "active",
            "source_inbox_id": inbox["id"],
        }
        state["next_actions"].append(row)
        audit(state, "create_next_action", None, row)
        result["state_change"] = "next_actions"
        result["final_rows"].append(row["id"])

    elif kind == "two_minute_suggestion":
        row = {
            "id": new_id("next_action", sample_id),
            "title": suggestion["title"],
            "context": suggestion["payload"]["context"],
            "project_id": None,
            "status": "active",
            "source_inbox_id": inbox["id"],
            "two_minute": True,
            "completed": False,
        }
        state["next_actions"].append(row)
        audit(state, "create_two_minute_next_action", None, row)
        result["state_change"] = "two_minute_next_action"
        result["final_rows"].append(row["id"])

    elif kind == "project":
        project = {
            "id": new_id("project", sample_id),
            "title": suggestion["title"],
            "desired_outcome": suggestion["payload"]["desired_outcome"],
            "status": "active",
            "created_at": BASE_TIME,
        }
        action = {
            "id": new_id("next_action", sample_id),
            "title": suggestion["payload"]["next_action"],
            "context": suggestion["payload"]["context"],
            "project_id": project["id"],
            "status": "active",
            "source_inbox_id": inbox["id"],
        }
        state["projects"].append(project)
        state["next_actions"].append(action)
        audit(state, "create_project", None, project)
        audit(state, "create_project_next_action", None, action)
        result["state_change"] = "projects+next_actions"
        result["final_rows"].extend([project["id"], action["id"]])

    elif kind == "waiting_for":
        row = {
            "id": new_id("waiting_for", sample_id),
            "title": suggestion["title"],
            "person": suggestion["payload"]["person"],
            "agreement": suggestion["payload"]["agreement"],
            "due_date": suggestion["payload"].get("due_date"),
            "status": "waiting",
        }
        state["waiting_for"].append(row)
        audit(state, "create_waiting_for", None, row)
        result["state_change"] = "waiting_for"
        result["final_rows"].append(row["id"])

    elif kind == "calendar_intent":
        row = {
            "id": new_id("calendar_intent", sample_id),
            "title": suggestion["title"],
            "start_time": suggestion["payload"]["start_time"],
            "end_time": suggestion["payload"]["end_time"],
            "calendar_id": suggestion["payload"]["calendar_id"],
            "status": "confirmed",
            "google_event_id": None,
            "failure_reason": None,
        }
        if "recurrence" in suggestion["payload"]:
            row["recurrence"] = suggestion["payload"]["recurrence"]
        state["calendar_intents"].append(row)
        audit(state, "create_confirmed_calendar_intent", None, copy.deepcopy(row))
        if mock_calendar:
            before = copy.deepcopy(row)
            row["status"] = "written"
            row["google_event_id"] = f"mock_google_event_{sample_id:03d}"
            audit(state, "mock_calendar_write", before, copy.deepcopy(row), actor="google_calendar")
            result["gcal_result"] = "mock_written_no_external_call"
        else:
            result["gcal_result"] = "not_written_local_baseline"
        result["state_change"] = "calendar_intents"
        result["final_rows"].append(row["id"])

    else:
        raise ValueError(f"Unsupported suggestion type: {kind}")

    inbox_before = copy.deepcopy(inbox)
    inbox["status"] = "clarified"
    audit(state, "mark_inbox_clarified", inbox_before, copy.deepcopy(inbox))
    return result


def expected_type_matches(actual: str, expected: str) -> bool:
    if expected == actual:
        return True
    allowed = {
        "next_action_or_waiting_for": {"next_action", "waiting_for"},
        "project_or_next_action": {"project", "next_action"},
        "calendar_intent_or_someday": {"calendar_intent", "someday"},
        "discard_or_needs_clarification": {"discard", "needs_clarification"},
    }
    return actual in allowed.get(expected, set())


def evaluate_sample(
    sample: dict[str, Any],
    suggestion: dict[str, Any],
    confirmation_id: str | None,
    applied: dict[str, Any],
    state: dict[str, list[dict[str, Any]]],
) -> tuple[str, list[str]]:
    failures: list[str] = []
    kind = suggestion["suggestion_type"]
    expected = sample["expected_type"]

    if not expected_type_matches(kind, expected):
        failures.append(f"type mismatch: expected {expected}, got {kind}")

    if sample.get("must_confirm") and not confirmation_id:
        failures.append("missing confirmation row")

    if sample.get("must_not_enter_action_lists"):
        source_inbox = new_id("inbox", sample["id"])
        if any(a.get("source_inbox_id") == source_inbox for a in state["next_actions"]):
            failures.append("route-only sample entered next_actions")
        if any(p.get("title") == sample["input"] for p in state["projects"]):
            failures.append("route-only sample entered projects")

    if sample.get("must_create_desired_outcome") and not suggestion["payload"].get("desired_outcome"):
        failures.append("project missing desired_outcome")

    if sample.get("must_create_next_action"):
        project_id = new_id("project", sample["id"])
        if not any(a.get("project_id") == project_id for a in state["next_actions"]):
            failures.append("project missing next action")

    if sample.get("must_not_create_active_project"):
        if any(p.get("title") == sample["input"] and p.get("status") == "active" for p in state["projects"]):
            failures.append("someday sample created active project")

    if sample.get("must_not_delete_automatically") and applied["state_change"] != "delete_request_requires_confirmation_no_delete":
        failures.append("delete request mutated state")

    if sample.get("must_not_claim_completed") and suggestion["payload"].get("completed") is True:
        failures.append("two-minute suggestion claimed completion")

    if sample.get("calendar_scope") == "test_only":
        for row in state["calendar_intents"]:
            if row["id"] == new_id("calendar_intent", sample["id"]) and row["calendar_id"] != TEST_CALENDAR_ID:
                failures.append("calendar intent did not use test calendar")

    return ("PASS" if not failures else "FAIL", failures)


def run_baseline(mock_calendar: bool) -> dict[str, Any]:
    schema = json.loads((BASE / "schema.json").read_text(encoding="utf-8"))
    samples = load_jsonl(BASE / "acceptance-samples.jsonl")
    if len(samples) != 20:
        raise AssertionError(f"Expected 20 samples, found {len(samples)}")
    if [s["id"] for s in samples] != list(range(1, 21)):
        raise AssertionError("Sample ids must be 1..20")

    state: dict[str, list[dict[str, Any]]] = {
        "inbox_items": [],
        "ai_suggestions": [],
        "confirmation_queue": [],
        "projects": [],
        "next_actions": [],
        "waiting_for": [],
        "calendar_intents": [],
        "audit_logs": [],
    }
    results: list[dict[str, Any]] = []

    for sample in samples:
        sample_id = sample["id"]
        inbox = {
            "id": new_id("inbox", sample_id),
            "raw_text": sample["input"],
            "source": "acceptance-samples.jsonl",
            "captured_at": BASE_TIME,
            "status": "captured",
        }
        state["inbox_items"].append(inbox)
        audit(state, "capture_inbox_item", None, copy.deepcopy(inbox))

        suggestion_payload = infer_suggestion(sample)
        suggestion = {
            "id": new_id("suggestion", sample_id),
            "inbox_item_id": inbox["id"],
            "created_at": BASE_TIME,
            **suggestion_payload,
        }
        state["ai_suggestions"].append(suggestion)
        audit(state, "create_ai_suggestion", None, copy.deepcopy(suggestion), actor="ai")

        confirmation_id = None
        if suggestion["needs_confirmation"]:
            queue_row = {
                "id": new_id("confirmation", sample_id),
                "suggestion_id": suggestion["id"],
                "action_type": confirmation_action_type(suggestion),
                "risk_reason": suggestion["risk_reason"] or "Confirmation required.",
                "status": "confirmed",
                "confirmed_at": BASE_TIME,
            }
            confirmation_id = queue_row["id"]
            state["confirmation_queue"].append(queue_row)
            audit(state, "confirm_high_risk_suggestion_for_local_baseline", None, copy.deepcopy(queue_row), actor="user")

        applied = apply_suggestion(state, sample, suggestion, inbox, mock_calendar)
        verdict, failures = evaluate_sample(sample, suggestion, confirmation_id, applied, state)
        results.append(
            {
                "id": sample_id,
                "input": sample["input"],
                "expected_type": sample["expected_type"],
                "actual_type": suggestion["suggestion_type"],
                "needs_confirmation": suggestion["needs_confirmation"],
                "confirmation_id": confirmation_id,
                "state_change": applied["state_change"],
                "gcal_result": applied["gcal_result"],
                "audit_count_so_far": len(state["audit_logs"]),
                "verdict": verdict,
                "failures": failures,
            }
        )

    undo_checks = run_undo_checks(state)
    invariant_failures = check_global_invariants(state)
    return {
        "metadata": {
            "generated_at": datetime.now().isoformat(timespec="seconds"),
            "base_date": BASE_DATE,
            "schema_version": schema["version"],
            "mode": "local_mock",
            "mock_calendar": mock_calendar,
            "warning": "This is not a Hosted Coze run and does not write Google Calendar.",
        },
        "summary": {
            "samples": len(results),
            "passed": sum(1 for r in results if r["verdict"] == "PASS"),
            "failed": sum(1 for r in results if r["verdict"] == "FAIL"),
            "confirmation_rows": len(state["confirmation_queue"]),
            "audit_logs": len(state["audit_logs"]),
            "global_invariant_failures": invariant_failures,
        },
        "results": results,
        "undo_checks": undo_checks,
        "state_counts": {k: len(v) for k, v in state.items()},
    }


def confirmation_action_type(suggestion: dict[str, Any]) -> str:
    kind = suggestion["suggestion_type"]
    if kind == "calendar_intent":
        return "calendar_write"
    if kind in {"delete_request", "discard"}:
        return "delete_or_discard"
    if kind == "waiting_for":
        return "delegate_or_notify"
    return "manual_compensation"


def check_global_invariants(state: dict[str, list[dict[str, Any]]]) -> list[str]:
    failures: list[str] = []
    active_project_ids = {p["id"] for p in state["projects"] if p["status"] == "active"}
    action_project_ids = {a.get("project_id") for a in state["next_actions"] if a.get("project_id")}
    missing = active_project_ids - action_project_ids
    if missing:
        failures.append(f"active projects without next action: {sorted(missing)}")

    for intent in state["calendar_intents"]:
        if intent["calendar_id"] != TEST_CALENDAR_ID:
            failures.append(f"calendar intent outside test calendar: {intent['id']}")
        if intent["status"] == "written" and not str(intent.get("google_event_id", "")).startswith("mock_google_event_"):
            failures.append(f"written calendar intent lacks mock event id: {intent['id']}")

    if not state["audit_logs"]:
        failures.append("missing audit logs")
    return failures


def run_undo_checks(state: dict[str, list[dict[str, Any]]]) -> dict[str, Any]:
    normal = {"verdict": "SKIP", "detail": "No next action audit found."}
    calendar = {"verdict": "SKIP", "detail": "No calendar intent found."}

    clone = copy.deepcopy(state)
    next_action_audit = next((a for a in clone["audit_logs"] if a["operation"] == "create_next_action"), None)
    if next_action_audit:
        target = next_action_audit["after_json"]["id"]
        before_count = len(clone["next_actions"])
        clone["next_actions"] = [row for row in clone["next_actions"] if row["id"] != target]
        audit(clone, "undo_create_next_action", next_action_audit["after_json"], None)
        normal = {
            "verdict": "PASS" if len(clone["next_actions"]) == before_count - 1 else "FAIL",
            "detail": f"Removed {target} in cloned state.",
        }

    cal = clone["calendar_intents"][0] if clone["calendar_intents"] else None
    if cal:
        before = copy.deepcopy(cal)
        cal["status"] = "manual_compensation_required"
        audit(clone, "undo_calendar_write_requires_manual_compensation", before, copy.deepcopy(cal))
        calendar = {
            "verdict": "PASS" if cal["status"] == "manual_compensation_required" else "FAIL",
            "detail": f"Marked {cal['id']} for manual compensation in cloned state.",
        }

    return {"normal_table_write": normal, "calendar_write": calendar}


def write_markdown(report: dict[str, Any], path: Path) -> None:
    lines = [
        "# Local Baseline Results",
        "",
        "> This is a local mock baseline. It is not a Hosted Coze run and it does not write Google Calendar.",
        "",
        "## Summary",
        "",
        f"- Samples: {report['summary']['samples']}",
        f"- Passed: {report['summary']['passed']}",
        f"- Failed: {report['summary']['failed']}",
        f"- Confirmation rows: {report['summary']['confirmation_rows']}",
        f"- Audit logs: {report['summary']['audit_logs']}",
        f"- Global invariant failures: {len(report['summary']['global_invariant_failures'])}",
        "",
        "## Sample Results",
        "",
        "| # | Expected | Actual | Confirmation | State change | GCal | Verdict |",
        "|---|---|---|---|---|---|---|",
    ]
    for row in report["results"]:
        lines.append(
            "| {id} | {expected_type} | {actual_type} | {confirmation} | {state_change} | {gcal_result} | {verdict} |".format(
                confirmation=row["confirmation_id"] or "",
                **row,
            )
        )
    lines.extend(
        [
            "",
            "## Undo Checks",
            "",
            f"- Normal table write: {report['undo_checks']['normal_table_write']['verdict']} - {report['undo_checks']['normal_table_write']['detail']}",
            f"- Calendar write: {report['undo_checks']['calendar_write']['verdict']} - {report['undo_checks']['calendar_write']['detail']}",
            "",
        ]
    )
    if report["summary"]["global_invariant_failures"]:
        lines.extend(["## Global Invariant Failures", ""])
        for failure in report["summary"]["global_invariant_failures"]:
            lines.append(f"- {failure}")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--no-mock-calendar", action="store_true", help="Do not mark calendar writes as mock-written.")
    parser.add_argument("--write-results", action="store_true", help="Write local-baseline-results.json/md.")
    args = parser.parse_args()

    report = run_baseline(mock_calendar=not args.no_mock_calendar)
    if args.write_results:
        (BASE / "local-baseline-results.json").write_text(
            json.dumps(report, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        write_markdown(report, BASE / "local-baseline-results.md")

    print(json.dumps(report["summary"], ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
