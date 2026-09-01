# Finance operations, accounting & payments (PH) — research brief (2026-09-02)

Scope: standing up finance ops for a small Philippine software + hardware studio — books and framework, invoicing/collections, payment rails with fees and settlement, BIR Form 2307 handling, expense substantiation, 13-week cash forecasting and reserves, dashboard KPIs, outsourcing costs, tax/accounting software, audit and AFS thresholds, bank onboarding, and government MSME financing (facts only). Every number below was read from the cited URL on 2026-09-02 unless marked **UNVERIFIED**. Provenance grades: P1 = publisher/originator (BSP, BIR, SEC-quoting firm alerts, provider's own page); P2 = reputable secondary quoting a named primary (Big-4/major firm alerts, established finance references); P3 = weak/unsourced (blogs, resellers, aggregators).

Method note: the session's 200-search budget was exhausted mid-task (shared with sibling agents); the remainder was done by direct WebFetch of known URLs and by reading four PDFs saved locally by the fetcher (BSP fee summary as of 31 Jul 2026, BSP FX FAQs Dec 2025, BSP Circular 1238 s.2026, BIR EOPT flyer). Pages that were blocked or dead (GCash Help Center 403, PwC PH 403, KPMG 404, Investopedia blocked, NetSuite 403, xero.com/ph 503, quickbooks.intuit.com/ph timeout, SEC website 403, Supreme Court e-library TLS error, FOI portal 403, and every "3–6 months reserve" and "dunning cadence" article tried — 13 URLs) are not cited for numbers. Two things the brief asked to verify could not be anchored to a fetched page and are marked as such: the "3–6 months of opex" reserve rule and a day-count dunning cadence.

---

## 1. Standard process — ordered steps and named deliverables

Assumes the entity-registration domain has already produced a DTI/SEC registration and a BIR Certificate of Registration (Form 2303). Each deliverable is the file the corresponding gate reads.

| # | Step | Deliverable | Anchor |
|---|------|-------------|--------|
| 1 | **Fix the accounting policy triad**: fiscal year (calendar year is the default a new studio should keep), accounting basis (accrual — EOPT put VAT on "gross sales", which "will align the accrual basis of accounting for both Income Tax and VAT" [S4]; SBA's definitions of cash vs accrual are the plain-language reference [S53]), and reporting framework (micro corporations ≤ ₱3M total assets or liabilities may use "income tax basis or PFRS for SEs"; ₱3M–₱100M use PFRS for Small Entities) [S18][S23]. Record VAT status (non-VAT below the ₱3,000,000 VAT threshold [S5][S4]). | `finance/policy.md` (FY, basis, framework, VAT status, signatories) | [S4][S5][S18][S23][S53] |
| 2 | **Open the bank accounts**: Treasurer-in-Trust (TITF) account for paid-up capital before SEC registration, converting to a regular corporate account after; standard corporate docs: SEC certificate, Articles + By-Laws, latest GIS, notarized Board Resolution / Secretary's Certificate naming signatories, BIR 2303 + TINs, Mayor's permit, two valid IDs per signatory [S54][S55][S56]. Pick the bank on its **corporate** InstaPay/PESONet schedule (§4), not the individual one. | `bank_accounts.csv` (bank, account type, signatory matrix, corporate fee row from [S1]) | [S1][S54][S55][S56] |
| 3 | **Register the books of accounts on ORUS**: new registrants register manual books "before the deadline for filing the initial quarterly Income Tax return or the annual Income Tax return, whichever comes earlier"; loose-leaf within 15 days after each taxable year; computerized within 30 days after each taxable year; QR stamp on first page [S32]. Loose-leaf needs a Permit to Use; the six books are General Journal, General Ledger, Sales Book, Purchase Book, Cash Receipts Book, Cash Disbursements Book [S33]. ₱500 annual registration fee is abolished [S4]. | ORUS confirmation + `books_registry.csv` (book, type, PTU no., registered date, next deadline) | [S32][S33][S4] |
| 4 | **Chart of accounts** for a services + product studio (*practitioner consensus*; structure below in §2). Every revenue account carries a VAT flag; every payable account carries an EWT flag. | `coa.csv` (code, name, type, vat_flag, ewt_atc) | consensus |
| 5 | **Invoicing set-up**: since RR 3-2024 (effective 27 Apr 2024) one **invoice** is the sole document for goods and services; official receipts are gone [S26][S28]. Mandatory invoice for transactions ≥ ₱500 [S4][S25]. Minimum information whose absence kills the buyer's input VAT: amount of sales, amount of VAT, name + TIN of both parties, description, date [S4]. **Print the credit term on the invoice** — it is a condition for the output-VAT credit on uncollected receivables [S27]. Authority to Print is free [S4]. | `invoice_template` + `ar_ledger.csv` (schema §5) | [S4][S25][S26][S27][S28] |
| 6 | **Choose payment rails per counterparty type** (peso B2B → corporate bank InstaPay ≤ ₱50k / PESONet; peso B2C → QR Ph via GCash/Maya/PayMongo; foreign → Wise Business local-details or PayPal; Stripe is not available to a PH-domiciled entity) with the fee table in §4. | `rails.md` + `rail_fees.csv` | [S1][S6][S9][S11][S12][S15] |
| 7 | **Withholding-tax (2307) workflow**: clients that are withholding agents deduct EWT and must issue Form 2307 "on or before the 20th day of the month following the end of the taxable quarter" [S34]; the studio books the receivable gross, cash net, and a "Creditable WTax" asset, and attaches the certificates to 1701Q/1702Q via SAWT [S34][S35]. | `wtax_2307_ledger.csv` | [S34][S35][S36] |
| 8 | **Expense and receipt discipline**: deductions must be substantiated with "sufficient evidence, such as official receipts or other adequate records" showing the amount and the direct connection to the business (Sec. 34, NIRC) [S30]; receipts must be in the company's name with registered name, TIN and address [S30]; "The mere allegation of the taxpayer that an item of expense is ordinary and necessary does not justify its deduction" (RMC 81-2025) [S29]. Preserve books/records for 5 years from the day after the return deadline [S4]. | `expense_ledger.csv` + `receipts/` folder policy | [S4][S29][S30][S31] |
| 9 | **13-week direct-method cash forecast**, rolled weekly with actual-vs-forecast variance and a pre-set minimum cash floor [S47][S48]. | `cash13.csv` + `variance.csv` | [S47][S48] |
| 10 | **Budget + finance dashboard** (cash, gross/net burn, runway, AR aging, DSO, gross margin, revenue concentration) generated by script from the ledgers. | `finance_dashboard.json` | [S49][S50] + consensus |
| 11 | **Compliance calendar**: EWT forms 0619-E monthly, 1601-EQ quarterly, 1604-E annual [S36]; 2307 by the 20th after quarter-end [S34]; SEC AFS for non-December fiscal years "within 120 calendar days from the fiscal year-end", December year-ends per the annual SEC circular; GIS within 30 days of the annual meeting; AFS attached to the annual ITR [S22]. | `compliance_calendar.csv` | [S22][S34][S36] |
| 12 | **Decide the outsourcing tier** (§2 table): a bookkeeper at ₱3,000–₱15,000/month [S42] or a software plan (§3) — and lock in an independent CPA once gross annual sales exceed ₱3,000,000 (Sec. 232 audit) [S21][S22] or total assets/liabilities exceed ₱3,000,000 (SEC MC 4 s.2026) [S18]. | `finance_vendors.csv` | [S18][S21][S22][S42] |
| 13 | **Financing options register** (facts, not advice): SB Corp RISE UP, DTI's 2026 MSME Business Fund, DOST SETUP (§3). | `financing_options.csv` | [S43][S44][S45][S46] |

---

## 2. Frameworks & practices

| Framework / practice | Source | What it produces | When to use |
|---|---|---|---|
| **PFRS for Small Entities** (total assets or liabilities ₱3M–₱100M, no public accountability; SEC MC 5-2018) | [S23] | Simplified GAAP financial statements a CPA can audit | Once the studio crosses ₱3M in assets or liabilities |
| **Income-tax-basis FS for micro entities** (≤ ₱3M; unaudited FS + sworn Statement of Management's Responsibility; SEC MC 4 s.2026, FYE ≥ 31 Dec 2025) | [S18][S19][S20] | Statement of Financial Position, Statement of Income, Notes, SMR under oath, two-year comparatives | Year 1–2 of a studio below ₱3M assets/liabilities |
| **PFRS for SMEs** (assets ₱3M–₱350M or liabilities ₱3M–₱250M) | [S24] P3 | Fuller framework | Not needed until the studio leaves the SE band |
| **Accrual basis** (income tax and VAT aligned on "gross sales") | [S4][S26][S53] | Revenue on invoice; output VAT due on invoice, not collection | Always, post-EOPT (RR 3-2024) |
| **Output-VAT credit on uncollected receivables** (RMC 65-2024 / RR 3-2024) | [S27][S4] | Deduction of output VAT in "the following quarter after the lapse of the credit term", reversed on recovery | Every unpaid VAT invoice whose written credit term has lapsed |
| **Chart of accounts — studio template** (*practitioner consensus*) | consensus | 1xxx Cash (per bank/wallet, FCDU/Wise USD separately) · 1xxx AR-Services / AR-Product · 1xxx Creditable WTax (2307) · 1xxx Input VAT · 1xxx Inventory (components, WIP, finished goods) · 1xxx Deposits to suppliers · 2xxx AP · 2xxx Output VAT · 2xxx EWT payable · 2xxx Customer deposits / deferred revenue · 2xxx Loans (SB Corp/DOST) · 3xxx Equity · 4xxx Revenue-Services (per line), Revenue-Product, Revenue-Support/recurring · 5xxx COGS-labour, COGS-components, COGS-fab/assembly, COGS-freight/duties · 6xxx Opex (payroll, rent, software, professional fees, bank/gateway fees, FX gain/loss) | Day one; codes align to BIR forms (VAT, EWT) and PFRS-for-SE line items |
| **13-week cash flow (TWCF), direct method** | [S47] | Weekly opening cash, receipts, disbursements, net, ending cash, borrowing need to hold a minimum cash balance; "must be updated weekly" | Always; the harness's cash gate reads it |
| **Small-business TWCF calibration**: minimum cash floor set before building the model at "one to three months of fixed operating expenses"; base/downside/stress cases; AR collections from "historical payment patterns, not stated terms" | [S48] P3 | Floor, scenarios, variance discipline | When setting the reserve gate threshold |
| **DSO** = AR ÷ net credit sales × days; "a DSO below 45 is considered low" (industry-dependent) | [S49] | Collections health metric | Monthly dashboard |
| **AR aging** buckets 0–30 / 31–60 / 61–90 / 90+ days; healthy book keeps "ideally 80–90%" of AR in current or 1–30 days | [S50] | Bad-debt estimate; collection priority (largest and oldest first) | Weekly collections run |
| **Dunning** — "methodically communicating with customers to ensure the collection of accounts receivable", escalating from gentle reminders to letters, calls and visits [S51]; a formal demand letter starts the legal-interest clock (6% p.a. from "judicial or extrajudicial demand") [S37]. Day-count cadence: *practitioner consensus*, e.g. T-7 courtesy reminder · T0 due · T+3 reminder · T+14 firm reminder + call · T+30 formal demand letter · T+60 suspend service / escalate. **UNVERIFIED** as a published schedule — no fetched source gives day counts. | [S51][S37] + consensus | Collections script | Every open invoice |
| **Late-payment clause**: contractual interest must be "expressly stipulated in writing" (Civil Code Art. 1956); absent a stipulation the legal rate is 6% p.a. (BSP Circular 799 s.2013; *Nacar v. Gallery Frames*, 2013); courts strike down unconscionable rates | [S37] | Enforceable late-fee term | Every services contract and invoice footer |
| **Deposits / milestone billing** (*practitioner consensus*): deposit before hardware component purchase; milestone invoices on acceptance; net-15/net-30 terms for corporate clients | consensus | Lower DSO, lower working-capital need | Every quote |
| **Runway** = cash ÷ net monthly burn (*standard definition*) | consensus (see sibling brief 05) | Months of survival | Dashboard |
| **Revenue concentration** = largest client revenue ÷ total revenue (trailing 12 months) — threshold is a policy parameter; no fetched source sets a number | consensus | Client-dependence flag | Dashboard |
| **Cash reserve** — the brief's "3–6 months opex" rule: **UNVERIFIED** (nine reserve-guidance URLs returned 404/403/405/timeout). Fetched anchor: 1–3 months of *fixed* opex as the TWCF floor [S48] P3 | [S48] | Reserve gate | Treat 3 months fixed opex as the floor and 6 as target, marked as policy, not sourced |

---

## 3. Numbers annex

Retrieved 2026-09-02 for every row.

### 3a. Payment rails — fees, settlement, limits

| Item | Value / threshold / fee | Context | Source URL | Grade |
|---|---|---|---|---|
| InstaPay per-transaction cap | ₱50,000 | BSP-mandated scheme cap per hitpay; real-time 24/7 | https://hitpayapp.com/blog/pesonet-vs-instapay | P3 |
| PESONet cap / timing | No scheme-wide cap (bank limits apply); batch windows 10 AM / 1 PM / 4 PM; same banking day if before bank cut-off, else next | — | same | P3 |
| BSP Circular 1238 s.2026 | Dated 17 Jun 2026 (MB Res. 498, 4 Jun 2026): fees for off-us P2P EFTs "should not materially differ from those charged for on-us P2P EFTs and any switch cost"; recipients "shall receive the full amount"; fees must be cost-justified; merchant fees "reasonable, transparent, market-based, and proportionate to the cost"; effective 15 days after publication | Drives the July 2026 fee waivers for individual accounts | https://www.bsp.gov.ph/Regulations/Issuances/2026/1238.pdf | P1 |
| Individual InstaPay/PESONet | FREE at AUB, BPI (1 Jul 2026), BDO (9 Jul), Chinabank, CTBC, EastWest, Landbank (7 Jul), Metrobank (9 Jul), PNB (10 Jul), Philtrust, RCBC, Security Bank (10 Jul), UnionBank, PSBank, Maribank, UnionDigital; Maya Bank ₱10 InstaPay; GCash (GXI) ₱10 InstaPay; PayMongo ₱10 | BSP disclosure table as of 31 Jul 2026 | https://www.bsp.gov.ph/PaymentAndSettlement/Fees.pdf | P1 |
| **Corporate** PESONet / InstaPay | AUB FREE/FREE · BPI ₱15/FREE · BDO ₱0–50/₱25 · Chinabank ₱50/₱25 · CTBC FREE/FREE · EastWest FREE/₱10 · Landbank ₱10–150 (₱15 single, ₱10 bulk via weAccess)/₱15 · Metrobank ₱50/not offered · PNB ₱50/₱15 · Philtrust FREE/FREE · RCBC ₱10/₱10 · Security Bank FREE/FREE (DigiBanker; API/proprietary-front-end clients excluded) · UnionBank ₱0–25/₱0–25 (by channel) · HSBC ₱50/₱25 · Maya Bank FREE/₱0–10 (corporate transfers free "until further notice") · Maya Philippines (EMI) FREE/₱10 · PayMongo ₱10/₱10 · Wise Pilipinas ₱35/₱35 ex-VAT | The July 2026 waivers are largely **individual-only**; corporate schedules still charge | same | P1 |
| PayMongo — cards (domestic) | 3.125% + ₱13.39 (page shows ex-VAT; hitpay confirms "exclusive of VAT"; ×1.12 = 3.5% + ₱15 VAT-inclusive, matching [S59]) | Per successful transaction | https://www.paymongo.com/pricing | P1 (VAT-inclusive figure computed) |
| PayMongo — cards (international) | 4.02% + ₱13.39 ex-VAT | — | same | P1 |
| PayMongo — e-wallets | GCash 2.23% · Maya 1.79% · GrabPay 1.96% · ShopeePay 1.70% (ex-VAT) | ×1.12 ≈ 2.5% / 2.0% / 2.2% / 1.9% | same | P1 |
| PayMongo — QR Ph / online banking / BNPL | QR Ph 1.34% · Direct online banking 0.71% or ₱13.39 · BNPL 1.34% (ex-VAT) | — | same | P1 |
| PayMongo — payouts & settlement | Payout ₱10 per InstaPay/PESONet transfer; instant settlement "Up to 2% (QR PH, Bank transfer) Up to 3% (Cards, BNPL)"; setup FREE; Storefront ₱349/mo (optional); "Settlements are as fast as the next business day"; T+1 per hitpay | — | same; https://www.paymongo.com/products/accept-payments; https://hitpayapp.com/blog/best-payment-gateway-philippines | P1 / P3 |
| PayMongo — KYB for a corporation | BIR Certificate of Registration, SEC Certificate of Incorporation, notarized By-Laws, Articles of Incorporation, latest GIS, notarized Secretary's Certificate; KYC: email/SMS, liveness, government ID, face match; statuses Activated / Under review / Pending clarification / Declined | Review time not stated | https://docs.paymongo.com/docs/account-settings-account-setup | P1 |
| Maya Business — MDR (pricing page) | Visa/Mastercard/JCB/Amex/Bancnet 3.50% (online: 3.50% + ₱10) · Maya QR 1.50% · QRPh 1.0% · GCash 2% · WeChat Pay 1.75% · ShopeePay 1.85% | Terminal, Checkout, Payment Links, Invoice, Static QR | https://www.maya.ph/business/pricing | P1 |
| Maya Business — QR Ph page | 1.25% offline (static QR, Terminal), 1.60% online (Checkout, Plugins, Invoice, Payment Links) — **inconsistent with the 1.0% on the pricing page**; treat as a range to confirm at sign-up | — | https://www.maya.ph/business/qr-ph | P1 (conflict) |
| Maya settlement | T+1 to Maya Business Deposit account — **search snippet only**, not on the fetched pages | — | (Maya site via search) | UNVERIFIED |
| GCash for Business — MDR | 3.2% cards, 1.0% QR Ph, auto-deducted per transaction; no setup/monthly MDR fee; settlement to nominated bank "by the next banking day" | GCash Help Center — **search snippet only** (direct fetch returned 403) | https://help.gcash.com/hc/en-us/articles/55684605325593 | P1 snippet / UNVERIFIED direct |
| GCash micro-merchant waiver | "the 1.5% transaction fee is waived up to P100,000 in gross sales"; wallet limit "up to P500,000 per month" | Announced 11 Sep 2023 for micro-merchants (sari-sari, market vendors, online sellers); current status not verified | https://mynt.com.ph/newsroom/gcash-waives-qr-transaction-fees-for-micro-merchants | P1 (2023, may be stale) |
| PayPal PH — receiving | Domestic commercial 3.40% + ₱15.00; international commercial 4.40% + ₱15.00 | "Last Updated: 28, May 2026" | https://www.paypal.com/ph/business/paypal-business-fees | P1 |
| PayPal PH — conversion & withdrawal | Currency conversion 3.0% on balances/transfers received, 4.0% when sending/receiving refunds; withdrawal to PH bank ₱50.00 below ₱7,000, free at ₱7,000 and above (no conversion) | — | same | P1 |
| Wise Business PH — launch | Launched 10 Sep 2025; "Licensed by the Bangko Sentral ng Pilipinas"; free to open, no minimum balance or monthly fee; 40+ currencies; receive in 24 currencies (10 via local transfers, 14 via SWIFT) | — | https://newsroom.wise.com/en-CAS/254004-wise-launches-wise-business-account-empowering-filipino-msmes-to-scale-globally-with-ease/ | P1 |
| Wise Business PH — receiving fees | One-time ₱1,400 for international account details; receiving AUD/CAD/EUR/GBP/NZD/PHP/SGD/USD by local (non-SWIFT) transfer free; USD wire 6.11 USD; GBP SWIFT 2.16 GBP; EUR SWIFT 2.39 EUR | — | https://wise.com/ph/pricing/business/receive | P1 |
| Wise PH — limits | No holding limit; receive/top-up 10,000,000 PHP per calendar month (personal and **freelancer** business accounts, "not to other company types"); 10,000 USD per conversion/transfer; 50,000 USD per calendar month; PHP→PHP 9,000,000; business card 500,000 PHP/transaction, 2.8M PHP/month | — | https://www.wise.com/help/articles/51HbmhqTgSPFGKqYfjuqOg/limits-for-your-wise-account-in-philippines | P1 |
| Stripe — Philippines | **Not listed** on Stripe's global availability page (APAC: Australia, Hong Kong, India preview, Indonesia preview, Japan, Malaysia, Singapore, Thailand) | Third-party pages claiming "3.4% + ₱15 in the Philippines" [S59] conflict with Stripe's own page; treat as unavailable to a PH entity | https://stripe.com/global | P1 |
| Xendit (for comparison) | Cards 2.9% + ₱15; e-wallets 2.5%; direct debit 1.5% + ₱20 | Blog comparison, 10 Jan 2026 | https://www.oliverrevelo.com/blog/payment-gateways-for-filipino-businesses | P3 |

### 3b. BSP foreign-exchange rules for a services exporter

| Item | Value | Context | Source URL | Grade |
|---|---|---|---|---|
| Incoming FX | "prior BSP approval/clearance is not required for receipt of incoming FX funds", subject to banks' KYC | FAQ 16 | https://www.bsp.gov.ph/Lists/Download%20Section/Attachments/118/faqfxreg.pdf (Dec 2025) | P1 |
| Disposition of FX receipts | FX receipts of residents from non-trade sources "may, at the option of said residents, be sold for pesos, retained or deposited in foreign currency accounts (whether in the Philippines or abroad)" | FAQ 27, FX Manual Sec. 1 | same | P1 |
| Buying FX without documents | Residents may buy FX for non-trade current account and trade purposes without supporting documents up to USD 500,000 (individuals) / USD 1,000,000 (corporates) per client per day; an Application to Purchase FX (ATP FX) form is required regardless of amount | FAQ 1, 3, 23 | same | P1 |
| Remittance purpose | Banks may hold/defer a remittance if the purpose is not disclosed; banks may require documents beyond the FX Manual under their KYC | FAQ 13, 17 | same | P1 |

### 3c. Tax, books, audit and reporting thresholds

| Item | Value | Context | Source URL | Grade |
|---|---|---|---|---|
| VAT threshold | ₱3,000,000 gross annual sales/receipts (Sec. 109(BB) as amended by TRAIN); EOPT indexes it to CPI every 3 years | — | https://lawphil.net/statutes/repacts/ra2017/ra_10963_2017.html ; https://bir-cdn.bir.gov.ph/BIR/pdf/flyer-eopt.pdf | P1 |
| EOPT taxpayer classes | Micro < ₱3,000,000 · Small ₱3M–< ₱20M · Medium ₱20M–< ₱1B · Large ≥ ₱1B gross sales; micro/small get a 2-page ITR, 10% civil-penalty rate, 50% interest reduction | RA 11976, effective 22 Jan 2024 | BIR flyer (above) | P1 |
| Invoice threshold | Mandatory invoice at ₱500 and above (CPI-indexed every 3 years) | — | BIR flyer; https://www.ocamposuralvo.com/2024/01/23/republic-act-no-11976-ease-of-paying-taxes-act/ | P1 / P2 |
| Invoice = sole document | VAT invoice for goods and services; RR 3-2024 effective 27 Apr 2024; unused ORs could be stamped as invoices through 31 Dec 2024 | — | https://www.grantthornton.com.ph/insights/articles-and-updates1/tax-notes/ease-of-paying-taxes-act-is-here-salient-changes-to-vat-and-percentage-tax-rules/ ; https://taxacctgcenter.ph/new-vat-rules-ease-of-paying-taxes-act-ra-11976-philippines/ | P2 |
| Withholding timing | "the obligation to deduct and withhold the tax arises at the time the income has become payable" | EOPT | BIR flyer | P1 |
| Sec. 34(K) repealed | Non-withholding is no longer a ground to disallow an expense | EOPT | BIR flyer | P1 |
| Books preservation | 5 years from the day after the return deadline (or filing date if late) | EOPT (replaces 10-year rule) | BIR flyer; taxacctgcenter (above) | P1 / P2 |
| Annual registration fee | ₱500 ARF removed | EOPT | BIR flyer | P1 |
| Output-VAT credit on uncollected receivables | Conditions: sale on credit after 27 Apr 2024; credit term lapsed; written credit term "indicated on the invoice"; sale declared in 2550Q with VAT shown; VAT paid; not claimed as bad-debt deduction; credit taken in the following quarter; reversed on recovery | RMC 65-2024 / RR 3-2024 | https://www.grantthornton.com.ph/insights/articles-and-updates1/tax-notes/eopt-is-here-bir-clarifies-availment-of-output-vat-credit-on-uncollected-receivables/ | P2 |
| EWT — professional fees | Individuals 5% (gross income ≤ ₱3M) / 10% (> ₱3M); non-individuals 10% (≤ ₱720,000) / 15% (> ₱720,000) | Two secondary sources agree; verify against RR 11-2018 §2.57.2 | https://www.hashmicro.com/ph/blog/bir-form-2307/ ; https://www.proseso-consulting.com/blog/blog-4/understanding-withholding-taxes-in-the-philippines-in-2026-1164 | P3 |
| EWT — other common rates | Rent 5%; top withholding agents 1% on goods / 2% on services; RR 24-2025 0.5% CWT on specified goods purchases; RR 5-2025 0.5% on e-marketplace remittances | — | Proseso (above) | P3 |
| Form 2307 issuance | "on or before the 20th day of the month following the end of the taxable quarter" (EWT); VAT-withholding 2307 by the 20th after each month | — | https://www.taxumo.com/blog/comprehensible-guide-bir-form-2307/ | P2 |
| Failure to issue 2307 | NIRC §255: minimum fine ₱1,000, up to ₱25,000 per year (per hashmicro) | — | hashmicro (above) | P3 |
| EWT return forms | 0619-E monthly, 1601-EQ quarterly, 1604-E annual | — | Proseso (above) | P3 |
| Books — new registrant | Manual books registered before the earlier of the initial quarterly ITR deadline or annual ITR deadline | RMC 3-2023 (ORUS) | https://www.forvismazars.com/ph/en/insights/tax-alerts/bir-rmc-03-2023 | P2 |
| Books — annual | Loose-leaf within 15 days after taxable year-end; computerized within 30 days after year-end; TY2025 extended to 31 Jan 2026 (loose-leaf) and 17 Feb 2026 (CAS) by RMC 4-2026 | — | Forvis Mazars (above); https://www.aureadalaw.com/post/bir-philippines-loose-leaf-books-binding-registration-deadlines-for-2026 | P2 / P3 |
| BIR audit (Sec. 232) | Gross annual sales/earnings/receipts/output > ₱3,000,000 → books audited yearly by an independent CPA (BOA-accredited and BIR-accredited tax agent) | TRAIN amendment | https://taxacctgcenter.ph/bir-audited-financial-statements-cpa/ ; https://philippines.acclime.com/guides/audit-requirements/ | P2 |
| SEC audit (MC 4 s.2026) | Audited FS if total assets **or** total liabilities > ₱3,000,000; at or below: unaudited FS + sworn SMR (income-tax basis or PFRS for SEs; SFP, SI, notes, 2-year comparatives); previous threshold ₱600,000; applies to FYE on/after 31 Dec 2025; Groups A/B/C and public-interest entities still audited | DOF approval letter dated 18 Nov 2025 | https://www.grantthornton.com.ph/technical-alerts/accounting-alert/2025/amendments-to-the-application-of-audit-thresholds-under-revised-src-rule-68/ ; https://tribune.net.ph/2026/01/23/sec-eases-audit-burden-on-micro-businesses | P2 |
| PFRS for SEs band | Total assets or total liabilities ₱3,000,000–₱100,000,000; no public accountability | SEC MC 5-2018 | https://taxacctgcenter.ph/pfrs-for-small-entities-a-simplified-framework-for-philippines-micro-and-small-businesses/ | P2 |
| PFRS for SMEs band | Assets ₱3M–₱350M or liabilities ₱3M–₱250M | — | https://zalamea.ph/philippine-financial-reporting-standards-pfrs-for-smes/ | P3 |
| SEC filing | Non-December FYE: AFS within 120 calendar days of FYE; December FYE: per annual SEC circular (2026 schedule **UNVERIFIED** — SEC site 403); GIS within 30 days of annual meeting; AFS attached to annual ITR | — | https://philippines.acclime.com/guides/audit-requirements/ | P2 |
| Legal interest | 6% p.a. (BSP Circular 799, effective 1 Jul 2013; *Nacar v. Gallery Frames*, 13 Aug 2013); from judicial or extrajudicial demand; contractual rate must be in writing (Art. 1956) | — | https://www.lawyer-philippines.com/articles/legal-interest-rates-in-the-philippines | P2 |
| Substantiation | Sec. 34 NIRC: "sufficient evidence, such as official receipts or other adequate records" showing amount + direct connection; RMC 72-2004: receipts "in the name of the persons whom they represent"; audit findings cite missing registered name, TIN, business address; RMC 81-2025: assertion alone does not justify deduction | — | https://www.grantthornton.com.ph/insights/articles-and-updates1/lets-talk-tax/bir-assessments-related-to-employee-reimbursements/ ; https://www.grantthornton.com.ph/insights/articles-and-updates1/lets-talk-tax/drawing-the-line-bir-clarifies-what-business-expenses-are-tax-deductible/ | P2 |
| Scanned receipts | KPMG (Aug 2023) reported scanned copies do not satisfy deductibility — **search snippet only**, page returned 404 | — | https://kpmg.com/us/en/home/insights/2023/08/tnf-philippines-scanned-copies-of-expenses-do-not-satisfy-tax-deductibility-requirements.html | UNVERIFIED |

### 3d. Software, outsourcing, banking, financing

| Item | Value | Context | Source URL | Grade |
|---|---|---|---|---|
| Taxumo plans | Free ₱0 (income/expense tracking, no filing) · 8% Plan ₱2,699/qtr (promo ₱2,499; ₱1,374/qtr-equivalent annual) — 1701Q, 1701A, 0605, 2551Q, SAWT · Micro ₱4,995/qtr (promo ₱3,248; ₱2,124/qtr on 2-yr) — adds 0619E, 1601EQ, 1604E, 1601C, 1604C, 1600-VT, QAP, MAP · SMB ₱6,995/qtr (promo ₱4,248; ₱2,749/qtr on 2-yr) — VAT individuals and partnerships/corporations: 1702Q, 1702RT, 2550Q, SLSP etc. · Accountant Buddy retainer ₱3,000/mo + subscription · Timeout ₱2,699/yr | — | https://www.taxumo.com/taxumo-subscription-plans/ | P1 |
| Juan (JuanTax / Juan Accounting) | Free ₱0 (invoicing, billing, payments; 5 admin + 5 custom users) · Essentials ₱2,000/mo (bookkeeping, bills, multi-currency, bank recon, e-invoicing, inventory, fixed assets, 10 custom users) · Growth "Let's talk" (adds CAS registration option, SSO, custom reports) | — | https://www.juan.ac/pricing | P1 |
| Xero | PH site bills in USD (search snippet); xero.com/ph returned 503 ×4. Third-party list prices conflict: Vendr (Feb 2026) Early ~$15 / Growing ~$42 / Established ~$78 per month; HireInSouth (2026) $25 / $55 / $90 | **UNVERIFIED** on Xero's own page | https://www.vendr.com/marketplace/xero ; https://www.hireinsouth.com/post/xero-pricing | P3 (conflicting) |
| QuickBooks Online PH | Page timed out ×4; only "30 days free" and a 3-month new-customer discount appeared in search snippets | **UNVERIFIED** | https://quickbooks.intuit.com/ph/pricing/ | UNVERIFIED |
| Bookkeeper / accountant cost | ₱3,000–₱15,000/month overall; freelance/home-based ₱2,500–₱5,000; small retail/service ₱5,000–₱8,000; growing SME/corporation ₱8,000–₱15,000; accounting firm ₱10,000+; drivers: volume, VAT/corporate complexity, frequency, scope, software | 17 Oct 2025 | https://loft.ph/how-much-should-you-pay-for-bookkeeping-in-the-philippines/ | P3 |
| Corporate bank account — docs | SEC certificate, AOI + By-Laws, latest GIS, notarized Board Resolution / Secretary's Certificate, BIR 2303 + TINs, Mayor's permit + barangay clearance, valid IDs of signatories | — | https://www.taxcalculator.com.ph/banking/business-bank-account-philippines ; https://www.korp.ph/blog/open-corporate-bank-account-philippines-2026-en | P3 |
| Corporate bank account — money & time | Initial deposit "often start at PHP 10,000 and can reach PHP 100,000 or more" (taxcalculator); opening ₱25,000–₱100,000, maintaining ₱25,000–₱50,000, monthly fees ₱500–₱2,000, local approval 5–10 business days (Emerhub); "a few days up to two weeks" (Korp); UnionBank Business Starter ₱5,000 / Business Check ₱100,000 | Ranges vary by bank | https://emerhub.com/philippines/open-a-business-bank-account-in-philippines/ ; taxcalculator; korp (above) | P3 |
| TITF account | Pre-SEC account for paid-up capital; funds locked until SEC registration; converts to corporate account; only the Treasurer signs | — | Emerhub (above) | P3 |
| SB Corp RISE UP | Micro up to ₱300,000, 12% p.a. diminishing, monthly up to 3 yrs · SME first-timers up to ₱20,000,000 (collateral-free up to ₱3,000,000), 12% p.a., up to 5 yrs · "Suki" repeat borrowers up to ₱20M (collateral-free up to ₱5M), 8–12% p.a. · processing fee 3% · larger loans need REM on land | — | https://sbcorp.gov.ph/riseupmultipurpose/ | P1 |
| DTI MSME Business Fund (2026) | ₱4 billion facility; loans ₱30,000–₱20,000,000; no collateral at ₱5,000,000 and below; payable up to 5 years; no principal or interest payments in the first year; via SB Corp app / DTI regional offices | Announced 10 Apr 2026 (Middle-East-crisis response); interest rate not disclosed | https://www.philstar.com/business/2026/04/10/2519816/dti-launches-p4-billion-msme-fund-amid-me-conflict | P2 |
| DOST SETUP — eligibility & docs | Filipino-owned MSME in priority sectors; funds equipment/upgrading, training, packaging/label design, database systems, standards; docs: project proposal, letter of interest "stating commitment to repay", permits, 3 years of financial statements, 5-year projections, DTI/SEC/CDA certificate, board resolution, 3 equipment quotations, technical drawings | — | https://ncr.dost.gov.ph/small-enterprise-technology-upgrading-program/ | P1 |
| DOST SETUP — refund terms | Zero interest; repayment "around three years"; 6-month to 1-year grace; at least three years in operation; 100% Filipino-owned | 11 Apr 2026 blog | https://pinoynegosyo.net/dost-setup-program-3724.html | P3 |

---

## 4. Philippine specifics

### 4a. Payment rails table

| Rail | Fees (to the studio) | Settlement | Limits | Business onboarding requirements | URL |
|---|---|---|---|---|---|
| Corporate bank → InstaPay | Corporate schedule [S1]: BPI FREE · Security Bank FREE (DigiBanker) · AUB/CTBC/Philtrust FREE · RCBC ₱10 · EastWest ₱10 · Landbank ₱15 · PNB ₱15 · BDO ₱25 · Chinabank ₱25 · UnionBank ₱0–25 · Metrobank not offered to corporates | Real-time, 24/7 [S57] | ₱50,000 per transaction [S57] | Corporate account (§3d docs) | https://www.bsp.gov.ph/PaymentAndSettlement/Fees.pdf |
| Corporate bank → PESONet | BPI ₱15 · BDO ₱0–50 · Metrobank ₱50 · PNB ₱50 · Chinabank ₱50 · Landbank ₱10–150 (₱15 single / ₱10 bulk) · RCBC ₱10 · UnionBank ₱0–25 · Security Bank/AUB/CTBC/EastWest/Philtrust FREE | Batch; same day if before cut-off, else next banking day [S57] | No scheme cap [S57] | Same | same |
| QR Ph via GCash for Business | 1.0% QR Ph, 3.2% cards (snippet) [S17] | Next banking day (snippet) | Micro-merchant waiver historically up to ₱100k gross sales [S16] | **UNVERIFIED** (Help Center blocked) | https://help.gcash.com/hc/en-us/articles/55684605325593 |
| Maya Business (QR Ph, wallet, cards, links, invoices) | QRPh 1.0% [S9] or 1.25% offline / 1.60% online [S10]; Maya QR 1.50%; cards 3.50% (+₱10 online); GCash 2%; ShopeePay 1.85%; WeChat 1.75% | T+1 to Maya Business Deposit (snippet; UNVERIFIED) | Not stated | Register on Business Manager dashboard; IDs, business permit, SEC/DTI (snippet); video-call verification | https://www.maya.ph/business/pricing |
| PayMongo (aggregator: cards, GCash, Maya, GrabPay, ShopeePay, QR Ph, online banking, BNPL) | Cards 3.125% + ₱13.39 ex-VAT (≈ 3.5% + ₱15 incl.); intl cards 4.02% + ₱13.39; GCash 2.23%; Maya 1.79%; QR Ph 1.34%; online banking 0.71% or ₱13.39; payouts ₱10; instant settlement up to 2–3% | "as fast as the next business day" [S8]; T+1 [S58] | Not stated | KYC (liveness, ID, face match) + KYB: BIR COR, SEC certificate, notarized By-Laws, AOI, latest GIS, notarized Secretary's Certificate [S7] | https://www.paymongo.com/pricing |
| PayPal Business (PH) | Domestic 3.40% + ₱15; international 4.40% + ₱15; conversion 3.0% (received balances) / 4.0% (sending); withdrawal ₱50 below ₱7,000, free at/above | Withdrawal time **UNVERIFIED** | Not stated | Not stated on fee page | https://www.paypal.com/ph/business/paypal-business-fees |
| Wise Business (PH) | ₱1,400 one-time for local account details in 10 currencies; local-transfer receipts free; USD wire 6.11 USD; GBP SWIFT 2.16; EUR SWIFT 2.39; Wise→PH bank PESONet/InstaPay ₱35 ex-VAT [S1] | Not stated | 10M PHP/month receive (freelancer business only; not other company types); 10k USD per transfer; 50k USD/month; PHP→PHP 9M | Fully digital; BSP-licensed; company eligibility beyond "MSMEs" **UNVERIFIED** | https://wise.com/ph/pricing/business/receive |
| Stripe | — | — | — | **Not available** to a PH-domiciled account per stripe.com/global | https://stripe.com/global |
| USD wire to a PH bank FCDU account | Bank fees **UNVERIFIED**; no BSP approval needed to receive; may retain in FX account, sell for pesos, or keep abroad [S3] | Bank-dependent | Purpose must be declared; bank KYC | Corporate FCDU account (bank docs) | https://www.bsp.gov.ph/Lists/Download%20Section/Attachments/118/faqfxreg.pdf |

### 4b. Withholding / Form 2307 handling in collections

1. When a corporate client pays, it withholds EWT at the rate for the studio's income class (individual professional 5%/10%; corporation professional fees 10%/15% at the ₱720,000 threshold; TWA suppliers 1% goods / 2% services) [S35][S36] P3. Book: Dr Cash (net), Dr Creditable WTax (2307), Cr AR (gross). Cash receipts will therefore be systematically **below** invoice totals; the AR ledger needs an `ewt_amount` column so "short payment" is not mis-flagged.
2. The client must issue Form 2307 "on or before the 20th day of the month following the end of the taxable quarter" [S34]; the studio claims the credit against 1701Q/1702Q and the annual return, rolled up through SAWT/QAP [S34][S35]. No certificate → no credit → the withheld cash is lost until recovered.
3. Post-EOPT the client's withholding obligation arises "at the time the income has become payable" [S4], i.e., on invoice/accrual, not on payment — expect withholding on invoices accrued in the client's books even before cash moves.
4. When the studio pays suppliers/contractors it becomes the withholding agent: file 0619-E monthly and 1601-EQ quarterly, issue 2307s by the 20th after quarter-end [S36][S34]. Non-withholding no longer disallows the expense (Sec. 34(K) repealed) [S4], but deficiency EWT plus penalties still apply [S30].

### 4c. FX rules for USD receipts (services exporter)

- No prior BSP approval to receive inward FX; banks apply KYC and will ask the purpose of the remittance and may hold it if undisclosed [S3].
- Proceeds may be sold for pesos, retained, or deposited in FX accounts in the Philippines or abroad, at the resident's option [S3] — so holding USD in Wise or a bank FCDU account is permitted.
- Buying FX back from a bank for trade/non-trade current-account purposes: ATP FX form always; supporting documents only above USD 1,000,000 per corporate per day [S3].
- VAT on exported services: zero-rating conditions were **not fetched** in this session (UNVERIFIED; check Sec. 108(B) and RR 3-2024 with the CPA).

---

## 5. Mechanical gate candidates

### 5a. Ledger schemas the harness owns

`ar_ledger.csv` — `invoice_no, invoice_date, client_id, client_name, client_tin, line_type (service|product|recurring), amount_ex_vat, vat_amount, gross, credit_term_days, due_date, ewt_rate, ewt_amount, expected_cash, paid_date, paid_amount, rail, rail_fee, form2307_received (Y/N), form2307_quarter, status (open|paid|short|disputed|written_off), demand_letter_date`

`cash13.csv` — `week_start, opening_cash, rcpt_ar, rcpt_new_sales, rcpt_other, disb_payroll, disb_rent_overhead, disb_vendors_components, disb_taxes, disb_debt_service, disb_capex, net_flow, closing_cash, min_cash_floor, actual_closing, variance` (rows per [S47][S48])

`expense_ledger.csv` — `date, vendor, vendor_tin, invoice_no, amount_ex_vat, input_vat, total, coa_code, receipt_file, in_company_name (Y/N), has_tin_name_address (Y/N), ewt_rate, ewt_withheld, paid_via, paid_date`

`wtax_2307_ledger.csv` — `quarter, client_id, invoices_covered, ewt_expected, ewt_certified, received_date, attached_to_return (Y/N)`

`books_registry.csv`, `compliance_calendar.csv`, `rail_fees.csv` (rail, fee_pct, fee_fixed, vat_incl, settlement_days, cap, source, retrieved)

### 5b. Checks a script can run (threshold · source)

| Gate | Computation | Threshold | Anchor |
|---|---|---|---|
| DSO | AR ÷ trailing-90-day credit sales × 90 | ≤ 45 days (policy default; "below 45 is considered low") | [S49] |
| AR aging health | share of open AR in current + 1–30 days | ≥ 80% (HighRadius "ideally 80–90%"); any single invoice > 90 days → FAIL until dispositioned | [S50] |
| Credit term on invoice | every VAT invoice row has `credit_term_days` > 0 and the term is printed | 100% — needed for the output-VAT credit on uncollected receivables | [S27] |
| Output-VAT credit trigger | open VAT invoices whose `due_date` + term has lapsed → list for next-quarter 2550Q deduction; recovered ones → add back | list non-empty ⇒ task for CPA (human files) | [S27][S4] |
| 2307 completeness | for every paid invoice with `ewt_amount` > 0, `form2307_received = Y` by day 20 after quarter-end | 100%; missing ⇒ dunning task to the client | [S34] |
| Short-payment classifier | `paid_amount + ewt_amount + rail_fee == gross` within ₱1 | mismatch ⇒ "short" not "paid" | consensus |
| Invoice-field completeness | amount, VAT, both names + TINs, description, date present | 100% | [S4] |
| ₱500 rule | any sale ≥ ₱500 without an invoice number | 0 | [S4][S25] |
| Receipt substantiation | expenses with `in_company_name = Y` and `has_tin_name_address = Y` and `receipt_file` present | 100% of deductible expenses; else tag "non-deductible" | [S29][S30] |
| Expense retention | receipts folder retains files for 5 years after return deadline | no deletions inside window | [S4] |
| Books deadlines | days to loose-leaf (FYE + 15) / CAS (FYE + 30) registration | warn at T-30, FAIL if past | [S32] |
| Reserve months | cash ÷ average monthly fixed opex | floor 1–3 months fixed opex [S48] P3; policy target 3 (floor) / 6 (target) months — **the 3–6 rule is UNVERIFIED** | [S48] |
| Runway | cash ÷ net monthly burn (trailing 3-month) | ≥ 6 months (policy parameter; consensus) | consensus |
| Forecast discipline | `cash13.csv` updated within 7 days; variance of closing cash vs actual | abs(variance) ≤ 10% of opening cash (policy); model "must be updated weekly" | [S47] |
| Revenue concentration | top client ÷ trailing-12-month revenue | policy parameter (no fetched source); flag when a single client > the parameter | consensus |
| Gross margin by line | (revenue − COGS) ÷ revenue per `line_type` | thresholds from the unit-economics brief (05) | sibling brief |
| Rail-fee optimiser | for each planned payout: choose cheapest rail given amount (≤ ₱50k → InstaPay if corporate fee ≤ PESONet fee) | uses `rail_fees.csv` | [S1][S57] |
| Gateway fee sanity | effective fee = fees ÷ gross settled per rail per month vs published rate ×1.12 | deviation > 0.3 pp ⇒ investigate | [S6][S58] |
| Audit-trigger watch | gross annual sales; total assets; total liabilities | any > ₱3,000,000 ⇒ open "engage CPA" task ≥ 90 days before FYE | [S21][S18] |
| VAT-threshold watch | trailing-12-month gross sales | > ₱3,000,000 ⇒ VAT registration task (human) | [S5] |
| KYB pack | corporation docs present (BIR COR, SEC cert, By-Laws, AOI, latest GIS, Secretary's Certificate) | complete before gateway/bank onboarding tasks | [S7][S54] |
| Compliance calendar | next due dates for 0619-E, 1601-EQ, 2550Q/2551Q, 1701Q/1702Q, AFS, GIS | warn T-14, FAIL if past without filing evidence | [S22][S36] |

### 5c. What cannot be mechanised (human-gated)

Every payment, remittance and BIR/SEC filing (harness rule). Judging whether an expense is "ordinary and necessary" [S29]. Choosing the reporting framework and signing the SMR under oath [S18]. Bank signatory and account decisions. Deciding to write off, sue, or send a demand letter (interest consequences) [S37]. FX timing (hold USD vs convert) [S3]. Negotiating deposits and credit terms. KYC/KYB video-call verification with gateways. Gateway/bank fee disputes.

---

## 6. Early irreversibles (fix early; expensive to reverse)

| Decision | Why it is sticky | Anchor |
|---|---|---|
| Fiscal year | Registered with SEC/BIR; books, ITR cadence and SEC AFS schedule key off it; changing the accounting period needs BIR approval (**procedure UNVERIFIED** this session — check Tax Code Sec. 46/47) | [S22] + UNVERIFIED |
| Accrual basis and framework (income-tax basis vs PFRS for SEs vs PFRS for SMEs) | EOPT already forces accrual for VAT and aligns income tax [S4]; switching frameworks later means restating comparatives (two-year comparatives are required in the micro FS) [S18] | [S4][S18] |
| VAT status | Crossing ₱3M forces VAT registration [S5]; voluntary VAT registration lock-in period **UNVERIFIED** (commonly cited 3 years — check Sec. 236(H)) | [S5] + UNVERIFIED |
| Books format (manual vs loose-leaf/PTU vs CAS) | Registered on ORUS with QR stamps; loose-leaf needs a Permit to Use; changing mid-year means re-registration and dual records | [S32][S33] |
| Invoice series and printed terms | ATP series is registered; the printed credit term is a condition of the output-VAT credit — invoices issued without it forfeit it for those sales | [S27] |
| Bank(s) | Corporate fee schedules differ materially (Metrobank offers no corporate InstaPay; BPI charges ₱15 corporate PESONet; Security Bank/AUB free) and signatory mandates are notarised documents | [S1][S54] |
| Entity type on Wise / gateways | Wise's 10M PHP monthly receive cap applies to freelancer business accounts but "not to other company types" — onboarding as the wrong type caps collections | [S14] |
| Chart of accounts and `line_type` taxonomy | Dashboard history and gross-margin gates break if codes are renumbered | consensus |
| Where USD sits (Wise / FCDU / convert) | Allowed either way [S3], but once converted, re-buying FX needs ATP forms and, above USD 1M/day, documents [S3]; conversion fees (PayPal 3%) are sunk | [S3][S11] |
| Becoming a withholding agent | First supplier/contractor payment starts monthly 0619-E and quarterly 1601-EQ obligations that never stop | [S36] |

---

## 7. Failure modes / anti-patterns the harness must guard against

1. **Cash-basis VAT thinking on services.** Since RR 3-2024 output VAT is due on the invoice ("gross sales"), not on collection; a studio that invoices ₱1M in a quarter owes the VAT even if unpaid [S26][S28]. Gate: output-VAT accrual computed from `ar_ledger` invoice dates, not `paid_date`.
2. **No credit term on the invoice** → the output-VAT credit on uncollected receivables is unavailable [S27]. Gate 5b "Credit term on invoice".
3. **Accepting withholding without collecting the 2307.** The withheld cash is only recoverable as a tax credit with the certificate [S34]; deadline is the 20th after quarter-end. Gate 5b "2307 completeness".
4. **Receipts not in the company's name / missing TIN and address** → disallowance plus deficiency EWT with penalties and interest (RMC 72-2004) [S30]. Gate 5b "Receipt substantiation".
5. **Asserting "ordinary and necessary" without evidence** → disallowed (RMC 81-2025) [S29].
6. **Missing books-of-accounts deadlines** (15 / 30 days after FYE) → penalties and "disallowance of books during BIR audits" [S32][S33].
7. **Watching only the sales threshold.** There are two independent ₱3M audit tests: Sec. 232 (gross annual sales) and SEC MC 4 s.2026 (total assets **or** liabilities) — a studio holding ₱3.5M of client deposits or equipment is audit-bound even at low sales [S21][S18].
8. **Defaulting foreign receipts to PayPal**: 4.40% + ₱15 plus 3.0% conversion versus Wise's free local-detail receipt / 6.11 USD wire [S11][S12]. Gate: rail-fee optimiser.
9. **Assuming Stripe works from a PH entity** — it is not on Stripe's availability list [S15]; third-party "3.4% + ₱15" claims [S59] are unverified.
10. **Reading the July 2026 fee waivers as corporate**: the BSP table shows most waivers are for individual clients; corporate InstaPay/PESONet still costs ₱10–₱50 at BDO, Metrobank, PNB, Chinabank, Landbank [S1].
11. **Forecasting collections from stated terms** rather than observed behaviour [S48]; building a TWCF that breaks on weekly update [S47].
12. **Charging late-payment interest that was never written into the contract** — only the 6% legal rate from demand applies, and unconscionable rates are struck down [S37].
13. **Mixing VAT-inclusive and VAT-exclusive gateway rates** in the model (PayMongo displays ex-VAT; comparison blogs quote inclusive) [S6][S58][S59]. Gate: `vat_incl` column in `rail_fees.csv`.
14. **Double-dipping bad debt and VAT credit** — the VAT component "should not have been claimed as a bad debt deduction" [S27].
15. **Keeping only scanned receipts** — KPMG reported this fails deductibility (snippet only, UNVERIFIED) [S61]; keep originals for the 5-year window [S4].
16. **Client concentration** — a single client dominating revenue turns one late payment into a cash event (*practitioner consensus*; threshold is a policy parameter).
17. **Opening the wrong Wise/gateway entity type** (freelancer vs company) and hitting the 10M PHP monthly receive cap [S14].
18. **Waiting for the corporate account to start selling** — use the TITF account for capital, but revenue collection needs the 2303 and a regular account [S55]; sequence steps 2 and 5 accordingly.

---

## 8. Sources (all retrieved 2026-09-02)

| # | Title | URL | Type | Used for |
|---|---|---|---|---|
| S1 | BSP — Summary of Transfer Fees via Digital Channels (as of 31 Jul 2026; extracted 12 Aug 2026) | https://www.bsp.gov.ph/PaymentAndSettlement/Fees.pdf | P1 regulator PDF | Individual vs corporate InstaPay/PESONet fees per bank/EMI; waiver dates |
| S2 | BSP — Circular No. 1238, Series of 2026 (17 Jun 2026) | https://www.bsp.gov.ph/Regulations/Issuances/2026/1238.pdf | P1 regulation | Off-us vs on-us pricing rule; recipients get full amount; merchant-fee principles |
| S3 | BSP — FAQs on BSP Foreign Exchange Regulations (Dec 2025) | https://www.bsp.gov.ph/Lists/Download%20Section/Attachments/118/faqfxreg.pdf | P1 regulator PDF | Incoming FX, disposition of receipts, USD 500k/1M no-document thresholds, ATP FX form |
| S4 | BIR — Salient Features of the Ease of Paying Taxes Act (RA 11976) flyer | https://bir-cdn.bir.gov.ph/BIR/pdf/flyer-eopt.pdf | P1 agency | Taxpayer classes, ₱500 invoice threshold, withholding timing, 5-year retention, ARF removal, VAT invoice, output-VAT credit |
| S5 | Lawphil — RA 10963 (TRAIN), Sec. 109(BB) | https://lawphil.net/statutes/repacts/ra2017/ra_10963_2017.html | P1 statute | ₱3,000,000 VAT threshold |
| S6 | PayMongo — Pricing | https://www.paymongo.com/pricing | P1 provider | All PayMongo rates, payout fee, instant settlement, Storefront |
| S7 | PayMongo Docs — Account setup | https://docs.paymongo.com/docs/account-settings-account-setup | P1 provider | KYC/KYB documents by entity type |
| S8 | PayMongo — Accept payments | https://www.paymongo.com/products/accept-payments | P1 provider | Settlement "as fast as the next business day"; methods |
| S9 | Maya Business — Pricing | https://www.maya.ph/business/pricing | P1 provider | MDR table |
| S10 | Maya Business — QR Ph | https://www.maya.ph/business/qr-ph | P1 provider | 1.25%/1.60% QR Ph fees (conflict with S9) |
| S11 | PayPal PH — Merchant & business fees (updated 28 May 2026) | https://www.paypal.com/ph/business/paypal-business-fees | P1 provider | Receiving, conversion, withdrawal fees |
| S12 | Wise — Business account: fees for getting paid (PH) | https://wise.com/ph/pricing/business/receive | P1 provider | ₱1,400 detail fee; wire/SWIFT receipt fees |
| S13 | Wise newsroom — Wise Business launches in the Philippines (10 Sep 2025) | https://newsroom.wise.com/en-CAS/254004-wise-launches-wise-business-account-empowering-filipino-msmes-to-scale-globally-with-ease/ | P1 provider | Launch date, BSP licence, currencies |
| S14 | Wise Help — Limits for your Wise account in the Philippines | https://www.wise.com/help/articles/51HbmhqTgSPFGKqYfjuqOg/limits-for-your-wise-account-in-philippines | P1 provider | Receive/send/card limits; freelancer vs company |
| S15 | Stripe — Global availability | https://stripe.com/global | P1 provider | Philippines not listed |
| S16 | Mynt newsroom — GCash waives QR fees for micro-merchants (11 Sep 2023) | https://mynt.com.ph/newsroom/gcash-waives-qr-transaction-fees-for-micro-merchants | P1 provider (dated) | Micro-merchant waiver, wallet limit |
| S17 | GCash Help Center — GCash for Business MDR | https://help.gcash.com/hc/en-us/articles/55684605325593-What-is-the-GCash-for-Business-Merchant-Discount-Rate-MDR | P1 (search snippet only; 403 on fetch) | 3.2% cards / 1.0% QR Ph; next-banking-day settlement |
| S18 | Grant Thornton PH — Amendments to audit thresholds under Revised SRC Rule 68 (SEC MC 4 s.2026) | https://www.grantthornton.com.ph/technical-alerts/accounting-alert/2025/amendments-to-the-application-of-audit-thresholds-under-revised-src-rule-68/ | P2 firm alert | ₱3M assets/liabilities audit test; micro filing option; effectivity |
| S19 | Daily Tribune — SEC eases audit burden on micro businesses (23 Jan 2026) | https://tribune.net.ph/2026/01/23/sec-eases-audit-burden-on-micro-businesses | P2 news | Previous ₱600k threshold; DOF letter 18 Nov 2025 |
| S20 | Aurea da Law — New SEC rule update 2026 | https://www.aureadalaw.com/post/new-sec-rule-update-2026-what-businesses-need-to-know-about-the-increased-audit-threshold | P3 | Corroboration of MC 4 s.2026 |
| S21 | Tax and Accounting Center — BIR audited financial statements, when mandatory (Sec. 232) | https://taxacctgcenter.ph/bir-audited-financial-statements-cpa/ | P2 | ₱3M gross sales audit; CPA accreditation |
| S22 | Acclime Philippines — Audit requirements | https://philippines.acclime.com/guides/audit-requirements/ | P2 | Sec. 232; SEC 120-day AFS rule; GIS 30 days; AFS with ITR |
| S23 | Tax and Accounting Center — PFRS for Small Entities | https://taxacctgcenter.ph/pfrs-for-small-entities-a-simplified-framework-for-philippines-micro-and-small-businesses/ | P2 | ₱3M–₱100M band; SEC MC 5-2018 |
| S24 | Zalamea — PFRS for SMEs in the Philippines | https://zalamea.ph/philippine-financial-reporting-standards-pfrs-for-smes/ | P3 | SMEs band ₱3M–350M / ₱3M–250M |
| S25 | Ocampo & Suralvo — RA 11976 Ease of Paying Taxes Act | https://www.ocamposuralvo.com/2024/01/23/republic-act-no-11976-ease-of-paying-taxes-act/ | P2 law firm | Classes, ₱500 invoice, withholding timing, 5-year books |
| S26 | Grant Thornton PH — EOPT salient changes to VAT and percentage tax (RR 3-2024, RR 7-2024) | https://www.grantthornton.com.ph/insights/articles-and-updates1/tax-notes/ease-of-paying-taxes-act-is-here-salient-changes-to-vat-and-percentage-tax-rules/ | P2 | Accrual VAT on services; OR→invoice; CPI indexation |
| S27 | Grant Thornton PH — BIR clarifies output VAT credit on uncollected receivables (RMC 65-2024) | https://www.grantthornton.com.ph/insights/articles-and-updates1/tax-notes/eopt-is-here-bir-clarifies-availment-of-output-vat-credit-on-uncollected-receivables/ | P2 | Credit conditions and timing |
| S28 | Tax and Accounting Center — 7 new VAT rules under RA 11976 | https://taxacctgcenter.ph/new-vat-rules-ease-of-paying-taxes-act-ra-11976-philippines/ | P2 | 27 Apr 2024 effectivity; billings basis; 5-year retention |
| S29 | Grant Thornton PH — Drawing the line: RMC 81-2025 on deductible expenses | https://www.grantthornton.com.ph/insights/articles-and-updates1/lets-talk-tax/drawing-the-line-bir-clarifies-what-business-expenses-are-tax-deductible/ | P2 | Substantiation standard |
| S30 | Grant Thornton PH — BIR assessments related to employee reimbursements | https://www.grantthornton.com.ph/insights/articles-and-updates1/lets-talk-tax/bir-assessments-related-to-employee-reimbursements/ | P2 | Sec. 34 wording; RMC 72-2004; name/TIN/address findings |
| S31 | Accountaholics PH — Requirements of deductible expense | https://accountaholicsph.com/the-requirements-of-deductible-expense-in-the-philippines/ | P3 | Requisites list |
| S32 | Forvis Mazars PH — BIR RMC 3-2023 ORUS books registration | https://www.forvismazars.com/ph/en/insights/tax-alerts/bir-rmc-03-2023 | P2 | Registration deadlines; QR stamp |
| S33 | Aurea da Law — Loose-leaf books binding & registration deadlines 2026 | https://www.aureadalaw.com/post/bir-philippines-loose-leaf-books-binding-registration-deadlines-for-2026 | P3 | RMC 4-2026 extensions; six books; PTU |
| S34 | Taxumo — Guide for BIR Form 2307 | https://www.taxumo.com/blog/comprehensible-guide-bir-form-2307/ | P2 | 2307 issuance deadlines; use in 1701Q/1702Q |
| S35 | HashMicro — BIR Form 2307 complete guide | https://www.hashmicro.com/ph/blog/bir-form-2307/ | P3 | EWT rate tiers; §255 penalty |
| S36 | Proseso Consulting — Understanding withholding taxes in the Philippines (2026) | https://www.proseso-consulting.com/blog/blog-4/understanding-withholding-taxes-in-the-philippines-in-2026-1164 | P3 | TWA 1%/2%; rent 5%; RR 24-2025 / RR 5-2025; forms |
| S37 | Respicio & Co. — Legal interest rates in the Philippines | https://www.lawyer-philippines.com/articles/legal-interest-rates-in-the-philippines | P2 | 6% legal interest; Art. 1956; demand |
| S38 | Taxumo — Subscription plans | https://www.taxumo.com/taxumo-subscription-plans/ | P1 provider | Plan prices |
| S39 | Juan Accounting — Pricing | https://www.juan.ac/pricing | P1 provider | Plan prices |
| S40 | Vendr — Xero pricing (Feb 2026) | https://www.vendr.com/marketplace/xero | P3 | Xero list prices (conflicting) |
| S41 | HireInSouth — Xero pricing 2026 | https://www.hireinsouth.com/post/xero-pricing | P3 | Xero list prices (conflicting) |
| S42 | Loft — How much should you pay for bookkeeping in the Philippines (17 Oct 2025) | https://loft.ph/how-much-should-you-pay-for-bookkeeping-in-the-philippines/ | P3 practitioner | Bookkeeping price bands |
| S43 | SB Corp — RISE UP Multi-Purpose Loan | https://sbcorp.gov.ph/riseupmultipurpose/ | P1 agency | Loan terms |
| S44 | Philstar — DTI launches ₱4-billion MSME fund (10 Apr 2026) | https://www.philstar.com/business/2026/04/10/2519816/dti-launches-p4-billion-msme-fund-amid-me-conflict | P2 news | MSME Business Fund terms |
| S45 | DOST-NCR — Small Enterprise Technology Upgrading Program | https://ncr.dost.gov.ph/small-enterprise-technology-upgrading-program/ | P1 agency | Eligibility; funded items; documents |
| S46 | Pinoy Negosyo — DOST SETUP (11 Apr 2026) | https://pinoynegosyo.net/dost-setup-program-3724.html | P3 | 0% interest, ~3 years, grace period |
| S47 | Wall Street Prep — 13-Week Cash Flow Model | https://www.wallstreetprep.com/knowledge/demystifying-the-13-week-cash-flow-model-in-excel/ | P2 | TWCF structure; weekly update rule |
| S48 | Beancount — 13-week rolling cash flow forecast for small business (9 May 2026) | https://beancount.io/blog/2026/05/09/13-week-rolling-cash-flow-forecast-direct-method-spot-cash-crunches-small-business-guide | P3 | Row structure; 1–3 months fixed-opex floor; scenarios |
| S49 | CFI — Days Sales Outstanding | https://corporatefinanceinstitute.com/resources/accounting/days-sales-outstanding/ | P2 | DSO formula; < 45 benchmark |
| S50 | HighRadius — Accounts receivable aging report | https://www.highradius.com/resources/Blog/accounts-receivable-aging-report/ | P2 | Buckets; 80–90% current rule |
| S51 | Wikipedia — Dunning (process) | https://en.wikipedia.org/wiki/Dunning_(process) | P2 | Definition; escalation |
| S52 | Chargebee — What is dunning | https://www.chargebee.com/resources/glossaries/what-is-dunning/ | P3 | "1 in 4" recovery statistic (card retries) |
| S53 | SBA — Manage your finances | https://www.sba.gov/business-guide/manage-your-business/manage-your-finances | P2 | Cash vs accrual definitions |
| S54 | TaxCalculator.com.ph — Business bank account requirements 2026 | https://www.taxcalculator.com.ph/banking/business-bank-account-philippines | P3 | Document list; deposit ranges |
| S55 | Emerhub — Open a business bank account in the Philippines | https://emerhub.com/philippines/open-a-business-bank-account-in-philippines/ | P3 | TITF mechanics; deposit/maintaining/fees; timelines |
| S56 | Korp.ph — Open a corporate bank account in the Philippines 2026 | https://www.korp.ph/blog/open-corporate-bank-account-philippines-2026-en | P3 | Document list; processing time |
| S57 | HitPay — PesoNet vs InstaPay (updated 13 Jul 2026) | https://hitpayapp.com/blog/pesonet-vs-instapay | P3 | ₱50k cap; batch windows |
| S58 | HitPay — Best payment gateway in the Philippines (13 Jul 2026) | https://hitpayapp.com/blog/best-payment-gateway-philippines | P3 | PayMongo T+1; ex-VAT confirmation |
| S59 | Oliver Revelo — Payment gateways for Filipino businesses (10 Jan 2026) | https://www.oliverrevelo.com/blog/payment-gateways-for-filipino-businesses | P3 | VAT-inclusive PayMongo rate; Xendit; Stripe claim (contradicted) |
| S60 | TechPinas — Banks with free InstaPay/PESONet per BSP (Jul 2026) | https://www.techpinas.com/2026/07/List-of-Banks-Free-InstaPay-PESONet-Transfer-Fees-BSP.html | P3 | Corroboration of S1 |
| S61 | KPMG — Scanned copies of expenses do not satisfy deductibility (Aug 2023) | https://kpmg.com/us/en/home/insights/2023/08/tnf-philippines-scanned-copies-of-expenses-do-not-satisfy-tax-deductibility-requirements.html | Search snippet only (404) | UNVERIFIED claim on scanned receipts |
