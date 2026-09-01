# as_of: 2026-09-02

# Venture Requirements Spec — automated stock counts for Metro Manila SMB manufacturers (fixture)

Venture: automated stock counts for make-to-stock SMB manufacturers with manual inventory.
Elected segment: `smb-mfg` (elected 2026-08-20 by founder-1, board_ack 2026-08-25); market type
`resegmented_niche`. Row format: `references/venture-requirements-protocol.md` §1 — one fenced
`vrs` block per row. The three riskiest rows are tested by doing (paid_pilot, LOI, pre_order),
never by asking. Baselines behind the thresholds cite the claims ledger in the rationale lines.

## Desirability

### V-1 — owners pay for automated counts

```vrs
id: V-1
statement: We believe that Metro Manila SMB manufacturers with manual counts will pay at least PHP 15,000 per month for automated stock counts
type: D
metric: paid pilots signed and invoiced at >= PHP 15,000 per month in the elected segment
threshold: >= 3 paid pilots signed and invoiced by decide_by
method: paid_pilot
evidence_grade: strong
risk_rank: 1
owner: founder-1
decide_by: 2026-11-30
status: open
```
Rationale: three money commitments already exist in `discovery/commitments.csv` (I-7, I-10, I-14);
a pilot converts intent into an invoice.

### V-2 — the owner signs within a month of a site walk-through

```vrs
id: V-2
statement: We believe that the owner, not the plant manager, signs within 30 days of a site walk-through
type: D
metric: days from the stockroom walk-through to a signed LOI, per account
threshold: <= 30 days for >= 50 % of walk-throughs (n >= 6)
method: LOI
evidence_grade: moderate
risk_rank: 2
owner: founder-2
decide_by: 2026-11-15
status: open
```

### V-3 — a deposit before any build

```vrs
id: V-3
statement: We believe that owners will place a PHP 10,000 deposit for a paid discovery workshop before any build exists
type: D
metric: deposits received for the paid discovery offer
threshold: >= 3 deposits of >= PHP 10,000 by decide_by
method: pre_order
evidence_grade: strong
risk_rank: 3
owner: founder-1
decide_by: 2026-10-31
status: open
```

### V-4 — the count is expensive enough to matter

```vrs
id: V-4
statement: We believe that the month-end count costs each site at least 16 staff-hours
type: D
metric: staff-hours per month-end count, reported as past behaviour in consented interviews
threshold: >= 16 staff-hours in >= 60 % of interviewed sites (n >= 12)
method: interview
evidence_grade: weak
risk_rank: 4
owner: founder-2
decide_by: 2026-10-15
status: open
```

## Feasibility

### V-5 — a count station is accurate enough

```vrs
id: V-5
statement: We believe that a camera-and-scale count station reaches 97 % count accuracy on sacks and drums
type: F
metric: count accuracy versus a manual audit count on the bench prototype
threshold: >= 97 % on >= 200 items across 3 material types
method: desk
evidence_grade: weak
risk_rank: 5
owner: founder-2
decide_by: 2026-12-15
status: open
```

## Viability

### V-6 — margin holds at the worst corner

```vrs
id: V-6
statement: We believe that gross margin holds at 60 % at the worst corner with anvil PRODUCT_COST as hardware COGS
type: V
metric: gross margin at the worst corner of economics/model.csv (economics gate UE-01)
threshold: >= 60 % at the worst corner
method: desk
evidence_grade: weak
risk_rank: 6
owner: founder-1
decide_by: 2026-12-31
status: open
```

### V-8 — an existing market pays back inside 18 months

```vrs
id: V-8
statement: We believe that this is an existing market resegmented as a niche, so the venture reaches positive contribution margin within 18 months
type: V
metric: months from the first paid pilot to positive contribution margin in the 13-week cash ledger
threshold: <= 18 months
method: desk
evidence_grade: weak
risk_rank: 8
owner: founder-1
decide_by: 2027-03-31
status: open
```

## Adaptability (must-be dispositions)

### V-7 — first-deal payment terms

```vrs
id: V-7
statement: We believe that corporate clients accept a 50 % deposit and Net 15 terms on the first SOW
type: A
metric: share of first SOWs signed with a 50 % deposit and Net 15 terms
threshold: >= 80 % of the first 5 SOWs
method: paid_pilot
evidence_grade: strong
risk_rank: 7
owner: founder-1
decide_by: 2026-12-31
status: open
```

| Must-be item | Disposition |
|---|---|
| Payment terms and withholding (EWT, Form 2307) | V-7 |
| Cash horizon by market type | V-8 |
| Delivery capacity (founder time, anvil build slot) | V-5 |
| Data privacy (RA 10173 consent on every interview and pilot) | covered by the interviews gate; no separate row |
