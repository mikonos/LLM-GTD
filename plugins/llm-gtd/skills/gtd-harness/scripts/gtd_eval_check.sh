#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT="${GTD_SKILL_ROOT:-$DEFAULT_ROOT}"

fail() {
  echo "❌ $*"
  exit 1
}

ok() {
  echo "✅ $*"
}

[ -d "$ROOT" ] || fail "skill root not found: $ROOT"

skill_lines="$(wc -l < "$ROOT/SKILL.md" | tr -d ' ')"
[ "$skill_lines" -le 120 ] || fail "SKILL.md too long: ${skill_lines} lines"
ok "SKILL.md <= 120 lines (${skill_lines})"

if grep -q '^## 版本摘要' "$ROOT/SKILL.md"; then
  fail "SKILL.md still contains version summary"
fi
ok "SKILL.md has no version summary"

core_heading_count="$(grep -c '^## 核心清单' "$ROOT/organize/SKILL.md" || true)"
[ "$core_heading_count" -le 1 ] || fail "organize has duplicate core-list headings: $core_heading_count"
ok "organize has no duplicate core-list definition"

grep -q '^## 动作权限表' "$ROOT/references/list-definitions.md" || fail "list-definitions lacks action permission table"
ok "list-definitions carries action permission table"

eval_count="$(grep -c '^| E[0-9][0-9]-' "$ROOT/references/evals.md" || true)"
[ "$eval_count" -ge 12 ] || fail "not enough eval cases: $eval_count"
ok "eval cases >= 12 (${eval_count})"

if find "$ROOT" -name '*.bak-*' -print -quit | grep -q .; then
  fail "backup files remain under skill root"
fi
ok "no .bak-* files under skill root"

if grep -R -E --exclude='gtd_eval_check.sh' "description:[[:space:]]+GTD[[:space:]]+harness" "$ROOT" >/dev/null; then
  fail "public descriptions still use legacy harness wording"
fi
ok "public descriptions use GTD skill wording"

bash -n "$ROOT/scripts/gtd_init.sh"
bash -n "$ROOT/scripts/gtd_status.sh"
bash -n "$ROOT/scripts/gtd_review_prep.sh"
bash -n "$ROOT/scripts/gtd_review_prep_notify.sh"
ok "shell scripts pass bash -n"

if [ "${GTD_PRIVACY_DENYLIST:-}" != "" ]; then
  if rg -n "$GTD_PRIVACY_DENYLIST" "$ROOT"; then
    fail "privacy denylist matched under skill root"
  fi
  ok "privacy denylist has no matches"
else
  echo "ℹ️  GTD_PRIVACY_DENYLIST not set; skipped private denylist scan"
fi

echo "GTD skill eval check passed"
