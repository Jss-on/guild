# The product/engineering studio business model — research brief (2026-09-02)

Scope: how a small software + hardware engineering studio (the founders' actual situation) earns money, what "normal" looks like numerically, and which of those numbers can be turned into mechanical harness gates. All figures below were read on 2026-09-02 from the URLs in §8; anything not traceable to a fetched page is marked **UNVERIFIED** or **practitioner consensus**. Citation keys `[S#]` refer to §8. Provenance grades: P1 = primary/official (the firm's own account, the survey publisher's own report, an official body); P2 = reputable secondary (encyclopedic, established practitioner, vendor blog with methodology); P3 = aggregator/vendor marketing (use only as a rule-of-thumb echo).

Note on method: the session's web-search budget was exhausted mid-task; the remainder was done by direct fetch of known primary URLs and by reading two PDFs saved locally (SPI 2025 benchmark, JPMC Institute cash-buffer study). Pages that could not be retrieved (PSA Occupational Wages Survey, DOLE DO 174-17, NWPC wage tables, PMI Pulse 2018, Glassdoor/Upwork rate pages, licensing-royalty sources) are named in §8 so the harness owner can fetch them by hand.

---

## 1. Standard process — first project → stable business

The professional-services literature is unusually consistent about the order of operations. SPI Research's maturity model (18 years, ~7,000 firms benchmarked) explicitly says a Level-1 firm's job is *client acquisition and reference building*, and only later finance/operations optimization [S1]. Ordered steps with named deliverables:

| # | Step | Named deliverable | Gate evidence |
|---|------|-------------------|---------------|
| 0 | Stand up the **studio ledger** before selling (time, revenue, cost, client, invoice, cash) | `studio-ledger.csv` v0 with the columns in §5 | SPI: revenue leakage (earned but never billed) averages 5.3%, 6.4% for firms under 10 people — it starts on day one [S1] |
| 1 | **Choose a positioning** (vertical or horizontal) and test market size | Positioning statement + prospect-count test | Baker: viable niche = 10–200 competitors, 2,000–10,000 qualified prospects; 1% capture of 2,000 = 20 clients; 85% of positioned agencies chose a vertical [S17] |
| 2 | Build the **offer ladder**: paid diagnostic → fixed-scope project → retainer/managed service → (later) product | Offer sheet with price, deposit, milestone and change-order terms | SPI 2024 mix: 39.6% T&M, 38.9% fixed fee, 8.3% managed services, 8.2% subscription, 3.3% shared-risk; firms under 10 skew fixed fee (41.4%) [S1] |
| 3 | Install a **pipeline ledger** and a business-development floor | `pipeline.csv` (stage, value, forecast quarter) | SPI: pipeline should be ≥2× next-quarter forecast; 49.3% of firms are below that [S1]. Sakas: block 1–2 h/week for BD even when busy; see gaps 3–6 months out [S20] |
| 4 | Close the **first 3 paying projects** on deposit + milestones | Signed SOW + deposit receipt per project | Sakas: deposit 20–50%; 50/25/25 for mid-size; avoid 50/50 on big jobs; trigger milestones on *delivery*, not approval; new small clients 100% up front [S19] |
| 5 | Install **delivery control**: SOW, change orders, time capture, on-time tracking | Change-order log; weekly time sheet | SPI: on-time delivery 73.4%, overrun 11.3% (2024); >10% overrun "undermines Service Execution" [S1]. Scope creep hits 37–52% of projects (PMI figure via aggregator — P3) [S22] |
| 6 | **Monthly KPI review** (utilization, realized rate, project margin, concentration, DSO, cash-buffer days) | KPI sheet; red/amber/green per §5 | SPI names five metrics that matter most: billable utilization, project overrun, project margin, revenue per billable consultant, revenue leakage [S1] |
| 7 | **Stabilize revenue**: references, retainer share, subcontractor bench | Reference list (≥70% of clients referenceable); retainer % | SPI: 70.1% of clients referenceable is average; subcontractors deliver 10.9% of revenue [S1]. Retainer churn 18%/yr vs 42% for project-only (P3) [S23] |
| 8 | Only then: **product or equity bets** funded from services surplus | Product P&L kept separate; equity term sheet human-approved | 37signals stopped web design about a year after Basecamp out-earned it [S8]; thoughtbot sold FormKeep when it "needed a dedicated team" [S11]; studios take ~34% equity on average (15–80% range) [S3] |

---

## 2. Models & frameworks

| Revenue model | What it requires | Economics (sourced) | Known pitfalls | Sources |
|---|---|---|---|---|
| **Project work — fixed fee** | Tight SOW, estimation skill, change control | Independents' project margin averages 35.9%; agencies sell 60.4% fixed-fee; fixed-fee share rose 35.5% (2009) → 44.7% (2022), fell to 38.9% (2024) as overruns bit | Overrun risk sits with the studio; "one or two money-losing projects can quickly undermine all profit" | [S1] |
| **Project work — time & materials** | Time capture, client trust | IT consultancies sell 53.1% T&M; SPI: independents "have always preferred T&M" and are moving back to it | Hourly anchor: "as long as you bill by the hour, your clients will treat you as labor"; income ceiling; rewards inefficiency | [S1][S18] |
| **Retainers / managed services** | Recurring scope, SLA, monthly invoicing in advance | Managed services 8.3% of PS work sold (2024); retainer churn 18%/yr vs 42% for project clients (P3) | Scope drift inside a flat fee; collect in advance (Sakas) | [S1][S19][S23] |
| **Productized services** (fixed-scope, fixed-price packages) | Repeatable method, packaging, marketing | SPI: "very few organizations are effective at service productization"; solution-development effectiveness scores 3.45/5 | Needs executive sponsorship and ongoing resource commitment; most firms never finish the packaging | [S1] |
| **Dedicated teams / staff augmentation** (PH-relevant) | Recruiting engine, retention, client success mgmt | Staff augmentation 5.8% of PS work; Full Scale (Cebu-founded 2018): 350+ engineers, flat monthly rate covering salary/equipment/benefits, 93%+ retention, $30–40/hr fully loaded | Margin is thin and rate-benchmarked; revenue per head capped by client rate cards | [S1][S30][S31] |
| **Licensing / royalties** (software white-label, hardware design royalty) | Ownable IP, contract, audit rights | **UNVERIFIED** — no P1/P2 royalty-rate source retrievable this session; treat rates as a human-negotiated term | Without written IP/tooling ownership, there is nothing to license (Ontario Dynamics: ownership transfers "only if your contract says so") | [S26] |
| **Own SaaS product** | Surplus cash, separate P&L, marketing | Basecamp: internal tool (built 2003, launched 2004) out-earned web design within ~a year; consulting stopped 2005; company still bootstrapped and profitable. Mailchimp: side project of a web-design agency from 2001; freemium (2009) took users 85k → 450k in a year; $700M revenue 2019; sold to Intuit for $12B (2021) | Product needs a dedicated team (thoughtbot/FormKeep); consultancy bandwidth is the scarce input; many years as a side project (Mailchimp ~5 yrs) | [S8][S9][S10][S11][S13][S14] |
| **Own hardware product** | NRE cash, tooling cash, certification, MOQ working capital | NRE: $10–30k simple, >$250k complex; tooling 60–70% of NRE; steel production tooling $15–120k+; tooling ≈ 20–30% of total manufacturing cost; CM MOQs "several hundred to several thousand units" | Buyer (the studio) pays NRE; tooling/CAD/IP ownership must be in the contract; MOQ ties up cash before first sale | [S26][S27] |
| **Hardware NRE-for-hire (+ optional royalty)** | Design capability, clear IP clause, milestone billing | Client pays NRE (buyer pays "whether that's a startup or an established manufacturer"); studio margin comes from the fixed NRE fee | Certification cost is a distinct NRE line with no benchmark retrieved (**UNVERIFIED** figures); royalty terms UNVERIFIED | [S26] |
| **Venture-studio / equity deals** | Capital to fund ventures, founder recruiting, repeatable stage gates | GSSN survey (258 studio startups, 2020): 84% raise seed, 72% of those reach Series A (vs 42% traditional), 25.2 months to A (vs 56), IRR 53% vs 21.3%; studio takes ~34% at founding (range 15–80%); eFounders built 27 cos with $11.4M studio funding; Idealab 145+ companies, 45+ IPOs/acquisitions since 1996 | Cap-table over-ownership "makes it hard to recruit founders and investors" (Signature Block quoting BCV); no standardized terms; requires cash the founders do not have | [S3][S4][S5][S7] |

Three frameworks worth carrying into the harness:

1. **SPI Service Performance Pillars** (Leadership, Client Relationships, Talent, Service Execution, Finance & Ops) with five maturity levels; Level 1 → Level 5 moves utilization 59.6% → 83.6%, project margin 16.5% → 55.8%, revenue per billable consultant $105k → $294k, EBITDA 2.7% → 20.8% [S1].
2. **Baker's positioning test** (competitor count, prospect count, "20 aha moments", geography: 80% of clients within 50 miles = weak positioning) [S17].
3. **AMI 55/25/20 rule** of agency gross income — 55% salaries+contractors, 25% overhead, 20% profit (Drew McLellan; reported via aggregator, P3) [S22].

---

## 3. Numbers annex

| Metric | Benchmark / threshold | Context (services / hardware / geo / date) | Source URL | Grade | Retrieved |
|---|---|---|---|---|---|
| Billable utilization | 68.9% avg; **75% "optimal"**; under-10 firms 64.3%; top-20% firms 76.2%; Level 5 83.6% | 403 PS firms, global, survey Sep–Dec 2024 | [S1] | P1 | 2026-09-02 |
| Project margin | 35.9% avg (5-yr 35.5%); under-$5M firms 34.0%; Level 5 55.8% | same | [S1] | P1 | 2026-09-02 |
| Revenue per billable consultant | $199k avg (2024), $207k (2023); under-10 firms $178k; rule: ≥1.5× fully loaded cost (min), plan on 2×; "3× common in engineering/architecture" | same | [S1] | P1 | 2026-09-02 |
| Revenue per employee | $158k avg; under-10 $147k; rule: ≥1.4× loaded cost, ideally >2× | same | [S1] | P1 | 2026-09-02 |
| Revenue per FTE (agencies) | $172k avg; $200–300k good; $300–500k excellent (Promethean via aggregator) | digital agencies, 2025/26 | [S22][S25] | P3/P2 | 2026-09-02 |
| EBITDA | 9.8% (2024) vs 15.4% (2023); under-10 firms 10.5% (was 21.0%); aspirational 20% independents / 25% embedded | same as SPI | [S1] | P1 | 2026-09-02 |
| Agency net margin | 13% industry avg 2025; studios <10 FTE 19%; 50+ FTE 8%; development agencies 11% | agencies, Promethean data 2025 | [S23][S25] | P3/P2 | 2026-09-02 |
| Deal pipeline / next-quarter forecast | 166% avg; **≥200% recommended**; 49.3% of firms below 2×; 3× cohort grows 6.2%, 4× cohort 8.2% | SPI 2024 | [S1] | P1 | 2026-09-02 |
| Backlog at quarter start | 42.8% of quarterly target avg; under-10 33.4%; >50% cohort grows 8.5% | SPI 2024 | [S1] | P1 | 2026-09-02 |
| Bids won | 47.3% avg; under-10 51.3%; "too high = not aggressive, too low = commoditized" | SPI 2024 | [S1] | P1 | 2026-09-02 |
| Service discount given | 9.1% avg; >70% of firms discount <10%; >20% correlates with higher attrition, fewer references | SPI 2024 | [S1] | P1 | 2026-09-02 |
| Referenceable clients | 70.1% avg; under-10 72.6% | SPI 2024 | [S1] | P1 | 2026-09-02 |
| Revenue leakage | 5.3% avg; under-10 6.4%; target <5% | SPI 2024 | [S1] | P1 | 2026-09-02 |
| Project overrun / on-time | 11.3% overrun; 73.4% on time; overrun >10% flagged | SPI 2024 | [S1] | P1 | 2026-09-02 |
| DSO | 43.3 days avg; under-10 37.4; large firms 52 | SPI 2024 | [S1] | P1 | 2026-09-02 |
| Subcontractor share of revenue | 10.9%; firms with none: EBITDA 13.6%; >30%: 11.8% | SPI 2024 | [S1] | P1 | 2026-09-02 |
| Non-billable expense per employee | $1,378/quarter avg; >$3,000/quarter "excessive" | SPI 2024 | [S1] | P1 | 2026-09-02 |
| Fully loaded cost per consultant | $109k (Level 1) → $154k (Level 5) | SPI 2024, mostly North America | [S1] | P1 | 2026-09-02 |
| Cost structure (under-10 PS firms) | Direct labor 40.5% of revenue, fringe 10.7%, subcontractors 10.4%, sales 2.9%, marketing 1.7%, G&A 9.9%, EBITDA 10.5% | SPI 2024 income statement | [S1] | P1 | 2026-09-02 |
| Deposit | 20–50% up front; mid-size 50/25/25; big projects min 20% (33% if thirds); avoid 50/50; new small clients 100% in advance | agency practice (Sakas) | [S19] | P2 | 2026-09-02 |
| Client concentration | Red flags: any client >20–25%; top-3 >50%; top-5 >70% | consulting-firm valuation blog (no external cites) | [S21] | P2 | 2026-09-02 |
| Client concentration (echo) | Single client ≤25%; top-3 ≤50% | agency aggregator | [S22] | P3 | 2026-09-02 |
| Cash buffer days | Median 27; 25% of firms <13; 25% >62; high-tech services median 33 (25th/75th: 15/77); other professional services 33 (15/72); high-tech manufacturing 32 (15/71) | 597,000 US small businesses, Feb–Oct 2015, pub. Sep 2016 | [S36] | P1 | 2026-09-02 |
| Positioning viability | 10–200 competitors; 2,000–10,000 prospects; assume 1% capture; 85% of positioned agencies vertical | David C. Baker (AMI podcast ep. 181) | [S17] | P2 | 2026-09-02 |
| BD time floor | 1–2 h/week blocked; pipeline gaps visible 3–6 months out | Sakas | [S20] | P2 | 2026-09-02 |
| Retainer vs project churn | 18%/yr (56-mo life) vs 42%/yr (24-mo life); 1–10-person firms 32% | agency aggregator citing Focus Digital | [S23] | P3 | 2026-09-02 |
| Hardware NRE | $10–30k simple; >$250k complex; tooling 60–70% of NRE; steel tooling $15–120k+; buyer pays | contract-manufacturing vendor, 2026-08-13 | [S26] | P2 | 2026-09-02 |
| Tooling share / MOQ | Tooling ≈20–30% of manufacturing cost; NRE usually <10%; MOQ "several hundred to several thousand units" | US contract manufacturer blog | [S27] | P2 | 2026-09-02 |
| Venture-studio outcomes | 84% raise seed; 72% seed→A (vs 42%); 25.2 mo to A (vs 56); IRR 53% vs 21.3%; TVPI 5.8 vs 1.57; studio equity ~34% (15–80%) | GSSN survey of 258 studio startups, 2020 | [S3] | P1 | 2026-09-02 |
| Studio equity range | 30–70% typical vs 5–10% accelerators | Signature Block, 2023-09-20 | [S4] | P2 | 2026-09-02 |
| Studio track records | Idealab: 145+ cos, 45+ IPOs/acquisitions (since 1996); Hexa/eFounders: 50+ cos, $5B combined valuation, 12 exits (since 2011); eFounders reached 27 cos/$1.5B valuation on $11.4M studio funding | studios' own sites; GSSN | [S5][S7][S3] | P1 | 2026-09-02 |
| Services→product timelines | Basecamp: built 2003, launched 2004, consulting stopped 2005; Mailchimp: side project 2001, freemium 2009 (85k→450k users in 1 yr), $700M rev 2019, $12B exit 2021; Pivotal Labs: founded 1989, Tracker from internal tool 2008 (240k developer users by 2012), acquired by EMC 2012, Tanzu Labs shut Jan 2025 | firms' own pages + Wikipedia + EMC release | [S8][S10][S13][S14][S15][S16] | P1/P2 | 2026-09-02 |
| PH software engineer pay (job ads) | Top cities: Mandaluyong ₱100,000/mo; Manila ₱76,500; Taguig ₱75,000; Pampanga ₱72,500 | JobStreet PH, Sep 2026, employer-disclosed ranges | [S28] | P2 | 2026-09-02 |
| PH software developer pay (job ads) | Mandaluyong ₱155,000; Isabela ₱120,000; Manila ₱80,000; Taguig ₱66,250; Quezon City ₱60,000 | JobStreet PH, Sep 2026 | [S29] | P2 | 2026-09-02 |
| PH pay bands (vendor synthesis) | Entry ₱40–60k; junior–mid ₱60–100k; senior ₱100–150k; very senior ₱150–250k; Glassdoor median ₱44k (₱33–75k); Metro Manila +20–30% vs provinces; 13th month ≈ +8%/yr | Full Scale blog, 2026-08-30 | [S30] | P3 | 2026-09-02 |
| PH IT-BPM industry | $40B revenue; 1.9M workforce (undated on page) | IBPAP | [S32] | P1 | 2026-09-02 |
| PH minimum wage / PSA wages | **UNVERIFIED** — NWPC page exposes only a PDF link; PSA OWS returned 403 | — | — | 2026-09-02 |

---

## 4. Philippine specifics

**Wage / rate data (what was retrievable).** JobStreet's employer-disclosed ranges put Metro Manila software engineers around ₱75–100k/month at the top-paying cities and developers at ₱60–80k, with Mandaluyong outliers to ₱155k [S28][S29]. A vendor synthesis (Full Scale, Cebu-based, so read as marketing) clusters public sites at ₱40–60k for "software engineer, Philippines", gives a senior band of ₱100–150k, adds ~8% for the mandatory 13th-month pay, notes Metro Manila runs 20–30% above provinces, and quotes its own fully loaded dedicated-engineer rate at $30–40/hour [S30]. IBPAP's headline is $40B industry revenue and a 1.9M workforce, undated on the page [S32]. Official sources (PSA Occupational Wages Survey, DOLE Department Order 174-17 on contracting, NWPC minimum-wage tables) could not be fetched — **UNVERIFIED**; the harness should require a human to paste the current NCR wage order and the DO 174 compliance checklist before any "hire vs contract" gate runs.

**Hiring vs contracting.** SPI's global data: subcontractors deliver 10.9% of PS revenue; firms using none show the highest EBITDA (13.6%) but are small (84 people avg); firms above 30% subcontracted revenue show 11.8% EBITDA [S1]. For a studio under 10 people the benchmark subcontractor share is 10.4% [S1]. PH-specific legal constraints on contracting exist but their text was not retrievable (UNVERIFIED).

**Verifiable PH ecosystem cases (all P1, own sites):**
- **Symph** — PH software studio: "89 engineers, 16 years of craft"; builds web/mobile/AI applications and business-process systems; clients include the DBM Office of the CIO and M Lhuillier [S33]. Evidence that a project-work studio can reach ~90 engineers on domestic government + enterprise work.
- **Full Scale** — founded 2018 by Matt Watson (ex-Stackify CTO), 350+ full-time Philippine engineers on a flat monthly rate, 93%+ retention, 200+ US SaaS clients, five-time Inc. 5000 [S31]. The clearest PH example of the *dedicated-team* model scaling; its margin structure is not disclosed.
- **Thinking Machines** — Manila/Bangkok/Singapore data-and-AI consultancy; consulting-led ("work alongside your team"), took a strategic investment from Temus [S34]. Example of a consultancy staying a consultancy and raising strategic capital instead of productizing.
- **Xurpas** — "over 24 years" operating, 150+ employees, 9.7-year average client retention, now an ERP/CRM/HRIS reseller plus custom development and IT staffing for clients such as ADB, Globe, Metrobank, Unilever [S35]. Its listed-company history (IPO, later losses) was not retrievable this session — **UNVERIFIED**, do not cite numbers.
- **PH hardware startups:** none could be verified from a primary page this session — **no citable case**; the harness should not assume local hardware-studio precedent.

---

## 5. Mechanical gate candidates

**Ledger columns (`studio-ledger.csv`, one row per person-day or per invoice line; derived KPIs computed by script):**
`period, person_id, hours_available, hours_billable, hours_billed, project_id, client_id, model (fixed|tm|retainer|product|nre), list_rate, revenue_recognized, invoice_id, invoice_date, paid_date, direct_labor_cost, subcontractor_cost, passthru_cost, fully_loaded_cost_per_fte, change_order_id, scope_delta_value, deposit_received, cash_balance, avg_daily_outflow_30d, pipeline_weighted_value, forecast_next_q, backlog_value, bid_id, bid_won`

| KPI (formula) | Threshold (source) | Gate action |
|---|---|---|
| Utilization = Σhours_billable / Σhours_available (trailing 90 d) | Floor 65% (SPI under-10 avg 64.3%); target 75% (SPI optimal) [S1] | <65% → block new hires; >85% → block new sales commitments without hire |
| Realization = revenue_recognized / (hours_billable × list_rate) | ≥90% (SPI avg discount 9.1%; >20% correlates with attrition) [S1] | <80% → pricing review before next proposal |
| Revenue per billable FTE / fully_loaded_cost_per_fte | ≥1.5× minimum, 2× plan (SPI) [S1] | <1.5× → freeze headcount, raise rates |
| Project margin = (project_revenue − direct − sub − passthru) / project_revenue | ≥35% (SPI avg 35.9%) [S1]; ≥70% delivery margin on individual projects (Parakeeto via aggregator, P3) [S22] | <25% on any closed project → post-mortem required before similar bid |
| Overrun = (actual_cost − estimate) / estimate | ≤10% (SPI) [S1] | >10% on two consecutive projects → estimation method change |
| Leakage = (hours_billable − hours_billed) / hours_billable | ≤5% (SPI) [S1] | >5% → invoice audit |
| Pipeline coverage = pipeline_weighted_value / forecast_next_q | ≥2.0× (SPI recommendation); 3× stretch [S1] | <2× → BD hours become mandatory; <1× → hiring frozen |
| Backlog coverage = backlog_value / quarterly_target | ≥40% (SPI avg 42.8%) [S1] | <30% → alarm |
| Bid win rate (trailing 8 bids) | 40–60% band (SPI) [S1] | >70% → raise prices; <30% → positioning review |
| Client concentration = max(client_rev) / total_rev (TTM) | ≤20% amber, ≤25% red; top-3 ≤50%; top-5 ≤70% [S21] | Above red → no new work for that client until another signs |
| DSO = Σ(paid_date − invoice_date)/n | ≤45 d (SPI avg 43.3; under-10 37.4) [S1] | >60 d → collections script + stop work clause |
| Cash buffer days = cash_balance / avg_daily_outflow_30d | Floor 27 (JPMC median); alarm 13 (25th pct); target 62+ (75th pct) [S36] | <27 → only cash-in-advance work; <13 → founders' salary hold |
| Deposit ratio = deposit_received / project_value at SOW | ≥20% (Sakas floor; 50% mid-size) [S19] | <20% → SOW cannot be countersigned |
| EBITDA = (revenue − all cost) / revenue (TTM) | Floor 10% (SPI 2024 avg 9.8%, under-10 10.5%); target 20% [S1] | <10% for 2 quarters → cost plan |
| Non-billable expense per employee per quarter | ≤$3,000 (SPI "excessive" line) [S1] | Above → expense review |
| Product-bet gate = product_MRR×12 / services_revenue (TTM) | Founders shift only when product revenue > services revenue (the 37signals rule) [S8] | Until then product time is capped as a ledger line |
| Referenceable share = referenceable_clients / active_clients | ≥70% (SPI) [S1] | Human enters flag; script counts |

**What cannot be mechanized (stays human-gated):** the positioning decision itself; whether a client is genuinely referenceable; SOW quality and acceptance criteria; firing a client; IP and tooling ownership terms; any equity or royalty negotiation; hiring/termination under PH labor law; pricing a novel engagement; the go/no-go on a product or hardware bet (the script can only prove the cash and margin preconditions).

---

## 6. Early irreversibles

1. **Positioning / niche.** Portfolio, references and hiring compound around it; Baker: fear of "not being busy enough" is what keeps firms generalist, and generalists cannot command premiums [S17]. Reversal cost: years of case studies.
2. **IP and tooling ownership in the first hardware contracts.** Ownership passes "only if your contract says so"; get "tooling, CAD file, and IP ownership written in before you sign" [S26]. Reversal cost: rebuild the design or buy it back.
3. **Pricing anchor (hourly vs value/fixed).** Once clients see an hourly rate, "your clients will treat you as labor" [S18]; SPI shows clients pushing risk onto the firm via fixed fee when trust is thin [S1]. Reversal cost: client-by-client re-negotiation.
4. **Model mix committed in year one.** Firms under 10 sell 60.9% consulting and only 5.6% managed services [S1]; retainers churn at 18% vs 42% for projects (P3) [S23]. Reversal cost: revenue base has to be rebuilt.
5. **Equity given to a studio, investor or partner.** Studio average 34% at founding, up to 80% [S3]; over-ownership "makes it hard to recruit founders and investors for later rounds" [S4]. Not reversible.
6. **Where product IP lives.** thoughtbot had to move FormKeep out to a dedicated owner once it grew [S11]; Basecamp's company was later renamed after the product and then back again [S9][S10]. Set the product entity and IP assignment before the first paying user.
7. **First anchor client above 25% of revenue.** Concentration compresses valuation and negotiating leverage [S21]; hard to dilute once the team is sized to that client.

---

## 7. Failure modes / anti-patterns the harness must guard against

| Anti-pattern | Evidence | Guard |
|---|---|---|
| Founder stops selling when delivery gets busy (feast–famine) | "When I stop working in BD almost every day, deals stop moving. When I'm pulled back in to fixing delivery problems, BD drops off a cliff" [S20] | BD-hours floor + pipeline ≥2× gate (§5) |
| Pipeline below 2× forecast | 49.3% of PS firms are there; those firms grow slower and discount more [S1] | Pipeline gate |
| Winning by discounting | Heavy discounters (>20%) show higher attrition and fewer references; "there is no way to recoup hours worked at cheap rates" [S1] | Realization ≥90% gate |
| Hourly-only billing | Misaligned incentives; income ceiling [S18] (practitioner) | Offer ledger must carry ≥1 fixed/retainer offer |
| 50/50 payment split on large projects | Studio can finish 80–95% of the work with 50% of the cash [S19] | Deposit ≥20% + milestones-on-delivery gate |
| Unbilled work / leakage | 5.3% of revenue lost before it is billed; smaller firms 6.4% [S1] | Leakage ≤5% gate |
| Uncontrolled scope | Scope creep in 37–52% of projects (PMI via aggregator, P3) [S22]; SPI: "change control is an important element of pricing" [S1] | Change-order log mandatory; overrun ≤10% gate |
| One client too big | >20–25% single client = red flag; top-3 >50% [S21] | Concentration gate |
| Cash buffer under two weeks | 25% of small businesses hold <13 days [S36] | Cash-buffer gate |
| Product built inside the consultancy with no dedicated team | thoughtbot: "we needed a dedicated team to give FormKeep proper attention" [S11]; Mailchimp stayed a side project for years [S13] | Product-bet gate; separate product P&L |
| Paying NRE/tooling without owning the output | Tooling/IP ownership only if contracted [S26] | Human IP gate before any hardware PO |
| Underestimating hardware working capital | NRE up to >$250k; tooling 60–70% of NRE; MOQs in the hundreds to thousands of units [S26][S27] | Cash-buffer gate must include committed NRE/MOQ outflows |
| Giving away too much equity for "studio support" | 30–70% typical; cap-table critique [S4][S3] | Human-only gate; no script may approve equity |
| Generalist "do everything" positioning | Generalists sound like every other firm; positioning creates pricing power [S17] | Positioning deliverable required before offer sheet |
| Small-firm process immaturity | Firms under 10 score lowest maturity (2.12/5); their EBITDA halved 21.0% → 10.5% in one year [S1] | Monthly KPI review gate |
| Over-reliance on subcontractors for growth | >30% subcontracted revenue → lower EBITDA (11.8% vs 13.6%) [S1] | Subcontractor share tracked; human review above 30% |

**Practitioner consensus (no single citable source):** never let a single engineer be both the only salesperson and the only deliverer for more than one quarter; never quote hardware without a written BOM-cost and certification allowance; never let product work consume more than a fixed weekly allotment until the product-bet gate passes.

---

## 8. Sources

Format: key · title · URL · type/grade · what was used.

- **[S1]** SPI Research, *2025 Professional Services Maturity™ Benchmark* (full report, Feb 2025; 403 firms; Kantata-hosted PDF) · https://get.kantata.com/rs/677-LEJ-696/images/2025-ps-maturity-benchmark.pdf · P1 · utilization, project margin, revenue/consultant and /employee, EBITDA, pipeline ≥2× rule, backlog, bids won, discounting, leakage, DSO, subcontractor share, under-10-employee segment, maturity-level table, pricing mix, income statement, productization finding.
- **[S2]** SPI Research, report page for the 2025 benchmark · https://spiresearch.com/reports/2025-ps-maturity-benchmark/ · P1 · sample (403 firms, 150,000+ consultants), report price.
- **[S3]** Global Startup Studio Network, *Disrupting the Venture Landscape* (white paper, 2020) · https://insightstudios.s3.amazonaws.com/Disrupting-the-Venture-Landscape_GSSN-White-Paper-1.pdf · P1 (industry body) · studio counts, seed/Series-A rates, IRR/TVPI, time-to-round, average studio equity 34% (15–80%), eFounders/High Alpha/Science case data, Idealab portfolio rates.
- **[S4]** Signature Block, *Venture studios & incubations* (2023-09-20) · https://signatureblock.co/articles/venture-studios · P2 · 30–70% equity range, cap-table and standardization critiques.
- **[S5]** Idealab, homepage · https://www.idealab.com/ · P1 · founded 1996, 145+ companies, 45+ IPOs/acquisitions.
- **[S6]** Atomic, homepage · https://atomic.vc/ · P1 · studio model description, portfolio names (no terms disclosed).
- **[S7]** Hexa (formerly eFounders), homepage · https://www.hexa.com/ · P1 · founded 2011, 50+ companies, $5B combined valuation, 12 exits, Start/Sprint/Scale model.
- **[S8]** Basecamp, *About* · https://basecamp.com/about · P1 · "about a year or so after we first released it, it was generating more revenue for us than our web design business. So we stopped doing web design."
- **[S9]** Jason Fried, *37signals: Hello again* (2022-05-03) · https://world.hey.com/jason/37signals-hello-again-117eae60 · P1 · 1999 web-design origin, 2014 single-product focus/rename, HEY 2020, 2022 rename back.
- **[S10]** Wikipedia, *37signals* · https://en.wikipedia.org/wiki/37signals · P2 · timeline 2003/2004/2005/2006/2014/2022; 34 employees (2021).
- **[S11]** thoughtbot, *FormKeep Moves to Furious Collective* (Nov 2017) · https://thoughtbot.com/blog/formkeep-moves-to-furious-collective · P1 · products "come out of our consulting work"; FormKeep founded 2014; sold because it "needed a dedicated team".
- **[S12]** thoughtbot, *Last Year at thoughtbot* (Jan 2015) · https://thoughtbot.com/blog/last-year-at-thoughtbot · P1 · FormKeep and Hound released 2014; Upcase rename.
- **[S13]** Mailchimp, *About* · https://mailchimp.com/about/ · P1 · Rocket Science Group web-design agency origin, founded Atlanta 2001, Intuit acquisition 2021.
- **[S14]** Wikipedia, *Mailchimp* · https://en.wikipedia.org/wiki/Mailchimp · P2 · 2009 freemium 85k→450k users, $700M revenue 2019, $12B Intuit deal (Sept–Nov 2021), 13M users.
- **[S15]** Dell/EMC press release, *EMC Acquires Pivotal Labs* (2012-03-20) · https://www.dell.com/en-us/dt/corporate/newsroom/announcements/2012/03/20120320-02.htm · P1 · founded 1989, agile services + tools, Tracker 240,000 developer users, all-cash, price undisclosed.
- **[S16]** Wikipedia, *Pivotal Labs* · https://en.wikipedia.org/wiki/Pivotal_Labs · P2 · pair-programming consultancy, Tracker 2008 from internal tool, Xtreme Labs 2013, VMware 2019, Tanzu Labs shut Jan 2025, Tracker retired Apr 2025.
- **[S17]** Agency Management Institute podcast ep. 181, *The business of expertise with David C. Baker* · https://agencymanagementinstitute.com/podcasts/david-baker/ · P2 · generalist critique, 10–200 competitors, 2,000–10,000 prospects, 1% capture, 85% vertical, 50-mile test.
- **[S18]** Jonathan Stark, *Hourly Billing Is Nuts* · https://jonathanstark.com/hbin · P2 (practitioner) · misaligned incentives, "treated as labor", income ceiling.
- **[S19]** Karl Sakas, *Digital marketing agency deposits: How much, and when?* · https://sakasandcompany.com/project-milestones-and-deposits/ · P2 · 20–50% deposit, 50/25/25, avoid 50/50, milestones on delivery, retainers in advance.
- **[S20]** Karl Sakas, feast-or-famine article · https://sakasandcompany.com/feast-or-famine/ · P2 · BD-drops-when-delivering quote, 1–2 h/week BD floor, 3–6-month pipeline horizon.
- **[S21]** Projectworks, *Client Concentration Risk* (2026-06-03) · https://www.projectworks.com/blog/client-concentration-risk · P2 (vendor, no external cites) · >20–25% single client, top-3 >50%, top-5 >70%.
- **[S22]** Swydo, *Agency Profitability Guide* (2026) · https://www.swydo.com/blog/agency-profitability/ · P3 aggregator · AMI 55/25/20, Promethean $172k/FTE, Parakeeto delivery margins, PMI scope-creep 37–52%, concentration echo.
- **[S23]** Forge, *Agency Benchmarks Report 2026* (updated 2026-06-09) · https://forge.so/agency-benchmarks · P3 aggregator (cites Promethean, Wow Company BenchPress, Focus Digital) · net margin by size/type, retainer vs project churn, revenue/employee bands, utilization by role.
- **[S24]** TMetric, *Marketing Agency Benchmarks 2025* · https://blog.tmetric.com/marketing-agency-profitability-benchmarks/ · P3 · 65–80% utilization band, specialist vs generalist margins, unbilled-time stats.
- **[S25]** Promethean Research, *Digital Agency Industry Report* (2026 landing page) · https://prometheanresearch.com/digital-agency-industry-report/ · P2 (survey publisher's summary) · 1,452 leaders surveyed; 13% net margin 2025; studios <10 FTE margins >2× 50+ FTE; service reduction → 30% net vs 10% for expansion; 7% of revenue on sales/marketing.
- **[S26]** Ontario Dynamics, *NRE Costs: What They Cover, Who Pays & How to Budget* (2026-08-13) · https://ontariodynamics.com/blog/non-recurring-engineering-nre-costs/ · P2 (vendor) · NRE ranges, tooling 60–70% of NRE, buyer pays, ownership only by contract.
- **[S27]** PEKO Precision, *Contract Manufacturing Costs: Understanding NRE, Tooling, and Minimum Buy Requirements* · https://www.pekoprecision.com/blog/contract-manufacturing-costs-nre-tooling-minimum-buys/ · P2 (vendor) · NRE <10% of manufacturing cost, tooling 20–30%, MOQ hundreds–thousands.
- **[S28]** JobStreet PH, *Software Engineer Salary in PH* (Sept 2026) · https://ph.jobstreet.com/career-advice/role/software-engineer/salary · P2 · top-city monthly averages from employer-disclosed ad ranges.
- **[S29]** JobStreet PH, *Software Developer Salary in Philippines* (Sept 2026) · https://ph.jobstreet.com/career-advice/role/software-developer/salary · P2 · top-city monthly averages.
- **[S30]** Full Scale, *Software Engineer Salary in the Philippines* (2026-08-30) · https://fullscale.io/blog/software-engineer-salary-in-the-philippines/ · P3 (vendor synthesis of Glassdoor/Indeed/JobStreet/PayScale/Levels.fyi) · pay bands, Manila premium, 13th month, $30–40/hr loaded rate.
- **[S31]** Full Scale, *About* · https://fullscale.io/about/ · P1 (company's own facts) · founded 2018, 350+ engineers, flat monthly rate, 93% retention, 200+ SaaS clients.
- **[S32]** IBPAP, homepage · https://ibpap.org/ · P1 · $40B revenue, 1.9M workforce (undated).
- **[S33]** Symph, *About* · https://symph.co/about · P1 · 89 engineers, 16 years, services, named clients.
- **[S34]** Thinking Machines, *About* · https://thinkingmachin.es/about/ · P1 · consulting model, Manila/Bangkok/Singapore, Temus strategic investment.
- **[S35]** Xurpas, homepage · https://www.xurpas.com/ · P1 · "over 24 years", 150+ employees, 9.7-year client retention, current service lines.
- **[S36]** JPMorgan Chase Institute, *Cash is King: Flows, Balances, and Buffer Days* (Sept 2016) · https://www.jpmorganchase.com/content/dam/jpmc/jpmorgan-chase-and-co/institute/pdf/jpmc-institute-small-business-report.pdf · P1 · median 27 cash-buffer days, 13/62-day quartiles, industry medians (high-tech services 33, other professional services 33, high-tech manufacturing 32).

**Attempted but not retrievable (fetch by hand before relying on them):** PSA Occupational Wages Survey (psa.gov.ph, 403); DOLE Department Order 174-17 PDF (403); NWPC regional minimum-wage tables (page exposes only a PDF link); PMI *Pulse of the Profession 2018* (404/403 — the 52% scope-creep figure is therefore P3 here); Jason Fried's Medium origin story (403); Win Without Pitching manifesto (403); Glassdoor and Upwork PH rate pages (403); Agency Management Institute and Promethean full benchmark PDFs (paywalled); any P1/P2 source for hardware design-royalty percentages; any primary page for a Philippine hardware startup.
