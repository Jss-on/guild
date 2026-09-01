#!/usr/bin/env bash
# score.test.sh — mechanical self-test of the guild scoring seam.
# The harness that preaches gates has its own gate. Runs on bash + node only.
#   usage: score.test.sh [filter]   — run only cases whose name contains <filter>;
#                                     zero matched cases = FAIL (a filter that matches nothing
#                                     must never read as green).
set -uo pipefail
export LC_ALL=C

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCORE="$ROOT/scripts/score-guild.sh"
HANDOFF="$ROOT/scripts/validate-handoff.sh"
FIX="$ROOT/tests/fixtures"
FILTER="${1:-}"

fails=0; n=0; matched=0

run_case() { # name expected mode cmd...   mode ∈ eq|match
  local name="$1" expected="$2" mode="$3"; shift 3
  if [[ -n "$FILTER" && "$name" != *"$FILTER"* ]]; then return 0; fi
  matched=$((matched + 1)); n=$((n + 1))
  local actual; actual="$("$@" 2>/dev/null)"
  local ok=0
  if [[ "$mode" == "eq" ]]; then [[ "$expected" == "$actual" ]] && ok=1
  else [[ "$actual" =~ $expected ]] && ok=1; fi
  if [[ $ok -eq 1 ]]; then echo "ok $n — $name"
  else echo "FAIL $n — $name: expected [$expected] got [$actual]"; fails=$((fails + 1)); fi
}
assert_eq()    { local name="$1" exp="$2"; shift 2; run_case "$name" "$exp" eq "$@"; }
assert_match() { local name="$1" exp="$2"; shift 2; run_case "$name" "$exp" match "$@"; }

# 1. weighted pass-rate: evidence 1 (.25) · customer 1 (.20) · offer 0 (.15) · economics 1 (.15)
#    · gtm skip · governance 0 (.10) → (.25+.20+.15)/(.85) = 0.7059 → 0.71
assert_eq "pass-rate weighted" "PASS_RATE: 0.71" \
  bash "$SCORE" pass-rate "$FIX/sample-results.tsv"

# 2. evidence gate: raw (.20+.15+.15)/.75 = 0.67 but a red evidence row caps at 0.50
assert_eq "pass-rate evidence gate cap" "PASS_RATE: 0.50" \
  bash "$SCORE" pass-rate "$FIX/gate-results.tsv"

# 3. gate cap overridable via env
assert_eq "pass-rate gate cap env override" "PASS_RATE: 0.25" \
  env EVIDENCE_GATE_CAP=0.25 bash "$SCORE" pass-rate "$FIX/gate-results.tsv"

# 4. no measurable rows → honest zero, not a crash
assert_eq "pass-rate empty ledger honest zero" "PASS_RATE: 0.00" \
  bash "$SCORE" pass-rate "$FIX/empty-results.tsv"

# 5. coverage: VRS has V-1..V-3, rows trace V-1,V-2 → 0.67
assert_eq "coverage RTM" "REQ_COVERAGE: 0.67" \
  bash "$SCORE" coverage "$FIX/open-results.tsv" "$FIX/cov-vrs.md"

# 6. verdict grammar
assert_eq "verdict evidence red blocks" "NOT_READY" \
  bash "$SCORE" verdict "$FIX/gate-results.tsv"
assert_eq "verdict must-pass customer red blocks even under a low target" "NOT_READY" \
  env TARGET_RATE=0.50 bash "$SCORE" verdict "$FIX/mustpass-results.tsv"
assert_eq "verdict coverage gap blocks" "NOT_READY" \
  bash "$SCORE" verdict "$FIX/open-results.tsv" "$FIX/cov-vrs.md"
assert_eq "verdict all green opens" "OPEN_FOR_BUSINESS" \
  bash "$SCORE" verdict "$FIX/open-results.tsv"
assert_eq "verdict paid won row → FIRST_CUSTOMER" "FIRST_CUSTOMER" \
  bash "$SCORE" verdict "$FIX/open-results.tsv" - "$FIX/pipeline-paid.tsv"
assert_eq "verdict unpaid won row stays OPEN_FOR_BUSINESS" "OPEN_FOR_BUSINESS" \
  bash "$SCORE" verdict "$FIX/open-results.tsv" - "$FIX/pipeline-unpaid.tsv"
assert_eq "verdict FIRST_CUSTOMER needs a green ledger too" "NOT_READY" \
  bash "$SCORE" verdict "$FIX/gate-results.tsv" - "$FIX/pipeline-paid.tsv"

# 7. handoff gate
assert_eq "handoff valid" "HANDOFF: VALID" bash "$HANDOFF" "$FIX/handoff-good.json"
assert_match "handoff invalid" "^HANDOFF: INVALID" bash "$HANDOFF" "$FIX/handoff-bad.json"

# 8. unknown subcommand is a hard error (exit 2), never a silent zero
assert_match "usage on unknown subcommand exits 2" "^2$" \
  bash -c 'bash "$1" bogus >/dev/null 2>&1; echo $?' _ "$SCORE"

if [[ -n "$FILTER" && $matched -eq 0 ]]; then
  echo "FAIL — no case matched filter [$FILTER]"; exit 1
fi
echo "SCORE_SELFTEST: $((n - fails))/$n passed"
[[ $fails -eq 0 ]]
