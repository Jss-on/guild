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
first_line()   { "$@" 2>/dev/null | head -1; }

# ---- pass-rate ------------------------------------------------------------------------------
# 1. weighted: evidence 1 (.25) · customer 1 (.20) · offer 0 (.15) · economics 1 (.15)
#    · gtm skip · governance 0 (.10) → (.25+.20+.15)/(.85) = 0.7059 → FLOORED 0.70
assert_eq "pass-rate weighted (floored, never rounded up)" "PASS_RATE: 0.70" \
  bash "$SCORE" pass-rate "$FIX/sample-results.tsv"
# 2. evidence gate: raw (.20+.15+.15)/.75 = 0.66 but a red evidence row caps at 0.50
assert_eq "pass-rate evidence gate cap" "PASS_RATE: 0.50" \
  bash "$SCORE" pass-rate "$FIX/gate-results.tsv"
# 3. gate cap overridable via env
assert_eq "pass-rate gate cap env override" "PASS_RATE: 0.25" \
  env EVIDENCE_GATE_CAP=0.25 bash "$SCORE" pass-rate "$FIX/gate-results.tsv"
# 4. all-pass ledger is exactly 1.00 (single division — no float floor to 0.99)
assert_eq "pass-rate all-pass exactly 1.00" "PASS_RATE: 1.00" \
  bash "$SCORE" pass-rate "$FIX/open-results.tsv"
# 5. no measurable rows → honest zero, not a crash; missing file → honest zero too
assert_eq "pass-rate empty ledger honest zero" "PASS_RATE: 0.00" \
  bash "$SCORE" pass-rate "$FIX/empty-results.tsv"
assert_eq "pass-rate no such file honest zero (no implicit discovery)" "PASS_RATE: 0.00" \
  bash "$SCORE" pass-rate "$FIX/does-not-exist.tsv"
# 6. strict evidence: a pass row whose evidence path is missing becomes fail
#    fixture: evidence row → strict/evidence/claims.tsv (exists), customer row → missing
#    non-strict 1.00; strict (.25·1 + .20·0)/.45 = 0.5555 → 0.55
assert_eq "pass-rate strict: non-strict reads 1.00" "PASS_RATE: 1.00" \
  bash "$SCORE" pass-rate "$FIX/strict/guild-results.tsv"
assert_eq "pass-rate strict: missing evidence path → fail (flag)" "PASS_RATE: 0.55" \
  bash "$SCORE" pass-rate "$FIX/strict/guild-results.tsv" --strict-evidence
assert_eq "pass-rate strict: missing evidence path → fail (env)" "PASS_RATE: 0.55" \
  env GUILD_EVIDENCE_STRICT=1 bash "$SCORE" pass-rate "$FIX/strict/guild-results.tsv"

# ---- coverage -------------------------------------------------------------------------------
# 7. VRS has V-1..V-3, rows trace V-1,V-2 → 2/3 = 0.6667 → FLOORED 0.66
assert_eq "coverage RTM (floored)" "REQ_COVERAGE: 0.66" \
  bash "$SCORE" coverage "$FIX/open-results.tsv" "$FIX/cov-vrs.md"

# ---- validate (discover → build contract) ---------------------------------------------------
assert_eq "validate: complete 7-dim spec with gated rows + ICP election → VALID" "VALIDATION: VALID" \
  first_line bash "$SCORE" validate "$FIX/spec/valid.spec.yaml"
assert_match "validate: valid spec reports all dims present" "dims_present=evidence,customer,offer,economics,gtm,operations,governance" \
  bash "$SCORE" validate "$FIX/spec/valid.spec.yaml"
assert_eq "validate: missing gtm dim → INVALID" "VALIDATION: INVALID" \
  first_line bash "$SCORE" validate "$FIX/spec/missing-gtm.spec.yaml"
assert_match "validate: missing dim named" "dims_missing=gtm" \
  bash "$SCORE" validate "$FIX/spec/missing-gtm.spec.yaml"
assert_eq "validate: customer without a gated row → INVALID" "VALIDATION: INVALID" \
  first_line bash "$SCORE" validate "$FIX/spec/no-gate.spec.yaml"
assert_match "validate: gated counts reported" "gated=evidence:1,customer:0,economics:1" \
  bash "$SCORE" validate "$FIX/spec/no-gate.spec.yaml"
assert_eq "validate: no segment/ICP election → INVALID" "VALIDATION: INVALID" \
  first_line bash "$SCORE" validate "$FIX/spec/no-segment.spec.yaml"
assert_eq "validate: no acceptance block → INVALID" "VALIDATION: INVALID" \
  first_line bash "$SCORE" validate "$FIX/spec/no-acceptance.spec.yaml"
assert_eq "validate: missing file → ERROR" "VALIDATION: ERROR" \
  first_line bash "$SCORE" validate "$FIX/spec/does-not-exist.spec.yaml"
assert_match "validate: missing file exits 2" "^2$" \
  bash -c 'bash "$1" validate "$2" >/dev/null 2>&1; echo $?' _ "$SCORE" "$FIX/spec/does-not-exist.spec.yaml"

# ---- verdict --------------------------------------------------------------------------------
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
assert_eq "verdict strict: claimed-but-missing evidence blocks" "NOT_READY" \
  env GUILD_EVIDENCE_STRICT=1 bash "$SCORE" verdict "$FIX/strict/guild-results.tsv"
assert_eq "verdict non-strict on the same ledger opens" "OPEN_FOR_BUSINESS" \
  bash "$SCORE" verdict "$FIX/strict/guild-results.tsv"

# ---- handoff (schema v3.1.0, guild sources) -------------------------------------------------
assert_eq "handoff: build CONVERGED with results/metric/config/coverage → VALID" "HANDOFF: VALID" \
  bash "$HANDOFF" "$FIX/handoff-good.json"
assert_eq "handoff: expected-source match → VALID" "HANDOFF: VALID" \
  bash "$HANDOFF" "$FIX/handoff-good.json" build
assert_eq "handoff: expected-source mismatch → INVALID" "HANDOFF: INVALID" \
  bash "$HANDOFF" "$FIX/handoff-good.json" discover
assert_eq "handoff: discover with spec → VALID" "HANDOFF: VALID" \
  bash "$HANDOFF" "$FIX/handoff-discover.json"
assert_eq "handoff: board with verdict+pack → VALID" "HANDOFF: VALID" \
  bash "$HANDOFF" "$FIX/handoff-board.json"
assert_eq "handoff: board verdict outside CONTINUE|PIVOT|KILL, no pack → INVALID" "HANDOFF: INVALID" \
  bash "$HANDOFF" "$FIX/handoff-board-bad.json"
assert_eq "handoff: colon-form source + bad status + no timestamp → INVALID" "HANDOFF: INVALID" \
  bash "$HANDOFF" "$FIX/handoff-bad.json"
assert_match "handoff: missing file exits 2" "^2$" \
  bash -c 'bash "$1" "$2" >/dev/null 2>&1; echo $?' _ "$HANDOFF" "$FIX/does-not-exist.json"

# ---- usage ----------------------------------------------------------------------------------
assert_match "usage on unknown subcommand exits 2" "^2$" \
  bash -c 'bash "$1" bogus >/dev/null 2>&1; echo $?' _ "$SCORE"

if [[ -n "$FILTER" && $matched -eq 0 ]]; then
  echo "FAIL — no case matched filter [$FILTER]"; exit 1
fi
echo "SCORE_SELFTEST: $((n - fails))/$n passed"
[[ $fails -eq 0 ]]
