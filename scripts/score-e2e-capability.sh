#!/usr/bin/env bash
# score-e2e-capability.sh — end-to-end BUSINESS-capability coverage of the guild harness.
#
# The target is a harness that takes a founding team with build capability (forge = software,
# anvil = hardware) from an idea to a working business with paying customers, and then sits as its
# board: evidence discipline → customer discovery → market → ICP + offer + pricing → unit economics
# that close → go-to-market plan + assets → operations + compliance → launch (human-gated) → first
# paying customer → standing board cadence with numeric kill/pivot criteria.
#
# One row per capability. A row passes only if its check exits 0. Grep rows verify wiring
# (protocol exists, phase gated, dispatch present); executable-test rows are the teeth. Every gate
# capability pairs a dispatch check with a fixture test so a hollow file cannot pass alone.
#
# Emits:  E2E_CAPABILITY: N/M   and   E2E_SCORE: 0.NN   (stdout)
#         per-row PASS/FAIL → stderr
#
# FROZEN SCORER: the improvement loop's Scope must EXCLUDE this file (and this file only).
# Editing the scorer to make rows pass is the one move the loop is never allowed.

set -u
cd "$(dirname "$0")/.." || exit 2

PASS=0; TOTAL=0
row() { # id  description  cmd...
  local id="$1" desc="$2"; shift 2
  TOTAL=$((TOTAL+1))
  if "$@" >/dev/null 2>&1; then
    PASS=$((PASS+1)); printf 'PASS  %-8s %s\n' "$id" "$desc" >&2
  else
    printf 'FAIL  %-8s %s\n' "$id" "$desc" >&2
  fi
}

SK=".claude/skills/guild/SKILL.md"
REF=".claude/skills/guild/references"
CMD=".claude/commands/guild"
BUILD="$CMD/build.md"

# ---- CORE — the seam itself (regression guard; green from the skeleton onward) ---------------
row CORE-1 "score seam: pass-rate + coverage + verdict wired" \
  bash -c 'grep -qE "^\s*pass-rate\)" scripts/score-guild.sh && grep -qE "^\s*coverage\)" scripts/score-guild.sh && grep -qE "^\s*verdict\)" scripts/score-guild.sh'
row CORE-2 "score self-test green (tests/score.test.sh)" bash tests/score.test.sh
row CORE-3 "plugin mirror byte-parity (sync-plugin.sh --check)" bash scripts/sync-plugin.sh --check
row CORE-4 "SKILL: safety invariants — human-gated send/spend/sign/file; never fabricate evidence" \
  bash -c 'grep -qi "never fabricate" "$1" && grep -qi "human-gated" "$1"' _ "$SK"
row CORE-5 "doctor: CORE toolchain READY (git, node)" \
  bash -c 'bash scripts/doctor.sh | grep -q "DOCTOR: READY"'
row CORE-6 "handoff validator: good fixture VALID, bad fixture INVALID" \
  bash -c 'bash scripts/validate-handoff.sh tests/fixtures/handoff-good.json | grep -q "HANDOFF: VALID" && bash scripts/validate-handoff.sh tests/fixtures/handoff-bad.json | grep -q "HANDOFF: INVALID"'

# ---- EVID — evidence discipline (the business analogue of anvil's electrical gate) -----------
row EVID-1 "evidence protocol: claims ledger (locator, retrieved date, grade) + interview ledger (consent)" \
  bash -c 'grep -qiE "retrieved" "$1" && grep -qiE "consent" "$1" && grep -qiE "locator" "$1"' _ "$REF/evidence-protocol.md"
row EVID-2 "citations gate wired+tested (unsourced numeric claims → count)" \
  bash -c 'grep -qE "^\s*citations\)" scripts/score-guild.sh && bash tests/evidence.test.sh citations'
row EVID-3 "interviews gate wired+tested (ledger completeness, segment quota, human-entered)" \
  bash -c 'grep -qE "^\s*interviews\)" scripts/score-guild.sh && bash tests/evidence.test.sh interviews'
row EVID-4 "metrics: EVIDENCE GATE caps pass-rate; ledgers table says who writes what" \
  bash -c 'grep -q "EVIDENCE GATE" "$1" && grep -qi "human-entered" "$1"' _ "$REF/metrics.md"

# ---- DISC — customer discovery + market ------------------------------------------------------
row DISC-1 "discovery protocol: interview discipline (past behavior, no pitching, quotas by segment)" \
  bash -c 'grep -qiE "past behavio" "$1" && grep -qiE "pitch" "$1" && grep -qiE "quota" "$1"' _ "$REF/discovery-protocol.md"
row DISC-2 "icp gate wired+tested (every ICP attribute traces to ≥ k interview rows)" \
  bash -c 'grep -qE "^\s*icp\)" scripts/score-guild.sh && bash tests/discovery.test.sh icp'
row DISC-3 "market protocol: TAM/SAM/SOM triangulated bottom-up + top-down, competitor matrix, PH sources" \
  bash -c 'grep -qiE "bottom-up" "$1" && grep -qiE "competitor" "$1" && grep -qiE "SOM" "$1"' _ "$REF/market-protocol.md"
row DISC-4 "discover command: VRS with V-n rows — metric + threshold + test method per assumption" \
  bash -c 'grep -qE "V-n" "$1" && grep -qiE "threshold" "$1" && grep -qiE "test method|verify:" "$1"' _ "$CMD/discover.md"
row DISC-5 "venture-requirements protocol: validation ladder (paid pilot > LOI > interview > survey > desk) + must-be checklist" \
  bash -c 'grep -qiE "paid pilot" "$1" && grep -qiE "must-be" "$1" && grep -qiE "LOI|letter of intent" "$1"' _ "$REF/venture-requirements-protocol.md"
row DISC-6 "build: ICP/segment election = charter-level early irreversible" \
  bash -c 'grep -qiE "irreversible" "$1" && grep -qE "ICP" "$1"' _ "$BUILD"

# ---- ECON — offer, pricing, unit economics ---------------------------------------------------
row ECON-1 "offer protocol: positioning statement, value proposition, packaging tiers, pricing methods" \
  bash -c 'grep -qiE "positioning statement" "$1" && grep -qiE "tier" "$1" && grep -qiE "value proposition" "$1"' _ "$REF/offer-protocol.md"
row ECON-2 "economics protocol: model schema, corners (base/worst/best), assertions (GM, LTV/CAC, payback, runway)" \
  bash -c 'grep -qiE "LTV" "$1" && grep -qiE "runway" "$1" && grep -qiE "corner" "$1" && grep -qiE "payback" "$1"' _ "$REF/economics-protocol.md"
row ECON-3 "economics gate wired+tested (assertions at corners)" \
  bash -c 'grep -qE "^\s*economics\)" scripts/score-guild.sh && bash tests/economics.test.sh economics'
row ECON-4 "pricing gate wired+tested (≥ cost floor, competitor band or logged justification, VAT-aware)" \
  bash -c 'grep -qE "^\s*pricing\)" scripts/score-guild.sh && bash tests/economics.test.sh pricing'
row ECON-5 "cross-harness COGS seam: anvil PRODUCT_COST/BOM_COST + forge build cost feed the model" \
  bash -c 'grep -qE "PRODUCT_COST" "$1" && grep -qiE "forge" "$1"' _ "$REF/economics-protocol.md"

# ---- GTM — go-to-market, sales, marketing ----------------------------------------------------
row GTM-1 "gtm protocol: channel matrix, sales playbook stages, pipeline ledger schema, marketing calendar + experiments" \
  bash -c 'grep -qiE "playbook" "$1" && grep -qiE "pipeline" "$1" && grep -qiE "calendar" "$1" && grep -qiE "experiment" "$1"' _ "$REF/gtm-protocol.md"
row GTM-2 "funnel gate wired+tested (stage conversion; paying customer = won + invoice + payment evidence)" \
  bash -c 'grep -qE "^\s*funnel\)" scripts/score-guild.sh && bash tests/gtm.test.sh funnel'
row GTM-3 "assets lint gate wired+tested (placeholders, missing ICP/offer/price/CTA, unsourced numbers)" \
  bash -c 'grep -qE "^\s*assets\)" scripts/score-guild.sh && bash tests/gtm.test.sh assets'
row GTM-4 "every send/publish/spend is a human sign-off row the loop never passes" \
  bash -c 'grep -qiE "never loop-passed|never mark(s|ed)? .*pass|human sign-off" "$1"' _ "$REF/gtm-protocol.md"

# ---- OPS — operations, compliance ------------------------------------------------------------
row OPS-1 "operations protocol: delivery process (SOW, milestones, acceptance, invoicing, support/SLA) for forge/anvil deliverables" \
  bash -c 'grep -qiE "SOW|statement of work" "$1" && grep -qiE "SLA" "$1" && grep -qiE "invoice" "$1"' _ "$REF/operations-protocol.md"
row OPS-2 "compliance protocol: PH register (DTI/SEC, BIR, LGU permit, SSS/PhilHealth/Pag-IBIG, VAT threshold) + accountant/lawyer sign-off rows" \
  bash -c 'grep -qE "BIR" "$1" && grep -qiE "Mayor|LGU" "$1" && grep -qiE "sign-off" "$1" && grep -qiE "VAT" "$1"' _ "$REF/compliance-protocol.md"
row OPS-3 "compliance gate wired+tested (document evidence per row; sign-off rows never auto-pass)" \
  bash -c 'grep -qE "^\s*compliance\)" scripts/score-guild.sh && bash tests/ops.test.sh compliance'

# ---- GOV — governance / the board ------------------------------------------------------------
row GOV-1 "governance protocol: board pack template, KPI tree, decision log, risk register, numeric kill/pivot criteria" \
  bash -c 'grep -qiE "kill" "$1" && grep -qiE "pivot" "$1" && grep -qiE "decision log" "$1" && grep -qiE "risk register" "$1"' _ "$REF/governance-protocol.md"
row GOV-2 "board command: BOD cadence — pack from ledgers → decisions → CONTINUE|PIVOT|KILL" \
  bash -c 'grep -qiE "board pack" "$1" && grep -qE "PIVOT" "$1" && grep -qE "KILL" "$1"' _ "$CMD/board.md"
row GOV-3 "board gate wired+tested (pack sections derived from ledgers, staleness check)" \
  bash -c 'grep -qE "^\s*board\)" scripts/score-guild.sh && bash tests/gov.test.sh board'

# ---- PROD — pipeline shape, exemplar, docs ---------------------------------------------------
row PROD-1 "build: phase-gated pipeline charter → discovery → market → ICP → offer → economics → GTM → ops → launch → first paying customer → board" \
  bash -c 'grep -qiE "first paying customer" "$1" && grep -qE "Phase" "$1" && grep -qiE "charter" "$1"' _ "$BUILD"
row PROD-2 "build: launch phase human-gated; improve: non-regression ratchet" \
  bash -c 'grep -qiE "human" "$1" && grep -qiE "ratchet" "$2"' _ "$BUILD" "$CMD/improve.md"
row PROD-3 "metrics: seven dimensions with weights (evidence … governance)" \
  bash -c 'for d in evidence customer offer economics gtm operations governance; do grep -qiE "^\|\s*.?$d.?\s*\|" "$1" || exit 1; done' _ "$REF/metrics.md"
row PROD-4 "exemplar venture spec exists (evals/venture/*.spec.yaml — the studio itself)" \
  bash -c 'ls evals/venture/*.spec.yaml'
row PROD-5 "template venture tree (evidence/ discovery/ market/ offer/ economics/ gtm/ ops/ compliance/ board/)" \
  bash -c 'grep -q "discovery/" "$1" && grep -q "board/" "$1" && grep -q "economics/" "$1"' _ templates/guild-venture/README.md
row PROD-6 "README declares idea → first paying customer scope + not-advice disclaimer" \
  bash -c 'grep -qi "paying customer" README.md && grep -qiE "not legal|not tax|not financial|not legal, tax, or financial" README.md'
row PROD-7 "benchmarks annex with provenance caveats (LTV/CAC, GM ranges, PH thresholds)" \
  bash -c 'grep -qiE "provenance|verify with" "$1" && grep -qiE "LTV" "$1" && grep -qiE "VAT" "$1"' _ "$REF/benchmarks.md"
row PROD-8 "commands: bare /guild dispatch + evals exist" \
  bash -c 'ls .claude/commands/guild.md .claude/commands/guild/evals.md'

# ---- emit -----------------------------------------------------------------------------------
SCORE=$(awk -v p="$PASS" -v t="$TOTAL" 'BEGIN{printf "%.2f", (t>0)? p/t : 0}')
echo "E2E_CAPABILITY: $PASS/$TOTAL"
echo "E2E_SCORE: $SCORE"
exit 0
