# Metrics Contract

The scoring spine. Everything here is mechanical; nothing here is impressions. Research basis:
`research/business-process-research-260902.md` (12 domain briefs, ~560 sources).

## guild-results.tsv (7 tab-separated columns)

```
n   dimension   assertion                                            status  weight  evidence                              traces
1   evidence    every market figure traces to a claims-ledger row    pass    1.0     evidence:evidence/claims.tsv          V-1
2   customer    12 interviews across 2 segments, consent recorded    pass    1.0     evidence:discovery/interviews.tsv     V-2
3   economics   gross margin >= 35 % at worst corner                 fail    1.0     evidence:economics/model.csv          V-4
```
`status ∈ pass|fail|skip` (skip = not applicable, excluded from scoring — never a parking lot for
hard rows). `weight` scales within the dimension. `evidence:` is a repo-relative path — a row
without evidence is `fail` by definition, and under **strict evidence** (`--strict-evidence` /
`GUILD_EVIDENCE_STRICT=1`) a `pass` row whose path does not resolve is rewritten to `fail`
(`EVIDENCE-MISSING`). `traces` = comma-joined `V-n` (the RTM against the VRS).

## Dimensions & weights (renormalized over dims that ran)

| Dimension | Weight | Owns |
|---|---|---|
| `evidence` | 0.25 | unsourced numeric claims = 0 · sources ledger valid (locator + retrieval date + archive/hash) · claims ledger valid (tier floors) · interview ledger complete + consented · no fabricated rows |
| `customer` | 0.20 | interview quota per segment · evidence-grade share · ICP leaves traced to ≥ k interviews · VRS rows measurable · segment + market-type election recorded |
| `offer` | 0.15 | positioning statement lint clean · offers ledger (paid discovery, tiers, fences, capped guarantee, tax note) · pricing book (floor, band, WTP, tax consistency) |
| `economics` | 0.15 | driver register cited · assertions hold at base AND worst corners · 13-week cash closes · default-alive · studio KPIs within floors · COGS from anvil/forge outputs where applicable |
| `gtm` | 0.10 | funnel hygiene (next step, staleness, slips, coverage vs win rate) · experiments pre-registered with n + duration · assets lint = 0 · consent joined to every send |
| `operations` | 0.05 | SOW lint · delivery ledger (deposit, acceptance, change control) · regulatory ship-blockers = 0 · AR ledger (2307, credit term, short-payment) · compliance register evidenced and on time |
| `governance` | 0.10 | founders agreement valid · board pack derived from fresh ledgers · decision log + risk register clean · kill/pivot rows evaluated · cadence kept |

**EVIDENCE GATE:** while ANY `evidence` row is red, headline pass-rate is capped at
`EVIDENCE_GATE_CAP` (default 0.50). A business built on invented numbers cannot be polished over.

**Must-pass:** `customer` and `economics` fails block the verdict — a beautiful deck for a
customer nobody interviewed, or an offer whose worst-corner margin is negative, is `NOT_READY`.

**Flooring:** the headline is floored to 2 decimals (never rounded up); a single weighted division
keeps an all-pass ledger at exactly 1.00. Unknown dimension names are scored at 0.10 and named on
stderr so a typo cannot hide a red row.

## Verdict grammars

| Verdict (`score-guild.sh verdict`) | Meaning |
|---|---|
| `NOT_READY` | evidence gate red, or a must-pass dim red, or rate < `TARGET_RATE` (1.00), or VRS coverage < 1.00 |
| `OPEN_FOR_BUSINESS` | ledger green — offer, price, economics, plan, operations and compliance are ready for a human to launch |
| `FIRST_CUSTOMER` | `OPEN_FOR_BUSINESS` **and** `gtm/pipeline.tsv` holds ≥ 1 `won` row with an invoice id and `payment = evidence:<path>` (human-entered) |

| Verdict (`/guild:board`, from the `board` + `alive` + kill rows) | Meaning |
|---|---|
| `CONTINUE` | no kill row breached; DEFAULT_ALIVE or a funded plan; pack fresh |
| `PIVOT` | a pre-committed pivot row breached (PMF < 40 % on n ≥ 40, zero paid invoices by date D, OKR average < 0.3 two quarters) — the pivot ADR must name the retained learning and pivot type |
| `KILL` | a pre-committed kill row breached (DEFAULT_DEAD with months_to_zero ≤ 6 and no accepted fatal-pinch ADR, or the founders' own kill date) |

Board verdicts are computed against the numeric rows in `references/governance-protocol.md`, never
from sentiment; issuing the verdict is mechanical, acting on it is human.

## validate — the discover → build contract

`score-guild.sh validate <venture.spec.yaml>` is VALID iff the spec has `name`, `thesis` (or
`summary`), a top-level `segment:` block with an `icp:` line (the ICP election — a charter-level
early irreversible), and an `acceptance:` block covering ALL SEVEN dimensions with ≥ 1 weighted
assertion, where `evidence`, `customer` and `economics` each carry ≥ 1 gated row (`gate: true`).
Exit 0 VALID / 1 INVALID / 2 ERROR. `/guild:discover` may not hand a spec to `/guild:build` until
it validates.

## Ledgers — human-entered vs loop-written

| Ledger | Writer | Read by |
|---|---|---|
| `evidence/sources.tsv`, `evidence/claims.tsv` | loop — forge research schema; every source has locator + retrieval date + archived URL/hash; a CAPTCHA page is not a source | `sources`, `claims`, `citations`, `market` |
| `discovery/assumptions.csv`, `discovery/segments.csv`, `discovery/experiments.csv` | loop (scores and elections are human sign-off rows) | `vrs`, `icp` |
| `discovery/interviews.tsv`, `discovery/consent.tsv`, `discovery/commitments.csv` | **human-entered** (loop drafts scripts + candidate rows into `drafts/`) | `interviews`, `icp` |
| `market/factors.csv`, `market/claims.csv`, `market/alternatives.csv`, `market/snapshots.csv` | loop (prices obtained by quote carry `captured_by` = human) | `market`, `competitors`, `positioning` |
| `offer/positioning.yaml`, `offer/offers.yaml`, `offer/pitch_tests.csv` | loop; `pitch_tests.csv` **human-entered** | `positioning`, `offers` |
| `pricing/price-book.csv`, `pricing/tax-status.csv`, `pricing/competitor-band.csv`, `pricing/wtp-interviews.csv` | loop; WTP rows and tax elections **human-entered** | `pricing` |
| `economics/model.csv`, `economics/assertions.tsv`, `economics/cash13.csv`, `economics/variance.csv` | loop — every driver carries `evidence ∈ measured|quote|statute|benchmark|assumption` and a source; actuals **human-entered** | `economics`, `cash`, `alive`, `studio` |
| `gtm/pipeline.tsv` (`deals.csv`), `gtm/outreach.csv` | **human-entered** (stage moves, sends, outcomes, invoices, payments); loop drafts next actions and assets | `funnel`, `paying`, `verdict`, `consent` |
| `marketing/experiments.csv`, `marketing/calendar.csv`, `marketing/assets.csv`, `marketing/consent.csv`, `marketing/spend.csv` | loop plans; publish/send/spend rows **human-approved** | `experiments`, `assets`, `consent` |
| `ops/projects.csv`, `ops/milestones.csv`, `ops/change_orders.csv`, `ops/time.csv`, `ops/regulatory.csv`, `ops/ar_ledger.csv` | **human-entered** facts (signatures, acceptance, payments, certificates); loop lints | `sow`, `delivery`, `regulatory`, `ar` |
| `compliance/register.csv`, `compliance/profile.yaml` | **human-entered** documents + professional sign-offs; loop writes checklist rows | `compliance` |
| `board/founders-agreement.yaml`, `board/decisions.tsv`, `board/risks.csv`, `board/kpi_actuals.csv`, `board/kill-criteria.csv` | human + loop; money/legal decisions need a signed artifact | `board`, `decisions`, `founders` |

## score-guild.sh surface (one stdout line each; detail → stderr; exit 2 only on hard error)

| Subcommand | Emits | Status | Checks (source brief in brackets) |
|---|---|---|---|
| `pass-rate [tsv] [--strict-evidence]` | `PASS_RATE: 0.NN` | shipped | weighted, floored, evidence gate, strict evidence |
| `coverage [tsv] [vrs]` | `REQ_COVERAGE: 0.NN` | shipped | every V-n traced ≥ 1 row; orphans → stderr |
| `validate <spec>` | `VALIDATION: VALID\|INVALID\|ERROR` | shipped | contract above |
| `verdict [tsv] [vrs\|-] [pipeline]` | `NOT_READY \| OPEN_FOR_BUSINESS \| FIRST_CUSTOMER` | shipped | gates, must-pass, coverage, paying rows |
| `paying <pipeline.tsv>` | `PAYING_CUSTOMERS: N` | shipped | won + invoice + `evidence:` payment |
| `sources <sources.tsv>` | `SOURCES: VALID\|INVALID …` | planned | port of forge `score-research.sh sources`: 9 cols, tiers T1–T4, locator forms, depth, status; `unverified`/`rejected` uncitable [01, 02] |
| `claims <claims.tsv> <sources.tsv>` | `CLAIMS: VALID\|INVALID …` | planned | port of forge `claims`: anchoring, tier floors (high ≥ 2 T1/T2; T4-only invalid), orphan refs [02] |
| `citations <doc> <claims.tsv>` | `UNSOURCED_CLAIMS: N` | planned | every `\d+(\.\d+)?\s?%`, `\d+x`, `₱\d`, `\$\d`, `\d{4,}` in a doc carries a `[C-n]` that resolves; comparative/superlative words need a comparator [02, 07] |
| `interviews <interviews.tsv> <consent.tsv> [quota.tsv]` | `INTERVIEW_VIOLATIONS: N` | planned | 100 % join to consent; `spi_collected=Y ⇒ spi_explicit_consent=Y`; none past `deletion_due`; ≥ 12 per elected segment (≥ 6 before "common"); `solution_revealed=N` for first 6; recorded or verbatim 100 %; evidence-grade (past behaviour ∧ spend/time/WTP/commitment) ≥ 50 %; saturation = `new_codes_count=0` on last 3 [01] |
| `icp <icp.yaml> <interviews.tsv>` | `ICP_VIOLATIONS: N` | planned | every leaf ≥ 3 interview ids (≥ 5 once ≥ 20 interviews); four forces non-empty; five beachhead criteria sourced; ≥ 3 anti-ICP disqualifiers; `decision_maker_role`; `procurement_mode ∈ private\|philgeps_lcrb\|philgeps_mearb\|philgeps_consulting` (+ certificate status) [03, 01] |
| `vrs <vrs.md>` | `VRS_MEASURABLE: x/y` | planned | each `V-n`: "We believe" statement, metric, threshold with direction, test method on the ladder (`paid_pilot > LOI > pre_order > interview > survey > desk`), type D/F/V/A, decide-by, owner; riskiest 3 need a `do`-class test [01, 03] |
| `market <factors.csv> <claims.csv> <sources.tsv>` | `MARKET_VIOLATIONS: N` | planned | product of factor rows within 1 % of stated; every factor sourced, `archived_url` matches `^https://web\.archive\.org/web/\d{14}/`, graded; bottom-up `unit_count` P1/P2 only; SOM ≤ SAM ≤ TAM; SOM `adoption_share` needs bottom-up anchor; ≥ 2 methods per layer with max/min ≤ 3.0; staleness 24/36/60 months [02] |
| `competitors <alternatives.csv> <snapshots.csv>` | `COMPETITOR_VIOLATIONS: N` | planned | ≥ 1 `status_quo\|diy\|do_nothing`; ≥ 3 others each with ≥ 2 interview ids (no phantoms); every non-do-nothing alt has a snapshot ≤ 90 d with `archived_url` + `screenshot_hash` + `price_metric` [02, 03] |
| `positioning <positioning.yaml> <alternatives.csv> <icp.yaml>` | `POSITIONING_VIOLATIONS: N` | planned | six Moore slots non-empty; `primary_alternative` ∈ alternatives; `target` ⊆ ICP segment; `differentiator`/`benefit` resolve to attribute/theme ids; ≤ 75 words, slot ≤ 25; banned adjectives (`simple\|affordable\|cheap\|quality\|innovative\|best`); `create_new_game` needs an education-budget line; 2–4 value themes each with ≥ 1 proof id [03] |
| `offers <offers.yaml>` | `OFFER_VIOLATIONS: N` | planned | exactly one `discovery` offer priced 5–10 % of median build price with credit deadline 14–42 d; tiers monotone with ≥ 1 fence each and `good.scope_out`; bundles `a_la_carte_available`; guarantee has trigger/remedy/`cap_pct ≤ 100`; hardware `support_months ≥ warranty_months`; first engagement `prepay_pct ≥ 50`, `payment_terms_days ≤ 30`; `tax_note` "ex-VAT; subject to EWT" [03] |
| `pricing <price-book.csv> <tax-status.csv> [competitor-band.csv] [wtp.csv]` | `PRICE_VIOLATIONS: N` | planned | `list ≥ cost_floor/(1−target_gm)`; hardware retail `list ≥ 3×cogs` (warn) `≥ 4×` (pass), GM ≥ 40 %; `floor_date ≤ 90 d`, utilisation input ≤ 75 % (> 70 % needs justification); `competitor_n ≥ 3` ≤ 90 d hashed, list outside [0.8×low, 1.5×high] needs `justification_ref`; new offer needs ≥ 10 WTP rows; VW `n ≥ 150` and `pmc ≤ list ≤ pme`, GG `n ≥ 100`, CBC `n·t·a/c ≥ 500`; trailing-12m > ₱3M ⇒ `vat_registered` and no `exempt_nonvat` rows (warn at 80 %); VAT ⇒ no 8 %; zero-rated only with foreign-currency client; B2B `display = exclusive`; `cwt_rate_expected ∈ {5,10}` (sole prop) / `{10,15}` (corp); pocket/list ≥ 1 − max_discount; P90/P10 band > 1.6× review; increases need `reason_text`, ≥ 30 d notice, `grandfather_until`, `realised_pct` [04] |
| `economics <model.csv> <assertions.tsv>` | `ECON_PASS: x/y` | planned | loader: `evidence ∈ measured\|quote\|statute\|benchmark\|assumption`, benchmark/statute rows need `source_id`, measured rows need `measured_from`, assumptions listed as open risks, derived values may not be typed as drivers; assertions at base/worst/best: UE-01 GM ≥ floor (SaaS .65 / HW .50 direct, .30 hard / services delivery .35), UE-02 LTV/CAC ≥ 3 base ≥ 1 worst (LTV GM-adjusted, 24-mo cap), UE-03 payback ≤ 12/18/24 by segment, UE-04 net revenue churn ≤ 2 %/mo, UE-05 burn multiple ≤ 2 (seed ≤ 3), UE-06 runway ≥ 18 base / ≥ 12 worst, UE-09 CM break-even ≤ cash-out month, HW-01..04 landed cost / first-PO cash / working capital / tooling amortisation, SV-01..04 utilisation ≥ .70 (worst ≥ .60), project margin ≥ .35, overrun ≤ 10 %, ALL-01 concentration ≤ 20 %, ALL-02 ±20 % fragility, PH-01/02 wage-order max and CIT/VAT by threshold [05] |
| `cash <cash13.csv> [variance.csv]` | `CASH_PASS: x/y` | planned | weekly rows; min closing cash ≥ `min_cash_floor` (one payroll cycle); receipts variance last 4 weeks ≤ 15 %; updated within 7 d; reserve months ≥ 3 fixed opex (policy; 1–3 floor P3); cash-buffer days ≥ 27 (alarm 13); runway ≥ 6 [05, 10, 12] |
| `alive <cash_ledger.csv>` | `DEFAULT_ALIVE: 1\|0` (+ `months_to_zero` → stderr) | planned | PG simulation: expenses flat, revenue growth = trailing 3–6-month compound rate; alive iff revenue ≥ expenses before cash < 0; `months_to_zero ≤ 6` ⇒ fatal-pinch row [11] |
| `studio <studio-ledger.csv>` | `STUDIO_PASS: x/y` | planned | utilisation ≥ 65 % (target 75; > 85 blocks new sales without hire); realisation ≥ 90 %; revenue per billable FTE ≥ 1.5× loaded cost; project margin ≥ 35 %; overrun ≤ 10 %; leakage ≤ 5 %; pipeline coverage ≥ 2×; backlog ≥ 40 % of quarter; bid win 40–60 %; concentration ≤ 20 % amber / 25 % red, top-3 ≤ 50 %; DSO ≤ 45; deposit ≥ 20 % before countersign; EBITDA ≥ 10 %; product time capped until product revenue > services revenue [12] |
| `funnel <deals.csv> [targets.tsv]` | `FUNNEL_VIOLATIONS: N` | planned | segment ∈ hypothesis (≥ 80 % pipeline in primary); motion vs ACV band; `proposal` needs `economic_buyer_named`+`metrics_agreed`+`decision_process_doc`, `commit` needs `paper_process_started`; empty/past `next_action_date` ⇒ downgrade; `last_activity > 21 d` flag, > 45 d ⇒ lost/no_decision; `close_date_slips ≥ 2` out of commit; coverage ≥ 1/win-rate × 1.2 (5× until 20 outcomes); win rate < 10 % on ≥ 20 ⇒ review; cycle > 2× band; pilot charter (`pilot_metric`, `pilot_end_date ≤ 8 wk`, price > 0; unpaid > 60 d red); contract tripwires block; cash-in alert at terms + 15 d [06] |
| `experiments <experiments.csv>` | `EXPERIMENT_VIOLATIONS: N` | planned | hypothesis "If we [change] for [ICP], [metric] moves from [baseline] to [target] because [assumption]" fields numeric; `required_n_per_arm` from baseline/MDE/power/α; `verdict ∈ WIN\|LOSE` only if `actual_n ≥ required_n` ∧ `elapsed_days ≥ min_duration (≥ 7)` else INCONCLUSIVE; `ice_confidence > 5 ⇒ ice_evidence_ref`; `budget_php ≤ cap` ∧ `approved_by` before running; `preregistered_at < started_at` [07, 01] |
| `assets <dir> <claims.tsv> <icp.yaml>` | `ASSET_LINT: N` | planned | placeholders `\[TBD\]\|lorem\|XX%\|\{\{\|INSERT\|TODO\|\?\?\?`; `icp_id` ∈ ICP; offer + price ref (or explicit on-request flag); landing `cta_count = 1`; numbers carry `[ev:C-n]` with `evidence_date`; superlatives (`best\|#1\|No\. ?1\|most preferred\|only\|fastest\|leading\|guaranteed`) need independent third-party evidence ≤ 12 months (ASC); comparatives name the comparator; case study 10 parts + `release_form_on_file`; pricing page currency/unit/inclusions/VAT note; email templates unsubscribe + `List-Unsubscribe` + `consent_source`; marketplace listing merchant disclosures (ITA) [07, 03] |
| `consent <consent.csv> <sends.csv>` | `CONSENT_VIOLATIONS: N` | planned | every send has `human_approved_by`; marketing sends join a live consent row for that channel (opt-in, no pre-ticked, not "continued use"); SMS/Viber explicit; withdrawn contacts never sent; template `word_count ≤ 100` (≤ 75 founder); batch ≤ cap; ≥ 3 follow-ups planned, ≤ 11 attempts [07, 06] |
| `sow <sow.md>` | `SOW_MISSING: N` | planned | sections: msa_reference, scope_in, deliverables (format), acceptance_criteria per deliverable, review_window_days (5) + deemed acceptance, assumptions_client_dependencies, out_of_scope (+ "requires a change order"), change_control_reference, milestones (id, deliverable, evidence, date), payment_schedule tied to milestone ids (never dates), deposit_pct ≥ 20, ip_ownership (assignment on payment + background-IP carve-out), warranty_days (≥ 30 software; ≥ 90 service/repair invoices), support_sla_reference or none, key_personnel, termination (cure, convenience), liability_cap; FAIL on "No Return, No Exchange" [08] |
| `delivery <dir>` (projects.csv, milestones.csv, change_orders.csv, time.csv) | `DELIVERY_VIOLATIONS: N` | planned | kickoff needs `signed_date` + `deposit_paid_date`; `invoice_date ≥ accepted_date` (or deemed after 5 BD); `hours_logged_before_approval = 0`; Σ approved CO > 25 % ⇒ rebaseline flag; on-time ≥ 75 %; overrun ≤ 10 %; realisation ≥ 90 %; write-off ≤ 5 %; RMA `days_to_resolve ≤ 30` [08] |
| `regulatory <regulatory.csv>` | `SHIP_BLOCKERS: N` | planned | `has_radio ⇒ ntc_status = approved ∧ ntc_model_name = marketed name`; `bps_mandatory ⇒ ps_icc_status = valid`; consumer warranty text ≥ 60 d; service invoice ≥ 90 d; lot AQL rows (critical 0 / major 2.5 / minor 4.0) accepted; forbidden "No Return, No Exchange" on any template [08] |
| `ar <ar_ledger.csv>` | `AR_VIOLATIONS: N` | planned | `paid_amount + ewt_amount + rail_fee = gross` (± ₱1) else `short`; every paid row with EWT has `form2307_received` by day 20 after quarter; every VAT invoice has `credit_term_days > 0`; invoice fields (amount, VAT line, both names + TINs, description, date); any sale ≥ ₱500 has an invoice number; aging: ≥ 80 % of open AR current/1–30 d, any > 90 d dispositioned; DSO ≤ 45 [10] |
| `compliance <register.csv> <profile.yaml>` | `COMPLIANCE: x/y` (applicable rows done on time / applicable rows) | planned | schema + `source_url` + `source_grade` per row; `applies_if` evaluated against profile (first hire, trailing > ₱3M, first online sale, foreign investor activate rows); evidence path exists + hash + `evidence_date ≤ deadline` else `overdue`; deadline engine T-30/T-7/T-0; `verified_on > 12 mo` ⇒ re-verify; consistency (VAT ⇒ 2550Q on/2551Q off; 8 % ⇒ 2551Q off; employees ⇒ SSS/PhilHealth/Pag-IBIG/13th/OSH; corp ⇒ SEC; > ₱3M ⇒ audit; online ⇒ ITA); `requires_professional_signoff` rows count done only with `signoff_path`; S-grade rows need notes [09] |
| `board <run-dir>` | `BOARD_PACK: OK\|STALE\|INCOMPLETE` | planned | Sequoia sections A–D derived from ledgers (narrative ≥ 3 highlights, ≥ 3 lowlights, ≤ 3 asks; KPI actual/plan/variance/trend with North Star + 3–5 inputs; cash + runway + DEFAULT_ALIVE; pipeline coverage + stale rows; milestones on-time; headcount vs plan waterfalls; risks top-5 with owner/trigger/review ≤ 30 d; proposed ADRs with owner + decide-by); any source ledger > 31 d old ⇒ STALE; pack ≥ 48 h before meeting [11] |
| `decisions <decisions.tsv> <risks.csv>` | `GOVERNANCE_VIOLATIONS: N` | planned | ADR ids monotonic never reused; `status ∈ proposed\|accepted\|deprecated\|superseded-by:id`; superseded rows retained; `money_or_legal_effect ⇒ signed artifact before accepted`; one-way doors ⇒ pre-mortem with ≥ 5 failure reasons linked to risk rows; risk rows owner + trigger + `next_review ≤ 30 d`; score ≥ 16 in pack [11] |
| `founders <founders-agreement.yaml>` | `FOUNDERS_AGREEMENT: VALID\|INVALID` | planned | split sums to 100; `vesting_years = 4` and `cliff_months = 12` (deviation needs an ADR ref); `ip_assigned_to_company = true`; roles; `decision_rights`; `departure_terms`; `signed_date` + `signed_pdf`; blocks the first external-money step [11] |

## Fixture convention (the frozen scorer's teeth)

Every gate ships with `tests/<domain>.test.sh <gate>` (filter arg; zero matched cases = fail) **and**
a good/bad fixture pair under `tests/fixtures/<gate>/`: the good fixture must come out clean, the
bad fixture carries a **planted defect** the gate must catch. A gate that cannot detect its own
planted defect does not count as wired.

## Goodhart guards

- **Ledgers, not prose.** No gate reads a narrative; every gate reads a TSV/CSV/YAML the loop cannot
  fabricate (human-entered) or must source (claims with locators, retrieval dates, archives, hashes).
- **Worst corner wins.** Economics assertions must hold at the worst corner; margins recorded maximin.
- **Pinned snapshots.** Sources carry retrieval dates and archive URLs; competitor prices carry
  capture dates and hashes; a model built on stale inputs is flagged by `board` staleness and the
  market gate's staleness rules.
- **Paired rows.** Every gate = dispatch ∧ fixture test ∧ good/bad execution in the frozen scorer.
- **Human sign-off rows** (sends, spend, contracts, filings, professional review, elections) are
  `fail` until a named human marks them; the loop's only move is to prepare the draft and surface
  the row.
- **Statute rows expire.** Compliance rows carry `verified_on`; older than 12 months ⇒ re-verify
  (this domain changed in 2018, 2021, 2024, 2025, 2026).
