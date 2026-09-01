#!/usr/bin/env bash
# offer.test.sh — fixture tests for the offer-domain gates: positioning, offers.
#   usage: tests/offer.test.sh [positioning|offers]
# The positioning cases run against PRIVATE copies of the shared icp/alternatives fixtures
# (tests/fixtures/positioning/_icp.yaml, _alternatives.csv) so this suite does not depend on the
# discovery/market domains; the frozen scorer wires the shared paths after merge.
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh" "$@"
P="$FIX/positioning"; O="$FIX/offers"
ICP="$P/_icp.yaml"; ALTS="$P/_alternatives.csv"

# ---- positioning ---------------------------------------------------------------------------
assert_eq   "positioning: good canvas is clean (six slots resolve to ICP / alternatives / attributes / themes)" \
  "POSITIONING_VIOLATIONS: 0" gate positioning "$P/good.yaml" "$ALTS" "$ICP"
assert_rc   "positioning: good canvas exits 0" 0 gate positioning "$P/good.yaml" "$ALTS" "$ICP"
assert_line "positioning: bad canvas counts violations" "^POSITIONING_VIOLATIONS: [1-9]" \
  gate positioning "$P/bad.yaml" "$ALTS" "$ICP"
assert_rc   "positioning: bad canvas still exits 0 (violations are valid data)" 0 \
  gate positioning "$P/bad.yaml" "$ALTS" "$ICP"
assert_match "positioning: bad names the phantom primary_alternative (Zoho not in ledger)" \
  "primary_alternative.*phantom competitor" \
  bash -c 'bash "$1" positioning "$2" "$3" "$4" 2>&1 >/dev/null' _ "$SCORE" "$P/bad.yaml" "$ALTS" "$ICP"
assert_match "positioning: bad names the banned adjectives in the differentiator" \
  "banned adjective.*simple, affordable" \
  bash -c 'bash "$1" positioning "$2" "$3" "$4" 2>&1 >/dev/null' _ "$SCORE" "$P/bad.yaml" "$ALTS" "$ICP"
assert_match "positioning: bad names the 90-word statement (> 75 words)" \
  "statement.length.*> 75 words" \
  bash -c 'bash "$1" positioning "$2" "$3" "$4" 2>&1 >/dev/null' _ "$SCORE" "$P/bad.yaml" "$ALTS" "$ICP"
assert_match "positioning: bad names create_new_game without an education budget" \
  "education_budget_php" \
  bash -c 'bash "$1" positioning "$2" "$3" "$4" 2>&1 >/dev/null' _ "$SCORE" "$P/bad.yaml" "$ALTS" "$ICP"
assert_eq   "positioning: word policy is env-overridable (GUILD_POS_MAX_WORDS)" "0" \
  bash -c 'GUILD_POS_MAX_WORDS=200 GUILD_POS_MAX_SLOT_WORDS=60 bash "$1" positioning "$2" "$3" "$4" 2>&1 >/dev/null | grep -c "rule statement.length"' \
  _ "$SCORE" "$P/bad.yaml" "$ALTS" "$ICP"
assert_rc   "positioning: missing positioning.yaml exits 2" 2 gate positioning "$P/nope.yaml" "$ALTS" "$ICP"
assert_rc   "positioning: missing alternatives.csv exits 2" 2 gate positioning "$P/good.yaml" "$P/nope.csv" "$ICP"

# ---- offers --------------------------------------------------------------------------------
assert_eq   "offers: good ladder is clean (one paid discovery, monotone G-B-B with fences, capped guarantees)" \
  "OFFER_VIOLATIONS: 0" gate offers "$O/good.yaml"
assert_rc   "offers: good ladder exits 0" 0 gate offers "$O/good.yaml"
assert_line "offers: bad ladder counts violations" "^OFFER_VIOLATIONS: [1-9]" gate offers "$O/bad.yaml"
assert_match "offers: bad names the two discovery offers" "2 discovery offers; exactly one" \
  bash -c 'bash "$1" offers "$2" 2>&1 >/dev/null' _ "$SCORE" "$O/bad.yaml"
assert_match "offers: bad names Good priced above Better" "good ₱450000 ≥ better ₱420000" \
  bash -c 'bash "$1" offers "$2" 2>&1 >/dev/null' _ "$SCORE" "$O/bad.yaml"
assert_match "offers: bad names the uncapped guarantee" "guarantee.cap_pct: missing" \
  bash -c 'bash "$1" offers "$2" 2>&1 >/dev/null' _ "$SCORE" "$O/bad.yaml"
assert_match "offers: bad names the missing tax note" "tax_note" \
  bash -c 'bash "$1" offers "$2" 2>&1 >/dev/null' _ "$SCORE" "$O/bad.yaml"
assert_match "offers: bad names the first-engagement prepay/terms breach" "prepay_pct.*first engagement" \
  bash -c 'bash "$1" offers "$2" 2>&1 >/dev/null' _ "$SCORE" "$O/bad.yaml"
assert_match "offers: bad names hardware support shorter than warranty" "support_months.*warranty" \
  bash -c 'bash "$1" offers "$2" 2>&1 >/dev/null' _ "$SCORE" "$O/bad.yaml"
assert_eq   "offers: a ladder with no discovery offer is a violation" "OFFER_VIOLATIONS: 1" \
  gate offers "$O/no-discovery.yaml"
assert_match "offers: no-discovery names the missing paid discovery" "no paid-discovery offer" \
  bash -c 'bash "$1" offers "$2" 2>&1 >/dev/null' _ "$SCORE" "$O/no-discovery.yaml"
assert_eq   "offers: pilot cap is env-overridable (GUILD_OFFER_PILOT_MAX_DAYS)" "0" \
  bash -c 'GUILD_OFFER_PILOT_MAX_DAYS=90 bash "$1" offers "$2" 2>&1 >/dev/null | grep -c "rule X-PILOT.duration_days"' \
  _ "$SCORE" "$O/bad.yaml"
assert_rc   "offers: missing offers.yaml exits 2" 2 gate offers "$O/nope.yaml"

finish
