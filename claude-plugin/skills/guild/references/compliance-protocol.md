# Compliance Protocol — the register, the deadline engine, and the Philippine zero-to-operating path

Companion to `/guild:build` P10 and to every command that touches `compliance/`. The compliance
analogue of the evidence gate: a venture whose registrations, returns and remittances are not
evidenced and on time is not `OPEN_FOR_BUSINESS`, however good the deck. Research basis: brief 09
(`research/raw/09-ph-legal-compliance.md`, primary), brief 10 §1/§3c (finance calendar and
thresholds) and brief 04 §4 (VAT / 8 % / CWT mechanics), all retrieved **2026-09-02**.

**Disclaimer.** This protocol is research for a register a human maintains. It is **not legal
advice, not tax advice and not financial advice**. Every filing, election, remittance and
signature stays human-gated: the loop drafts checklist rows and surfaces deadlines; a Philippine
accountant (CPA) or lawyer confirms the rule and a named human performs the act. Amounts and dates
below are only those read from the cited source on 2026-09-02; anything not read from a source is
marked **UNVERIFIED** and is a prompt, not a threshold. This domain moved in 2018 (TRAIN, RA
11032, OSH), 2021 (CREATE, RA 11595), 2024 (EOPT, RR 7-2024, CREATE MORE), 2025 (SSS final
tranche) and 2026 (SEC MC 4) — **re-verify any row whose `verified_on` is older than 12 months.**

Sources are cited `[S#]` (brief 09 numbering), `[10:S#]` (brief 10) and `[04:S#]` (brief 04);
the table in §16 resolves them. Grades: **A** official primary text · **B** Big-4 / major PH firm
· **C** reputable knowledge base · **S** search-snippet only (treat as UNVERIFIED).

## §0 The four rules

1. **Rows, not rulings.** The register holds obligations as data — statute number, effective
   date, deadline_rule, source, grade, `verified_on` — never interpretations. Where the brief
   could not fetch the primary text (LGC §167, RCC §177, NPC Circular 2022-04, OSHS Rule 1020),
   the row carries grade `S` or an UNVERIFIED note and cannot be marked `done` without `notes`
   recording the human verification.
2. **Evidence is a document with a hash and a date.** A row is `done` only when `evidence_path`
   resolves to a non-empty file, `evidence_hash` is a 16–64-hex sha256 prefix that matches that
   file, and `evidence_date` is on or before the computed deadline. "We filed it" is not evidence;
   the filed return, receipt or certificate is.
3. **Professional sign-off rows never loop-pass.** Entity choice, VAT / 8 % elections, every tax
   return, the audit opinion, employment-vs-contractor classification, contracts and IP
   assignments carry `requires_professional_signoff=true`; such a row counts only when
   `signoff_path` resolves to the signed artefact a human filed. The loop may prepare drafts and
   surface the row; it may never mark its own sign-off.
4. **Statute rows expire.** `verified_on` older than 12 months → the gate prints `RE-VERIFY` and
   the protocol demands a fresh read of the source before the row is relied on.

## §1 `compliance/profile.yaml` — the company profile

The register is generic; the profile makes it yours. `applies_if` expressions are evaluated
against these fields (plus any extra keys the venture adds — an expression naming a field the
profile does not define **fails closed**: the row is treated as applicable-and-failed until the
profile or the expression is fixed).

| Field | Type | Meaning |
|---|---|---|
| `entity_type` | `sole_prop\|opc\|corp\|partnership` | legal form (early irreversible — see §14) |
| `has_employees` | bool | true from the **first hire**; activates every §8 row |
| `first_hire_date` | date or null | anchor for `hire_date+Nd` rules and the trigger for `category=employer` rows |
| `gross_sales_12m` | number | trailing-12-month gross sales (₱); crossing 3,000,000 forces VAT and the audit row |
| `vat_registered` | bool | VAT posture; drives 2550Q vs 2551Q consistency |
| `eight_pct_elected` | bool | the 8 % option (individuals only, non-VAT) |
| `sells_online` | bool | first online sale activates the Internet Transactions Act rows |
| `foreign_equity` | number | % foreign ownership; > 0 activates FIA capitalisation rows |
| `total_assets` / `total_liabilities` | number | SEC audit test (MC 4 s.2026) and BMBE ceiling |
| `fiscal_year_end` | `MM-DD` or `Mon-DD` | anchor for `fye+Nd` and `@fye` rules |
| `registration_date` | date | commencement of business per the BIR COR — anchor for `once` / `registration+Nd` and the default trigger |

Optional extension fields the seed register references: `employee_count`, `spi_records` (count of
individuals whose sensitive personal information is held), `withholding_agent`, `bmbe_elected`,
`books_method` (`manual\|loose_leaf\|cas`), `sells_consumer_products`, `trademark_filed`. Extra
keys are legal; referencing an absent key is not.

## §2 `compliance/register.csv` — 19 columns (validator: `score-guild.sh compliance`)

```
id, obligation, category, applies_if, agency, cadence, deadline_rule, evidence_type,
evidence_path, evidence_date, evidence_hash, status, owner, requires_professional_signoff,
signoff_path, source_url, source_grade, verified_on, notes
```

- `id` unique, stable (e.g. `BIR-2550Q`); the consistency rules in §12 find rows by keyword in
  `id + obligation + agency`, so keep the form number or agency name in one of them.
- `category` `formation|lgu|bir|tax|employer|privacy|ecommerce|consumer|ip|contracts` — rows in
  `employer` are triggered by `first_hire_date`; all others by `registration_date`.
- `applies_if` boolean expression over the profile (§3); empty = always applies.
- `cadence` `once|monthly|quarterly|annual|event` (descriptive; the deadline engine derives
  periodicity from `deadline_rule`).
- `deadline_rule` per the grammar in §4.
- `evidence_type` `filed_return|receipt|certificate|contract|register` — what the document is.
- `evidence_path` relative to the register's directory; `evidence_date` the date on the document;
  `evidence_hash` 16–64 hex of `sha256sum <file>` — the mechanical proof the document existed
  with this content (rule 2). Humans place the documents; the loop only verifies.
- `status` `na|pending|done|overdue` — human-maintained; the gate recomputes and flags drift
  (`na` on an applicable row is a failure; `done` without resolving evidence is a failure).
- `requires_professional_signoff` true|false; `signoff_path` the signed CPA / lawyer artefact.
- `source_url` + `source_grade` (A|B|C|S) + `verified_on` on **every** row (rules 1 and 4).
- `notes` free text; required when `source_grade=S`; the keyword `late` records a settled late
  filing so a single-deadline row can count again (§4).

Ledger discipline (SKILL.md): the register's evidence documents and sign-offs are human-entered;
the loop writes candidate checklist rows and never marks a sign-off row `pass`.

## §3 `applies_if` — the expression grammar

```
expr   := or                          or   := and ( "or" and )*
and    := not ( "and" not )*          not  := "not" not | cmp
cmp    := atom [ op atom ]            op   := == | != | > | >= | < | <= | =   (= aliases ==)
atom   := "(" expr ")" | number | string | true | false | null | field
number := digits with optional _ separators and decimal (3_000_000 == 3000000)
string := single- or double-quoted ('corp' or "corp")
field  := a key of compliance/profile.yaml
```

Semantics: `and`/`or`/`not` demand booleans; `==`/`!=` compare like types (mixed types are simply
unequal); ordered comparison needs two numbers or two strings (ISO dates compare correctly as
strings). Evaluation is a tokenizer plus recursive descent inside the gate — register text is
**never** eval-ed. Errors (unknown field, type clash, stray token) fail closed: the row scores as
applicable-but-failed with the parse error on stderr.

Examples from the seed register:

```
entity_type == 'sole_prop'
entity_type == 'opc' or entity_type == 'corp'
not vat_registered and not eight_pct_elected
gross_sales_12m > 3000000 or total_assets > 3000000 or total_liabilities > 3000000
(entity_type == 'sole_prop' and gross_sales_12m <= 3000000 and not vat_registered)
  or ((entity_type == 'corp' or entity_type == 'opc') and gross_sales_12m <= 720000)
employee_count >= 250 or spi_records >= 1000
```

Profile changes activate rows mechanically: the **first hire** flips `has_employees`, trailing
gross crossing ₱3,000,000 flips the audit and VAT rows, the first online sale flips
`sells_online`, a foreign investor flips `foreign_equity > 0`.

## §4 `deadline_rule` — grammar and the deadline engine

```
deadline_rule := "once"                          due at the trigger date itself (register before operating)
              | YYYY-MM-DD                       one absolute deadline (e.g. a DAU date, a set meeting)
              | registration+Nd                  N days after registration_date
              | hire_date+Nd                     N days after first_hire_date
              | fye+Nd                           N days after each fiscal year end        (periodic)
              | quarter_end+Nd                   N days after each calendar quarter end   (periodic)
              | month_end+Nd                     N days after each calendar month end     (periodic)
              | Mon-DD[|Mon-DD…][@fye]           fixed calendar date(s) each year; "@fye" makes it a
                                                 look-back filing for the fiscal year ended before it
```

Examples: `Jan-20` (LGU renewal), `Dec-24` (13th-month pay), `Apr-15@fye` (annual return stated
as its calendar date), `May-15|Aug-15|Nov-15` (1701Q), `quarter_end+25d` (2550Q / 2551Q),
`month_end+10d` (0619-E), `fye+15d` (loose-leaf books), `fye+120d` (SEC AFS),
`hire_date+30d` (SSS employee reporting), `registration+30d` (set-up tasks).

Engine semantics (implemented in `scripts/gates/compliance.sh`; "today" = `guild_today`, i.e.
`$GUILD_TODAY` → the register's `# as_of:` line → the system date — every fixture carries
`# as_of:` so scoring never decays with the calendar):

- **Trigger.** `category=employer` rows are owed only from `first_hire_date`; all others from
  `registration_date`. A periodic occurrence is **owed** iff its period end (or, for point-in-time
  fixed dates, the date itself) is on/after the trigger — a company registered 2026-03-15 owes the
  Q1-2026 VAT return (quarter ended 03-31) but not the FY2025 annual return.
- **Current deadline** = the latest owed occurrence with `D ≤ today`. None passed yet → the row is
  in good standing as `pending`.
- **Coverage.** Evidence dated `E` covers: for periodic rules, the latest occurrence whose period
  end ≤ E (a return cannot precede its period); for fixed point-in-time dates, the next occurrence
  on/after E (a renewal or 13th-month payment is made before its date); for single rules, the one
  deadline. The row passes when the covered occurrence is the current one (or later) and
  `E ≤ its deadline`.
- **Overdue** = current deadline strictly before today and not covered (`no evidence`, or evidence
  that covers an earlier period = stale). Overdue rows print
  `OVERDUE <id>: due <date> (N days late…)` and score 0.
- **Late** = evidence after its own deadline (possible for periodic and single rules). It fails
  until a human settles the penalty and records the keyword `late` in `notes`; the gate then
  counts the row and still prints a `LATE` line. For fixed point-in-time rules a late act simply
  shows as OVERDUE until done — the register cannot distinguish "late for this year" from "early
  for next" on a date alone.
- **Warnings.** The next uncovered deadline warns at **T-30**, **T-7** and **T-0** on stderr.
- Known approximations, stated so nobody trusts them silently: `fye+105d` renders "15th day of the
  4th month after FYE" as Apr-15 after a Dec-31 FYE but Apr-14 in a leap year (file a day early,
  or write `Apr-15@fye`); `quarter_end+Nd` emits all four quarters, while 1701Q/1702Q have no Q4
  filing — the annual row owns Q4; `quarter_end` means calendar quarters, so a fiscal year not
  ending on a calendar quarter needs absolute dates.

## §5 Zero to operating — the ordered path (order matters: each step feeds the next)

| # | Step | Where | Document produced | Rule / deadline | Source · grade · verified_on |
|---|---|---|---|---|---|
| 0 | Choose entity + capital (sole prop / OPC / corp / partnership; foreign-equity check) | decision memo | signed memo (`requires_professional_signoff`) | before anything (early irreversible) | RCC Sec. 10: 1–15 incorporators, single-stockholder = OPC [S2] · A · 2026-09-02 |
| 1a | Sole prop: business name | DTI BNRS | DTI BN Certificate, valid 5 years; renew 180 d before to 90 d after expiry; 50 % late surcharge | `once` | fees ₱200/₱500/₱1,000/₱2,000 + ₱30 DST [S4] · A · 2026-09-02 |
| 1b | Corp/OPC: incorporate | SEC eSPARC / OneSEC | Certificate of Incorporation + AOI (+ by-laws) | `once`; OneSEC purges an incomplete application after 1 day | [S5] · A · 2026-09-02; filing-fee formula UNVERIFIED |
| 2 | BMBE Certificate of Authority (optional) — total assets ≤ ₱3,000,000 excl. land | DTI **Negosyo** Center | BMBE CA, 2 years, fee ≤ ₱1,000, deemed registered after 15 days | `event` | RA 9178 Sec. 3/7/8 (income-tax + minimum-wage exemption; NOT a VAT/percentage/SSS exemption) [S1]; RA 10644 Sec. 5(b) [S31] · A · 2026-09-02 |
| 3 | **Barangay** clearance + **Mayor's** permit / **business permit** (FSIC, sanitary, zoning consolidated) | city **BOSS** | Business Permit valid 1 year + FSIC + sanitary permit | `once`; RA 11032: 3 / 7 / 20 working days, deemed approved [S17] | A · 2026-09-02 |
| 4 | BIR registration on/before commencement | RDO / ORUS | TIN; **COR (BIR Form 2303)**; registered **books of accounts**; **ATP** + printed **INVOICES** (not ORs) | `once` (Sec. 236(A)) | TRAIN [S16]; EOPT [S3] · A · 2026-09-02. ₱500 **annual registration fee abolished 22 Jan 2024** [S7 · B] |
| 5 | Employer registrations (on **first hire**) | SSS / PhilHealth / Pag-IBIG / DOLE | employer numbers; DOLE Rule 1020 registration (text UNVERIFIED) | `hire_date+30d` (SSS reporting, RA 11199 Sec. 24) [S10] · A · 2026-09-02 | §8 |
| 6 | Data-privacy set-up | NPC | privacy notice, consent records, DPO designation | `registration+30d` (harness policy) | RA 10173 [S25] · A · 2026-09-02; NPC registration thresholds [S42] · S · UNVERIFIED |
| 7 | Contracts & IP: NDA / MSA / SOW with written IP assignment; e-signature procedure | — | reviewed templates (`requires_professional_signoff`) | `registration+30d` (policy) | RA 8792 Sec. 8 [S18]; IP Code §178.4/§180 [S40] · A · 2026-09-02 |
| 8 | Trademark (optional) | IPOPHL eTMfile | filing receipt; **Declaration of Actual Use** within 3 years | `event` / absolute DAU date | RA 8293 §124.2, §145 [S41] · A · 2026-09-02; IPOPHL fees UNVERIFIED |
| 9 | Selling online | DTI E-Commerce Bureau | Online Business Database entry, published terms/returns/warranty | `event` (first online sale) | RA 11967 [S21] · A; IRR JAO 24-03 [S22] · B · 2026-09-02 |
| 10 | Run the calendar | BIR / LGU / SEC / SSS / PhilHealth / Pag-IBIG / DOLE | filed returns, receipts, 2307s, GIS/AFS | §6–§8 | — |

## §6 BIR mechanics — registration, invoicing, books (EOPT era)

- **Register once** with the RDO "on or before the commencement of business" (Sec. 236(A), TRAIN
  [S16]; EOPT allows electronic or manual registration [S3]). Evidence: COR Form 2303. Grade A,
  verified_on 2026-09-02.
- **Invoices, not official receipts** [CHANGED 2024–26]: under EOPT (RA 11976, approved 5 Jan
  2024) and RR 7-2024 (effective **27 Apr 2024**) a registered **invoice** is the sole document
  for goods *and services* [S3][S6]. Mandatory for every sale ≥ **₱500** (or when the day's
  aggregate reaches ₱500; CPI-indexed every 3 years) [S3][10:S4]. The invoice must show the VAT
  as a separate line, both parties' names and TINs, description and date — omissions kill the
  buyer's input VAT [10:S4][04:S41]. **Print the credit term on the invoice**: it is a condition
  of the output-VAT credit on uncollected receivables (RMC 65-2024 / RR 3-2024) [10:S27].
  Penalty for invoicing violations as cited: ₱1,000–₱50,000 + 2–4 years [S6 · B].
- **Annual registration fee**: the ₱500 fee (old Form 0605 by 31 Jan) is **abolished from
  22 Jan 2024**; an existing COR stays valid [S7 · B].
- **Books of accounts**: manual books before the earlier of the first quarterly or annual ITR
  deadline; loose-leaf within **15 days** after each fiscal year end; computerized (CAS) within
  **30 days** — all on ORUS with a QR stamp (RMC 3-2023) [10:S32 · B]. Preserve books and records
  **5 years** (Sec. 235 as amended by EOPT) [S3 · A]. Rules in the register: `once` for the
  initial registration, `fye+15d` / `fye+30d` for loose-leaf/CAS re-registration
  (`applies_if: books_method == 'loose_leaf' or books_method == 'cas'`).
- **Taxpayer classes** (EOPT Sec. 21, self-assessed): micro < ₱3M, small < ₱20M, medium < ₱1B,
  large ≥ ₱1B gross sales; micro/small get penalty relief — **10 % surcharge, interest halved,
  compromise reduced ≥ 50 %** (EOPT Sec. 45) [S3 · A].

## §7 The tax calendar — VAT, percentage, 8 %, income tax, withholding, audit

| Return / act | Applies when (`applies_if`) | Deadline (`deadline_rule`) | Statute · effective | Source · grade · verified_on |
|---|---|---|---|---|
| **2550Q** quarterly **VAT** | `vat_registered` | 25 days after quarter end (`quarter_end+25d`, Sec. 114); monthly 2550M abolished 1 Jan 2023 | VAT **12 %** on gross sales incl. services; threshold **₱3,000,000** (Sec. 109(BB), CPI-indexed every 3 years); mandatory once trailing-12m gross exceeds it (Sec. 236(G)); voluntary registration = **3-year lock-in** (Sec. 236(H)) — TRAIN eff. 1 Jan 2018; EOPT moved services VAT to gross sales (accrual) | [S16][S3][04:S33][S35] · A/B · 2026-09-02 |
| **2551Q** quarterly **percentage tax** | `not vat_registered and not eight_pct_elected` | `quarter_end+25d` (Sec. 128) | **3 %** of gross (was 1 % 1 Jul 2020–30 Jun 2023 under CREATE) | [S16][S15] · A · 2026-09-02 |
| **8 % option** election | `eight_pct_elected` | signified in the Q1 return (`event`) | 8 % on gross sales + non-operating income above ₱250,000, in lieu of graduated rates *and* Sec. 116; **individuals only**; ≤ ₱3M; non-VAT; **irrevocable per year**; breach of ₱3M mid-year ⇒ graduated + VAT from the breach date — TRAIN Sec. 24(A)(2)(b); RMO 23-2018 | [04:S30][04:S33] · A · 2026-09-02 |
| **1701Q / 1701** individual quarterly / annual | `entity_type == 'sole_prop'` | `May-15\|Aug-15\|Nov-15` (Sec. 74); annual `Apr-15@fye` (Sec. 51; > ₱2,000 payable in 2 instalments 15 Apr / 15 Oct) | graduated 0–35 % (2023+ table) or the 8 % option | [S16][S33] · A/B · 2026-09-02 |
| **1702Q / 1702** corporate quarterly / annual | `entity_type == 'corp' or entity_type == 'opc'` | `quarter_end+60d` for the first 3 quarters (Sec. 75); annual `fye+105d` = 15th day of the 4th month after FYE (Sec. 52) | **CIT 25 %**; **20 %** if net taxable income ≤ ₱5M **and** assets ≤ ₱100M excl. land; **MCIT 2 %** from year 4 — CREATE (RA 11534, 26 Mar 2021, rates from 1 Jul 2020) | [S15][S32][S34-B via brief] · A/B · 2026-09-02 |
| **0619-E** monthly EWT remittance | `withholding_agent` | 10th of the following month (`month_end+10d`; eFPS staggering UNVERIFIED) | creditable **withholding** at source | [S37] · C · 2026-09-02 |
| **1601-EQ** + QAP quarterly EWT | `withholding_agent` | last day of the month after the quarter (Sec. 58(A)): `Apr-30\|Jul-31\|Oct-31\|Jan-31` | — | [S16][S37] · A/C · 2026-09-02 |
| **Form 2307** to each payee | `withholding_agent` | within 20 days after quarter end (`quarter_end+20d`) | Sec. 58(B) — primary text not fetched; secondary sources agree | [10:S34] · C · 2026-09-02 (statute wording UNVERIFIED) |
| **1604-E** + alphalist annual EWT return | `withholding_agent` | `Mar-01` | — | [S37] · C · 2026-09-02 |
| Payor **sworn declaration** (Annex C, RR 11-2018) | `withholding_agent` | `Jan-31` | — | [S39] · B · 2026-09-02 |
| Payee **sworn declaration** to each client | individual ≤ ₱3M (with non-VAT COR) or corp ≤ ₱720k wanting the lower rate | `Jan-15` (or before first payment) | CWT on professional fees: **individuals 5 %** (≤ ₱3M, non-VAT + sworn declaration) / **10 %**; **corporations 10 %** (≤ ₱720,000) / **15 %**; engineers and technical consultants are named payees; TWA purchases 1 % goods / 2 % services — RR 11-2018 / RR 14-2018 | [04:S31][04:S32][S8][S39] · A/B · 2026-09-02 |
| **Audited FS** by independent CPA | `gross_sales_12m > 3000000 or total_assets > 3000000 or total_liabilities > 3000000` | with the annual return (`fye+105d`); SEC filing `fye+120d` for non-Dec FYE, December FYE per the annual SEC circular (2026 schedule UNVERIFIED) | two independent tests: Tax Code **Sec. 232** — gross annual sales > ₱3,000,000 ⇒ CPA-**audited** books (TRAIN); **SEC MC 4 s.2026** — total assets **or** liabilities > ₱3M ⇒ audited FS (was ₱600,000; FYE ≥ 31 Dec 2025) | [S16][10:S18][10:S22][S32] · A/B · 2026-09-02 |
| VAT **zero-rating** for foreign clients | VAT-registered exporter of services | per engagement | Sec. 108(B)(2): services to a person doing business outside the PH, paid in acceptable foreign currency per BSP rules, are zero-rated | [04:S33] · A · 2026-09-02 (documentation/refund practice not covered) |
| **CREATE MORE** (RA 12066, signed 11 Nov 2024; effectivity 28 Nov 2024 per search summary — UNVERIFIED) | RBEs only — not a non-registered domestic corp | — | 20 % CIT under the Enhanced Deductions Regime; RBE local tax ≤ 2 %; 70 % export threshold for VAT zero-rating; WFH ≤ 50 % | [S23][S24] · B · 2026-09-02 |

Cash mechanics worth a register note: output VAT is due on invoicing, not collection (EOPT put
services VAT on gross sales) [S3][10:S4]; CWT arrives as Form 2307 credits, not cash, so the cash
floor is computed on (1 − CWT) × the ex-VAT price (brief 04 §4); withholding at the wrong rate
without the sworn declaration puts the deficiency on the **withholding agent** [S39].

## §8 Employer obligations — activated by the first hire (`has_employees`, `first_hire_date`)

| Obligation | Rate / rule | Deadline | Penalty (verified) | Source · grade · verified_on |
|---|---|---|---|---|
| **SSS**: register employer; report each employee within **30 days** of employment; remit monthly | **15 %** (ER 10 % / EE 5 %) on MSC ₱5,000–₱35,000 (final tranche 1 Jan 2025); above ₱20,000 MSC to MPF/WISP | `hire_date+30d` (reporting, RA 11199 Sec. 24); monthly per the SSS payment schedule (day UNVERIFIED in brief) | 2 %/month; fines ₱5,000–₱20,000 + 6y1d–12y (Sec. 22/28) | [S10][S35] · A/B · 2026-09-02 |
| **PhilHealth**: register; remit monthly via EPRS | **5 %** of monthly basic salary, shared equally; floor ₱10,000 (₱500), ceiling ₱100,000 (₱5,000); unchanged for 2026 (Advisory 2026-0042, 21 Jul 2026) | PEN ending 0–4: 11th–15th; 5–9: 16th–20th of the following month (`month_end+15d` / `month_end+20d`) | ₱50,000 per affected employee + 6 mo–1 yr; interest ≥ 3 %/mo (RA 11223) | [S11][S43][S13][S12] · A · 2026-09-02 |
| **Pag-IBIG** (HDMF): register; remit monthly | EE 1 % (≤ ₱1,500) / 2 %; ER 2 %; **max ₱200/month each** (base adjustable; Feb-2024 circular number UNVERIFIED) | monthly (schedule UNVERIFIED) | 3 %/month; fines up to 2× the amount / ≤ 6 yrs (RA 9679 Sec. 23/25) | [S14][S35] · A/B · 2026-09-02 |
| **DOLE** establishment registration (**OSHS Rule 1020** — text UNVERIFIED) + OSH program, safety officer, first-aider, free PPE | RA 11058 duties | on set-up (`hire_date+30d` as harness policy until Rule 1020 is verified) | **OSH** fines up to **₱100,000/day** until corrected | [S30] · A (RA) / S (Rule 1020) · 2026-09-02 |
| **13th-month pay** | 1/12 of basic annual salary, all rank-and-file with ≥ 1 month service | not later than **24 December** (`Dec-24`) | — | PD 851 [S27]; MO 28 (1986) removed the ₱1,000 ceiling [S28] · A · 2026-09-02 |
| Minimum wage (regional wage orders; BMBE exempt per RA 9178 Sec. 8) | NCR order under TRO/injunction as of the research date — model both floors | continuous | — | [S1] · A (exemption) · 2026-09-02 |
| **Contractor vs employee** — the **four-fold** test: selection, wages, dismissal, **control** over means and methods (the control test is decisive; the contract label is not) | *Sonza v. ABS-CBN*, G.R. 138051 (2004) | at every engagement (`registration+30d` review row, then per contract) | misclassification ⇒ employment "by law, not by contract label": back statutory benefits, security of tenure | [S29] · A · 2026-09-02 |

Contractors: withhold EWT (5 %/10 % or 2 %) and issue 2307s — no SSS/PhilHealth/Pag-IBIG/13th-month;
but if the studio controls means and methods, the relationship is employment regardless of the
label, retroactively (§14.9).

## §9 Data, online sales, consumers, contracts, IP, foreign equity

- **Data Privacy Act (RA 10173, 2012).** Lawful basis for every processing; consent must be
  "freely given, specific, informed"; age, marital status, health and education are sensitive
  personal information needing **explicit** consent; privacy notice, security measures, breach
  register (72-hour notification per IRR — UNVERIFIED); **DPO** designated. **NPC** registration
  of data-processing systems at the thresholds in NPC Circular 2022-04 — ≥ 250 employees or SPI
  of ≥ 1,000 individuals — is **UNVERIFIED** (snippet only; the PDF was blocked on 2026-09-02)
  [S25 · A; S42 · S]. Penalties: ₱500k–₱2M + 1–3 yrs (unauthorised processing); up to ₱4M +
  7 yrs for sensitive data [S25]. Register rows: `DPA-BASELINE` (`registration+30d`),
  `DPA-NPC-REG` (`applies_if: employee_count >= 250 or spi_records >= 1000`).
- **Internet Transactions Act (RA 11967, 5 Dec 2023) + IRR JAO 24-03.** On the first online sale
  (`sells_online`): merchant disclosures (name, address, contact, product info), delivery as
  described, invoices, complaint mechanism, entry in the **Online Business Database** (submit the
  BIR COR and IDs — marketplaces run KYC), under the DTI **E-Commerce Bureau**; administrative
  fines ₱20,000–₱1,000,000, takedown, blacklist; 18-month transitory period (end date UNVERIFIED)
  [S21 · A; S22 · B].
- **Consumer Act (RA 7394, 1992).** Selling consumer products (hardware): implied **warranty**
  "not less than sixty (60) days nor more than one (1) year"; remedies repair/replace/refund;
  service invoices carry a ≥ 90-day workmanship guaranty; **"No Return, No Exchange" is
  prohibited** (DAO 2 s.1993; fines to ₱300k + ₱1k/day per the dossier) [S26 · A]. The per-sale
  warranty text control lives in the `regulatory` gate; the register holds the template row.
- **E-signatures (RA 8792, 2000).** Valid when Sec. 8 holds: a method identifies the signer and
  indicates intent; reliable and appropriate for the purpose; necessary to proceed; and the other
  party can verify. Keep the signing-platform audit trail as evidence [S18 · A].
- **IP Code (RA 8293, 1997).** Employer owns work from regularly-assigned duties (§178.3);
  **commissioned work: the commissioner owns the object, the creator keeps the copyright unless
  there is a written stipulation** (§178.4); **assignment must be in writing** (§180); patents on
  commissioned work default to the commissioner only by contract (Sec. 30). Every MSA/SOW and
  employment contract carries the written assignment + background-IP carve-out
  (`requires_professional_signoff=true`) [S40][S41] · A · 2026-09-02.
- **Trademark.** Rights by registration (§122); **Declaration of Actual Use within 3 years of
  filing** (§124.2) or the application is refused/removed; 10-year term with a further DAU within
  1 year of the 5th anniversary (§145). IPOPHL fees UNVERIFIED [S41 · A].
- **Foreign equity (FIA, RA 11647, 2 Mar 2022).** A domestic-market enterprise with any foreign
  equity needs **US$200,000** paid-in — **US$100,000** with ≥ 15 direct Filipino employees,
  DOST-certified advanced tech, or an RA 11337 startup endorsement; export enterprises may be
  100 % foreign. Retail to consumers while foreign-owned: ₱25M paid-up (₱10M per store beyond
  one) under RA 11595 (10 Dec 2021). EO 175 negative-list annex UNVERIFIED [S19][S36] · A ·
  2026-09-02.
- **BMBE (RA 9178 + RA 10644).** Assets ≤ ₱3M excl. land ⇒ optional CA at the DTI Negosyo
  Center (≤ ₱1,000, 2 years): income-tax exemption on operating income + minimum-wage exemption —
  **not** VAT/percentage-tax or SSS/PhilHealth/Pag-IBIG relief; misuse: ₱25k–₱50k + 6 mo–2 yrs
  (Sec. 13) [S1][S31] · A · 2026-09-02.

## §10 The professional sign-off rule

These rows carry `requires_professional_signoff=true` and **never loop-pass** — the gate refuses
`done` without a resolving `signoff_path`, and no iteration may mark them on its own:

choice of entity and capital structure · VAT / 8 % elections and any tax posture change · BMBE
application · every tax return and payment (signed by the taxpayer/officer) · the AFS audit
opinion (independent, BOA-accredited CPA) · SEC GIS/AFS submissions · employment-vs-contractor
classification · contracts, NDAs, IP assignments and any e-signature roll-out · NPC registration
and DPO appointment · LGU renewal filings · any interpretation of a rule marked UNVERIFIED.

The human is a Philippine **accountant** (CPA) or **lawyer** as the row demands; the loop's whole
authority is to draft, compute deadlines, and surface the row. This protocol and the gate are
**not legal advice, not tax advice and not financial advice** (rule 3, SKILL.md invariants).

## §11 The 12-month re-verification rule

Every row's `verified_on` records when a human last read the cited source. The gate prints
`RE-VERIFY` for rows older than **12 months**; treat the flag as a hard prompt — TRAIN (2018),
CREATE (2021), EOPT + RR 7-2024 + CREATE MORE (2024), the SSS final tranche (2025) and SEC MC 4
(2026) each invalidated register rows that looked settled. Grade `S` rows (snippet-only) are
born-UNVERIFIED: they may not be `done` without `notes` recording the human verification.

## §12 The gate — `score-guild.sh compliance <register.csv> <profile.yaml>` → `COMPLIANCE: x/y`

- `y` = rows applicable under the profile (`applies_if`) **plus** consistency violations with no
  row to blame; `x` = applicable rows in good standing. `x < y` blocks the operations phase gate.
- Per applicable row (any failure → stderr `FAIL <id>: <rule>` and the row scores 0):
  schema (unique id; `source_url`; `source_grade ∈ A|B|C|S`; `verified_on`; valid cadence/status);
  status honesty (`na` while applicable fails); for `done` rows — `evidence_path` resolves
  non-empty, `evidence_hash` 16–64 hex matching the file's sha256, `evidence_date` valid, not in
  the future, and on time per §4; sign-off rows need `signoff_path`; grade-S rows need `notes`.
- Deadline engine per §4: `OVERDUE` (deadline < today, not covered) and `LATE` lines on stderr;
  T-30 / T-7 / T-0 warnings for the next uncovered deadline; `RE-VERIFY` per §11.
- **Consistency rules** (each violation = an applicable-but-failed row; keyword matching over
  `id + obligation + agency`, so name rows accordingly):

| Rule | Check |
|---|---|
| C1 | `vat_registered` ⇒ a **2550Q** row applies and no **2551Q** row applies; not `vat_registered` ⇒ no 2550Q applies, and (unless on 8 %) a 2551Q row applies |
| C2 | `eight_pct_elected` ⇒ no 2551Q applies, `vat_registered` is false, and `entity_type == 'sole_prop'` (individuals only) |
| C3 | `has_employees` ⇒ **SSS**, **PhilHealth**, **Pag-IBIG**, **13th-month** and **OSH** rows apply, and `first_hire_date` is set |
| C4 | `entity_type ∈ {corp, opc}` ⇒ SEC rows (SEC / GIS / AFS) apply |
| C5 | `gross_sales_12m > 3000000` ⇒ an audit row applies **and** `vat_registered` is true (Sec. 236(G)) |
| C6 | `sells_online` ⇒ Internet Transactions Act rows apply |

- Exit 0 on valid data (a red register is data); exit 2 only on hard error (missing file,
  unparseable register/profile, missing schema columns, invalid profile).
- Fixtures: `tests/fixtures/compliance/` — `good-register.csv` (every applicable row in good
  standing) vs `overdue-register.csv` (planted: a 2550Q past deadline without evidence; a 2551Q
  active while VAT-registered; a sign-off row `done` without `signoff_path`; an S-grade row
  without notes; a stale `verified_on`), scored via `tests/compliance.test.sh compliance`.

## §13 Failure modes / penalties (verified numbers only)

| Failure | Consequence | Source · grade |
|---|---|---|
| Missing the 20 January LGU renewal / LBT payment | surcharge ≤ 25 % + interest ≤ 2 %/month up to 36 months (LGC Sec. 168) | UNVERIFIED verbatim (LGC not retrievable 2026-09-02) |
| No invoice / unstamped ORs after 27 Apr 2024 | ₱1,000–₱50,000 + 2–4 yrs as cited; customers lose input VAT | [S6] · B |
| Late/short tax filing | surcharge + interest; micro/small: 10 % surcharge, interest halved (EOPT Sec. 45) | [S3] · A |
| SSS non-remittance | 2 %/month + ₱5k–₱20k + 6y1d–12y | [S10] · A |
| PhilHealth non-remittance | ₱50,000 per affected employee + 6 mo–1 yr; ≥ 3 %/mo interest | [S12] · A |
| Pag-IBIG non-remittance | 3 %/month; up to 2× the amount / ≤ 6 yrs | [S14] · A |
| OSH non-compliance | up to ₱100,000/day until corrected | [S30] · A |
| Misclassifying employees as contractors | employment found by the control test ⇒ back benefits, tenure | [S29] · A |
| Personal-data misuse | ₱500k–₱2M + 1–3 yrs; up to ₱4M + 7 yrs (sensitive) | [S25] · A |
| Online-seller non-disclosure / non-delivery | ₱20k–₱1M + takedown + blacklist | [S21] · A |
| Warranty misrepresentation / "No Return, No Exchange" | Consumer Act remedies + fines | [S26] · A |
| Withholding at the wrong rate (no sworn declaration) | agent withholds at the higher rate; deficiency assessed on the agent | [S39] · B |
| GIS/AFS not filed ×3 | delinquent status (RCC Sec. 177) | UNVERIFIED (text not retrievable) |
| No DAU within 3 years | trademark application refused / mark removed (§124.2) | [S41] · A |
| BMBE misuse | ₱25k–₱50k + 6 mo–2 yrs (RA 9178 Sec. 13) | [S1] · A |

## §14 Early irreversibles (fix at charter time; each needs a decide-by date and an owner)

1. **Entity type** — sole prop → corp later = new SEC registration, new BIR COR/TIN, new permits,
   new invoices/ATP, contract transfers (closure procedures UNVERIFIED) [brief 09 §6].
2. **Voluntary VAT registration** — 3-year lock-in (Sec. 236(H)) [S16].
3. **The 8 % election** — irrevocable for the taxable year (Sec. 24(A)(2)(b)) [S16].
4. **TIN** — one per person for life; the corporation's is separate.
5. **Name scope** — DTI BN territorial scope, SEC name rules, trademark class; the DAU clock
   starts at filing.
6. **Foreign-equity structure** — US$200k/US$100k (₱25M retail) must hold at formation [S19][S36].
7. **Books and invoicing method** — manual vs loose-leaf vs CAS; printed invoice stock under ATP.
8. **Fiscal year** — corporations change it only with BIR approval (procedure UNVERIFIED).
9. **Employment behaviour** — once an engagement behaves like employment (control test), statutory
   benefits attach retroactively [S29].
10. **IP clauses in the first MSA** — §178.4 keeps copyright with the creator absent a written
    stipulation; retrofitting assignments from ex-contractors is hard [S40].

## §15 Open items — UNVERIFIED on 2026-09-02; hand to a human before relying on them

LGC §167/168 verbatim (the 20 January renewal and its surcharge) · RCC OPC chapter and §177 ·
SEC December-FYE AFS/GIS calendar and fines · NPC Circular 2022-04 thresholds · OSHS Rule 1020 ·
IPOPHL fee schedule · BIR 2025 e-invoicing regulations · Pag-IBIG Feb-2024 circular and
remittance schedule · SSS remittance day · ITA transitory end date · CREATE MORE effectivity ·
fiscal-year change procedure · multiple-TIN penalty · eFPS staggered EWT dates · DTI
consumer-price-display rule · Sec. 58(B) verbatim (2307 20-day wording).

## §16 Sources cited (read 2026-09-02; grades per brief 09 / 10 / 04)

| Ref | Source | Grade |
|---|---|---|
| [S1] | RA 9178 (BMBE Act) — lawphil.net/statutes/repacts/ra2002/ra_9178_2002.html | A |
| [S2] | RA 11232 (Revised Corporation Code) — lawphil.net/statutes/repacts/ra2019/ra_11232_2019.html | A |
| [S3] | RA 11976 (EOPT) — lawphil.net/statutes/repacts/ra2024/ra_11976_2024.html | A |
| [S4] | DTI BNRS FAQ — bnrs.dti.gov.ph/faq | A |
| [S5] | SEC eSPARC OneSEC overview — esparc.sec.gov.ph/application-one-sec/overview-zero | A |
| [S6] | Grant Thornton — RR 7-2024 invoicing clarification | B |
| [S7] | Grant Thornton — annual registration fee abolished 22 Jan 2024 | B |
| [S8] | Forvis Mazars — withholding taxes in the Philippines | B |
| [S10] | RA 11199 (Social Security Act 2018) — lawphil | A |
| [S11] | PhilHealth Advisory 2025-0002 | A |
| [S12] | RA 11223 (Universal Health Care) — lawphil | A |
| [S13] | PhilHealth employer payment procedures — philhealth.gov.ph | A |
| [S14] | RA 9679 (HDMF / Pag-IBIG) — lawphil | A |
| [S15] | RA 11534 (CREATE) — lawphil | A |
| [S16] | RA 10963 (TRAIN) — lawphil | A |
| [S17] | RA 11032 (Ease of Doing Business) — lawphil | A |
| [S18] | RA 8792 (E-Commerce Act, e-signatures) — lawphil | A |
| [S19] | RA 11647 (FIA amendments) — lawphil | A |
| [S21] | RA 11967 (Internet Transactions Act) — lawphil | A |
| [S22] | Baker McKenzie — ITA IRR (JAO 24-03) | B |
| [S23] | Grant Thornton — CREATE MORE (RA 12066) | B |
| [S24] | ACCRALAW — MORE to CREATE | B |
| [S25] | RA 10173 (Data Privacy Act) — lawphil | A |
| [S26] | RA 7394 (Consumer Act) — lawphil | A |
| [S27] | PD 851 (13th Month Pay) — lawphil | A |
| [S28] | Memorandum Order No. 28 (1986) — lawphil | A |
| [S29] | Sonza v. ABS-CBN, G.R. 138051 (2004) — lawphil | A |
| [S30] | RA 11058 (OSH) — lawphil | A |
| [S31] | RA 10644 (Go Negosyo) — lawphil | A |
| [S32] | PwC WWTS — PH Corporate tax administration (reviewed 1 Aug 2026) | B |
| [S33] | PwC WWTS — PH Individual tax administration | B |
| [S35] | PwC WWTS — PH Corporate other taxes (reviewed 1 Aug 2026) | B |
| [S36] | RA 11595 (Retail Trade Liberalization) — lawphil | A |
| [S37] | Taxumo — expanded withholding tax deadlines | C |
| [S39] | Grant Thornton — RR 11-2018 sworn declarations | B |
| [S40] | RA 8293 (IP Code) — WIPO Lex copy | A |
| [S41] | RA 8293 (IP Code) — lawphil (truncated at §129) | A |
| [S42] | NPC Circular 2022-04 — privacy.gov.ph PDF (snippet only) | S |
| [S43] | PhilHealth Advisory 2026-0042 (21 Jul 2026) | A |
| [10:S4] | BIR — EOPT salient-features flyer (bir-cdn.bir.gov.ph) | A |
| [10:S18] | Grant Thornton — SEC MC 4 s.2026 audit thresholds | B |
| [10:S22] | Acclime — PH audit requirements | B |
| [10:S27] | Grant Thornton — RMC 65-2024 output-VAT credit on uncollected receivables | B |
| [10:S32] | Forvis Mazars — RMC 3-2023 ORUS books registration | B |
| [10:S34] | Taxumo — BIR Form 2307 guide | C |
| [04:S30] | BIR RMO 23-2018 (the 8 % option) — bir-cdn PDF | A |
| [04:S31] | BIR — Digest of RR 11-2018 (withholding) — bir-cdn PDF | A |
| [04:S32] | Grant Thornton — RR 14-2018 5 % EWT non-VAT condition | B |
| [04:S33] | RA 10963 (TRAIN) — lawphil (VAT / 8 % / zero-rating sections) | A |
| [04:S41] | MTF Counsel — BIR invoicing requirements (8 May 2025) | B |
