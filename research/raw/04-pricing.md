# Pricing — research brief (2026-09-02)

Domain: pricing for a small Philippine engineering studio selling software, hardware and engineering services. All numbers below come from URLs fetched on 2026-09-02; anything not fetched is marked **UNVERIFIED**. Provenance: P1 = primary (law, regulator, framework author/firm, benchmark publisher); P2 = secondary (Big-4/law-firm summary, vendor citing a named primary, trade-press with named data); P3 = weak (vendor blog, Wikipedia, aggregator).

Scope note: HBR's Good-Better-Best (2018) and Marn & Rosiello (1992) are paywalled; only headers/abstracts were readable. OpenView's site now serves a corporate shell, so its usage-based-pricing figures are taken from Chargebee's citation (P2). PSA Occupational Wages Survey returned 403 and Michael Page's guide is gated, so Philippine rate ranges are thin (see §3, §4).

## 1. Standard process — ordered steps and the named deliverable of each

| # | Step | Deliverable | Anchor |
|---|------|-------------|--------|
| 1 | **Willingness-to-pay (WTP) conversations before building.** Take a wireframe/prototype to target customers and run the sales conversation you would run after launch; segment by *differences in WTP*, not demographics. | `wtp-interviews.csv` (customer, segment, acceptable / expensive / prohibitive price, feature reactions), n ≥ 10 per segment (harness default; no published minimum found) | Ramanujam (S-K) [S14][S15] |
| 2 | **Cost floor.** Fully loaded unit cost: labour at realistic utilisation, overhead, subcontractors, channel costs, plus the tax cash effects (percentage tax if non-VAT; CWT timing). | `cost-floor.csv` (offer, cost components, floor price, method, date) | ClickTime [S25], SPI [S23], BIR [S30][S31] |
| 3 | **Competitor price band.** Dated captures of ≥ 3 comparable offers (URL, screenshot/hash, price, metric, VAT treatment). | `competitor-band.csv` | Simon-Kucher definition of competitor-based pricing [S18] |
| 4 | **Quantitative price research** (only when a public/list price will be set for many buyers): Van Westendorp for the acceptable range, Gabor-Granger for the revenue-maximising point, CBC conjoint when features and price trade off. | `price-research.md` with n, method, PMC/OPP/IPP/PME or revenue curve | Sawtooth [S1][S2][S3][S4] |
| 5 | **Choose price metric & model** (per seat / usage / tiered / flat / hybrid; for services: T&M, fixed, milestone, retainer, value-based; for hardware: cost-plus to a target GM through the channel stack). | `price-model.md` (metric, why it tracks value, model pros/cons accepted) | Paddle [S21], OpenView via Chargebee [S22], Predictable Designs [S26] |
| 6 | **Structure the offer**: Good-Better-Best with fence attributes; anchors; decoys only where dominance is easy to see. | `price-book.csv` (tier, price, fences, anchor logic) | HBR/Mohammed [S11][S12], Huber et al. via [S28], Simon-Kucher [S17] |
| 7 | **Tax treatment per line**: VAT-registered vs non-VAT (≤ ₱3M), 8% option, zero-rating for foreign clients, CWT rate the client will withhold. | `price-book.csv` columns `vat_treatment`, `cwt_rate_expected`, `display` | NIRC via lawphil [S33][S35], BIR [S30][S31] |
| 8 | **Discount & increase policy**: authority levels, max discount, pocket-price tracking; annual price-increase playbook with a stated reason. | `discount-policy.md`, `price-change-log.csv` | Marn & Rosiello [S44], Simon-Kucher [S16][S17], Paddle [S21] |
| 9 | **Review cadence**: quarterly review of price vs. value; refresh competitor captures; re-run WTP on new segments. | ledger diff + gate report | Paddle [S21] |

## 2. Frameworks & methods

| Method | Originator | Produces | When to use | Known critiques |
|---|---|---|---|---|
| **Cost-plus** | traditional | cost + markup | Physical goods with predictable cost; as a *floor* only | Paddle: "less than ideal for anything but physical products" [S19]; Simon-Kucher: cost-plus firms "communicate and sell too heavily on price… leave substantial amounts of money on the table" [S17] |
| **Competitor-based** | traditional | price relative to rivals' structures | Start-up phase, commodity-like offers, as a band check | Paddle: "doesn't leave a lot of room for growth" [S19]; S-K: strategy should "primarily focus on your unique value and market position" [S18] |
| **Value-based** | Simon-Kucher (Hermann Simon); Paddle/ProfitWell for SaaS | price from customer-perceived monetary value | Differentiated offers; S-K's four steps: map key value drivers → calculate monetary benefits → adapt revenue models → train team to sell value, not price [S17] | Hard to quantify; needs interviews ("really dig deep and conduct extensive customer interviews") [S17] |
| **Monetizing Innovation** (price before product) | Ramanujam & Tacke, Simon-Kucher, 2016 | WTP-validated product + segments + bundle + model | Before building anything new | Firm's own research: "72 percent of new products introduced over the past five years have failed"; four failure types: feature shock, minivation, hidden gem, undead; nine rules incl. "Maintain pricing integrity by limiting discounting" [S14] |
| **Van Westendorp PSM** | Peter van Westendorp, 1970s | four curves; PMC (too-cheap × expensive), IPP (cheap × expensive), OPP (too-cheap × too-expensive), PME (cheap × too-expensive); acceptable range = PMC–PME [S4][S5] | Setting a *range* for a new list price when there is no reference price | Sawtooth: "lacks competitive context", line-crossing "doesn't follow from economic theory", stated not revealed preference, no purchase intent unless Newton-Miller-Smith extension (adds two 5-point purchase-likelihood questions) [S4][S5]. Sample size: no vendor primary states one [S4][S5][S8][S9]; CleverX (P3): 150–200 completes per segment floor, 200–300 preferred, "below 100 responses the intersection points… become unstable" [S10] |
| **Gabor-Granger** | Gabor & Granger, 1960s | demand curve, revenue curve, revenue-maximising price [S3] | Choosing a *point* price for an existing/defined product | Evaluates product in isolation; "doesn't account for competitive context" [S3]; self-reported intent [S7]. Qualtrics ladder: start random in middle third; questions = ceil(log2((max−min)/tolerance)) [S6]. Sample: IntelliSurvey (P3) "100 or more respondents" [S7] |
| **Choice-based conjoint (CBC)** | Green & Srinivasan; Sawtooth (Johnson, Orme) | part-worths, share-of-preference simulators, price elasticity by feature | Feature/price trade-offs, packaging tiers | Johnson's rule: **n·t·a / c ≥ 500** (n respondents, t tasks, a alternatives excl. none, c largest number of levels); "It would be better, when possible, to have 1,000 or more representations per main-effect level" [S2]. Sawtooth blog: ~300 respondents rule of thumb, ≥ 200 per subgroup reported separately, main-effect SEs < 0.05 [S1]. Costly for a small studio |
| **Good-Better-Best** | Rafi Mohammed, HBR Sep–Oct 2018 [S11] | 3-tier offer: Good attracts price-sensitive buyers, Better is the Goldilocks default, Best captures high-WTP buyers; "fence" attributes stop downgrading (e.g., non-refundable Good rates, GA-only tickets) [S12] | Any offer with heterogeneous WTP | Full text paywalled; tier-gap heuristics (Better ≈ +10% over avg sale, Good ≈ −25%, Best ≤ +50%) are trade-press (P3) [S12] — **treat as UNVERIFIED** |
| **Anchoring / compromise / decoy** | Tversky & Kahneman 1974 (Science 185:1124–31) [S29]; Huber, Payne & Puto 1982 (JCR 9(1):90–98) [S28]; S-K "psychological pricing" [S17] | higher reference points raise WTP; middle option wins; asymmetrically dominated decoy shifts choice | Tier design, first-offer in negotiation | Decoy needs near-indifference, comparable dimensions, easy-to-see dominance; "may not appear in realistic purchasing scenarios" [S28]. Ariely's Economist case: 16/0/84 → 68/32 when decoy removed [S28] |
| **Pocket price waterfall / band** | Marn & Rosiello, McKinsey, HBR 1992 [S44] | list → invoice → pocket price after all leakages; band of realised prices | Discount governance | Abstract: transaction prices for one product "range 60%; one fastener supplier's price band ranged up to 500%". The "1% price = 11.1% operating profit" statistic is **UNVERIFIED** (paywalled) |
| **Utilisation-based rate** | practitioner formula | hourly rate = (labour + overhead + profit) ÷ billable hours [S25] | T&M, retainer floors | Realistic billable hours 1,200–1,600/yr; 2×–3× salary multiplier; 65–80% billable efficiency [S25]. Industry actual utilisation is lower (SPI 68.9% 2024, 66.4% 2025) [S23][S24] |
| **Channel margin stack + MAP** | practitioner (Teel) [S26]; US antitrust (Colgate 1919, Leegin 2007) [S27] | retail = COGS × 3–4; keystone (retailer 50% margin, 40–60% typical); distributor 10–15%; GM ≥ 40%, 50–60% ideal [S26] | Hardware sold via distributors/retail | MAP restricts *advertised* not *sale* price; must be unilateral (no agreements) or it becomes RPM; CA/NY still per-se hostile [S27]. Philippine treatment of RPM under RA 10667 **UNVERIFIED** |
| **Skimming vs penetration** | Simon-Kucher [S17] | launch price posture | New product launch | "Many companies fail with a penetration pricing strategy… You need to be able to follow through on future price increases" [S17] |

## 3. Numbers annex

| metric | benchmark / threshold | context | source URL | grade | retrieved |
|---|---|---|---|---|---|
| CBC minimum exposures | n·t·a/c ≥ 500; 1,000+ better | aggregate CBC, Johnson/Orme | https://content.sawtoothsoftware.com/assets/dd3f6a38-285f-441f-a88c-678d7c8aaffb | P1 | 2026-09-02 |
| CBC respondents | ~300; ≥ 200 per reported subgroup; SE < 0.05 | Sawtooth blog (Halversen, 2020) | https://sawtoothsoftware.com/resources/blog/posts/sample-size-rules-of-thumb | P1 | 2026-09-02 |
| Van Westendorp sample | 150–200/segment floor; 200–300 preferred; < 100 unstable | vendor guidance | https://cleverx.com/blog/pricing-sensitivity-survey-van-westendorp-guide/ | P3 | 2026-09-02 |
| Gabor-Granger sample | "100 or more respondents" | vendor guidance | https://www.intellisurvey.com/blog/understanding-gabor-granger-pricing-method | P3 | 2026-09-02 |
| Innovation failure | 72% of new products (past 5 yrs) failed | Simon-Kucher research, per Ramanujam | https://www.marketingjournal.org/monetizinginnovation/ | P2 | 2026-09-02 |
| Price-increase realisation | companies "realize less than half the amount of their price increases on average" | Global Pricing Study 2025, >2,200 leaders, 28 countries, 39 industries | https://www.simon-kucher.com/en/insights/global-pricing-study-2025 | P1 | 2026-09-02 |
| Price lever | "A 5% improvement in pricing without volume loss and average margins can boost profits easily by 30% to 50%" | Simon-Kucher e-book (2019) | https://www.simon-kucher.com/sites/default/files/2019-06/SimonKucher_Ebook_A_Practical_Guide_to_Pricing.pdf | P1 | 2026-09-02 |
| Price wars | "More than half of all companies worldwide believe they're involved in a price war" | same e-book | same | P1 | 2026-09-02 |
| Price-increase justification | "no specific reasons… might fly with a 2% increase, but higher increases definitely need justification" | same e-book | same | P1 | 2026-09-02 |
| Pocket price band | product transaction prices range 60%; one supplier up to 500% | HBR 1992 abstract | https://pubmed.ncbi.nlm.nih.gov/10121318/ | P1 (abstract) | 2026-09-02 |
| Usage-based pricing adoption | 3 of 5 SaaS firms (2023) vs 45% (2021); 46% hybrid/testing | OpenView State of UBP 2nd ed., via Chargebee | https://www.chargebee.com/blog/usage-based-pricing-for-growth-in-a-changing-landscape/ | P2 | 2026-09-02 |
| Value metric effect | value-metric companies grow at "double the rate… with half the churn and 2x the expansion revenue" | ProfitWell analysis, via Paddle | https://www.paddle.com/resources/pricing-strategy | P2 | 2026-09-02 |
| Localisation | Nordic customers pay 28% more than US; Brazil 12% less | Paddle (Mar 2026) | https://www.paddle.com/blog/saas-pricing-models-strategies-fltr | P2 | 2026-09-02 |
| Pricing review cadence | "Review pricing quarterly" | Paddle | same | P2 | 2026-09-02 |
| Billable utilisation | 68.9% (2024), 73.2% (2021), 5-yr avg 70.8%; SPI optimal threshold 75% | SPI 2025 PS Maturity Benchmark, 403 firms | https://forms.workday.com/content/dam/web/en-us/documents/reports/SPI_2025_Benchmark_Report.pdf | P1 | 2026-09-02 |
| Revenue per billable consultant | $199K (2024), $207K (2023) | same | same | P1 | 2026-09-02 |
| Project margin / EBITDA | 35.9% / 9.8% (2024); EBITDA 15.4% (2023) | same | same | P1 | 2026-09-02 |
| Subcontractor share | 10.9% of revenue (2024) | same | same | P1 | 2026-09-02 |
| Utilisation 2025 | 66.4%; rev/consultant $210K; project margin 37.7%; EBITDA 9.9% | SPI 2026 edition, 500+ firms, via Deltek | https://www.deltek.com/resources/articles/professional-services-benchmarks/ | P2 | 2026-09-02 |
| Billable hours / multiplier | 1,200–1,600 billable hrs/yr; 1,500 default; 2×–3× salary; 65–80% billable efficiency | ClickTime | https://www.clicktime.com/resources/billing-rate-calculator | P3 | 2026-09-02 |
| Hardware retail multiple | retail ≥ 3× COGS initially, 4× target; keystone = 50% retailer margin (40–60%); distributor 10–15%; GM ≥ 40%, 50–60% ideal | Predictable Designs (Teel) | https://predictabledesigns.com/how-to-price-your-product-for-various-distribution-channels/ | P3 | 2026-09-02 |
| Decoy effect | Economist: 16/0/84 with decoy → 68/32 without | Ariely via Wikipedia; Huber et al. 1982 | https://en.wikipedia.org/wiki/Decoy_effect | P3 (cites P1) | 2026-09-02 |
| Anchoring | wheel at 10 → ~25%; at 65 → ~45% | Tversky & Kahneman 1974 via Wikipedia | https://en.wikipedia.org/wiki/Anchoring_effect | P3 (cites P1) | 2026-09-02 |
| PH VAT rate | 12% of gross sales (goods and services) | NIRC §106/§108 as amended by RA 11976 | https://lawphil.net/statutes/repacts/ra2024/ra_11976_2024.html | P1 | 2026-09-02 |
| PH VAT threshold | ₱3,000,000 gross sales, past 12 months or reasonably expected next 12 | PwC (reviewed 1 Aug 2026); NIRC §109(BB) | https://taxsummaries.pwc.com/philippines/corporate/other-taxes ; https://lawphil.net/statutes/repacts/ra2017/ra_10963_2017.html | P2 / P1 | 2026-09-02 |
| Percentage tax (non-VAT) | 3% of gross quarterly sales; was 1% 1 Jul 2020–30 Jun 2023 | NIRC §116; RA 11534 | https://lawphil.net/statutes/repacts/ra2021/ra_11534_2021.html | P1 | 2026-09-02 |
| 8% option | 8% on gross sales/receipts + other non-operating income above ₱250,000, in lieu of graduated rates and §116; only individuals ≤ ₱3M and not VAT-registered | NIRC §24(A)(2)(b); RMO 23-2018 | https://bir-cdn.bir.gov.ph/local/pdf/RMO%20NO.23-2018.pdf | P1 | 2026-09-02 |
| Graduated individual rates | 0% to ₱250k … 35% above ₱8M (2023+) | PwC (reviewed 2 Jul 2026) | https://taxsummaries.pwc.com/philippines/individual/taxes-on-personal-income | P2 | 2026-09-02 |
| CWT on professional fees, individual | 5% if gross income for year ≤ ₱3M; 10% if > ₱3M | RR 11-2018 §2.57.2(A) | https://bir-cdn.bir.gov.ph/local/pdf/Digest%20RR%2011-2018.pdf | P1 | 2026-09-02 |
| CWT on professional fees, non-individual | 10% if gross income ≤ ₱720,000; 15% if > ₱720,000 | same | same | P1 | 2026-09-02 |
| 5% rate condition | payee must be non-VAT per COR; VAT-registered individuals 10% regardless | RR 14-2018 via Grant Thornton | https://www.grantthornton.com.ph/alerts-and-publications/technical-alerts/tax-alert/2018/additional-condition-for-5-ewt-on-professional-fees-extended-deadlines-for-sworn-declarations/ | P2 | 2026-09-02 |
| EOPT taxpayer classes | micro < ₱3M; small ₱3M–< ₱20M; medium ₱20M–< ₱1B; large ≥ ₱1B | RA 11976 §21 | https://lawphil.net/statutes/repacts/ra2024/ra_11976_2024.html | P1 | 2026-09-02 |
| Invoice thresholds | VAT shown as separate item; buyer name/TIN/address for sales ≥ ₱1,000 to VAT-registered buyers; issuance mandatory ≥ ₱500 | NIRC §113 / RR 7-2024 via MTF Counsel | https://mtfcounsel.com/2025/05/08/how-to-comply-with-the-birs-invoicing-requirements/ | P2 | 2026-09-02 |
| PH software engineer pay (job-ad averages, monthly) | Mandaluyong ₱100,000; Manila ₱76,500; Taguig ₱75,000; Pampanga ₱72,500; Parañaque ₱65,000 | Jobstreet, Sept 2026, employer-disclosed ranges | https://ph.jobstreet.com/career-advice/role/software-engineer/salary | P2 | 2026-09-02 |
| PH electronics engineer pay (job-ad averages, monthly) | Laguna ₱50,000; Pasig ₱29,250; Mandaluyong ₱27,000; Misamis Oriental ₱23,500 | Jobstreet, Sept 2026 | https://ph.jobstreet.com/career-advice/role/electronics-engineer/salary | P2 | 2026-09-02 |
| PH engineering *service* hourly/day rates | **UNVERIFIED** — no P1/P2 rate survey retrieved (PSA OWS 403; Michael Page gated; Robert Walters not fetched) | — | — | — | 2026-09-02 |

Worked floor (not a benchmark): a ₱75,000/month engineer (₱900k/yr) at a 2.0× loaded multiplier and 20% profit over 1,400 billable hours → ₱900k × 2.0 × 1.2 ÷ 1,400 ≈ **₱1,540/hr** before VAT; at SPI-actual 66% utilisation of 2,000 h (1,320 h) ≈ ₱1,640/hr. Inputs from [S25][S23][S42]; the multiplier and profit are harness parameters, not findings.

## 4. Philippine specifics

**VAT (12%).** Levied on gross sales of goods and, since RA 11976, of services ("twelve percent (12%) of the gross sales derived from the sale or exchange of services", §108(A)) [S35]. Registration is compulsory once gross sales exceed ₱3M in the past 12 months or are reasonably expected to in the next 12 [S36]; §109(BB) exempts sellers at or below ₱3M and provides CPI re-indexing every three years [S33] (whether the BIR has re-indexed is **UNVERIFIED**; PwC still states ₱3M as of Aug 2026 [S36]).

**Inclusive vs exclusive quoting.** §113(B) as amended: "The amount of the tax shall be shown as a separate item in the invoice" [S35]; RR 7-2024 requires "the total amount the buyer pays or is obliged to pay, inclusive of VAT, with the VAT amount shown as a separate line item" [S41]. Consequence for the harness: B2B quotes and price books must carry the ex-VAT price and the 12% line separately; a quote stated as one inclusive number is treated as ex-VAT by many B2B buyers and the seller eats 12/112 of it (quoting convention = practitioner consensus; the separate-line requirement = P1). Consumer-facing price displays being VAT-inclusive under DTI rules is **UNVERIFIED** here.

**Zero-rating for foreign clients.** §108(B)(2): services "rendered to a person engaged in business conducted outside the Philippines or to a nonresident person not engaged in business who is outside the Philippines when the services are performed, the consideration for which is paid for in acceptable foreign currency and accounted for in accordance with the rules and regulations of the Bangko Sentral ng Pilipinas" are VAT zero-rated for a VAT-registered seller [S33]. Documentation conditions and refund practice are not covered here.

**EOPT Act (RA 11976, approved 5 Jan 2024; effective 15 days after publication; Grant Thornton's note dated 22 Jan 2024)** [S35][S39]:
- VAT on services moved from collection (gross receipts) to accrual (gross sales); the invoice replaces the official receipt as the VAT document [S35][S38][S39]. Cash-flow effect: output VAT is due on invoicing, not collection.
- Relief: §110(D) "A seller of goods or services may deduct the output VAT pertaining to uncollected receivables from its output VAT on the next quarter" after the agreed payment period lapses [S35][S40].
- §58(C): "The obligation to deduct and withhold the tax arises at the time the income has become payable" [S35][S38].
- Taxpayer classes by gross sales (micro < ₱3M, small < ₱20M, medium < ₱1B, large ≥ ₱1B); reduced penalties for micro/small (10% surcharge, 50% interest reduction) [S35][S40].

**Non-VAT path and the 8% option (individuals / sole proprietors only).** §24(A)(2)(b) (TRAIN, effective 1 Jan 2018): "eight percent (8%) tax on gross sales or gross receipts and other non-operating income in excess of Two hundred fifty thousand pesos (₱250,000) in lieu of the graduated income tax rates… and the percentage tax under Section 116" [S33]. RMO 23-2018: available only to individuals with gross sales ≤ ₱3M who are not VAT-registered; not for partners of GPPs; must be signified in the first-quarter return; if cumulative gross sales exceed ₱3M mid-year the taxpayer is "liable for graduated income tax rates and VAT from the date the P3,000,000 threshold is breached" [S30]. Otherwise: graduated rates 0–35% plus 3% percentage tax (1% during 1 Jul 2020–30 Jun 2023 under CREATE) [S37][S34]. Corporations cannot use the 8% option (RMO scope is "individual taxpayers") [S30]; the corporate rate was not fetched — **UNVERIFIED** here.

Pricing math: for a sole prop under 8%, tax is ~8% of revenue above ₱250k with no deductions — the cost floor must include it as a revenue-linked cost; under graduated rates the effective rate depends on margin. Crossing ₱3M forces 12% VAT on all subsequent sales: a price that was net-of-tax competitive at ₱2.9M becomes 12% more expensive to non-VAT buyers, or 12% less profitable if absorbed.

**Creditable withholding tax (CWT/EWT) the client deducts.** RR 11-2018 §2.57.2(A), professional/talent fees "for services rendered" — individual payee: 5% if gross income for the current year ≤ ₱3M, 10% if more; non-individual payee: 10% if ≤ ₱720,000, 15% if more; the payee list explicitly includes "civil, electrical, chemical, mechanical, structural, industrial… engineers" and "management and technical consultants" [S31]. RR 14-2018 added that 5% requires the COR to show non-VAT status; VAT-registered individuals are withheld 10% regardless; the payee files a sworn declaration with each payor (initial 2018 deadlines 20/30 April; thereafter before first payment / annually) [S32]. The payor issues **BIR Form 2307** (Certificate of Creditable Tax Withheld at Source) [S31]; the payee credits it against income tax due. Pricing consequence: CWT is a prepayment, not a cost, so no gross-up is needed if income tax due ≥ credits; but 5–15% of every invoice arrives as a tax credit rather than cash, so the cash-flow floor must be computed on (1 − CWT) × ex-VAT price. Payor-side timing now follows §58(C) "payable" [S35]. Whether 2307 credits offset the 8% tax is governed by RR 8-2018 — **UNVERIFIED** in fetched text.

## 5. Mechanical gate candidates

**Pricing ledger `price-book.csv` (one row per offer × tier × metric):**
`offer_id, tier, price_metric{seat|usage|flat|tiered|tm|fixed|milestone|retainer|value}, list_price_exvat, currency, vat_treatment{vatable12|exempt_nonvat|zero_rated_108B2}, display{exclusive|inclusive}, cost_floor_exvat, floor_method, floor_date, target_gm_pct, cwt_rate_expected, competitor_low, competitor_high, competitor_n, competitor_capture_date, wtp_n, wtp_pmc, wtp_opp, wtp_ipp, wtp_pme, research_method, justification_ref, max_discount_pct, discount_authority, grandfather_until, effective_from, approver`

Supporting ledgers: `competitor-band.csv` (offer_id, competitor, url, capture_date, hash, price, metric, vat_treatment); `wtp-interviews.csv`; `discount-log.csv` (quote_id, list, invoiced, pocket, approver); `tax-status.csv` (entity_type, vat_registered, eight_pct_elected, trailing_12m_gross_sales, cor_date); `price-change-log.csv` (offer_id, old, new, reason_text, notice_date, effective, realised_pct).

**Checks a script can run (thresholds are harness defaults unless sourced):**
1. `price ≥ cost_floor / (1 − target_gm)` per row; hardware retail rows additionally `list ≥ 3 × cogs` (warn) and `≥ 4 ×` (pass) [S26]; hardware GM ≥ 40% [S26].
2. Floor freshness: `floor_date` ≤ 90 days; utilisation input ≤ 75% and, if > 70%, a justification ref (SPI 68.9% / 66.4% actuals) [S23][S24].
3. Competitor band: `competitor_n ≥ 3`, every capture ≤ 90 days old, hash present; flag if `list_price` outside [0.8 × low, 1.5 × high] without `justification_ref`.
4. Research adequacy: Van Westendorp rows require `wtp_n ≥ 150` per segment (P3 floor) and `pmc ≤ list ≤ pme`; Gabor-Granger `n ≥ 100`; CBC `n·t·a/c ≥ 500` [S2][S7][S10].
5. WTP evidence: any new offer without ≥ 10 `wtp-interviews.csv` rows in its segment fails ("price before product") [S14].
6. Tax consistency: if `trailing_12m_gross_sales > 3,000,000` then `vat_registered = true` and no row `exempt_nonvat`; if `vat_registered` then `eight_pct_elected = false`; `zero_rated_108B2` only with foreign-currency client flag; every B2B row `display = exclusive` and quote template shows VAT as a separate line [S30][S33][S35][S41].
7. CWT expectation: `cwt_rate_expected ∈ {5,10}` for sole prop, `{10,15}` for corporation, per rules in §4; cash floor computed on `(1 − cwt) × price` [S31][S32].
8. Discount discipline: pocket/list ≥ (1 − max_discount); any quote below floor blocks; monthly pocket-price band width reported (P90/P10) — band > 1.6× triggers review (Marn & Rosiello 60% band as the alarm level) [S44].
9. Tier structure: 2–4 tiers; each tier has ≥ 1 fence attribute; monotone price and feature sets [S12][S21].
10. Price-change log: every increase has non-empty `reason_text`, ≥ 30-day notice for existing customers, `grandfather_until` set or explicitly null; track `realised_pct` vs attempted (S-K: < 50% realised is the industry norm to beat) [S16][S17][S21].
11. Cadence: ledger reviewed (any row touched) at least quarterly [S21].

**Cannot be mechanised (stays human):** the value story and monetary-benefit estimate; picking the segment and price metric; interpreting WTP interviews; whether to skim or penetrate; entering/exiting a price war; negotiation walk-away points; grandfathering decisions; the VAT-registration/8% election itself (a BIR filing — human-gated); sending any quote, discount or price-increase notice (irreversible send); signing MAP/channel terms.

## 6. Early irreversibles

1. **Price metric / value metric** — per-seat vs usage vs flat shapes billing, product telemetry and contracts; Paddle lists model-specific traps (seat-sharing, unpredictable usage revenue) [S21]; switching later means re-papering every customer.
2. **First public list price = the anchor** — customers' and competitors' reference point (anchoring, [S29]); penetration launches rarely recover: "prices hardly ever return to their pre-war levels" [S17].
3. **Tax posture** — 8% must be elected in Q1 and is tied to non-VAT status; VAT registration changes every quote (+12% line) and CWT rate (5% → 10%); entity form (sole prop vs corporation) fixes which CWT bracket and whether 8% is even available [S30][S31][S32].
4. **Contract T&Cs enabling increases** — "Consider when your contract allows for a price increase and keep an eye on T&Cs" [S17]; retainer/fixed-price contracts without indexation lock the price.
5. **Discount precedents** — the first discounts set the pocket-price band and the expectation for every renewal [S44][S17].
6. **Channel structure** — once distributors/retailers are appointed, their 10–15% / 40–60% margin expectations fix the retail-to-COGS multiple you must design to [S26]; a MAP policy must be unilateral from day one [S27].
7. **Grandfathering promises** — cheap to give, expensive to unwind [S21].

## 7. Failure modes / anti-patterns the harness must guard against

| Anti-pattern | Guard | Source |
|---|---|---|
| Building before the WTP conversation (feature shock, minivation, hidden gem, undead) | Check 5 | Ramanujam [S14] |
| Cost-plus for software/services as the *price* rather than the *floor* | Checks 1 & 3 with value evidence | Paddle [S19]; S-K [S17] |
| Copying competitors with no differentiation ("doesn't leave a lot of room for growth") | Check 3 requires justification when inside the band by imitation | Paddle [S19]; S-K [S18] |
| Penetration price with no path to increase | Launch posture flag + T&C indexation clause | S-K [S17] |
| Price increase with no stated reason; attempting increases that realise < 50% | Check 10 | S-K [S16][S17] |
| Discount leakage / wide pocket-price band | Check 8 | Marn & Rosiello [S44] |
| Too many tiers → decision paralysis; per-seat seat-sharing; usage revenue volatility | Check 9; model pros/cons recorded | Paddle [S21] |
| Under-powered price research (unstable intersections, wide CIs) | Check 4 | Sawtooth [S1][S2]; CleverX [S10] |
| PSM used as if it modelled competition or purchase intent | research_method note + NMS extension | Sawtooth [S4] |
| Decoy tiers nobody can see dominance in | Check 9 fences; decoy caveats | [S28] |
| Quoting one VAT-inclusive number to B2B buyers (losing 12/112) or invoicing without the VAT line | Check 6 | NIRC §113 [S35]; MTF [S41] |
| Crossing ₱3M unplanned → VAT + graduated rates from breach date | Check 6 trailing-12m monitor at 80% of threshold | RMO 23-2018 [S30] |
| Electing 8% while VAT-registered / as a corporation | Check 6 | [S30] |
| Treating CWT as lost revenue (over-grossing) or ignoring it (cash floor too low) | Check 7 | RR 11-2018 [S31] |
| Assuming 100% utilisation in the rate floor | Check 2 | SPI [S23][S24] |
| Hardware priced at COGS + margin ignoring the channel stack | Check 1 hardware branch | Teel [S26] |
| MAP policy negotiated into an agreement → RPM exposure | human-gated legal review; PH law UNVERIFIED | [S27] |
| Changing prices on existing customers without test/grandfather/transition | Check 10 | Paddle [S21] |
| Entering a price war ("nobody ever truly wins") | human gate + competitor-band trend alarm | S-K [S17] |
| Pricing revisited never ("one-time project") | Check 11 | S-K [S17]; Paddle [S21] |

## 8. Sources

1. [S1] Sawtooth Software — "Sample Size Rules of Thumb for a CBC Study" (Halversen, 2020) · https://sawtoothsoftware.com/resources/blog/posts/sample-size-rules-of-thumb · P1 · 300-respondent rule, ≥ 200 per subgroup, 500/1,000 exposures, SE < 0.05.
2. [S2] Orme, B., *Getting Started with Conjoint Analysis*, 4th ed., ch. 7 (Sawtooth PDF) · https://content.sawtoothsoftware.com/assets/dd3f6a38-285f-441f-a88c-678d7c8aaffb · P1 · n·t·a/c ≥ 500; 1,000 better; Johnson & Orme 1996.
3. [S3] Sawtooth — "Gabor-Granger Pricing Method" (2024) · https://sawtoothsoftware.com/resources/blog/posts/gabor-granger-pricing-method · P1 · mechanics, outputs, isolation critique.
4. [S4] Sawtooth — "Van Westendorp Pricing Model" · https://sawtoothsoftware.com/resources/blog/posts/van-westendorp-pricing-sensitivity-meter · P1 · four questions, intersections, critiques, Newton-Miller-Smith.
5. [S5] Conjointly — Van Westendorp tool page · https://conjointly.com/products/van-westendorp/ · P2 · PMC/PME/OPP/IPP definitions, NMS 5-point questions.
6. [S6] Qualtrics — Pricing Study (Gabor-Granger) · https://www.qualtrics.com/support/common-use-case/xm-solutions/pricing-study-gabor-granger/ · P2 · ladder algorithm and question-count formula.
7. [S7] IntelliSurvey — Gabor-Granger · https://www.intellisurvey.com/blog/understanding-gabor-granger-pricing-method · P3 · "100 or more respondents"; limitations.
8. [S8] SurveyMonkey — Van Westendorp guide · https://www.surveymonkey.com/market-research/resources/van-westendorp-price-sensitivity-meter/ · P3 · confirms no sample-size guidance.
9. [S9] Quantilope — Van Westendorp questions · https://www.quantilope.com/resources/examples-of-van-westendorp-price-sensitivity-questions · P3 · confirms no sample-size guidance.
10. [S10] CleverX — Van Westendorp guide (Jul 2026) · https://cleverx.com/blog/pricing-sensitivity-survey-van-westendorp-guide/ · P3 · 150–200/segment floor, < 100 unstable.
11. [S11] Mohammed, R., "The Good-Better-Best Approach to Pricing", HBR Sep–Oct 2018 · https://hbr.org/2018/09/the-good-better-best-approach-to-pricing · P1 (paywalled; header only) · existence, date, Allstate example.
12. [S12] Wikipedia — Good–better–best · https://en.wikipedia.org/wiki/Good%E2%80%93better%E2%80%93best · P3 · tier purposes and fence attributes as summarised from HBR 2018; trade-press gap heuristics.
13. [S13] Mohammed, R., "Why Good-Better-Best Prices Are So Effective", HBR 2013 · https://hbr.org/2013/02/why-good-better-best-prices-are-so-effective · P1 (header only) · not used for numbers.
14. [S14] Marketing Journal — interview with Madhavan Ramanujam on *Monetizing Innovation* · https://www.marketingjournal.org/monetizinginnovation/ · P2 · 72% failure stat, four failure types, nine rules, Cayenne.
15. [S15] Lenny's Newsletter — "The art and science of pricing | Madhavan Ramanujam" · https://www.lennysnewsletter.com/p/the-art-and-science-of-pricing-madhavan · P2 · WTP "early and often", "price before product".
16. [S16] Simon-Kucher — Global Pricing Study 2025 · https://www.simon-kucher.com/en/insights/global-pricing-study-2025 · P1 · > 2,200 leaders/28 countries/39 industries; < 50% price-increase realisation.
17. [S17] Simon-Kucher — *A Practical Guide to Pricing* e-book (2019, PDF) · https://www.simon-kucher.com/sites/default/files/2019-06/SimonKucher_Ebook_A_Practical_Guide_to_Pricing.pdf · P1 · 5% price → 30–50% profit; price-war prevalence; increase checklist; value-pricing steps; psychological effects; penetration risk.
18. [S18] Simon-Kucher — "Master pricing models" (Feb 2026) · https://www.simon-kucher.com/en/insights/master-pricing-models-strategies-maximize-business-value · P1 · definitions of cost-plus, competitor-based, value-based.
19. [S19] Paddle — "Pricing strategy guide" · https://www.paddle.com/resources/pricing-strategy · P2 · critiques of cost-plus/competitor-based; ProfitWell value-metric claim.
20. [S20] Paddle — "How to optimize your SaaS pricing in practice" (Rose, 2021) · https://www.paddle.com/blog/optimize-pricing-strategy · P2 · localisation, discounts, value metrics as experiment areas.
21. [S21] Paddle — "SaaS Pricing Models and Strategies" (Mar 2026) · https://www.paddle.com/blog/saas-pricing-models-strategies-fltr · P2 · model pros/cons; grandfather/transition; quarterly review; localisation deltas.
22. [S22] Chargebee — "Usage-based Pricing For Growth…" citing OpenView State of UBP 2nd ed. (Feb 2023) · https://www.chargebee.com/blog/usage-based-pricing-for-growth-in-a-changing-landscape/ · P2 · 3 of 5; 45% (2021); 46% hybrid.
23. [S23] SPI Research — 2025 Professional Services Maturity Benchmark (PDF via Workday) · https://forms.workday.com/content/dam/web/en-us/documents/reports/SPI_2025_Benchmark_Report.pdf · P1 · utilisation, revenue/consultant, margins, EBITDA, subcontractor share, 403 firms.
24. [S24] Deltek — "2026 PSO Benchmarks: Insights from SPI" · https://www.deltek.com/resources/articles/professional-services-benchmarks/ · P2 · 2025 figures (66.4%, $210K, 37.7%, 9.9%).
25. [S25] ClickTime — Billing rate calculator · https://www.clicktime.com/resources/billing-rate-calculator · P3 · rate formula, billable-hour and multiplier assumptions.
26. [S26] Predictable Designs (Teel) — "How to Price Your Product for Various Distribution Channels" · https://predictabledesigns.com/how-to-price-your-product-for-various-distribution-channels/ · P3 · 3–4× COGS, keystone, distributor 10–15%, GM targets.
27. [S27] Bona, J., "Does a MAP Policy Violate the Antitrust Laws?" (2022) · https://www.theantitrustattorney.com/minimum-advertised-price-map-policy-violate-antitrust-laws/ · P2 · MAP vs RPM, Colgate, Leegin, state caveats.
28. [S28] Wikipedia — Decoy effect · https://en.wikipedia.org/wiki/Decoy_effect · P3 · Huber/Payne/Puto 1982 citation; Economist numbers; conditions.
29. [S29] Wikipedia — Anchoring effect · https://en.wikipedia.org/wiki/Anchoring_effect · P3 · Tversky & Kahneman 1974 citation; wheel experiment.
30. [S30] BIR — RMO 23-2018 (8% income tax rate option) · https://bir-cdn.bir.gov.ph/local/pdf/RMO%20NO.23-2018.pdf · P1 · eligibility, ₱3M/₱250k, ineligible classes, Q1 election, mid-year breach.
31. [S31] BIR — Digest of RR 11-2018 (withholding, TRAIN) · https://bir-cdn.bir.gov.ph/local/pdf/Digest%20RR%2011-2018.pdf · P1 · §2.57.2(A) 5/10% and 10/15% with ₱3M/₱720k tests; engineer/consultant payees; Form 2307.
32. [S32] Grant Thornton PH — "Additional condition for 5% EWT on professional fees" (2018) · https://www.grantthornton.com.ph/alerts-and-publications/technical-alerts/tax-alert/2018/additional-condition-for-5-ewt-on-professional-fees-extended-deadlines-for-sworn-declarations/ · P2 · RR 14-2018 non-VAT condition; sworn declaration.
33. [S33] lawphil — RA 10963 (TRAIN) · https://lawphil.net/statutes/repacts/ra2017/ra_10963_2017.html · P1 · §24(A)(2)(b), §108(B)(2), §109(BB) + CPI proviso, §116, effectivity 1 Jan 2018.
34. [S34] lawphil — RA 11534 (CREATE) · https://lawphil.net/statutes/repacts/ra2021/ra_11534_2021.html · P1 · §116 3% with 1% window 1 Jul 2020–30 Jun 2023.
35. [S35] lawphil — RA 11976 (Ease of Paying Taxes) · https://lawphil.net/statutes/repacts/ra2024/ra_11976_2024.html · P1 · effectivity, §21 classes, §108(A) gross sales, §113(B) separate VAT item, §110(D), §58(C).
36. [S36] PwC Tax Summaries — Philippines corporate, other taxes (reviewed 1 Aug 2026) · https://taxsummaries.pwc.com/philippines/corporate/other-taxes · P2 · 12% VAT; ₱3M registration test.
37. [S37] PwC Tax Summaries — Philippines individual, taxes on personal income (reviewed 2 Jul 2026) · https://taxsummaries.pwc.com/philippines/individual/taxes-on-personal-income · P2 · graduated brackets; 8% option wording.
38. [S38] Deloitte SEA — "Value Added: … changes made by RA 11976" · https://www.deloitte.com/southeast-asia/en/services/tax/perspectives/ease-of-paying-taxes-act.html · P2 · VAT on gross sales for services; withholding timing; ₱1B large class.
39. [S39] Grant Thornton PH — "New year new law: … Ease of Paying Taxes Act" (22 Jan 2024) · https://www.grantthornton.com.ph/insights/articles-and-updates1/tax-notes/new-year-new-law-what-we-can-expect-from-the-ease-of-paying-taxes-act/ · P2 · signing 5 Jan 2024; effectivity clause; OR → invoice.
40. [S40] Ocampo & Suralvo — "Republic Act No. 11976" (23 Jan 2024) · https://www.ocamposuralvo.com/2024/01/23/republic-act-no-11976-ease-of-paying-taxes-act/ · P2 · class thresholds; uncollected-receivable output VAT; reduced penalties.
41. [S41] MTF Counsel — "How to comply with the BIR's invoicing requirements" (8 May 2025) · https://mtfcounsel.com/2025/05/08/how-to-comply-with-the-birs-invoicing-requirements/ · P2 · §113/RR 7-2024 invoice contents, ₱1,000 and ₱500 thresholds.
42. [S42] Jobstreet PH — Software Engineer salary (Sept 2026) · https://ph.jobstreet.com/career-advice/role/software-engineer/salary · P2 · location averages from employer-disclosed ranges.
43. [S43] Jobstreet PH — Electronics Engineer salary (Sept 2026) · https://ph.jobstreet.com/career-advice/role/electronics-engineer/salary · P2 · location averages.
44. [S44] Marn & Rosiello, "Managing Price, Gaining Profit", HBR 70(5) 1992 — PubMed abstract · https://pubmed.ncbi.nlm.nih.gov/10121318/ · P1 (abstract) · pocket price waterfall/band; 60% and 500% band examples.
45. Michael Page PH — Salary Guide 2026 · https://www.michaelpage.com.ph/salary-guide · gated; no data extracted.

Not reachable on 2026-09-02 (recorded so the next pass can retry): OpenView blog pages (redirect to corporate shell), web.archive.org (blocked), PSA Occupational Wages Survey (403), Official Gazette RA 11976 (403), McKinsey "The power of pricing" (timeout), SC e-library RR 14-2018 (TLS error), HBR full texts (paywall).
