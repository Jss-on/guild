#!/usr/bin/env bash
# gov.test.sh — fixture tests for the governance gates: board, decisions, founders.
#   usage: tests/gov.test.sh [board|decisions|founders]
# Fixtures: tests/fixtures/board/{good,bad,incomplete}/ — good derives clean; bad carries the
# planted defects from the research dossier §4 (stale pipeline, missing risks section, reused ADR
# number, unsigned money/legal ADR, one-way door without a pre-mortem, ownerless risk, 90 % split,
# no cliff, unassigned IP, unsigned agreement); incomplete is fresh but missing the risks section.
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh" "$@"
B="$FIX/board"

# ---- board ---------------------------------------------------------------------------------
assert_line "board: good pack derives clean from fresh ledgers → OK" \
  "^BOARD_PACK: OK$" gate board "$B/good"
assert_rc   "board: good pack exits 0" 0 gate board "$B/good"
assert_line "board: 45-day-old pipeline ledger wins over the missing risks section → STALE" \
  "^BOARD_PACK: STALE$" gate board "$B/bad"
assert_rc   "board: stale pack exits 1" 1 gate board "$B/bad"
assert_match "board: stderr names the 45-day-old pipeline ledger" "deals\.csv.*45 d before meeting" \
  bash -c 'bash "$1" board "$2" 2>&1 >/dev/null' _ "$SCORE" "$B/bad"
assert_match "board: stderr names the missing risks section as well" "missing section B6" \
  bash -c 'bash "$1" board "$2" 2>&1 >/dev/null' _ "$SCORE" "$B/bad"
assert_line "board: fresh ledgers but no risks section → INCOMPLETE" \
  "^BOARD_PACK: INCOMPLETE$" gate board "$B/incomplete"
assert_rc   "board: incomplete pack exits 1" 1 gate board "$B/incomplete"
assert_match "board: derived line carries the generator seam values" \
  "derived: .*default_alive=1.*coverage=0\.65x" \
  bash -c 'bash "$1" board "$2" 2>&1 >/dev/null' _ "$SCORE" "$B/good"
assert_rc   "board: missing run-dir exits 2" 2 gate board "$B/does-not-exist"

# ---- decisions -----------------------------------------------------------------------------
assert_line "decisions: clean ADR log + risk register + pre-mortems → 0 violations" \
  "^GOVERNANCE_VIOLATIONS: 0$" gate decisions "$B/good/decisions.tsv" "$B/good/risks.csv"
assert_rc   "decisions: clean ledgers exit 0" 0 gate decisions "$B/good/decisions.tsv" "$B/good/risks.csv"
assert_line "decisions: planted defects are counted" \
  "^GOVERNANCE_VIOLATIONS: [1-9]" gate decisions "$B/bad/decisions.tsv" "$B/bad/risks.csv"
assert_match "decisions: stderr names the reused ADR number" "ADR-2.*reused" \
  bash -c 'bash "$1" decisions "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$B/bad/decisions.tsv" "$B/bad/risks.csv"
assert_match "decisions: stderr names the money/legal ADR accepted without a signed artifact" \
  "ADR-4.*signed_artifact" \
  bash -c 'bash "$1" decisions "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$B/bad/decisions.tsv" "$B/bad/risks.csv"
assert_match "decisions: stderr names the one-way door without a pre-mortem" \
  "ADR-5.*one-way door without a pre-mortem" \
  bash -c 'bash "$1" decisions "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$B/bad/decisions.tsv" "$B/bad/risks.csv"
assert_match "decisions: stderr names the ownerless risk row" "R-3.*no owner" \
  bash -c 'bash "$1" decisions "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$B/bad/decisions.tsv" "$B/bad/risks.csv"
assert_match "decisions: stderr names the overdue risk review" "R-6.*next_review.*past" \
  bash -c 'bash "$1" decisions "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$B/bad/decisions.tsv" "$B/bad/risks.csv"
assert_rc   "decisions: missing risk register exits 2" 2 gate decisions "$B/good/decisions.tsv" "$B/nope.csv"

# ---- founders ------------------------------------------------------------------------------
assert_line "founders: signed 50/50 with 4-year vest and 12-month cliff → VALID" \
  "^FOUNDERS_AGREEMENT: VALID" gate founders "$B/good/founders-agreement.yaml"
assert_rc   "founders: valid agreement exits 0" 0 gate founders "$B/good/founders-agreement.yaml"
assert_line "founders: 90 % split, no cliff, unassigned IP, unsigned → INVALID" \
  "^FOUNDERS_AGREEMENT: INVALID" gate founders "$B/bad/founders-agreement.yaml"
assert_rc   "founders: invalid agreement exits 1" 1 gate founders "$B/bad/founders-agreement.yaml"
assert_match "founders: stderr names the 90 % split" "split sums to 90" \
  bash -c 'bash "$1" founders "$2" 2>&1 >/dev/null' _ "$SCORE" "$B/bad/founders-agreement.yaml"
assert_match "founders: stderr names the missing cliff" "cliff_months: missing" \
  bash -c 'bash "$1" founders "$2" 2>&1 >/dev/null' _ "$SCORE" "$B/bad/founders-agreement.yaml"
assert_match "founders: stderr names the unassigned IP" "ip_assigned_to_company is false" \
  bash -c 'bash "$1" founders "$2" 2>&1 >/dev/null' _ "$SCORE" "$B/bad/founders-agreement.yaml"
assert_match "founders: stderr names the missing signature" "signed_date: missing" \
  bash -c 'bash "$1" founders "$2" 2>&1 >/dev/null' _ "$SCORE" "$B/bad/founders-agreement.yaml"
assert_rc   "founders: missing file exits 2" 2 gate founders "$B/nope.yaml"

finish
