# Market Protocol — sizing charter, beachhead, TAM/SAM/SOM factor ledgers, alternatives and price snapshots

Companion to `/guild:build` phase P3 (Market) and to the segment election `/guild:discover` hands
over. Research basis: brief 02 (`research/raw/02-market-competition.md` — market sizing,
competitive analysis, PH data sources; 49 sources, all retrieved 2026-09-02) and brief 03 §5 G3.1
(alternatives ledger). `[S#]` tokens below resolve in brief 02 §8; provenance grades are the
brief's: P1 primary/authoritative · P2 reputable secondary · P3 weak/tertiary. Validators:
`score-guild.sh market <factors.csv> <claims.csv> <sources.tsv>` → `MARKET_VIOLATIONS: N` and
`score-guild.sh competitors <alternatives.csv> <snapshots.csv>` → `COMPETITOR_VIOLATIONS: N`
(gate surface: `references/metrics.md`). Numbers in this document carry their grade and source tag
so the loop copies them into `evidence/claims.tsv` rows — it never restates them from memory, and
in venture documents every one of them still needs its own `[C-n]`.

## §0 The four rules

1. **Fix the counting unit and the statistical frame before any number.** The Philippines has two
   defensible answers to "how many businesses": the PSA List of Establishments counts 1,241,476
   establishments (2024, all sizes, formal + informal) [S27 P1], while the ASPBI formal sector
   counts 281,825 (2022) [S29 P1] — **4.4× apart**. A TAM whose unit_count and whose filters come
   from different frames is arithmetic on apples and oranges; the sizing charter (§1) pins unit,
   frame, PSIC codes, geography, currency and reference year as an early irreversible, and every
   downstream ledger inherits it.
2. **Bottom-up is the primary method.** Units counted from named lists × annual revenue per unit
   (Aulet, DE Step 4 [S20 P3, secondary of S18]; "bottom-up should be your primary approach when
   presenting to investors" [S17 P2]). Top-down (macro figure × filters) and value-theory are
   cross-checks. Every market figure is the **product of factor rows** in `market/factors.csv`,
   each factor sourced, dated, archived and graded — and each `(layer, segment)` must be
   **triangulated by ≥ 2 methods that land within 3.0× of each other**. The 3.0× tolerance is a
   harness policy: no canonical value exists in the literature (practitioner consensus only —
   Aulet's top-down validation [S20], Forum VC [S17], Statista's own top-down/bottom-up
   "Reconciliation & Alignment" [S25 P1]).
3. **The status quo is a competitor; a competitor no interviewee named is a phantom; a price
   without a dated, archived, hashed snapshot is a rumour.** Dunford: "the first competitive
   alternative we need to beat is the status quo", and 20–30 % of enterprise deals are lost to
   "no decision" [S8 P1]. The alternatives register therefore carries mandatory
   status-quo / DIY / do-nothing rows, ≥ 2 interview ids per alternative (brief 03 §5 G3.1), and a
   fresh price snapshot per alternative (§4).
4. **Sources age.** Every factor row carries its source's reference period, publication date and
   retrieval date; the registry row carries the archive URL and content hash. A CAPTCHA page is not
   a source (§6). Staleness is mechanical: reference periods older than 24 months WARN (36 for
   census/LE-class data), older than 60 months fail.

## §1 Sizing charter (`market/charter.csv`) — the frame decision

Columns (brief 02 G1): `charter_id, counting_unit, unit_definition_source_url, frame
(LE|ASPBI|CPBI|other), psic_codes, geography, currency, reference_year, created_at`. All fields
non-empty; `psic_codes` are PSIC section letters with optional digits (`C`, `C25`, `J62`); the
choice of unit and frame is a **human sign-off row** and an early irreversible (brief 02 §6.1) —
changing frame invalidates every downstream factor.

Counting units: end user, buying unit, **establishment**, enterprise, household. PSA's definition:
"Establishment is an economic unit under a single ownership or control which engages in one or
predominantly one kind of economic activity at a single fixed location" [S29 P1]. Never
"identities" or "connections": DataReportal counts 90.8M social-media **identities** and 142M
mobile connections (122 % of population) against 116M people [S34 P2] — identities are not people,
and the gate rejects a unit_count denominated in them.

The three PH frames (§7 has the full catalog):

| Frame | Covers | Latest count | Cadence / lag | Grade |
|---|---|---|---|---|
| **List of Establishments (LE)** | all establishments in operation, formal + informal, by PSIC / region / employment size | 1,241,476 (2024) [S27]; 1,246,373 (2023) [S28] | annual; published via DTI tabulations or PSA data request | P1 |
| **ASPBI** | formal sector only: corporations, partnerships, cooperatives/foundations, single proprietorships with branches or total employment ≥ 10 | 281,825 establishments (2022); revenue ₱23.57T; e-commerce sales ₱159.26B | annual, ~22-month lag (ref-2022 released 30 Oct 2024); final tables in OpenSTAT | P1 [S29] |
| **CPBI** | formal + informal, census scope (same variables as ASPBI); census years 2006, 2012, 2018, 2023 | 2023 round: fieldwork May–Jul 2024 [S31][S32] | every ~5–6 years ("every five years" per PSA — UNVERIFIED, technical notes CAPTCHA-blocked) | P1 |

MSME size bands used with the LE frame: micro 1–9, small 10–99, medium 100–199, large ≥ 200
employees; asset bands (RA 9501): micro ≤ ₱3M, small ₱3,000,001–15M, medium ₱15,000,001–100M
[S27][S28 P1].

## §2 Segmentation, beachhead, follow-on markets

The chain is Disciplined Entrepreneurship Steps 1–5 (Market Segmentation → Select a Beachhead
Market → End User Profile → Beachhead TAM → Persona), Step 11 (Chart Your Competitive Position)
and Step 14 (TAM for Follow-on Markets) [S18 P1 (step titles), S19 P1].

- **Segmentation matrix** (`market/segments.csv`, shared with discovery): brainstorm end-user
  groups broadly, narrow to **6–12 candidate segments**, primary interviews per segment
  [S20 P3][S18]. Columns per brief 02 G2: seven score fields, `evidence_refs` (interview ids),
  `interview_count`, `status (candidate|beachhead|follow_on)`.
- **Beachhead selection** scores Aulet's **seven criteria**: customer budget / willingness to pay,
  accessibility, compelling reason to buy, ability to deliver a whole product now, competition,
  expansion potential, founder fit [S20 P3 — secondary summary of S18]. Moore's test: "a target
  segment that is big enough to matter, small enough to lead, and a good fit with your crown
  jewels" [S21 P2]. Exactly one `beachhead` row; every score 1–5 with ≥ 1 evidence ref; beachhead
  `interview_count ≥ 10` (harness default — Aulet only says "primary research" [S20]); the
  beachhead decision and the founder-fit score are human sign-off rows.
- The secondary-source guidance that a beachhead TAM should land around **$20–100M/yr** is
  P3 and UNVERIFIED against the book [S20], and US-scale — do **not** copy it into a claim row;
  PH beachheads are sized from PH frames.
- **Follow-on markets** (`follow_on` rows + DE Step 14): adjacent "bowling pins" that share
  customer traits, channel, or whole-product components with the beachhead [S18][S21]. List them;
  do not add their size into the beachhead TAM — geography or segments the studio cannot sell into
  inflate TAM (the classic pitch-lie family [S9 P1]).
- Screening heuristics for candidate segments (Kevin Hale, YC): the problem should be popular,
  growing, urgent, expensive, mandatory, frequent; ideals of "millions of users", "markets that
  are growing 20% a year", "billions of dollars" [S11 P1] are aspirations, not thresholds — record
  them as context, never as claims about your segment.

## §3 The market-size ledger (`market/factors.csv` + `market/claims.csv`) — validator `market`

### 3.1 Schemas

`market/claims.csv` — one row per sizing claim:
```
claim_id  stated_value  currency  computed_value  method  layer  segment_id
```
`market/factors.csv` — the factor chain behind each claim (dossier §5; brief 02 G3):
```
claim_id  layer  segment_id  method  factor  value  unit  currency  source_id
source_reference_period  source_publication_date  retrieved_at  archived_url  grade  note
```
- `layer` TAM|SAM|SOM · `method` top_down|bottom_up|value_theory · `factor`
  unit_count|price_per_unit|frequency|adoption_share|filter
- shares and filters are **fractions in (0, 1]**; `value` is always a positive number; the claim's
  figure is the **product of its factor rows and nothing else** — no claim references another
  claim's total, so every product is auditable on its own
- `source_id` resolves in `evidence/sources.tsv` (the registry, §6); `grade` P1|P2|P3 may not
  exceed the source's tier (P1 ⇔ T1, P2 ⇔ T1/T2, P3 ⇔ any citable tier)
- `source_reference_period` (`YYYY`, `YYYY-MM`, `YYYY-MM-DD`, `YYYYQn`) is the period the number
  **describes**; `source_publication_date` is when it was published (ASPBI's ~22-month lag lives
  in the gap between the two [S29]); `retrieved_at` is when the loop read it
- `archived_url` is the Wayback form `https://web.archive.org/web/<14-digit timestamp>/<url>`
  [S24 P1], or `-` when the source row is `fetch_status=manual`
- `note` names the real-world figure, its brief/source tag, and whether the row is a **proxy**
  (e.g. an all-sector regional share applied to one sector) — proxies are legitimate but must say
  so, and a same-named metric must state its definition (electronics exports 2024 = $42.75B on
  SEIPI's definition [S45 P2] but $39.1B on PSA's "electronic products" [S46 P2])

### 3.2 The three methods

| Method | Produces | Use | Caveat |
|---|---|---|---|
| **bottom_up** (primary) | units counted from named lists — "customer lists, industry databases, trade associations, or public records" — × annual revenue per unit [S20]; "Market Size = ACV × Number of Potential Customers" [S17 P2] | every layer; the SOM **must** be built this way (a named lead list × a close rate someone signs) | the unit list must be real, dated, sourced — grade P1/P2, never a modeled count |
| **top_down** | macro figure × filters (segment %, geography %, channel %) [S16 P2][S17]; Statista's description: global size "allocated to countries using drivers (e.g. GDP, digitization etc)" [S25 P1] | cross-check; when no list of units exists | "relies heavily on assumptions" [S16]; single-source TAMs; the "1 % of a huge market" trap [S9] |
| **value_theory** | value delivered per customer × share of value capturable | category-creating products with no comparable spend ("Some of the best companies invent their own markets" — Sequoia [S7 P1]) | originator UNVERIFIED (named only in secondary guides); easy to inflate; needs the quantified value proposition |

### 3.3 Worked chain (the fixture's beachhead: NCR small/medium manufacturers on manual inventory)

Bottom-up TAM = 141,266 manufacturing establishments (PSIC C, LE 2023) [S28 P1] × 18.00 % NCR
share of establishments [S27 P1, proxy: all-sector share] × 8.97 % small + medium share
(8.60 % + 0.37 %) [S27 P1, proxy] × price per establishment per year (draft price book, human
sign-off until pricing lands) — cross-checked top-down from the 1,241,476 all-sector base [S27]
× manufacturing share 11.33 % (141,266 / 1,246,373, LE 2023 [S28]). SAM applies the
manual-inventory share observed in the segment's own interviews (first-party dataset, T1); SOM is
the studio's **named lead list** (e.g. PCCI member directory [S48 P1] ∩ LGU business-permit lists)
× a signed adoption assumption. Sector counts available for other beachheads (LE 2023 [S28 P1]):
wholesale/retail 604,758 · accommodation & food 190,965 · manufacturing 141,266 · ICT (J) 11,247
(144 large) · admin & support (N) 18,661 with 1.33M employed, 85 % in large firms; hardware buyers
in manufacturing: 1,086 large + 978 medium establishments nationally.

### 3.4 What the `market` gate checks (letters are the gate's stderr tags)

- **(a) Arithmetic.** The product of a claim's factor rows must match `stated_value` within 1 %
  (`GUILD_FACTOR_TOLERANCE`), and `computed_value` must be that product within the same tolerance.
  Every claim needs ≥ 1 factor row and a `price_per_unit` in the claim's currency; a bottom_up
  claim needs a `unit_count`.
- **(b) Provenance.** Every factor row cites a registry row that exists and is citable (status
  read|cited, not T4), carries a valid `retrieved_at` (not after `as_of`), an `archived_url`
  matching `^https://web\.archive\.org/web/[0-9]{14}/` (or the source is `manual` and the cell is
  `-`), and a grade no higher than the source's tier. A live URL in `archived_url` is a violation:
  nothing pins what was read (§6).
- **(c) Bottom-up counts come from named lists.** A `bottom_up` `unit_count` graded P3 fails —
  a Statista-class modeled count or vendor estimate is not a list of buyers [S25][S26]; so does a
  unit_count denominated in "identities" or "connections" [S34].
- **(d) Layers nest.** Per segment, SOM ≤ SAM ≤ TAM within each method chain — evaluated on the
  recomputed factor product **and** on the stated values (a typed number cannot pass ordering on
  its own) — and across methods the largest SOM may not exceed the largest TAM.
- **(e) The 1 % guard.** A SOM claim applying an `adoption_share` requires a `bottom_up` claim in
  the same segment. "All we have to do is get 1 % of the market" is Kawasaki's lie #1 [S9 P1];
  reverse-engineered share ("we need ₱X so share = X/TAM") is the same defect.
- **(f) Triangulation.** Each `(layer, segment)` needs ≥ 2 distinct methods whose products agree
  within `GUILD_TRIANGULATION_MAX` (3.0, harness policy — see §0.2). A team that proceeds despite
  a failed triangulation records a human explanation row; the gate stays red until the factors
  change.
- **(g) Staleness** (vs the ledger's `# as_of:` date, via `guild_today` — results never decay
  with the calendar): reference period older than `GUILD_STALE_WARN_MONTHS` (24) → WARN;
  census/LE/CPBI-class rows (the note or unit says LE / CPBI / census / List of Establishments)
  older than `GUILD_STALE_CENSUS_WARN_MONTHS` (36) → WARN; older than `GUILD_STALE_FAIL_MONTHS`
  (60) → violation. Calibration [S29][S31]: ASPBI lags ~22 months, CPBI lands every ~5–6 years,
  LE/DTI is annual, trade is monthly.

### 3.5 The Big Market Delusion guard

Cornell & Damodaran: in a big market "each business cluster … will overestimate its capacity and
its probability of success" and participants "downplay existing competition" [S10 P1]. The
mechanical consequences here: SOM is bottom-up from a named list (e), TAM claims triangulate (f),
and the alternatives register (§4) must name ≥ 3 competitors plus the status quo before any
positioning work starts. Growth alone is not attractiveness (§5).

### 3.6 Human sign-off rows in this domain

Counting unit and frame; beachhead choice and founder-fit score; adoption / penetration
assumptions; price-per-unit until `pricing/price-book.csv` supplies it; the decision to proceed
despite a failed triangulation; the overall attractiveness verdict (§5). The loop drafts the rows
and surfaces them; a named human signs them.

## §4 Alternatives register and price snapshots — validator `competitors`

### 4.1 `market/alternatives.csv`

```
alt_id  name  type  url  why_customer_uses_it  evidence_interview_ids  lost_deal_ids
```
`type` ∈ direct|indirect|**status_quo**|**diy**|**do_nothing**|in_house. Ask "What would the
customer do if your offering didn't exist?" [S8 P1]; Sequoia asks for direct **and** indirect
competitors [S7 P1]. Rules (brief 02 G5; brief 03 §5 G3.1):

- ≥ 1 row of type status_quo|diy|do_nothing — spreadsheets, manual processes, the incumbent
  platform's built-in features [S8]. 20–30 % of enterprise deals end in "no decision" [S8 P1]
  (a Dunford-cited variant says ~40 % — P2, origin UNVERIFIED; brief 03 §3), so the do-nothing
  column is usually the biggest competitor.
- ≥ 3 named alternatives (`GUILD_MIN_ALTERNATIVES`) besides the status-quo class.
- Every non-do-nothing row carries ≥ 2 distinct `evidence_interview_ids`
  (`GUILD_MIN_INTERVIEWS_PER_ALT`) resolving into `discovery/interviews.tsv` — a row with fewer is
  a **phantom competitor** (brief 03 G3.1): an alternative the team imagined from a listicle, not
  one a buyer named. `lost_deal_ids` joins `gtm/pipeline.tsv` once deals exist.
- `why_customer_uses_it` non-empty — the buyer's compelling reason, in their words (human-signed
  judgement; the gate checks presence, a human checks truth).
- The register cannot be proven *complete* mechanically — that judgement stays human.

### 4.2 `market/snapshots.csv` — dated, archived, hashed prices

```
snapshot_id  alt_id  plan_name  list_price  currency  billing_period  price_metric
included_limits  discount_terms  source_url  archived_url  captured_at  captured_by
screenshot_hash
```
- `price_metric` ∈ per_seat|per_device|per_site|flat|usage|project — a price without its metric
  cannot be compared or banded; `billing_period` ∈ monthly|quarterly|annual|one_time|per_project|
  usage.
- Every non-do-nothing alternative needs ≥ 1 snapshot ≤ 90 days old (`GUILD_SNAPSHOT_MAX_DAYS`,
  vs the ledger's `as_of`). Older captures are kept as history (WARN) but are not current prices.
- `archived_url` uses the Wayback grammar `https://web.archive.org/web/YYYYMMDDhhmmss/<url>`
  [S24 P1]; create snapshots with Save Page Now [S23 P1]. Record the canonical form — the `id_`
  raw-bytes variant (`/web/<ts>id_/…`) is for fetching the body to hash, and does not match the
  gate's regex.
- `screenshot_hash` = 16–64 hex of the captured page or document — the proof the price existed on
  that day. A price obtained by **quote or email** has no public URL: set `source_url` to
  `quote:<file>` / `email:<ref>`, `archived_url = -`, hash the quote document, and put the human
  who obtained it in `captured_by` (quotes are human-obtained by definition; `loop` is not a valid
  captured_by there).
- Currency/period normalisation to ₱ per month is a **derived** view built by the pricing domain's
  competitor band (`pricing/competitor-band.csv`) — snapshots store what the vendor published,
  conversions never overwrite captures.

### 4.3 Feature matrix and positioning inputs

`market/feature-matrix.csv` (brief 02 G6): the **same feature list across all alternatives**,
cells ∈ {yes, no, partial, unknown}; `unknown` ≤ 10 % of cells; every competitor `yes` carries an
evidence URL. Which features are table-stakes vs differentiators is a human call that feeds the
strategy canvas — the value curve across "the range of factors that an industry competes on and
invests in" [S4 P1] with the Four Actions (eliminate / reduce / raise / create) [S5 P1]. Build the
canvas **from the matrix**, not from adjectives — Blue Ocean's own critics call post-hoc canvases
"descriptive rather than prescriptive" and unfalsifiable [S6 P3]. The positioning map (DE Step 11
[S18]) must come from customer perception data — judgmental, manager-made maps are "limited by not
being based on consumer data" [S22 P3]; its axes trace to interview codes, and the whole chain
(alternatives → unique attributes → value themes) continues in `references/offer-protocol.md`
under positioning.

## §5 Industry structure and timing

- **Five forces** (`market/five-forces.csv`: `force, rating_1to5, evidence_refs, source_ids` —
  exactly five rows: rivals, customers, suppliers, potential entrants, substitutes). "The Five
  Forces determine the competitive structure of an industry, and its profitability" [S2 P1];
  every force needs ≥ 1 P1/P2 source — a forces table without evidence is vibes in a grid.
  Known limits (record, don't ignore): the model assumes actors don't collude, that value comes
  from structural barriers, that uncertainty is low; it ignores complementors (Coyne &
  Subramaniam; Brandenburger & Nalebuff / Grove) [S3 P3]; Porter himself warns managers "define
  competition too narrowly" [S1 P1] and "industry structure changes over time, and is not static"
  [S2] — re-run on the refresh cadence (§6).
- **Attractiveness** (`market/attractiveness.csv`: factor ∈ market_size|growth_rate|profitability|
  entry_barriers|regulation|buyer_concentration, each with value, unit, source_id, reference
  period). Growth rate alone is not attractiveness (attributed to Porter 2008 — wording UNVERIFIED,
  full text paywalled; held here as policy): profitability and entry barriers are mandatory rows.
  The nine-box placement (industry attractiveness × competitive strength; above-diagonal invest
  [S15 P1]) is the human verdict on top — "judgment is required to weigh the trade-offs" [S15].
- **Why-now** (`market/why-now.csv`: `signal_id, what_changed, metric, value_before, value_after,
  date_before, date_after, source_id` — ≥ 2 signals, each with both dates and a source). Sequoia:
  "Nature hates a vacuum—so why hasn't your solution been built before now?" [S7 P1]. Gross's
  retrospective on 200 companies scored **timing at 42 %** of the success/failure difference,
  ahead of team, idea, model, funding [S14 P1] — small sample, single scorer, but the strongest
  timing evidence read. The judgement that the window is open stays human; the dated signals do
  not.

## §6 Source registry, grades, cadence and staleness

The registry is `evidence/sources.tsv` — the same 13-column ledger the evidence gates validate
(`references/evidence-protocol.md` §2: id, tier, type, year, title, venue, locator, depth, status,
retrieved_at, archived_url, content_hash, fetch_status), optionally extended with a 14th `cadence`
column (monthly|quarterly|semiannual|annual|census) that the market gate reads to WARN
"refresh due" when `retrieved_at` is older than the cadence. Reference period and publication date
travel on the **factor rows** (§3.1), because one registry row can back numbers with different
reference periods.

- **Grade ⇔ tier**: P1 ⇔ T1 (statute, agency release, publisher's own report, first-party
  dataset), P2 ⇔ T1/T2 (reputable secondary quoting a named primary), P3 ⇔ T3 (vendor marketing,
  blogs, aggregators). T4 is uncitable for market factors. A factor may be graded *below* its
  source's tier (conservative), never above it.
- **The CAPTCHA rule.** A blocked page is not a source. On 2026-09-02, `psa.gov.ph`,
  `psada.psa.gov.ph`, `openstat.psa.gov.ph`, `imf.org`, `data.adb.org`, `tandfonline.com` and
  `hbr.org` returned 403/CAPTCHA to scripted fetchers (brief 02 access note, operational finding);
  PSA/IMF content was read from Wayback snapshots. So: store the archived snapshot URL **and** the
  content hash, not just the live URL; reject a fetched body that is a CAPTCHA/verification page,
  a JS shell, or suspiciously small; `fetch_status ∈ live|archived|manual` — a human-obtained
  document is `manual` with `-` for archive and hash.
- **Aggregators.** Statista Market Insights numbers are **modeled**: top-down, bottom-up or
  hybrid; "individual sources for each data point are not always cited"; for smaller economies the
  models "leverage benchmark ratios from similar, more developed markets"; refreshed "at least
  twice a year" [S25 P1]. Library rule: cite the original source, not the aggregator [S26 P2].
  Therefore: a Statista/Euromonitor figure is P3 unless the original source is traced, cite it
  only as "modeled estimate, Statista Market Insights, <date>" — and by rule (c) it can never be
  a bottom-up unit count.
- **Staleness thresholds** (rule g): WARN > 24 months; census/LE-class WARN > 36 months;
  **fail > 60 months** — all measured against the ledger's `# as_of:` date so fixture results and
  reproduced runs never drift. Refresh on the source's cadence (annual LE/DTI, ~22-month-lagged
  ASPBI, ~5–6-year CPBI, monthly IMTS trade, quarterly BSP dashboards, annual DataReportal,
  semi-annual Statista model refresh [S29][S31][S33][S34][S25]).

## §7 PH data-source catalog (brief 02 §4.1 — grades per the brief)

| Source | What it provides | Cadence / lag | Cite as | Grade |
|---|---|---|---|---|
| PSA — List of Establishments (LE) | frame of all establishments (formal + informal) by PSIC, region, size; basis of DTI MSME counts and ASPBI/CPBI sampling frames | annual; accessed via DTI tabulations or PSA data request | "PSA, 2023 List of Establishments, as tabulated in DTI …" [S28][S29] | P1 |
| PSA — ASPBI | formal-sector establishments: counts, employment, compensation, revenue, value added, capex, e-commerce sales by PSIC/region/size | annual, ~22-month lag; final tables in OpenSTAT | PSA's own technical-notes form [S29][S30] | P1 |
| PSA — CPBI | ASPBI variables over formal + informal, census scope (2006, 2012, 2018, 2023); 2023 IOSPBI rider | every ~5–6 years | "PSA, 2023 Census of Philippine Business and Industry …" [S31][S32] | P1 |
| PSA — OpenSTAT | open PC-Axis platform + API: ASPBI tables, LFS, IMTS trade, prices, accounts; free reuse with attribution | follows each release | "PSA OpenSTAT, <table>, accessed <date>" [S33] | P1 |
| PSA — IMTS (foreign trade) | monthly exports/imports by commodity group incl. "electronic products" | monthly, ~5–6-week lag | "PSA, Highlights of Philippine Export and Import Statistics, <month>" [S46] | P1 |
| PSA — Labor Force Survey | employment by industry/occupation | monthly | "PSA, Labor Force Survey, <month year>" [S33] | P1 |
| DTI — MSME Statistics | LE tabulations: counts + employment by size, sector, region; MSME definitions | annual | "DTI (2024). 2024 Philippine MSME Statistics" [S27][S28] | P1 |
| BSP | monetary/financial/external statistics; BES/CES/CFIS surveys; Financial Inclusion Dashboard | dashboard quarterly; CFIS 2021→2025; CES/BES cadence UNVERIFIED | "BSP, <survey/dashboard>, <period>" [S38][S40][S41] | P1 |
| DOST | Compendium of S&T Statistics (R&D spend and personnel, IPR, innovation rankings) | "updated regularly", no fixed cadence stated | "DOST, Compendium of S&T Statistics, <edition>" [S47] | P1 |
| SEIPI | monthly electronics-export performance (own definition ≠ PSA's), forecasts, roadmap | monthly | "SEIPI, Philippine Electronics Export Performance, <month>" [S44][S45] | P1 site / P2 via press |
| IBPAP | IT-BPM revenue, FTE headcount, roadmap ($59B / 2.5M FTE by 2028) | annual results each January; site JS-rendered | "IBPAP (Jan 2026) results, as reported in Philstar" [S42][S43] | P2 (via press) |
| PSIA | software-industry association ("more than 160 … member companies"); events, mentoring; no published statistics found | — | "Philippine Software Industry Association, <page>, accessed <date>" [S49] | P1 (about itself) |
| PCCI | largest business organization ("10,000+ business leaders"); searchable member directory (a named list for SOM work); local chambers | annual conference | "PCCI, <document>, <date>" [S48] | P1 |
| World Bank | Philippines Economic Update (~2×/yr), poverty and growth data | semi-annual | "World Bank (2026). Philippines Economic Update, <edition>" [S35] | P1 |
| ADB | Asia SME Monitor (MSME data across 24 economies incl. PH, with data tables) | annual | "ADB (2024). Asia SME Monitor 2024. DOI 10.22617/SGP240536-2" [S37] | P1 |
| IMF | Article IV staff reports, WEO database | Article IV ~annual | "IMF (Dec 2025). Philippines: 2025 Article IV …" [S36] | P1 |
| DataReportal | Digital <year> Philippines: population, internet users, social identities, connections (Kepios/GSMA/ad-platform) | annual (Feb) + partials | "Kemp, S. (25 Feb 2025). Digital 2025: The Philippines." [S34] | P2 |
| Statista / Euromonitor | modeled market sizes ("Market Insights") | model refresh ≥ 2×/yr | "modeled estimate, Statista Market Insights, <date>" — P3 unless the original source is traced; never a unit_count [S25][S26] | P3 (as aggregator) |

## §8 Verified PH market-structure facts (copy with grade + tag, then cite as `[C-n]`)

- **Two frames, 4.4× apart:** LE 1,241,476 establishments (2024) [S27 P1] vs ASPBI formal sector
  281,825 (2022) [S29 P1]; the formal sector excludes single proprietorships without branches and
  with total employment < 10 [S29]. Every B2B count must declare its frame.
- **Micro dominates counts, large dominates money:** micro = 90.66 % of establishments but
  34.25 % of employment (DTI 2024) [S27 P1]; in the formal sector, large establishments (1.5 % of
  units) earn 50.2 % of revenue and pay 61.9 % of compensation [S29 P1]. MSMEs are 99.63 % of
  establishments and 66.58 % of employment (2024) [S27 P1].
- **Sector shape (LE 2023)** [S28 P1]: wholesale/retail 604,758 · accommodation & food 190,965 ·
  manufacturing 141,266 (1,606,152 employed) · ICT (J) 11,247 (144 large) · professional/
  scientific/technical (M) 17,217 · admin & support (N, incl. BPO) 18,661 with 1.33M employed,
  85.11 % in large firms. Hardware buyers in manufacturing: 1,086 large + 978 medium
  establishments nationally.
- **Geography (2024)** [S27 P1]: NCR 18.00 %, CALABARZON 15.41 %, Central Luzon 12.67 % of
  establishments.
- **Same-named metrics differ by definition:** electronics exports 2024 = $42.75B (SEIPI series)
  [S45 P2] vs $39.1B (PSA "electronic products") [S46 P2]; IT-BPM 2024 = $38B revenue, 1.82M FTE
  (IBPAP) [S42 P2]. Record the definition with every number.
- **Formal e-commerce is small:** ₱159.26B sales (2022), 81.7 % by large establishments [S29 P1].
- **Digital reach ≠ financial reach:** 97.5M internet users (83.8 % of 116M) and 90.8M social
  identities [S34 P2]; but only 50 % of adults own a transaction account — e-money 36 % over bank
  23 % (BSP CFIS 2025, n=8,784) [S41 P2]; 222,553 financial access points (1Q2023) [S40 P1].
- **Freshness:** ASPBI ~22-month lag; CPBI every ~5–6 years; LE/DTI annual; IMTS monthly;
  DataReportal annual; Statista model refresh ≥ 2×/yr [S29][S31][S34][S25].

## §9 What the market gates block

- A TAM/SAM/SOM figure whose factor product does not reproduce it, or whose `computed_value` was
  typed rather than computed (a).
- A factor citing a missing, rejected, unverified or T4 source; a grade above the source's tier;
  a live URL where the archive belongs; a retrieval date in the future (b).
- A bottom-up unit count from a modeled/aggregator source (P3) or denominated in identities/
  connections (c).
- SOM > SAM or SAM > TAM in any method chain, by product or by stated value (d).
- A SOM built as "x % of the market" with no named-list bottom-up anchor in the segment (e).
- A single-method layer, or methods disagreeing beyond 3.0× (f).
- A reference period past 60 months; silent decay is surfaced as WARN at 24/36 (g).
- An alternatives register with no status-quo/DIY/do-nothing row, fewer than 3 named
  alternatives, or any phantom competitor (< 2 interview ids).
- A price without a fresh (≤ 90 days), archived, hashed snapshot carrying its price metric —
  including quotes without the human who captured them.

## §10 Anti-patterns (brief 02 §7 — the guard that catches each)

| Anti-pattern | Guard | Source |
|---|---|---|
| "We just need 1 % of a $50B market" / analyst-chart TAM | (e) + (f); SOM bottom-up from a named list | Kawasaki [S9]; Forum VC [S17] |
| Big Market Delusion — every entrant assumes it wins | ≥ 3 alternatives + status quo; forces sourced | Cornell & Damodaran [S10] |
| Top-down-only sizing from one source | (f) ≥ 2 methods; (c) P1/P2 unit counts | [S17]; practitioner consensus |
| Ignoring do-nothing; 20–30 % lost to "no decision" | mandatory status_quo|diy|do_nothing row | Dunford [S8] |
| Phantom competitors from listicles | ≥ 2 interview ids per alternative | brief 03 G3.1 |
| Undated / metric-less competitor prices | snapshot ≤ 90 d + archived_url + hash + price_metric | [S23][S24] |
| Mixing frames (LE vs ASPBI, 4.4×) or metric definitions (SEIPI vs PSA exports) | charter frame + factor `note` names frame/definition | [S27][S29][S45][S46] |
| Social identities / connections as buyers | unit_count unit check (c) | DataReportal caveats [S34] |
| Citing Statista models as observed PH data | aggregator = P3; never a unit_count; cite as modeled | [S25][S26] |
| Stale data quietly compounding (ASPBI lag, CPBI cycle) | staleness 24/36/60 vs `as_of` (g); cadence "refresh due" | [S29][S31] |
| Judgmental positioning maps; post-hoc blue-ocean canvases | maps from customer data; canvas from the feature matrix | [S22][S6] |
| Growth rate treated as attractiveness | attractiveness needs profitability + entry-barrier rows | [S2][S15]; Porter 2008 (UNVERIFIED wording) |
| CAPTCHA page silently read as "the source" | fetch_status + archive + hash; reject verification pages | operational finding, brief 02 |
