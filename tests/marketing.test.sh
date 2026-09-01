#!/usr/bin/env bash
# marketing.test.sh — fixture tests for the marketing gates: experiments, assets, consent.
#   usage: tests/marketing.test.sh [experiments|assets|consent]
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh" "$@"
X="$FIX/experiments"; AS="$FIX/assets"; CO="$FIX/consent"; E="$FIX/evidence"
gate_err() { bash -c 'bash "$0" "$@" 2>&1 >/dev/null' "$SCORE" "$@"; }

# ---- experiments ---------------------------------------------------------------------------
assert_line "experiments: good ledger (pre-registered, n reached, honest INCONCLUSIVE) is clean" \
  "^EXPERIMENT_VIOLATIONS: 0$" gate experiments "$X/good.csv"
assert_rc   "experiments: good ledger exits 0" 0 gate experiments "$X/good.csv"
assert_line "experiments: bad ledger counts the planted defects" \
  "^EXPERIMENT_VIOLATIONS: [1-9][0-9]*$" gate experiments "$X/bad.csv"
assert_match "experiments: WIN below required n is forced INCONCLUSIVE (peeking)" \
  "actual_n 300 < required_n .*must be INCONCLUSIVE" gate_err experiments "$X/bad.csv"
assert_match "experiments: ice_confidence 8 without an evidence ref is named" \
  "ice_confidence 8 > 5 without ice_evidence_ref" gate_err experiments "$X/bad.csv"
assert_match "experiments: running without approved_by is named" \
  "status=running without approved_by" gate_err experiments "$X/bad.csv"
assert_match "experiments: understated required_n is recomputed and named" \
  "required_n_per_arm 200 < computed" gate_err experiments "$X/bad.csv"
assert_rc   "experiments: missing ledger exits 2" 2 gate experiments "$X/does-not-exist.csv"

# ---- assets --------------------------------------------------------------------------------
assert_line "assets: good asset dir lints clean against claims + ICP" \
  "^ASSET_LINT: 0$" gate assets "$AS/good" "$E/claims.tsv" "$AS/_icp.yaml"
assert_rc   "assets: good asset dir exits 0" 0 gate assets "$AS/good" "$E/claims.tsv" "$AS/_icp.yaml"
assert_line "assets: bad asset dir counts the planted defects" \
  "^ASSET_LINT: [1-9][0-9]*$" gate assets "$AS/bad" "$E/claims.tsv" "$AS/_icp.yaml"
assert_match "assets: the TBD placeholder in the one-pager is named" \
  "one-pager.md line [0-9]+: placeholder \[TBD\]" gate_err assets "$AS/bad" "$E/claims.tsv" "$AS/_icp.yaml"
assert_match "assets: the two-CTA landing page is named" \
  "cta_count=2" gate_err assets "$AS/bad" "$E/claims.tsv" "$AS/_icp.yaml"
assert_match "assets: the unsubstantiated number-one superlative is named" \
  "superlative .#1. without independent third-party substantiation" gate_err assets "$AS/bad" "$E/claims.tsv" "$AS/_icp.yaml"
assert_match "assets: 40 % faster without an ev token is named" \
  "numeric claim.* without a resolving \[ev:C-n\]" gate_err assets "$AS/bad" "$E/claims.tsv" "$AS/_icp.yaml"
assert_rc   "assets: missing dir exits 2" 2 gate assets "$AS/does-not-exist" "$E/claims.tsv" "$AS/_icp.yaml"
assert_rc   "assets: missing icp exits 2" 2 gate assets "$AS/good" "$E/claims.tsv" "$AS/does-not-exist.yaml"

# ---- consent -------------------------------------------------------------------------------
assert_line "consent: good consent + sends ledgers are clean" \
  "^CONSENT_VIOLATIONS: 0$" gate consent "$CO/good-consent.csv" "$CO/good-sends.csv"
assert_rc   "consent: good ledgers exit 0" 0 gate consent "$CO/good-consent.csv" "$CO/good-sends.csv"
assert_match "consent: founder legitimate-interest outreach is flagged on stderr, not a violation" \
  "warn .*LEGITIMATE-INTEREST" gate_err consent "$CO/good-consent.csv" "$CO/good-sends.csv"
assert_line "consent: bad sends ledger counts the planted defects" \
  "^CONSENT_VIOLATIONS: [1-9][0-9]*$" gate consent "$CO/good-consent.csv" "$CO/bad-sends.csv"
assert_match "consent: the marketing send to a contact with no opt-in row is named" \
  "K-999 with no opt-in consent row" gate_err consent "$CO/good-consent.csv" "$CO/bad-sends.csv"
assert_match "consent: the send without human approval is named" \
  "no human_approved_by" gate_err consent "$CO/good-consent.csv" "$CO/bad-sends.csv"
assert_match "consent: the withdrawn contact who was still sent is named" \
  "withdrawn 2026-08-20 before the send" gate_err consent "$CO/good-consent.csv" "$CO/bad-sends.csv"
assert_match "consent: the viber send without a viber opt-in is named" \
  "does not cover viber" gate_err consent "$CO/good-consent.csv" "$CO/bad-sends.csv"
assert_rc   "consent: missing sends file exits 2" 2 gate consent "$CO/good-consent.csv" "$CO/does-not-exist.csv"

finish
