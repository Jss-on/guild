#!/usr/bin/env bash
# discovery.test.sh — fixture tests for the discovery gates: interviews, icp, vrs.
#   usage: tests/discovery.test.sh [interviews|icp|vrs]
# Every planted defect in the bad fixtures is asserted by name on stderr — a gate that cannot say
# which row broke which rule is not a gate.
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh" "$@"
I="$FIX/interviews"; P="$FIX/icp"; V="$FIX/vrs"
stderr_of() { bash -c 'bash "$@" 2>&1 >/dev/null' _ "$SCORE" "$@"; }   # the gate's stderr on stdout

# ---- interviews ------------------------------------------------------------------------------
assert_eq   "interviews: good ledger (14 smb-mfg + 4 logistics-3pl, every row consented) has 0 violations" \
  "INTERVIEW_VIOLATIONS: 0" gate interviews "$I/good.tsv" "$I/consent.tsv"
assert_rc   "interviews: good ledger exits 0" 0 gate interviews "$I/good.tsv" "$I/consent.tsv"
assert_match "interviews: good ledger reports saturation reached for smb-mfg (last 3 added 0 codes)" \
  "saturation: segment smb-mfg: reached" stderr_of interviews "$I/good.tsv" "$I/consent.tsv"
assert_match "interviews: good ledger reports evidence-grade share for the active segment" \
  "segment smb-mfg: evidence-grade 12/14 \(85 %\)" stderr_of interviews "$I/good.tsv" "$I/consent.tsv"
assert_match "interviews: contrast segment is reported, not held to the quota" \
  "segment logistics-3pl: 4 interviews, evidence-grade 3 - not under active discovery" stderr_of interviews "$I/good.tsv" "$I/consent.tsv"
assert_line "interviews: bad ledger has violations" "^INTERVIEW_VIOLATIONS: [1-9]" gate interviews "$I/bad.tsv" "$I/consent.tsv"
assert_eq   "interviews: bad ledger carries exactly the 10 planted defects" \
  "INTERVIEW_VIOLATIONS: 10" gate interviews "$I/bad.tsv" "$I/consent.tsv"
assert_rc   "interviews: bad ledger still exits 0 (violations are valid data)" 0 gate interviews "$I/bad.tsv" "$I/consent.tsv"
assert_match "interviews: bad names the row with no consent join" \
  "\(I-3\): no consent row for consent_id \"P-99\"" stderr_of interviews "$I/bad.tsv" "$I/consent.tsv"
assert_match "interviews: bad names SPI collected without explicit consent (RA 10173 s.13)" \
  "\(I-4\): consent P-24: spi_collected=Y but spi_explicit_consent=N" stderr_of interviews "$I/bad.tsv" "$I/consent.tsv"
assert_match "interviews: bad names the pitch revealed in interview 2 of the segment" \
  "\(I-2\): solution_revealed=Y at position 2 of segment smb-mfg" stderr_of interviews "$I/bad.tsv" "$I/consent.tsv"
assert_match "interviews: bad names the row used past deletion_due" \
  "\(I-5\): consent P-25: used past deletion_due 2026-08-01" stderr_of interviews "$I/bad.tsv" "$I/consent.tsv"
assert_match "interviews: bad names the withdrawn participant" \
  "\(I-7\): consent P-27: participant withdrew on 2026-08-15" stderr_of interviews "$I/bad.tsv" "$I/consent.tsv"
assert_match "interviews: bad names the unrecorded row with no verbatim quote" \
  "\(I-6\): neither recorded=Y nor a verbatim_quote" stderr_of interviews "$I/bad.tsv" "$I/consent.tsv"
assert_match "interviews: bad names evidence_kind=do on a row without behaviour evidence" \
  "\(I-8\): evidence_kind=do but the row is not evidence-grade" stderr_of interviews "$I/bad.tsv" "$I/consent.tsv"
assert_match "interviews: bad names the illegal commitment_type" \
  "\(I-8\): bad commitment_type \"verbal\"" stderr_of interviews "$I/bad.tsv" "$I/consent.tsv"
assert_match "interviews: bad names the quota shortfall of the active segment" \
  "segment smb-mfg: 8 interviews < quota 12" stderr_of interviews "$I/bad.tsv" "$I/consent.tsv"
assert_match "interviews: bad names the evidence-grade shortfall (compliments are not evidence)" \
  "segment smb-mfg: evidence-grade share 3/8 = 37 % < 50 %" stderr_of interviews "$I/bad.tsv" "$I/consent.tsv"
assert_eq   "interviews: quota.tsv holds the contrast segment to 6 (4 < 6 = one violation)" \
  "INTERVIEW_VIOLATIONS: 1" gate interviews "$I/good.tsv" "$I/consent.tsv" "$I/quota.tsv"
assert_match "interviews: quota.tsv shortfall names the segment and the quota" \
  "segment logistics-3pl: 4 interviews < quota 6" stderr_of interviews "$I/good.tsv" "$I/consent.tsv" "$I/quota.tsv"
assert_eq   "interviews: GUILD_INTERVIEW_QUOTA=15 makes the 14-interview segment a shortfall" \
  "INTERVIEW_VIOLATIONS: 1" env GUILD_INTERVIEW_QUOTA=15 bash "$SCORE" interviews "$I/good.tsv" "$I/consent.tsv"
assert_eq   "interviews: header-only ledgers (a fresh venture template) yield 0" \
  "INTERVIEW_VIOLATIONS: 0" gate interviews "$I/empty.tsv" "$I/empty-consent.tsv"
assert_rc   "interviews: missing interview ledger exits 2" 2 gate interviews "$I/nope.tsv" "$I/consent.tsv"
assert_rc   "interviews: missing consent ledger exits 2" 2 gate interviews "$I/good.tsv" "$I/nope.tsv"
assert_rc   "interviews: missing quota file exits 2" 2 gate interviews "$I/good.tsv" "$I/consent.tsv" "$I/nope.tsv"

# ---- icp -------------------------------------------------------------------------------------
assert_eq   "icp: good ICP (every leaf >= 3 smb-mfg ids, four forces, five beachhead criteria, 5 disqualifiers) has 0 violations" \
  "ICP_VIOLATIONS: 0" gate icp "$P/good.yaml" "$I/good.tsv"
assert_rc   "icp: good ICP exits 0" 0 gate icp "$P/good.yaml" "$I/good.tsv"
assert_match "icp: good ICP reports the segment and the id floor" \
  "icp: segment=smb-mfg interviews=14 min_ids_per_leaf=3" stderr_of icp "$P/good.yaml" "$I/good.tsv"
assert_line "icp: bad ICP has violations" "^ICP_VIOLATIONS: [1-9]" gate icp "$P/bad.yaml" "$I/good.tsv"
assert_eq   "icp: bad ICP carries exactly the 4 planted defects" "ICP_VIOLATIONS: 4" gate icp "$P/bad.yaml" "$I/good.tsv"
assert_match "icp: bad names the leaf with only two interview ids" \
  "leaf firmographics.geography: 2 distinct interview id\(s\) < 3 required" stderr_of icp "$P/bad.yaml" "$I/good.tsv"
assert_match "icp: bad names the empty anxiety force" \
  "list triggers.anxiety: 0 item\(s\) < 1" stderr_of icp "$P/bad.yaml" "$I/good.tsv"
assert_match "icp: bad names the missing decision_maker_role" \
  "missing leaf roles.decision_maker_role" stderr_of icp "$P/bad.yaml" "$I/good.tsv"
assert_match "icp: bad names the phantom interview id" \
  "leaf pains\[0\]: interview id I-999 not in interviews.tsv" stderr_of icp "$P/bad.yaml" "$I/good.tsv"
assert_line "icp: GUILD_ICP_MIN_IDS=5 turns three-id leaves into violations" \
  "^ICP_VIOLATIONS: [1-9]" env GUILD_ICP_MIN_IDS=5 bash "$SCORE" icp "$P/good.yaml" "$I/good.tsv"
assert_match "icp: a PhilGEPS procurement mode without a certificate status is named" \
  "procurement_mode philgeps_lcrb requires buying_process.philgeps_certificate_status" \
  bash -c 't="$(mktemp)"; sed "s/value: private/value: philgeps_lcrb/" "$2" > "$t"; bash "$1" icp "$t" "$3" 2>&1 >/dev/null; rm -f "$t"' _ "$SCORE" "$P/good.yaml" "$I/good.tsv"
assert_rc   "icp: missing icp.yaml exits 2" 2 gate icp "$P/nope.yaml" "$I/good.tsv"
assert_rc   "icp: missing interview ledger exits 2" 2 gate icp "$P/good.yaml" "$I/nope.tsv"

# ---- vrs -------------------------------------------------------------------------------------
assert_eq   "vrs: good VRS has all 8 V-n rows measurable" "VRS_MEASURABLE: 8/8" gate vrs "$V/good.md"
assert_rc   "vrs: good VRS exits 0" 0 gate vrs "$V/good.md"
assert_match "vrs: good VRS reports the riskiest three as do-class" \
  "riskiest 3: V-1 \(rank 1\) method=paid_pilot do-class ok" stderr_of vrs "$V/good.md"
assert_eq   "vrs: bad VRS has 1 of 5 rows measurable" "VRS_MEASURABLE: 1/5" gate vrs "$V/bad.md"
assert_rc   "vrs: bad VRS still exits 0" 0 gate vrs "$V/bad.md"
assert_match "vrs: bad names the adjective threshold" \
  "V-2: threshold \"high\" has no number \(an adjective is not a threshold\)" stderr_of vrs "$V/bad.md"
assert_match "vrs: bad names the riskiest assumption tested by desk research only" \
  "V-1: risk_rank 1 is among the riskiest 3 but method=desk is say-class" stderr_of vrs "$V/bad.md"
assert_match "vrs: bad names the statement that is not a We-believe hypothesis" \
  "V-4: statement does not start with \"We believe\"" stderr_of vrs "$V/bad.md"
assert_match "vrs: bad names the missing owner" "V-5: missing owner" stderr_of vrs "$V/bad.md"
assert_match "vrs: bad names the missing decide_by" "V-5: missing decide_by" stderr_of vrs "$V/bad.md"
assert_eq   "vrs: a document with no vrs blocks scores 0/0 (prose rows are not rows)" \
  "VRS_MEASURABLE: 0/0" gate vrs "$FIX/cov-vrs.md"
assert_rc   "vrs: missing file exits 2" 2 gate vrs "$V/nope.md"

finish
