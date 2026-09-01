# Governance, strategy & the board — research brief (2026-09-02)

Domain 11 of the guild body of knowledge. Scope: founders' agreement → planning cadence → board pack → decision/risk logs → kill/pivot criteria → funding options (with Philippine ecosystem facts). All numbers below come from URLs fetched on 2026-09-02; anything not fetched is marked **UNVERIFIED**. Provenance grades: **P1** primary (author/firm/agency/law), **P2** secondary (encyclopedia, publisher page, reputable press), **P3** weak (aggregator, blog summary, search snippet). Harness-specific thresholds that have no external source are labelled **harness proposal**.

---

## 1. Standard process — the ordered steps and their deliverables

| # | Step | Named deliverable | Anchor |
|---|------|-------------------|--------|
| 1 | **Founders' agreement** before any outside money or IP is created in earnest: equity split (YC default: equal — "If you aren't willing to give your partner an equal share, then perhaps you are choosing the wrong partner"), 4-year vesting with 1-year cliff (25% at the cliff, then 1/48 per month), roles, decision rights, IP assignment, departure terms. | `founders-agreement.yaml` (signed PDF + machine-readable summary) | [3] P1; Wasserman: "People problems are the leading cause of failure in startups" [19] P1 |
| 2 | **Strategy kernel** — one page: diagnosis, guiding policy, coherent actions (Rumelt); plus a Lean Canvas (Maurya) time-boxed, not polished. | `strategy-kernel.md`, `lean-canvas.md` | [28] P2, [11][12] P1 |
| 3 | **North Star + KPI tree** — pick the "game" (attention / transaction / productivity), one North Star, 3–5 input metrics. | `kpi-tree.yaml` | [7] P1 |
| 4 | **Pre-committed kill/pivot criteria** — numeric thresholds with decide-by dates, written *before* the quarter starts. | `kill-criteria.csv` | PG default-alive [1] P1; Ries pivot [25] P1 |
| 5 | **Planning cadence** — annual OKRs + quarterly OKRs (3–5 objectives, ~3 KRs each), graded 0.0–1.0 at quarter end; monthly written update; weekly metric refresh. | `okrs/<year>-Q<n>.yaml` | [5][6] P1 |
| 6 | **Advisory board → board of directors.** Pre-priced-round companies on SAFEs have no board-seat obligation ("SAFEs carry no board seats; investors who want one negotiate a side letter" [23] P3); start with an advisory board on FAST terms (2-year vest, 3-month cliff) and a self-imposed board cadence. | `board-roster.yaml`, advisor agreements | [21] P1, [22] P2 |
| 7 | **Board pack** every 6–12 weeks (Sequoia: "four to six times per year", materials "one to two days in advance"), generated from ledgers, not hand-written. | `board-pack/<date>.md` | [4] P1 |
| 8 | **Decision log (ADR-style) + pre-mortem** for every decision with money/legal effect or one-way-door character; statuses proposed → accepted → deprecated/superseded, numbered monotonically, never deleted. | `decisions/ADR-NNN.md` | [13][14] P1; [15][16] |
| 9 | **Risk register** with owner, trigger, probability × impact score, reviewed each board cycle. | `risk-register.csv` | [33] P2 |
| 10 | **Funding decision** (bootstrap / RBF / grant / angel / VC / loan / SAFE) recorded as an ADR; every instrument issued requires a human signature — SAFEs also require board approval [2] P1. | `ADR-funding-*.md` + signed instruments | [2] P1, [34] P1, [35][36] P1 |

---

## 2. Frameworks & methods

| Framework | Originator | Produces | When to use | Known critiques |
|-----------|-----------|----------|-------------|-----------------|
| **Founders' equity + vesting** | YC (Seibel et al.) [3] P1; Wasserman [18][19][20] | Split, 4y/1y-cliff schedule, departure mechanics | Day 0, before incorporation is finalised | Equal split can under-reward disproportionate contribution; Wasserman's "rich vs king" trade-off (control vs. value) is never resolved once, it recurs at every hire/raise [20] P2 |
| **Rich vs King** | Noam Wasserman, HBR 2008 (212 startups) [18] P1; book on ~10,000 founders / 3,500 startups [19] P1, [20] P2 | Explicit control-vs-wealth preference per founder | Before first outside investor, before hiring a CEO | Stats on founder-CEO replacement rates are widely quoted but the HBR body was not retrievable — **UNVERIFIED** here |
| **SAFE (post-money)** | YC, created 2013 (Carolynn Levy), post-money standard since 2018 [2] P1 | Investment now for equity later; no interest, no maturity | Pre-priced-round angel money | Ownership math is only "transparent" if founders run it: "$500k on a $6.7M post-money cap is about 7.5%, and $1M on the same cap is about 15%" [2]; stacking SAFEs compounds dilution |
| **Advisory board / FAST** | Founder Institute [21] P1 | Advisor grants by stage: Standard 0.50% / 0.25% / 0.10% and Expert 1.00% / 0.75% / 0.50% for pre-seed / seed / Series A; 2-year vest, 3-month cliff | When founders lack domain/market experience (this studio) | Advisors are not fiduciaries; FI recommends 1 month and ≥8 hours of working together *before* signing |
| **Board of directors** | Blumberg (Startup Boards) [22] P2; Sequoia [4] P1 | Oversight + strategy; at early stage "less than 5% of its time on governance … 95% … on strategy and product market fit"; size 3–7 | From the first priced round, or self-imposed earlier | A board without independent directors is a founder mirror; "four times a year face to face with the firing squad" [22] |
| **Board pack (Sequoia)** | Sequoia Capital [4] P1 | Big picture (15 min) → calibration exhibits (45–60) → company building (30) → working sessions (30/topic) → closed session (15); memos allowed | Every board cycle | Deck-building consumes founder time; Sequoia's answer is pre-reads so the meeting is "discussing rather than presenting" |
| **OKRs** | Grove → Doerr [6] P1; Google re:Work [5] P1 | 3–5 objectives, ~3 KRs each, scored 0.0–1.0; "sweet spot" 60–70%; annual + quarterly | From first quarter of operations | Scores of 100% mean goals were not ambitious; risk of OKR theatre if KRs are activities, not outcomes |
| **North Star + inputs** | Amplitude / Sean Ellis [7] P1 | One metric that "aligns to customer value", "represents product strategy", is a "leading indicator"; 3–5 input metrics; three games: attention, transaction, productivity | Once a product/service exists to measure | Vanity metrics (DAU, registrations) masquerade as North Stars [7]; a services or hardware business must translate "product engagement" into delivered value |
| **AARRR** | Dave McClure, 2007 deck [24] P1 | Funnel: Acquisition → Activation → Retention → Referral → Revenue with per-stage conversion % | Any business with a repeatable funnel | Built for consumer web; example numbers ("70% … Email/Blog/RSS/Widget Signup", "2% … Repeat Visitor") are illustrative, not benchmarks |
| **Default alive / default dead** | Paul Graham [1] P1 | Binary trajectory verdict from cash, burn, growth: "Assuming their expenses remain constant and their revenue growth is what it has been over the last several months, do they make it to profitability on the money they have left?" | "start asking too early" — PG says the question becomes relevant around 8–9 months in | Assumes constant expenses; services revenue is lumpy so growth must be smoothed over "the last several months" |
| **Pivot vs persevere** | Eric Ries [25] P1, [26] P2 | "a structured course correction designed to test a new fundamental hypothesis about the product, strategy, and engine of growth" [26]; 2009 post names segment, customer-problem and feature pivots [25] | When the solution team is "chronically frustrated" across cycles [25] | The 10-type pivot catalog is in the 2011 book, not retrievable online here — **UNVERIFIED** list; Ries's own gate is qualitative: "If and only if we can't find any market for our current vision is it appropriate to change it" |
| **PMF survey (40%)** | Sean Ellis; retold by First Round [27] P2 | "How would you feel if you could no longer use the product?" → ≥40% "very disappointed" | After ≥1 cohort has used the product/service | Benchmarked on "nearly a hundred startups" (consumer/SaaS); small-N services businesses need interviews, not surveys |
| **Lean Canvas** | Ash Maurya, 2010 [11][12] P1 | 1-page model; replaces BMC's Key Partners / Key Activities / Key Resources / Customer Relationships with Problem / Solution / Key Metrics / Unfair Advantage | Idea stage; time-box it | Maurya: "pursuing key partnerships from day one can be a form of waste" [12] — the canvas deliberately ignores partners |
| **Business Model Canvas** | Osterwalder (2004 thesis) & Pigneur (2010 book) [9][10] | 9 blocks: Customer Segments, Value Propositions, Channels, Customer Relationships, Revenue Streams, Key Resources, Key Activities, Key Partnerships, Cost Structure [10] P2 | Once a model exists to describe | "static", "does not capture changes in strategy", isolates the firm from industry structure [10] |
| **Strategy kernel** | Richard Rumelt, 2011 [28] P2 | Diagnosis → guiding policy → coherent action | Any planning cycle; before OKRs | Bad strategy = "fluff, excessively complex language, and the conflation of goal-setting with strategy" [28] |
| **Playing to Win (5 choices)** | Lafley & Martin, 2013 [29] P1 | "a set of five interrelated and powerful choices that positions an organization to win" [29] (commonly: winning aspiration, where to play, how to win, capabilities, management systems — wording **UNVERIFIED** online) | When choosing segment/offer | Built from P&G-scale cases; for a two-founder studio it collapses into "where to play" |
| **SWOT** | Origin disputed: Harvard 1965 textbook vs SRI "SOFT" 1965 [31] P2 | Four lists | Rarely; only as input to a diagnosis | "No-one subsequently used the outputs … within the later stages of the strategy"; unprioritised lists; dominated by loud voices [31] |
| **Porter generic strategies** | Michael Porter 1980/1985 [30] P2 | Cost leadership / differentiation / focus | Choosing how to compete in a segment | "Stuck in the middle" contested; hybrid strategies shown to work (Miller 1992) [30] |
| **7 Powers** | Hamilton Helmer [32] P3 | Power = benefit + barrier; scale economies, network economies, counter-positioning, switching costs, branding, cornered resource, process power | Deciding whether an advantage is durable | Summary source only; timing-by-stage not verified |
| **ADR / decision log** | Michael Nygard 2011 [13] P1; adr.github.io [14] P1 | Title, Context, Decision, Status, Consequences; statuses proposed/accepted/deprecated/superseded; "Numbers will not be reused"; superseded records kept | Every material decision | Consequences must list "positive, negative, and neutral" — most teams list only positives |
| **Pre-mortem** | Gary Klein, HBR 2007 [15] P1, [16] P2, [17] P1 | Assume the plan "has just failed" and list why; runs "after a team has been briefed on a plan" [17] | Before any irreversible decision | The often-quoted "30%" prospective-hindsight gain (Mitchell, Russo, Pennington 1989) could not be fetched — **UNVERIFIED** |
| **Risk register** | PMBOK / PRINCE2 / ISO 31000 [33] P2 | ID, category, description, probability, impact, score = p × i, trigger, owner, mitigation, contingency | Continuous; reviewed each board cycle | Becomes a graveyard without owners, triggers, and review dates |
| **Revenue-based financing** | Lighter Capital (vendor) [34] P1 | Loan repaid as a % of monthly revenue to a cap "expressed as 1.x" (example 1.2×); no equity, no personal guarantee, no board seat | Only with recurring revenue "at least $15K a month or $200K a year, and growing", gross margin ">50%", 12–18 months runway [34] | Vendor terms; PH availability **UNVERIFIED** |

---

## 3. Numbers annex

| Metric | Benchmark / threshold | Context | Source URL | Grade | Retrieved |
|--------|----------------------|---------|-----------|-------|-----------|
| Founder vesting | 4 years, 1-year cliff; 25% at cliff then 1/48 monthly | "typical Valley arrangement" | https://www.ycombinator.com/blog/splitting-equity-among-founders | P1 | 2026-09-02 |
| Time to build a valuable company | "7 to 10 years" | Why early contribution differences don't justify unequal splits | same | P1 | 2026-09-02 |
| Wasserman dataset | 212 startups (HBR 2008); ~10,000 founders / 3,500 startups (book) | Founder's Dilemma(s) | https://hbr.org/2008/02/the-founders-dilemma ; https://en.wikipedia.org/wiki/Noam_Wasserman | P1 / P2 | 2026-09-02 |
| SAFE ownership math | $500k on $6.7M post-money cap ≈ 7.5%; $1M ≈ 15% | Post-money SAFE (standard since 2018) | https://www.ycombinator.com/documents | P1 | 2026-09-02 |
| SAFE discount | "Typically 10–20%" | Discount-only SAFE variant | same | P1 | 2026-09-02 |
| SAFE prerequisites | Board approval; accredited investors; side letter for pro rata | Company obligations | same | P1 | 2026-09-02 |
| Advisor equity (FAST) | Standard 0.50 / 0.25 / 0.10 %; Expert 1.00 / 0.75 / 0.50 % (pre-seed / seed / Series A); 2-year vest, 3-month cliff | Founder Institute FAST v3 | https://fi.co/fast | P1 | 2026-09-02 |
| Advisor trial | ≥1 month and ≥8 hours together before signing | FAST guidance | same | P1 | 2026-09-02 |
| Board meeting cadence | "four to six times per year"; materials "one to two days in advance" | Sequoia | https://articles.sequoiacap.com/preparing-a-board-deck | P1 | 2026-09-02 |
| Board meeting time budget | 15 / 45–60 / 30 / 30-per-topic / 15 minutes (≈3 h) | Sequoia section timings | same | P1 | 2026-09-02 |
| Early-stage board attention | "<5% governance … 95% strategy and product market fit"; size 3–7; "four times a year" | Blumberg | https://onboardspodcast.com/22-matt-blumberg/ | P2 | 2026-09-02 |
| Director vesting (early) | "one-year vest … two-year vest" rather than 4 years | Blumberg | same | P2 | 2026-09-02 |
| Seed board norms | Quarterly meetings + monthly written updates; ~90% of pre-seed rounds on SAFEs; ~20% of seed cos reach Series A in 2 years; 35–40% need extension capital; Series A bar ≈ $3.5M ARR | Secondary citing Carta (Peter Walker) | https://www.pmf.show/blog/seed-stage-board-meeting | P3 | 2026-09-02 |
| OKR shape | 3–5 objectives, ~3 KRs each | Google re:Work | https://rework.withgoogle.com/en/guides/set-goals-with-okrs | P1 | 2026-09-02 |
| OKR score sweet spot | 0.6–0.7 on a 0.0–1.0 scale; consistent 1.0 = not ambitious | Google re:Work | same | P1 | 2026-09-02 |
| OKR cadence | Annual + quarterly; company-wide quarterly grading | Google; Doerr: quarterly cycle | same; https://www.whatmatters.com/faqs/okr-meaning-definition-example | P1 | 2026-09-02 |
| North Star inputs | "three to five" input metrics | Amplitude | https://amplitude.com/blog/product-north-star-metric | P1 | 2026-09-02 |
| Example North Stars | "Number of mobile orders delivered"; "Trial accounts with >3 users active in week 1"; Facebook "7 friends in 10 days" | Amplitude | same | P1 | 2026-09-02 |
| PMF survey threshold | ≥40% "very disappointed"; benchmarked on "nearly a hundred startups"; Superhuman 22% → 58% | Sean Ellis via First Round | https://review.firstround.com/how-superhuman-built-an-engine-to-find-product-market-fit/ | P2 | 2026-09-02 |
| Default-alive timing | Ask ~8–9 months in; "start asking too early" | Paul Graham | https://paulgraham.com/aord.html | P1 | 2026-09-02 |
| Investor-interest growth | "steep revenue growth, say over 5x a year" (and even then unreliable) | Paul Graham | same | P1 | 2026-09-02 |
| Biggest killer of funded startups | "overhiring is by far the biggest killer of startups that raise money" | Paul Graham | same | P1 | 2026-09-02 |
| AARRR example funnel | Activation 70% (signup) / 30% (account); Retention 2% (3+ visits in 30 days); Referral 1–2%; Revenue 1% break-even | McClure deck (illustrative) | https://www.slideshare.net/dmc500hats/startup-metrics-for-pirates-long-version | P1 | 2026-09-02 |
| RBF eligibility | ≥$15K MRR or $200K ARR and growing; gross margin >50%; 12–18 months runway; cap example 1.2× | Lighter Capital | https://www.lightercapital.com/revenue-based-financing | P1 (vendor) | 2026-09-02 |
| ADR size | "one or two pages"; numbered monotonically; never reuse numbers | Nygard | https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions.html | P1 | 2026-09-02 |
| Risk score | Score = probability × impact (integer scales) | PMBOK-derived | https://en.wikipedia.org/wiki/Risk_register | P2 | 2026-09-02 |
| PH VC funding | $1.12B in 2024 (vs $440M in 2019); PH = 19% of SEA funding (2% in 2021); 20% of SEA population, 13% of funding over 3 years; GDP 5.7% vs 4.9% regional (2024) | Foxmont | https://foxmontcapital.com/insights/foxmont-secures-30m-first-close-for-fund-iii | P1 (fund's own claims) | 2026-09-02 |
| PH equity funding H1 2025 | "$86.4 million (down 55 percent YoY)" | Kickstart Q&A | https://technode.global/2026/02/12/kickstart-ventures/ | P2 | 2026-09-02 |
| PH deal trend 2023 | Deals +53% vs 2022; deal size −70%; rounds −60%; govt funding $11.4M as of 2023 | Gobi-Core report via press | https://theindependentinvestor.ph/updated-gobi-core-philippine-fund-report-highlights-53-increase-in-ph-startup-deals/ | P3 | 2026-09-02 |

---

## 4. Philippine specifics — verified funding ecosystem facts

**Law.** RA 11337, the Innovative Startup Act, approved 26 April 2019 [35] P1. Defines a startup as "any person or registered entity in the Philippines which aims to develop an innovative product, process, or business model" and creates: the Philippine Startup Development Program; a **Startup Grant Fund** under DOST, DICT and DTI to "provide initial and supplemental GIA for startups and startup enablers"; a **Startup Venture Fund** administered by DTI with the National Development Company to "match investments by selected investors in startups"; startup visas (five-year validity; interim visas "for six (6) months to one (1) year"); "full or partial subsidy for the registration and cost in the application and processing of permits"; and event-participation subsidies. The IRR is dated 06 October 2021 (DOST download page) [46] P1 — its text was not parseable, so per-agency SGF eligibility is **UNVERIFIED** here. The widely repeated DICT SGF range of PHP 500,000–1,000,000 per grant appeared only in a search snippet (page returned 403) — **UNVERIFIED**.

**Startup Venture Fund (NDC/DTI)** [36][37] P1. Allocation "US$10 Million (PHP500 Million)" as of 17 Feb 2023 [37]. Accredited Co-Investment Partners: Gobi Partners, Foxmont Capital Partners, Kaya Founders, Ideaspace Ventures, UntroD Capital Asia, Indelible Ventures, AHG Lab, ICCP SBI Venture Partners [36]. Rule: "A Co-Investment Partner is needed before an investment can be made" and "The SVF cannot invest alone and cannot be the lead investor". Startup eligibility: an existing MVP and/or innovative business model; "Based and registered in the Philippines"; no pending government accountability and full disclosure of other government funding; "at least one (1) year of operating track record". Timeline: mandate 2019, public launch 2021, investment committee April 2022, first beneficiaries 2024 [36]. Matching ratio and per-startup cap: not published — **UNVERIFIED**.

**DTI SB Corp loans** [43] P1 (program page), [44] P2 (Philstar, 19 Jan 2025):
- *Business Expansion Financing*: PHP 50,000–3,000,000; "0% interest for the first 12 months; 1% per month based on diminishing balance"; up to 3 years plus up to 6 months grace; eligibility "3 to 11 months of business operation (at least three (3) months of proven sale)"; Philstar reports a P1 billion allocation and documentary requirements (mayor's permit, DTI/SEC registration, government ID, bank account, business plan).
- *Purchase Order Financing*: up to 80% of the PO, max PHP 20,000,000; 1% per 30-day period; 30–360 days; "at least one (1) year of business operation with minimum of at least three (3) consummated Purchase Orders"; P500 million allocation per Philstar.
- *Enterprise Rehabilitation Financing*: up to PHP 300,000; interest-free year 1, 1%/month years 2–3.
- *Venture Capital Program*: PHP 500,000–5,000,000 equity-type investment, 5–10 years, "Duly registered MSME" as a "corporation" (not sole proprietorship).
Collateral terms are not stated on the program page — **UNVERIFIED**.

**Angels — Manila Angel Investors Network (MAIN)** [38] P1: SEC-registered non-stock non-profit; "MAIN invests in pre-seed, Seed and Series A rounds"; "100 Members", "30+ Portfolio Companies", "500+ Startups Screened"; impact focus (financial inclusion, employment, education; women-led SMEs). Ticket sizes: not published — **UNVERIFIED**.

**VC — Kickstart Ventures (Globe/Ayala)** [39] P2: three funds including the Ayala Corporation Technology Innovation Venture Fund (ACTIVE); 2026 plan = strengthen portfolio, "selective early-stage investing, with a focus on AI beyond Southeast Asia", and corporate-partnership value; first ACTIVE exit (SlashNext → Varonis, Q3 2025). Check sizes and the "~70 companies" figure surfaced only in search snippets — **UNVERIFIED**.

**VC — Foxmont Capital Partners** [40] P1: Fund III first close $30M on 1 Aug 2025, anchored by the Dutch Good Growth Fund; Fund III "more than doubl[ed] its assets under management"; targets "up to eight high-conviction deals annually"; "early growth" stage, expanding to growth. SVF-accredited CIP [36].

**VC — Gobi-Core Philippine Fund** [37][45]: Core Capital × Gobi Partners JV founded 2018, co-sponsored by Alibaba Global Initiatives [45] P3; first SVF Co-Investment Partner (Feb 2023) [37] P1. Fund size "$10 million" appeared only in a search snippet — **UNVERIFIED**.

**IdeaSpace** [41] P1: est. 2012 by Manny V. Pangilinan; backed by First Pacific, MPIC, PLDT-Smart, Meralco, Maynilad. Accelerator: "$10K USD for 1% equity", "3-month accelerator from August to October", "five pre-seed startups close to or just securing their first revenues"; Opportunity Fund (year-round) for "post-revenue startups with at least six months of traction, month-on-month growth in revenues"; HALO Fund for early-stage. Non-equity grant amounts seen in snippets — **UNVERIFIED**.

**QBO Innovation Hub** [42] P1: "a division of Ideaspace"; founding partners DTI, DOST, IdeaSpace, J.P. Morgan; programs WORQSHOP (workshops), SHOWQASE (investor pitch), QLITAN (networking), BASIQS (intro classes), INQBATION (J.P. Morgan incubation), Startup Pinay. A "PHP 2B fund for 200 deep-tech startups" claim circulating on an aggregator is absent from QBO's own site — **UNVERIFIED, treat as false until QBO publishes it**.

**DOST-TBI / DOST SGF**: DOST and DICT pages returned 403 during this run; no verified ticket sizes. **UNVERIFIED** — re-fetch before the harness cites them.

Implication for a two-founder engineering studio: the only money that does not require ≥1 year of operating history or a prior lead investor is SB Corp Business Expansion (3–11 months of operation, ≥3 months of sales) and angel/accelerator money (MAIN, IdeaSpace at $10K/1%). SVF and PO financing become reachable at month 12 with an MVP and three fulfilled POs.

---

## 5. Mechanical gate candidates

### 5.1 Board pack schema (generated, not written)

| Section (Sequoia order [4]) | Derived from ledger | Mechanical check |
|---|---|---|
| A. Big picture: CEO narrative, highlights, lowlights, "where the company needs help" | `narrative.md` (human) | present; ≥3 highlights, ≥3 lowlights, ≤3 asks (asks count per [23] P3) |
| B1. KPIs vs plan | `kpi_actuals.csv` × `plan.csv` | every KPI row has actual, plan, variance %, trend; North Star + 3–5 inputs present [7] |
| B2. Cash & runway | `cash_ledger.csv` (bank balance, monthly in/out) | runway_months = cash / avg 3-month net burn; **default-alive flag** per PG's definition [1] |
| B3. Pipeline | `pipeline.csv` (opportunity, stage, value, next step, date) | weighted pipeline ÷ next-quarter revenue plan (coverage ratio); stale rows (no update >30 days) counted |
| B4. Product/delivery | `milestones.csv` | on-time % vs committed dates |
| B5. People | `headcount.csv`, `hiring_plan.csv` | headcount vs plan; "monthly waterfalls for revenue, burn, cash balance, headcount" [4] rendered automatically |
| B6. Risks | `risk_register.csv` | top-5 by score; every row has owner + trigger + review date ≤ 30 days old |
| B7. Decisions & asks | `decisions/ADR-*.md` with status=proposed | each has owner, decide-by date, money/legal flag |
| C. Company building: roadmap, org chart | `roadmap.md`, `org.yaml` | present, dated |
| D. Closed session | — | cannot be mechanized (feedback to founders) |

Staleness gate: the pack fails if any source ledger's last-modified date is older than 31 days at generation time, or if the pack is not generated ≥48 h before the meeting (Sequoia: "one to two days in advance" [4]).

### 5.2 Default-alive computation (PG [1], mechanized)

Inputs: `cash_now`, `burn_avg_3m` (net), `rev_growth_rate` (compound monthly rate from "the last several months" — use 3–6 months), `expenses` held constant. Simulate month by month; output `DEFAULT_ALIVE` if revenue ≥ expenses before cash < 0, else `DEFAULT_DEAD` with `months_to_zero`. Harness proposal: recompute monthly from month 6 (PG: ~8–9 months but "start asking too early"); a `DEFAULT_DEAD` verdict with `months_to_zero ≤ 6` auto-opens a "fatal pinch" ADR (PG: "default dead + slow growth + not enough time to fix it") that must be accepted by a human.

### 5.3 KPI tree schema

```
kpi-tree.yaml
  game: attention | transaction | productivity        # Amplitude [7]
  north_star: {name, unit, source_ledger, column, direction}
  inputs: [3..5] × {name, unit, source_ledger, column, direction, owner}
  funnel: AARRR stages × {metric, source}             # McClure [24]
```
Harness proposal examples (Amplitude's three-game framing; no external benchmark):
- *Engineering services studio (productivity game)*: North Star = **accepted-milestone revenue per month**; inputs = qualified leads/month, proposal win rate, billable utilisation, milestone first-pass acceptance rate, repeat/expansion revenue share.
- *Hardware product (transaction game)*: North Star = **units commissioned and reporting in the field per month**; inputs = units shipped, week-1 activation rate, RMA rate, gross margin per unit, reorder rate.

### 5.4 Decision log (ADR) columns

`id` (monotonic, never reused) · `date` · `title` (short noun phrase) · `status` (proposed | accepted | deprecated | superseded-by:id) · `context` · `decision` ("We will …") · `consequences` (positive, negative, neutral) [13] · `owner` · `money_or_legal_effect` (bool → human gate) · `reversibility` (one-way | two-way; practitioner consensus) · `premortem_ref` · `review_date` · `outcome` (filled at review). Mechanical checks: no status other than the four; superseded records retained; every `money_or_legal_effect=true` ADR has a signed-approval artifact before status=accepted; every one-way-door ADR has a pre-mortem with ≥5 failure reasons each linked to a risk-register row.

### 5.5 Risk register columns

`id` · `category` · `description` · `probability` (1–5) · `impact` (1–5) · `score` (= p × i) · `trigger` · `owner` · `mitigation` · `contingency` · `status` · `last_reviewed` · `next_review` [33]. Gates: no row without owner or trigger; `next_review` ≤ 30 days after `last_reviewed`; rows with score ≥ 16 must appear in the board pack.

### 5.6 OKR file and grading

`objective` · `kr` · `baseline` · `target` · `current` · `score` (0.0–1.0) · `graded_on`. Gates: 3–5 objectives, ≤5 KRs each [5][6]; quarter-end grading present; average score in 0.6–0.7 is "sweet spot" [5] — flag ≥0.9 average as "targets too easy", ≤0.3 as "re-plan".

### 5.7 Pre-committed kill/pivot criteria (numeric rows, decided before the period)

| Row | Metric | Threshold | Decide-by | Action if breached | Source |
|---|---|---|---|---|---|
| K1 | default_alive flag | DEFAULT_DEAD and months_to_zero ≤ 6 | monthly | fatal-pinch ADR: cut expenses or raise; hiring freeze | PG [1] P1; 6-month figure = harness proposal |
| K2 | PMF survey | <40% "very disappointed" with ≥40 responses | end of quarter | pivot review (segment / customer-problem / feature) | Ellis via [27] P2; N=40 = harness proposal |
| K3 | paying customers | 0 signed, paid invoices by date D | D set at plan time | stop build, restart discovery | Ries "no market for our current vision" [25] P1 (qualitative); date rule = practitioner consensus ("states and dates", Annie Duke, **UNVERIFIED** quote) |
| K4 | pipeline coverage | weighted pipeline < 2× next-quarter plan | monthly | marketing/sales sprint before any hire | harness proposal |
| K5 | gross margin | below plan floor for 2 consecutive months | monthly | pricing/scope ADR | harness proposal |
| K6 | OKR average | <0.3 two quarters running | quarter end | strategy-kernel rewrite | Google scale [5]; 0.3 = harness proposal |
| K7 | hiring | headcount > plan | monthly | block until DEFAULT_ALIVE | PG: overhiring "biggest killer" [1] P1 |

### 5.8 Founders'-agreement gate (blocks the first external-money step)

`founders-agreement.yaml` must have non-null: `split` (sums to 100%), `vesting_years=4`, `cliff_months=12` (YC default [3]; deviations require an ADR), `ip_assigned_to_company=true`, `roles`, `decision_rights` (list of decisions needing unanimity), `departure_terms`, `signed_date`, `signed_pdf`. Cap-table file must reconcile with the vesting schedule each month.

### 5.9 What cannot be mechanized

- Whether to pivot (Ries's test is judgment about "frustration" and "market" [25]); the script can only force the conversation.
- Rich-vs-king preferences and founder conflict (Wasserman [19][20]).
- Quality of the diagnosis in the strategy kernel (Rumelt [28]) — a script can check presence and length, not truth.
- Any issuance of SAFEs/shares/loans, advisor grants, or director appointments (money/legal → human-gated; SAFEs need board approval [2]).
- The board's closed session and feedback to founders [4].

---

## 6. Early irreversibles

1. **Equity split and vesting terms** — fixed at founding; YC's cliff exists precisely so a mistake can be fixed "without harm in year one" [3]; after that, unwinding requires buy-backs or litigation.
2. **IP assignment to the company** — must precede first customer deliverable; retrofitting requires every contributor's signature (practitioner consensus; Cooley/Orrick forms not retrievable).
3. **Corporate form and registration** — SB Corp's Venture Capital Program requires a corporation, "not sole proprietorship" [43]; SVF requires "Based and registered in the Philippines" [36]; the PH ecosystem clock (≥1 year track record for SVF and PO financing) starts at registration.
4. **First SAFE valuation cap** — post-money math is permanent: "$500k on a $6.7M post-money cap is about 7.5%" [2]; stacking caps compounds dilution before a priced round.
5. **Board composition and control terms** — Wasserman's rich-vs-king trade-off is decided de facto by the first board seat or protective provision [20].
6. **Advisor grants without a cliff** — FAST's 3-month cliff exists so "unproductive relationships can be ended within the initial three months without equity allocation obligations" [21].
7. **North Star choice** — Amplitude devotes a playbook chapter to "changing your North Star" [8]; every KPI tree, OKR and board exhibit is rebuilt when it changes.
8. **Hiring ahead of default-alive** — PG: "overhiring is by far the biggest killer of startups that raise money" [1]; payroll is the least reversible expense.

---

## 7. Failure modes / anti-patterns the harness must guard against

| Anti-pattern | Guard | Source |
|---|---|---|
| Asking "default alive?" too late; entering the "fatal pinch" | K1 monthly recompute from month 6 | PG [1] P1 |
| Overhiring after a raise | K7 headcount vs plan blocked unless DEFAULT_ALIVE | PG [1] P1 |
| Handshake equity split with no vesting/cliff | 5.8 gate before external money | YC [3] P1 |
| Founders who never state rich-vs-king preference, then fight at the first investor | founders-agreement `decision_rights` + `departure_terms` required | Wasserman [18][19][20] |
| Vanity North Star (DAU, registrations) | KPI tree must declare the "game" and value-realisation event | Amplitude [7] P1 |
| OKR sandbagging (all 1.0) or activity KRs | 5.6 score-band flags | Google re:Work [5] P1 |
| "Strategy" that is fluff or a goal list | strategy-kernel.md must contain diagnosis / guiding policy / coherent actions sections | Rumelt [28] P2 |
| SWOT lists that feed nothing | SWOT allowed only as an input section of the diagnosis | [31] P2 |
| Chasing key partnerships before a validated problem | Lean Canvas (no partners box) is the idea-stage canvas | Maurya [12] P1 |
| Board meeting as presentation, deck as founder-time sink | pack auto-generated from ledgers; pre-read gate 48 h | Sequoia [4] P1 |
| Early board spending its time on governance instead of strategy/PMF | agenda template weights working sessions | Blumberg [22] P2 |
| Modifying the SAFE text instead of using a side letter | instrument must be an unmodified YC form + side letter | YC [2] P1 |
| Advisor equity granted on day 1 without trial | FAST trial (≥1 month, ≥8 h) + 3-month cliff | [21] P1 |
| "Jumping to a new vision" instead of a grounded pivot | pivot ADR must name the retained learning and pivot type | Ries [25] P1 |
| Dissent suppressed in planning | mandatory pre-mortem on one-way-door ADRs | Klein [15][17] P1 |
| Risk register without owner/trigger/review date | 5.5 gates | [33] P2 |
| Rewriting or deleting old decisions | ADR numbers never reused; superseded kept | Nygard [13] P1 |
| Planning on government money as lead | SVF "cannot be the lead investor"; needs a CIP first | NDC [36] P1 |
| Treating aggregator claims (e.g., "PHP 2B QBO fund") as facts | Section 4 verification rule: org's own site or gazette only | this brief |
| Mistaking secondary "benchmarks" (Series A ≈ $3.5M ARR, 20% seed→A) for PH-relevant thresholds | P3 rows are context only, never gates | [23] P3 |

---

## 8. Sources (all retrieved 2026-09-02)

1. Paul Graham, "Default Alive or Default Dead?" — https://paulgraham.com/aord.html — essay (P1) — definition, timing, fatal pinch, overhiring, 5×/yr remark.
2. Y Combinator, "Startup Documents / SAFE" — https://www.ycombinator.com/documents — primary (P1) — SAFE history (2013, post-money 2018), variants, cap math, side letters, board approval.
3. Y Combinator blog, "How to Split Equity Among Co-Founders" — https://www.ycombinator.com/blog/splitting-equity-among-founders — primary (P1) — equal split, 4y/1y cliff, 1/48 monthly, 7–10 years.
4. Sequoia Capital, "Preparing a Board Deck" — https://articles.sequoiacap.com/preparing-a-board-deck — primary (P1) — cadence, pre-read timing, section structure and minutes, waterfalls.
5. Google re:Work, "Set goals with OKRs" — https://rework.withgoogle.com/en/guides/set-goals-with-okrs — primary (P1) — 3–5 objectives, 0–1 scale, 60–70% sweet spot, annual+quarterly.
6. What Matters (John Doerr), OKR FAQ — https://www.whatmatters.com/faqs/okr-meaning-definition-example — primary (P1) — formula, quarterly cycle, scoring methods.
7. Amplitude, "What is a North Star Metric?" — https://amplitude.com/blog/product-north-star-metric — primary (P1) — three criteria, three games, 3–5 inputs, examples.
8. Amplitude, North Star Playbook (table of contents) — https://amplitude.com/north-star — primary (P1, TOC only) — chapter on changing the North Star.
9. Strategyzer, "The Business Model Canvas" — https://www.strategyzer.com/library/the-business-model-canvas — primary (P1) — creator, purpose.
10. Wikipedia, "Business Model Canvas" — https://en.wikipedia.org/wiki/Business_Model_Canvas — secondary (P2) — nine blocks, 2004/2010 dates, critiques.
11. Ash Maurya / LEANSTACK, "Lean Canvas" — https://leanspark.ai/leancanvas — primary (P1) — 2010, four swapped boxes, time-boxing.
12. Ash Maurya, "Why Lean Canvas vs Business Model Canvas?" — https://ashmaurya.com/blog/why-lean-canvas-versus-business-model-canvas — primary (P1) — rationale per swapped box, partnerships-as-waste quote.
13. Michael Nygard, "Documenting Architecture Decisions" (2011) — https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions.html — primary (P1) — ADR template, statuses, numbering rules.
14. ADR GitHub organisation — https://adr.github.io/ — primary (P1) — ADR/decision-log definitions.
15. Gary Klein, "Performing a Project Premortem", HBR Sept 2007 — https://hbr.org/2007/09/performing-a-project-premortem — primary (P1, abstract only) — definition, purpose.
16. Wikipedia, "Pre-mortem" — https://en.wikipedia.org/wiki/Pre-mortem — secondary (P2) — "patient has died" framing, Mitchell/Russo/Pennington 1989 attribution.
17. Gary Klein, "Premortem" — https://www.gary-klein.com/premortem — primary (P1) — procedure timing.
18. Noam Wasserman, "The Founder's Dilemma", HBR Feb 2008 — https://hbr.org/2008/02/the-founders-dilemma — primary (P1, abstract only) — 212-startup dataset.
19. Princeton University Press, *The Founder's Dilemmas* — https://press.princeton.edu/books/paperback/9780691158303/the-founders-dilemmas — publisher (P1) — ~10,000 founders, "people problems" quote, dilemma list.
20. Wikipedia, "Noam Wasserman" — https://en.wikipedia.org/wiki/Noam_Wasserman — secondary (P2) — rich vs king, 10,000 founders / 3,500 startups.
21. Founder Institute, FAST Agreement — https://fi.co/fast — primary (P1) — advisor equity grid, 2-year vest, 3-month cliff, trial period.
22. On Boards Podcast ep. 22, Matt Blumberg — https://onboardspodcast.com/22-matt-blumberg/ — secondary transcript (P2) — 5%/95% split, board size, cadence, director vesting.
23. PMF.show, "Seed Stage Board Meeting" — https://www.pmf.show/blog/seed-stage-board-meeting — secondary citing Carta (P3) — SAFE/no board seat, quarterly + monthly, seed→A statistics.
24. Dave McClure, "Startup Metrics for Pirates" (SlideShare) — https://www.slideshare.net/dmc500hats/startup-metrics-for-pirates-long-version — primary (P1) — AARRR definitions and example funnel.
25. Eric Ries, "Pivot, don't jump to a new vision" (22 June 2009) — https://www.startuplessonslearned.com/2009/06/pivot-dont-jump-to-new-vision.html — primary (P1) — pivot types, pivot/persevere test.
26. Wikipedia, "Lean startup" — https://en.wikipedia.org/wiki/Lean_startup — secondary (P2) — pivot definition, build-measure-learn, innovation accounting.
27. First Round Review, "How Superhuman Built an Engine to Find Product/Market Fit" — https://review.firstround.com/how-superhuman-built-an-engine-to-find-product-market-fit/ — secondary (P2) — Ellis question, 40%, ~100 startups, 22%→58%.
28. Wikipedia, "Richard Rumelt" — https://en.wikipedia.org/wiki/Richard_Rumelt — secondary (P2) — kernel, bad-strategy hallmarks.
29. Roger L. Martin, "Playing to Win" — https://rogerlmartin.com/lets-read/playing-to-win — primary (P1, thin) — "five interrelated and powerful choices", 2013.
30. Wikipedia, "Porter's generic strategies" — https://en.wikipedia.org/wiki/Porter%27s_generic_strategies — secondary (P2) — three strategies, stuck-in-the-middle, critiques.
31. Wikipedia, "SWOT analysis" — https://en.wikipedia.org/wiki/SWOT_analysis — secondary (P2) — quadrants, disputed origin, critiques.
32. Blas Moros, "7 Powers" summary — https://blas.com/7-powers/ — summary (P3) — Power definition, seven powers.
33. Wikipedia, "Risk register" — https://en.wikipedia.org/wiki/Risk_register — secondary (P2) — fields, PMBOK/PRINCE2/ISO 31000.
34. Lighter Capital, "Revenue-Based Financing" — https://www.lightercapital.com/revenue-based-financing — vendor (P1 for its own terms) — definition, cap, eligibility.
35. RA 11337, Innovative Startup Act (Lawphil) — https://lawphil.net/statutes/repacts/ra2019/ra_11337_2019.html — law text (P1) — definitions, SGF, SVF, visas, subsidies.
36. National Development Company, Startup Venture Fund — https://www.ndc.gov.ph/svf/ — agency (P1) — CIP list, no-lead rule, eligibility, timeline.
37. Gobi-Core, "Appointed as Co-Investment Partner for the SVF" (17 Feb 2023) — https://gobicore.vc/gobi-core-appointed-as-a-co-investment-partner-for-philippine-governments-startup-venture-fund/ — primary (P1) — SVF US$10M/PHP500M.
38. Manila Angel Investors Network — https://www.main.ph/ and https://www.main.ph/about-1 — primary (P1) — stages, members, portfolio, screened.
39. TechNode Global, "Kickstart Ventures sets 2026 plans" (12 Feb 2026) — https://technode.global/2026/02/12/kickstart-ventures/ — press Q&A (P2) — funds, 2026 strategy, H1 2025 funding.
40. Foxmont Capital Partners, "Foxmont Secures $30M First Close for Fund III" — https://foxmontcapital.com/insights/foxmont-secures-30m-first-close-for-fund-iii — primary (P1) — fund size, date, deal pace, PH market figures.
41. IdeaSpace Ventures, About — https://www.ideaspace.vc/about — primary (P1) — backers, $10K/1%, program terms, eligibility.
42. QBO Innovation Hub — https://www.qboinnovation.com/ — primary (P1) — partners, program list.
43. SB Corporation, "MSME Financing Programs" — https://sbcorp.gov.ph/msme-financing-programs/ — agency (P1) — loan ranges, rates, tenors, eligibility, VC program.
44. Philstar, "SB Corp rolls out P1.5 billion loan program for MSMEs" (19 Jan 2025) — https://www.philstar.com/business/2025/01/19/2415185/sb-corp-rolls-out-p15-billion-loan-program-msmes — press (P2) — allocations, requirements.
45. The Independent Investor, "Updated Gobi-Core Philippine Fund report…" (15 Mar 2024) — https://theindependentinvestor.ph/updated-gobi-core-philippine-fund-report-highlights-53-increase-in-ph-startup-deals/ — press (P3) — 2023 deal statistics, Gobi-Core background.
46. DOST, IRR of RA 11337 download page — https://www.dost.gov.ph/knowledge-resources/downloads/file/3263-implementing-rules-and-regulations-of-republic-act-no-11337-or-the-innovative-startup-act.html — agency (P1, metadata only) — IRR dated 06 Oct 2021.
47. assistance.ph, "RA 11337: Accelerating Innovation in the Philippines" (20 Aug 2025) — https://assistance.ph/ra-11337-innovative-startup-act/ — aggregator (P3) — Startup BOSS mention only.

Not retrievable this run (403 / timeout / cert / empty) and therefore **not cited**: Lexology DICT-SGF guidelines, DICT and DOST-PCIEERD program pages, Startup BOSS, Cooley GO, Orrick forms, McKinsey "Perils of Bad Strategy", 7powers.com synopsis, HBR Store Playing to Win, HBS Working Knowledge, Wiley (Mitchell/Russo/Pennington 1989), Annie Duke "Quit", Wiley Startup Boards page, Sean Ellis's original 2009 post.
