#!/usr/bin/env bash
# gtm.test.sh — fixture tests for the GTM sales gates: funnel.
#   usage: tests/gtm.test.sh [funnel]
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh" "$@"
F="$FIX/funnel"
gate_err() { bash -c 'bash "$0" "$@" 2>&1 >/dev/null' "$SCORE" "$@"; }

# ---- funnel --------------------------------------------------------------------------------
assert_line "funnel: good deals ledger (no targets) is clean" \
  "^FUNNEL_VIOLATIONS: 0$" gate funnel "$F/good-deals.csv"
assert_rc   "funnel: good deals ledger exits 0" 0 gate funnel "$F/good-deals.csv"
assert_line "funnel: good ledger with targets passes coverage, primary share and motion bands" \
  "^FUNNEL_VIOLATIONS: 0$" gate funnel "$F/good-deals.csv" "$F/targets.tsv"
assert_line "funnel: header-only TSV pipeline (fresh venture) is clean" \
  "^FUNNEL_VIOLATIONS: 0$" gate funnel "$F/header-only.tsv"
assert_line "funnel: wide pipeline.tsv with trailing invoice/payment columns parses as TSV" \
  "^FUNNEL_VIOLATIONS: 0$" gate funnel "$F/wide-pipeline.tsv"
assert_line "funnel: bad ledger counts the planted defects" \
  "^FUNNEL_VIOLATIONS: [1-9][0-9]*$" gate funnel "$F/bad-deals.csv"
assert_match "funnel: bad ledger names the commit deal with no dated next step" \
  "no dated next step" gate_err funnel "$F/bad-deals.csv"
assert_match "funnel: bad ledger names the proposal without an economic buyer" \
  "economic buyer" gate_err funnel "$F/bad-deals.csv"
assert_match "funnel: bad ledger names the triple slip still sitting in commit" \
  "close_date_slips=3" gate_err funnel "$F/bad-deals.csv"
assert_match "funnel: bad ledger names the 70-day unpaid pilot" \
  "unpaid pilot running 70 d" gate_err funnel "$F/bad-deals.csv"
assert_match "funnel: bad ledger names the 54-day stale deal" \
  "no activity for 54 d" gate_err funnel "$F/bad-deals.csv"
assert_match "funnel: bad ledger names the unreviewed contract tripwires" \
  "unlimited_liability" gate_err funnel "$F/bad-deals.csv"
assert_match "funnel: with targets the off-hypothesis segment is named" \
  "enterprise-bpo.* not in targets" gate_err funnel "$F/bad-deals.csv" "$F/targets.tsv"
assert_rc   "funnel: missing deals file exits 2" 2 gate funnel "$F/does-not-exist.csv"

finish
