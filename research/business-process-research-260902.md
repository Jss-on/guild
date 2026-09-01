# From Idea to Paying Customer: The Standard Business-Building Process — and the Gates a Harness Can Enforce

**Research dossier for the guild harness — 2026-09-02**
Method: 12 domain briefs (`research/raw/01–12`), ~560 sources read on 2026-09-02, every number
graded P1/P2/P3 with a URL and retrieval date; anything not fetched is marked UNVERIFIED. Founder
context: a Philippine engineering studio with build capability (forge = software, anvil = hardware),
permit in progress, no customer yet.

## TL;DR

- **Business-building is a gated, evidence-first process, not a plan.** Every school that survived
  contact with practice (Blank, Ries, Aulet, Dunford, Simon-Kucher, Skok, SPI, Sequoia) orders
  the work the same way: hypotheses → human conversations → measurable assumptions → offer and
  price validated by willingness to pay → a model that closes at the worst corner → a repeatable
  sales motion → operations that bill on acceptance → a board that reads ledgers. The harness's
  `/guild:build` phases (§2) are that order, each with a named deliverable and a mechanical gate.
- **More of it is mechanical than founders assume.** 27 gates (§4) read CSV/TSV/YAML ledgers and
  emit one line: unsourced claims, consent joins, interview quotas, ICP trace, TAM factor products
  and triangulation, phantom competitors, positioning slot integrity, price floors and tax
  consistency, unit-economics assertions at corners, 13-week cash, default-alive, funnel hygiene,
  experiment n/duration, asset lint, consent per send, SOW completeness, acceptance-before-invoice,
  regulatory ship-blockers, 2307 completeness, compliance deadlines, founders' agreement, board
  pack freshness. What stays human is explicit (§4, last column) and is the same list every time:
  send, spend, sign, file, elect, judge.
- **The Philippines changes the numbers, not the process.** EOPT (2024) moved VAT on services to
  accrual and replaced receipts with invoices; the ₱3M line drives VAT, the 8 % option, audit and
  BMBE at once; clients withhold 5–15 % and issue Form 2307; RA 12009 (2024) rewrote government
  buying; corporate transfer fees survived the July-2026 waivers; the buyer culture is
  relationship-first with 30–180-day terms and after-sales expectations. Every PH row carries a
  statute citation, an effective date and a `verified_on`, because this domain moved in 2018,
  2021, 2024, 2025 and 2026.
- **Several v0.0.1 assumptions were wrong and are corrected here:** services gross margin is not
  40–60 % (SPI project margin 35.9 %, EBITDA 9.8 %); pipeline coverage is 1 ÷ win-rate (≈ 5× at
  today's 19–21 % B2B win rate), not 3×; the 8 % tax option is individuals-only; "3–6 months
  reserve" has no published source (1–3 months fixed opex is the only anchor); Stripe is not
  available to PH entities; the July-2026 InstaPay/PESONet waivers are mostly individual-only.

## 1. What the research covered

| # | Brief | Sources | Anchors |
|---|---|---|---|
| 01 | Customer discovery & validation | 29 | Blank deck, Ries, Mom Test, YC, Strategyzer/Bland, Superhuman, NN/g, RA 10173, Guest et al. |
| 02 | Market sizing & competition | 49 | Aulet DE-24, Moore, Dunford, Porter, Kim & Mauborgne, Sequoia, Kawasaki, Cornell & Damodaran, PSA/DTI/BSP/SEIPI/IBPAP/DataReportal |
| 03 | Positioning, offer, packaging | 39 | Dunford, Moore, Strategyzer VPC, Mohammed G-B-B, Raskin, Sakas/Dunn (paid discovery), Derdenger & Kumar, US ITA PH guides, GPPB |
| 04 | Pricing | 44 | Simon-Kucher, Ramanujam, Sawtooth (VW/GG/CBC), Paddle/OpenView, Marn & Rosiello, BIR RMO 23-2018 / RR 11-2018 / RA 11976, SPI |
| 05 | Unit economics & modelling | 50 | Skok, a16z, Bessemer, Sacks, Feld, Gurley, SaaS Capital, ChartMogul, KeyBanc, SPI, Promethean, Bolt, Adafruit/Barros, FAST Standard, WSP, BSP, NWPC |
| 06 | GTM & B2B sales | 46 | Skok, Janz, a16z, Leslie & Holloway, YC (Kolysh, Blomfield, Koomen), Kazanjy, Bridge Group, Gong, Ebsta, Clari, HBR Challenger, RA 12009 + IRR, PhilGEPS, trade.gov |
| 07 | Marketing | 37 | DataReportal, Unbounce, Mailchimp, Woodpecker, LocaliQ, First Page Sage, Balfour, Ellis, Evan Miller, Binet & Field, ASC, RA 7394, RA 11967, NPC AO 2017-42, Gmail |
| 08 | Operations & delivery | 45 | SPI, Contract Nerds, Instrumental/Bolt/Fictiv, QIMA/InTouch (Z1.4), DTI-BPS, NTC MC 02-01-2001, RA 7394, DAO 2 s.1993, ITA IRR, PH couriers |
| 09 | PH legal, tax, compliance | 42 | lawphil statutes (RA 9178, 11232, 11976, 10963, 11534, 11032, 8792, 11647, 11967, 10173, 7394, 11199, 11223, 9679, 11058, 8293), DTI/SEC/SSS/PhilHealth pages, PwC/GT/Forvis/ACCRALAW/Baker McKenzie |
| 10 | Finance ops & payments | 61 | BSP fee table + Circular 1238 + FX FAQs, BIR EOPT flyer, RR 3-2024 / RMC 65-2024, PayMongo/Maya/PayPal/Wise/Stripe pages, WSP TWCF, HighRadius, SB Corp, DOST SETUP |
| 11 | Governance & board | 47 | PG default-alive, YC equity + SAFE, Sequoia board deck, re:Work OKRs, Amplitude North Star, McClure AARRR, Nygard ADR, Klein pre-mortem, Wasserman, FI FAST, RA 11337, NDC SVF, SB Corp, MAIN, IdeaSpace, QBO |
| 12 | Studio business model | 36 | SPI 2025 full report, Promethean, GSSN studio white paper, JPMC cash-buffer study, Sakas, Baker, Stark, 37signals/Basecamp, Mailchimp, thoughtbot, Pivotal, PH studios (Symph, Full Scale, Thinking Machines, Xurpas), JobStreet |

Access notes that matter for the harness: `psa.gov.ph`, `officialgazette.gov.ph`, `sec.gov.ph`,
`privacy.gov.ph`, `bir.gov.ph` (JS), `imf.org`, HBR full text and several vendor pages block
scripted fetches (403 / CAPTCHA). Statutes were read on lawphil.net or WIPO Lex; PSA/IMF via
Wayback snapshots. Consequence: the evidence protocol requires an archived URL + content hash per
source and rejects CAPTCHA pages as sources.

## 2. The process map — `/guild:build` phases, deliverables, gates

| Phase | What happens | Named deliverables (ledgers / docs) | Mechanical gate(s) | Human sign-off rows | Irreversibles fixed here | Briefs |
|---|---|---|---|---|---|---|
| **P0 Doctor + charter** | Founder interview (≤ 4 questions/round): thesis, capabilities (forge/anvil), constraints, cash, geography; write the charter with the early irreversibles as *decisions with decide-by dates*, not defaults | `charter.md`, `board/founders-agreement.yaml`, `board/kill-criteria.csv`, `compliance/profile.yaml` | `founders`, `validate` (later) | equity split, entity type, decision rights | founders' agreement + IP assignment; entity/tax posture; fiscal year; brand name/domain | 11, 09, 10 |
| **P1 Evidence setup** | Source registry + claims ledger (forge research schema); every number from here on cites `[C-n]` | `evidence/sources.tsv`, `evidence/claims.tsv` | `sources`, `claims`, `citations` | none | — | 01, 02 |
| **P2 Discovery** | Hypotheses typed D/F/V/A → assumption map (riskiest first) → segment + market-type hypotheses → drafted interview scripts + consent forms (RA 10173) → **humans run the interviews** and enter the ledger → synthesis (codes, job stories, saturation) → Blank discovery-exit memo → commitments | `discovery/assumptions.csv`, `discovery/segments.csv`, `drafts/interview-script.md`, `discovery/consent.tsv`, `discovery/interviews.tsv`, `discovery/codes.csv`, `discovery/commitments.csv`, `discovery/exit-memo.md` | `interviews`, `icp` | every interview row; consent; segment election; assumption scores | segment election (narrow → widen only); market type; consent scope; contaminated pool | 01 |
| **P3 Market** | Sizing charter (unit + frame — PH LE vs ASPBI differ 4.4×) → beachhead scoring (Aulet 7 criteria) → bottom-up TAM with top-down cross-check, triangulation ≤ 3× → alternatives incl. status quo → dated hashed price snapshots → five forces + why-now → source refresh cadence | `market/charter.csv`, `market/segments.csv`, `market/factors.csv`, `market/claims.csv`, `market/alternatives.csv`, `market/snapshots.csv`, `market/five-forces.csv`, `market/why-now.csv` | `market`, `competitors` | beachhead choice; counting unit; adoption assumptions; attractiveness verdict | counting unit/frame; beachhead; category frame; geography claimed | 02 |
| **P4 VRS** | Every assumption becomes a `V-n` row: statement, metric, threshold, test method on the ladder (paid pilot > LOI > pre-order > interview > survey > desk), owner, decide-by; venture spec generated and validated | `vrs/requirements.md`, `venture.spec.yaml` | `vrs`, `validate`, `coverage` | riskiest-assumption ranking | — | 01, 03 |
| **P5 Positioning + offer** | Dunford: alternatives → unique attributes → value themes with proof → ICP + anti-ICP (four forces, beachhead criteria, decision-maker role, procurement mode) → category decision (new category = opt-in with budget) → Moore statement (linted) → messaging pillars → offer ladder (paid discovery first; G-B-B with fences; mixed bundling; capped guarantee; PH tax note) → narrative + one-pager → pitch-test ledger | `offer/alternatives.csv`, `offer/attributes.csv`, `offer/value_themes.csv`, `offer/icp.yaml`, `offer/anti_icp.yaml`, `offer/category.md`, `offer/positioning.yaml`, `offer/messaging.yaml`, `offer/offers.yaml`, `offer/narrative.md`, `offer/one-pager.md`, `offer/pitch_tests.csv` | `positioning`, `offers`, `assets` (one-pager) | category style; "compelling reason to buy"; pitch tests | category; paid-vs-free discovery precedent; published anchors; guarantee terms; naming | 03 |
| **P6 Pricing** | WTP conversations (≥ 10/segment) → cost floor at realistic utilisation → competitor band → (quant research only for public list prices) → price metric + model → tiers/anchors → tax treatment per line (VAT/8 %/CWT/zero-rating) → discount + increase policy | `pricing/wtp-interviews.csv`, `pricing/cost-floor.csv`, `pricing/competitor-band.csv`, `pricing/price-book.csv`, `pricing/tax-status.csv`, `pricing/discount-policy.md`, `pricing/price-change-log.csv` | `pricing` | WTP interviews; VAT/8 % election; skim vs penetrate; every quote | price metric; first public list price; tax posture; T&C indexation; discount precedents; channel/MAP | 04 |
| **P7 Economics + cash** | Metric dictionary → driver register (evidence classes; anvil `PRODUCT_COST` / forge cost as COGS) → unit-economics sheet → monthly driver-based model → base/worst/best corners + ±20 % sensitivity → 13-week direct-method cash with weekly variance → default-alive → benchmark verdict; studio KPI ledger | `economics/metric-dictionary.csv`, `economics/model.csv`, `economics/assertions.tsv`, `economics/cash13.csv`, `economics/variance.csv`, `economics/studio-ledger.csv` | `economics`, `cash`, `alive`, `studio` | actuals; segment for payback limit; profit definition | business model choice; hardware channel; MOQ/tooling; price floor; fixed-cost base/hiring | 05, 12, 10 |
| **P8 GTM + marketing** | Sales hypothesis → motion by ACV → founder-led ladder (warm → manual → tooling) → materials → lead list from ICP → MEDDPICC stage exits → paid pilots with fixed metric → proposals with tiers → paper-process tripwires → pipeline ledger + weekly review; STP/7Ps → ≤ 3 channels with hypotheses and PH reach data → assets vs checklist → content clusters → tracking → experiments (n + duration) → consent + spend ledgers → compliance review per publish (ASC / RA 7394 / ITA / DPA) | `gtm/hypothesis.md`, `gtm/plan.md`, `gtm/playbook.md`, `gtm/leads.csv`, `gtm/outreach.csv`, `gtm/pipeline.tsv`, `marketing/plan.md`, `marketing/channel-plan.csv`, `marketing/assets.csv` + files, `marketing/calendar.csv`, `marketing/experiments.csv`, `marketing/consent.csv`, `marketing/spend.csv` | `funnel`, `paying`, `experiments`, `assets`, `consent` | **every send, call, quote, pilot commitment, bid, spend, publish** | segment; motion + first sales hire; price anchor; pilot scope; contract clauses; government track; channel appointments; brand/domain; sending domain; consent design | 06, 07 |
| **P9 Operations + finance** | MSA/SOW templates (payments on milestone ids, deemed acceptance, change control, IP, warranty floors, SLA) → delivery ledgers → hardware NPI/EMS/regulatory register → finance policy triad → books/ORUS → invoicing (EOPT) → rails chosen on corporate fee schedules → 2307 workflow → substantiation → AR aging/dunning → dashboard | `ops/msa.md`, `ops/sow-template.md`, `ops/projects.csv`, `ops/milestones.csv`, `ops/change_orders.csv`, `ops/time.csv`, `ops/regulatory.csv`, `ops/lots.csv`, `ops/rma.csv`, `finance/policy.md`, `finance/ar_ledger.csv`, `finance/wtax_2307_ledger.csv`, `finance/rail_fees.csv` | `sow`, `delivery`, `regulatory`, `ar` | signing, acceptance, POs/tooling deposits, shipping, refunds, filings, payments | IP terms in first MSA; engagement model; radio architecture; hard tooling; MOQ; warranty text; fiscal year/basis/books; banks; invoice series | 08, 10 |
| **P10 Compliance** | Register generated from `profile.yaml` via `applies_if`; deadline engine; evidence + hash per row; professional sign-off rows | `compliance/register.csv` | `compliance` | every filing, election, professional review | entity type; voluntary VAT lock-in; 8 % election; TIN; books method; employment contracts | 09 |
| **P11 Launch → first paying customer** | Humans execute outreach/pilots/proposals from drafts; the loop keeps the pipeline honest; `FIRST_CUSTOMER` = won + invoice + payment evidence | `gtm/pipeline.tsv` (human), `finance/ar_ledger.csv` | `verdict`, `paying`, `funnel`, `ar` | all of it | first anchor client (> 25 % concentration); reference customers; payment-terms precedent | 06, 12 |
| **P12 Board** | Every 6–12 weeks: pack derived from ledgers (KPI vs plan, cash/runway/DEFAULT_ALIVE, coverage, delivery, headcount waterfalls, risks, ADRs due) → decisions → kill/pivot rows → `CONTINUE \| PIVOT \| KILL` | `board/pack-YYYY-MM.md`, `board/kpi_actuals.csv`, `board/decisions.tsv`, `board/risks.csv`, `board/okrs/…` | `board`, `decisions`, `alive` | pivot judgement; closed session; hiring; funding instruments | North Star choice; board composition; first SAFE cap; advisor grants; hiring ahead of default-alive | 11 |

## 3. Design principles the research confirmed or changed

1. **Evidence is the electrical gate.** Fabricated or unsourced numbers are the business analogue
   of a shorted net. Adopt forge's research ledger schema wholesale (sources.tsv 9 cols, claims.tsv
   6 cols, tiers, confidence floors); add archive URL + hash + CAPTCHA rejection (02); add a
   consented, pseudonymous interview ledger (01).
2. **Say ≠ do.** Only past behaviour and commitments (time, reputation, money) count as evidence;
   compliments and "would you buy?" are excluded by column constraints (01). The validation ladder
   orders test methods by evidence strength, and the riskiest assumptions need a `do`-class test.
3. **Elect early, narrow, and record it.** Segment + market type (01), counting unit + frame (02),
   category (03), price metric (04), business model (05), entity/tax posture (09/10) and the
   founders' agreement (11) are charter rows with decide-by dates; the harness never defaults them.
4. **Corners, not base cases.** Every economic assertion holds at the worst corner; hardware
   models carry landed cost (BOM ÷ (1 − scrap) + assembly + freight + warranty reserve) and the
   first-PO cash test; services models use SPI floors (utilisation 70 %, project margin 35 %,
   overrun 10 %, leakage 5 %), not the 40–60 % margin folklore (05, 12).
5. **Cash is a weekly ledger.** 13-week direct-method forecast with variance, cash-buffer days
   (median 27, alarm 13), default-alive from month ~6–9, corporate rail fees priced in (05, 10, 11).
6. **Sales is a learning curve, not a headcount.** Founder-led to ~30 customers; no seller before
   ≥ 10 paid customers and two quarters within band; coverage = 1 ÷ win-rate; deals without a dated
   next step are downgraded; pilots are paid, short and metric-fixed (06).
7. **Every send is a signature.** Outreach, publishes, spend, bids, contracts, filings, elections
   and professional reviews are human sign-off rows; the loop drafts and lints (all briefs).
8. **Statutes have dates.** PH rows carry effective dates and `verified_on`; rows older than 12
   months are re-verified; UNVERIFIED rows cannot be marked done without a human note (09, 10).
9. **Templates encode the law.** Invoice templates print the credit term (output-VAT credit),
   quotes show VAT as a separate line and state "subject to EWT", SOWs tie payments to milestone
   ids and carry warranty floors, consumer templates never say "No Return, No Exchange" (04, 08, 10).
10. **Board packs are generated.** Sequoia's structure maps onto ledgers; staleness > 31 days fails
    the pack; kill/pivot rows are pre-committed numbers (11).

## 4. Gate registry (the `score-guild.sh` surface the loop must implement)

Full check lists, inputs and output grammar are the contract in `references/metrics.md`; this table
is the map from research to gate.

| Gate | Emits | Planted defect the bad fixture must expose | Brief |
|---|---|---|---|
| `sources` | `SOURCES: VALID\|INVALID` | a row with an unresolvable locator / `unverified` status cited elsewhere | 01, 02 |
| `claims` | `CLAIMS: VALID\|INVALID` | a `high` claim resting on one T3 source; an orphan `S-` id | 02 |
| `citations` | `UNSOURCED_CLAIMS: N` | a percentage in a market doc with no `[C-n]` | 02, 07 |
| `interviews` | `INTERVIEW_VIOLATIONS: N` | an interview row with no consent join; SPI collected without explicit consent; pitch revealed in interview 2 | 01 |
| `icp` | `ICP_VIOLATIONS: N` | an ICP leaf with two interview ids; empty `anxiety` force; missing `decision_maker_role` | 03, 01 |
| `vrs` | `VRS_MEASURABLE: x/y` | a `V-n` with an adjective instead of a threshold; a riskiest assumption tested by desk research only | 01, 03 |
| `market` | `MARKET_VIOLATIONS: N` | factor product ≠ stated claim; SOM > SAM; a bottom-up unit count from Statista (P3); a live URL with no archive | 02 |
| `competitors` | `COMPETITOR_VIOLATIONS: N` | no status-quo row; an alternative with zero interview ids (phantom); a 120-day-old snapshot without hash | 02, 03 |
| `positioning` | `POSITIONING_VIOLATIONS: N` | `primary_alternative` not in the alternatives ledger; "simple and affordable" as differentiator; 90-word statement | 03 |
| `offers` | `OFFER_VIOLATIONS: N` | two discovery offers or none; Good priced above Better; guarantee without cap; missing tax note | 03 |
| `pricing` | `PRICE_VIOLATIONS: N` | list below floor/(1−GM); floor 120 days old; `eight_pct_elected` while VAT-registered; a new offer with 4 WTP rows | 04 |
| `economics` | `ECON_PASS: x/y` | worst-corner GM below floor; LTV/CAC < 1 at worst; a benchmark driver without `source_id` | 05 |
| `cash` | `CASH_PASS: x/y` | a week whose closing cash < floor; receipts variance 30 %; forecast 20 days stale | 05, 10 |
| `alive` | `DEFAULT_ALIVE: 1\|0` | flat revenue, burn exceeds cash within 6 months | 11 |
| `studio` | `STUDIO_PASS: x/y` | utilisation 55 %; one client at 40 % of revenue; DSO 75; deposit 10 % | 12 |
| `funnel` | `FUNNEL_VIOLATIONS: N` | a `commit` deal with no next-action date; a deal in `proposal` without an economic buyer; three slips still in commit; a 70-day unpaid pilot | 06 |
| `paying` | `PAYING_CUSTOMERS: N` | a `won` row with invoice but no `evidence:` payment | 06 |
| `experiments` | `EXPERIMENT_VIOLATIONS: N` | `verdict = WIN` with `actual_n < required_n`; `ice_confidence 8` with no evidence ref; running with no `approved_by` | 07 |
| `assets` | `ASSET_LINT: N` | "[TBD]" in a one-pager; landing page with two CTAs; "#1 in the Philippines" without third-party evidence; "40 % faster" without `[ev:]` | 07, 03 |
| `consent` | `CONSENT_VIOLATIONS: N` | a marketing email sent to a contact with no opt-in row; a send without `human_approved_by` | 07, 06 |
| `sow` | `SOW_MISSING: N` | payment schedule tied to dates; no review window; "No Return, No Exchange"; warranty 14 days | 08 |
| `delivery` | `DELIVERY_VIOLATIONS: N` | kickoff before deposit; invoice dated before acceptance; 12 hours logged on an unapproved change order | 08 |
| `regulatory` | `SHIP_BLOCKERS: N` | a WiFi product shipping with `ntc_status = pending`; a marketed model name different from the certificate | 08 |
| `ar` | `AR_VIOLATIONS: N` | a VAT invoice without a credit term; a paid row with EWT and no 2307 after day 20; paid + EWT ≠ gross flagged as paid | 10 |
| `compliance` | `COMPLIANCE: x/y` | a 2550Q row past deadline without evidence; a VAT-registered profile with a 2551Q row active; a sign-off row marked done without `signoff_path` | 09 |
| `board` | `BOARD_PACK: OK\|STALE\|INCOMPLETE` | a pack whose pipeline ledger is 45 days old; missing risks section | 11 |
| `decisions` | `GOVERNANCE_VIOLATIONS: N` | a reused ADR number; a money/legal ADR accepted with no signed artifact; a one-way door without a pre-mortem; a risk with no owner | 11 |
| `founders` | `FOUNDERS_AGREEMENT: VALID\|INVALID` | split sums to 90; no cliff; IP not assigned; unsigned | 11 |

## 5. Ledger registry (who writes; what columns)

| Ledger | Writer | Columns (abbreviated; full in the briefs) | Brief |
|---|---|---|---|
| `evidence/sources.tsv` | loop | `id tier type year title venue locator depth status` + `retrieved_at archived_url content_hash fetch_status cadence` | 02 |
| `evidence/claims.tsv` | loop | `id rq claim confidence sources evidence` | forge |
| `discovery/assumptions.csv` | loop (scores human) | `id statement type importance evidence risk experiment_ids status owner scored_by scored_at` | 01 |
| `discovery/consent.tsv` | human | `participant_id date consent_version recording quotes_allowed spi_collected spi_explicit_consent incentive_given_at_start withdrawal_date deletion_due` | 01 |
| `discovery/interviews.tsv` | human | `interview_id date segment_id role org_type org_size channel language interviewer consent_id recorded solution_revealed top_pains last_occurrence_date past_behavior workaround current_spend_php current_spend_time wtp_signal verbatim_quote commitment_type commitment_detail next_step_date new_codes_count snapshot_link` | 01 |
| `discovery/experiments.csv` | loop (spend approved human) | `exp_id assumption_id type evidence_kind setting cost_php setup_days run_days metric pass_criterion preregistered_at started_at n result verdict learning spend_approved_by` | 01 |
| `discovery/commitments.csv` | human | `customer_id segment_id type amount_php date doc_link signed_by_human` | 01 |
| `discovery/segments.csv` | loop (election human) | `segment_id icp_firmographics persona_role job_story market_type interviews_n evidence_grade_n commitments_money_n elected elected_at elected_by board_ack` | 01, 02 |
| `market/factors.csv` | loop | `claim_id layer segment_id method factor value unit currency source_id source_reference_period source_publication_date retrieved_at archived_url grade note` | 02 |
| `market/alternatives.csv` / `snapshots.csv` | loop (quotes human) | `alt_id name type url why_customer_uses_it evidence_interview_ids` / `snapshot_id alt_id plan_name list_price currency billing_period price_metric included_limits discount_terms source_url archived_url captured_at captured_by screenshot_hash` | 02, 03 |
| `offer/icp.yaml` | loop | firmographics, roles (economic_buyer, champion, decision_maker_role, relationship_owner), technographics, pains, triggers {push,pull,anxiety,habit}, buying_process {procurement_mode, payment_terms_expected, withholding_class}, beachhead_criteria; every leaf `evidence_interview_ids[]` | 03 |
| `offer/positioning.yaml` | loop | six Moore slots + canvas fields, referential ids | 03 |
| `offer/offers.yaml` | loop | `name tier price_php price_basis scope_in scope_out fence_attributes deliverables duration_days prepay_pct payment_terms_days guarantee{trigger,remedy,cap_pct} credit_to_next{amount,deadline_days} whole_product{…} tax_note` | 03 |
| `offer/pitch_tests.csv` | human | `conversation_id date icp_match positioning_version confusion_flag alternative_named_by_buyer next_step_agreed next_step_type` | 03 |
| `pricing/price-book.csv` | loop | `offer_id tier price_metric list_price_exvat currency vat_treatment display cost_floor_exvat floor_method floor_date target_gm_pct cwt_rate_expected competitor_low competitor_high competitor_n competitor_capture_date wtp_n wtp_pmc wtp_opp wtp_ipp wtp_pme research_method justification_ref max_discount_pct discount_authority grandfather_until effective_from approver` | 04 |
| `pricing/tax-status.csv` | human | `entity_type vat_registered eight_pct_elected trailing_12m_gross_sales cor_date` | 04 |
| `economics/model.csv` | loop | `driver_id name unit segment base worst best evidence source_id measured_from owner last_verified` | 05 |
| `economics/cash13.csv` / `variance.csv` | loop (actuals human) | `week_start opening_cash rcpt_ar rcpt_new_sales rcpt_other disb_payroll disb_rent_overhead disb_vendors_components disb_taxes disb_debt_service disb_capex net_flow closing_cash min_cash_floor actual_closing variance` | 10, 05 |
| `economics/studio-ledger.csv` | human + loop | `period person_id hours_available hours_billable hours_billed project_id client_id model list_rate revenue_recognized invoice_id invoice_date paid_date direct_labor_cost subcontractor_cost passthru_cost fully_loaded_cost_per_fte change_order_id scope_delta_value deposit_received cash_balance avg_daily_outflow_30d pipeline_weighted_value forecast_next_q backlog_value bid_id bid_won` | 12 |
| `gtm/pipeline.tsv` (`deals.csv`) | human | `deal_id account segment source_channel stage stage_entered_at days_in_stage amount_acv amount_tcv currency forecast_category probability owner next_action next_action_date last_activity_at expected_close_date close_date_slips champion_named economic_buyer_named metrics_agreed decision_criteria_doc decision_process_doc paper_process_started pain_statement competition pilot_metric pilot_end_date proposal_path payment_terms_days withholding_pct po_number contract_signed_at invoice_date paid_date outcome loss_reason loss_note` (+ the 10-col verdict view `id segment account stage value currency next_action updated invoice payment`) | 06 |
| `gtm/outreach.csv` | human-approved | `send_id sequence_id template_id word_count contact_id channel sent_at delivered replied reply_sentiment meeting_booked meeting_held opp_created human_approved_by human_approved_at` | 06 |
| `marketing/experiments.csv` | loop (spend human) | `id opened owner funnel_stage channel hypothesis primary_metric baseline target_threshold mde_rel alpha power required_n_per_arm min_duration_days ice_impact ice_confidence ice_evidence_ref ice_ease rice_reach rice_effort_pm budget_php approved_by status actual_n elapsed_days observed ci_or_p verdict learning next_action` | 07 |
| `marketing/assets.csv` / `calendar.csv` / `consent.csv` / `spend.csv` | loop / human-approved | see brief 07 §5 | 07 |
| `ops/projects.csv` / `milestones.csv` / `change_orders.csv` / `time.csv` / `ops_monthly.csv` / `lots.csv` / `rma.csv` / `regulatory.csv` | human facts, loop lint | see brief 08 §5 | 08 |
| `finance/ar_ledger.csv` | human | `invoice_no invoice_date client_id client_name client_tin line_type amount_ex_vat vat_amount gross credit_term_days due_date ewt_rate ewt_amount expected_cash paid_date paid_amount rail rail_fee form2307_received form2307_quarter status demand_letter_date` | 10 |
| `compliance/register.csv` | human docs, loop rows | `id obligation category applies_if agency cadence deadline_rule evidence_type evidence_path evidence_date evidence_hash status owner requires_professional_signoff signoff_path source_url source_grade verified_on notes` | 09 |
| `board/founders-agreement.yaml` / `decisions.tsv` / `risks.csv` / `kpi-tree.yaml` / `kill-criteria.csv` / `okrs/*.yaml` | human + loop | see brief 11 §5 | 11 |

## 6. Early-irreversibles register (charter rows; each needs a decide-by date and an owner)

| # | Decision | Why it is one-way | Brief |
|---|---|---|---|
| 1 | Founders' equity split, vesting (4y/1y cliff), roles, decision rights, IP assignment to the company | unwinding needs buy-backs or litigation; IP retrofits need every contributor | 11, 09 |
| 2 | Entity type (sole prop / OPC / corp) and fiscal year | sole prop → corp = new SEC/BIR/permits/invoices; FY change needs BIR approval | 09, 10 |
| 3 | Tax posture: VAT vs non-VAT (voluntary = 3-year lock), 8 % (individuals only, elected Q1, irrevocable per year), books method (manual/loose-leaf/CAS), invoice series with printed credit term | quotes, CWT bracket and cash floor all follow | 04, 09, 10 |
| 4 | Segment / ICP election and market-type hypothesis | everything downstream derives; a segment pivot restarts discovery; new market = 5+ year cash horizon | 01, 02, 03 |
| 5 | Counting unit + statistical frame for sizing; geography claimed | base moves 4.4× between PH frames; invalidates all TAM factors | 02 |
| 6 | Category / frame of reference (and whether to attempt a new category) | rewrites positioning, canvas axes, price anchors, SEO pillars | 03, 07 |
| 7 | Price metric, first public list price, discount precedents, T&C indexation, grandfathering | anchors customers and competitors; penetration prices rarely recover | 04 |
| 8 | Business model mix (project / retainer / product / hardware) and hardware channel | margin band and cash profile; physical retail loses money at first-run scale | 05, 12 |
| 9 | Paid-vs-free discovery precedent; guarantee terms; first-deal payment terms and EWT class | sets the relationship precedent; open-account terms lengthen, never shorten | 03, 06 |
| 10 | Sales motion and first non-founder seller; pilot scope; government track (PhilGEPS, securities, blacklisting exposure) | cash burn; one failed government delivery locks out all PEs | 06 |
| 11 | Brand name, domain, handles, trademark class, sending subdomain, consent capture design, UTM taxonomy | assets, ASC clearances, SEO history, deliverability, retroactive consent impossible | 07, 09 |
| 12 | Hardware: IP/tooling ownership in first contracts, radio architecture (module vs custom RF; certificate model name), hard tooling at DVT, EMS/MOQ commitment, BPS-mandatory design-to-PNS, warranty text on packaging | sunk cost, certificates, statutory floors | 08, 05 |
| 13 | IP terms in the first MSA (assignment on payment; background IP) | re-negotiation = client-relationship event; §178.4 default keeps copyright with the creator | 08, 09 |
| 14 | Bank(s) and payment-rail entity type; where USD sits | corporate fee schedules differ; Wise caps by account type; conversion fees sunk | 10 |
| 15 | North Star metric; board composition; first SAFE cap; advisor grants; hiring ahead of default-alive | KPI tree/OKRs rebuild; control; permanent dilution; payroll is the least reversible expense | 11 |
| 16 | First anchor client above 25 % of revenue; first reference customers | team sized to one client; references define the segment story | 12, 06 |

## 7. Numbers annex

Moved to `.claude/skills/guild/references/benchmarks.md` (10 sections, every row with grade,
source and retrieval date; policy thresholds tagged). The rows the gates lean on hardest:

- Services: utilisation 68.9 % (floor 70, optimal 75), project margin 35.9 %, EBITDA 9.8 %,
  overrun 11.3 % (> 10 % concern), leakage 5.3 %, DSO 43.3, pipeline ≥ 2×, backlog 42.8 %,
  bids won 47.3 %, cash-buffer days 27 (13 / 62 quartiles), deposits 20–50 %.
- Recurring: LTV:CAC ≥ 3, payback ≤ 12/18/24 by segment (median 16), GM 65–70 % private cloud,
  net revenue churn ≤ 2 %/mo, burn multiple ≤ 2, runway 12/18/24.
- Hardware: ≥ 50 % direct GM or the price is too low; e-tail 15–20 %, retail 30–50 %; MOQ ~5k
  with 50 % deposit; certification ≥ $15k; scrap 5 % → 0.5 %; EVT ≤ 20 units; MP yield ≈ 98 %.
- Sales: win rate 19–21 %, coverage = 1 ÷ win-rate, 344 cold emails per meeting, ≤ 75-word
  founder emails with 3–4 follow-ups, paid pilots $10–20k ≤ 8 weeks, founder-led to ~30 customers.
- Discovery: saturation at ~12 interviews per homogeneous segment; PMF ≥ 40 % "very disappointed"
  on engaged users, n ≥ 30 (policy); ≥ 1 interview/week.
- PH statute: VAT 12 % / ₱3M; invoice ≥ ₱500 with VAT line and credit term; CWT 5/10 % or
  10/15 % + Form 2307 by the 20th; SSS 15 %, PhilHealth 5 %, Pag-IBIG ₱200; 13th month by
  24 Dec; audit at ₱3M (two tests); RA 12009 award ≤ 60 days, LD 0.1 %/day; NCR wage ₱755/₱780
  (enjoined); BSP RRP 4.75–5.00 %, inflation forecast 6.4 % (2026).

## 8. Philippine compliance register — seed rows (from briefs 09, 10, 04; verify with a CPA / lawyer)

| Obligation | Applies if | Agency | Cadence / deadline | Evidence | Source |
|---|---|---|---|---|---|
| DTI business-name registration (sole prop) | `entity_type = sole_prop` | DTI BNRS | once; valid 5 yrs | BN certificate | bnrs.dti.gov.ph |
| SEC incorporation (OPC/corp) | `entity_type ∈ {opc, corp}` | SEC eSPARC | once | Certificate of Incorporation, AOI, by-laws | esparc.sec.gov.ph |
| GIS after election; annual GIS + AFS | corp | SEC | 30 d after election / annual | GIS, AFS (audited if assets or liabilities > ₱3M, MC 4 s.2026) | RCC; SEC MC 4 s.2026 |
| BMBE Certificate of Authority (optional) | `total_assets ≤ 3,000,000` | DTI Negosyo Center | 2 yrs | BMBE CA | RA 9178; RA 10644 |
| Barangay clearance + Mayor's/Business Permit (+ FSIC, sanitary, zoning) | all | LGU BOSS | before operating; renew by 20 Jan | permit, receipts | RA 11032; LGC (verbatim UNVERIFIED) |
| BIR registration (COR 2303), books, ATP, invoices | all | BIR RDO / ORUS | before first sale; books yearly (loose-leaf FYE+15 d, CAS FYE+30 d) | 2303, ORUS ack, ATP, invoice stock | Sec. 236(A); RMC 3-2023 |
| Invoice ≥ ₱500 with VAT line + credit term | all | BIR | per sale | invoice series | EOPT; RR 7-2024; RMC 65-2024 |
| 2550Q (VAT) / 2551Q (3 %) | `vat_registered` / non-VAT not on 8 % | BIR | 25 d after quarter | filed return | Sec. 114 / 128 |
| 1701Q / 1701 (individual) · 1702Q / 1702 (corp) | by entity | BIR | 15 May/Aug/Nov + 15 Apr · 60 d after quarter + 15 Apr | filed return + 2307 credits (SAWT) | Secs. 51, 52, 74, 75 |
| 0619-E monthly, 1601-EQ quarterly, 1604-E annual; 2307 to payees by the 20th after quarter | pays any contractor/supplier subject to EWT | BIR | 10th / month-end after quarter / 1 Mar | returns, 2307s | Sec. 58; RR 11-2018 |
| Payee sworn declaration to each client | individual ≤ ₱3M or corp ≤ ₱720k wanting the lower rate | client | by 15 Jan | copy sent | RR 11-2018 / 14-2018 |
| Audited FS | gross sales > ₱3M (Sec. 232) or assets/liabilities > ₱3M (SEC) | BIR / SEC | annual | audit report | TRAIN; SEC MC 4 s.2026 |
| SSS / PhilHealth / Pag-IBIG employer registration + monthly remittance; DOLE registration (Rule 1020 UNVERIFIED); OSH program; 13th month by 24 Dec | `has_employees` | SSS / PhilHealth / Pag-IBIG / DOLE | report hires within 30 d; monthly | remittance confirmations, payroll register | RA 11199, 11223, 9679, 11058, PD 851 |
| Contractor classification review (control test) | any independent contractor | — | at engagement | signed contract + autonomy evidence | Sonza v. ABS-CBN |
| Privacy notice, consent records, DPO; NPC registration if thresholds hit | any personal data | NPC | continuous | notice, consent logs | RA 10173; NPC Circular 2022-04 (UNVERIFIED) |
| Online-merchant disclosures + Online Business Database | `sells_online` | DTI E-Commerce Bureau | when live | ECB registration, published policies | RA 11967; JAO 24-03 |
| Consumer warranty text (60 d–1 yr), no "No Return, No Exchange", service invoices ≥ 90 d guaranty | sells consumer products / repairs | DTI | per sale | templates | RA 7394; DAO 2 s.1993 |
| NTC type approval / BPS PS-ICC | radio products / BPS-mandatory list | NTC / DTI-BPS | before sale | certificates per marketed model | MC 02-01-2001; bps.dti.gov.ph |
| IP assignment clauses in every SOW/employment contract; trademark filing + DAU | all / brand | — / IPOPHL | per contract; DAU within 3 yrs | signed clauses; filing receipts | RA 8293 §§178.4, 180, 124.2 |
| PhilGEPS Platinum (if selling to government) | `procurement_mode ∈ philgeps_*` | PS-PhilGEPS | annual | certificate, GIS with beneficial ownership | RA 12009 §52; IRR 20 |
| Foreign-equity capitalisation | `foreign_equity > 0` | SEC/BOI | at formation | proof of paid-in ≥ US$200k/100k | RA 11647 |

## 9. Per-domain digests (what each brief adds beyond the map above)

**01 Discovery.** Blank's exit criteria are the phase gates and carry no interview counts; the
only sourced volume floors are saturation (12 / 6-for-80 %) and I-Corps (100). Evidence strength
(actual behaviour > stated intent > opinion) is enforced by columns. Superhuman's 40 % works only on
engaged users, per segment. RA 10173 makes age/marital/health/education *sensitive* — screeners
need explicit consent. Filipino social-desirability bias is measurable (Cagasan 2016) — weight
behaviour, never praise. Segment election is the first irreversible: narrow, then widen.

**02 Market.** Fix the counting unit and frame before any number (PH LE 1.24M establishments vs
ASPBI 281,825). Bottom-up is primary; triangulate ≥ 2 methods within 3× (policy). Status quo /
do-nothing rows are mandatory (20–30 % of enterprise deals end in no decision). Same-named PH
metrics differ by definition (electronics exports $42.75B SEIPI vs $39.1B PSA). ASPBI lags ~22
months; CPBI every ~5–6 years; PSA blocks scripts — archive + hash every source.

**03 Positioning & offer.** Dunford's ordered method with phantom-competitor and pre-PMF cautions;
90 % of recent tech IPOs positioned in existing markets (new category is opt-in with a budget).
Every positioning artifact is linted by referential integrity to the alternatives / ICP / attribute
ledgers. First offer = paid discovery (5–10 % of project value; free proposals are worthless).
PH: clients withhold EWT and issue 2307 — invoices must say ex-VAT / subject to EWT; trust ladder
L/C → open account; after-sales beyond warranty expected; PhilGEPS tenders are LCRB or MEARB — TCO
positioning does not win LCRB.

**04 Pricing.** Price before product (≥ 10 WTP conversations per segment). Cost floor at ≤ 75 %
utilisation. Competitor band of ≥ 3 dated, hashed captures. Quant research only for public list
prices, with sample floors. VAT on services is accrual (EOPT); B2B quotes ex-VAT with the VAT
line separate; the ₱3M threshold flips VAT + graduated rates from the breach date; the 8 % option
is individuals-only and non-VAT-only; CWT 5/10 % (individuals, ₱3M test) or 10/15 % (corps,
₱720k test) is a cash-flow effect, not a cost. Increases > 2 % need a stated reason; companies
realise < 50 % of attempted increases.

**05 Economics.** Driver register with evidence classes and FAST discipline; assertions at
corners (UE/HW/SV/ALL/PH series). LTV on contribution, capped at 24 months; paid CAC over blended;
burn multiple once ARR > 0; default-alive from month ~8; 13-week cash reconciled weekly. Hardware:
Bolt's cost stack (33 % first-run margin; retail loses money), MOQ/deposit/tooling/certification as
cash gates. Services: SPI floors. PH macro: RRP 4.75 → 5.00 %, inflation 6.4 % forecast, NCR wage
order enjoined — model both floors; CIT 20/25 %; on-costs SSS 15 %, PhilHealth 5 %, Pag-IBIG ₱200.

**06 GTM & sales.** Motion follows ACV; adding sellers before repeatability burns cash (Leslie &
Holloway, a16z). Founder-led shape: 1–3 warm, 4–10 manual, 10–50 tooling; ≤ 75-word emails, 3–4
follow-ups; paid pilots with a pre-fixed metric converting to recurring contracts with 30/60-day
opt-out; implementation is the vendor's job. Baselines are harsh (win rate 19–21 %, 344 emails per
meeting) so coverage = 1 ÷ win-rate and slipped or next-step-less deals are downgraded. PH
government selling under RA 12009 is fully specified (PhilGEPS Platinum, ≤ 60-day award, MEARB
price weight 15–40 %, securities, LD 0.1 %/day, startup set-asides, STI direct procurement with IP
defaulting to the PE).

**07 Marketing.** PH is a Facebook/Messenger/TikTok country with a small fast-growing LinkedIn;
Shopee leads GMV, TikTok Shop overtook Lazada. Experiments gate on n and duration (peeking turns
5 % into 26 % false positives); ICE confidence > 5 needs evidence. ASC requires independent
third-party data for superiority/No. 1 claims (12 months, expiring yearly); RA 7394 Arts 110/115/116
(national promos need a DTI permit ≥ 30 days prior); ITA merchant disclosures; DPA consent is
opt-in ("continued use" is not consent); Gmail spam-rate thresholds are hard stops.

**08 Operations.** Services delivery is contract-mechanical: deposit before kickoff, payments on
milestone ids, 5-BD deemed acceptance, invoice on acceptance, "no signature, no work" on change
orders, 5–10 % holdback, SLA tiers only with staffing behind them. Hardware NPI at startup scale
(EVT ≤ 20, DVT hard-tooled, PVT ≥ 98 % yield), AQL 0/2.5/4.0 incoming QC, EMS RFQ package. PH
ship-blockers: NTC certificate under the exact marketed model name; BPS PS/ICC for 111 mandatory
products; Consumer Act floors (60 d–1 yr implied warranty, 30-day repair, 90-day service guaranty,
"No Return, No Exchange" prohibited). COD is 13–23 % of payments despite 71 % stated preference.

**09 Compliance.** EOPT rewired the basics (no ARF, invoice replaces OR, ₱500 rule, 5-year
books, micro/small penalty relief). The ₱3M line drives VAT, 8 %, audit and BMBE. First hire
triggers SSS/PhilHealth/Pag-IBIG/13th/OSH and the control test (labels do not survive Sonza).
IP Code §178.4 keeps copyright with the creator of commissioned work unless assigned in writing.
Foreign co-founders need US$200k/100k paid-in. Register schema with `applies_if`, deadline rules,
evidence hashes and professional sign-off rows; UNVERIFIED rows (LGC §167 verbatim, NPC Circular
2022-04, Rule 1020, IPOPHL fees, SEC AFS calendar) need a human before they are relied on.

**10 Finance ops.** Accounting policy triad (calendar FY, accrual, income-tax basis / PFRS for SEs);
TITF → corporate account chosen on the *corporate* rail schedule; ORUS books; invoices with printed
credit terms (output-VAT credit); 2307 workflow (book gross, cash net, credit asset); substantiation
(receipts in the company's name with TIN; RMC 81-2025); AR aging ≥ 80 % current, DSO ≤ 45, dunning
with the 6 % legal-interest clock from written demand; 13-week cash; dashboards from ledgers. Rails:
PayMongo ex-VAT rates, Maya conflicts, PayPal 4.4 % + 3 % conversion, Wise Business PH (2025) for
USD, Stripe unavailable; BSP FX rules permit holding USD. Two independent ₱3M audit tests.

**11 Governance.** Founders' agreement gate before any external money; strategy kernel; North Star
+ 3–5 inputs; OKRs graded 0.6–0.7; Sequoia board pack generated from ledgers with a 48-hour
pre-read and a 31-day staleness rule; default-alive mechanised from three columns with a fatal-pinch
ADR and hiring freeze; ADR log (monotonic, never reused) with pre-mortems on one-way doors; risk
register with owners/triggers/review dates; SAFE unmodified + side letter; FAST advisor terms; PH
money has time-gates (SB Corp 3–11 months + ≥ 3 months sales; SVF ≥ 1 year + co-investment partner;
IdeaSpace $10K/1 %).

**12 Studio model.** Ledger before selling; positioning (vertical; 10–200 competitors, 2,000–10,000
prospects); offer ladder from paid diagnostic; pipeline ≥ 2× with a BD-hours floor; first three
projects on deposit + milestones; delivery control; monthly KPI review with SPI floors and JPMC
cash-buffer days; references ≥ 70 %; products only from surplus with a dedicated team (37signals,
Mailchimp, thoughtbot); venture-studio equity (~34 %) is human-only. PH: Metro Manila engineers
₱75–100k/month, +20–30 % vs provinces, 13th month ≈ +8 %; Full Scale $30–40/h loaded; no
verifiable PH hardware-startup case.

## 10. Open items / UNVERIFIED — hand to a human before relying on them

- LGC §167/168 verbatim (20 Jan renewal; 25 % + 2 %/mo); RCC OPC chapter and §177 delinquency;
  SEC AFS/GIS filing calendar and fines; IPOPHL fee schedule; NPC Circular 2022-04 thresholds; OSHS
  Rule 1020; BIR 2025 e-invoicing regulations; Pag-IBIG Feb-2024 circular; ITA transitory end date;
  CREATE MORE effectivity; fiscal-year change procedure; multiple-TIN penalty; DTI promo-permit
  fees; PH RPM/MAP treatment under RA 10667.
- Benchmarks without a fetched anchor: "3–6 months reserve"; dunning day-counts; warranty-reserve %;
  COD rejection / RMA rates; PH engineering service rate ranges; Statista-derived PH market sizes;
  Blank's "50–100 interviews"; the 30 % pre-mortem gain; Sacks' burn-multiple tier chart.
- Conflicts to resolve at sign-up: Maya QR Ph 1.0 % vs 1.25–1.60 %; PwC's stale SSS cap; SSS MSC
  floor ₱4,000 vs ₱5,000; electronics-export series (SEIPI vs PSA definitions).
- Culture claims (hiya / pakikisama in procurement) are practitioner consensus, not evidence.

## 11. How the loop consumes this dossier

- Each `references/<domain>-protocol.md` is written from its brief(s) and must clear the frozen
  scorer's rubric (concept coverage), then its gate must be wired (`score-guild.sh <gate>`),
  fixture-tested (`tests/<domain>.test.sh <gate>`) and executed on a good/bad fixture pair where
  the bad fixture carries the planted defect named in §4.
- Thresholds tagged **policy** in `benchmarks.md` are tunable via env (`GUILD_*`), documented as
  policy, never presented as literature.
- Every PH statute row in a protocol carries the RA/RR/RMC number, the effective date and the
  `verified_on` date from the brief; the compliance gate re-flags rows older than 12 months.
- Human sign-off rows are named in every protocol (send, spend, sign, file, elect, judge) and are
  the only rows the loop may leave red at `OPEN_FOR_BUSINESS`.

## 12. Sources

Per-brief numbered source lists (title · URL · type · what was used) are in `research/raw/01–12`
(section 8 of each). Totals: 01 29 · 02 49 · 03 39 · 04 44 · 05 50 · 06 46 · 07 37 · 08 45 ·
09 42 · 10 61 · 11 47 · 12 36. Fetch failures are listed at the end of each brief so a human can
retry them.
