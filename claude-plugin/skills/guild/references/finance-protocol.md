# Finance Protocol — policy triad, books, EOPT invoicing, 2307s, substantiation, AR, cash, rails, FX

Companion to `/guild:build` P9 (finance half) and to `/guild:board` cash reviews. Research basis:
brief 10 (`research/raw/10-finance-ops-payments.md`; [S#] below = its §8 source list, P1–P3
grades, all retrieved 2026-09-02), with the ₱3M statute rows shared with briefs 04/09. Gate:
`score-guild.sh ar` (this file is its contract); `cash`, `alive` and `studio` read the ledgers
defined here. **Every payment, remittance, filing and election is a human sign-off row** (§15).
Not tax advice — the CPA verifies every statute row before it is relied on; statute rows older
than 12 months re-verify.

## §0 The four money rules

1. **Accrual thinking, always.** Since EOPT, output VAT is due on the invoice ("gross sales"),
   not on collection — invoice ₱1M in a quarter and the VAT is owed even if unpaid [S26][S28].
2. **The invoice is the product of the finance system.** One missing field (VAT line, TIN,
   printed credit term) forfeits real money: the buyer's input VAT, or the studio's output-VAT
   credit on uncollected receivables [S4][S27].
3. **Withholding is not a short payment.** Clients legally pay net of EWT; the difference is an
   asset only when the Form 2307 certificate arrives. Book gross → cash net → Creditable WTax
   [S34][S35].
4. **Cash discipline is weekly.** The 13-week forecast is updated weekly against actuals with a
   pre-set minimum cash floor; collections are forecast from observed behaviour, not stated
   terms [S47][S48].

## §1 Accounting policy triad (fix once, at charter — `finance/policy.md`)

- **Fiscal year: calendar year.** SEC/BIR registration, ITR cadence and the AFS schedule key off
  it; changing the accounting period later needs BIR approval [S22].
- **Basis: accrual.** EOPT put VAT on "gross sales", aligning the accrual basis for both income
  tax and VAT [S4][S53].
- **Framework by size** (SEC): total assets or liabilities ≤ ₱3M → **income-tax basis** or PFRS
  for SEs, unaudited FS + sworn Statement of Management's Responsibility (SEC MC 4 s.2026, FYE ≥
  31 Dec 2025) [S18][S19]; ₱3M–₱100M → **PFRS for Small Entities** (MC 5-2018) [S23]; above the
  SE band → PFRS for SMEs (₱3M–₱350M assets / ₱3M–₱250M liabilities) [S24]. Switching frameworks
  restates two-year comparatives — pick deliberately [S18].
- Record VAT status with it: non-VAT below the **₱3,000,000** VAT threshold (Sec. 109(BB), CPI-
  indexed every 3 years) [S5]; the voluntary-registration lock-in and the 8 % option live in the
  pricing/compliance protocols.

## §2 Banks — TITF first, then a corporate account chosen on the corporate fee schedule

Sequence: **Treasurer-in-Trust (TITF)** account holds paid-up capital before SEC registration
(only the treasurer signs; funds locked until registration), then converts to a regular corporate
account [S55]. Standard corporate KYB pack: SEC certificate, AOI + By-Laws, latest GIS, notarized
Board Resolution / Secretary's Certificate naming signatories, BIR 2303 + TINs, Mayor's permit,
IDs per signatory [S54][S56]. Opening deposits ₱10k–₱100k, maintaining ₱25k–₱50k, 5–10 business
days (P3 ranges) [S54][S55]. Revenue collection needs the 2303 and the regular account — do not
wait for the corporate account to start selling, but do not collect into a personal wallet
either [S55].

**Pick the bank on its corporate InstaPay/PESONet schedule, not the individual one.** The July
2026 fee waivers driven by BSP Circular 1238 are largely **individual-only**; corporate transfers
still cost money at most banks (BSP disclosure table as of 31 Jul 2026) [S1][S2]:

| Bank (corporate) | PESONet | InstaPay |
|---|---|---|
| Security Bank (DigiBanker), AUB, CTBC, Philtrust | FREE | FREE |
| BPI | ₱15 | FREE |
| RCBC | ₱10 | ₱10 |
| EastWest | FREE | ₱10 |
| Landbank | ₱15 single / ₱10 bulk | ₱15 |
| PNB | ₱50 | ₱15 |
| BDO | ₱0–50 | ₱25 |
| Chinabank | ₱50 | ₱25 |
| Metrobank | ₱50 | **not offered to corporates** |
| UnionBank | ₱0–25 | ₱0–25 |

InstaPay is real-time 24/7 with a **₱50,000 per-transaction cap**; PESONet is batch (same banking
day before cut-off) with no scheme cap [S57]. Circular 1238: recipients receive the full amount;
fees must be cost-justified [S2]. Keep the chosen rows in `finance/rail_fees.csv`
(`rail fee_pct fee_fixed vat_incl settlement_days cap source retrieved`).

## §3 Books of accounts on ORUS

Register **before the deadline for the first quarterly income-tax return** (new registrants,
manual books); thereafter **loose-leaf within 15 days after FYE** (with a Permit to Use),
**computerized (CAS) within 30 days after FYE**; ORUS issues the QR stamp for the first page
[S32][S33]. The six books: General Journal, General Ledger, Sales Book, Purchase Book, Cash
Receipts Book, Cash Disbursements Book [S33]. Preserve books and records **5 years** from the day
after the return deadline (EOPT, replacing the 10-year rule) [S4]. The ₱500 annual registration
fee is abolished (22 Jan 2024) [S4]. Ledger: `books_registry.csv` (book, type, PTU no.,
registered date, next deadline); missing a books deadline invites penalties and disallowance of
the books in audit [S32][S33].

## §4 Chart of accounts (studio template, practitioner consensus)

1xxx Cash per bank/wallet (FCDU / Wise USD separately) · AR-Services / AR-Product ·
**Creditable WTax (2307)** · Input VAT · Inventory (components, WIP, finished goods) · supplier
deposits — 2xxx AP · **Output VAT** · **EWT payable** · customer deposits / deferred revenue ·
loans (SB Corp / DOST) — 3xxx equity — 4xxx Revenue-Services (per line), Revenue-Product,
Revenue-Recurring — 5xxx COGS-labour / components / fab-assembly / freight-duties — 6xxx opex
(payroll, rent, software, professional fees, bank + gateway fees, FX gain/loss). Every revenue
account carries a VAT flag; every payable account carries an EWT ATC code, so returns fall out of
the ledger instead of a spreadsheet hunt. Renumbering codes later breaks dashboard history —
an early irreversible (§16).

## §5 Invoicing under EOPT (`finance/ar_ledger.csv` + invoice template)

- Since **RR 3-2024 / RR 7-2024 (effective 27 Apr 2024) the invoice replaces the official
  receipt** as the sole document for goods **and** services [S26][S28].
- An invoice is **mandatory for every sale ≥ ₱500** (CPI-indexed) [S4][S25].
- Required information — absence kills the buyer's input VAT: amount of sales, **VAT as a
  separate line**, registered names + **TINs of both parties**, description, date [S4].
- **Print the credit term on the invoice.** It is a statutory condition of the **output-VAT
  credit on uncollected receivables** (RMC 65-2024): sale on credit after 27 Apr 2024, credit
  term lapsed, term "indicated on the invoice", sale declared in the 2550Q with VAT paid, not
  claimed as bad debt; the credit is taken **in the quarter following** the lapse and reversed on
  recovery [S27]. No printed term → the credit is forfeited for that sale.
- Authority to Print is free; the invoice series is registered — another early irreversible [S4][S27].

## §6 The 2307 / withholding workflow (`finance/wtax_2307_ledger.csv`)

**When clients pay the studio** [S34][S35][S36]:

1. Corporate clients withhold EWT at the studio's income class: professional fees — individuals
   **5 %** (gross ≤ ₱3M, with COR + sworn declaration by 15 Jan) or **10 %**; corporations
   **10 %** (≤ ₱720,000/yr per payor) or **15 %**; top withholding agents 1 % goods / 2 %
   services (P3 — verify against RR 11-2018 with the CPA).
2. Book: Dr Cash (net), Dr **Creditable WTax**, Cr AR (gross). Cash receipts are systematically
   below invoice totals — the AR ledger carries `ewt_amount` so a withheld payment is never
   mis-flagged as short.
3. The client issues **Form 2307 on or before the 20th day of the month following the end of the
   taxable quarter** [S34]. No certificate → no credit → the withheld cash is lost until
   recovered. Chase 2307s like receivables.
4. Credits attach to **1701Q/1702Q** and the annual return through **SAWT** [S34][S35].
5. Post-EOPT the client's obligation arises when the income **becomes payable** (accrual), so
   withholding can hit invoices before cash moves [S4].

**When the studio pays** suppliers/contractors it becomes the **withholding agent**: file
**0619-E monthly**, **1601-EQ quarterly**, **1604-E annually**, and issue 2307s to payees by the
20th after quarter-end [S34][S36]. Sec. 34(K) is repealed — non-withholding no longer disallows
the expense, but deficiency EWT plus penalties still applies [S4][S30].

## §7 Expense substantiation (`expense_ledger.csv` + `receipts/`)

Deductions need "sufficient evidence, such as official receipts or other adequate records"
showing the amount and the direct business connection (Sec. 34, NIRC) [S30]; receipts must be
**in the company's name** with registered name, **TIN and business address** (RMC 72-2004 — BIR
audit findings cite exactly these) [S30]; "the mere allegation of the taxpayer that an item of
expense is ordinary and necessary does not justify its deduction" (**RMC 81-2025**) [S29]. Keep
originals **5 years** — KPMG reported scanned copies failing deductibility (snippet-only,
UNVERIFIED; keep paper anyway) [S4][S61]. Ledger columns: `in_company_name` and
`has_tin_name_address` — a deductible expense row with either = N is tagged non-deductible.

## §8 AR ledger, aging, DSO, dunning (`score-guild.sh ar`, emits `AR_VIOLATIONS: N`)

`finance/ar_ledger.csv` (human-entered; brief 10 §5a): `invoice_no invoice_date client_id
client_name client_tin line_type{service,product,recurring} amount_ex_vat vat_amount gross
credit_term_days due_date ewt_rate ewt_amount expected_cash paid_date paid_amount rail rail_fee
form2307_received form2307_quarter status{open,paid,short,disputed,written_off}
demand_letter_date`.

Checks the gate runs (thresholds env-overridable, §18):

| Check | Rule | Anchor |
|---|---|---|
| Invoice fields | date, amount, separate VAT line, both names + TINs, description present | [S4] |
| ₱500 rule | any sale ≥ ₱500 carries an invoice number | [S4][S25] |
| Credit term | every VAT invoice sold on credit has `credit_term_days > 0` (printed) | [S27] |
| Short-payment classifier | `paid_amount + ewt_amount + rail_fee = gross` within ₱1, else the status must be `short` — a short payment labelled `paid` is a violation | consensus [brief 10 §5b] |
| 2307 completeness | every paid row with `ewt_amount > 0` has `form2307_received = Y` once today > quarter-end + 20 days | [S34] |
| **AR aging** | share of open AR in current / 1–30 days ≥ **80 %** (healthy books keep 80–90 % there); buckets 0–30 / 31–60 / 61–90 / 90+ | [S50] |
| Demand | any open balance > 90 days past due carries a `demand_letter_date` — the written demand starts the **6 % p.a. legal interest** clock (BSP Circular 799; *Nacar v. Gallery Frames*, 2013); a **contractual rate must be written** (Civil Code Art. 1956) or it does not exist, and unconscionable rates are struck down | [S37] |
| **DSO** | open AR ÷ trailing-90-day credit sales × 90 ≤ **45** ("a DSO below 45 is considered low"); above 60 is a violation | [S49] |

**Dunning ladder** (escalating, methodical [S51]; day counts are practitioner consensus —
UNVERIFIED as a published schedule): T-7 courtesy reminder · T0 due · T+3 reminder · T+14 firm
reminder + call · T+30 **formal demand letter** (interest clock) · T+60 suspend service /
escalate. Collections priority: largest and oldest first [S50]. Sending anything is human-gated.

## §9 13-week cash, variance, reserve (`economics/cash13.csv`, `variance.csv` — read by `cash`)

Direct-method weekly rows: opening cash, receipts (AR, new sales, other), disbursements
(payroll, rent/overhead, vendors/components, taxes, debt service, capex), net flow, closing cash,
`min_cash_floor`, actual closing, variance. The model "must be updated weekly" [S47]; forecast
collections from **historical payment patterns, not stated terms** [S48]. Set the **minimum cash
floor before building the model at 1–3 months of *fixed* operating expenses** [S48] (P3); the
common "3–6 months" reserve rule could not be anchored to a fetched source — the harness uses
**3 months floor / 6 target as policy**, labelled policy. Receipts variance over the last 4
weeks beyond 15 % triggers a re-forecast; runway = cash ÷ net monthly burn stays on the
dashboard (≥ 6 months policy floor) with cash-buffer days alongside (brief 12: median 27 days,
alarm at 13).

## §10 Payment rails (fees to the studio; PayMongo publishes ex-VAT — multiply by 1.12)

| Rail | Fee | Settlement | Notes |
|---|---|---|---|
| Corporate bank InstaPay / PESONet | §2 table | real-time / batch | ₱50k InstaPay cap [S1][S57] |
| **PayMongo** (aggregator) | cards 3.125 % + ₱13.39 **ex-VAT** (≈ 3.5 % + ₱15 incl.); intl cards 4.02 % + ₱13.39; GCash 2.23 %; Maya 1.79 %; QR Ph 1.34 %; online banking 0.71 %; payout ₱10 | "as fast as the next business day" (T+1) | KYB: BIR COR, SEC cert, By-Laws, AOI, GIS, Secretary's Certificate [S6][S7][S8] |
| **Maya Business** | cards 3.50 % (+₱10 online); Maya QR 1.50 %; **QR Ph 1.0 % on the pricing page vs 1.25 %/1.60 % on the QR page — a live conflict; confirm at sign-up**; GCash 2 % | T+1 (snippet, UNVERIFIED) | [S9][S10] |
| **GCash for Business** | 3.2 % cards / 1.0 % QR Ph (snippet; Help Center blocked) | next banking day | micro-merchant waiver history [S16][S17] |
| **PayPal PH** | domestic 3.40 % + ₱15; international 4.40 % + ₱15; **+ 3.0 % currency conversion**; withdrawal ₱50 below ₱7,000 | — | expensive default for USD [S11] |
| **Wise Business PH** | launched 10 Sep 2025, BSP-licensed; ₱1,400 one-time for local account details; local-transfer receipts free; USD wire 6.11 USD | — | **10M PHP/month receive cap applies to freelancer business accounts, not other company types** — onboard as the right entity [S12][S13][S14] |
| **Stripe** | **not available to a PH-domiciled entity** (not on stripe.com/global); third-party "3.4 % + ₱15 PH" claims are contradicted | — | [S15][S59] |

Monthly sanity: effective fee per rail (fees ÷ gross settled) vs published rate × 1.12; a
deviation > 0.3 pp gets investigated — mixing VAT-inclusive and exclusive rates in the model is
failure mode #13 [S6][S58][S59].

## §11 BSP FX rules (services exporter receiving USD)

No prior BSP approval to **receive** inward FX (banks apply KYC and may ask the purpose);
proceeds may be **sold for pesos, retained, or deposited in FX accounts (FCDU) in the Philippines
or abroad, at the resident's option** — holding USD in Wise or an FCDU account is permitted.
Buying FX back: ATP-FX form always; supporting documents only above **USD 1,000,000 per corporate
per day** for current-account purposes [S3]. Where the USD sits is an early irreversible:
conversion fees (PayPal 3 %) are sunk, and re-buying FX has paperwork [S3][S11]. VAT zero-rating
conditions for exported services were not verified this pass — Sec. 108(B) goes to the CPA.

## §12 Audit triggers and threshold watches — two independent ₱3M tests

- **Tax Code Sec. 232** (TRAIN): gross annual sales > **₱3,000,000** → books audited yearly by an
  independent, BIR-accredited CPA [S21][S22].
- **SEC MC 4 s.2026**: total assets **or** total liabilities > **₱3,000,000** → audited FS
  (previous threshold ₱600k; FYE ≥ 31 Dec 2025); at or below — unaudited FS + sworn SMR [S18][S19].
- A studio holding ₱3.5M of client deposits or equipment is audit-bound even at low sales —
  watch both tests, plus the trailing-12-month VAT threshold (> ₱3M → VAT registration task);
  open the "engage CPA" task ≥ 90 days before FYE [S18][S21].
- Filing calendar: SEC AFS within 120 calendar days of FYE (non-December FYE; December per the
  annual SEC circular), GIS within 30 days of the annual meeting, AFS attached to the annual ITR
  [S22]. EWT calendar per §6.

## §13 Dashboard KPIs (generated from ledgers, never typed)

Cash · net burn · runway months · cash-buffer days · 13-week variance · AR aging buckets + share
current/1–30 · DSO · open 2307 count and peso value · gross margin by `line_type` ·
**revenue concentration** (top client ÷ trailing-12-month revenue — a policy parameter; a single
dominant client turns one late payment into a cash event; the `studio` gate reds at 20–25 %) ·
effective rail fee per rail · audit-trigger watches (§12). Bookkeeper cost reference:
₱3,000–₱15,000/month (P3) [S42]; software: Taxumo ₱2,699–₱6,995/qtr plans, JuanTax Essentials
₱2,000/mo, Xero/QuickBooks PH pricing UNVERIFIED [S38][S39][S40][S41].

## §14 MSME financing facts (register rows, not advice)

**SB Corp RISE UP**: micro ≤ ₱300k at 12 % p.a. diminishing (≤ 3 yrs); SME first-timers ≤ ₱20M
(collateral-free ≤ ₱3M), 12 %, ≤ 5 yrs; repeat "Suki" 8–12 % (collateral-free ≤ ₱5M);
3 % processing fee [S43]. **DTI MSME Business Fund (2026)**: ₱4B facility, ₱30k–₱20M, no
collateral ≤ ₱5M, ≤ 5 yrs, **no principal or interest in year 1** (rate undisclosed at launch)
[S44]. **DOST SETUP**: zero-interest equipment/upgrading refund over ~3 years with 6–12-month
grace; needs ≥ 3 years of operation, 100 % Filipino-owned, 3 years of FS [S45][S46]. All carry
time-gates — none funds a day-zero studio; the decision to borrow is a board ADR with a signed
artifact.

## §15 Human sign-off rows

Every payment, remittance, BIR/SEC filing and election · judging "ordinary and necessary" [S29] ·
choosing the reporting framework and signing the SMR under oath [S18] · bank signatories and
accounts · write-off, demand letter, suit (interest consequences) [S37] · FX timing (hold vs
convert) [S3] · negotiating deposits and credit terms · gateway/bank KYB video verification ·
fee disputes. The `ar` gate checks artefacts and dates; it never sends a dunning e-mail.

## §16 Early irreversibles

Fiscal year (BIR approval to change) [S22] · accrual + framework (restating two-year
comparatives) [S4][S18] · VAT status and the voluntary lock-in [S5] · books format
(manual / loose-leaf PTU / CAS re-registration) [S32][S33] · invoice series with the printed
credit term (issued invoices without it forfeit the output-VAT credit) [S27] · bank choice on the
corporate fee schedule (Metrobank has no corporate InstaPay) [S1][S54] · Wise/gateway entity type
(the 10M PHP cap) [S14] · chart-of-accounts and `line_type` taxonomy (dashboard history) ·
where USD sits [S3][S11] · the first supplier payment that makes the studio a withholding agent
(0619-E/1601-EQ never stop) [S36].

## §17 Failure modes the gate and ledgers exist to catch

Cash-basis VAT thinking (output VAT accrues on invoice) [S26][S28] · no printed credit term → no
output-VAT credit [S27] · EWT accepted without collecting the 2307 by the 20th [S34] · receipts
not in the company's name / missing TIN and address → disallowance + deficiency EWT [S30] ·
"ordinary and necessary" asserted without evidence (RMC 81-2025) [S29] · missed books deadlines
(FYE + 15 / + 30) [S32] · watching only the sales threshold when the SEC ₱3M assets/liabilities
test bites first [S18][S21] · defaulting foreign receipts to PayPal at 4.40 % + 3 % conversion
when Wise receives local transfers free [S11][S12] · assuming Stripe works from a PH entity
[S15] · reading the July 2026 waivers as corporate [S1] · forecasting collections from stated
terms [S48] · charging late interest never written into the contract [S37] · mixing VAT-inclusive
and exclusive gateway rates [S6][S59] · double-dipping bad-debt deduction and the VAT credit
[S27] · scanned-only receipts [S61] · one client dominating revenue (concentration watch) ·
wrong gateway entity type capping collections [S14].

## §18 Gate surface (env overrides; defaults in brackets)

| Gate | Emits | Overrides |
|---|---|---|
| `ar <ar_ledger.csv>` | `AR_VIOLATIONS: N` | `GUILD_AR_TOLERANCE` [1] · `GUILD_INVOICE_MIN` [500] · `GUILD_VAT_RATE` [12] · `GUILD_2307_DAYS` [20] · `GUILD_AR_AGING_MIN` [80] · `GUILD_AR_DEMAND_DAYS` [90] · `GUILD_DSO_TARGET` [45] · `GUILD_DSO_MAX` [60] · `GUILD_DSO_WINDOW_DAYS` [90] |

One stdout line; every violation named on stderr with its invoice number and rule; exit 0 on
valid data, 2 on hard error. Dates compare against `GUILD_TODAY`, else the ledger's
`# as_of: YYYY-MM-DD` line, else the system date. The companion `cash13`/13-week, `alive` and
`studio` gates read the ledgers this protocol defines but ship with the economics domain.
