# Go-to-market & B2B sales — research brief (2026-09-02)

Domain 06 of the guild body of knowledge. Scope: GTM plan, sales-motion choice by ACV, founder-led sales to the first 10 customers, lead lists, outbound, discovery, qualification, pipeline/forecast, proposals, channels, and Philippine B2B/government selling. Every number below is tied to a URL that was actually fetched on 2026-09-02; anything not fetched is marked UNVERIFIED. Provenance grades: P1 = primary/authoritative (originator, law text, official site, first-party dataset), P2 = reputable secondary (vendor benchmark blog, VC essay, secondary summary of a primary dataset), P3 = weak (agency blog, third-party guide).

---

## 1. Standard process — ordered steps and named deliverables

The sequence below merges Kazanjy's *Founding Sales* chapter order (narrative → materials → prospecting → outreach → pitch → close → success) [S10], Koomen's six steps (prospecting → outreach → qualification → pricing → closing → implementation) [S9], and the Leslie & Holloway rule that a new product's selling process is *learned* before it is scaled [S4].

| # | Step | Named deliverable (what the harness stores) | Source anchor |
|---|------|---------------------------------------------|---------------|
| 0 | **Sales hypothesis** — segment, the specific problem, why you win | `gtm/hypothesis.md`: ICP definition (firmographics, role, trigger), problem statement, value equation | Koomen: "Develop a sales hypothesis identifying the customer segment, their specific problem, and how your solution helps" [S9] |
| 1 | **GTM plan** — segment · value prop · channel · pricing · motion | `gtm/plan.md` with the five fields filled and the motion justified by expected ACV (§2, §3) | Skok CAC-by-touch [S1]; Janz ACV bands [S26]; a16z [S2] |
| 2 | **Sales narrative + materials** | one-page narrative, deck, demo script, objection sheet, ROI/value calculator | Kazanjy ch. 2–3 [S10]; Cranney: value framework "strategy → initiatives → capabilities → features" [S3] |
| 3 | **Lead list from ICP** | `pipeline/leads.csv` (company, contact, role, source, ICP-fit score, trigger evidence) | Kolysh: warm network first, "Prospecting tools only start to matter once you have 10 to 20 quality customers" [S7]; Koomen: Builtwith / LinkedIn Sales Navigator [S9] |
| 4 | **Outreach** — warm intros → manual unscalable → sequenced cold | `pipeline/outreach.csv` (per send: template id, sent, replied, positive, meeting booked/held) | Kolysh customers 1–3 warm, 4–10 manual, 10–50 tooling [S7]; Graham "You have to go out and get them" [S6]; Gong email stats [S15] |
| 5 | **Discovery + qualification call** | discovery notes with MEDDPICC/SPIN fields filled; disqualify decision recorded | Koomen's six questions [S9]; Gong 11–14 questions, 3–4 problems [S16]; MEDDICC [S18] |
| 6 | **Pilot / proof** (paid, time-boxed, success metric fixed *before* start) | pilot charter: metric, duration, price, review meeting date | Blomfield: unpaid 3–6-month design partnerships are where "90% of founders get stuck"; paid pilot "$10,000 or $20,000 charge on their corporate credit card"; schedule the post-pilot ROI review before the pilot starts [S8] |
| 7 | **Proposal / SOW + pricing presentation** | proposal with tiered options, ROI scenarios, scope, acceptance criteria, payment terms, validity date | Cranney: tiered options, conservative vs aggressive ROI [S3]; Koomen "Pick a number, ideally one that makes you a little uncomfortable" [S9] |
| 8 | **Paper process** — security, privacy, legal redlines, procurement | redline log; only "company-ending" clauses (unlimited liability, IP transfer) are fought [S8]; PhilGEPS/bid documents for government (§4) | Blomfield [S8]; Koomen: expect security reviews, keep legal docs simple (Common Paper templates) [S9] |
| 9 | **Close + contract** (recurring with opt-out beats one-off pilot) | signed contract; PO number; invoice; payment-terms field | Blomfield: "monthly or annually recurring contract with a 30 or 60-day money back guarantee" [S8] |
| 10 | **Implementation / onboarding as an internal project** | onboarding plan, shared roadmap, time-to-first-value measured | Koomen: "The single biggest mistake that founders make is thinking that implementation is the customer's job" [S9]; Blomfield: $4M signed, <$2M implemented for lack of customer success [S8] |
| 11 | **References / case studies** | reference list with consent; 1-page case study per segment | Kolysh: automation becomes viable "once you've refined messaging and have case studies" [S7] |
| 12 | **Pipeline review + forecast** (weekly) | pipeline ledger snapshot; coverage ratio; forecast by category; loss-reason tally | Clari [S17]; HubSpot [S20]; Salesforce Ben [S25] |
| 13 | **Scale decision** — only after repeatability | rep-hiring gate: evidence the sales process is learned (win rate, cycle, yield) before adding headcount | Leslie & Holloway: three phases — "initiation, transition, and execution. Each phase requires a different size—and kind—of sales force" [S4] |
| 14 | **Channel / partner program** (later) | partner agreement, margin schedule, enablement kit | BVP: prerequisites are product-market fit, ICP, proven sales strategy; programs "should be driven by a genuine and organic need" [S27] |

---

## 2. Frameworks & methods

| Framework | Originator | What it produces | When to use | Known critiques |
|-----------|-----------|------------------|-------------|-----------------|
| **CAC-by-sales-complexity / LTV:CAC** | David Skok, Matrix (forentrepreneurs) [S1] | CAC per model: touchless ~$100 example; light-touch inside sales "$400 to $5,000 per customer"; field sales up to "$100,000" per customer (10 deals/rep/yr); rules "LTV should be about 3 x CAC", "recover your CAC in < 12 months" | Choosing/validating a motion against ACV | Illustrative numbers, not survey data; SaaS-centric |
| **Customer "animals" ACV ladder** | Christoph Janz (2014) [S26] | $100/yr mice (virality/paid), $1k rabbits (inbound, no-touch), $10k deer (inside sales: "$10k per year usually isn't enough to make traditional enterprise field sales work"), $100k elephants (enterprise field sales) | First-pass motion choice from target ACV | Order-of-magnitude heuristic; ignores services-heavy/hardware models |
| **Growth+Sales layering** | Lauten & Casado, a16z (2020) [S2] | Rule: start bottom-up, add top-down sales only when "users ask: 'How can I get this in the hands of my entire department?'"; "If you layer on sales too early… the organic motion never matures" | Software with end-user adoption | Only applies where a self-serve wedge exists |
| **Sales Learning Curve** | Leslie & Holloway, HBR Jul–Aug 2006 [S4] | Three phases (initiation, transition, execution); "hiring a full sales force too early just causes the firm to burn through cash"; sales yield rises as the org learns | Rep-hiring gate; pace of scaling | Numeric thresholds are behind the paywall — UNVERIFIED here |
| **Field-sales bootcamp** | Mark Cranney, a16z (2017) [S3] | Three buyer questions (why do anything different / why us / why now); champion vs coach vs supporter; "If I'm getting an RFI or an RFP and I haven't influenced it, I've probably wasted my time"; "process trumps heroics" | Enterprise/government complex sales | No numbers; assumes funded field team |
| **Do Things That Don't Scale** | Paul Graham (2013) [S6] | Manual recruitment of first users ("Collison installation"); weekly growth as the metric (100 users at 10%/week → 14,000 in a year) | Customers 1–10 | Consumer/PLG examples; B2B extrapolation is the founder's |
| **First 10 customers playbook** | Max Kolysh, YC [S7] | 1–3 from personal network, 4–10 manual/in-person/community, 10–50 tooling; emails "under 75 words", follow up "three or four times over a couple weeks"; micro-events of 6–10 people | Pre-PMF B2B | Anecdotal conversion figures |
| **Founder sales playbook** | Tom Blomfield, YC [S8] | Ladder: design partnership → free pilot → paid pilot → recurring contract with 30/60-day money-back; champion "like a co-founder"; willingness-to-pay question early; urgency via capacity scarcity; "Don't leave a meeting without the next touch point set up" | First paid contracts | — |
| **Enterprise sales for founders** | Pete Koomen, YC (W24) [S9] | Six steps; six discovery questions; price experiment ("$10,000/month… negotiated to $2,000 and purchased anyway"); implementation is the vendor's job | Enterprise deals | — |
| **Founding Sales** | Pete Kazanjy (2020) [S10] | 13 chapters: mindset, narrative, materials, prospecting, outreach, inbound, pitching, closing/pipeline, success, then management/hiring; founder-led "from 0 to ~30 customers" | End-to-end founder-led B2B | — |
| **SPIN Selling** | Neil Rackham, Huthwaite (1988; "30 researchers who studied 35,000 sales calls in over 20 countries" over 12 years) [S22][S23] | Situation → Problem → Implication → Need-payoff questioning | Discovery in larger sales | Vendor-owned training; 1980s dataset |
| **Sandler Selling System** | David Sandler [S21] | 7 steps: bonding & rapport, up-front contract, pain, budget, decision, fulfillment, post-sell | Low-pressure consultative discovery + qualification | Proprietary; no public effectiveness data |
| **Challenger / Insight selling** | Adamson, Dixon, Toman, HBR 2012 (CEB studies: >6,000 reps at 83 companies; ~600 companies; >700 stakeholders) [S24] | Customers complete "nearly 60% of a typical purchasing decision" before talking to a supplier; target "Mobilizers" (Go-Getters, Teachers, Skeptics) not "Talkers" (Guides, Friends, Climbers) or Blockers; Challengers = "nearly 40% of the high performers… 54% in complex, insight-driven environments"; opportunity scorecard (0–10 don't pursue, 10–20 limited, 20+ full) | Complex/commoditising markets | Works best with a teachable insight; needs org support |
| **BANT** | attributed to IBM (HubSpot does not name the originator) [S19] | Budget, Authority, Need, Timeline | Fast triage | Authority "could be more than one person"; strict timeline "might tell reps to cycle a lead who won't be ready to buy until next year" [S19] |
| **CHAMP** | not attributed in fetched source [S19] | Challenges, Authority, Money, Prioritization — "prioritizes Challenges over Authority" | Early-stage inbound | — |
| **MEDDIC → MEDDPICC** | Dick Dunkel at PTC, 1996, with Jack Napoli under John McMahon [S18] | Metrics, Economic buyer, Decision criteria, Decision process, (Paper process), Identify pain, Champion, (Competition) | Deals with ≥ several stakeholders; the natural stage-exit checklist | Heavy for small deals; needs discipline |
| **Pipeline coverage** | practitioner standard; Clari write-up [S17] | Coverage = qualified pipeline ÷ target; required coverage = 1 ÷ win rate (33% → 3×, 25% → 4×, 20% → 5×, 50% → 2×; enterprise 15–25% → 4–7×) | Weekly pipeline gate | The blanket 3× rule is wrong unless win rate ≈ 33% |
| **Forecast categories** | Salesforce defaults [S25] | Pipeline, Best Case, (Most Likely), Commit, Closed, Omitted; one category per opportunity, mapped from stage | Weekly forecast | "How each forecast category is defined can be different based on your business process" — must be defined per org |
| **Channel partner economics** | BVP Atlas [S27] | VAR "20-30% margin"; resellers "5-10%"; referral = one-time commission; budget "10-20% of the purchase price towards services and implementation" | After PMF/ICP/proven sales | Premature channel = "driven by revenue targets alone" |

---

## 3. Numbers annex

| Metric | Benchmark / threshold | Context (motion / ACV / geo) | Source URL | Grade | Retrieved |
|--------|-----------------------|------------------------------|------------|-------|-----------|
| CAC, touchless/freemium | ~$100 lead-gen cost per customer (worked example) | SaaS, self-serve | https://www.forentrepreneurs.com/startup-killer/ | P1 | 2026-09-02 |
| CAC, inside sales | "$400 to $5,000 per customer acquired" | SaaS, light-touch inside sales | same | P1 | 2026-09-02 |
| CAC, field sales | up to "$100,000" per customer (10 deals/rep/yr) | Enterprise field sales | same | P1 | 2026-09-02 |
| LTV:CAC | "LTV should be about 3 x CAC" | Recurring-revenue models | same | P1 | 2026-09-02 |
| CAC payback | "< 12 months" | SaaS | same | P1 | 2026-09-02 |
| ACV → motion | $1k inbound/no-touch; $10k inside sales; $100k field sales; 1,000 × $100k or 10,000 × $10k = $100M | SaaS, global | https://christophjanz.blogspot.com/2014/10/five-ways-to-build-100-million-business.html | P2 | 2026-09-02 |
| Founder-led span | "from 0 to ~30 customers" before hiring sales | B2B direct | https://www.foundingsales.com/ | P1 | 2026-09-02 |
| Cold email → meeting | "344 cold emails to land one meeting" (≈0.29%); 28M+ emails | Outbound, all segments | https://www.gong.io/blog/does-cold-email-even-work-any-more-heres-what-the-data-says | P2 | 2026-09-02 |
| Top-rep multiples | top 10% book 8.1× more meetings; top 25% 4.3×; top reps 4.2× reply rate | Outbound | same | P2 | 2026-09-02 |
| Pitching penalty | pitching in a cold email cuts reply rate "by as much as 57%" | Outbound | same | P2 | 2026-09-02 |
| Email length | best replies at 3–4 sentences; "100 words or fewer" | Outbound | same | P2 | 2026-09-02 |
| Founder email length | "Keep it under 75 words"; follow up "three or four times over a couple weeks" | Founder-led | https://www.ycombinator.com/library/SF-how-to-get-your-first-10-customers | P1 | 2026-09-02 |
| Warm outreach anecdotes | ~50% LinkedIn connection acceptance, 20% → calls; 30% acceptance for paid ($100–200/h) feedback sessions | Founder-led, single-founder examples | same | P1 (anecdotal) | 2026-09-02 |
| Cold email reply rate | "1% to 5%" typical; "12%" for effective sequences | Outbound (GMass, Outreach via secondary) | https://www.gradient.works/blog/benchmarks-for-metrics-that-matter-to-sales-development | P2 | 2026-09-02 |
| Connect rate / cadence | "4.4 connects per 100 touches"; average cadence "10.6 attempts" (Bridge Group via secondary) | SDR outbound | same | P2 | 2026-09-02 |
| SDR-sourced conversion | 58% of SDR-qualified leads → opportunities; 22% of SDR-sourced opps → closed-won (TOPO via secondary) | SDR outbound | same | P2 | 2026-09-02 |
| SDR activity | 112 activities/day (44 phone, 41 email, 19 LinkedIn, 8 other); 4.1 quality conversations/day | 351 B2B companies, 2024–25 | https://www.bridgegroupinc.com/research/2025-sdr-models-metrics-report-the-bridge-group | P1 | 2026-09-02 |
| SDR quota & attainment | monthly quota 10 (global median, stage 0), "down 40% since 2018"; 60% at quota ("lowest reported in study history") | same | same | P1 | 2026-09-02 |
| SDR economics | $3.78M pipeline/SDR/yr; ramp 3.0 months; 1 SDR : 2.4 AEs; tenure 1.9 yrs; attrition 40%; OTE $80K ($55K/$25K) | same | same | P1 | 2026-09-02 |
| Discovery call | "11-14 targeted questions"; talk:listen 46:54; "3 to 4 customer problems"; 519,291 conversations | B2B discovery | https://www.gong.io/blog/discovery-call/ | P2 | 2026-09-02 |
| B2B win rate | 19–21% (2025) vs 29% (2024); top performers 30%+ (Ebsta × Pavilion via secondary) | B2B, 655,000 opps / $48B sample | https://www.gradient.works/blog/2025-b2b-sales-performance-benchmarks ; sample size at https://benchmarks.ebsta.com/2025-gtm-benchmarks | P2 / P1 | 2026-09-02 |
| Win-rate drivers | delayed deals −113%; early decision-maker involvement +55%; multi-threading +130% on deals >$50K | same | same | P2 | 2026-09-02 |
| Quota attainment (AE) | "76% of sellers missed quota in H1 2025"; 28% met quota in 2023 | B2B | same | P2 | 2026-09-02 |
| Sales cycle | 6.5 months avg (vs 4.9 in 2019); <$25K ACV ≈ 90 days; >$100K "6–9+ months" (Norwest 2024 via secondary); SMB 14–30d, mid-market 30–90d, enterprise 90–180+d | B2B SaaS | same | P2 | 2026-09-02 |
| Buying committee | 6.8 stakeholders avg (Gartner via secondary) | B2B | same | P2 | 2026-09-02 |
| Pre-supplier buying progress | "nearly 60% of a typical purchasing decision" done before supplier contact (CEB, >1,400 customers) | B2B complex | https://hbr.org/2012/07/the-end-of-solution-sales (text via PDF mirror) | P1 | 2026-09-02 |
| Funnel stage rates | lead→MQL 41%, MQL→SQL 39%, SQL→opp 42%, opp→close 39% ($10–100M ARR SaaS); enterprise 34/40/36/31 | B2B SaaS, agency dataset | https://www.poweredbysearch.com/learn/b2b-saas-funnel-conversion-benchmarks/ | P3 | 2026-09-02 |
| MQL→SQL | "about 16%" across industries | B2B | https://blog.hubspot.com/sales/sales-pipeline | P2 | 2026-09-02 |
| Stage probabilities | lead 10%, nurture 20%, MQL 30%, sales-accepted 40%, SQL 50–75%, closed 100% | Generic template | same | P2 | 2026-09-02 |
| Stale-deal threshold | flag deals with no touch for "14–21 days"; "if there's no dated next step, we downgrade it" | Pipeline hygiene | same | P2 | 2026-09-02 |
| Pipeline coverage | required = 1 ÷ win rate: 33%→3×, 25%→4×, 20%→5×, 50%→2×; enterprise 4–7× | All | https://www.clari.com/blog/pipeline-coverage-best-practices/ | P2 | 2026-09-02 |
| Sales velocity | "close new ARR every week"; mature: a recurring contract "every week or two" | Founder-led SaaS | https://www.ycombinator.com/library/Mo-the-sales-playbook-for-founders | P1 | 2026-09-02 |
| Paid pilot size | "$10,000 or $20,000 charge on their corporate credit card" to bypass approvals | Enterprise pilots | same | P1 | 2026-09-02 |
| Channel margins | VAR 20–30%; reseller 5–10%; implementation budget 10–20% of price | SaaS channel | https://www.bvp.com/atlas/the-gtm-guide-to-building-saas-channel-partnerships | P2 | 2026-09-02 |
| PH agent commission | "Standard agent commissions range from 5 to 10 percent but vary by industry" | Philippines | https://www.trade.gov/country-commercial-guides/philippines-distribution-and-sales-channels | P1 | 2026-09-02 |
| PH retail markup / VAT | retail markups avg 30% of invoice (7–10% regulated goods to 30% luxury); VAT 12% | Philippines | https://www.trade.gov/country-commercial-guides/philippines-selling-factors-and-techniques | P1 | 2026-09-02 |
| PH credit terms | L/C "typically 30 or 60 days"; D/A "30 to 60 days"; open account "30 days to 180 days"; collections "30 to 120 days", agency fee "20 percent to 40 percent of the recovered amount" | Philippines import trade | https://www.trade.gov/country-commercial-guides/philippines-trade-financing | P1 | 2026-09-02 |
| PH gov award clock | bid opening → award "shall not exceed sixty (60) calendar days" | RA 12009 §67; IRR 67.1 | https://lawphil.net/statutes/repacts/ra2024/ra_12009_2024.html ; https://www.gppb.gov.ph/wp-content/uploads/2025/02/IRR-of-RA-No.-12009.pdf | P1 | 2026-09-02 |
| PH gov small-value threshold | SVP ≤ ₱2,000,000 (≥3 quotations requested, 1 sufficient); Direct Acquisition ≤ ₱200,000; RFQ posted 3 days on PhilGEPS except ABC ≤ ₱200,000 | RA 12009 §32, §34; IRR 34.1, 34.x | same | P1 | 2026-09-02 |
| PH gov price weight (MEARB) | price "minimum weight of fifteen percent (15%) up to a maximum of forty percent (40%)" | RA 12009 §61 | lawphil | P1 | 2026-09-02 |
| PH gov bid security | cash/cashier's check 2% of ABC; surety bond 5% (table partly garbled in extraction — bank-guarantee row not legible) | IRR 56.2 | IRR PDF | P1 | 2026-09-02 |
| PH gov performance security | cash 5% of contract (goods/consulting), 10% (infrastructure); bank guarantee/LC or surety 30% | IRR 68 table | IRR PDF | P1 | 2026-09-02 |
| PH gov liquidated damages | 1/10 of 1% of undelivered portion per day of delay; at 10% of contract price the PE may rescind | IRR 71.1.4 | IRR PDF | P1 | 2026-09-02 |
| PH gov advance payment | goods: ≤15% against irrevocable LC/bank guarantee, "paid within sixty (60) calendar days from the signing of the contract"; 50% for hotel/venue/lease services; infrastructure ≤15% | IRR 71.1.5, 71.2.5 | IRR PDF | P1 | 2026-09-02 |
| PH gov retention (infra) | 10% of each progress payment until 50% complete; released on final acceptance | IRR 71.2.8 | IRR PDF | P1 | 2026-09-02 |
| PH gov warranty (goods) | 3 months (expendable) / 1 year (non-expendable) after acceptance; warranty security 1–5% (default 1%) | IRR 90.1 | IRR PDF | P1 | 2026-09-02 |
| PH gov payment-delay signal | consultants may terminate if progress-billing payment is delayed "beyond sixty (60) calendar days" after certified claim | IRR 71.x (consulting) | IRR PDF | P1 | 2026-09-02 |
| PhilGEPS Platinum | certificate valid 1 year; PS-DBM issues it "within seven (7) calendar days" of complete application; fee ₱5,000/yr (fee from third-party guide — official help page omits amount) | Philippines | IRR 20; https://notices.philgeps.gov.ph/help1_5.html ; https://www.firstcircle.ph/blog/philgeps-membership-how-to-register | P1 / P3 | 2026-09-02 |
| PH gov service clock | simple 3 / complex 7 / highly technical 20 working days; "deemed approved" if missed | RA 11032 §9–10 | https://lawphil.net/statutes/repacts/ra2018/ra_11032_2018.html | P1 | 2026-09-02 |
| PH private-sector payment terms | Net 30 / 2/10 net 30 / COD / advance listed; no survey data | Philippines | https://shoppable.ph/payment-terms-philippines-guide/ | P3 | 2026-09-02 |
| PH B2B DSO / % overdue | UNVERIFIED — Atradius 2025 Asia barometer excludes the Philippines; no PH survey fetched | — | — | — | 2026-09-02 |
| PH withholding on supplier payments (BIR 2307) | UNVERIFIED — BIR/PwC pages fetched did not show domestic creditable-withholding rates | — | — | — | 2026-09-02 |

---

## 4. Philippine specifics

**Buying norms (verified).** The US Commercial Service guide states: "Strong relationships of mutual trust with Philippine clients are the key to clinching a sale"; an aggressive approach is discouraged; suppliers are "encouraged to visit the Philippines on a regular basis"; local representatives "make regular sales calls to customers"; "English is the main language used for trade and sales correspondence"; quote in USD "but a Philippine peso equivalent should also be noted" [S40]. The 2026 edition adds that "Philippine partners expect strong after-sales service and support… during and after the warranty period" and that it is a "brand-conscious market" [S37]. Agents/distributors "are commonly used… and are essential for most U.S. companies"; two importer types: stocking distributors (contractually hold inventory) and indenters (broker on commission); "Standard agent commissions range from 5 to 10 percent"; Metro Manila (17 cities) hosts most national importers/distributors, with regional hubs Pampanga, Baguio, Cebu, Iloilo, Davao, Batangas [S38][S41]. Contracts with government need "patience and diligence" [S41]. A P3 local guide calls the environment "highly relationship-driven" where "informal terms are common but risky" [S45].

**Government procurement (verified, primary).**
- RA 12009 (New Government Procurement Act) signed 20 Jul 2024 [S29][S36]; "took effect on 13 August 2024" [S33]; IRR approved 4 Feb 2025, published 10 Feb 2025 [S35][S33]; standard forms approved by GPPB Resolution 03-2025 on 14 May 2025 [S33]; PEs get "a three (3)-year transitory period from the approval of the standard forms" to comply (IRR 113.3) [S32]; RA 9184 and CA 138 "are hereby repealed" (IRR 115) [S32]. Net: through ~May 2028 a supplier may meet either RA 9184-style or RA 12009-style processes depending on the procuring entity.
- Modalities (RA 12009 §26; IRR Rule IV): competitive bidding, limited source bidding, competitive dialogue, unsolicited offer with bid matching, direct contracting, direct acquisition (≤ ₱200k), repeat order (≤25% of quantity), small value procurement (≤ ₱2M), negotiated procurement, direct sales (§36: a PE buys directly from a supplier that "has satisfactorily delivered Non-CSE to another government agency under a completed contract" — a reference customer becomes a procurement channel), and direct procurement for science, technology and innovation (§37: PEs may buy R&D goods "from a qualified startup business"; note "the intellectual property rights… shall belong to the Procuring Entity" unless agreed otherwise) [S31][S32].
- Award of contract: lowest calculated responsive bid **or** most economically advantageous responsive bid (MEARB), the latter weighting price 15–40% alongside quality, design, after-sales service, sustainability (§49, §61) [S31]. Trade.gov summary: award timeline "reduced from 90 to 60 days" and "Lowest bid no longer automatically wins" [S36].
- Inclusion: PEs must encourage "microenterprises, social enterprises, and startups" including "Reserving a percentage of procurement opportunities for inclusive suppliers" (IRR 75); a GPPB registry of sectors includes "Startups, spin-offs, and other forms of entity involved in science, technology, and innovation activities as certified by the DTI, DICT, NIC or… DOST" (IRR 76.1(f)); those sectors may post a Performance Securing Declaration instead of a performance security, with blacklisting of 1 year (first offense) / 2 years on breach (IRR 68.2–68.3) [S32].
- Eligibility: a "valid and updated PhilGEPS Certificate of Registration (Platinum Membership)" is required (RA 12009 §52; IRR 52.1) [S31][S32]. Platinum documents: DTI/SEC/CDA registration, valid mayor's permit, BIR-stamped audited financial statements, notarized PhilGEPS sworn statement, tax clearance (EO 398), PCAB license for contractors [S42]; corporations must add a SEC-received GIS with beneficial-ownership data from 15 Jul 2025 [S43]. Red membership is free/no expiry; Platinum lasts one year and downgrades to Red if not renewed [S42].
- Securities & penalties: bid security 2% (cash) / 5% (surety) of ABC or a Bid Securing Declaration; performance security 5% (goods/consulting) or 10% (infra) in cash, 30% via bank guarantee/LC/surety; liquidated damages 0.1%/day of the undelivered portion, rescission possible at 10%; warranty 3 months/1 year with 1–5% warranty security [S32].
- Money-in timing: no statutory "pay within N days" for goods was found in the RA 12009 text or IRR (grep of the full IRR). What is verifiable: advance payment up to 15% against a bank guarantee within 60 days of signing; consultants may terminate when payment lags 60 days past a certified claim [S32]. Typical actual government payment lag and COA post-audit behaviour: UNVERIFIED — treat as practitioner consensus (plan cash for 60–90+ days after acceptance).
- Government service clock (permits, registrations): 3/7/20 working days with deemed-approval (RA 11032 §9–10) [S46].

**Private-sector payment terms.** Verified only for trade-finance instruments: L/C 30/60 days; D/A 30–60 days; open account 30–180 days; collection agencies 30–120 days at 20–40% fee [S39]. Local net-30 / 2/10-net-30 / COD are listed by a P3 guide with no survey data [S45]. Post-dated checks as settlement instrument, corporate 30/60/90-day norms, and BIR creditable withholding (Form 2307) on supplier invoices are UNVERIFIED in this brief (BIR and PwC pages fetched did not expose the domestic rates); the harness should carry them as a `payment_terms_days` and `withholding_pct` field to be filled from the signed contract, not from a benchmark.

---

## 5. Mechanical gate candidates

**Pipeline ledger (`pipeline/deals.csv`) — one row per opportunity.** Columns: `deal_id`, `account`, `segment` (ICP tag), `source_channel`, `stage`, `stage_entered_at`, `days_in_stage`, `amount_acv`, `amount_tcv`, `currency`, `forecast_category` (pipeline/best_case/commit/closed/omitted), `probability`, `owner`, `next_action`, `next_action_date`, `last_activity_at`, `expected_close_date`, `close_date_slips` (count), `champion_named` (y/n), `economic_buyer_named` (y/n), `metrics_agreed` (y/n), `decision_criteria_doc` (path), `decision_process_doc` (path), `paper_process_started` (y/n), `pain_statement`, `competition`, `pilot_metric`, `pilot_end_date`, `proposal_path`, `payment_terms_days`, `withholding_pct`, `po_number`, `contract_signed_at`, `invoice_date`, `paid_date`, `outcome` (won/lost/open), `loss_reason` (enum: timing, need, budget, authority, feature, price, competition, no_decision, other), `loss_note`. Fields mirror MEDDPICC [S18], HubSpot exit-criteria guidance [S20], and the InsightSquared loss-reason chart categories [S5].

**Outreach ledger (`pipeline/outreach.csv`).** `send_id`, `sequence_id`, `template_id`, `word_count`, `contact_id`, `channel`, `sent_at`, `delivered`, `replied`, `reply_sentiment` (+/−), `meeting_booked`, `meeting_held`, `opp_created`, `human_approved_by`, `human_approved_at`.

**Checks a script can run (each is a threshold read from the ledgers).**
1. *ICP lock*: every deal has a `segment` tag that exists in `gtm/hypothesis.md`; ≥ 80% of open pipeline in the primary segment (else the motion is unfocused — practitioner consensus).
2. *Motion–ACV consistency*: median `amount_acv` of won deals vs declared motion; flag if field-sales motion with ACV < $10k-equivalent or self-serve with ACV > $100k (bands per Janz [S26], CAC ranges per Skok [S1]).
3. *Stage exit criteria*: no deal enters `proposal` without `economic_buyer_named=y`, `metrics_agreed=y`, `decision_process_doc` present; no deal enters `commit` without `paper_process_started=y` (HubSpot: exit criteria "such as 'discovery completed with decision maker,' not 'feels warm'" [S20]).
4. *Next-step rule*: any open deal with empty `next_action_date` or `next_action_date < today` is auto-downgraded one forecast category and listed ("if there's no dated next step, we downgrade it" [S20]).
5. *Staleness*: `today − last_activity_at > 21 days` → flag; > 45 days → move to nurture/lost with `loss_reason=no_decision` (14–21-day threshold [S20]).
6. *Slip counter*: `close_date_slips ≥ 2` → exclude from commit (delayed deals cut win rate −113% [S13]).
7. *Coverage gate*: `open_qualified_pipeline / target ≥ 1 / trailing_win_rate × 1.2`; until ≥ 20 closed outcomes exist, use 5× (20% B2B baseline [S13][S17]).
8. *Win-rate sanity*: trailing win rate on ≥ 20 decided deals reported against the 19–21% B2B baseline; < 10% triggers a qualification review, not more outbound [S13].
9. *Cycle-time budget*: `days_in_pipeline` p50 vs band (≤ 90 days for < $25k ACV; 180–270+ for > $100k [S13]); deals over 2× band are flagged for disqualification review.
10. *Outbound quality floor*: after ≥ 200 sends of a template, positive-reply rate < 1% or meetings/100 emails < 0.3 (Gong: 344 emails/meeting [S15]) → template locked for rewrite; ≥ 3–5% reply is "working" [S12].
11. *Email lint*: `word_count ≤ 100` (Gong) and ≤ 75 for founder emails (YC); pitch/buzzword list hits → warn (pitching −57% [S15][S7]).
12. *Follow-up cadence*: 3–4 touches over ~2 weeks per contact before marking `no_response` [S7]; cadence ≤ 10–11 attempts (Bridge Group avg 10.6 [S12]).
13. *Discovery-note lint*: ≥ 3 problems captured, ≥ 8 questions logged, pain/impact/quantification fields non-empty (Gong 11–14 questions, 3–4 problems [S16]; Koomen's six questions [S9]).
14. *Pilot charter lint*: `pilot_metric`, `pilot_end_date` (≤ 8 weeks), `price > 0`, review meeting date set before start (Blomfield [S8]). Unpaid pilots > 60 days → red.
15. *Proposal/SOW lint*: sections present — scope, deliverables, acceptance criteria, timeline, price with ≥ 2 tiers, assumptions/exclusions, payment terms (days, milestones, currency), validity date, warranty/support, IP ownership, liability cap, signature block (structure per Cranney tiered options [S3]; clause list is practitioner consensus).
16. *Contract-clause tripwires*: unlimited liability, IP assignment, exclusivity, auto-renew without opt-out → block for human review ("company-ending" clauses [S8]).
17. *Cash-in check*: `paid_date − invoice_date` tracked; alert at `payment_terms_days + 15`; government deals default expectation 60–90 days (advance-payment 60-day clause is the only statutory anchor [S32]; the rest UNVERIFIED).
18. *Government bid pack lint*: PhilGEPS Platinum valid (`expires_at > bid_date`), GIS-with-beneficial-ownership on file for corporations, bid security amount = 2%/5% of ABC or Bid Securing Declaration, performance security = 5% (goods) computed, liquidated-damage exposure = 0.1% × contract/day computed, modality vs ABC consistent (≤ ₱200k direct acquisition; ≤ ₱2M SVP; else bidding), warranty security 1–5% budgeted [S31][S32][S42][S43].
19. *Reference/case-study gate*: before enabling any sequenced outbound, ≥ 1 case study per target segment on file [S7].
20. *Scale gate*: hire the first non-founder seller only when ≥ 10 paid customers, trailing win rate and cycle within band for two consecutive quarters, and a written playbook exists (Kazanjy 0–30 [S10]; Leslie & Holloway phases [S4]).

**Cannot be mechanized (human sign-off, logged with `human_approved_by`).** Sending any email/message/LinkedIn note; placing or joining calls; quoting a price or discount; committing to a pilot; submitting a bid or proposal; signing NDAs/contracts/POs; posting a bid/performance security; registering/renewing PhilGEPS; issuing invoices; agreeing payment terms; appointing agents/distributors; spending on ads/events. The harness drafts, lints, and gates; a human sends, spends, signs, files.

---

## 6. Early irreversibles

1. **Segment/ICP choice.** The organization learns to sell to one buyer; switching resets the sales learning curve (three phases, each needing "a different size—and kind—of sales force") [S4]. Kolysh: buyer channel habits differ by persona (a sales leader "lives on LinkedIn", a truck dispatcher "may rarely check email") [S7].
2. **Sales motion and first sales hires.** Hiring reps before the process is learned "causes the firm to burn through cash" [S4]; layering top-down sales too early means "the organic motion never matures" [S2]. Reversal cost: severance, ramp (3.0 months per SDR [S11]), lost quarters.
3. **Price anchor and discount precedent.** First quotes set the reference (Koomen's $10k→$2k anecdote [S9]); money-back/opt-out structure vs one-off pilots determines whether revenue recurs [S8].
4. **Pilot/design-partnership scope.** Unpaid 3–6-month partnerships are where "90% of founders get stuck" [S8]; the pilot metric agreed up front is what the customer will judge you on.
5. **Contract clauses.** Unlimited liability, IP transfer/exclusivity are "company-ending" [S8]; under RA 12009 §37 STI direct procurement, IP in commissioned goods belongs to the procuring entity unless otherwise agreed [S32].
6. **Government track commitments.** Bid Securing/Performance Securing Declarations carry 1–2-year blacklisting on breach; liquidated damages accrue at 0.1%/day and rescission at 10% [S32]. A single failed government delivery locks out all PEs.
7. **Channel/agent appointments.** Distributors are "essential" in the Philippines [S41], margins are structural (VAR 20–30%, reseller 5–10% [S27]; agent 5–10% [S38]), and BVP warns programs must be "driven by a genuine and organic need" [S27]; exclusivity clauses are especially hard to unwind (practitioner consensus).
8. **Reference customers.** The first references define the segment story; RA 12009 §36 Direct Sales makes a completed government contract a reusable channel [S32] — choose the first public-sector customer deliberately.
9. **Payment terms precedent.** Open-account terms of 30–180 days [S39] once granted are hard to shorten (practitioner consensus).

---

## 7. Failure modes / anti-patterns to guard against

| Anti-pattern | Guard (gate #) | Source |
|--------------|----------------|--------|
| Scaling the sales force before the sales process is learned | #20 scale gate | Leslie & Holloway [S4] |
| Adding top-down sales before pull exists | #2, #20 | a16z [S2] |
| Long, unpaid, ill-scoped design partnerships / pilots ("too long—maybe two or three months") | #14 pilot lint | Blomfield [S8] |
| "Talking to bad customers gives you the illusion that you're making progress" | #1 ICP lock, #13 discovery lint | Koomen [S9] |
| Treating implementation as the customer's job ($4M signed, <$2M live) | step 10 deliverable; onboarding plan required before `closed_won` | Koomen [S9]; Blomfield [S8] |
| Pitching in cold email (−57% replies), buzzwords, > 100 words | #11 email lint | Gong [S15] |
| Front-loading all discovery questions; no quantification | #13 | Gong [S16] |
| Courting "Talkers" (Guides, Friends, Climbers) instead of Mobilizers; senior Talker "more likely to head to the graveyard than to the income statement" | `champion_named` must be validated by an action (e.g., champion brings the economic buyer to a meeting) | HBR Challenger [S24] |
| Responding to RFPs you did not shape | bid/no-bid check requires prior contact logged | Cranney [S3] |
| Blanket 3× coverage when win rate ≠ 33% | #7 | Clari [S17] |
| Deals without a dated next step; stale deals inflating the forecast | #4, #5 | HubSpot [S20] |
| Letting deals slip repeatedly (−113% win rate) | #6 | Ebsta × Pavilion via [S13] |
| Strict BANT that cycles out next-year buyers / assumes one authority | multi-contact roles in ledger; timeline stored, not used to disqualify | HubSpot [S19] |
| Aggressive, transactional approach in the Philippines | in-person/relationship steps in step 4; no automation before 10 customers | export.gov [S40]; Kolysh [S7] |
| Bidding without PhilGEPS Platinum / wrong modality for the ABC / no security | #18 | RA 12009, IRR [S31][S32] |
| Ignoring collection cost and lag (30–120 days, 20–40% agency fee) | #17 cash-in check | trade.gov [S39] |
| Launching a channel program to hit a revenue target rather than from need | #20-style prerequisite check: PMF, ICP, proven direct sales | BVP [S27] |
| Vanity outbound volume with no reply-rate floor | #10 | Gong [S15]; Bridge Group [S11] |

---

## 8. Sources

1. [S1] David Skok, "Startup Killer: the Cost of Customer Acquisition" · https://www.forentrepreneurs.com/startup-killer/ · P1 essay · CAC by sales complexity, LTV ≈ 3× CAC, CAC payback < 12 months.
2. [S2] Peter Lauten & Martin Casado, "Growth+Sales: The New Era of Enterprise Go-to-Market" (a16z, 2020-07-29) · https://a16z.com/growthsales-the-new-era-of-enterprise-go-to-market/ · P1 · when to layer top-down sales.
3. [S3] Mark Cranney, "Go-to-Market Boot Camp for Startups: Field Sales" (a16z, 2017-01-03) · https://a16z.com/go-to-market-boot-camp-for-startups-field-sales/ · P1 · enterprise process, RFP shaping, tiered proposals.
4. [S4] Mark Leslie & Charles A. Holloway, "The Sales Learning Curve" (HBR Jul–Aug 2006) · https://hbr.org/2006/07/the-sales-learning-curve and abstract at https://store.hbr.org/product/sales-learning-curve/R0607J · P1 (abstract only; body paywalled) · three phases, hiring warning.
5. [S5] InsightSquared, "What CEOs Must Know About the Sales Learning Curve" (2014 whitepaper) · https://www.insightsquared.com/wp-content/uploads/downloads/2014/09/Sales_Learning_Curve_Whitepaper_v4.pdf · P2 · loss-reason categories, iterate-on-conversion method.
6. [S6] Paul Graham, "Do Things That Don't Scale" (July 2013) · https://www.paulgraham.com/ds.html · P1 · manual recruitment, weekly growth math.
7. [S7] Max Kolysh, "How to Get Your First 10 Customers" (YC Library) · https://www.ycombinator.com/library/SF-how-to-get-your-first-10-customers · P1 · 1–3/4–10/10–50 ladder, email length, cadence, micro-events.
8. [S8] Tom Blomfield, "The Sales Playbook for Founders" (YC Library) · https://www.ycombinator.com/library/Mo-the-sales-playbook-for-founders · P1 · pilots → recurring contracts, champion, negotiation, velocity.
9. [S9] Pete Koomen, "Enterprise Sales for Founders" (YC Library, W24) · https://www.ycombinator.com/library/LF-enterprise-sales-for-founders · P1 · six steps, discovery questions, pricing, implementation.
10. [S10] Pete Kazanjy, *Founding Sales* site · https://www.foundingsales.com/ · P1 · chapter sequence, 0–30 customers founder-led.
11. [S11] The Bridge Group, "2025 SDR Models & Metrics Report" (351 companies) · https://www.bridgegroupinc.com/research/2025-sdr-models-metrics-report-the-bridge-group (index at https://blog.bridgegroupinc.com/sales-development-metrics) · P1 · SDR activity, quota, ratios, ramp, OTE.
12. [S12] Gradient Works, "Benchmarks for metrics that matter to sales development" · https://www.gradient.works/blog/benchmarks-for-metrics-that-matter-to-sales-development · P2 · secondary compilation (Bridge Group, TOPO, GMass, Outreach).
13. [S13] Gradient Works, "2025 B2B sales performance benchmarks" · https://www.gradient.works/blog/2025-b2b-sales-performance-benchmarks · P2 · secondary summary of Ebsta × Pavilion 2025, Norwest 2024, Gartner.
14. [S14] Ebsta × Pavilion, "2025 GTM Benchmarks" landing page · https://benchmarks.ebsta.com/2025-gtm-benchmarks · P1 · sample size (655,000 opportunities, $48B) only; report body gated.
15. [S15] Gong, "Does cold email even work any more? Here's what the data says" (2025-07-24, 28M+ emails) · https://www.gong.io/blog/does-cold-email-even-work-any-more-heres-what-the-data-says · P2 · 344 emails/meeting, top-rep multiples, pitching penalty.
16. [S16] Gong, "Discovery call" data (519,291 conversations) · https://www.gong.io/blog/discovery-call/ · P2 · 11–14 questions, 46:54, 3–4 problems.
17. [S17] Clari, "Pipeline Coverage Ratio: What Your Number Actually Means" · https://www.clari.com/blog/pipeline-coverage-best-practices/ · P2 · coverage = 1/win rate.
18. [S18] MEDDICC, "Who Created MEDDIC?" · https://meddicc.com/resources/who-created-meddic · P2 · origin (PTC 1996, Dunkel/Napoli/McMahon), MEDDPICC letters.
19. [S19] HubSpot, "The Ultimate Guide to Sales Qualification" · https://blog.hubspot.com/sales/ultimate-guide-to-sales-qualification · P2 · BANT/CHAMP/MEDDIC/GPCTBA/ANUM/FAINT and critiques.
20. [S20] HubSpot, "Sales Pipeline" guide · https://blog.hubspot.com/sales/sales-pipeline · P2 · stages, probabilities, exit criteria, stale-deal rules, velocity formula.
21. [S21] Sandler, "Sandler Selling System" · https://www.sandler.com/sandler-selling-system/ · P1 (originator) · seven steps.
22. [S22] Wikipedia, "Neil Rackham" · https://en.wikipedia.org/wiki/Neil_Rackham · P3 · SPIN research basis (1988; 35,000 calls; 20 countries; 12 years).
23. [S23] Huthwaite International, "SPIN Selling" · https://www.huthwaiteinternational.com/spin-selling · P1 (originator) · 35,000+ calls claim.
24. [S24] Adamson, Dixon & Toman, "The End of Solution Sales" (HBR Jul–Aug 2012) · https://hbr.org/2012/07/the-end-of-solution-sales (full text read from mirror https://www.mitchellmackey.com.au/wp-content/uploads/2012/08/The-End-of-Solution-Sales-CEB-HBR-August-2012.pdf) · P1 · 60% pre-supplier progress, Mobilizers vs Talkers, scorecard, Challenger share.
25. [S25] Salesforce Ben, "Forecast Categories in Salesforce" · https://www.salesforceben.com/forecast-categories-in-salesforce-everything-you-need-to-know/ · P2 · category names and stage mapping.
26. [S26] Christoph Janz, "Five ways to build a $100 million business" (2014-10-05) · https://christophjanz.blogspot.com/2014/10/five-ways-to-build-100-million-business.html · P2 · ACV bands → motion.
27. [S27] Bessemer Venture Partners Atlas, "The GTM guide to building SaaS channel partnerships" · https://www.bvp.com/atlas/the-gtm-guide-to-building-saas-channel-partnerships · P2 · partner types, margins, prerequisites.
28. [S28] Powered by Search, "B2B Funnel Conversion Benchmarks (2026)" · https://www.poweredbysearch.com/learn/b2b-saas-funnel-conversion-benchmarks/ · P3 · stage conversion rates by segment/channel.
29. [S29] GPPB-TSO, "Know more about the New Government Procurement Act or RA 12009" · https://www.gppb.gov.ph/know-more-about-the-new-government-procurement-act-or-republic-act-no-12009/ · P1 · legislative timeline, signing date.
30. [S30] GPPB-TSO, NGPA resource index · https://www.gppb.gov.ph/new-government-procurement-act-republic-act-no-12009/ · P1 · links to law, IRR, PBDs, forms, primer.
31. [S31] Republic Act No. 12009 text (LawPhil) · https://lawphil.net/statutes/repacts/ra2024/ra_12009_2024.html · P1 · §26 modalities, §32/§34 thresholds, §49/§61 MEARB, §52 PhilGEPS, §56/§68 securities, §67 60-day award.
32. [S32] IRR of RA 12009 (GPPB PDF, text-extracted with pdftotext, 193 pp.) · https://www.gppb.gov.ph/wp-content/uploads/2025/02/IRR-of-RA-No.-12009.pdf · P1 · Rule IV modes, §20 PhilGEPS/e-marketplace, §34 SVP, §36 Direct Sales, §37 STI, §52 eligibility, §56 bid security, §68 performance security/PSD, §67 award clock, §71 contract implementation (LD, advance payment, retention), §75–76 inclusive procurement/startups, §90 warranty, §112–117 transitory/repeal/effectivity.
33. [S33] GPPB Resolution No. 03-2025 (14 May 2025), approving standard forms · https://www.gppb.gov.ph/wp-content/uploads/2025/07/GPPB-Resolution-No.-03-2025.pdf · P1 · NGPA effective 13 Aug 2024; IRR Res. 02-2025 dated 4 Feb 2025, published 10 Feb 2025; 3-year transitory period reckoned from standard-forms approval.
34. [S34] GPPB-TSO, "NGPA Primer" (July 2025) · https://www.gppb.gov.ph/wp-content/uploads/2025/07/NGPA-Primer.pdf · P1 · principles and new modalities list.
35. [S35] DBM, "IRR of New Gov't Procurement Act Now Published" · https://www.dbm.gov.ph/index.php/management-2/3212-irr-of-new-govt-procurement-act-now-published · P1 · IRR approved 4 Feb 2025, published 10 Feb 2025.
36. [S36] US ITA trade.gov, "Philippines Government Procurement Law" (2024-09-30) · https://www.trade.gov/market-intelligence/philippines-government-procurement-law · P1 · 90→60-day award, lowest bid no longer automatic, 3-year transition.
37. [S37] trade.gov CCG, "Philippines – Selling Factors and Techniques" (updated 2026-06-30) · https://www.trade.gov/country-commercial-guides/philippines-selling-factors-and-techniques · P1 · after-sales expectations, markups, VAT.
38. [S38] trade.gov CCG, "Philippines – Distribution and Sales Channels" · https://www.trade.gov/country-commercial-guides/philippines-distribution-and-sales-channels · P1 · distributors vs indenters, 5–10% commissions, Metro Manila.
39. [S39] trade.gov CCG, "Philippines – Trade Financing" (updated 2026-06-30) · https://www.trade.gov/country-commercial-guides/philippines-trade-financing · P1 · L/C, D/A, D/P, open-account day ranges, collection costs.
40. [S40] export.gov (legacy), "Philippines – Selling Factors and Techniques" (2019-07-18) · https://legacy.export.gov/article?id=Philippines-Selling-Factors-and-Techniques · P1 · relationship/trust norms, visits, language, quoting.
41. [S41] export.gov (legacy), "Philippines – Market Entry Strategy" (2019-07-18) · https://legacy.export.gov/article?id=Philippines-Market-Entry-Strategy · P1 · agents/distributors essential; local partner for government sales (pre-NGPA); patience.
42. [S42] PhilGEPS, "PhilGEPS 1.5 Help" · https://notices.philgeps.gov.ph/help1_5.html · P1 · Red vs Platinum, six Platinum documents.
43. [S43] PS-PhilGEPS ADV 2025-007 (30 Jun 2025) · https://ps-philgeps.gov.ph/home/index.php/about-ps/news/7646-adv-2025-007-submission-of-updated-eli%E2%80%A6 · P1 · GIS with beneficial ownership required from 15 Jul 2025.
44. [S44] First Circle, "PhilGEPS Membership: How to Register as an SME" (upd. 2024-07-12) · https://www.firstcircle.ph/blog/philgeps-membership-how-to-register · P3 · ₱5,000 annual Platinum fee, 2–3 day processing claim.
45. [S45] Shoppable Business, "Why Payment Terms Matter: A Strategic Guide for Philippine Businesses" · https://shoppable.ph/payment-terms-philippines-guide/ · P3 · local terms vocabulary, "relationship-driven"; no data.
46. [S46] Republic Act No. 11032 (Ease of Doing Business Act, 2018) text · https://lawphil.net/statutes/repacts/ra2018/ra_11032_2018.html · P1 · 3/7/20 working-day clocks, deemed approval.

Fetched but yielded nothing usable (not cited): YC library pages without the render proxy (title only); HBR paywalled bodies; Ebsta report body (gated); Atradius Asia 2025 (Philippines not covered); BIR and PwC withholding pages (domestic rates not exposed); GPPB NGPA microsite (parse error).
