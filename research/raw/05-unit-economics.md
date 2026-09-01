# Unit economics & financial modeling — research brief (2026-09-02)

Scope: unit-economics definitions, benchmarks by business model (SaaS / hardware / professional services), driver-based modeling, cash forecasting, Philippine specifics, and the mechanical gates a `guild` script can evaluate. Every number below was read from the cited URL on 2026-09-02 unless marked **UNVERIFIED**. Provenance grades: P1 = publisher/originator; P2 = reputable secondary quoting a named primary; P3 = weak/unsourced.

Method note: 200-search session budget was exhausted mid-task (shared with sibling agents); remaining verification was done by direct WebFetch of known URLs and by reading two PDFs (SPI 2025 benchmark, BSP June-2026 Monetary Policy Report) saved locally by the fetcher. Pages that returned 403/404 (Medium mirror of Sacks, Dragon Innovation, PNA, Rappler, PwC PH article, YC Library, Janz CAC-payback post, HBR contribution-margin article, Parakeeto) are not cited for numbers.

---

## 1. Standard process — ordered steps and named deliverables

The order below is the composite a competent operator/CFO follows; each step's deliverable is what the harness should require before the next gate opens. Source anchors are given per step; where a step is ordering convention rather than a published rule it is marked *practitioner consensus*.

| # | Step | Deliverable (file the gate reads) | Anchor |
|---|------|-----------------------------------|--------|
| 1 | Declare the business model and its metric dictionary. Recurring (SaaS), transactional/hardware, services. Metrics differ: recurring uses ARR/CAC/churn/NRR; hardware uses landed COGS, channel margin, sell-through, inventory turns; services uses utilization, project margin, revenue per billable head. | `model-type.md` + `metric-dictionary.csv` (metric, formula, inclusions/exclusions) | a16z "16 Startup Metrics" (definitions of bookings vs revenue, ARR exclusions, gross/net burn, gross vs net churn, blended vs paid CAC, LTV on net profit) [S3]; a16z "16 More" (gross margin as the cross-model equalizer; sell-through; inventory turns; customer concentration) [S4]; Bessemer "5 C's" [S9] |
| 2 | Build the assumptions register (drivers), separated from calculations and outputs. Every driver row carries a source id and an evidence grade (measured / benchmark / guess). | `model.csv` (schema in §5) | FAST Standard principles — Flexible, Appropriate, Structured, Transparent [S37]; CFI 3-statement step 2 "determine key forecast assumptions" [S33]; Janz's template takes organic growth, marketing spend, CAC, conversion, ARPU, churn by segment, headcount timing, payroll tax as inputs [S38] |
| 3 | Unit-economics sheet: price → fully-loaded COGS / landed cost → contribution margin → CAC (paid and blended) → churn → LTV (gross-margin-adjusted) → CAC payback → break-even. | `unit-econ.csv` (one row per segment/SKU/service line) | Skok [S1][S2]; a16z [S3]; CFI contribution margin & break-even [S35]; Bolt cost stack [S25][S26][S27] |
| 4 | Driver-based monthly 3-statement model (24–36 months): revenue from drivers, cost schedules, capex/tooling, debt, then balance sheet, then cash flow; ending cash ties to the balance sheet. | `model.xlsx` or `model/` (P&L, BS, CF per month) | CFI 8-step build order [S33]; Janz sheets: Summary, Revenues (3 tiers), Costs by department, Sales hiring plan, MRR movements [S38] |
| 5 | Scenario corners (base/worst/best) as full duplicate assumption sets with a live-scenario selector; plus one-driver-at-a-time sensitivity (tornado). | `scenarios.csv` (driver × corner) + `sensitivity.csv` | CFI scenario mechanics (list assumptions, duplicate per scenario, identical layout, CHOOSE/OFFSET selector) [S34]; BSP itself publishes "alternative scenarios" alongside its central projection [S43] |
| 6 | Cash: 13-week direct-method forecast (receipts, operating disbursements, non-operating disbursements, beginning/ending cash, facility availability) with weekly actual-vs-forecast variance; runway and default-alive test. | `cash13.csv` + `variance.csv` + `runway.json` | Wall Street Prep TWCF [S32]; Paul Graham default-alive [S39]; a16z burn definitions [S3] |
| 7 | Benchmark comparison and verdict: each derived metric vs the threshold for the declared model, stage and geography (§3). | `benchmark-verdict.json` (metric, value per corner, threshold, pass/fail, source id) | Bessemer [S8][S10]; SaaS Capital [S14]; SPI [S20]; Promethean [S24]; Bolt [S25–27] |
| 8 | Operating cadence: monthly actuals into the model, quarterly re-baseline, board pack. *Practitioner consensus*; SPI's "Measure Continuously … SMART goals" and "Benchmark and Assess" steps are the closest published statement [S20 p.233]. | `board/YYYY-MM.md` | SPI [S20] |

---

## 2. Frameworks & formulas

| Metric | Formula | Originator / canonical statement | Applies when | Known critiques |
|---|---|---|---|---|
| **CAC (fully loaded)** | Total sales + marketing cost in period (incl. salaries, headcount-related, tools) ÷ new customers acquired in period | Skok 2009 [S2]; a16z distinguishes *blended* (all channels) vs *paid* (paid-marketing customers only) [S3] | Any model with a repeatable acquisition motion | a16z: investors weight paid CAC over blended, and CAC rises as you reach a larger audience [S3]; Gurley: organic customers wrongly included in SAC; purchased customers convert/retain worse than organic [S7] |
| **LTV (gross-margin adjusted)** | Skok: gross margin expected from a customer over the relationship; simplest form ARPA × GM% ÷ churn. a16z: contribution margin per customer × (1 ÷ monthly churn), on *net profit*, not revenue | Skok [S2]; a16z [S3] | Recurring or repeat-purchase models with observable churn | a16z: common error is LTV on revenue or gross margin instead of net profit; prefer measured 12- and 24-month LTV over projected lifetimes [S3]. Gurley (2012): variables are interdependent (ARPU↑ → churn↑; spend↑ → SAC↑), not "hard science", and the formula rationalises over-spend [S7] |
| **LTV:CAC ≥ 3** | LTV ÷ CAC | Skok 2009: "LTV should be about 3 x CAC for a viable SaaS or other form of recurring revenue model"; public comps "more like 5 x CAC" [S2]. Skok 2012: "best SaaS businesses have a LTV to CAC ratio that is higher than 3, sometimes as high as 7 or 8"; author says guidelines were "early guesses" later validated in the field [S1] | Recurring revenue; author's basis is observation of failed startups plus public comps, not a derivation | Gurley's ten objections [S7]; ratio silently depends on the LTV horizon and GM adjustment [S1][S3] |
| **CAC payback (months)** | S&M expense (prior period) ÷ (new ARR added × GM%) × 12 — gross-margin-adjusted, S&M lagged | Aleph × Benchmarkit formula [S19]; Skok's original: months to recover CAC [S2]; Bessemer: "time to fully payback your sales and marketing investment" accounting for variable cost to serve [S9] | Recurring; segment-dependent thresholds (see §3) | Unadjusted (revenue-based) payback flatters low-margin businesses [S19] |
| **Gross margin** | (Revenue − COGS) ÷ Revenue; COGS must include manufacturing, delivery and support of the product/service, with inclusions disclosed | a16z [S3][S4] | Every model; "equalizer across business models" [S4] | Definitions drift (support, hosting, implementation in or out) — a16z insists on disclosure [S3] |
| **Contribution margin / break-even** | CM = net sales − variable costs; CM ratio = CM ÷ sales; break-even units = fixed costs ÷ CM per unit (revenue break-even = fixed ÷ CM ratio, derived) | CFI [S35] | Any; the hardware and services gate uses CM, not GM | Variable/fixed split is a judgment for semi-variable costs (*practitioner consensus*) |
| **Burn rate / runway** | Gross burn = monthly expenses + other cash outlays; net burn = revenues (incl. high-probability incoming cash) − gross burn; runway = cash ÷ net burn | a16z [S3] | All stages | a16z: "companies fail when they are running out of cash" — treat as the primary constraint [S3] |
| **Default alive / dead** | With expenses held flat and revenue growth at its recent rate, does the company reach profitability on cash on hand? Calculator: growth.tlb.org | Paul Graham, Oct 2015 [S39] | Meaningful only once there is revenue; "switches from meaningless to critical" ~8–9 months in [S39] | "Fatal pinch": default dead + slow growth + no time to correct [S39] |
| **Burn multiple** | Net burn ÷ net new ARR | David Sacks, Apr 2020 [S5] | Venture-stage recurring-revenue startups | Sacks: seed ~3 acceptable "because it just started selling", post-Series A ~2, should approach 0 toward profitability; 5x is "terrible" [S5]. Bessemer's *efficiency score* is the inverse (net new ARR ÷ net burn) [S10] |
| **Rule of 40** | Growth rate % + profit margin % ≥ 40 (profit = EBITDA preferred; growth = YoY MRR growth preferred) | Brad Feld, Feb 2015, citing an unnamed late-stage investor [S6] | "At scale" — ≥ ~$50M revenue, correlates from ~$1M MRR [S6] | Feld: profit definition matters; sub-scale companies that optimise for profit "will remain smaller longer" [S6]. Bessemer: BVP Nasdaq index averages "closer to 50%" [S8] |
| **Efficiency score (Bessemer)** | FCF margin % + ARR YoY growth % | Bessemer "Scaling to $100M" [S8] | Targets 70% at $25–50M ARR, 50% at $100M+ [S8] | Same profit-definition sensitivity as Rule of 40 |
| **Magic number** | (Quarterly revenue − prior-quarter revenue) × 4 ÷ prior-quarter S&M expense | Lars Leckie 2008 ("Magic Number for SaaS Companies"), building on Josh James / Omniture; threshold 0.75: below, "step back and look at your business"; above, "pour on the gas" [S40][S41] | Recurring, quarter-scale data available | Joel York: ignores cost of service; at 0.75 with 50% contribution margin the customer rate of return is ~38% and best-case time-to-profit 2.7 years; recommends > 1.0 *and* ARR ≥ 2 × average cost of service [S40] |
| **Churn / retention** | Monthly unit churn = lost customers ÷ prior-month total; gross MRR churn = MRR lost ÷ opening MRR; net churn = (MRR lost − upsell MRR) ÷ opening MRR; NRR/GRR are the annual complements | a16z [S3]; Bessemer logo churn / CMRR churn / CMRR renewal [S9] | Recurring | a16z: net churn "understates the losses" — report gross too [S3] |
| **Cash conversion cycle** | CCC = DIO + DSO − DPO (DIO = avg inventory ÷ daily COGS; DSO = avg AR ÷ daily credit sales; DPO = avg AP ÷ daily COGS) | CFI [S36] | Hardware and any inventory/AR-heavy model | Retail terms make DSO structural: Bolt reports 90-day PO terms with ~150-day actual payment [S27] |
| **Landed cost / hardware COGS** | BOM + assembly + test + packaging + freight/duties + scrap/yield + warranty reserve (+ amortised tooling/NRE/certification at low volume) | Components from Bolt [S26][S27], Ridgeway (tooling capitalised, units-of-production or 3–7 yrs; warranty reserve under ASC 460 at sale from defect rates; CM MOQ/NRE/prepayments as commitments) [S31], Barros (support labour, defective replacement incl. two-way shipping) [S28] | Any physical product | Under-scoping is the classic error: Bolt's 5k-unit example has BOM $32.16 but fully-loaded unit cost ≈ $65.80 [S25] |
| **13-week cash flow (TWCF)** | Weekly direct-method: receipts (DSO-driven), operating disbursements (payroll, inventory, vendors), non-operating (debt service, fees), beginning/ending cash, facility availability; working-capital roll-forwards; weekly variance | Wall Street Prep [S32] (restructuring practice) | Any company within ~6 months of cash-out, or any hardware company with MOQ deposits | Only credible if reconciled weekly to actuals; lenders/courts treat it as the liquidity evidence [S32] |
| **Services: utilization, project margin, revenue per billable consultant** | Utilization = billable hours ÷ available hours; project margin = (project revenue − delivery cost) ÷ project revenue; revenue per billable consultant = PS revenue ÷ billable heads (definitions standard; SPI's verbatim definitions are in its Appendix D, not extracted) | SPI Research PS Maturity Benchmark [S20] | Consultancies, agencies, embedded PS | SPI: KPIs are interconnected; compare against your vertical and size peer group, not the all-firm mean [S20 p.229] |

---

## 3. Numbers annex

Retrieved 2026-09-02 for every row.

### 3a. SaaS / recurring

| Metric | Benchmark / threshold | Context (stage · model · geo · date) | Source | Grade |
|---|---|---|---|---|
| LTV:CAC | ~3× viable; public comps ~5× | Recurring revenue; 2009 | https://www.forentrepreneurs.com/startup-killer/ | P1 |
| LTV:CAC | Best > 3, "sometimes as high as 7 or 8" | SaaS; 2012 update | https://www.forentrepreneurs.com/saas-metrics-2/ | P1 |
| CAC payback | "< 12 months, otherwise … too much capital to grow" | SaaS; 2009 | https://www.forentrepreneurs.com/startup-killer/ | P1 |
| CAC payback | Best businesses 5–7 months; "anemic" beyond 12 | SaaS; 2012 | https://www.forentrepreneurs.com/saas-metrics-2/ | P1 |
| CAC payback | SMB < 12 · mid-market < 18 · enterprise < 24 months; avg 15 months at $1–10M ARR | Private cloud; Sep 2021, updated 2024 | https://www.bvp.com/atlas/scaling-to-100-million | P1 |
| CAC payback | Good 12–18 · Better 6–12 · Best 0–6 months | Series B/C enterprise software; Apr 2023 | https://www.bvp.com/atlas/state-of-the-cloud-2023 | P1 |
| CAC payback | Median 16 mo (FY2025), top quartile ≤ 6, bottom quartile ≥ 24; FY2024 median 18 | 342 B2B SaaS/AI cos, 198 reporting; report Jun 2026 | https://www.getaleph.com/answers/cac-payback-period-saas-2026 | P1 (co-publisher page) |
| AE payback | Expected to shorten to 18 months by 2026 | Private SaaS survey, 16th year; Nov 2025 | https://info.sapphireventures.com/2025-keybanc-capital-markets-sapphire-ventures-saas-survey | P1 |
| Gross margin | Software should hold 80–90% (Amazon e-commerce cited at 27%) | Ideal, all stages; Sep 2015 | https://a16z.com/16-more-startup-metrics/ | P1 |
| Gross margin | "Consistent 65–70% across all scales" | BVP private cloud companies; 2021/2024 | https://www.bvp.com/atlas/scaling-to-100-million | P1 |
| Gross margin | Compressing "due to the cost for building many AI products" (no median in fetched text) | 800+ respondents, 69% US / 17% EU; 2025 | https://www.highalpha.com/saas-benchmarks | P1 |
| NRR by ACV | $5–25k ≈ 100% · $25–50k 102% (Q1 111%, Q3 97%) · $50–100k ≈ 105% · $100k+ ≈ 110% | Private B2B SaaS, 2024 data; Sep 2025 | https://www.saas-capital.com/blog-posts/what-is-a-good-retention-rate-for-a-private-saas-company/ | P1 |
| Growth | Median 24% for companies > $1M ARR | Same survey, 2024 data | same | P1 |
| GRR / NRR | GRR ~90%, NRR ~101% (2024); GRR fell to 86% in 2023; NRR > 100% (2025) | Private SaaS; Nov 2024 / Nov 2025 | https://info.sapphireventures.com/2024-keybanc-capital-markets-and-sapphire-ventures-saas-survey ; https://investor.key.com/press-releases/news-details/2025/PRIVATE-SAAS-COMPANY-SURVEY-REVEALS-AI-DRIVEN-TRANSFORMATION-AND-SUSTAINED-OPERATIONAL-EXCELLENCE/default.aspx | P1 |
| ARR growth | 15% (2024) → 20% projected (2025); EBITDA expected positive by 2026 | Private SaaS; Nov 2025 | KeyBanc press release (above) | P1 |
| Sales | Quota attainment ~70% (2023), ~75% proj. (2024); quotas ~$750k; public SaaS ~5–6× NTM revenue | Private SaaS; 2024 | Sapphire 2024 page (above) | P1 |
| NRR (public) | Median ~110% | Public SaaS, 2024 | https://www.growthunhinged.com/p/your-guide-to-the-2024-saas-benchmarks | P2 |
| Growth medians | <$1M 100% · $1–5M 50% · $5–20M 30% · $20–50M 30% · >$50M 15% (2024) | 800+ cos, 62% US; Nov 2024 | same | P2 |
| NRR / GRR (bottom-up) | B2B SaaS median NRR 82%, upper quartile 97%; AI-native median NRR 48%, GRR 40%; AI > $250/mo GRR 70% / NRR 85%; < $50/mo GRR 23% / NRR 32% | Scraped 3,500 cos ≥ $250k ARR (2,700 B2B, 600 B2C, 200 AI); data to Sep 2025 | https://chartmogul.com/reports/saas-retention-the-ai-churn-wave/ | P1 |
| Retention tiers | NRR Good 100 / Better 110 / Best 120+; logo retention >85 / >90 / 95+; growth 75 / 100 / 125%+; runway 12 / 18 / 24+ months; efficiency (net new ARR ÷ net burn) <0.5× / 0.5–1.5× / 1.5×+ | Series B/C enterprise; Apr 2023 | https://www.bvp.com/atlas/state-of-the-cloud-2023 | P1 |
| Churn | Top performers: annual logo churn < 7%, CMRR churn < 5% | Cloud; Oct 2012 | https://www.bvp.com/atlas/cloud-computing-metrics | P1 |
| Net revenue churn | > 2%/month "indicator that there is something wrong" | SaaS; 2012 | https://www.forentrepreneurs.com/saas-metrics-2/ | P1 |
| NDR by stage | $1–10M ARR 140% avg; $10–100M+ 120% avg | BVP portfolio-style private cloud; 2021/2024 | https://www.bvp.com/atlas/scaling-to-100-million | P1 |
| Burn multiple | 2× "reasonable for an early-stage startup"; seed ~3 → post-A ~2 → toward 0; 5× "terrible" | Venture-stage; Apr 2020 | https://sacks.substack.com/p/the-burn-multiple-51a7e43cb200 | P1 |
| Burn multiple tiers | Amazing < 1 / Great 1–1.5 / Good 1.5–2 / Suspect 2–3 / Bad > 3 | Sacks' chart is an image; **UNVERIFIED from text**. Unattributed tiers seen: <1 exceptional, 1–1.5 strong, 1.5–2 acceptable, >2 concerning, >4 high risk | https://www.klipfolio.com/resources/kpi-examples/saas/burn-multiple | P3 |
| Rule of 40 | growth + profit ≥ 40% | ≥ ~$50M revenue / ~$1M MRR; Feb 2015 | https://feld.com/archives/2015/02/rule-40-healthy-saas-company/ | P1 |
| Efficiency score | 70% at $25–50M ARR; 50% at $100M+; BVP Nasdaq index ~50% on Rule of 40 | Private cloud; 2021/2024 | https://www.bvp.com/atlas/scaling-to-100-million | P1 |
| Magic number | 0.75 threshold (Leckie); > 1 = "increase S&M spend" (Cummings); York: > 1.0 and ARR ≥ 2 × ACS | SaaS; 2008 / 2010 / 2016 | https://chaotic-flow.com/saas-metrics-joels-magic-number-for-saas-companies/ ; https://davidcummings.org/2016/10/13/the-magic-number-for-saas/ | P2 |
| Customer concentration | Prefer low; example 10% (largest customer $2M of $20M) | All; 2015 | https://a16z.com/16-more-startup-metrics/ | P1 |

### 3b. Hardware

| Metric | Benchmark / threshold | Context | Source | Grade |
|---|---|---|---|---|
| Gross margin target | "at least a 50% gross margin on the sale of your device" unless there is ongoing service revenue; "If your gross margin is less than 50% your price is too low" | Consumer hardware; Marc Barros (Contour) | https://learn.adafruit.com/how-to-build-a-hardware-startup/pricing-your-product | P1 (practitioner) |
| Worked cost stack | MSRP $99; BOM $32.16; fully-loaded unit cost ≈ $65.80 at 5,000 units (→ ≈ 33.5% GM direct, *derived*); dev $360k + first run $330k ≈ $690k; "each unit sold in physical retail actually LOSES money" at that volume | Consumer device, first run; Aug 2015 | https://blog.bolt.io/will-your-hardware-startup-make-money-677a8e6c665b | P1 |
| Channel margins | Online retail (Amazon) 15–20%; specialty retail 30–35%, sometimes > 40%; Apple retail 50% "common"; phone cases 70%+; PO terms 90 days, actual ~150 days; in-store displays ~$5k/store; product liability insurance $10–30k/yr; licensing royalties < 5%, ~2% | US consumer hardware; Feb 2015 | https://blog.bolt.io/hardware-retail-exits/ | P1 |
| Price rule | 2.5–4× BOM common rule (author prefers value pricing) | same | same | P1 |
| MOQ / CM terms | MOQ ~5k units; CM wants ~$1M BOM/yr per customer; 50% down-payment common; injection tool ~$6.5k in China (US ~2×), 1–50 tools per product; certification (FCC/UL/CE) ≥ $15k; quoted 180 days from database release, usually +50%, often ~1 year | Chinese CMs; Nov 2014 | https://blog.bolt.io/hardware-financing-manufacturing/ | P1 |
| Yield / scrap | ~5% scrapped on initial production → ~0.5% after a few cycles | same | same | P1 |
| Packaging | $0.25–0.50 per box; $1–5 master carton; up to $15 premium | same | same | P1 |
| Warranty / returns | Barros' example assumes a 15% defective rate and 1–2 support staff at $10/hr per 1,000 units/month | Illustrative assumption, not a benchmark | Adafruit page (above) | P1 (assumption) |
| Warranty reserve % of revenue | **UNVERIFIED** — no fetched source gives a rate; Ridgeway confirms reserve is booked at sale from defect-rate history or "comparable products or industry benchmarks" (ASC 460) | Oct 2025 | https://www.ridgewayfs.com/hardware-startup-financial-challenges/ | P2 |
| Tooling accounting | Capitalise; depreciate by units-of-production or 3–7 yrs; impairment at EOL | same | same | P2 |
| Public comparables | Cisco ~65%, Garmin ~58%, Sonos mid-40s, Apple hardware ~37% (overall ~47%), GoPro mid-30s, Dell low-20s; Amazon devices at/below cost | Unsourced assertions; Jan 2026 | https://seriesops.com/insights/gross-margin-hardware-startups | P3 |
| Hard-tech B2B | "Many HAX companies are operating 80%+ gross margin businesses"; HAX B2B share 10% → 70% since 2012 | HAX partner claim; Jun 2021 | https://techcrunch.com/2021/06/12/the-rapid-hard-tech-emergence/ | P2 |
| Inventory metrics | Sell-through = units sold ÷ units at period start; inventory turns = COGS ÷ avg inventory | 2015 | https://a16z.com/16-more-startup-metrics/ | P1 |

Reading: the brief's "hardware 30–50%" band is consistent with Bolt's ≈33% first-run direct margin and Barros' ≥50% floor; distribution takes 15–50 points off the top depending on channel. Bolt: don't go to physical retail on the first run.

### 3c. Professional services / agencies

| Metric | Benchmark / threshold | Context | Source | Grade |
|---|---|---|---|---|
| Billable utilization | 68.9% (2024); 5-yr avg 70.8%; SPI "optimal 75%" | 403 firms, mostly North America; 2025 benchmark (2024 data) | Kantata-hosted SPI PDF https://get.kantata.com/rs/677-LEJ-696/images/2025-ps-maturity-benchmark.pdf (Tables 1–2) | P1 |
| Project margin | 35.9% (2024); 5-yr avg 35.5%; 36.5% peak (2021) | same | same | P1 |
| Revenue per billable consultant | $199k (2024); 5-yr avg $204k; SPI cites $200k+ as the reinvestment threshold and revenue leakage < 5% | same | same (p.229) | P1 |
| EBITDA | 9.8% (2024) vs 15.4% (2023); 5-yr avg 14.9%; 16.1% (2022) | same | same | P1 |
| Delivery | On-time 73.4%; project overrun 11.3%; PS revenue growth 4.6%; headcount growth 1.9%; attrition 11.7%; subcontractors 10.9% of revenue | same | same | P1 |
| 2026 update | Utilization 66.4% (record low; 3.6 pts under SPI's 70% healthy floor); project margin 37.7%; revenue per consultant $210k; revenue per employee $168k; EBITDA 9.9%; growth 5.2%; overrun 10.7% (SPI concern > 10%); 500+ firms | 2026 benchmark (2025 data) | https://www.deltek.com/resources/articles/professional-services-benchmarks/ | P2 |
| Agency net margin | 13% after-tax (2025); 14% (2024); ~15% long-run; by size: studio (0–9 FTE) 19%, small 12%, medium 9%, large (50+) 8%; by type: design 18%, marketing 13%, development 11% | Digital agencies; Apr 2026 (2025 data); geography not stated | https://prometheanresearch.com/how-profitable-are-digital-agencies/ | P1 |
| Agency project margin | 35% avg (37% where engagement size growing, 30% where shrinking); 59% of agencies track it; avg revenue $4.43M | same | same | P1 |
| "Agency gross margin ≥ 50% / delivery margin 50–60%" | **UNVERIFIED** — search snippet only (Swydo/Parakeeto not fetched) | — | — | — |

Reading: the brief's "services 40–60%" gross-margin band is **not** what the benchmark publishers report; SPI and Promethean both centre *project/delivery margin* at ~35–38%, with EBITDA ~10% (PS) and net ~13% (agencies). Use 35% project margin and 70% utilization as floors, 75% utilization as target.

### 3d. Philippines macro/cost context (see §4)

---

## 4. Philippine specifics

Verified (retrieved 2026-09-02):

- **Policy rate.** BSP raised the target reverse repurchase rate 25 bp to **4.75%** on 18 Jun 2026; overnight deposit 4.25%, lending 5.25% [S43, MPR p.1]. Trading Economics reports a further hike to **5.00% on 27 Aug 2026** (P2; the MPR's meeting calendar confirms an MB meeting that day) [S44].
- **Inflation.** BSP central forecasts (June 2026 MPR): **6.4% (2026), 4.5% (2027), 3.1% (2028)** vs 3.6%/3.2% in the February report; target 3.0% ± 1 pp for 2026–2028; drivers: Middle-East oil shock, weaker peso, fertilizer/fuel, "possible fare hikes and higher minimum wage adjustments in 2026"; fiscal deficit targets 5.3/4.8/4.3% of GDP [S43 pp.1–3]. July 2026 headline **6.2%** (June 6.4%), core 4.2%, Jan–Jul average 5.0%; transport 11.9%, housing/utilities 8.2%, food 5.2% [S45, P2].
- **Wages (NCR).** Wage Order NCR-27: non-agriculture **₱695 → ₱755/day from 25 Jul 2026 → ₱780 from 20 Jan 2027**; agriculture, retail/service ≤ 15 workers and manufacturing < 10 workers **₱658 → ₱718 → ₱743**; domestic workers ₱7,800/month (NCR-DW-06, 7 Feb 2026) [S48, P1]. Implementation was restrained by a Pasig RTC TRO (30 Jul 2026) and preliminary injunction (13 Aug 2026), under Supreme Court review as of 26 Aug 2026 [S49, P2] — model both floors.
- **Corporate tax.** Regular CIT **25%**; **20%** for domestic corporations with total assets ≤ ₱100M and net taxable income ≤ ₱5M; MCIT 2% of gross income from the 4th taxable year; **VAT 12%**, registration threshold ₱3M gross sales [S46][S47, P2, "last reviewed 01 Aug 2026"]. (CREATE MORE's 20% RBE rate was in search snippets only — UNVERIFIED here.)
- **Employer on-costs (2026).** SSS 15% of MSC (employer 10% / employee 5%), MSC ceiling ₱35,000 (floor ₱4,000 per KAMI; other sources say ₱5,000 — **UNVERIFIED**); EC ₱10 or ₱30/month employer-only; PhilHealth 5% split 2.5/2.5, floor ₱10,000, ceiling ₱100,000; Pag-IBIG 2% + 2% capped at ₱200 each [S50, P2]. PwC's "other taxes" page lists a maximum employer SSS contribution of ₱2,000, which looks stale against a 10% × ₱35,000 ceiling — flag for the accountant [S47]. 13th-month pay (PD 851, 1/12 of basic annual pay) — statutory but **not fetched, UNVERIFIED**.
- **Rule of thumb for the model.** For an NCR minimum-wage hire the fully-loaded monthly cost ≈ daily wage × ~26 days + ~10% SSS + 2.5% PhilHealth + ₱200 Pag-IBIG + ₱10–30 EC + 1/12 13th month — the script should compute it from the driver rows, not hard-code it.

Not found: no Philippine publisher of SaaS/hardware/services unit-economics benchmarks was located; SPI and Promethean samples are North-America-heavy and USD-denominated (revenue per consultant $199–210k), so PH services benchmarks must be **derived** (local billing rates × utilization) and marked as assumptions until measured.

---

## 5. Mechanical gate candidates

### 5.1 `model.csv` — driver register (one row per driver; three corner columns)

```
driver_id,name,unit,segment,base,worst,best,evidence,source_id,measured_from,owner,last_verified
price_arpa,Average revenue per account per month,PHP,saas_smb,2500,2000,3000,assumption,,,
gm_pct,Gross margin (fully loaded COGS incl. hosting+support),pct,saas_smb,0.72,0.60,0.78,benchmark,S8;S4,,
churn_m,Monthly gross revenue churn,pct,saas_smb,0.025,0.04,0.015,benchmark,S1;S14,,
cac_paid,Paid CAC (S&M incl. salaries / new paid customers),PHP,saas_smb,45000,70000,30000,measured,,ledger:sm_spend/ledger:new_customers,
sm_monthly,Sales & marketing spend,PHP,all,300000,300000,300000,assumption,,,
opex_fixed,Fixed opex excl. S&M,PHP,all,900000,1000000,850000,measured,,ledger:opex,
cash_open,Opening cash,PHP,all,6000000,6000000,6000000,measured,,bank:balance,
bom_unit,BOM per unit,PHP,hw_sku1,1800,2100,1650,quote,Q-2026-014,,
asm_test_pack_unit,Assembly+test+packaging per unit,PHP,hw_sku1,420,520,380,quote,Q-2026-014,,
freight_duty_unit,Freight+duties per unit landed,PHP,hw_sku1,150,260,120,quote,,,
scrap_pct,Yield loss,pct,hw_sku1,0.05,0.08,0.02,benchmark,S26,,
warranty_pct,Warranty reserve % of revenue,pct,hw_sku1,0.03,0.08,0.02,assumption(UNVERIFIED),,,
tooling_total,Tooling+NRE+certification,PHP,hw_sku1,1500000,2200000,1200000,quote,S26,,
moq_units,Minimum order quantity,units,hw_sku1,5000,5000,3000,quote,S26,,
deposit_pct,CM deposit on PO,pct,hw_sku1,0.5,0.5,0.3,quote,S26,,
channel_margin,Retail/distribution margin,pct,hw_sku1,0.20,0.40,0.0,benchmark,S27,,
dso_days,Days sales outstanding,days,hw_sku1,45,150,30,benchmark,S27,,
dio_days,Days inventory outstanding,days,hw_sku1,90,150,60,assumption,,,
dpo_days,Days payable outstanding,days,hw_sku1,30,15,45,quote,,,
bill_rate,Blended hourly bill rate,PHP,svc,1800,1500,2200,measured,,ledger:invoices,
utilization,Billable utilization,pct,svc,0.70,0.60,0.75,benchmark,S20,timesheets,
delivery_cost_pct,Delivery cost % of project revenue,pct,svc,0.62,0.70,0.58,benchmark,S20;S24,,
wage_floor_ncr,NCR daily minimum wage,PHP,all,755,780,695,statute,S48;S49,,
cit_rate,Corporate income tax,pct,all,0.20,0.25,0.20,statute,S46,,
```

Rules the loader enforces: `evidence ∈ {measured, quote, statute, benchmark, assumption}`; `benchmark` and `statute` rows must carry a `source_id` that resolves in §8; `measured` rows must carry `measured_from` (a ledger/CSV path the script can re-read); any `assumption` row is listed in the verdict as an open risk; no derived metric may be typed in as a driver (FAST: inputs ≠ calculations) [S37].

### 5.2 Assertions evaluated at each corner (base / worst / best)

| Gate | Assertion (script) | Threshold | Corner | Source |
|---|---|---|---|---|
| UE-01 | `gm_pct` ≥ floor for declared model | SaaS ≥ 0.65 (Bessemer private-cloud floor); hardware ≥ 0.50 direct-channel target, ≥ 0.30 hard floor; services delivery margin ≥ 0.35 | base ≥ target; worst ≥ hard floor | S8, S28, S25, S20, S24 |
| UE-02 | `LTV / CAC` with LTV = ARPA × gm_pct ÷ churn_m, capped at 24 months of life | ≥ 3 | base ≥ 3; worst ≥ 1 | S1, S2, S3 (24-month cap) |
| UE-03 | `CAC payback` = sm_prev ÷ (new_ARR × gm_pct) × 12 | SMB ≤ 12 · mid-market ≤ 18 · enterprise ≤ 24 | base ≤ segment limit; worst ≤ 24 | S8, S19, S2 |
| UE-04 | Net revenue churn | ≤ 2%/month | base | S1 |
| UE-05 | `burn_multiple` = net_burn ÷ net_new_ARR (only once ARR > 0) | ≤ 2 (seed: ≤ 3) | base | S5 |
| UE-06 | Runway = cash ÷ net burn | ≥ 18 months at base; ≥ 12 months at worst | both | S10 (12/18/24 tiers) |
| UE-07 | Default-alive: with opex frozen at current and growth at trailing-3-month rate, cash never < 0 before cash-flow breakeven | must pass at base once revenue > 0 for ≥ 8 months | base | S39 |
| UE-08 | 13-week: min weekly ending cash ≥ buffer (one payroll cycle) and last-4-week receipts variance ≤ 15% (buffer/variance sizes are *practitioner consensus*) | pass | worst | S32 |
| UE-09 | Contribution-margin break-even month ≤ month of cash-out | pass | base and worst | S35, S3 |
| HW-01 | Landed unit cost = bom + asm_test_pack + freight_duty, ÷ (1 − scrap_pct), + warranty_pct × price; channel-net price = price × (1 − channel_margin); GM = (channel-net − landed) ÷ channel-net | ≥ UE-01 floor **per channel row** | all corners | S25–S27, S31 |
| HW-02 | First-PO cash = deposit_pct × moq_units × landed + tooling_total | ≤ cash_open − 6 × (opex_fixed + sm_monthly) | worst | S26 |
| HW-03 | Working-capital need = (dio + dso − dpo) ÷ 30 × monthly COGS | ≤ cash_open − HW-02 need | worst (DSO 150 if any physical retail) | S36, S27 |
| HW-04 | Amortised fixed costs (tooling ÷ first-run units) included in landed cost at run-1 volume | present | all | S25 |
| SV-01 | utilization | ≥ 0.70 floor; target 0.75 | base ≥ 0.70; worst ≥ 0.60 | S20 |
| SV-02 | project margin = 1 − delivery_cost_pct | ≥ 0.35 | base | S20, S24 |
| SV-03 | revenue per billable head vs local derivation (bill_rate × utilization × annual hours) — USD $200k threshold not applicable in PH | derived value recorded, no threshold until measured | — | S20 (context) |
| SV-04 | Project overrun (actual ÷ budget − 1) from timesheets | ≤ 10% | measured | S22 (SPI concern > 10%) |
| ALL-01 | Customer concentration = largest customer revenue ÷ total | flag > 20% (threshold *practitioner consensus*; a16z gives no number) | measured | S4 |
| ALL-02 | Sensitivity: no single driver moved ±20% flips any pass→fail (fragility) | pass | base | S34 (scenario mechanics) |
| ALL-03 | Every `benchmark`/`statute` row cites a source in §8; every `assumption` row appears in the verdict's open-risk list | pass | — | S37 |
| PH-01 | Wage driver equals the higher of the enjoined and un-enjoined NCR-27 rate for worst case; on-cost rates equal S50 values | pass | worst | S48–S50 |
| PH-02 | Tax driver = 25% unless assets ≤ ₱100M and NTI ≤ ₱5M (then 20%); MCIT 2% from year 4; VAT 12% applied above ₱3M | computed, not typed | all | S46, S47 |

### 5.3 What cannot be mechanized

- Whether an `assumption` row is true — only customer-discovery/sales evidence converts it to `measured` (Gurley: LTV inputs are predictions, and interdependent) [S7].
- Segment choice for the payback limit (SMB vs enterprise) — a human declares it; the script only checks consistency with ACV.
- The definition of "profit" in Rule of 40 / efficiency score and where semi-variable costs sit in COGS vs opex [S6][S3] — declared in `metric-dictionary.csv`, then enforced mechanically.
- Timing/quality of the worst case (e.g., a 150-day DSO or a 40% channel margin) — the script can only require that the worst corner is at least as bad as the published worst benchmarks.
- Any *send/spend/sign/file* act triggered by a passing gate (issuing a PO with a 50% deposit, signing a retail program, registering for VAT) stays human-gated.

---

## 6. Early irreversibles (fix early; expensive to reverse)

1. **Business-model choice** sets the entire margin band and cash profile: 65–90% (software) vs ≈33–50% (hardware) vs ~35% project margin / ~10–13% bottom line (services) [S4][S8][S25][S28][S20][S24].
2. **Hardware channel choice.** Physical retail costs 30–50 points of margin plus ~150-day cash cycles and program fees; Bolt's first-run example loses money in physical retail — go direct/e-tail first [S25][S27].
3. **MOQ, tooling, certification commitments.** 5k-unit MOQ with 50% deposit, 1–50 tools at ~$6.5k each, ≥ $15k certification, and a CM expectation of ~$1M BOM/yr are sunk once the PO is signed [S26]; tooling is capitalised and impaired at EOL [S31].
4. **Price floor.** A price that yields < 50% GM direct is "too low" and cannot be raised easily after launch [S28]; Gurley: raising ARPU later raises churn [S7].
5. **ACV tier / segment.** Retention bands are set by ACV ($5–25k ≈ 100% NRR vs $100k+ ≈ 110%) [S14]; sub-$50/month AI plans retain catastrophically (GRR 23%) [S15].
6. **Fixed-cost base and hiring.** PH wage floors are ratcheting (₱695 → ₱780 in NCR by Jan 2027) and inflation is forecast at 6.4% for 2026 [S43][S48]; a16z: companies fail when they run out of cash [S3].
7. **Entity/tax posture.** Staying under ₱100M assets / ₱5M NTI keeps CIT at 20%; crossing ₱3M sales triggers VAT registration [S46][S47].
8. **Metric definitions.** Once bookings/LOIs are counted as revenue or LTV is computed on revenue, every downstream board number is wrong; a16z lists these as the top mistakes [S3].

---

## 7. Failure modes / anti-patterns the harness must guard against

| # | Anti-pattern | Guard | Source |
|---|---|---|---|
| 1 | LTV computed on revenue or gross margin instead of net profit / contribution; unbounded lifetime | UE-02 uses gm-adjusted LTV capped at 24 months | a16z [S3] |
| 2 | Reporting blended CAC while paid CAC is what scales | `cac_paid` is a required driver; blended is informational | a16z [S3] |
| 3 | Treating LTV:CAC as a strategy or as science; ignoring interdependence (ARPU↑ → churn↑, spend↑ → CAC↑) | ALL-02 fragility test; sensitivity on paired drivers | Gurley [S7] |
| 4 | Counting LOIs, verbal agreements or bookings as revenue; non-recurring fees in ARR | metric-dictionary enforced; ledger tags | a16z [S3] |
| 5 | Showing net churn only (upsell masks gross losses) | UE-04 on gross and net | a16z [S3] |
| 6 | Applying Rule of 40 below scale, or choosing early profitability that keeps the company small | Rule-of-40 gate disabled below ~$1M MRR | Feld [S6] |
| 7 | Magic number ≥ 0.75 read as "pour on gas" while cost-to-serve makes the customer ROI ~38% | Require GM-adjusted payback (UE-03), not magic number alone | York [S40] |
| 8 | Growth reported without the burn that bought it | UE-05 burn multiple mandatory once ARR > 0 | Sacks [S5] |
| 9 | Not knowing default-alive status until the "fatal pinch" | UE-07 runs monthly from month 8 of revenue | Graham [S39] |
| 10 | Under-scoped hardware COGS (BOM ≠ landed cost; first-run scrap ~5%; tooling amortised over 5k units) | HW-01/HW-04 | Bolt [S25][S26] |
| 11 | First production run straight into physical retail (margin + 150-day terms + displays) | HW-01 per channel, HW-03 with DSO 150 in worst | Bolt [S25][S27] |
| 12 | Pricing at a BOM multiple rather than value with a ≥ 50% GM floor | UE-01 hardware floor | Bolt [S27], Barros [S28] |
| 13 | Services: utilization drift below 70%, overruns > 10%, revenue leakage > 5% | SV-01, SV-04, leakage flag | SPI [S20][S22] |
| 14 | Agencies: growing headcount into lower margins (studio 19% → large 8% net) | SV-02 + headcount-vs-margin trend check | Promethean [S24] |
| 15 | Using AI-native or SMB retention as if it were enterprise SaaS (NRR 48% vs 110%) | Segment declared; NRR benchmark chosen by ACV tier | ChartMogul [S15], SaaS Capital [S14] |
| 16 | 13-week forecast built once and not reconciled weekly | UE-08 requires a `variance.csv` with weekly actuals | WSP [S32] (*practice*) |
| 17 | Importing USD benchmarks (e.g., $200k revenue per consultant) into a PHP model | SV-03 records derived local value; USD thresholds informational only | *practitioner consensus* |
| 18 | Modeling one wage floor while a wage order is under injunction; ignoring 6.4% inflation on fixed costs | PH-01; inflation driver from BSP central forecast | NWPC [S48], Mercans [S49], BSP [S43] |
| 19 | Hard-coded numbers inside formulas; inputs mixed with calculations | Loader rejects derived values typed as drivers | FAST [S37] |
| 20 | Customer concentration hidden inside a growth story | ALL-01 | a16z [S4] |

---

## 8. Sources (all retrieved 2026-09-02)

| # | Title · URL · type · used for |
|---|---|
| S1 | David Skok, "SaaS Metrics 2.0" · https://www.forentrepreneurs.com/saas-metrics-2/ · P1 practitioner canon · LTV:CAC > 3 (up to 7–8), payback 5–7 months best / > 12 anemic, net churn > 2%/mo red flag, negative churn |
| S2 | David Skok, "Startup Killer: the Cost of Customer Acquisition" (2009) · https://www.forentrepreneurs.com/startup-killer/ · P1 · origin of the 3× rule and < 12-month payback; CAC/LTV definitions; public comps ~5× |
| S3 | a16z, "16 Startup Metrics" (Aug 2015) · https://a16z.com/16-startup-metrics/ · P1 · definitions: bookings vs revenue, ARR, gross profit, gross/net burn, churn variants, blended vs paid CAC, LTV on net profit, 12/24-month LTV |
| S4 | a16z, "16 More Startup Metrics" (Sep 2015) · https://a16z.com/16-more-startup-metrics/ · P1 · gross margin as equalizer (software 80–90%, Amazon 27%), sell-through, inventory turns, customer concentration |
| S5 | David Sacks, "The Burn Multiple" (Apr 2020) · https://sacks.substack.com/p/the-burn-multiple-51a7e43cb200 · P1 · formula, 2× reasonable early, seed 3 → A 2 → 0, 5× terrible (tier chart is an image — not transcribed) |
| S6 | Brad Feld, "The Rule of 40% for a Healthy SaaS Company" (Feb 2015) · https://feld.com/archives/2015/02/rule-40-healthy-saas-company/ · P1 · definition, scale caveat, profit-definition caveat |
| S7 | Bill Gurley, "The Dangerous Seduction of the Lifetime Value (LTV) Formula" (Sep 2012) · https://abovethecrowd.com/2012/09/04/the-dangerous-seduction-of-the-lifetime-value-ltv-formula/ · P1 · ten critiques |
| S8 | Bessemer, "Scaling to $100 Million" (2021, upd. 2024) · https://www.bvp.com/atlas/scaling-to-100-million · P1 · payback by segment, avg 15 mo, NDR by stage, GM 65–70%, efficiency score targets, Rule of 40 ~50% index |
| S9 | Bessemer, "The five accounting metrics for cloud companies" (Oct 2012) · https://www.bvp.com/atlas/cloud-computing-metrics · P1 · CMRR, burn, payback, CLTV, churn definitions; logo churn < 7%, CMRR churn < 5% |
| S10 | Bessemer, "State of the Cloud 2023" (Apr 2023) · https://www.bvp.com/atlas/state-of-the-cloud-2023 · P1 · Good/Better/Best table (payback, efficiency, NRR, runway, growth, logo retention) |
| S11 | KeyBanc/Sapphire press release (Nov 2025) · https://investor.key.com/press-releases/news-details/2025/PRIVATE-SAAS-COMPANY-SURVEY-REVEALS-AI-DRIVEN-TRANSFORMATION-AND-SUSTAINED-OPERATIONAL-EXCELLENCE/default.aspx · P1 · growth 15→20%, GRR 86% (2023) → ~90%, NRR > 100%, EBITDA positive by 2026 |
| S12 | Sapphire, 2025 KeyBanc/Sapphire SaaS Survey page · https://info.sapphireventures.com/2025-keybanc-capital-markets-sapphire-ventures-saas-survey · P1 · AE payback → 18 months by 2026 |
| S13 | Sapphire, 2024 KeyBanc/Sapphire SaaS Survey page · https://info.sapphireventures.com/2024-keybanc-capital-markets-and-sapphire-ventures-saas-survey · P1 · GRR ~90%, NRR ~101%, quota attainment, 5–6× NTM |
| S14 | SaaS Capital, "What is a Good Retention Rate for a Private SaaS Company in 2025?" (Sep 2025) · https://www.saas-capital.com/blog-posts/what-is-a-good-retention-rate-for-a-private-saas-company/ · P1 · NRR by ACV band with quartiles; median growth 24% |
| S15 | ChartMogul, "SaaS Retention Report: The AI churn wave" (2025) · https://chartmogul.com/reports/saas-retention-the-ai-churn-wave/ · P1 · B2B/B2C/AI NRR & GRR medians, by price tier, sample 3,500 |
| S16 | High Alpha, 2025 SaaS Benchmarks Report · https://www.highalpha.com/saas-benchmarks · P1 · sample, GRR "9 of 10", AI margin compression, expansion 60% of new ARR > $50M |
| S17 | High Alpha/OpenView, 2024 SaaS Benchmarks · https://www.highalpha.com/saas-benchmarks/2024 · P1 · sample 800+, public NRR ~110%, growth < $1M 90→100% |
| S18 | Kyle Poyar, "Your guide to the 2024 SaaS benchmarks" (Nov 2024) · https://www.growthunhinged.com/p/your-guide-to-the-2024-saas-benchmarks · P2 · growth medians by ARR band |
| S19 | Aleph × Benchmarkit, "CAC payback period benchmarks for SaaS (2026)" · https://www.getaleph.com/answers/cac-payback-period-saas-2026 · P1 (co-publisher) · median 16 mo, quartiles, GM-adjusted formula |
| S20 | SPI Research, 2025 Professional Services Maturity Benchmark (Kantata-hosted full PDF, Feb 2025) · https://get.kantata.com/rs/677-LEJ-696/images/2025-ps-maturity-benchmark.pdf · P1 · Tables 1–2 KPIs, 403 firms, 75% optimal utilization, $200k+/consultant, leakage < 5%, "Steps to Improve" |
| S21 | SPI Research, 2025 benchmark intro/contents PDF · https://spiresearch.com/wp-content/uploads/2025/02/2025-PS-Maturity-Benchmark-Intro-and-Contents-Pages.pdf · P1 · report structure (Appendix D financial terminology exists) |
| S22 | Deltek, "2026 PSO Benchmarks: Insights from SPI" · https://www.deltek.com/resources/articles/professional-services-benchmarks/ · P2 · 2026 benchmark KPIs (66.4%, 37.7%, $210k, 9.9%, overrun 10.7%, 500+ firms) |
| S23 | Kantata resource page, 2025 SPI benchmark · https://www.kantata.com/resource/2025-professional-services-maturity-benchmark · P2 · corroborates 68.9% / 9.8% / 4.6% / 403 firms |
| S24 | Promethean Research, "How Profitable are Digital Agencies?" (Apr 2026) · https://prometheanresearch.com/how-profitable-are-digital-agencies/ · P1 · net margin by year/size/type, project margin 35%, avg revenue $4.43M |
| S25 | Ben Einstein (Bolt), "Will Your Hardware Startup Make Money?" (Aug 2015) · https://blog.bolt.io/will-your-hardware-startup-make-money-677a8e6c665b · P1 · $99/$32.16/$65.80 stack, $690k, retail loses money |
| S26 | Ben Einstein (Bolt), "Hardware by the Numbers Part 2: Financing + Manufacturing" (Nov 2014) · https://blog.bolt.io/hardware-financing-manufacturing/ · P1 · MOQ 5k, $1M BOM/yr, 50% deposit, tooling, certification, scrap, packaging, timelines |
| S27 | Ben Einstein (Bolt), "Hardware by the Numbers Part 4: Retail + Exits" (Feb 2015) · https://blog.bolt.io/hardware-retail-exits/ · P1 · channel margins, 90/150-day terms, 2.5–4× BOM, displays, insurance, royalties |
| S28 | Marc Barros via Adafruit, "Pricing Your Product" · https://learn.adafruit.com/how-to-build-a-hardware-startup/pricing-your-product · P1 practitioner · ≥ 50% GM rule, cost components, 15% defect assumption |
| S29 | SeriesOps, "Gross Margin for Hardware Startups" (Jan 2026) · https://seriesops.com/insights/gross-margin-hardware-startups · P3 · unsourced public comparables |
| S30 | Garrett Winther (HAX), "The rapid hard-tech emergence" (TechCrunch, Jun 2021) · https://techcrunch.com/2021/06/12/the-rapid-hard-tech-emergence/ · P2 · "80%+ gross margin" claim, B2B share |
| S31 | Ridgeway Financial, "Hardware and IoT Startup Accounting and Finance" (Oct 2025) · https://www.ridgewayfs.com/hardware-startup-financial-challenges/ · P2 · tooling, warranty reserve (ASC 460), CM commitments, inventory stages |
| S32 | Wall Street Prep, "13-Week Cash Flow Model (TWCF)" · https://www.wallstreetprep.com/knowledge/demystifying-the-13-week-cash-flow-model-in-excel/ · P2 · structure, direct method, stakeholders |
| S33 | CFI, "3-Statement Model" · https://corporatefinanceinstitute.com/resources/financial-modeling/3-statement-model/ · P2 · linkages, 8-step build order |
| S34 | CFI, "Scenario Analysis" · https://corporatefinanceinstitute.com/resources/financial-modeling/scenario-analysis/ · P2 · base/worst/best, selector mechanics |
| S35 | CFI, "Contribution Margin" · https://corporatefinanceinstitute.com/resources/accounting/contribution-margin-overview/ · P2 · CM, CM ratio, break-even units |
| S36 | CFI, "Cash Conversion Cycle" · https://corporatefinanceinstitute.com/resources/accounting/cash-conversion-cycle/ · P2 · DIO + DSO − DPO |
| S37 | FAST Standard Organisation, "The FAST Standard" (v02c, Jul 2019) · https://www.fast-standard.org/the-fast-standard/ · P1 · Flexible/Appropriate/Structured/Transparent principles |
| S38 | Christoph Janz, "SaaS Financial Plan 2.0" (Mar 2016) · https://christophjanz.blogspot.com/2016/03/saas-financial-plan-20.html · P1 · template structure and driver inputs; low-touch early-stage scope |
| S39 | Paul Graham, "Default Alive or Default Dead?" (Oct 2015) · http://paulgraham.com/aord.html · P1 · test, timing (~8–9 months), fatal pinch, growth.tlb.org |
| S40 | Joel York, "Joel's Magic Number for SaaS Companies" · https://chaotic-flow.com/saas-metrics-joels-magic-number-for-saas-companies/ · P2 · Leckie 0.75 quote, Josh James origin, cost-of-service critique |
| S41 | David Cummings, "The Magic Number for SaaS" (Oct 2016) · https://davidcummings.org/2016/10/13/the-magic-number-for-saas/ · P2 · quarterly formula, Leckie 2008 attribution |
| S42 | Klipfolio, "Burn Multiple" · https://www.klipfolio.com/resources/kpi-examples/saas/burn-multiple · P3 · unattributed tier ranges |
| S43 | BSP, Monetary Policy Report June 2026 (PDF) · https://www.bsp.gov.ph/Price%20Stability/MonetaryPolicyReport/FullReport-June2026.pdf · P1 · RRP 4.75% (18 Jun 2026), corridor, forecasts 6.4/4.5/3.1, target 3 ± 1, drivers, MB calendar |
| S44 | Trading Economics, Philippines interest rate · https://tradingeconomics.com/philippines/interest-rate · P2 · 5.00% from 27 Aug 2026 |
| S45 | Trading Economics, Philippines inflation · https://tradingeconomics.com/philippines/inflation-cpi · P2 · July 2026 6.2% headline, 4.2% core, YTD 5.0%, category drivers |
| S46 | PwC Tax Summaries, Philippines — Taxes on corporate income (rev. 01 Aug 2026) · https://taxsummaries.pwc.com/philippines/corporate/taxes-on-corporate-income · P2 · 25% / 20% thresholds / MCIT 2% |
| S47 | PwC Tax Summaries, Philippines — Other taxes (rev. 01 Aug 2026) · https://taxsummaries.pwc.com/philippines/corporate/other-taxes · P2 · VAT 12%, ₱3M threshold, contribution caps (SSS cap looks stale) |
| S48 | NWPC-DOLE, National Capital Region wage page · https://nwpc.dole.gov.ph/ncr/ · P1 · NCR-27 rates and tranches, NCR-DW-06 |
| S49 | Mercans statutory alert, Wage Order NCR-27 (Jul 2026) · https://mercans.com/resources/statutory-alerts/philippines-rtwpb-ncr-wage-order-ncr-27-raises-metro-manila-floor-to-755-day/ · P2 · prior rates, TRO 30 Jul / injunction 13 Aug 2026 |
| S50 | KAMI Workforce, "SSS, PhilHealth and Pag-IBIG Contribution Tables 2026" (May 2026) · https://kamiworkforce.com/ph/blog/sss-philhealth-pagibig-contribution-tables-2026/ · P2 · SSS 15% (10/5), MSC ceiling ₱35k, EC, PhilHealth 5%, Pag-IBIG 2%/₱200 cap |

Attempted but not usable for numbers (403/404/JS-only/binary): Medium mirror of S5; Dragon Innovation "Understanding Gross Margin in Hardware"; Philippine News Agency BSP article; Rappler BSP/inflation articles; PwC PH "CREATE MORE" article; YC Library ("Nine business models…", "Key Startup Metrics", "YC guide to business models"); Christoph Janz "Art and Science of CAC Payback" (Medium); HBR "Contribution Margin" (paywalled); Wall Street Prep "Burn Multiple" (chart image only); Fictiv landed-cost article (search-level only); Parakeeto agency benchmarks.
