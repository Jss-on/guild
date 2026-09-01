#!/usr/bin/env bash
# pricing.test.sh — fixture tests for the pricing gate.
#   usage: tests/pricing.test.sh [pricing]
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh" "$@"
PR="$FIX/pricing"

assert_eq   "pricing: good price book + tax status is clean" "PRICE_VIOLATIONS: 0" \
  gate pricing "$PR/good-price-book.csv" "$PR/tax-status.csv"
assert_rc   "pricing: good book exits 0" 0 gate pricing "$PR/good-price-book.csv" "$PR/tax-status.csv"
assert_eq   "pricing: good book stays clean with competitor band, WTP ledger and discount log" \
  "PRICE_VIOLATIONS: 0" \
  gate pricing "$PR/good-price-book.csv" "$PR/tax-status.csv" "$PR/competitor-band.csv" "$PR/wtp-interviews.csv" "$PR/discount-log.csv"
assert_line "pricing: bad book counts violations" "^PRICE_VIOLATIONS: [1-9]" \
  gate pricing "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_rc   "pricing: bad book still exits 0 (violations are valid data)" 0 \
  gate pricing "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_match "pricing: bad names the list below floor ÷ (1 − GM)" "below the cost floor" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_match "pricing: bad names the 120-day-old floor" "floor_date 2026-05-05 is 120 d old" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_match "pricing: bad names the new offer with 4 WTP rows" "wtp_n 4 < 10" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_match "pricing: bad names the exempt_nonvat row under a VAT-registered seller" \
  "exempt_nonvat row while the seller is VAT-registered" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_match "pricing: bad names the B2B row displayed VAT-inclusive" "displayed VAT-inclusive" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_match "pricing: bad names the CWT 5 on a corporate payee" "cwt_rate_expected 5 not in \{10,15\}" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_match "pricing: bad names the zero-rated row without a foreign-currency client" "zero_rated_108B2 without foreign_currency_client" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_match "pricing: bad names the 85 % utilisation floor" "0.85 utilisation > 0.75" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_match "pricing: bad names the retail hardware at 2.7× COGS" "below the 3× floor" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_match "pricing: bad names the under-powered Van Westendorp and the list outside PMC–PME" \
  "van_westendorp.*n 40 < 150" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_match "pricing: bad names the +20 % increase with 7 d notice and no reason" "increase.notice" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_line "pricing: eight_pct_elected while VAT-registered is a violation (tax-status-bad)" \
  "^PRICE_VIOLATIONS: [1-9]" gate pricing "$PR/good-price-book.csv" "$PR/tax-status-bad.csv"
assert_match "pricing: tax-status-bad names the 8 %-while-VAT election" \
  "eight_pct_elected while VAT-registered" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/good-price-book.csv" "$PR/tax-status-bad.csv"
assert_match "pricing: trailing sales above ₱3M while non-VAT is a violation (tax-status-over3m)" \
  "exceed the ₱3000000 VAT threshold" \
  bash -c 'bash "$1" pricing "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$PR/good-price-book.csv" "$PR/tax-status-over3m.csv"
assert_line "pricing: stale, short, unhashed competitor captures are violations" "^PRICE_VIOLATIONS: [1-9]" \
  gate pricing "$PR/good-price-book.csv" "$PR/tax-status.csv" "$PR/competitor-band-bad.csv"
assert_match "pricing: competitor-band-bad names the non-hex hash" "not 16–64 hex" \
  bash -c 'bash "$1" pricing "$2" "$3" "$4" 2>&1 >/dev/null' _ "$SCORE" "$PR/good-price-book.csv" "$PR/tax-status.csv" "$PR/competitor-band-bad.csv"
assert_line "pricing: pocket prices beyond max discount / below floor are violations" "^PRICE_VIOLATIONS: [1-9]" \
  gate pricing "$PR/good-price-book.csv" "$PR/tax-status.csv" "$PR/competitor-band.csv" "$PR/wtp-interviews.csv" "$PR/discount-log-bad.csv"
assert_match "pricing: discount-log-bad names the pocket below the cost floor" "pocket 140000 is below the cost floor" \
  bash -c 'bash "$1" pricing "$2" "$3" "$4" "$5" "$6" 2>&1 >/dev/null' _ "$SCORE" "$PR/good-price-book.csv" "$PR/tax-status.csv" "$PR/competitor-band.csv" "$PR/wtp-interviews.csv" "$PR/discount-log-bad.csv"
assert_eq   "pricing: floor staleness is env-overridable (GUILD_PRICE_FLOOR_MAX_DAYS)" "0" \
  bash -c 'GUILD_PRICE_FLOOR_MAX_DAYS=365 bash "$1" pricing "$2" "$3" 2>&1 >/dev/null | grep -c "rule floor_date"' \
  _ "$SCORE" "$PR/bad-price-book.csv" "$PR/tax-status.csv"
assert_rc   "pricing: missing price book exits 2" 2 gate pricing "$PR/nope.csv" "$PR/tax-status.csv"
assert_rc   "pricing: missing tax status exits 2" 2 gate pricing "$PR/good-price-book.csv" "$PR/nope.csv"

finish
