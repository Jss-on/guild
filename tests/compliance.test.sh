#!/usr/bin/env bash
# compliance.test.sh — fixture tests for the compliance gate (register × profile, deadline engine,
# applies_if, consistency rules, sign-off + S-grade + re-verify rules).
#   usage: tests/compliance.test.sh [compliance]
# Fixtures: tests/fixtures/compliance/ — good-register.csv (31 applicable rows, all in good
# standing) vs overdue-register.csv (planted: 2550Q past deadline without evidence; 2551Q active
# while VAT-registered; sign-off row done without signoff_path; S-grade row done without notes;
# stale verified_on). Both carry "# as_of: 2026-09-02" so scoring never decays with the calendar.
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh" "$@"
CF="$FIX/compliance"
stderr_of() { bash "$SCORE" compliance "$1" "$2" 2>&1 >/dev/null; }

# ---- good register -------------------------------------------------------------------------
assert_line "compliance: good register - every applicable row in good standing (x/x)" \
  "^COMPLIANCE: 31/31$" gate compliance "$CF/good-register.csv" "$CF/profile.yaml"
assert_rc   "compliance: good register exits 0" 0 \
  gate compliance "$CF/good-register.csv" "$CF/profile.yaml"
assert_match "compliance: good register still warns on upcoming T-30 deadlines (0619-E)" \
  "WARN BIR-0619E: next deadline 2026-09-10 \(T-8" stderr_of "$CF/good-register.csv" "$CF/profile.yaml"

# ---- overdue register: planted defects ------------------------------------------------------
assert_line "compliance: overdue register scores x < y (28/32)" \
  "^COMPLIANCE: 28/32$" gate compliance "$CF/overdue-register.csv" "$CF/profile.yaml"
assert_rc   "compliance: overdue register is valid data - exits 0" 0 \
  gate compliance "$CF/overdue-register.csv" "$CF/profile.yaml"
assert_match "compliance: stderr names the 2550Q past deadline without evidence" \
  "OVERDUE BIR-2550Q: due 2026-07-25 \(39 days late, no evidence\)" \
  stderr_of "$CF/overdue-register.csv" "$CF/profile.yaml"
assert_match "compliance: stderr names the 2551Q row active while vat_registered (C1)" \
  "FAIL BIR-2551Q: \[C1\] 2551Q .* vat_registered=true" \
  stderr_of "$CF/overdue-register.csv" "$CF/profile.yaml"
assert_match "compliance: stderr names the sign-off row done without signoff_path" \
  "FAIL TAX-POSTURE: requires_professional_signoff=true but signoff_path is missing" \
  stderr_of "$CF/overdue-register.csv" "$CF/profile.yaml"
assert_match "compliance: stderr flags the S-grade row done without notes" \
  "FAIL EMP-DOLE-OSH: source_grade=S" \
  stderr_of "$CF/overdue-register.csv" "$CF/profile.yaml"
assert_match "compliance: stderr flags verified_on older than 12 months (re-verify)" \
  "RE-VERIFY EMP-CONTRACTOR: verified_on 2025-06-01" \
  stderr_of "$CF/overdue-register.csv" "$CF/profile.yaml"

# ---- applies_if vs profile ------------------------------------------------------------------
assert_match "compliance: applies_if excludes the sole-prop DTI row under the corp/OPC profile" \
  "na DTI-BN: does not apply under profile" \
  stderr_of "$CF/good-register.csv" "$CF/profile.yaml"
assert_match "compliance: applies_if excludes SEC incorporation under the sole-prop profile" \
  "na SEC-INC: does not apply under profile" \
  stderr_of "$CF/good-register.csv" "$CF/profile-soleprop.yaml"
assert_match "compliance: a row marked na that applies under the profile is a failure" \
  "FAIL DTI-BN: marked status=na but the row applies" \
  stderr_of "$CF/good-register.csv" "$CF/profile-soleprop.yaml"

# ---- deadline engine (quarter_end+25d) + GUILD_TODAY override -------------------------------
assert_match "compliance: deadline engine quarter_end+25d warns in the T-7 window (GUILD_TODAY)" \
  "WARN BIR-2550Q: next deadline 2026-04-25 \(T-5, inside the T-7 window\)" \
  bash -c 'GUILD_TODAY=2026-04-20 bash "$1" compliance "$2" "$3" 2>&1 >/dev/null' _ \
  "$SCORE" "$CF/overdue-register.csv" "$CF/profile.yaml"
assert_line "compliance: GUILD_TODAY=2026-12-31 turns the good register red (Q3 unfiled)" \
  "^COMPLIANCE: 22/31$" \
  env GUILD_TODAY=2026-12-31 bash "$SCORE" compliance "$CF/good-register.csv" "$CF/profile.yaml"
assert_match "compliance: GUILD_TODAY=2026-12-31 reports the stale 2550Q evidence period" \
  "OVERDUE BIR-2550Q: due 2026-10-25 .* covers the period due 2026-07-25" \
  bash -c 'GUILD_TODAY=2026-12-31 bash "$1" compliance "$2" "$3" 2>&1 >/dev/null' _ \
  "$SCORE" "$CF/good-register.csv" "$CF/profile.yaml"

# ---- hard errors ----------------------------------------------------------------------------
assert_rc "compliance: missing register exits 2" 2 \
  gate compliance "$CF/does-not-exist.csv" "$CF/profile.yaml"
assert_rc "compliance: missing profile exits 2" 2 \
  gate compliance "$CF/good-register.csv" "$CF/does-not-exist.yaml"
assert_rc "compliance: register missing schema columns is a hard error (exit 2)" 2 \
  bash -c 't="$(mktemp)"; printf "id,obligation\nX-1,foo\n" > "$t"; bash "$1" compliance "$t" "$2" >/dev/null 2>&1; rc=$?; rm -f "$t"; exit $rc' _ \
  "$SCORE" "$CF/profile.yaml"

finish
