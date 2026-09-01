#!/usr/bin/env bash
# ops.test.sh — fixture tests for the operations + finance gates: sow, delivery, regulatory, ar.
#   usage: tests/ops.test.sh [sow|delivery|regulatory|ar]
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh" "$@"
S="$FIX/sow"; DLV="$FIX/delivery"; R="$FIX/regulatory"; A="$FIX/ar"

# ---- sow -----------------------------------------------------------------------------------
assert_line "sow: complete SOW (18 fields, milestone-tied payments) lints clean" \
  "^SOW_MISSING: 0$" gate sow "$S/good.md"
assert_rc   "sow: good SOW exits 0" 0 gate sow "$S/good.md"
assert_line "sow: bad SOW counts all 7 breaches" "^SOW_MISSING: 7$" gate sow "$S/bad.md"
assert_rc   "sow: bad SOW still exits 0 (violations are valid data)" 0 gate sow "$S/bad.md"
assert_match "sow: bad names the payments tied to calendar dates" "payment tied to a calendar date" \
  bash -c 'bash "$1" sow "$2" 2>&1 >/dev/null' _ "$SCORE" "$S/bad.md"
assert_match "sow: bad names the missing review window + deemed acceptance" "review_window_days" \
  bash -c 'bash "$1" sow "$2" 2>&1 >/dev/null' _ "$SCORE" "$S/bad.md"
assert_match "sow: bad names the 14-day warranty below the 30-day floor" "warranty_days 14 < 30" \
  bash -c 'bash "$1" sow "$2" 2>&1 >/dev/null' _ "$SCORE" "$S/bad.md"
assert_match "sow: bad names the forbidden No Return, No Exchange wording" "No Return, No Exchange" \
  bash -c 'bash "$1" sow "$2" 2>&1 >/dev/null' _ "$SCORE" "$S/bad.md"
assert_rc   "sow: missing file exits 2" 2 gate sow "$S/does-not-exist.md"
assert_line "sow: GUILD_SOW_DEPOSIT_MIN is honoured (40 flags the 30 % deposit)" "^SOW_MISSING: 1$" \
  bash -c 'GUILD_SOW_DEPOSIT_MIN=40 bash "$1" sow "$2"' _ "$SCORE" "$S/good.md"

# ---- delivery ------------------------------------------------------------------------------
assert_line "delivery: clean ledgers (deposits before kickoff, invoices on acceptance) pass" \
  "^DELIVERY_VIOLATIONS: 0$" gate delivery "$DLV/good"
assert_rc   "delivery: good ledgers exit 0" 0 gate delivery "$DLV/good"
assert_line "delivery: bad ledgers count the 3 planted defects" "^DELIVERY_VIOLATIONS: 3$" gate delivery "$DLV/bad"
assert_match "delivery: bad names the kickoff before the deposit was paid" "kickoff 2026-06-01 before the deposit was paid" \
  bash -c 'bash "$1" delivery "$2" 2>&1 >/dev/null' _ "$SCORE" "$DLV/bad"
assert_match "delivery: bad names the 12 h logged on an unapproved change order" "12 h logged before approval" \
  bash -c 'bash "$1" delivery "$2" 2>&1 >/dev/null' _ "$SCORE" "$DLV/bad"
assert_match "delivery: bad names the invoice dated before acceptance" "invoice_date 2026-07-10 before accepted_date 2026-07-15" \
  bash -c 'bash "$1" delivery "$2" 2>&1 >/dev/null' _ "$SCORE" "$DLV/bad"
assert_rc   "delivery: missing directory exits 2" 2 gate delivery "$DLV/does-not-exist"
assert_rc   "delivery: directory without the four ledgers exits 2" 2 gate delivery "$S"
assert_line "delivery: rebaseline is a flag, not a violation (GUILD_CO_REBASELINE_PCT=5)" "^DELIVERY_VIOLATIONS: 0$" \
  bash -c 'GUILD_CO_REBASELINE_PCT=5 bash "$1" delivery "$2"' _ "$SCORE" "$DLV/good"
assert_match "delivery: rebaseline flag lands on stderr" "rebaseline the plan" \
  bash -c 'GUILD_CO_REBASELINE_PCT=5 bash "$1" delivery "$2" 2>&1 >/dev/null' _ "$SCORE" "$DLV/good"

# ---- regulatory ----------------------------------------------------------------------------
assert_line "regulatory: certified products with statutory warranty text ship" \
  "^SHIP_BLOCKERS: 0$" gate regulatory "$R/good.csv"
assert_rc   "regulatory: good register exits 0" 0 gate regulatory "$R/good.csv"
assert_line "regulatory: bad register counts the 4 blockers" "^SHIP_BLOCKERS: 4$" gate regulatory "$R/bad.csv"
assert_match "regulatory: bad names the WiFi product with ntc_status pending" "ntc_status=pending" \
  bash -c 'bash "$1" regulatory "$2" 2>&1 >/dev/null' _ "$SCORE" "$R/bad.csv"
assert_match "regulatory: bad names the marketed model that differs from the certificate model" "NTC certificate model" \
  bash -c 'bash "$1" regulatory "$2" 2>&1 >/dev/null' _ "$SCORE" "$R/bad.csv"
assert_match "regulatory: bad names the consumer warranty text below 60 days" "warranty text 30 days < 60" \
  bash -c 'bash "$1" regulatory "$2" 2>&1 >/dev/null' _ "$SCORE" "$R/bad.csv"
assert_match "regulatory: bad names the No Return, No Exchange template" "No Return, No Exchange" \
  bash -c 'bash "$1" regulatory "$2" 2>&1 >/dev/null' _ "$SCORE" "$R/bad.csv"
assert_rc   "regulatory: missing file exits 2" 2 gate regulatory "$R/does-not-exist.csv"

# ---- ar ------------------------------------------------------------------------------------
assert_line "ar: clean ledger (2307s in, credit terms printed, aging healthy) passes" \
  "^AR_VIOLATIONS: 0$" gate ar "$A/good.csv"
assert_rc   "ar: good ledger exits 0" 0 gate ar "$A/good.csv"
assert_line "ar: bad ledger counts the 6 violations" "^AR_VIOLATIONS: 6$" gate ar "$A/bad.csv"
assert_match "ar: bad names the paid row with EWT and no 2307 after the 20th" "Form 2307 not received" \
  bash -c 'bash "$1" ar "$2" 2>&1 >/dev/null' _ "$SCORE" "$A/bad.csv"
assert_match "ar: bad names the short payment labelled paid" "short payment labelled paid" \
  bash -c 'bash "$1" ar "$2" 2>&1 >/dev/null' _ "$SCORE" "$A/bad.csv"
assert_match "ar: bad names the VAT invoice without a credit term (RMC 65-2024)" "VAT invoice without a credit term" \
  bash -c 'bash "$1" ar "$2" 2>&1 >/dev/null' _ "$SCORE" "$A/bad.csv"
assert_match "ar: bad names the 90+ day invoice with no demand letter" "without demand_letter_date" \
  bash -c 'bash "$1" ar "$2" 2>&1 >/dev/null' _ "$SCORE" "$A/bad.csv"
assert_match "ar: bad reports DSO above the 60-day line" "DSO 138.0 days > 60" \
  bash -c 'bash "$1" ar "$2" 2>&1 >/dev/null' _ "$SCORE" "$A/bad.csv"
assert_rc   "ar: missing file exits 2" 2 gate ar "$A/does-not-exist.csv"

finish
