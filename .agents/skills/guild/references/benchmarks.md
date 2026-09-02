# Benchmarks Annex — the numbers the protocols cite

**Provenance caveat.** Every row was read from the cited source on **2026-09-02** by the research
pass (`research/raw/NN-*.md`, section 3 of each brief); grades: **P1** primary (originator,
statute, agency, benchmark publisher), **P2** reputable secondary (Big-4 / major-firm summary,
vendor citing a named primary), **P3** weak (blog, aggregator, unsourced). Items the pass could
not verify are marked **UNVERIFIED** and are not thresholds. Statute rows change (2018, 2021,
2024, 2025, 2026 all moved something) — re-verify any row older than 12 months, and **verify with
your CPA / lawyer** before relying on a tax, labour or compliance number. This annex is not legal,
tax or financial advice.

Harness policy numbers (thresholds we chose because no published rule exists) are tagged
**policy** so nobody mistakes them for literature.

## 1. Recurring / SaaS unit economics (brief 05)

| Metric | Value | Context | Source | Grade |
|---|---|---|---|---|
| LTV:CAC | ≥ 3 viable; best 5–8 | recurring revenue; Skok 2009/2012 (self-described "early guesses", field-validated) | forentrepreneurs.com/startup-killer, /saas-metrics-2 | P1 |
| CAC payback | < 12 mo good; best 5–7; > 12 anemic | SaaS, Skok | same | P1 |
| CAC payback by segment | SMB < 12 · mid-market < 18 · enterprise < 24 mo; avg 15 at $1–10M ARR | Bessemer "Scaling to $100M" | bvp.com/atlas | P1 |
| CAC payback (private SaaS) | median 16 mo FY2025; top quartile ≤ 6; bottom ≥ 24 | 342 cos, Aleph × Benchmarkit | getaleph.com | P1 |
| Gross margin | software 80–90 % ideal (a16z); private cloud 65–70 % (Bessemer) | — | a16z.com/16-more-startup-metrics; bvp.com | P1 |
| LTV definition | on net profit / contribution, GM-adjusted, cap at 24 months measured | a16z "16 Startup Metrics" | a16z.com | P1 |
| Net revenue churn | > 2 %/month "something is wrong" | Skok | forentrepreneurs.com | P1 |
| NRR by ACV | $5–25k ≈ 100 % · $25–50k ≈ 102 % · $50–100k ≈ 105 % · $100k+ ≈ 110 % | SaaS Capital 2024 data | saas-capital.com | P1 |
| NRR (bottom-up billing data) | B2B median 82 %; AI-native 48 % (GRR 40 %) | ChartMogul 2025, 3,500 cos | chartmogul.com | P1 |
| Burn multiple | ≤ 2 early-stage; seed ~3; 5× terrible | Sacks 2020 | sacks.substack.com | P1 |
| Runway tiers | 12 / 18 / 24+ months (good / better / best) | Bessemer 2023 | bvp.com | P1 |
| Rule of 40 | applies from ~$1M MRR; not below | Feld 2015 | feld.com | P1 |
| Default alive | ask from month ~8–9; overhiring = biggest killer | Paul Graham 2015 | paulgraham.com/aord | P1 |
| Customer concentration | prefer ≤ ~10 % (example); harness flag > 20 % | a16z (**policy** for 20 %) | a16z.com | P1 / policy |

## 2. Hardware economics (briefs 05, 08, 12)

| Metric | Value | Context | Source | Grade |
|---|---|---|---|---|
| Direct gross margin | ≥ 50 % or "price too low"; ≥ 30 % hard floor (harness) | consumer hardware, Barros/Adafruit; **policy** floor | learn.adafruit.com | P1 / policy |
| Worked cost stack | MSRP $99 · BOM $32.16 · fully loaded ≈ $65.80 at 5k units (≈ 33 % GM); physical retail loses money at that scale | Bolt 2015 | blog.bolt.io | P1 |
| Channel margins | e-tail 15–20 %; specialty retail 30–35 % (to 40 %+); keystone 50 %; distributor 10–15 % | Bolt; Teel | blog.bolt.io; predictabledesigns.com | P1 / P3 |
| Retail multiple | list ≥ 3× COGS initially, 4× target | Teel | predictabledesigns.com | P3 |
| Payment terms (retail) | PO 90 days, actual ~150 days | Bolt | blog.bolt.io | P1 |
| MOQ / deposits | ~5,000 units; 50 % deposit; CM wants ~$1M BOM/yr | Bolt 2014 | blog.bolt.io | P1 |
| Tooling / certification | injection tool ~$6.5k (China); certification ≥ $15k; NRE $10–30k simple, > $250k complex; tooling 60–70 % of NRE | Bolt; Ontario Dynamics | blog.bolt.io; ontariodynamics.com | P1 / P2 |
| Scrap | ~5 % first run → ~0.5 % | Bolt | blog.bolt.io | P1 |
| Warranty reserve | booked at sale from defect history (ASC 460); rate **UNVERIFIED** | Ridgeway | ridgewayfs.com | P2 |
| NPI build sizes (startup scale) | EVT ≤ 20 (up to ~40 % may fail); DVT 2–5× EVT, all parts hard-tooled; PVT ≈ 10 % of first run; MP yield ≈ 98 % | Bolt; Instrumental | blog.bolt.io; instrumental.com | P2 |
| Incoming QC | ANSI/ASQ Z1.4 GII; AQL critical 0 / major 2.5 / minor 4.0 | QIMA; InTouch | qima.com | P2 |

## 3. Professional services / studio (briefs 05, 08, 12)

| Metric | Value | Context | Source | Grade |
|---|---|---|---|---|
| Billable utilisation | 68.9 % (2024); 66.4 % (2025); optimal 75 %; 70 % healthy floor; under-10-person firms 64.3 % | SPI 2025/2026, 403–500+ firms | get.kantata.com SPI PDF; deltek.com | P1 / P2 |
| Project margin | 35.9 % (2024); 37.7 % (2025) | SPI | same | P1 |
| EBITDA | 9.8 % (2024); under-10 firms 10.5 % (was 21.0 %) | SPI | same | P1 |
| Revenue per billable consultant | $199k; rule ≥ 1.5× fully loaded cost (min), 2× plan | SPI | same | P1 |
| Project overrun / on-time | 11.3 % overrun (> 10 % is a concern); 73.4 % on time | SPI | same | P1 |
| Revenue leakage | 5.3 % (under-10: 6.4 %); target < 5 % | SPI | same | P1 |
| Pipeline coverage | ≥ 2× next-quarter forecast recommended; 49.3 % of firms below | SPI | same | P1 |
| Backlog | 42.8 % of quarterly target avg | SPI | same | P1 |
| Bid win rate | 47.3 % avg (40–60 % band) | SPI | same | P1 |
| Discount | 9.1 % avg; > 20 % correlates with attrition | SPI | same | P1 |
| Referenceable clients | 70.1 % | SPI | same | P1 |
| DSO | 43.3 days (under-10: 37.4); "below 45 is low" | SPI; AccountingTools | same; accountingtools.com | P1 / P2 |
| Subcontractor share | 10.9 % of revenue; > 30 % ⇒ lower EBITDA | SPI | same | P1 |
| Agency net margin | 13 % (2025); studios < 10 FTE 19 %; dev agencies 11 % | Promethean 2026 | prometheanresearch.com | P1 |
| Cash-buffer days | median 27; 25th pct 13; 75th pct 62; high-tech services 33 | JPMC Institute 2016, 597k firms | jpmorganchase.com | P1 |
| Deposits | 20–50 % up front; 50/25/25 mid-size; never 50/50 on big jobs; milestones on delivery | Sakas; Apptage/Horizon (P3) | sakasandcompany.com | P2 / P3 |
| Review window / warranty holdback | 5 business days deemed acceptance; 5–10 % holdback for 30–90 d | practitioner guides | horizon-labs.co; apptage.com | P3 |
| Client concentration | > 20–25 % single client red; top-3 > 50 %; top-5 > 70 % | Projectworks | projectworks.com | P2 |
| Positioning viability | 10–200 competitors; 2,000–10,000 prospects; assume 1 % capture; 85 % of positioned agencies vertical | David C. Baker | agencymanagementinstitute.com | P2 |
| Paid discovery | $500–2,500 typical; 5–10 % of expected project value; credit deadline 2–6 weeks | Sakas | sakasandcompany.com | P2 |
| Productize after | ≥ 6 similar deliveries, ~80 % repeatable | Haus Advisors | hausadvisors.com | P3 |

## 4. Customer discovery & validation (brief 01)

| Metric | Value | Context | Source | Grade |
|---|---|---|---|---|
| Qualitative saturation | code saturation by interview 12; 80 % of codes by 6 (Guest et al. 2006); 9–17 / 16–24 (Hennink 2017) | homogeneous samples | skimle.com (SAGE blocked) | P2 |
| I-Corps floor | ≥ 100 interviews in 7 weeks | NSF | nsf.gov | P1 |
| Cadence | ≥ 1 interview per week while discovery is open | Torres | producttalk.org | P1 |
| PMF survey | ≥ 40 % "very disappointed" on users active ≥ 2× in prior 2 weeks; per segment; n ≥ 30 (**policy**, Strategyzer rule of thumb) | Ellis; Superhuman 22 → 33 → 58 % | review.firstround.com | P1 / P2 |
| Quant experiments | n > 30; B2B 50 % participation of a limited pool is excellent; 12 experiments in 12 weeks | Strategyzer | strategyzer.com | P1 |
| 6-month retention good / great | consumer SaaS 40 / 70 %; SMB SaaS 60 / 80 %; enterprise 70 / 90 % | Lenny poll of 20 experts | lennysnewsletter.com | P2 |
| Market-type cash horizon | new market unprofitable 5+ years; existing 12–18 months | Blank | steveblank.com | P1 |
| Deals lost to no decision | 20–30 % (Dunford); 40–60 % (Sales Pitch, secondary) | enterprise B2B | aprildunford.com | P1 / P2 |
| DPA penalties | 6 mo–7 yrs; ₱100k–₱4M (secs 25–32) | RA 10173 | lawphil.net | P1 |

## 5. Pricing research (brief 04)

| Metric | Value | Context | Source | Grade |
|---|---|---|---|---|
| WTP interviews before building | ≥ 10 per segment (**policy**); 72 % of new products fail (Simon-Kucher) | Ramanujam | marketingjournal.org | policy / P2 |
| CBC sample | n·t·a/c ≥ 500 (1,000 better); ~300 respondents; ≥ 200 per subgroup | Sawtooth / Orme | sawtoothsoftware.com | P1 |
| Van Westendorp sample | 150–200 per segment floor; < 100 unstable | vendor guidance | cleverx.com | P3 |
| Gabor-Granger sample | ≥ 100 | vendor guidance | intellisurvey.com | P3 |
| Price-increase realisation | companies realise < 50 % of attempted increases; > 2 % needs a stated reason | Simon-Kucher GPS 2025; e-book | simon-kucher.com | P1 |
| Pocket-price band | transaction prices range 60 % for one product; up to 500 % | Marn & Rosiello 1992 (abstract) | pubmed | P1 |
| G-B-B spacing | Good ≈ −25 %, Better ≈ +10 %, Best ≤ +50 % vs average sale | trade press | wikipedia (HBR 2018 summary) | P3 |
| Utilisation-based rate | (salary + overhead + profit) ÷ billable hours; 1,200–1,600 billable h/yr; 2–3× salary multiplier | ClickTime | clicktime.com | P3 |
| Worked PH floor | ₱75k/mo engineer, 2.0× loaded, 20 % profit, 1,400 h ⇒ ≈ ₱1,540/h ex-VAT (≈ ₱1,640 at 66 % utilisation) | derived; multiplier/profit are **policy** | brief 04 | derived |

## 6. Sales / GTM (brief 06)

| Metric | Value | Context | Source | Grade |
|---|---|---|---|---|
| Motion by ACV | ~$1k inbound/no-touch · ~$10k inside sales · ~$100k field sales | Janz 2014 | christophjanz.blogspot.com | P2 |
| CAC by motion | touchless ~$100 · inside sales $400–5,000 · field up to $100k | Skok | forentrepreneurs.com | P1 |
| Founder-led span | 0 to ~30 customers before hiring sales; first 1–3 warm, 4–10 manual, 10–50 tooling | Kazanjy; Kolysh (YC) | foundingsales.com; ycombinator.com | P1 |
| Cold email | 344 emails per meeting (≈ 0.29 %); reply 1–5 % typical; pitching cuts replies −57 %; ≤ 75–100 words; 3–4 follow-ups over ~2 weeks | Gong 28M emails; YC | gong.io; ycombinator.com | P2 / P1 |
| Discovery calls | 11–14 questions; 3–4 problems; talk:listen 46:54 | Gong 519k calls | gong.io | P2 |
| B2B win rate | 19–21 % (2025) vs 29 % (2024); slipped deals −113 %; multi-threading +130 % on > $50k | Ebsta × Pavilion 655k opps (via secondary) | gradient.works; benchmarks.ebsta.com | P2 / P1 |
| Quota | 76 % of sellers missed H1-2025 quota | same | same | P2 |
| Sales cycle | 6.5 mo avg; < $25k ACV ≈ 90 d; > $100k 6–9+ mo | same | same | P2 |
| Pipeline coverage | required = 1 ÷ win rate (33 % → 3×, 20 % → 5×); harness 5× until 20 outcomes (**policy**) | Clari | clari.com | P2 |
| Stale deals | no touch 14–21 d ⇒ flag; no dated next step ⇒ downgrade | HubSpot | blog.hubspot.com | P2 |
| Paid pilot | $10–20k on a corporate card bypasses approvals; unpaid 3–6-month partnerships = where 90 % get stuck | Blomfield (YC) | ycombinator.com | P1 |
| Channel margins | VAR 20–30 %; reseller 5–10 %; PH agents 5–10 % | Bessemer; trade.gov | bvp.com; trade.gov | P2 / P1 |
| PH payment terms | L/C 30/60 d; D/A 30–60 d; open account 30–180 d; collections 30–120 d at 20–40 % fee | US ITA CCG | trade.gov | P1 |

## 7. Marketing (brief 07)

| Metric | Value | Context | Source | Grade |
|---|---|---|---|---|
| PH digital reach (Jan 2025) | 97.5M internet users (83.8 %); Facebook 90.8M (93.1 % of internet users); Messenger 61.8M; TikTok 62.3M adults (+27 %); YouTube 57.7M; LinkedIn 19.0M (+18.8 %); identities ≠ people | DataReportal | datareportal.com | P1 |
| PH marketplaces | Shopee 55 % GMV (+25 %); TikTok Shop 29 % (+53 %); Lazada 16 % (−34 %) — FY2025 | Cube.asia | cube.asia | P2 |
| Landing page CVR | median 6.6 % all; SaaS 3.8 %; hardware 4.1 % | Unbounce 2024 | unbounce.com | P2 |
| Email | open 35.6 % (MPP-inflated) · click 2.6 % · unsub 0.22 % | Mailchimp Dec 2023 | mailchimp.com | P2 |
| Cold-email reply | 3.43 % avg; good 5–10 %; 3–5 follow-ups 8.3 % vs 4.1 % | Woodpecker | woodpecker.co | P2 |
| Deliverability | spam rate < 0.10 %, never ≥ 0.30 %; SPF+DKIM+DMARC; one-click unsubscribe | Gmail bulk-sender rules | support.google.com | P1 |
| Paid CPL (US) | Google search B2B $93.69; Meta lead $27.66; LinkedIn CPC $10–16 | LocaliQ; HockeyStack | localiq.com; hockeystack.com | P2 |
| B2B CAC by channel (US) | email $510 … LinkedIn Ads $982 … ABM $4,664 | First Page Sage | firstpagesage.com | P2 |
| Funnel | MQL→SQL 26 % (PPC) to 51 % (SEO); opp→close 32–40 % | First Page Sage | same | P2 |
| Peeking penalty | nominal 5 % significance → 26.1 % false positives with continuous checking | Evan Miller | evanmiller.org | P1 |
| Brand : activation | ~50/50; SOV > SOM correlates with growth | Binet & Field / LinkedIn B2B Institute | business.linkedin.com | P1 |
| Content clusters | 3–5 pillar candidates; 20–30 cluster articles each | HubSpot | blog.hubspot.com | P2 |
| ASC claims | superiority / No. 1 need independent third-party data (12 months); substantiation expires after 1 year | Ad Standards Council | asc.com.ph | P1 |
| RA 7394 | Art 110 misleading incl. omission; Art 115 substantiate special claims; Art 116 promo permit ≥ 30 days before national promos | Consumer Act | lawphil.net | P1 |
| ITA (RA 11967) | full effect 20 Jun 2025 (via P2); merchant disclosures, accurate listings, receipts; fines ₱5k–₱1M (P2) / ₱20k–₱1M (statute) | Cruz Marcelo; lawphil | cruzmarcelo.com; lawphil.net | P2 / P1 |
| DPA marketing consent | "continued use" ≠ consent (NPC AO 2017-42); penalties 1–6 yrs + ₱500k–₱5M | SyCipLaw; RA 10173 | legal500.com PDF; lawphil.net | P2 / P1 |

## 8. Philippine tax, labour, compliance (briefs 04, 09, 10) — verify with your CPA / lawyer

| Item | Value | Effective / source | Grade |
|---|---|---|---|
| VAT | 12 % on gross sales incl. services (EOPT); threshold ₱3,000,000 (CPI-indexed every 3 yrs); voluntary registration 3-year lock-in (Sec. 236(H)) | RA 11976 (5 Jan 2024); TRAIN; lawphil.net | P1 |
| Invoice | replaces the official receipt (RR 7-2024 eff. 27 Apr 2024); mandatory ≥ ₱500; VAT as a separate line; buyer TIN ≥ ₱1,000 to VAT-registered buyers; print the credit term (output-VAT credit on uncollected receivables, RMC 65-2024) | BIR; Grant Thornton; MTF | P1 / P2 |
| Annual registration fee | ₱500 abolished from 22 Jan 2024 | EOPT; Grant Thornton | P1 / P2 |
| Books | keep 5 years; loose-leaf within 15 d and CAS within 30 d after FYE (ORUS) | EOPT; RMC 3-2023 | P1 / P2 |
| Percentage tax | 3 % (non-VAT) | RA 11534 | P1 |
| 8 % option | individuals only; ≤ ₱3M; non-VAT; on gross above ₱250k; elect Q1; irrevocable per year; breach ⇒ graduated + VAT from breach date | RMO 23-2018 | P1 |
| CIT | 25 %; 20 % if net taxable income ≤ ₱5M and assets ≤ ₱100M (excl. land); MCIT 2 % from year 4 | CREATE; PwC (rev. Aug 2026) | P1 / P2 |
| Creditable withholding (professional fees) | individuals 5 % (≤ ₱3M, non-VAT COR + sworn declaration by 15 Jan) / 10 %; corporations 10 % (≤ ₱720k) / 15 %; TWA 1 % goods / 2 % services; Form 2307 by the 20th after quarter-end | RR 11-2018 / RR 14-2018 | P1 |
| Audit thresholds (two independent tests) | Tax Code Sec. 232: gross sales > ₱3M ⇒ CPA audit; SEC MC 4 s.2026: total assets **or** liabilities > ₱3M ⇒ audited FS (FYE ≥ 31 Dec 2025; was ₱600k) | lawphil; Grant Thornton | P1 / P2 |
| EOPT classes | micro < ₱3M; small < ₱20M; medium < ₱1B; micro/small: 10 % surcharge, interest halved | RA 11976 | P1 |
| BMBE | assets ≤ ₱3M excl. land; CA 2 years ≤ ₱1,000 at DTI Negosyo Center; income-tax + minimum-wage exemption | RA 9178; RA 10644 | P1 |
| LGU | business permit valid 1 year; renewal + local business tax by 20 January (LGC §167 — verbatim **UNVERIFIED**); surcharge 25 % + 2 %/mo; LBT ≤ ~3 % of gross | RA 11032; PwC | P1 / P2 / UNVERIFIED |
| SSS | 15 % (ER 10 / EE 5) on MSC ₱5,000–₱35,000 (final tranche 2025); report new hires within 30 days; penalty 2 %/mo | RA 11199; sss.gov.ph | P1 |
| PhilHealth | 5 % split equally; floor ₱10,000 (₱500) ceiling ₱100,000 (₱5,000); unchanged for 2026 (Advisory 2026-0042) | philhealth.gov.ph | P1 |
| Pag-IBIG | 2 % + 2 %, max ₱200 each | RA 9679; PwC | P1 / P2 |
| 13th-month pay | 1/12 of basic annual pay, by 24 December | PD 851; MO 28 | P1 |
| OSH | RA 11058 fines up to ₱100,000/day | lawphil | P1 |
| Contractor vs employee | four-fold test, control decisive (Sonza v. ABS-CBN 2004) | lawphil | P1 |
| NCR minimum wage | ₱695 → ₱755 (25 Jul 2026) → ₱780 (20 Jan 2027) — Wage Order NCR-27, enjoined by a TRO/injunction Jul–Aug 2026; model both floors | NWPC; Mercans | P1 / P2 |
| FIA (foreign co-founder) | US$200k paid-in for domestic-market enterprises (US$100k with ≥ 15 Filipino employees / DOST tech / startup endorsement); retail ₱25M | RA 11647; RA 11595 | P1 |
| Data Privacy | consent freely given/specific/informed; SPI (age, marital status, health, education) needs explicit consent; NPC registration ≥ 250 employees or SPI of ≥ 1,000 (**UNVERIFIED** circular) | RA 10173 | P1 / UNVERIFIED |
| IP Code | commissioned work: commissioner owns the object, creator keeps copyright unless written stipulation (§178.4); assignment in writing (§180) | RA 8293 | P1 |
| Trademark | DAU within 3 years of filing; 10-year term | RA 8293 | P1 |
| Consumer Act | implied warranty 60 days–1 year; repair within 30 days; service invoices ≥ 90-day workmanship guaranty; "No Return, No Exchange" prohibited (DAO 2 s.1993; fines to ₱300k + ₱1k/day) | RA 7394 | P1 / P2 |
| Government procurement | RA 12009 eff. 13 Aug 2024, IRR 10 Feb 2025, 3-year transition; PhilGEPS Platinum (1 yr; ₱5,000 P3); award ≤ 60 days; LCRB or MEARB (price 15–40 %); direct acquisition ≤ ₱200k, SVP ≤ ₱2M; bid security 2 % cash / 5 % surety; performance 5 % / 10 %; LD 0.1 %/day, rescind at 10 %; advance ≤ 15 %; startup set-asides + Performance Securing Declaration | lawphil; GPPB IRR | P1 |
| Ease of Doing Business | 3 / 7 / 20 working days; deemed approved | RA 11032 | P1 |
| NTC | type approval per marketing model; foreign test reports at discretion; tests ≤ 15 WD; ~8-week lead (P2); fees ₱5–20k (P3) | MC 02-01-2001 | P1 / P2 / P3 |
| BPS | 111 products under mandatory PS/ICC (extension cords, LED lamps, EV chargers, appliances …) | bps.dti.gov.ph | P1 |

## 9. Philippine payments & finance ops (brief 10)

| Item | Value | Source | Grade |
|---|---|---|---|
| Corporate InstaPay / PESONet fees | still charged at most banks (BDO ₱25 InstaPay; Metrobank ₱50 PESONet, no corporate InstaPay; BPI ₱15 PESONet); Security Bank / AUB / CTBC free — July 2026 waivers are mostly individual-only | BSP fee table 31 Jul 2026 | P1 |
| InstaPay cap | ₱50,000 per transaction | hitpay (P3) | P3 |
| PayMongo | cards 3.125 % + ₱13.39 ex-VAT (≈ 3.5 % + ₱15 incl.); GCash 2.23 %; QR Ph 1.34 %; payout ₱10; settlement next business day | paymongo.com | P1 |
| Maya Business | cards 3.50 %; QR Ph 1.0 % (pricing page) vs 1.25–1.60 % (QR page) — confirm at sign-up | maya.ph | P1 (conflict) |
| PayPal PH | domestic 3.40 % + ₱15; international 4.40 % + ₱15; conversion 3.0 % | paypal.com | P1 |
| Wise Business PH | launched 10 Sep 2025; ₱1,400 one-time for local account details; USD wire 6.11 USD; 10M PHP/month cap freelancer accounts only | wise.com | P1 |
| Stripe | not available to a PH-domiciled entity (not on stripe.com/global) | stripe.com | P1 |
| BSP FX | no approval to receive FX; may hold USD or convert; corporates buy back up to USD 1M/day without documents | BSP FX FAQs Dec 2025 | P1 |
| Legal interest | 6 % p.a. from demand (BSP Circular 799; Nacar 2013); contractual rate must be in writing | lawyer-philippines.com (P2) | P2 |
| AR aging health | ≥ 80–90 % of AR in current / 1–30 days | HighRadius | P2 |
| Reserve | 1–3 months fixed opex as TWCF floor (P3); "3–6 months" **UNVERIFIED** — harness uses 3 floor / 6 target (**policy**) | — | P3 / policy |
| Bookkeeper | ₱3,000–₱15,000/month | loft.ph | P3 |
| SB Corp / DTI / DOST money | RISE UP micro ≤ ₱300k @ 12 %; SME ≤ ₱20M (collateral-free ≤ ₱3M); Business Expansion ₱50k–3M, 0 % first 12 mo then 1 %/mo, needs 3–11 mo operation + ≥ 3 mo sales; PO financing ≤ 80 % PO (≥ 1 yr + 3 POs); DTI MSME Business Fund 2026 ₱30k–20M no principal/interest year 1; DOST SETUP zero-interest, ≥ 3 yrs operation; NDC Startup Venture Fund needs a co-investment partner + ≥ 1 yr track record | sbcorp.gov.ph; philstar; dost.gov.ph; ndc.gov.ph | P1 / P2 |

## 10. Governance (brief 11)

| Item | Value | Source | Grade |
|---|---|---|---|
| Founder vesting | 4 years, 1-year cliff (25 % then 1/48 monthly); equal split default | YC | P1 |
| OKRs | 3–5 objectives, ~3 KRs each; sweet spot 0.6–0.7; 1.0 = not ambitious | Google re:Work | P1 |
| Board cadence | 4–6 meetings/year; materials 1–2 days ahead; early boards < 5 % governance | Sequoia; Blumberg | P1 / P2 |
| Advisor equity (FAST) | 0.10–1.00 % by stage; 2-year vest, 3-month cliff; ≥ 1 month / 8 h trial | Founder Institute | P1 |
| SAFE math | $500k on a $6.7M post-money cap ≈ 7.5 %; unmodified form + side letter; board approval | YC | P1 |
| Kill/pivot rows | default-dead with months_to_zero ≤ 6 ⇒ fatal-pinch ADR + hiring freeze; PMF < 40 % on n ≥ 40; pipeline coverage < 2×; OKR avg < 0.3 two quarters — thresholds beyond PG/Ellis/Google are **policy** | PG; Ellis; Google; policy | P1 / policy |
| PH VC context | $1.12B in 2024; H1 2025 $86.4M (−55 %) | Foxmont; Kickstart | P1 / P2 |
