# Pricing Protocol — WTP first, cost floor, band, metric, tiers, tax mechanics

Companion to `/guild:build` phase P6 (pricing). Research basis: brief 04
(`research/raw/04-pricing.md`, retrieved 2026-09-02; sources [S#] listed there §8 with provenance
P1 primary / P2 secondary / P3 weak). Numbers carry their grade; thresholds chosen by the harness
because no published rule exists are tagged **policy**. The `pricing` gate
(scripts/gates/pricing.sh) enforces the mechanical part; elections, quotes and increases are
human sign-off rows. Tax content is process, **not tax advice** — every posture row is verified
with a CPA.

## §0 The rules of this domain

1. **Price before product.** Willingness-to-pay conversations come before building — 72 % of new
   products introduced over the past five years failed (Simon-Kucher research, per Ramanujam
   [S14, P2]); the four failure types are feature shock, minivation, hidden gem, undead.
2. **Cost is a floor, never the price.** Cost-plus firms "communicate and sell too heavily on
   price… leave substantial amounts of money on the table" [S17, P1]; but no row exists without a
   computed floor, and no quote goes below it.
3. **Every number in the book is dated, sourced and approved.** Floors carry a method and a date;
   competitor prices carry captures with hashes; WTP counts trace to a human-entered ledger;
   every row names its approver.
4. **The tax posture shapes the price.** VAT / non-VAT / 8 % / zero-rating / CWT are not
   accounting trivia — they change the quote, the display, the cash floor and the breakeven.

## §1 The ordered process (P6 pipeline; brief 04 §1)

| # | Step | Deliverable |
|---|---|---|
| 1 | WTP conversations before building — run the post-launch sales conversation on a wireframe; segment by differences in WTP, not demographics [S14][S15] | `pricing/wtp-interviews.csv` (human-entered), **≥ 10 per segment (policy)** |
| 2 | Cost floor — fully loaded labour at realistic utilisation, overhead, subcontractors, channel, tax cash effects [S25][S23][S30][S31] | `pricing/cost-floor.csv`, summarised into the book's `cost_floor_exvat / floor_method / floor_date / floor_utilization` |
| 3 | Competitor price band — dated captures of ≥ 3 comparable offers with URL + hash [S18] | `pricing/competitor-band.csv` |
| 4 | Quantitative research **only when a public list price will be set for many buyers**: Van Westendorp range, Gabor-Granger point, CBC trade-offs [S1–S4] | research columns in the book |
| 5 | Price metric & model [S21][S22][S26] | `price_metric` per row + model rationale |
| 6 | Structure — Good-Better-Best, fences, anchors, decoys only where dominance is easy to see [S11][S12][S17][S28] | `pricing/price-book.csv` |
| 7 | Tax treatment per line — VAT/8 %/zero-rating/CWT [S30][S31][S33][S35] | `vat_treatment`, `display`, `cwt_rate_expected` columns + `pricing/tax-status.csv` |
| 8 | Discount & increase policy — authority levels, max discount, pocket tracking, increase playbook [S16][S17][S21][S44] | `max_discount_pct`, `discount_authority`, change columns, `pricing/discount-log.csv` |
| 9 | Review cadence — **quarterly** price-vs-value review; refresh captures; re-run WTP on new segments [S21] | ledger diff (the gate checks freshness) |

## §2 WTP conversations (human-entered; the "price before product" test)

`pricing/wtp-interviews.csv`: `interview_id, date, segment_id, offer_id, acceptable_price_php,
expensive_price_php, prohibitive_price_php, feature_reaction, consent_id, entered_by`.

- Take the wireframe/prototype to target customers and run the sales conversation you would run
  after launch; ask for acceptable / expensive / prohibitive prices and watch feature reactions
  ("early and often" — Ramanujam [S15, P2]).
- **≥ 10 rows per segment** before any new offer is priced (**policy**; no published minimum was
  found). The gate fails a new offer (effective within 180 days) whose `wtp_n` < 10, and — when
  the ledger is passed — an interview-method `wtp_n` that overstates the rows on file.
- Segment by differences in willingness to pay, not by demographics [S14]. Rows join the consent
  ledger like every interview (RA 10173 discipline lives in the evidence protocol).

## §3 The cost floor (fully loaded, at realistic utilisation)

Rate formula (practitioner [S25, P3]): hourly floor = (labour + overhead + profit) ÷ billable
hours, with realistic billable hours 1,200–1,600/yr, a 2–3× salary multiplier and 65–80 %
billable efficiency. Industry actuals are lower than intuition: **SPI billable utilisation
68.9 % (2024, 403 firms) and 66.4 % (2025, 500+ firms)** [S23, P1][S24, P2]; SPI's optimal
threshold is **75 %**.

- The gate caps the floor's `floor_utilization` input at **≤ 0.75** and demands a
  `justification_ref` above 0.70 — assuming 100 % utilisation makes the floor a hidden discount.
- **Worked PH floor** (derived in brief 04 §3; multiplier and profit are **policy** parameters,
  not findings): a ₱75,000/month engineer (₱900k/yr; Jobstreet job-ad average for Metro Manila
  software engineers [S42, P2]) at a 2.0× fully loaded multiplier and 20 % profit over 1,400
  billable hours → ≈ **₱1,540/hr ex-VAT**; at SPI-actual 66 % utilisation of 2,000 h (1,320 h)
  ≈ ₱1,640/hr.
- The floor includes tax cash effects: percentage tax (3 %) if non-VAT, the 8 % option as a
  revenue-linked cost, and CWT timing (§10) [S30][S31].
- Floors expire: `floor_date` ≤ **90 days** old or the row fails — wages, subs and overhead move.
- Book check: `list_price_exvat ≥ cost_floor_exvat ÷ (1 − target_gm_pct)` per row; a services
  business below a 35 % project-margin floor is bleeding (SPI project margin 35.9 % / 37.7 %
  actuals [S23][S24]).

## §4 The competitor band (≥ 3 dated, hashed captures)

`pricing/competitor-band.csv`: `offer_id, competitor, url, capture_date, hash, price, metric,
vat_treatment`. Competitor-based pricing is a band check, not a strategy — "primarily focus on
your unique value and market position" (Simon-Kucher [S18, P1]); copying competitors "doesn't
leave a lot of room for growth" (Paddle [S19, P2]).

- **≥ 3 comparable offers** per priced offer, every capture **≤ 90 days** old, every capture
  carrying a content **hash** of the archived page (16–64 hex) — an unhashed price is hearsay.
- A list price outside **[0.8 × band low, 1.5 × band high]** (**policy** width) needs a
  `justification_ref` — priced far outside the band you are either differentiated (write down
  why) or wrong.
- The book columns `competitor_low / competitor_high / competitor_n / competitor_capture_date`
  summarise the band; when the capture file is passed, the gate cross-checks counts, freshness,
  hashes and min/max agreement.

## §5 Quantitative research — only for public list prices, with sample floors

Use surveys only when a public/list price will face many buyers; otherwise interviews beat
instruments.

| Method | Produces | Floors (gate-enforced) | Caveats |
|---|---|---|---|
| **Van Westendorp PSM** [S4][S5] | four curves; PMC, IPP, OPP, PME; acceptable range = PMC–PME | **n ≥ 150 per segment** (vendor floor, P3 [S10]; < 100 unstable) and **PMC ≤ list ≤ PME** | stated not revealed preference; no competitive context; no purchase intent unless the Newton-Miller-Smith extension is added [S4, P1] |
| **Gabor-Granger** [S3][S6][S7] | demand and revenue curves; revenue-maximising point | **n ≥ 100** (vendor guidance, P3) | product evaluated in isolation; self-reported intent |
| **Choice-based conjoint (CBC)** [S1][S2] | part-worths, share simulators, elasticity by feature | **n·t·a/c ≥ 500** exposures (Johnson-Orme rule, P1; 1,000+ better), ~300 respondents, ≥ 200 per reported subgroup | costly for a small studio; design discipline required |

The book's `research_method` column names the instrument; `wtp_n` carries its sample;
`wtp_pmc/opp/ipp/pme` carry the intersections; `cbc_exposures` carries n·t·a/c.

## §6 Price metric, price model, channel stack

**The price metric is the unit value is charged in** — per seat, usage, tiered, flat, hybrid for
software; T&M, fixed-price, milestone, retainer, value-based for services; cost-plus to a target
GM through the channel for hardware [S21][S26]. Companies priced on a **value metric** grow at
"double the rate… with half the churn and 2x the expansion revenue" (ProfitWell via Paddle
[S19, P2]); usage-based adoption reached 3 of 5 SaaS firms in 2023 (OpenView via Chargebee
[S22, P2]). Model traps are real: seat-sharing under per-seat, revenue volatility under usage
[S21, P2] — record the accepted cons in the model rationale.

**Hardware goes through the channel stack** (Teel [S26, P3]): retail price ≥ **3× COGS**
initially, **4× target**; **keystone** = 50 % retailer margin (40–60 % typical); **distributor
10–15 %**; gross margin **≥ 40 %**, 50–60 % ideal. The gate enforces GM ≥ 0.40 on hardware rows
and the 3×/4× multiple on `channel=retail` rows — a device priced at COGS + software-style
markup dies in the channel. MAP policies restrict *advertised* price only and must be unilateral
or they become resale-price maintenance (Colgate/Leegin, US law [S27, P2]); Philippine RPM
treatment under RA 10667 is **UNVERIFIED** — human legal review before any MAP/channel terms.

**Skimming vs penetration** is a human election: "many companies fail with a penetration pricing
strategy… You need to be able to follow through on future price increases" [S17, P1].

## §7 Structure — G-B-B, fences, anchoring, decoys

Good-Better-Best segments heterogeneous WTP: Good attracts, Better is the default, Best expands
and anchors (Mohammed [S11, P1 partial; S12, P3]). Each tier carries **fence attributes** that
stop downgrading (non-refundable rates, GA-only tickets are the classic fences [S12]). Tier-gap
heuristics (Better ≈ +10 % over the average sale, Good ≈ −25 %, Best ≤ +50 %) are trade-press —
**treat as UNVERIFIED** [S12]; the offers gate applies them only as warnings. **Anchoring** works
(Tversky & Kahneman 1974 [S29, P3 citing P1]) and the **decoy/compromise effect** shifts choice
(Huber, Payne & Puto 1982; Ariely's Economist case went 16/0/84 → 68/32 without the decoy
[S28, P3 citing P1]) — but a decoy needs near-indifference, comparable dimensions and
easy-to-see dominance, and "may not appear in realistic purchasing scenarios" [S28]. 2–4 tiers;
more breeds decision paralysis [S21].

## §8 Pocket price and the discount policy

List → invoice → **pocket price** after every leakage (Marn & Rosiello, HBR 1992 [S44, P1
abstract]): transaction prices for one product ranged **60 %**; one supplier's band reached
**500 %**. The famous "1 % price = 11.1 % operating profit" lever is paywalled — **UNVERIFIED**;
the verified lever: "a 5 % improvement in pricing without volume loss and average margins can
boost profits easily by 30 % to 50 %" (Simon-Kucher e-book [S17, P1]).

- `pricing/discount-log.csv`: `quote_id, offer_id, tier, date, list_exvat, invoiced_exvat,
  pocket_exvat, approver` — every quote logged, every discount approved by the named
  `discount_authority`.
- Gate: `max_discount_pct ≤ 20` (**policy**, anchored on SPI: average discount 9.1 % and > 20 %
  correlates with attrition — benchmarks annex §3), `discount_authority` non-empty, pocket/list
  ≥ 1 − max_discount, no pocket below the floor, and a **P90/P10 pocket band > 1.6×** flags a
  review (alarm level set from Marn & Rosiello's 60 % band, **policy**).
- "Maintain pricing integrity by limiting discounting" is one of Ramanujam's nine rules [S14].
  More than half of all companies worldwide believe they are in a price war [S17, P1]; entering
  one is a human decision the band trend informs — "nobody ever truly wins" [S17].

## §9 Price increases (reason, notice, grandfathering, realisation)

- Companies "realize less than half the amount of their price increases on average" (Simon-Kucher
  Global Pricing Study 2025: > 2,200 leaders, 28 countries, 39 industries [S16, P1]) — track
  `realised_pct` against every attempt; **realised < 50 % is the norm to beat**.
- "No specific reasons… might fly with a 2 % increase, but higher increases definitely need
  justification" [S17, P1]: any increase **> 2 %** requires `change_reason_text`.
- Existing customers get **≥ 30 days notice** (`change_notice_date` vs `effective_from`;
  **policy** floor) and an explicit `grandfather_until` — a date, or the literal `null` as a
  recorded decision; grandfathering is cheap to give and expensive to unwind [S21, P2].
- Contracts must allow increases: "consider when your contract allows for a price increase and
  keep an eye on T&Cs" [S17] — retainer/fixed contracts without indexation lock the price
  (early irreversible §15).

## §10 Philippine tax mechanics (verify with a CPA; statute rows expire at 12 months)

**VAT 12 %.** Levied on gross sales of goods and — since the EOPT Act — of **services on
accrual**: "twelve percent (12%) of the gross sales derived from the sale or exchange of
services" (NIRC §108(A) as amended by RA 11976 [S35, P1]). Output VAT is due on invoicing, not
collection; the invoice replaces the official receipt [S35][S38][S39]. Relief: §110(D) lets a
seller deduct output VAT on **uncollected receivables** the quarter after the agreed period
lapses [S35][S40] — which is why invoice templates print the credit term.

**Display: exclusive for B2B.** §113(B): "the amount of the tax shall be shown as a separate
item in the invoice" [S35, P1]; RR 7-2024 requires the VAT amount as a **separate line** on the
total [S41, P2]. B2B quotes and the price book carry the **ex-VAT price** with the 12 % line
separate — quote one inclusive number and many B2B buyers read it as ex-VAT, so the seller eats
12/112 of it (quoting convention: practitioner consensus; the separate-line rule: P1). The gate
fails B2B rows with `display=inclusive`. Consumer-facing VAT-inclusive display under DTI rules is
**UNVERIFIED** — b2c rows may display either way.

**The ₱3,000,000 threshold and the 80 % monitor.** Registration is compulsory once gross sales
exceed ₱3M in the past 12 months or reasonably expected in the next 12 (§236; PwC still states
₱3M as of Aug 2026 [S36, P2]; §109(BB) provides CPI re-indexing every 3 years — whether BIR has
re-indexed is **UNVERIFIED** [S33]). Crossing unplanned is a pricing event: a net-of-tax
competitive price at ₱2.9M becomes 12 % more expensive to non-VAT buyers or 12 % less profitable
absorbed. The gate reds a non-VAT posture with trailing sales > ₱3M and **warns at 80 %** of the
threshold so registration is planned, not forced. Voluntary registration carries a 3-year
lock-in (annex §8).

**The 8 % option (individuals only).** §24(A)(2)(b): 8 % on gross sales above ₱250,000 **in lieu
of** graduated rates and §116 percentage tax [S33, P1]. RMO 23-2018 [S30, P1]: individuals only
(sole proprietors; not corporations, not GPP partners), gross sales ≤ ₱3M, **not VAT-registered**,
elected in the **first-quarter** return, **irrevocable for the year**; breach the ₱3M mid-year
and graduated rates + VAT apply **from the breach date**. Under 8 % the tax is a revenue-linked
cost with no deductions — the floor must include it. Otherwise: graduated 0–35 % plus **3 %
percentage tax** (non-VAT, §116; the 1 % rate expired 30 Jun 2023 [S34, P1]). The gate reds:
8 % while VAT-registered; 8 % on a corp/OPC; 8 % with trailing sales > ₱3M.

**Zero-rating for foreign clients.** §108(B)(2): services to a person engaged in business
**outside the Philippines** (or a nonresident not engaged in business), **paid in acceptable
foreign currency** per BSP rules, are VAT **zero-rated for a VAT-registered seller** [S33, P1].
The gate requires `foreign_currency_client=Y` on every `zero_rated_108B2` row and reds
zero-rating under a non-VAT posture. Documentation and refund practice are out of scope here.

**Creditable withholding tax (CWT/EWT) — a cash-flow effect, not a cost.** RR 11-2018 §2.57.2(A)
(the payee list names "civil, electrical, chemical, mechanical, structural, industrial…
engineers" and "management and technical consultants") [S31, P1]:

| Payee | Rate |
|---|---|
| Individual (sole prop), gross income ≤ ₱3M for the year | **5 %** — only with a non-VAT COR + sworn declaration filed with each payor (RR 14-2018 [S32, P2]); VAT-registered individuals are withheld 10 % regardless |
| Individual, > ₱3M | **10 %** |
| Corporation / OPC, gross income ≤ ₱720,000 | **10 %** |
| Corporation / OPC, > ₱720,000 | **15 %** |

The payor issues **BIR Form 2307** (by the 20th after quarter end) and the payee credits it
against income tax due. CWT is a **prepayment**: no gross-up if income tax due ≥ credits, but
5–15 % of every invoice arrives as a certificate, not cash — so the **cash floor is computed on
(1 − cwt) × ex-VAT price**, and a missing 2307 is money lost twice. Withholding timing follows
§58(C): the obligation arises when the income becomes **payable** [S35]. Whether 2307 credits
offset the 8 % tax is governed by RR 8-2018 — **UNVERIFIED** here. The gate constrains
`cwt_rate_expected` to {5,10} for sole props ({10} once VAT-registered), {10,15} for corps/OPCs,
0 only for b2c or foreign-currency buyers, and warns when the ₱720k test points at 15.

**EOPT classes** (RA 11976 §21 [S35]): micro < ₱3M, small < ₱20M, medium < ₱1B, large ≥ ₱1B;
micro/small get reduced penalties (10 % surcharge, halved interest) [S40].

## §11 Review cadence

Review pricing **quarterly** (Paddle [S21, P2]): refresh competitor captures, recompute floors,
re-run WTP on new segments, re-read the tax posture. The gate reds a book with no floor /
capture / effective / review date within 90 days — "one-time project" pricing is a failure mode,
not a convenience.

## §12 The ledgers (who writes what)

**`pricing/price-book.csv`** — loop-written, one row per offer × tier × metric; `-` reads as
empty; every row `approver`-signed. Columns:

| Column | Meaning |
|---|---|
| `offer_id, tier` | join to `offer/offers.yaml` |
| `price_metric` | seat·per_seat·usage·flat·tiered·tm·fixed·milestone·retainer·value·per_device·per_unit |
| `list_price_exvat, currency` | the anchor, ex-VAT, ISO-4217 |
| `vat_treatment` | vatable12 · exempt_nonvat · zero_rated_108B2 |
| `display` | exclusive (mandatory for b2b) · inclusive |
| `cost_floor_exvat, floor_method, floor_date` | §3; floor ≤ 90 days old |
| `floor_utilization` | fraction; required on tm/fixed/milestone/retainer/value rows; ≤ 0.75, > 0.70 needs justification |
| `target_gm_pct` | fraction (0,1); check list ≥ floor ÷ (1 − gm) |
| `cwt_rate_expected` | §10 table; cash floor = (1 − cwt) × price |
| `buyer_type` | b2b (default) · b2c |
| `channel` | direct (default) · retail · distributor — retail hardware rows face the 3×/4× COGS multiple |
| `cogs_exvat` | hardware landed cost for the multiple |
| `foreign_currency_client` | Y required on zero-rated rows |
| `segment_id` | joins WTP interviews |
| `competitor_low/high/n, competitor_capture_date` | §4 band summary |
| `wtp_n, wtp_pmc, wtp_opp, wtp_ipp, wtp_pme` | §2 count / §5 Van Westendorp intersections |
| `research_method, cbc_exposures` | none·interviews·van_westendorp·gabor_granger·cbc; n·t·a/c |
| `justification_ref` | names the written justification for band/utilisation exceptions |
| `max_discount_pct, discount_authority` | §8 policy per row |
| `prev_price_exvat, change_reason_text, change_notice_date, realised_pct, grandfather_until` | §9 increase discipline |
| `effective_from, last_reviewed, approver` | new-offer test (180 d), cadence, the named human |

**`pricing/tax-status.csv`** — **human-entered** (elections are BIR filings):
`entity_type (sole_prop|corp|opc), vat_registered, eight_pct_elected,
trailing_12m_gross_sales, cor_date`.

**`pricing/competitor-band.csv`** (§4) · **`pricing/wtp-interviews.csv`** (§2, human-entered) ·
**`pricing/discount-log.csv`** (§8, human-approved quotes) · price-change history lives in the
book's change columns (a separate `price-change-log.csv` may archive old rows).

Every fixture and ledger with dates starts with `# as_of: YYYY-MM-DD` so staleness checks are
deterministic.

## §13 The gate (mechanical surface)

`score-guild.sh pricing pricing/price-book.csv pricing/tax-status.csv
[pricing/competitor-band.csv] [pricing/wtp-interviews.csv] [pricing/discount-log.csv]`
→ `PRICE_VIOLATIONS: N` (0 required; each violation named on stderr; exit 2 only on missing or
unparsable files). Checks, in the order of §1: floor ÷ (1 − GM) · hardware GM ≥ 40 % and retail
3×/4× COGS · floor ≤ 90 days and utilisation ≤ 75 % (> 70 % justified) · band n ≥ 3, captures
≤ 90 days, hashed, list within [0.8×low, 1.5×high] or justified · new offers need ≥ 10 WTP rows ·
Van Westendorp n ≥ 150 with PMC ≤ list ≤ PME, Gabor-Granger n ≥ 100, CBC exposures ≥ 500 · VAT /
8 % / zero-rating / display / threshold consistency incl. the 80 % monitor · CWT brackets ·
max discount ≤ 20 with a named authority · increases with reason, ≥ 30-day notice, grandfather
decision, realised tracking · quarterly freshness · cross-file: capture counts/hashes/min-max,
interview counts, pocket ≥ (1 − max_discount) × list and ≥ floor, P90/P10 band review at 1.6×.
All thresholds env-overridable (`GUILD_PRICE_*`) with the defaults above.

## §14 Human sign-off rows (the loop never marks these pass)

| Row | Why human |
|---|---|
| Every WTP interview row | human conversation, human entry |
| VAT registration / 8 % election / entity form | BIR filings; irrevocable windows [S30] |
| Skim vs penetrate; entering/exiting a price war | strategy under uncertainty [S17] |
| The value story and monetary-benefit estimate | judgement [S17] |
| Every quote, discount, and price-increase notice | irreversible sends |
| Grandfathering decisions | contractual promises [S21] |
| MAP / channel terms | legal review; PH RPM UNVERIFIED [S27] |

## §15 Early irreversibles (charter rows)

1. **Price metric / value metric** — re-papering every customer to change it [S21].
2. **First public list price** — the anchor for customers and competitors [S29]; penetration
   prices rarely recover: "prices hardly ever return to their pre-war levels" [S17].
3. **Tax posture** — 8 % elected in Q1, irrevocable per year, non-VAT only; VAT registration
   changes every quote (+12 % line) and the CWT bracket (5 % → 10 %); entity form fixes which
   bracket applies at all [S30][S31][S32].
4. **Contract T&Cs enabling increases** — no indexation clause, no increase [S17].
5. **Discount precedents** — the first discounts set the pocket band and every renewal
   expectation [S44][S17].
6. **Channel structure** — appointed distributors/retailers fix the 10–15 % / 40–60 % margin
   stack the retail multiple must clear; MAP must be unilateral from day one [S26][S27].
7. **Grandfathering promises** [S21].

## §16 Failure modes this protocol exists to prevent

Building before the WTP conversation (feature shock, minivation, hidden gem, undead [S14]) ·
cost-plus as the price instead of the floor [S17][S19] · copying competitors without
differentiation [S18][S19] · penetration launches with no path to increase [S17] · increases
without a stated reason (< 50 % realised is the norm [S16]) · discount leakage and a wide pocket
band [S44] · too many tiers; seat-sharing; usage volatility [S21] · under-powered research with
unstable intersections [S1][S2][S10] · PSM read as competition or intent [S4] · decoys nobody can
see dominance in [S28] · one VAT-inclusive number quoted to B2B (losing 12/112) [S35][S41] ·
crossing ₱3M unplanned [S30] · 8 % while VAT-registered or as a corporation [S30] · CWT treated
as lost revenue, or ignored so the cash floor is 5–15 % high [S31] · a floor assuming 100 %
utilisation [S23][S24] · hardware priced without the channel stack [S26] · MAP negotiated into an
agreement (RPM exposure) [S27] · repricing never ("one-time project") [S17][S21].

## §17 What the gate blocks

A list below its floor ÷ (1 − GM) · a hardware retail price the channel stack cannot survive · a
stale or utilisation-inflated floor · a band of fewer than 3 captures, stale captures, unhashed
captures, or a price outside the band with no written justification · a new offer priced on
fewer than 10 WTP conversations · survey-dressed guesses (VW n < 150, GG n < 100, CBC < 500
exposures, a list outside PMC–PME) · a book that contradicts the tax posture (exempt rows under
VAT registration, VAT/zero-rated rows without registration, 8 % elected where it cannot be,
missing FX flag on zero-rated rows, inclusive B2B display, wrong CWT bracket, the unwatched ₱3M
threshold) · discounts beyond policy or below floor, with no named authority · increases with no
reason, short notice, or no grandfather decision · a book nobody has reviewed in a quarter.

## §18 Sources

[S#] resolve in `research/raw/04-pricing.md` §8 (all retrieved 2026-09-02): S1–S2 Sawtooth CBC
sample rules (P1) · S3–S4 Sawtooth GG/VW (P1) · S5 Conjointly (P2) · S6 Qualtrics ladder (P2) ·
S7 IntelliSurvey (P3) · S8–S9 SurveyMonkey/Quantilope (P3) · S10 CleverX VW floor (P3) ·
S11–S13 Mohammed G-B-B (P1 partial / P3) · S14 Ramanujam interview (P2) · S15 Lenny/Ramanujam
(P2) · S16 Simon-Kucher GPS 2025 (P1) · S17 Simon-Kucher pricing e-book (P1) · S18 Simon-Kucher
models (P1) · S19–S21 Paddle (P2) · S22 Chargebee/OpenView UBP (P2) · S23 SPI 2025 benchmark
(P1) · S24 Deltek/SPI 2026 (P2) · S25 ClickTime calculator (P3) · S26 Predictable Designs
channel stack (P3) · S27 MAP/RPM antitrust (P2) · S28 decoy effect (P3 citing P1) · S29
anchoring (P3 citing P1) · S30 BIR RMO 23-2018 (P1) · S31 BIR RR 11-2018 digest (P1) · S32
Grant Thornton RR 14-2018 (P2) · S33 RA 10963 TRAIN (P1) · S34 RA 11534 CREATE (P1) · S35
RA 11976 EOPT (P1) · S36–S37 PwC tax summaries (P2) · S38 Deloitte EOPT (P2) · S39–S40 Grant
Thornton / Ocampo & Suralvo EOPT notes (P2) · S41 MTF invoicing (P2) · S42–S43 Jobstreet salary
pages (P2) · S44 Marn & Rosiello abstract (P1).
