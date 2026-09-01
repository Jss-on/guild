#!/usr/bin/env bash
# economics.test.sh — fixture tests for the economics-domain gates: economics, cash, alive, studio.
#   usage: tests/economics.test.sh [economics|cash|alive|studio]
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh" "$@"
EC="$FIX/economics"; CA="$FIX/cash"; ST="$FIX/studio"

# ---- economics -----------------------------------------------------------------------------
assert_eq   "economics: good model passes every assertion at every corner" \
  "ECON_PASS: 33/33" gate economics "$EC/good-model.csv" "$EC/assertions.tsv"
assert_rc   "economics: good model exits 0" 0 gate economics "$EC/good-model.csv" "$EC/assertions.tsv"
assert_eq   "economics: bad model breaches at the worst corner (x < y)" \
  "ECON_PASS: 29/33" gate economics "$EC/bad-model.csv" "$EC/assertions.tsv"
assert_match "economics: bad model names the worst-corner GM breach" "FAIL UE-01w gm_pct" \
  bash -c 'bash "$1" economics "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$EC/bad-model.csv" "$EC/assertions.tsv"
assert_match "economics: bad model names LTV/CAC < 1 at worst" "FAIL UE-02w ltv_cac" \
  bash -c 'bash "$1" economics "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$EC/bad-model.csv" "$EC/assertions.tsv"
assert_match "economics: bad model names the benchmark driver without source_id" "benchmark row without source_id" \
  bash -c 'bash "$1" economics "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$EC/bad-model.csv" "$EC/assertions.tsv"
assert_match "economics: bad model rejects a derived metric typed as a driver (FAST)" "typed as a driver" \
  bash -c 'bash "$1" economics "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$EC/bad-model.csv" "$EC/assertions.tsv"
assert_rc   "economics: missing model file exits 2" 2 gate economics "$EC/does-not-exist.csv" "$EC/assertions.tsv"

# ---- cash ----------------------------------------------------------------------------------
assert_eq   "cash: good 13-week forecast closes (variance row uncounted without actuals)" \
  "CASH_PASS: 8/8" gate cash "$CA/good-cash13.csv"
assert_eq   "cash: good forecast with weekly actuals adds the variance row" \
  "CASH_PASS: 9/9" gate cash "$CA/good-cash13.csv" "$CA/good-variance.csv"
assert_eq   "cash: bad forecast breaches floor + freshness (x < y)" \
  "CASH_PASS: 6/8" gate cash "$CA/bad-cash13.csv"
assert_eq   "cash: bad forecast with 30 % receipts variance fails that row too" \
  "CASH_PASS: 6/9" gate cash "$CA/bad-cash13.csv" "$CA/bad-variance.csv"
assert_match "cash: bad forecast names the week whose closing dives under the floor" "floor breach: week" \
  bash -c 'bash "$1" cash "$2" 2>&1 >/dev/null' _ "$SCORE" "$CA/bad-cash13.csv"
assert_match "cash: bad forecast names the 20-day staleness" "forecast age 20 days" \
  bash -c 'bash "$1" cash "$2" 2>&1 >/dev/null' _ "$SCORE" "$CA/bad-cash13.csv"
assert_match "cash: bad variance file yields the 30 % receipts miss" "receipts variance last 4 actual weeks = 30" \
  bash -c 'bash "$1" cash "$2" "$3" 2>&1 >/dev/null' _ "$SCORE" "$CA/bad-cash13.csv" "$CA/bad-variance.csv"
assert_rc   "cash: missing forecast exits 2" 2 gate cash "$CA/none.csv"

# ---- alive ---------------------------------------------------------------------------------
assert_line "alive: growing revenue reaches break-even before zero" \
  "^DEFAULT_ALIVE: 1 months_to_breakeven=2" gate alive "$CA/alive-ledger.csv"
assert_line "alive: flat revenue burns out inside the horizon" \
  "^DEFAULT_ALIVE: 0 " gate alive "$CA/dead-ledger.csv"
assert_match "alive: dead ledger reports months_to_zero on the contract line" "months_to_zero=6" \
  gate alive "$CA/dead-ledger.csv"
assert_match "alive: months_to_zero <= 6 raises the fatal-pinch ADR" "FATAL_PINCH: months_to_zero=6" \
  bash -c 'bash "$1" alive "$2" 2>&1 >/dev/null' _ "$SCORE" "$CA/dead-ledger.csv"
assert_rc   "alive: fewer than 6 monthly rows is too early to ask (exit 2)" 2 gate alive "$CA/short-ledger.csv"
assert_rc   "alive: missing ledger exits 2" 2 gate alive "$CA/none.csv"

# ---- studio --------------------------------------------------------------------------------
assert_eq   "studio: good ledger clears every SPI/JPMC floor" \
  "STUDIO_PASS: 14/14" gate studio "$ST/good-ledger.csv"
assert_eq   "studio: bad ledger breaches utilisation, concentration, DSO, deposit (x < y)" \
  "STUDIO_PASS: 9/14" gate studio "$ST/bad-ledger.csv"
assert_match "studio: bad ledger names the 55 % utilisation" "FAIL S-01 utilisation 55.0" \
  bash -c 'bash "$1" studio "$2" 2>&1 >/dev/null' _ "$SCORE" "$ST/bad-ledger.csv"
assert_match "studio: bad ledger names the 40 % client" "top client C-ALPHA = 40.3" \
  bash -c 'bash "$1" studio "$2" 2>&1 >/dev/null' _ "$SCORE" "$ST/bad-ledger.csv"
assert_match "studio: bad ledger names the 75-day DSO" "FAIL S-10 DSO 68.8" \
  bash -c 'bash "$1" studio "$2" 2>&1 >/dev/null' _ "$SCORE" "$ST/bad-ledger.csv"
assert_match "studio: bad ledger names the 10 % deposit before countersign" "deposit: project P-03 10.0" \
  bash -c 'bash "$1" studio "$2" 2>&1 >/dev/null' _ "$SCORE" "$ST/bad-ledger.csv"
assert_rc   "studio: missing ledger exits 2" 2 gate studio "$ST/none.csv"

finish
