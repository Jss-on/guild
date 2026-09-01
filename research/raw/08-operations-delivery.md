# Operations & delivery — research brief (2026-09-02)

Domain: operations and delivery for a 3–10 person Philippine studio selling software + hardware engineering (projects and products). All numbers below were read from the cited URL on 2026-09-02; anything not read is marked UNVERIFIED. Provenance: P1 = regulator/statute/primary research, P2 = reputable secondary (law firm, established practitioner body, vendor summary of primary data), P3 = weak (blog, vendor marketing, news).

---

## 1. Standard process

### 1A. Professional-services delivery lifecycle (software/hardware engineering projects)

| # | Step | Named deliverable | Gate evidence (what a script can read) |
|---|------|-------------------|----------------------------------------|
| 1 | Qualify + scope | Scoping notes → draft SOW under an MSA (SOW carries commercial terms only; legal terms live in the MSA) [6] | SOW file passes completeness lint (§5) |
| 2 | Contract | Signed MSA + SOW; deposit invoice | `signed_date`, `deposit_paid_date` non-null |
| 3 | Kickoff | Kickoff record: roles, client dependencies/assumptions, comms cadence, milestone plan [6][8] | Kickoff row in delivery ledger |
| 4 | Build (sprints/milestones) | Milestone deliverable + "objective evidence of completion" per milestone [8] | Milestone row: `delivered_date`, evidence link |
| 5 | UAT / review window | Client acceptance or defect list; deemed acceptance if no response within the review window ("commonly 5 business days") [8] | `accepted_date` or `deemed_accepted_date` |
| 6 | Acceptance + milestone invoice | Acceptance record; invoice issued on acceptance, not on a calendar date [9] | `invoice_date ≥ accepted_date` |
| 7 | Handover / knowledge transfer | Source, docs, credentials, runbook, training record (practitioner consensus) | Handover checklist file complete |
| 8 | Warranty | Defect log during warranty window; 30–90 days is the typical software warranty [7]; holdback of 5–10% until warranty expiry is common [8][9] | Warranty rows closed; holdback released |
| 9 | Support/SLA (optional) | Support contract with P1–P4 targets [12][13]; monthly SLA report | SLA ledger (§5) |
| 10 | Close + retro | Project P&L: realized rate, write-offs, margin [5]; CSAT/NPS survey [15] | Close row with metrics |

Change control runs across steps 3–8: written change request → estimate within 2–5 business days → client written approval → work begins [7]. "No signature, no work. Ever." [11]

### 1B. Hardware NPI → fulfillment

| # | Stage | Purpose / exit criterion | Deliverable |
|---|-------|--------------------------|-------------|
| 1 | PRD | Requirements incl. cost target; PRD "has the highest impact on optimizing product quality, development speed, and production cost" (practitioner consensus; Bolt PRD article not fetched — UNVERIFIED) | PRD + target COGS/landed cost |
| 2 | Proto / POC | "understand risks around specific modules or designs"; ≤10 units [18] | Concept selection memo |
| 3 | EVT | "select the production intent design"; units "fully functional and testable, made from the intended materials and with the intended manufacturing process"; "up to ~40% of the units built may fail" [18]. Tests: functional, initial EMC scan, thermal, mechanical fit, battery UL review [19] | EVT report + issue list |
| 4 | DVT | "verify mass production yields with one production-worthy design" and "qualify the first hard tool for every part" [18]; reliability/abuse, regulatory (FCC/CE/RoHS), cosmetic sign-off samples, beta usability [19] | DVT report; cosmetic spec + golden samples; cert test reports |
| 5 | PVT | "verify mass production yields at mass production speeds"; "All units are intended to be sold to customers" [18]; packaging tests incl. ISTA-3A transport [19] | PVT yield report; packaging spec; work instructions |
| 6 | Regulatory | NTC type approval/acceptance if the product radiates (WiFi/BT/cellular/SRD) [32][33]; DTI-BPS PS/ICC if the product is on the mandatory list [27][28] | Certificates on file before any sale |
| 7 | MP | "units are of high enough quality to be continuously sold" [20]; "Good production runs typically have yields around 98%" [20] | Lot records + AQL results |
| 8 | Incoming QC | Attribute sampling per ANSI/ASQ Z1.4, GII, AQL 0/2.5/4.0 (critical/major/minor) [23][24] | Lot accept/reject log |
| 9 | Fulfillment | Courier contract; COD terms; delivery-time norms (§4) | Shipment ledger |
| 10 | After-sales | RMA/warranty log; RA 7394 remedies (repair/replace/refund) [38] | RMA ledger |

Unit-count expectations vary by source and by product scale: Instrumental (consumer-electronics scale) EVT 100–1,000 / DVT 300–2,000 / PVT 1K–20K [18]; Bolt EVT "typically 20 units or less", DVT "2–5x of EVT", PVT "typically 10% of first run production volume" [20]; EnCata EVT 3–50, DVT 20–200, PVT 50–500, MP from 1,000–2,000 [22]. For a Philippine studio, the Bolt/EnCata scale is the realistic one.

---

## 2. Frameworks & methods

| Framework | Originator | Produces | Use when | Critiques |
|-----------|-----------|----------|----------|-----------|
| SOW under MSA (deliverables + out-of-scope + assumptions + acceptance) | Contract practice; Contract Nerds [6] | A commercial scope document with "Any work not set forth in the scope of work section is out-of-scope work and will require a change order" | Every engagement | Over-lawyered SOWs slow sales; keep legal terms in MSA [6] |
| Engagement models: fixed-price, T&M, T&M with not-to-exceed cap, retainer | Industry practice [7] | Pricing/risk allocation; fixed price "typically 10–20% premium" [7] | Fixed price only when scope is testable; T&M/NTE for discovery | Fixed-price on vague scope = margin loss; 100% upfront or 100% at end are red flags [7] |
| Milestone billing | Practitioner guides [8][9][7] | 20–30% deposit / 40–50% across 2–3 milestones / 20–30% on acceptance; 20/30/50 for 8–12-week builds; 50/50 for tiny jobs [9]; deposits "typically range from 20% to 50%" [8] | Projects > 2 weeks | Milestones tied to dates instead of deliverables pay for nothing [9] |
| Change order discipline | PS practice [10][11] | Signed amendment with scope/cost/schedule delta; tiered approval (<$1k or 5h by email; $1k–10k simplified; >$10k full) [10] | Any deviation from SOW | Rework's "15–30% margin erosion" and "10–20% typical change value" are uncited — treat as P3 |
| PS Maturity Model (5 pillars: Leadership, Client Relationship, Talent, Service Execution, Finance & Operations; Levels 1–5; 165+ KPIs) | SPI Research [1][2] | Benchmarks for utilization, on-time delivery, margin | Setting ops KPI targets | Sample skews to larger firms (403 firms, 150k consultants) [1]; Kantata-sponsored edition is vendor-framed [3] |
| Realization rate | Accounting practice [5] | Billing realization = billed ÷ standard-rate value; collection realization = collected ÷ billed; overall = collected ÷ potential [5] | Monthly project P&L | Illustrative figures only, no benchmark [5] |
| Severity-tiered SLA (P1–P4) | ITSM practice [12][13] | Response/resolution targets per tier; escalation intervals | Any support contract | "A 24/7 P1 response target needs a 24/7 operation behind it" [13] |
| EVT/DVT/PVT stage gates | Consumer-hardware practice (Instrumental, Fictiv, Bolt) [18][19][20] | Build with defined quantity + exit criteria; "You do not move to the next stage until the current one passes its gate" | Any product intended for volume | Unit counts differ 10× across sources; pick by product scale |
| EMS RFQ package | Contract-manufacturing practice [25] | Cover letter + production start date, BOM, AVL, assembly/fab drawings, Gerbers, test, labor, packaging requirements, firmware, certifications, NRE, trade compliance [25] | Selecting a contract manufacturer | Incomplete RFQ → vague/high quotes (practitioner consensus) |
| Acceptance sampling ANSI/ASQ Z1.4 | ASQ (standard page not fetchable — 403) [23][24] | Lot size → code letter → sample n → Ac/Re | Incoming inspection of every lot | Doesn't catch systemic defects a full functional test would; pair with 100% functional test for electronics (consensus) |
| Ops manual (7 sections) | Small-business practice [17] | Company overview; org/roles; processes & SOPs; policies; vendor list; emergency procedures; financial procedures; quarterly review of 20–25% of the doc [17] | From ~3 people onward | Dies without a single named owner [17] |

---

## 3. Numbers annex

| Metric | Benchmark / threshold | Context | Source URL | Grade | Retrieved |
|--------|----------------------|---------|------------|-------|-----------|
| Billable utilization | 68.9% (2025 benchmark) | 403 PS firms; "fell" | https://www.kantata.com/resource/2025-professional-services-maturity-benchmark | P2 | 2026-09-02 |
| Utilization trend | "dropped for three straight years" | Same | https://get.kantata.com/rs/677-LEJ-696/images/2025-ps-maturity-benchmark.pdf | P2 | 2026-09-02 |
| On-time project delivery | 73.4% | "down to 73.4%" | same PDF | P2 | 2026-09-02 |
| PS EBITDA | 9.8% ("historic low") | Same | same PDF + Kantata page | P2 | 2026-09-02 |
| PS revenue growth | 4.6% | Same | Kantata page | P2 | 2026-09-02 |
| Deal pipelines | +8% | Same | same PDF | P2 | 2026-09-02 |
| Level 5 vs Level 2 firms | +433% revenue growth, +265% EBITDA, +36.4% utilization | Maturity delta | https://spiresearch.com/reports/2025-ps-maturity-benchmark/ | P1 | 2026-09-02 |
| Level 5 vs Level 1 (2024) | 739% rev growth, 537% profit margin, 71% utilization improvement | SPI scorecard | https://spiresearch.com/wp-content/uploads/2025/02/2025-PS-Maturity-Benchmark-Intro-and-Contents-Pages.pdf | P1 | 2026-09-02 |
| Sample | 403 firms, >150,000 consultants, ~$60B revenue | 2025 edition | spiresearch.com reports page | P1 | 2026-09-02 |
| PSA-tool adoption effect | +117% EBITDA, +8% utilization, +11% project margin | Vendor claim | Kantata page | P2 (vendor) | 2026-09-02 |
| Realization examples | 95.2% billing; 90% collection; 62% overall | Illustrative, not benchmark | https://www.accountingtools.com/articles/realization-rate | P2 | 2026-09-02 |
| Deposit | 20–30% (long), 20–50% range, 50/50 for ~2-week jobs | Software contracts | https://www.apptage.com/blogs/milestone-payments-software-contract/ ; https://www.horizon-labs.co/resources/milestone-based-contract-guide-key-clauses | P3 | 2026-09-02 |
| Milestone split | 20–30 / 40–50 / 20–30; or 20/30/50 | Same | Apptage; https://www.stratagem-systems.com/blog/software-development-contract-essential-terms-2026 | P3 | 2026-09-02 |
| Warranty holdback | 5–10% for 30–90 days | Same | Apptage; Horizon Labs | P3 | 2026-09-02 |
| Software warranty period | 30–90 days typical | "'As-is' delivery with no warranty" = red flag | Stratagem | P3 | 2026-09-02 |
| Review window / deemed acceptance | commonly 5 business days; Upwork 14 days | Milestone acceptance | Horizon Labs | P3 | 2026-09-02 |
| Change estimate turnaround | 2–5 business days; written approval before work | Contract clause | Stratagem | P3 | 2026-09-02 |
| Change-order tiers | <$1k/5h email; $1k–10k form; >$10k full; >25–30% of contract → rebaseline | Process guide | https://resources.rework.com/libraries/professional-services-growth/change-order-process | P3 | 2026-09-02 |
| Liability cap | 1–2× contract value (carve-outs: IP, confidentiality, wilful misconduct) | Contract clause | Stratagem | P3 | 2026-09-02 |
| Cure / convenience notice | 7–14 day cure; 30-day termination for convenience | Contract clause | Stratagem | P3 | 2026-09-02 |
| SLA P1 | respond 15 min; resolve 2–4 h | MSP practice | https://www.brocent.com/blog/posts/it-support-sla-priority-levels-p1-p2-p3-p4 | P3 | 2026-09-02 |
| SLA P2 / P3 / P4 | 30–60 min / 4–8 h; 4 h / 1–2 BD; 8 h or NBD / 3–5 BD | Same | Brocent | P3 | 2026-09-02 |
| SLA (alt.) | P1 resolution 1–4 h; P2 response 4–8 h, resolve within 24 h; P3 response within a business day | Incident practice | https://rootly.com/incident-response/support-levels | P2 | 2026-09-02 |
| 99.9% uptime allowance | 1m 26s/day; 43m 50s/month; 8h 45m 57s/year | Arithmetic | https://uptime.is/99.9 | P2 | 2026-09-02 |
| CSAT (B2B SaaS support) | median 78; P75 85; P90 90+ | Aggregated benchmarks | https://www.happysupport.ai/en/blog/csat-nps-ces-benchmarks-saas | P3 | 2026-09-02 |
| NPS (B2B SaaS) | median +36; P75 +50; P90 +65; only 3% above +70 | Same | HappySupport | P3 | 2026-09-02 |
| B2B NPS by sector | healthcare 65 (top), telecom 54 (bottom); 340 programs; top SaaS high-80s/low-90s | Survey May–Jul 2026 | https://customergauge.com/blog/b2b-nps-benchmarks-tying-revenue-to-your-experience-program | P2 | 2026-09-02 |
| Ops manual review | quarterly, 20–25% of doc per pass; first review at 6 months | Practice | https://www.whatstheprocessfor.com/blog/small-business-operations-manual | P3 | 2026-09-02 |
| EVT failure allowance | up to ~40% of units may fail | Consumer HW | https://instrumental.com/build-better-handbook/evt-dvt-pvt | P2 | 2026-09-02 |
| Build sizes (Instrumental) | Proto ≤10; EVT 100–1,000; DVT 300–2,000; PVT 1K–20K | Consumer HW scale | Instrumental | P2 | 2026-09-02 |
| Build sizes (Bolt) | EVT ≤20; DVT 2–5× EVT; PVT ≈10% of first run | Startup scale | https://blog.bolt.io/hardware-glossary/ | P2 | 2026-09-02 |
| Build sizes (EnCata) | EVT 3–50 (avg 5–12); DVT 20–200; PVT 50–500 over 3–6 months; MP from 1,000–2,000 | Agency view | https://www.encata.net/blog/overview-of-the-hardware-product-development-stages-explained-poc-evt-dvt-pvt | P3 | 2026-09-02 |
| MP yield | "around 98%" for good runs | Bolt glossary | Bolt | P2 | 2026-09-02 |
| MOQ | 5,000 units final assembly "a common number in China" | Bolt glossary | Bolt | P2 | 2026-09-02 |
| HW unit economics | $99 MSRP vs $32.16 BOM (~3.1×); dev $100k–500k over 6–9 months; ~$690k to reach 5,000 units; physical retail loses money per unit at that scale | Worked example | https://blog.bolt.io/will-your-hardware-startup-make-money-677a8e6c665b | P2 | 2026-09-02 |
| DVT build duration | "just 1–2 days" (the build itself) | Fictiv | https://www.fictiv.com/articles/pre-production-hardware-testing-methods | P2 | 2026-09-02 |
| Prototype turnaround (EMS) | 3–6 weeks median | Vendor page | https://emselectronicmanufacturingservices.com/ | P3 | 2026-09-02 |
| AQL defaults | critical 0 / major 2.5 / minor 4.0; GII default | Consumer goods | https://www.qima.com/aql-acceptable-quality-limit ; https://www.intouch-quality.com/blog/anatomy-of-the-ansi-asq-z1.4-industry-standard-aql-table | P2 | 2026-09-02 |
| AQL worked example | lot 4,000 → code L → n=200; AQL 2.5 → accept ≤10, reject ≥11 | QIMA | QIMA | P2 | 2026-09-02 |
| AQL worked example 2 | lot 300, GII → code H (n=50); at AQL 0.65 arrow → J (n=80) | InTouch | InTouch | P2 | 2026-09-02 |
| RA 7394 implied warranty | "not less than sixty (60) days nor more than one (1) year" | Art. 68(e) | https://ra7394.blogspot.com/2015/08/chapter-iii-consumer-products-and.html (mirror) | P2 | 2026-09-02 |
| RA 7394 repair window | conform within thirty (30) days, extendable for causes beyond warrantor's control; refund minus use | Art. 68(f) | same mirror | P2 | 2026-09-02 |
| RA 7394 service guaranty | workmanship + spare parts ≥ ninety (90) days, stated on invoices | Art. 71 | same mirror | P2 | 2026-09-02 |
| DAO 2 s.1993 penalties | criminal fine ₱500–₱20,000 and/or 3 months–2 years; admin ₱500–₱300,000 + up to ₱1,000/day continuing | DTI | https://www.sunstar.com.ph/cebu/local-news/dti-warns-of-penalties-for-practicing-no-return-no-exchange-policy ; https://www.oocities.org/dtiilo/cwa4.html | P3 / P2 | 2026-09-02 |
| BPS mandatory products | 111 products, 9 categories (list page); main page still says 87 | DTI-BPS | https://bps.dti.gov.ph/product-certification/list-of-products-under-mandatory-certification ; https://bps.dti.gov.ph/product-certification | P1 | 2026-09-02 |
| NTC test duration | ≤15 working days (ordinary CPE); ≤30 (PABX/large); results forwarded within 5 working days | MC 02-01-2001 §VI | https://region7.ntc.gov.ph/wp-content/uploads/2024/01/MC_02-01-2001_Revised_CPE_interface_standard.pdf | P1 | 2026-09-02 |
| NTC same-series fee | one-half of original fee if no retest needed | MC 02-01-2001 §VI.3 | same | P1 | 2026-09-02 |
| NTC lead time / validity | ~8 weeks; validity "unlimited"; local representative required | Cert consultancy | https://ib-lenhardt.com/type-approval/philippines | P2 | 2026-09-02 |
| NTC fees | ₱5,000–20,000 per model; processing 20–45 days; import without clearance: seizure + fines up to 200% of value | Law-firm commentary; UNVERIFIED against NTC | https://www.respicio.ph/commentaries/how-to-register-radio-or-telecom-equipment-with-the-ntc-in-the-philippines-1 | P3 | 2026-09-02 |
| ITA transitory period | 18 months from ITA effectivity; IRR = JAO 24-03 s.2024, issued 24 May 2024 | Baker McKenzie | https://www.globalcompliancenews.com/2024/10/22/https-insightplus-bakermckenzie-com-bm-consumer-goods-retail_1-philippines-implementing-rules-of-the-internet-transactions-act-issued_10152024/ | P2 | 2026-09-02 |
| COD share | "between 13% and 23% of Philippine e-commerce payments in 2024" | LOKAL | https://www.lkl.ai/shopify-shipping-101-a-list-of-all-delivery-couriers-in-the-philippines-you-can-integrate-to-your-store | P3 | 2026-09-02 |
| COD preference | "preferred payment method for 71% of Filipino online shoppers" (preference ≠ share) | Transportify | https://www.transportify.com.ph/ecommerce-shipping-guide/ | P3 | 2026-09-02 |
| COD fees | J&T 2.5%; Ninja Van 2.75–2.8%; Flash 2.3% (or 3%+VAT self-registered); GoGo Xpress ₱0 + fuel surcharge | Two blogs disagree on Flash | Cloud Ecommerce; LOKAL | P3 | 2026-09-02 |
| COD caps / remittance | max ₱50k (J&T), ₱30k (Ninja Van), ₱25k (Flash); remittance twice-weekly (J&T Tue/Fri, Ninja Van) or weekly (Flash) | Blog | https://www.cloudecommerce.com/blog/courier-showdown-2026-jandt-vs-ninja-van-vs-flash-express-complete-philippines-comparison/ | P3 | 2026-09-02 |
| Delivery times | Metro Manila 1–3 BD; Luzon 3–5; interisland 5–7 (Transportify); LBC: 1–2 d Luzon, 3–5 Visayas, 4–6 Mindanao, 7–9 Coron (LOKAL) | Blogs | Transportify; LOKAL | P3 | 2026-09-02 |
| Base rates | ₱60–70 Metro Manila ≤1 kg; up to ₱110 interisland; shipping ≈10–15% of order value | Blogs | Transportify; Cloud Ecommerce | P3 | 2026-09-02 |
| Next-day success (MM) | J&T 87%, Ninja Van 89%, Flash 85% | Blog, method unstated | Cloud Ecommerce | P3 | 2026-09-02 |
| COD rejection / RTS rate | UNVERIFIED — no fetched source | — | — | — | — |
| Hardware return / RMA rate benchmark | UNVERIFIED — no fetched source | — | — | — | — |
| PS license validity / ICC per-shipment validity | UNVERIFIED — BPS pages fetched do not state it | — | — | — | — |

---

## 4. Philippine specifics

**Consumer Act, RA 7394 (approved April 13, 1992 [37]).** Title III Ch. III (Arts. 66–71), read from a verbatim mirror [38] (official Gazette 403'd; LawPhil fetch truncated before Art. 66):
- Art. 68(d) minimum standards: "remedy such consumer product within a reasonable time and without charge" and "permit the consumer to elect whether to ask for a refund or replacement without charge" after a reasonable number of repair attempts.
- Art. 68(e): implied warranty of merchantability runs with an express warranty for equal duration; "Any other implied warranty shall endure not less than sixty (60) days nor more than one (1) year following the sale of new consumer products."
- Art. 68(f): on breach of express warranty the consumer elects repair or refund; repair must conform "within thirty (30) days", extendable for causes beyond the warrantor's control; refund is net of "the amount directly attributable to the use of the consumer".
- Art. 70: warranty provisions "shall not apply to professional services of certified public accountants, architects, engineers, lawyers, ..." — the studio's engineering *services* sit in this carve-out; its *products* do not. (Whether B2B sales are "consumer transactions" at all turns on the Act's definition of "consumer" — not verified in this pass; UNVERIFIED.)
- Art. 71: "Service firms shall guarantee workmanship and replacement of spare parts for a period not less than ninety (90) days which shall be indicated in the pertinent invoices." Applies to repair/service work on products.

**DTI DAO No. 2, s. 1993 (IRR of RA 7394), Title III Ch. 1 Rule 2 §7** [39][40]: "No Return, No Exchange" or "words to such effect" may not appear on receipts, contracts, or anywhere in the establishment. Remedies (replacement, refund, proportionate price reduction) attach only to "hidden faults or defects"; change-of-mind returns are not required [40]. DTI-cited penalties: criminal fine ₱500–₱20,000 and/or 3 months–2 years; administrative fines up to ₱300,000 plus up to ₱1,000/day for continuing violations [39]. Effective 1993 (exact date not in fetched text — UNVERIFIED).

**Internet Transactions Act, RA 11967 (enacted December 2023; IRR JAO 24-03 s.2024 issued 24 May 2024; 18-month transitory period from ITA effectivity) [41][42].** Online merchants must: price goods "consistent with the Consumer Act"; "Ensure proper and complete delivery"; "Issue paper or electronic invoices or receipts at all times"; "Publish sufficient information, such as trade names, address and contact information" [42]; e-marketplaces must require merchants' BIR Certificate of Registration and indicate where goods are produced [41]. Consumers "shall have the right to pursue repair, replacement, refund or other remedies" and may "return the original goods delivered without cost" when choosing replacement/refund [42]. DTI Secretary may issue takedown and blacklist orders [41][42]; all online businesses must register in the Online Business Database once established [41].

**DTI-BPS product certification [27][28][29][30][31].** "Products covered by the BPS Mandatory Product Certification Schemes, whether locally manufactured or imported, are required to bear the PS mark or ICC sticker before being distributed in the Philippine Market" [27]. PS licence = manufacturer whose "factory and product have successfully complied with the requirements of the PNS ISO 9001 and the relevant product standard/s" [29]; ICC = importer, per shipment, "through inspection and product testing by the BPS Testing Laboratory or BPS-recognized testing laboratory" [29]. The list page enumerates 111 products in 9 categories [28]; electrical items include ballasts, LED and fluorescent lamps, circuit breakers, fuses, plugs, sockets, extension cords, electrical wires, EV charging equipment, 25 household appliances, and consumer electronics (TVs, disc players, vapor products, heated tobacco). Generic IoT devices, dev boards and USB-powered gadgets are *not* on the fetched list — but check each product against [28] at design time; the main page still says 87 products, so the list is moving. PS application needs a controlled Quality Manual, process description, test-equipment list, labels/markings, factory vicinity map [30]; ICC needs packing list, invoice, B/L, valid test report, manufacturer's ISO 9001 certificate [30]. Validity/fees: UNVERIFIED (fee page 404).

**NTC type approval / type acceptance [32][33][34][35][36].** MC 02-01-2001 §I: "Type approval is a process by which a CPE is evaluated for conformance to national CPE interface standards"; "Type acceptance is a process by which a CPE may be accepted for use in the country in the absence of established interface standards"; "In cases where a CPE has already been certified by a foreign approval authority, the NTC and/or its accredited test laboratory may, at its discretion, accept manufacturer's self-declaration, foreign test reports and approval certificates in lieu of local type approval tests"; §I(c): no CPE "shall be connected to the public telecommunications network" without a certificate; §I(d): a change of trade name/model number needs a new certificate even without retest; §VI: file the NTC form with manual, specs, circuit diagram, foreign test reports, declaration of conformity, permits; tests ≤15 working days (≤30 for PABX-class); type-approved units "must be marked by a tamper proof label" produced by the supplier subject to NTC clearance [32]. Radio products: WiFi/Bluetooth/SRD devices are covered (MC 03-05-2007 on short-range devices per [33]); conformity is EU-standards based, "FCC standard can also be accepted in some cases"; local representative required; lead time ≈8 weeks; validity unlimited [33]. NTC memo of 7 Aug 2019: "The host/end product shall be Type Approved/Accepted as per specific integrated/installed RF Module" and one certificate per marketing model [34]. Importers/dealers need a Dealer's Permit first; NTC import permit and release clearance precede type approval registration [35][36]. Fees/processing days in [35] are commentary — UNVERIFIED.

**Logistics norms.** See §3 rows: COD is a minority of payments by share (13–23%) yet the stated preference of 71% of shoppers — reconcile before building a COD-heavy plan; COD costs 2.3–3% + VAT and remits weekly/twice-weekly, with ₱25k–50k caps; Metro Manila 1–3 business days, interisland 5–7 [43][44][45]. Rejection/RTS rates: UNVERIFIED.

---

## 5. Mechanical gate candidates

**5.1 SOW completeness lint** (script checks each heading exists and is non-empty; FAIL on any missing) — derived from [6][7][8]:
`msa_reference`, `scope_in`, `deliverables` (each with format), `acceptance_criteria` (per deliverable; testable), `review_window_days` (default 5) + deemed-acceptance clause, `assumptions_client_dependencies`, `out_of_scope` (with the "requires a change order" sentence), `change_control_reference`, `milestones` (id, deliverable, evidence, planned date), `payment_schedule` (each line tied to a milestone id, not a date), `deposit_pct`, `ip_ownership` (assignment on payment; background-IP carve-out), `warranty_days` (≥30 for software; ≥90 for service/repair invoices per RA 7394 Art. 71 when consumer-facing), `support_sla_reference` or "none", `key_personnel`, `termination` (cure days; convenience notice days), `liability_cap`. Extra lint: SOW must not contain "No Return, No Exchange" (also lint invoices/receipts/templates for the string).

**5.2 Delivery ledger** (`projects.csv`): `project_id, client_id, engagement_model{fixed,tm,tm_nte,retainer}, contract_value, currency, signed_date, deposit_pct, deposit_paid_date, kickoff_date, planned_end, actual_end, accepted_end_date, status`.
`milestones.csv`: `milestone_id, project_id, deliverable, acceptance_ref, planned_date, delivered_date, review_deadline, accepted_date, deemed_accepted, invoice_id, invoice_date, paid_date, amount`.
`change_orders.csv`: `co_id, project_id, requested_date, description, delta_cost, delta_days, estimate_sent_date, approved_date, signed_doc_ref, hours_logged_before_approval`.
`time.csv`: `date, person, project_id, hours, billable, standard_rate, billed_rate, billed_flag, written_off_hours`.

**5.3 SLA / ops metrics ledger** (`ops_monthly.csv`): `month, projects_closed, projects_on_time, utilization_pct, billing_realization_pct, write_off_pct, co_value_pct_of_contract, csat, nps, p1_count, p1_response_met_pct, p1_resolve_met_pct, uptime_pct, avg_days_to_invoice_after_acceptance, dso_days`.
Hardware: `lots.csv`: `lot_id, sku, supplier, lot_size, aql_level, code_letter, sample_n, critical_found, major_found, minor_found, ac_major, re_major, result`. `rma.csv`: `rma_id, order_id, sku, received_date, defect_class, remedy{repair,replace,refund}, resolved_date, days_to_resolve`. `regulatory.csv`: `sku, has_radio, ntc_status, ntc_cert_no, ntc_model_name, bps_mandatory, ps_icc_status, cert_expiry`.

**5.4 Thresholds** (B = benchmark-derived from §3; D = harness default, judgment):

| Gate | Rule | Basis |
|------|------|-------|
| Start-work | `signed_date` and `deposit_paid_date` non-null, `deposit_pct ≥ 20` before `kickoff_date` | B [8][9] |
| Milestone invoice | `invoice_date ≥ accepted_date` or `deemed_accepted` after `review_deadline` (5 BD) | B [8][9] |
| Change control | Σ `hours_logged_before_approval` = 0; any CO with `approved_date` null and hours > 0 → FAIL | B [11] |
| Rebaseline | Σ approved CO value > 25% of `contract_value` → FLAG for re-plan | B (P3) [10] |
| Utilization | rolling-3-month `utilization_pct ≥ 65` warn, target 70 (industry 68.9%) | B [4] + D |
| On-time | rolling `projects_on_time / projects_closed ≥ 0.75` (industry 73.4%) | B [3] + D |
| Realization | `billing_realization_pct ≥ 90`; `write_off_pct ≤ 5` | D (AccountingTools gives examples only) |
| Warranty legal floor | consumer product warranty text states ≥60 days; service invoices state ≥90 days workmanship guaranty; repair closure ≤30 days from claim | B (statute) [38] |
| SLA | `p1_response_met_pct ≥ 95`; if 99.9% promised, monthly downtime ≤ 43 min 50 s | D + B [14] |
| Satisfaction | `csat ≥ 78` and `nps ≥ 36` (medians) | B (P3) [15] |
| Incoming QC | every lot has a row; accept only if majors ≤ Ac at AQL 2.5 and minors ≤ Ac at AQL 4.0 and criticals = 0 | B [23][24] |
| NPI stage exit | EVT: one config passes all requirements; DVT: 100% of parts from hard tools; PVT: yield ≥ 98% at line speed | B [18][20] |
| Regulatory-ship | `has_radio` ⇒ `ntc_status = approved` and `ntc_model_name` = marketed name; `bps_mandatory` ⇒ `ps_icc_status = valid`; else block "ship" | B [32][34][27] |
| Online listing lint | listing has trade name, address, contact, price, delivery period, return/refund/warranty policy | B [41][42] |
| Ops manual | 7 sections present; `last_reviewed` ≤ 90 days | B (P3) [17] |

**5.5 Cannot be mechanized (human-gated):** signing MSA/SOW/CO; sending any invoice or client email; paying EMS/tooling deposits and issuing POs; releasing hard tooling; submitting NTC/BPS applications; declaring acceptance on the client's behalf; issuing refunds/replacements; shipping any lot; closing a warranty claim as "unreasonable use" (RA 7394 Art. 68(d) defence). The scripts can only check that the artefacts and dates exist.

---

## 6. Early irreversibles

1. **IP terms in the first MSA** — assignment "upon receipt of final payment" vs licence, and background-IP carve-outs; "If contract doesn't explicitly assign IP to you, developer may retain ownership" [7]. Renegotiating later is a client-relationship event.
2. **Engagement model on ambiguous scope** — fixed price without testable acceptance criteria locks in the margin loss [7][9].
3. **Radio architecture** — pre-certified module vs custom RF decides the NTC path (host approved per integrated module [34]) and foreign test-report acceptance [32]; also fixes the regulatory model name, which must match every marketing name [32][34].
4. **Hard tooling at DVT** — DVT is where "the first hard tool for every part" is qualified [18]; DFM before tooling or pay twice.
5. **EMS and MOQ commitment** — 5,000-unit final-assembly MOQs are common in China [20]; inventory liability lives in the RFQ terms [25].
6. **Whether the product lands on the BPS mandatory list** — design to the PNS from day one (extension cords, LED lamps, EV chargers are on it) [28].
7. **Warranty text printed on packaging/invoices** — statutory floors apply and cannot be reduced after sale [38]; "No Return, No Exchange" on any template is a violation [39][40].
8. **COD vs prepaid policy and courier contract** — remittance cadence (weekly/twice-weekly) and COD caps shape cash conversion [43][44].
9. **Channel choice** — physical retail can lose money per unit at 5,000-unit scale in Bolt's example [21].

---

## 7. Failure modes / anti-patterns

| Anti-pattern | Guard | Source |
|--------------|-------|--------|
| Work started on verbal/Slack scope change; never billed | CO gate (§5.4) | [10][11] |
| Payments tied to dates, so cash arrives whether or not work shipped | Milestone-id-linked payment schedule lint | [9] |
| "As-is", no IP clause, 100% upfront or 100% at end | SOW lint red-flag list | [7] |
| No review window → UAT never ends | `review_window_days` mandatory, deemed acceptance | [8] |
| EVT built from non-production parts/processes → false confidence | EVT gate requires intended materials + process | [18] |
| Skipping DVT tool qualification → PVT yield collapse | DVT gate: all parts hard-tooled | [18] |
| Yield below ~98% accepted as "normal" in MP | PVT/MP yield threshold | [20] |
| Incomplete RFQ → vague/high EMS quotes | RFQ package checklist lint | [25] (practitioner consensus for the causal claim) |
| Selling a WiFi/BT product before NTC certificate or under a different model name | Regulatory-ship gate | [32][34] |
| Selling a BPS-mandatory item without PS/ICC | Regulatory-ship gate | [27][31] |
| "No Return, No Exchange" on receipts/site | String lint on templates | [39][40] |
| Promising 24/7 P1 response with a 5-person team | SLA gate cross-checks staffing calendar (human review) | [13] |
| Utilization slide while founders sell and deliver → EBITDA slide | Monthly utilization gate | [3][4] |
| Assuming COD dominates because shoppers "prefer" it | Track actual COD share + fees + RTS in shipment ledger | [44][45] |
| Ops knowledge in one head; manual never reviewed | Ops manual owner + 90-day review gate | [17] |
| Consumer warranty repair dragging past 30 days | RMA `days_to_resolve` gate | [38] |

---

## 8. Sources

1. SPI Research — 2025 PS Maturity Benchmark (report page) · https://spiresearch.com/reports/2025-ps-maturity-benchmark/ · P1 · 403 firms/150k consultants/$60B; Level 5 vs 2 deltas; 165 KPIs.
2. SPI Research — 2025 Benchmark intro & contents PDF · https://spiresearch.com/wp-content/uploads/2025/02/2025-PS-Maturity-Benchmark-Intro-and-Contents-Pages.pdf · P1 · five pillars; 2024 Level 5 vs 1 deltas.
3. Kantata — 2025 SPI Benchmark sponsored PDF (foreword) · https://get.kantata.com/rs/677-LEJ-696/images/2025-ps-maturity-benchmark.pdf · P2 · EBITDA 9.8%, on-time 73.4%, utilization trend, pipeline +8% (body pages are images; not extracted).
4. Kantata — 2025 SPI Benchmark landing page · https://www.kantata.com/resource/2025-professional-services-maturity-benchmark · P2 · utilization 68.9%, growth 4.6%, PSA effects.
5. AccountingTools — Realization rate · https://www.accountingtools.com/articles/realization-rate · P2 · definitions/examples.
6. Contract Nerds — SOW template best practices · https://contractnerds.com/best-practices-for-drafting-a-statement-of-work-template/ · P2 · MSA reference, deliverables/out-of-scope, assumptions, acceptance.
7. Stratagem Systems — Software development contract essential terms (2026) · https://www.stratagem-systems.com/blog/software-development-contract-essential-terms-2026 · P3 · IP, payment split, change process, warranty 30–90 d, caps, red flags.
8. Horizon Labs — Milestone-based contract guide · https://www.horizon-labs.co/resources/milestone-based-contract-guide-key-clauses · P3 · 5-BD review window, deposits 20–50%, holdback.
9. Apptage — Milestone payments in software contracts · https://www.apptage.com/blogs/milestone-payments-software-contract/ · P3 · 20/30/50; deliverables not dates; holdback 5–10%.
10. Rework — Change order process · https://resources.rework.com/libraries/professional-services-growth/change-order-process · P3 · tiers, rebaseline at 25–30%.
11. Beancount — Change order playbook · https://beancount.io/blog/2026/04/24/change-order-template-scope-changes-service-business-guide · P3 · CO contents; "No signature, no work."
12. Rootly — Support levels P1–P3 · https://rootly.com/incident-response/support-levels · P2 · severity definitions and targets.
13. Brocent — IT support SLA priority levels · https://www.brocent.com/blog/posts/it-support-sla-priority-levels-p1-p2-p3-p4 · P3 · response/resolution table; 24/7 staffing caveat.
14. uptime.is — 99.9% · https://uptime.is/99.9 · P2 · downtime allowances.
15. HappySupport — CSAT/NPS/CES SaaS benchmarks 2026 · https://www.happysupport.ai/en/blog/csat-nps-ces-benchmarks-saas · P3 · medians/quartiles.
16. CustomerGauge — B2B NPS benchmarks (Decade Edition) · https://customergauge.com/blog/b2b-nps-benchmarks-tying-revenue-to-your-experience-program · P2 · sector figures, "above your industry median".
17. What's the Process For — Small business operations manual · https://www.whatstheprocessfor.com/blog/small-business-operations-manual · P3 · 7 sections; review cadence.
18. Instrumental — EVT/DVT/PVT stage gate definitions · https://instrumental.com/build-better-handbook/evt-dvt-pvt · P2 · purposes, quantities, exit criteria, ~40% EVT failure.
19. Fictiv — Pre-production hardware testing methods · https://www.fictiv.com/articles/pre-production-hardware-testing-methods · P2 · tests per stage; ISTA-3A; DVT build 1–2 days.
20. Bolt — Hardware glossary · https://blog.bolt.io/hardware-glossary/ · P2 · EVT ≤20, DVT 2–5×, PVT 10%, MOQ 5,000, yield ~98%, landed cost.
21. Bolt — Will your hardware startup make money · https://blog.bolt.io/will-your-hardware-startup-make-money-677a8e6c665b · P2 · worked unit economics.
22. EnCata — POC/EVT/DVT/PVT stages · https://www.encata.net/blog/overview-of-the-hardware-product-development-stages-explained-poc-evt-dvt-pvt · P3 · startup-scale quantities/durations.
23. QIMA — AQL · https://www.qima.com/aql-acceptable-quality-limit · P2 · AQL defaults, worked example.
24. InTouch Quality — Reading the Z1.4 AQL table · https://www.intouch-quality.com/blog/anatomy-of-the-ansi-asq-z1.4-industry-standard-aql-table · P2 · table mechanics; 0/2.5/4 recommendation.
25. Mark Zetter — RFQ checklist for OEM electronics programs · https://www.markzetter.com/checklist-for-oem-electronics-program-rfq-in-contract-electronics-manufacturing/ · P3 · RFQ package item list.
26. PCBSync — EMS guide · https://emselectronicmanufacturingservices.com/ · P3 · 3–6 wk prototype turnaround (vendor).
27. DTI-BPS — PS and ICC Marks · https://bps.dti.gov.ph/product-certification/ps-and-icc-marks · P1 · mandatory-mark rule; verification.
28. DTI-BPS — List of products under mandatory certification · https://bps.dti.gov.ph/product-certification/list-of-products-under-mandatory-certification · P1 · 111 products / 9 categories.
29. DTI-BPS — Product certification schemes · https://bps.dti.gov.ph/product-certification · P1 · PS vs ICC definitions; "87 products" legacy count.
30. DTI-BPS — PS and ICC application requirements · https://bps.dti.gov.ph/product-certification/ps-and-icc-application-requirements · P1 · document lists.
31. DTI e-Sigaw — Product standards · https://esigaw.dti.gov.ph/e-sigaw-services/e-konsyumer-corner/consumer-info-hub/product-standards/ · P1 · PS = local, ICC = imported; retailer duty.
32. NTC — Memorandum Circular 02-01-2001 (PDF via NTC Region 7) · https://region7.ntc.gov.ph/wp-content/uploads/2024/01/MC_02-01-2001_Revised_CPE_interface_standard.pdf · P1 · type approval vs acceptance; foreign reports; documents; test durations; labels; new-model rule.
33. IB-Lenhardt — NTC type approval Philippines · https://ib-lenhardt.com/type-approval/philippines · P2 · scope, local rep, 8 weeks, unlimited validity, MC 03-05-2007.
34. Bureau Veritas CPS — NTC memorandum on integrated RF modules (7 Aug 2019) · https://www.cps.bureauveritas.com/newsroom/philippines-ntc-issued-memorandum-regarding-type-approvalacceptance-equipment-based · P2 · host approved per module; certificate per marketing model.
35. Respicio & Co. — Registering radio/telecom equipment with the NTC · https://www.respicio.ph/commentaries/how-to-register-radio-or-telecom-equipment-with-the-ntc-in-the-philippines-1 · P3 · dealer's permit, RA 3846/EO 546; fees/timelines UNVERIFIED.
36. Andaman Medical — NTC rules for wireless medical devices · https://www.andamanmed.com/ntc/ · P3 · import permit, release clearance, document list, registration number.
37. LawPhil — RA 7394 · https://lawphil.net/statutes/repacts/ra1992/ra_7394_1992.html · P1 · approval date 13 Apr 1992; Arts. 50/52 (warranty chapter beyond fetch truncation).
38. RA 7394 Chapter III mirror · https://ra7394.blogspot.com/2015/08/chapter-iii-consumer-products-and.html · P2 (unofficial verbatim) · Arts. 68(d)(e)(f), 70, 71.
39. SunStar Cebu — DTI warns on "no return, no exchange" (7 Nov 2022) · https://www.sunstar.com.ph/cebu/local-news/dti-warns-of-penalties-for-practicing-no-return-no-exchange-policy · P3 · DAO 2 s.1993 citation; penalties.
40. DTI Iloilo (archived) — Consumer welfare, No Return No Exchange · https://www.oocities.org/dtiilo/cwa4.html · P2 · defects-only scope; 3 remedies; penalties.
41. Baker McKenzie via Global Compliance News — ITA IRR issued · https://www.globalcompliancenews.com/2024/10/22/https-insightplus-bakermckenzie-com-bm-consumer-goods-retail_1-philippines-implementing-rules-of-the-internet-transactions-act-issued_10152024/ · P2 · JAO 24-03; 18-month transitory; OBD; DTI powers.
42. Cruz Marcelo — ITA primer · https://cruzmarcelo.com/navigating-the-internet-transactions-act-r-a-no-11967-a-primer-on-opportunities-and-risks-for-digital-economy-players/ · P2 · merchant/e-marketplace obligations; consumer remedies.
43. Cloud Ecommerce — Courier showdown 2026 (2 Mar 2026) · https://www.cloudecommerce.com/blog/courier-showdown-2026-jandt-vs-ninja-van-vs-flash-express-complete-philippines-comparison/ · P3 · COD fees/caps/remittance, rates, next-day rates.
44. LOKAL — Shopify shipping in the Philippines (17 Jun 2026) · https://www.lkl.ai/shopify-shipping-101-a-list-of-all-delivery-couriers-in-the-philippines-you-can-integrate-to-your-store · P3 · COD 13–23% of payments (2024); courier fees; LBC transit days.
45. Transportify — E-commerce shipping guide (21 Jul 2026) · https://www.transportify.com.ph/ecommerce-shipping-guide/ · P3 · 71% COD preference; transit days; shipping 10–15% of order value.

Not usable (fetched but blocked/empty): Official Gazette RA 7394 (403), ASQ Z1.4 page (403), ntc.gov.ph (403), jur.ph DAO 93-02 summary (429), jlp-law (429), SC e-library RA 11967 (TLS error), BPS fee schedule (404), VentureOutsource RFQ pages (landing pages only).
