#!/usr/bin/env bash
# market.test.sh — fixture tests for the market gates: market, competitors.
#   usage: tests/market.test.sh [market|competitors]
# Fixtures carry "# as_of: 2026-09-02" so staleness and snapshot-age checks never decay.
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh" "$@"
M="$FIX/market"; K="$FIX/competitors"; E="$FIX/evidence"
errs() { bash "$SCORE" "$@" 2>&1 >/dev/null; }   # stderr only — the detail channel

# ---- market ----------------------------------------------------------------------------------
assert_eq   "market: good ledger (NCR small/medium manufacturers, 6 claims × 2 methods, 30 sourced factors) is clean" \
  "MARKET_VIOLATIONS: 0" gate market "$M/good-factors.csv" "$M/claims.csv" "$E/sources.tsv"
assert_rc   "market: good ledger exits 0" 0 gate market "$M/good-factors.csv" "$M/claims.csv" "$E/sources.tsv"
assert_match "market: good ledger only WARNs (stderr) about the 26-month-old vendor-blog filter" \
  "WARN factors.csv line [0-9]+ \(MC-4 filter\): \(g\) reference period 2024-06 is 26 months old" \
  errs market "$M/good-factors.csv" "$M/claims.csv" "$E/sources.tsv"
assert_line "market: bad ledger (5 planted defects against the same claims.csv) counts violations" \
  "^MARKET_VIOLATIONS: [1-9][0-9]*$" gate market "$M/bad-factors.csv" "$M/claims.csv" "$E/sources.tsv"
assert_rc   "market: bad ledger still exits 0 (violations are valid data)" 0 gate market "$M/bad-factors.csv" "$M/claims.csv" "$E/sources.tsv"
assert_match "market: bad names (a) factor product ≠ stated claim on MC-1" \
  "claim MC-1: \(a\) factor product 684264251 differs from stated_value 410000000 by 66\.9 %" \
  errs market "$M/bad-factors.csv" "$M/claims.csv" "$E/sources.tsv"
assert_match "market: bad names (d) SOM > SAM on the bottom-up chain" \
  "segment SEG-1 / bottom_up: \(d\) SOM 2542788000 > SAM 254546301 \(factor product\)" \
  errs market "$M/bad-factors.csv" "$M/claims.csv" "$E/sources.tsv"
assert_match "market: bad names (c) the P3 bottom-up unit count (MC-3 from S-4)" \
  "\(MC-3 unit_count\): \(c\) bottom_up unit_count graded P3 \(source S-4\)" \
  errs market "$M/bad-factors.csv" "$M/claims.csv" "$E/sources.tsv"
assert_match "market: bad names (b) the live URL with no archive (MC-2)" \
  "\(MC-2 unit_count\): \(b\) archived_url is a live URL with no archive" \
  errs market "$M/bad-factors.csv" "$M/claims.csv" "$E/sources.tsv"
assert_match "market: bad names (g) the 92-month-old reference period (MC-4)" \
  "\(MC-4 filter\): \(g\) reference period 2018 is 92 months old \(> 60 months\)" \
  errs market "$M/bad-factors.csv" "$M/claims.csv" "$E/sources.tsv"
assert_eq   "market: triangulation fixture — 3.98× method gap, single-method SOM, adoption share without a bottom-up anchor = 3" \
  "MARKET_VIOLATIONS: 3" gate market "$M/triangulation-factors.csv" "$M/triangulation-claims.csv" "$E/sources.tsv"
assert_match "market: triangulation names (f) the 3.98× disagreement between bottom_up and top_down TAM" \
  "segment SEG-1 / TAM: \(f\) methods disagree 3\.98x" \
  errs market "$M/triangulation-factors.csv" "$M/triangulation-claims.csv" "$E/sources.tsv"
assert_match "market: triangulation names (e) the 1 % pattern on TC-3 and (f) its single method" \
  "claim TC-3: \(e\) SOM applies an adoption_share with no bottom_up claim in segment SEG-2.*segment SEG-2 / SOM: \(f\) only one method" \
  errs market "$M/triangulation-factors.csv" "$M/triangulation-claims.csv" "$E/sources.tsv"
assert_eq   "market: GUILD_TRIANGULATION_MAX=5 accepts the 3.98× gap (policy threshold is env-overridable)" \
  "MARKET_VIOLATIONS: 2" env GUILD_TRIANGULATION_MAX=5 bash "$SCORE" market "$M/triangulation-factors.csv" "$M/triangulation-claims.csv" "$E/sources.tsv"
assert_rc   "market: missing factors file exits 2" 2 gate market "$M/does-not-exist.csv" "$M/claims.csv" "$E/sources.tsv"
assert_rc   "market: missing sources ledger exits 2" 2 gate market "$M/good-factors.csv" "$M/claims.csv" "$E/nope.tsv"

# ---- competitors -----------------------------------------------------------------------------
assert_eq   "competitors: good register (status quo + DIY + do-nothing + 4 vendors, fresh hashed snapshots) is clean" \
  "COMPETITOR_VIOLATIONS: 0" gate competitors "$K/good-alternatives.csv" "$K/good-snapshots.csv"
assert_rc   "competitors: good register exits 0" 0 gate competitors "$K/good-alternatives.csv" "$K/good-snapshots.csv"
assert_line "competitors: bad register (no status-quo row, phantom rows, unknown type) counts violations" \
  "^COMPETITOR_VIOLATIONS: [1-9][0-9]*$" gate competitors "$K/bad-alternatives.csv" "$K/good-snapshots.csv"
assert_match "competitors: bad register names the missing status-quo row" \
  "alternatives.csv: no status_quo\|diy\|do_nothing row" \
  errs competitors "$K/bad-alternatives.csv" "$K/good-snapshots.csv"
assert_match "competitors: bad register names the phantom competitor ALT-5 (zero interview ids) and ALT-4 (one)" \
  "\(ALT-4\): phantom competitor — 1 distinct evidence_interview_ids.*\(ALT-5\): phantom competitor — 0 distinct evidence_interview_ids" \
  errs competitors "$K/bad-alternatives.csv" "$K/good-snapshots.csv"
assert_match "competitors: bad register names the unknown type" \
  "\(ALT-8\): unknown type \"vendor\"" \
  errs competitors "$K/bad-alternatives.csv" "$K/good-snapshots.csv"
assert_eq   "competitors: bad snapshots (120-day capture without hash, live URL, bad price_metric) = 6 violations" \
  "COMPETITOR_VIOLATIONS: 6" gate competitors "$K/good-alternatives.csv" "$K/bad-snapshots.csv"
assert_match "competitors: bad snapshots WARN the 120-day capture and fail ALT-2 for having no current price" \
  "WARN snapshots.csv line [0-9]+ \(SNAP-7 -> ALT-2\): captured 120 days ago \(> 90\).*alternative ALT-2 \(Zoho Inventory\): no valid price snapshot <= 90 days old" \
  errs competitors "$K/good-alternatives.csv" "$K/bad-snapshots.csv"
assert_match "competitors: bad snapshots name the missing screenshot_hash and the live URL" \
  "\(SNAP-2 -> ALT-2\): screenshot_hash \"-\" is not 16-64 hex.*\(SNAP-3 -> ALT-3\): archived_url is a live URL with no archive" \
  errs competitors "$K/good-alternatives.csv" "$K/bad-snapshots.csv"
assert_eq   "competitors: GUILD_SNAPSHOT_MAX_DAYS=180 makes the hashed 120-day capture current again (5 left)" \
  "COMPETITOR_VIOLATIONS: 5" env GUILD_SNAPSHOT_MAX_DAYS=180 bash "$SCORE" competitors "$K/good-alternatives.csv" "$K/bad-snapshots.csv"
assert_rc   "competitors: missing snapshots file exits 2" 2 gate competitors "$K/good-alternatives.csv" "$K/none.csv"

finish
