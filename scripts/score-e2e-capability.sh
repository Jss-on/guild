#!/usr/bin/env bash
# score-e2e-capability.sh — end-to-end BUSINESS-capability coverage of the guild harness.
# v2 — re-frozen 2026-09-02 after the business-process research pass
# (research/business-process-research-260902.md; 12 domain briefs, ~560 sources, in research/raw/).
#
# The target is a harness that takes a founding team with build capability (forge = software,
# anvil = hardware) from an idea to a working business with paying customers, and then sits as its
# board: evidence discipline → customer discovery → market → ICP + offer + pricing → unit economics
# that close → go-to-market + marketing → operations + finance + PH compliance → launch
# (human-gated) → first paying customer → standing board with numeric kill/pivot criteria.
#
# Row kinds (forge/anvil lineage):
#   rub  — forge-style grep RUBRIC: the file must match ≥ min of the listed concept patterns
#          (each pattern = +1). Concepts come from the research briefs, not from taste.
#   d/t  — gate WIRED (dispatch entry in scripts/score-guild.sh) AND fixture-TESTED
#          (tests/<domain>.test.sh <gate>, filter arg — zero matched cases = fail).
#   emit — gate EXECUTED on named fixtures with the contract line on stdout; every gate has a
#          GOOD fixture that must come out clean AND a BAD fixture with a planted defect the gate
#          must catch. A hollow gate cannot pass: it would have to detect the planted defect.
#
# Emits:  E2E_CAPABILITY: N/M   and   E2E_SCORE: 0.NN   (stdout)
#         per-row PASS/FAIL → stderr
#
# FROZEN SCORER: the improvement loop's Scope must EXCLUDE this file (and this file only).
# Editing the scorer to make rows pass is the one move the loop is never allowed. The fixture
# paths named below are part of the contract: the loop creates them; it does not rename them.

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

# ---- helpers (exported so `bash -c` rows can use them) ---------------------------------------
g()    { grep -qiE -- "$1" "$2" 2>/dev/null; }                       # pattern in file
d()    { grep -qE "^\s*$1\)" scripts/score-guild.sh 2>/dev/null; }    # dispatch entry
t()    { [[ -f "tests/$1.test.sh" ]] && bash "tests/$1.test.sh" "$2" >/dev/null 2>&1; }
emit() { # emit <regex> <sub> [args…] — the gate's FIRST stdout line must match regex
  local re="$1"; shift
  bash scripts/score-guild.sh "$@" 2>/dev/null | head -1 | grep -qE -- "$re"
}
rub()  { # rub <file> <min> <pattern…> — forge-style grep rubric
  local f="$1" min="$2"; shift 2; local n=0 p
  [[ -f "$f" ]] || { echo "rubric: missing $f" >&2; return 1; }
  for p in "$@"; do grep -qiE -- "$p" "$f" && n=$((n+1)); done
  echo "rubric $f: $n/$# (min $min)" >&2
  [[ $n -ge $min ]]
}
export -f g d t emit rub

SK=".claude/skills/guild/SKILL.md"
REF=".claude/skills/guild/references"
CMD=".claude/commands/guild"
BARE=".claude/commands/guild.md"
BUILD="$CMD/build.md"
FIX="tests/fixtures"

# =============================================================================================
# CORE — the seam itself (regression guard; green from the skeleton onward)
# =============================================================================================
row CORE-1 "score seam wired: pass-rate + coverage + validate + verdict" \
  bash -c 'd pass-rate && d coverage && d validate && d verdict'
row CORE-2 "score self-test green (tests/score.test.sh)" bash tests/score.test.sh
row CORE-3 "plugin mirror byte-parity (sync-plugin.sh --check)" bash scripts/sync-plugin.sh --check
row CORE-4 "SKILL: safety invariants — never fabricate; human-gated send/spend/sign/file; not legal/tax/financial advice; ledgers human-entered" \
  bash -c 'g "never fabricate" "$1" && g "human-gated" "$1" && g "not legal, tax, or financial advice" "$1" && g "human-entered" "$1"' _ "$SK"
row CORE-5 "doctor: CORE toolchain READY (git, node, awk, bash ≥ 4)" \
  bash -c 'bash scripts/doctor.sh | grep -q "DOCTOR: READY"'
row CORE-6 "handoff v3.1.0: build fixture VALID, discover fixture VALID, bad fixture INVALID, expected-source mismatch INVALID" \
  bash -c 'bash scripts/validate-handoff.sh "$1/handoff-good.json" | grep -q "HANDOFF: VALID" && bash scripts/validate-handoff.sh "$1/handoff-discover.json" discover | grep -q "HANDOFF: VALID" && bash scripts/validate-handoff.sh "$1/handoff-bad.json" | grep -q "HANDOFF: INVALID" && bash scripts/validate-handoff.sh "$1/handoff-good.json" discover | grep -q "HANDOFF: INVALID"' _ "$FIX"
row CORE-7 "strict evidence honoured: claimed-but-missing evidence path scores fail (1.00 → 0.55 on the strict fixture)" \
  bash -c 'emit "^PASS_RATE: 1\.00$" pass-rate "$1/strict/guild-results.tsv" && emit "^PASS_RATE: 0\.55$" pass-rate "$1/strict/guild-results.tsv" --strict-evidence' _ "$FIX"
row CORE-8 "validate contract: 7-dim spec with gated rows + ICP election VALID; customer without gate row INVALID" \
  bash -c 'emit "^VALIDATION: VALID$" validate "$1/spec/valid.spec.yaml" && emit "^VALIDATION: INVALID$" validate "$1/spec/no-gate.spec.yaml"' _ "$FIX"

# =============================================================================================
# EVID — evidence discipline (the business analogue of anvil's electrical gate)
# =============================================================================================
row EVID-1 "evidence protocol rubric ≥ 18/24 (forge research ledger schemas, tiers, retrieval + archive + hash, interview consent, say|do)" \
  rub "$REF/evidence-protocol.md" 18 \
  'sources\.tsv' 'claims\.tsv' 'T1|T2|T3|T4' 'locator' 'doi:|url:' 'depth' 'unverified' 'confidence' \
  'two independent|≥ ?2 .*T1|>= ?2 .*T1|2 distinct' 'contested' 'retrieved|retrieval date' \
  'archived_url|wayback|web\.archive' 'content_hash|hash' 'captcha' '\[C-[0-9n]+\]|C-n' \
  'numeric claim|every number|every figure' 'interviews\.tsv|interview ledger' 'consent' 'pseudonym' \
  'sensitive personal|RA 10173|Data Privacy' 'evidence_kind|say.*do|past behavio' 'human-entered|never writes' 'drafts/' 'evidence:'
row EVID-2 "sources gate wired+tested, validates the good ledger and rejects the bad one" \
  bash -c 'd sources && t evidence sources && emit "^SOURCES: VALID" sources "$1/evidence/sources.tsv" && emit "^SOURCES: INVALID" sources "$1/evidence/sources-bad.tsv"' _ "$FIX"
row EVID-3 "claims gate wired+tested (citation anchoring, tier floors, orphan refs)" \
  bash -c 'd claims && t evidence claims && emit "^CLAIMS: VALID" claims "$1/evidence/claims.tsv" "$1/evidence/sources.tsv" && emit "^CLAIMS: INVALID" claims "$1/evidence/claims-bad.tsv" "$1/evidence/sources.tsv"' _ "$FIX"
row EVID-4 "citations gate wired+tested: unsourced numeric claims counted (good doc = 0, bad doc ≥ 1)" \
  bash -c 'd citations && t evidence citations && emit "^UNSOURCED_CLAIMS: 0$" citations "$1/citations/good.md" "$1/evidence/claims.tsv" && emit "^UNSOURCED_CLAIMS: [1-9]" citations "$1/citations/bad.md" "$1/evidence/claims.tsv"' _ "$FIX"
row EVID-5 "interviews gate wired+tested: consent join, SPI explicit consent, quota per segment, evidence-grade share, early pitch, saturation" \
  bash -c 'd interviews && t discovery interviews && emit "^INTERVIEW_VIOLATIONS: 0$" interviews "$1/interviews/good.tsv" "$1/interviews/consent.tsv" && emit "^INTERVIEW_VIOLATIONS: [1-9]" interviews "$1/interviews/bad.tsv" "$1/interviews/consent.tsv"' _ "$FIX"
row EVID-6 "metrics: EVIDENCE GATE, strict evidence, human-entered ledgers, good/bad fixture convention documented" \
  bash -c 'g "EVIDENCE GATE" "$1" && g "strict" "$1" && g "human-entered" "$1" && g "good.*bad|bad fixture|planted" "$1"' _ "$REF/metrics.md"

# =============================================================================================
# DISC — customer discovery, market, venture requirements
# =============================================================================================
row DISC-1 "discovery protocol rubric ≥ 19/26 (Blank/Ries/Mom Test/Bland; consent RA 10173; saturation; segment election)" \
  rub "$REF/discovery-protocol.md" 19 \
  'assumption' 'we believe' 'riskiest|importance.*evidence' 'desirability|feasibility|viability' \
  'market type|existing market|new market|resegment' 'mom test|past behavio' 'pitch|solution_revealed|contaminat' \
  'commitment.*(time|reputation|money)' 'consent' 'RA 10173|sensitive personal|Data Privacy' 'pseudonym' \
  'saturation|new_codes|new codes' '12 interviews|≥ ?12|>= ?12|twelve' 'job stor' 'day.in.the.life' 'org chart|buyer' \
  'say.*do|evidence strength|evidence.grade' 'pre.?regist' 'LOI|letter of intent|paid pilot|pre.?order' 'earlyvangelist' \
  'PMF|very disappointed|40 ?%' 'retention' 'pivot' 'segment election|elected' 'interview script|drafts/' 'quota'
row DISC-2 "icp gate wired+tested: every ICP leaf traces to ≥ k interview ids; four forces; beachhead criteria; anti-ICP; decision-maker role" \
  bash -c 'd icp && t discovery icp && emit "^ICP_VIOLATIONS: 0$" icp "$1/icp/good.yaml" "$1/interviews/good.tsv" && emit "^ICP_VIOLATIONS: [1-9]" icp "$1/icp/bad.yaml" "$1/interviews/good.tsv"' _ "$FIX"
row DISC-3 "market protocol rubric ≥ 19/26 (sizing charter, PH frames LE/ASPBI/CPBI, bottom-up primary, triangulation, snapshots, source registry, CAPTCHA)" \
  rub "$REF/market-protocol.md" 19 \
  'sizing charter|counting unit|frame' 'List of Establishments|ASPBI|CPBI' 'PSIC' 'bottom.up' 'top.down' 'value.theory' \
  'triangulat' 'SOM' 'TAM' '1 ?%|one percent|Big Market Delusion' 'beachhead' 'status quo|do.nothing|DIY' \
  'snapshot' 'archived|wayback|web\.archive' 'hash' '90 days|≤ ?90|<= ?90' 'feature matrix' 'five forces|Porter' \
  'why.now|timing' 'source registry|sources\.tsv' 'reference period|cadence' 'CAPTCHA' 'PSA|DTI|BSP' \
  'SEIPI|IBPAP|DataReportal' 'Statista' 'stale|36 months|60 months'
row DISC-4 "market gate wired+tested: factor product = stated claim, SOM ≤ SAM ≤ TAM, ≥ 2 methods within 3×, bottom-up units P1/P2, archived sources" \
  bash -c 'd market && t market market && emit "^MARKET_VIOLATIONS: 0$" market "$1/market/good-factors.csv" "$1/market/claims.csv" "$1/evidence/sources.tsv" && emit "^MARKET_VIOLATIONS: [1-9]" market "$1/market/bad-factors.csv" "$1/market/claims.csv" "$1/evidence/sources.tsv"' _ "$FIX"
row DISC-5 "competitors gate wired+tested: status-quo row present, ≥ 3 alternatives with ≥ 2 interview ids each (no phantoms), dated hashed snapshots ≤ 90 d" \
  bash -c 'd competitors && t market competitors && emit "^COMPETITOR_VIOLATIONS: 0$" competitors "$1/competitors/good-alternatives.csv" "$1/competitors/good-snapshots.csv" && emit "^COMPETITOR_VIOLATIONS: [1-9]" competitors "$1/competitors/bad-alternatives.csv" "$1/competitors/good-snapshots.csv"' _ "$FIX"
row DISC-6 "venture-requirements protocol rubric ≥ 14/19 (V-n = assumption + metric + threshold + test method on the validation ladder; must-be checklist; exit criteria)" \
  rub "$REF/venture-requirements-protocol.md" 14 \
  'V-n|V-[0-9]' 'we believe|assumption' 'metric' 'threshold' 'test method|verify:' 'validation ladder|ladder' \
  'paid pilot' 'LOI|letter of intent' 'pre.?order|deposit' 'survey' 'desk' 'must-be' \
  'evidence.?grade|strong|moderate|weak' 'desirability|feasibility|viability' 'decide.by|deadline' 'owner' \
  'exit criteria|discovery exit|validation exit' 'segment election|elected' 'sign-off'
row DISC-7 "vrs gate wired+tested: every V-n row measurable (good = all, bad = fewer than all)" \
  bash -c 'd vrs && t discovery vrs && emit "^VRS_MEASURABLE: ([1-9][0-9]*)/\1$" vrs "$1/vrs/good.md" && emit "^VRS_MEASURABLE: " vrs "$1/vrs/bad.md" && ! emit "^VRS_MEASURABLE: ([0-9]+)/\1$" vrs "$1/vrs/bad.md"' _ "$FIX"
row DISC-8 "discover command rubric ≥ 16/22 (domain recon, ≤ 4-question rounds, VRS V-n, validate, handoff, drafted scripts, consent, quota, saturation, market type, election)" \
  rub "$CMD/discover.md" 16 \
  'EXECUTE IMMEDIATELY' 'domain recon|research.first|before the first question' 'AskUserQuestion' '4 questions|≤ ?4|<= ?4|max 4' \
  'VRS|Venture Requirements' 'V-n|V-[0-9]' 'threshold' 'test method|verify' 'validate' 'spec\.yaml' 'handoff' \
  'interview script|drafts/' 'consent' 'quota' 'saturation' 'market type' 'segment election|ICP election|elected' \
  'open-questions|open questions' '--chain build|chain' 'human-entered|never write' 'doctor' 'guild/discover-'
row DISC-9 "build: charter fixes the early irreversibles — ICP/segment election + market type" \
  bash -c 'g "irreversible" "$1" && g "ICP" "$1" && g "market type" "$1" && g "charter" "$1"' _ "$BUILD"

# =============================================================================================
# OFFER + PRICE — positioning, offer design, pricing
# =============================================================================================
row OFFER-1 "offer protocol rubric ≥ 24/34 (Dunford canvas, Moore statement, VPC, ICP/anti-ICP, paid discovery, G-B-B fences, bundling, guarantee cap, narrative, one-pager, pitch tests, PH tax note)" \
  rub "$REF/offer-protocol.md" 24 \
  'competitive alternatives|alternatives' 'status quo' 'phantom' 'unique attribute' 'value theme' 'proof' \
  'value proposition|pains|gains' '(≥|>=) ?3 interview|three interview' 'canvas' 'For .* who|Moore' 'category' \
  'head.to.head|big fish|new game|create.a.new' 'education budget' 'banned|adjective' '75 words' 'messaging|pillar' \
  'whole product' 'paid discovery' '5.?10 ?%|5–10' 'credit' 'Good.Better.Best|tier' 'fence' 'scope_out|scope out' \
  'mixed bundl' 'guarantee' 'cap' 'support_months|after-sales|warranty' 'prepay|50 ?%' 'ex-VAT|withholding|EWT' \
  'narrative|Raskin|promised land' 'one.pager' 'pitch test|confusion|next.step' 'anti-ICP' 'four forces|push.*pull'
row OFFER-2 "positioning gate wired+tested: six Moore slots, referential integrity to alternatives/ICP, ≤ 75 words, banned adjectives" \
  bash -c 'd positioning && t offer positioning && emit "^POSITIONING_VIOLATIONS: 0$" positioning "$1/positioning/good.yaml" "$1/competitors/good-alternatives.csv" "$1/icp/good.yaml" && emit "^POSITIONING_VIOLATIONS: [1-9]" positioning "$1/positioning/bad.yaml" "$1/competitors/good-alternatives.csv" "$1/icp/good.yaml"' _ "$FIX"
row OFFER-3 "offers gate wired+tested: exactly one paid-discovery offer, monotone tiers with fences, capped guarantee, tax note, first-deal prepay/terms" \
  bash -c 'd offers && t offer offers && emit "^OFFER_VIOLATIONS: 0$" offers "$1/offers/good.yaml" && emit "^OFFER_VIOLATIONS: [1-9]" offers "$1/offers/bad.yaml"' _ "$FIX"
row PRICE-1 "pricing protocol rubric ≥ 24/34 (WTP before build, cost floor at realistic utilisation, competitor band, VW/GG/CBC floors, metric, channel stack, G-B-B, pocket price, increases, VAT/8%/CWT/zero-rating/₱3M)" \
  rub "$REF/pricing-protocol.md" 24 \
  'willingness.to.pay|WTP' '(≥|>=) ?10|ten ' 'cost floor' 'fully.loaded' 'utili[sz]ation' '75 ?%' 'competitor' \
  '(≥|>=) ?3' '90 days' 'hash|archived' 'Van Westendorp|PMC|PME' 'Gabor' 'conjoint|CBC' 'price metric|value metric' \
  'per.seat|usage|tiered|flat' 'retainer|milestone|T&M|fixed.price' 'keystone|distributor|channel' 'Good.Better.Best|tier' \
  'fence' 'anchor' 'decoy' 'pocket price' 'discount' 'price increase|reason_text' 'grandfather' 'realised|realized' \
  'VAT' 'ex-VAT|exclusive|separate line' '8 ?%|eight percent' 'withholding|CWT|EWT|2307' 'zero.rat' \
  '3,000,000|₱3M|3M' '80 ?%' 'quarterly'
row PRICE-2 "pricing gate wired+tested: price ≥ floor/(1−GM), fresh floor ≤ 90 d, competitor band, WTP ≥ 10, VAT/8%/CWT consistency, tier fences" \
  bash -c 'd pricing && t pricing pricing && emit "^PRICE_VIOLATIONS: 0$" pricing "$1/pricing/good-price-book.csv" "$1/pricing/tax-status.csv" && emit "^PRICE_VIOLATIONS: [1-9]" pricing "$1/pricing/bad-price-book.csv" "$1/pricing/tax-status.csv"' _ "$FIX"

# =============================================================================================
# ECON — unit economics, cash, studio KPIs, benchmarks
# =============================================================================================
row ECON-1 "economics protocol rubric ≥ 28/40 (driver register with evidence classes, corners, sensitivity, CAC/LTV/payback/churn/burn/runway/default-alive, 13-week cash, landed cost, services KPIs, PH statute drivers, anvil/forge seam)" \
  rub "$REF/economics-protocol.md" 28 \
  'metric dictionary' 'driver|assumptions register' 'model\.csv' 'measured|quote|statute|benchmark|assumption' 'source_id' \
  'measured_from' 'base.*worst.*best|corner' 'sensitivity|tornado|±20|20 ?%' 'contribution margin' 'break.even' 'CAC' \
  'blended' 'LTV' 'net profit|24 months|24.month|gross.margin.adjusted' 'payback' '12.*18.*24|SMB.*mid.*enterprise' \
  'churn|NRR|GRR' 'burn multiple' 'runway' 'default.alive' '13.week|thirteen' 'variance' 'landed cost' 'BOM' \
  'scrap|yield' 'warranty reserve' 'tooling|MOQ|deposit' 'channel margin|DSO|DIO|DPO|cash conversion' 'utili[sz]ation' \
  'project margin' 'overrun' 'leakage' 'concentration' 'FAST|inputs.*calculation' 'PRODUCT_COST|score-anvil' 'forge' \
  'wage order|NCR|minimum wage' 'SSS|PhilHealth|Pag-IBIG' 'CIT|MCIT' 'VAT'
row ECON-2 "economics gate wired+tested: assertions evaluated at corners (good model all pass; bad model breaches at worst corner)" \
  bash -c 'd economics && t economics economics && emit "^ECON_PASS: ([1-9][0-9]*)/\1$" economics "$1/economics/good-model.csv" "$1/economics/assertions.tsv" && emit "^ECON_PASS: " economics "$1/economics/bad-model.csv" "$1/economics/assertions.tsv" && ! emit "^ECON_PASS: ([0-9]+)/\1$" economics "$1/economics/bad-model.csv" "$1/economics/assertions.tsv"' _ "$FIX"
row ECON-3 "cash gate wired+tested: 13-week forecast min cash ≥ floor, receipts variance, reserve months, runway" \
  bash -c 'd cash && t economics cash && emit "^CASH_PASS: ([1-9][0-9]*)/\1$" cash "$1/cash/good-cash13.csv" && emit "^CASH_PASS: " cash "$1/cash/bad-cash13.csv" && ! emit "^CASH_PASS: ([0-9]+)/\1$" cash "$1/cash/bad-cash13.csv"' _ "$FIX"
row ECON-4 "alive gate wired+tested: Paul Graham default-alive simulation from cash, 3-month net burn, trailing growth" \
  bash -c 'd alive && t economics alive && emit "^DEFAULT_ALIVE: 1" alive "$1/cash/alive-ledger.csv" && emit "^DEFAULT_ALIVE: 0" alive "$1/cash/dead-ledger.csv"' _ "$FIX"
row ECON-5 "studio gate wired+tested: utilisation, realisation, revenue/FTE vs loaded cost, project margin, leakage, pipeline coverage, concentration, DSO, deposit, cash-buffer days" \
  bash -c 'd studio && t economics studio && emit "^STUDIO_PASS: ([1-9][0-9]*)/\1$" studio "$1/studio/good-ledger.csv" && emit "^STUDIO_PASS: " studio "$1/studio/bad-ledger.csv" && ! emit "^STUDIO_PASS: ([0-9]+)/\1$" studio "$1/studio/bad-ledger.csv"' _ "$FIX"
row ECON-6 "cross-harness COGS seam: anvil PRODUCT_COST / BOM_COST and forge build cost feed the model" \
  bash -c 'g "PRODUCT_COST" "$1" && g "BOM_COST" "$1" && g "forge" "$1"' _ "$REF/economics-protocol.md"
row ECON-7 "benchmarks annex rubric ≥ 26/38 (numbers with provenance grade + retrieval date + verify-with caveat: SaaS/HW/services, sales, marketing, PH tax/labour/macro)" \
  rub "$REF/benchmarks.md" 26 \
  'provenance|P1|P2|P3' 'retrieved' 'verify with|caveat|not advice' 'LTV' '(≥|>=) ?3|3×|3x' 'payback' '12.*18.*24' \
  'gross margin' '65|70' '50 ?%' '35' 'utili[sz]ation' '68\.9|75' 'EBITDA' '9\.8|10 ?%' 'DSO' '43|45' \
  'cash buffer|27|13|62' 'coverage|2×|2x' 'win rate|19|21' '344|cold email' 'reply' '3\.8|landing page' 'VAT' \
  '3,000,000|₱3M' 'withholding|5 ?%|10 ?%|15 ?%' 'SSS|15 ?%' 'PhilHealth|5 ?%' 'Pag-IBIG|200' 'wage|₱7[0-9][0-9]' \
  'BSP|inflation|RRP' 'saturation|12' '40 ?%|very disappointed' 'MOQ|tooling|scrap' 'no.decision|20.*30' 'AQL|98 ?%' \
  'OKR|0\.6|0\.7' 'RA 12009|60 days|PhilGEPS'
row ECON-8 "metrics: seven dimensions, must-pass dims, both verdict grammars (NOT_READY/OPEN_FOR_BUSINESS/FIRST_CUSTOMER, CONTINUE/PIVOT/KILL), validate contract" \
  bash -c 'for d in evidence customer offer economics gtm operations governance; do grep -qiE "^\|\s*.?$d.?\s*\|" "$1" || exit 1; done; g "NOT_READY" "$1" && g "OPEN_FOR_BUSINESS" "$1" && g "FIRST_CUSTOMER" "$1" && g "CONTINUE" "$1" && g "PIVOT" "$1" && g "KILL" "$1" && g "validate" "$1"' _ "$REF/metrics.md"

# =============================================================================================
# GTM — sales, marketing, outreach
# =============================================================================================
row GTM-1 "gtm protocol rubric ≥ 26/37 (motion by ACV, founder-led ladder, MEDDPICC stage exits, paid pilots, paper-process tripwires, forecast hygiene, coverage = 1/win-rate, scale gate, channels, PH procurement, sends human-gated)" \
  rub "$REF/gtm-protocol.md" 26 \
  'sales hypothesis' 'motion' 'ACV' 'inside sales|field sales|self.serve|product.led' 'founder.led' 'first 10|warm' \
  '75 words|100 words' 'follow.up' 'human_approved|human sign-off|never (loop-)?pass' 'discovery' 'MEDDPICC|MEDDIC' \
  'SPIN|BANT|CHAMP' 'economic buyer' 'champion' 'stage exit|exit criteria' 'pilot' 'pilot_metric|8 weeks|paid pilot' \
  'proposal' 'tier' 'paper process|redline' 'unlimited liability|exclusivity|auto.renew' 'forecast categor|commit|best case' \
  'next.action|next step' 'stale|21 days|45 days' 'slip' 'coverage' 'win rate' 'loss reason|no.decision' 'case stud|reference' \
  'scale gate|first (sales )?hire|(≥|>=) ?10 (paid )?customers' 'channel|partner|VAR|reseller|agent' 'PhilGEPS|Platinum' \
  'RA 12009|MEARB|LCRB|ABC' 'bid security|performance security' 'payment_terms|withholding_pct|2307' 'deals\.csv|pipeline' 'outreach'
row GTM-2 "funnel gate wired+tested: no-next-step downgrade, staleness, slips, stage-exit fields, coverage vs win rate, loss reasons" \
  bash -c 'd funnel && t gtm funnel && emit "^FUNNEL_VIOLATIONS: 0$" funnel "$1/funnel/good-deals.csv" && emit "^FUNNEL_VIOLATIONS: [1-9]" funnel "$1/funnel/bad-deals.csv"' _ "$FIX"
row GTM-3 "paying gate: paying customer = won + invoice + payment evidence (paid fixture 1, unpaid fixture 0)" \
  bash -c 'd paying && emit "^PAYING_CUSTOMERS: 1$" paying "$1/pipeline-paid.tsv" && emit "^PAYING_CUSTOMERS: 0$" paying "$1/pipeline-unpaid.tsv"' _ "$FIX"
row GTM-4 "marketing protocol rubric ≥ 26/38 (STP/7Ps, brand vs activation, ≤ 3 channels, PH reach data, content clusters, tracking, experiments with n + duration + INCONCLUSIVE, consent opt-in, deliverability, ASC/RA 7394/ITA claim rules)" \
  rub "$REF/marketing-protocol.md" 26 \
  'STP|segment.*target.*position' '7Ps|4Ps|marketing mix' 'brand.*activation|share of voice|SOV' 'channel hypothesis|three channels|(≤|<=) ?3 channels' \
  'DataReportal' 'Facebook|Messenger' 'TikTok' 'LinkedIn' 'Viber' 'Shopee|Lazada|TikTok Shop' 'pillar|cluster' 'landing page' \
  'single CTA|one CTA|cta_count' 'case study' 'release form' 'UTM' 'attribution' 'experiment' 'hypothesis' \
  'required_n|sample size|MDE' 'min_duration|7 days' 'INCONCLUSIVE|peeking' 'ICE|RICE' 'evidence_ref' 'approved_by|budget' \
  'consent' 'opt.in|pre.ticked|NPC' 'unsubscribe' 'spam|0\.10|0\.30' 'ASC|Ad Standards|superlative' 'RA 7394|Consumer Act' \
  'Art(icle)? ?116|promo permit|30 days' 'Internet Transactions|RA 11967|ITA' 'activation|Ellis' 'subdomain|sending domain' \
  'placeholder|TBD|lorem' 'calendar' 'CPL|CAC by channel|MQL|SQL'
row GTM-5 "experiments gate wired+tested: hypothesis fields, pre-registration, required n + duration before WIN/LOSE, confidence needs evidence, spend approved" \
  bash -c 'd experiments && t marketing experiments && emit "^EXPERIMENT_VIOLATIONS: 0$" experiments "$1/experiments/good.csv" && emit "^EXPERIMENT_VIOLATIONS: [1-9]" experiments "$1/experiments/bad.csv"' _ "$FIX"
row GTM-6 "assets gate wired+tested: placeholders, single CTA, unsourced numbers without [ev:] refs, ASC superlatives, comparator naming, release form" \
  bash -c 'd assets && t marketing assets && emit "^ASSET_LINT: 0$" assets "$1/assets/good" "$1/evidence/claims.tsv" "$1/icp/good.yaml" && emit "^ASSET_LINT: [1-9]" assets "$1/assets/bad" "$1/evidence/claims.tsv" "$1/icp/good.yaml"' _ "$FIX"
row GTM-7 "consent gate wired+tested: every send row human-approved and joined to a live opt-in consent row for its channel" \
  bash -c 'd consent && t marketing consent && emit "^CONSENT_VIOLATIONS: 0$" consent "$1/consent/good-consent.csv" "$1/consent/good-sends.csv" && emit "^CONSENT_VIOLATIONS: [1-9]" consent "$1/consent/good-consent.csv" "$1/consent/bad-sends.csv"' _ "$FIX"

# =============================================================================================
# OPS — delivery, hardware operations, finance operations, PH compliance
# =============================================================================================
row OPS-1 "operations protocol rubric ≥ 27/38 (MSA/SOW anatomy, deposits + milestone-id payments, deemed acceptance, change control, IP, warranty floors, SLA, NPI gates, AQL, EMS/RFQ, NTC/BPS, Consumer Act, RMA, COD, ops manual)" \
  rub "$REF/operations-protocol.md" 27 \
  'MSA|master services' 'SOW|statement of work' 'acceptance criteria' 'review window|deemed accept' '5 business days|5 BD' \
  'milestone' 'deposit' '20 ?%|50 ?%' 'change (order|request|control)' 'no signature|before work|written approval' \
  '25 ?%|rebaseline' 'IP (ownership|assignment)' 'background IP' 'warranty' '90 days|90.day' 'holdback' 'SLA' \
  'P1|response|resolution' 'uptime|99\.9' 'handover|knowledge transfer' 'realiz|realis' 'write-off|write off' \
  'utili[sz]ation' 'on.time' 'CSAT|NPS' 'EVT|DVT|PVT' 'yield|98 ?%' 'AQL|Z1\.4' 'EMS|contract manufacturer|RFQ' \
  'MOQ|tooling' 'NTC|type approval' 'BPS|PS mark|ICC' 'RA 7394|Consumer Act' 'No Return|No Exchange' 'RMA|30 days' \
  'COD|courier' 'ops manual|runbook|SOP' 'Internet Transactions|ITA|listing'
row OPS-2 "sow gate wired+tested: required sections, payment lines tied to milestone ids, deposit ≥ 20 %, warranty floors, forbidden 'No Return, No Exchange'" \
  bash -c 'd sow && t ops sow && emit "^SOW_MISSING: 0$" sow "$1/sow/good.md" && emit "^SOW_MISSING: [1-9]" sow "$1/sow/bad.md"' _ "$FIX"
row OPS-3 "delivery gate wired+tested: kickoff needs signed + deposit, invoice on acceptance, zero hours before change-order approval, on-time and overrun" \
  bash -c 'd delivery && t ops delivery && emit "^DELIVERY_VIOLATIONS: 0$" delivery "$1/delivery/good" && emit "^DELIVERY_VIOLATIONS: [1-9]" delivery "$1/delivery/bad"' _ "$FIX"
row OPS-4 "regulatory gate wired+tested: radio ⇒ NTC certificate under the marketed model name; BPS-mandatory ⇒ PS/ICC; consumer warranty text floors" \
  bash -c 'd regulatory && t ops regulatory && emit "^SHIP_BLOCKERS: 0$" regulatory "$1/regulatory/good.csv" && emit "^SHIP_BLOCKERS: [1-9]" regulatory "$1/regulatory/bad.csv"' _ "$FIX"
row OPS-5 "finance protocol rubric ≥ 24/34 (accrual + framework, books/ORUS, invoice ≥ ₱500 with credit term, output-VAT credit, 2307 by the 20th, substantiation, AR aging/DSO, dunning + 6 % legal interest, 13-week cash, rails with corporate fees, FX, audit triggers)" \
  rub "$REF/finance-protocol.md" 24 \
  'accrual' 'fiscal year' 'PFRS for Small Entities|PFRS for SEs|income.tax basis' 'chart of accounts' \
  'books of accounts|ORUS|loose.leaf|CAS' 'invoice' '500' 'credit term' 'output VAT|uncollected' '2307' '20th' \
  'SAWT|1701Q|1702Q' 'substantiat|receipt' 'TIN' '5 years' 'ar_ledger|AR ledger|aging' 'DSO|45' '80 ?%|1.30' \
  'dunning|demand letter' '6 ?%|legal interest' 'cash13|13.week' 'variance' 'reserve|buffer|fixed opex' 'runway' \
  'InstaPay|PESONet' 'corporate' 'PayMongo|Maya|GCash' 'Wise|PayPal' 'Stripe' 'FX|BSP|FCDU' \
  'audit|Sec(tion)? 232|MC 4' 'concentration' 'SB Corp|SETUP|MSME (Business )?Fund' 'withholding agent|0619|1601'
row OPS-6 "ar gate wired+tested: short-payment classifier (paid + EWT + fee = gross), 2307 completeness, credit term on every VAT invoice, invoice fields, aging" \
  bash -c 'd ar && t ops ar && emit "^AR_VIOLATIONS: 0$" ar "$1/ar/good.csv" && emit "^AR_VIOLATIONS: [1-9]" ar "$1/ar/bad.csv"' _ "$FIX"
row OPS-7 "compliance protocol rubric ≥ 30/42 (register schema with applies_if/deadline_rule/evidence_hash/sign-off; DTI/SEC/BMBE/LGU/BIR/EOPT/VAT/8%/withholding/audit; SSS/PhilHealth/Pag-IBIG/13th/OSH; contractor test; DPA; ITA; Consumer Act; IP Code; trademark; FIA; not advice)" \
  rub "$REF/compliance-protocol.md" 30 \
  'applies_if' 'deadline_rule' 'evidence_hash|hash' 'overdue' 'requires_professional_signoff|professional sign-off' 'source_grade|verified_on' \
  'DTI|business name|BNRS' 'SEC|OPC|incorporat' 'BMBE|Negosyo' 'barangay|Mayor|business permit|BOSS' '20 Jan|January 20|Jan-20' \
  'BIR|2303|Certificate of Registration' 'ATP|invoice' 'books of accounts|5 years' 'EOPT|RA 11976|annual registration fee' \
  'VAT|2550Q' '3,000,000|₱3M|3M' 'percentage tax|2551Q' '8 ?%|eight percent|irrevocable' '1701|1702|quarterly' \
  'withholding|0619|1601|2307|1604|sworn declaration' 'audited|CPA|Sec(tion)? 232' 'SSS' 'PhilHealth' 'Pag-IBIG' '13th.month' \
  'OSH|DOLE|Rule 1020' 'contractor|control test|Sonza|four.fold' 'Data Privacy|RA 10173|NPC|DPO' 'Internet Transactions|RA 11967|E-Commerce Bureau' \
  'Consumer Act|RA 7394|warranty' 'e-signature|RA 8792' 'IP Code|RA 8293|178|assignment|copyright' 'trademark|IPOPHL|Declaration of Actual Use' \
  'FIA|foreign equity|US\$ ?200' 'CREATE MORE|RA 12066' 'not (legal|tax|financial) advice' 'accountant|lawyer' 'UNVERIFIED' \
  'first hire|has_employees' 'sells_online' 'never (loop-)?pass|human'
row OPS-8 "compliance gate wired+tested: applies_if vs profile, evidence present + hashed + on time, consistency rules, sign-off rows never auto-pass (overdue fixture < full)" \
  bash -c 'd compliance && t compliance compliance && emit "^COMPLIANCE: ([1-9][0-9]*)/\1$" compliance "$1/compliance/good-register.csv" "$1/compliance/profile.yaml" && emit "^COMPLIANCE: " compliance "$1/compliance/overdue-register.csv" "$1/compliance/profile.yaml" && ! emit "^COMPLIANCE: ([0-9]+)/\1$" compliance "$1/compliance/overdue-register.csv" "$1/compliance/profile.yaml"' _ "$FIX"

# =============================================================================================
# GOV — governance, the board, founders
# =============================================================================================
row GOV-1 "governance protocol rubric ≥ 26/36 (founders agreement + vesting, strategy kernel, KPI tree/North Star, OKRs, Sequoia board pack from ledgers, default-alive, kill rows, ADR log, pre-mortem, risk register, SAFE/advisor terms, PH funding time-gates)" \
  rub "$REF/governance-protocol.md" 26 \
  'founders.? agreement' 'vesting|cliff' 'IP assign' 'decision rights|decision_rights' 'strategy kernel|diagnosis|guiding policy|coherent action' \
  'Lean Canvas|Business Model Canvas' 'North Star' 'KPI tree|input metric' 'AARRR|pirate' 'OKR|key result' '0\.6|0\.7|sweet spot' \
  'board pack' 'big picture|calibration|closed session' 'pre-read|48 h|two days' 'staleness|31 days' 'waterfall' \
  'default.alive|default.dead' 'fatal pinch|months_to_zero' 'runway|net burn' 'pipeline coverage' 'kill' 'pivot' \
  'CONTINUE|PIVOT|KILL' 'hiring freeze|headcount' 'decision log|ADR' 'superseded|never reused' 'money_or_legal|one.way' \
  'pre-mortem|premortem' 'risk register' 'probability.*impact|p ?× ?i|score' 'trigger' 'SAFE' 'side letter|post-money' \
  'advisor|FAST' 'SB Corp|Startup Venture Fund|RA 11337|MAIN|IdeaSpace|QBO' 'human'
row GOV-2 "board gate wired+tested: pack sections derived from ledgers, staleness > 31 d or missing section fails" \
  bash -c 'd board && t gov board && emit "^BOARD_PACK: OK$" board "$1/board/good" && emit "^BOARD_PACK: (STALE|INCOMPLETE)" board "$1/board/bad"' _ "$FIX"
row GOV-3 "decisions gate wired+tested: ADR statuses + monotonic ids, money/legal decisions need a signed artifact, one-way doors need a pre-mortem, risks need owner/trigger/review" \
  bash -c 'd decisions && t gov decisions && emit "^GOVERNANCE_VIOLATIONS: 0$" decisions "$1/board/good/decisions.tsv" "$1/board/good/risks.csv" && emit "^GOVERNANCE_VIOLATIONS: [1-9]" decisions "$1/board/bad/decisions.tsv" "$1/board/bad/risks.csv"' _ "$FIX"
row GOV-4 "board command rubric ≥ 16/22 (pack from ledgers, DEFAULT_ALIVE, kill rows, ADR + risks, staleness/pre-read, CONTINUE|PIVOT|KILL verdict, handoff with pack)" \
  rub "$CMD/board.md" 16 \
  'EXECUTE IMMEDIATELY' 'board pack' 'ledger' 'KPI|actual.*plan' 'runway' 'DEFAULT_ALIVE|default.alive' 'months_to_zero|fatal pinch' \
  'coverage' 'kill|pivot' 'CONTINUE|PIVOT|KILL' 'decision log|ADR' 'risk register' 'staleness|31 days|48 h' 'pre-read' \
  'closed session' 'hiring freeze|headcount' 'handoff' 'pack' 'verdict' 'cadence|6.12 weeks|monthly' 'human' 'drafts/|never (send|spend|sign)'
row GOV-5 "founders gate wired+tested: split sums to 100, 4-year vest / 12-month cliff (or ADR), IP assigned, roles, decision rights, departure, signed" \
  bash -c 'd founders && t gov founders && emit "^FOUNDERS_AGREEMENT: VALID" founders "$1/board/good/founders-agreement.yaml" && emit "^FOUNDERS_AGREEMENT: INVALID" founders "$1/board/bad/founders-agreement.yaml"' _ "$FIX"

# =============================================================================================
# PROD — pipeline shape, commands, exemplar, template, docs
# =============================================================================================
row PROD-1 "build command rubric ≥ 24/34 (charter irreversibles; phases discovery → market → offer → pricing → economics → GTM → marketing → ops → finance → compliance → launch (human-gated) → first paying customer → board; ledger + verdict seams; output repo; dry-run)" \
  rub "$BUILD" 24 \
  'EXECUTE IMMEDIATELY' 'Phase' 'charter' 'irreversible' 'ICP election|segment election' 'market type' 'entity|tax posture|VAT' \
  'price metric' 'brand|domain' 'discovery' 'market' 'offer|positioning' 'pricing' 'economics' 'GTM|go-to-market' 'marketing' \
  'operations|SOW' 'finance|cash' 'compliance' 'launch' 'human.gated|sign-off' 'first paying customer' 'board' \
  'guild-results\.tsv' 'evidence:' 'coverage' 'verdict' 'OPEN_FOR_BUSINESS|FIRST_CUSTOMER' 'output repo|private' 'handoff' \
  '--dry-run' 'drafts/' 'templates/guild-venture|venture tree' 'keep|revert' 'validate' 'doctor'
row PROD-2 "improve command rubric ≥ 9/12 (named metrics, non-regression ratchet over evidence + economics + compliance, keep/revert, results ledger)" \
  rub "$CMD/improve.md" 9 \
  'EXECUTE IMMEDIATELY' 'conversion|gross_margin|ltv_cac|cac|payback|utili[sz]ation' 'ratchet' 'non-regression' 'evidence' \
  'economics' 'compliance' 'keep|revert' 'results\.tsv' 'handoff' 'Iterations' 'Verify'
row PROD-3 "bare /guild dispatch rubric ≥ 8/11 and evals rubric ≥ 6/8" \
  bash -c 'rub "$1" 8 "EXECUTE IMMEDIATELY" "banner|\[guild\] mode" "classic" "build" "wizard" "Metric:" "Verify:" "Spec:|Goal:" "Iterations" "doctor" "Direction" && rub "$2" 6 "EXECUTE IMMEDIATELY" "results\.tsv" "trend" "plateau" "regression" "funnel|cash|pipeline" "recommend" "handoff"' _ "$BARE" "$CMD/evals.md"
row PROD-4 "exemplar venture spec exists (evals/venture/*.spec.yaml — the studio itself) and validates VALID" \
  bash -c 'ok=0; for f in evals/venture/*.spec.yaml; do [[ -f "$f" ]] || continue; emit "^VALIDATION: VALID$" validate "$f" && ok=1; done; [[ $ok -eq 1 ]]'
row PROD-5 "template venture tree: README lists the ledger directories; template ledgers exist for discovery, gtm, economics, compliance, board" \
  bash -c 'rub templates/guild-venture/README.md 10 "evidence/" "discovery/" "market/" "offer/" "pricing/" "economics/" "gtm/" "ops/" "compliance/" "board/" "drafts/" && for f in discovery/interviews.tsv discovery/consent.tsv gtm/pipeline.tsv economics/model.csv compliance/register.csv board/decisions.tsv; do [[ -f "templates/guild-venture/$f" ]] || exit 1; done'
row PROD-6 "template ledgers pass their own gates (a fresh venture starts clean, not red): interviews, funnel, paying" \
  bash -c 'emit "^INTERVIEW_VIOLATIONS: 0$" interviews templates/guild-venture/discovery/interviews.tsv templates/guild-venture/discovery/consent.tsv && emit "^FUNNEL_VIOLATIONS: 0$" funnel templates/guild-venture/gtm/pipeline.tsv && emit "^PAYING_CUSTOMERS: 0$" paying templates/guild-venture/gtm/pipeline.tsv'
row PROD-7 "command contract: every command file has frontmatter name/description/argument-hint, EXECUTE IMMEDIATELY, seam resolution, handoff" \
  bash -c 'for f in "$1" "$2"/discover.md "$2"/build.md "$2"/board.md "$2"/improve.md "$2"/evals.md; do [[ -f "$f" ]] || exit 1; g "^name:" "$f" && g "^description:" "$f" && g "^argument-hint:" "$f" && g "EXECUTE IMMEDIATELY" "$f" && g "GUILD_ROOT|Seam" "$f" && g "handoff" "$f" || exit 1; done' _ "$BARE" "$CMD"
row PROD-8 "README declares idea → first paying customer scope, not-advice disclaimer, human-entered ledgers, research dossier pointer" \
  bash -c 'g "paying customer" README.md && g "not legal|not tax|not financial" README.md && g "human-entered" README.md && g "business-process-research" README.md'
row PROD-9 "metrics.md score surface documents every dispatch entry in score-guild.sh" \
  bash -c 'for s in $(grep -oE "^\s*[a-z-]+\)" scripts/score-guild.sh | tr -d " )"); do grep -q "\`$s" "$1" || { echo "undocumented gate: $s" >&2; exit 1; }; done' _ "$REF/metrics.md"
row PROD-10 "research dossier present with process map, gate registry, ledger registry, irreversibles, numbers annex, open items" \
  bash -c 'f=research/business-process-research-260902.md; g "process map" "$f" && g "gate registry" "$f" && g "ledger registry" "$f" && g "irreversible" "$f" && g "numbers annex|benchmark" "$f" && g "UNVERIFIED|open items" "$f"'

# ---- emit -----------------------------------------------------------------------------------
SCORE=$(awk -v p="$PASS" -v t="$TOTAL" 'BEGIN{printf "%.2f", (t>0)? p/t : 0}')
echo "E2E_CAPABILITY: $PASS/$TOTAL"
echo "E2E_SCORE: $SCORE"
exit 0
