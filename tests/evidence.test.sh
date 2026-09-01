#!/usr/bin/env bash
# evidence.test.sh — fixture tests for the evidence gates: sources, claims, citations.
#   usage: tests/evidence.test.sh [sources|claims|citations]
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh" "$@"
E="$FIX/evidence"; C="$FIX/citations"

# ---- sources -------------------------------------------------------------------------------
assert_line "sources: good 13-col ledger is VALID with tier counts" \
  "^SOURCES: VALID total=4 t1=2 t2=1 t3=1 t4=0 unverified=0$" gate sources "$E/sources.tsv"
assert_rc   "sources: good ledger exits 0" 0 gate sources "$E/sources.tsv"
assert_line "sources: bad ledger (dup id, bad tier, bare locator, captcha fetch) is INVALID" \
  "^SOURCES: INVALID" gate sources "$E/sources-bad.tsv"
assert_rc   "sources: bad ledger exits 1" 1 gate sources "$E/sources-bad.tsv"
assert_match "sources: bad ledger names the captcha fetch_status" "fetch_status" \
  bash -c 'bash "$1" sources "$2" 2>&1 >/dev/null' _ "$SCORE" "$E/sources-bad.tsv"
assert_rc   "sources: missing file exits 2" 2 gate sources "$E/does-not-exist.tsv"

# ---- claims --------------------------------------------------------------------------------
assert_line "claims: good ledger is VALID (high on 2×T1/T2, moderate on 1, low on T3)" \
  "^CLAIMS: VALID total=3 high=1 moderate=1 low=1 contested=0 orphans=0$" gate claims "$E/claims.tsv" "$E/sources.tsv"
assert_line "claims: bad ledger (high on one T3, orphan S-9, uncitable status) is INVALID" \
  "^CLAIMS: INVALID" gate claims "$E/claims-bad.tsv" "$E/sources.tsv"
assert_match "claims: bad ledger reports the orphan" "orphans=1" gate claims "$E/claims-bad.tsv" "$E/sources.tsv"
assert_rc   "claims: bad ledger exits 1" 1 gate claims "$E/claims-bad.tsv" "$E/sources.tsv"
assert_rc   "claims: missing sources file exits 2" 2 gate claims "$E/claims.tsv" "$E/nope.tsv"

# ---- citations -----------------------------------------------------------------------------
assert_eq   "citations: every number in the good doc carries a resolving [C-n] (years ignored)" \
  "UNSOURCED_CLAIMS: 0" gate citations "$C/good.md" "$E/claims.tsv"
assert_line "citations: bad doc has an unsourced percentage and an orphan [C-99]" \
  "^UNSOURCED_CLAIMS: [1-9][0-9]*$" gate citations "$C/bad.md" "$E/claims.tsv"
assert_match "citations: bad doc offenders are listed on stderr" "orphan token \[C-99\]" \
  bash -c 'bash "$1" citations "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$C/bad.md" "$E/claims.tsv"
assert_rc   "citations: missing doc exits 2" 2 gate citations "$C/none.md" "$E/claims.tsv"

finish
