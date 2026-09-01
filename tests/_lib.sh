#!/usr/bin/env bash
# tests/_lib.sh — shared harness for tests/<domain>.test.sh [filter]
#
#   source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh" "$@"
#   assert_eq    "<gate>: case name" "expected line" cmd…      # exact first-line-free compare of stdout
#   assert_match "<gate>: case name" "regex"         cmd…      # bash ERE over stdout
#   assert_line  "<gate>: case name" "regex"         cmd…      # regex over the FIRST stdout line only
#   assert_rc    "<gate>: case name" N               cmd…      # exit code
#   finish                                                     # summary + exit code
#
# Case names start with the gate name ("sources: …") so `tests/evidence.test.sh sources` runs
# just that gate. A filter that matches zero cases is a FAIL — silence must never read as green.
set -uo pipefail
export LC_ALL=C

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCORE="$ROOT/scripts/score-guild.sh"
HANDOFF="$ROOT/scripts/validate-handoff.sh"
FIX="$ROOT/tests/fixtures"
FILTER="${1:-}"
SUITE="$(basename "${BASH_SOURCE[1]:-$0}" .test.sh)"

fails=0; n=0; matched=0

_run_case() { # name expected mode cmd…
  local name="$1" expected="$2" mode="$3"; shift 3
  if [[ -n "$FILTER" && "$name" != *"$FILTER"* ]]; then return 0; fi
  matched=$((matched + 1)); n=$((n + 1))
  local actual rc ok=0
  actual="$("$@" 2>/dev/null)"; rc=$?
  case "$mode" in
    eq)    [[ "$expected" == "$actual" ]] && ok=1 ;;
    match) [[ "$actual" =~ $expected ]] && ok=1 ;;
    line)  [[ "$(printf '%s\n' "$actual" | head -1)" =~ $expected ]] && ok=1 ;;
    rc)    [[ "$rc" == "$expected" ]] && ok=1; actual="exit $rc" ;;
  esac
  if [[ $ok -eq 1 ]]; then echo "ok $n — $name"
  else echo "FAIL $n — $name: expected [$expected] got [$actual]"; fails=$((fails + 1)); fi
}
assert_eq()    { local name="$1" exp="$2"; shift 2; _run_case "$name" "$exp" eq "$@"; }
assert_match() { local name="$1" exp="$2"; shift 2; _run_case "$name" "$exp" match "$@"; }
assert_line()  { local name="$1" exp="$2"; shift 2; _run_case "$name" "$exp" line "$@"; }
assert_rc()    { local name="$1" exp="$2"; shift 2; _run_case "$name" "$exp" rc "$@"; }
gate()         { bash "$SCORE" "$@"; }   # gate <name> [args…]

finish() {
  if [[ -n "$FILTER" && $matched -eq 0 ]]; then
    echo "FAIL — no case matched filter [$FILTER] in $SUITE"; exit 1
  fi
  echo "$(echo "$SUITE" | tr '[:lower:]' '[:upper:]')_SELFTEST: $((n - fails))/$n passed"
  [[ $fails -eq 0 ]]
}
