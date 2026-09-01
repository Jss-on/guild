# Board pack — Bayanihan Embedded Systems Inc. — 2026-09-04

Generated 2026-09-01T18:00:00+08:00 from the ledger snapshot in this directory (as_of 2026-09-02).
Pre-read: 63 h before the meeting. Every number below is derived from a ledger row; nothing here
is typed by hand except the narrative in section A.

## A. Big picture

CEO narrative: August was the third cash-positive month in a row. Mabuhay Foods signed phase 2
(line 3), the DVT build is on schedule, and the constraint has moved from delivery to pipeline:
coverage of the Q4 plan is well under target while win rate slipped on two hourly-anchored
proposals we wrote before the milestone price book.

### Highlights
- Accepted-milestone revenue ₱1,380,000 in August, up from ₱1,210,000 in July.
- Mabuhay Foods phase 2 won (₱1,850,000 TCV) with a 30 % deposit invoiced on countersign.
- First-pass milestone acceptance hit 88 % against the 85 % plan; MS-4 delivered 2 days early.

### Lowlights
- Proposal win rate 40 % vs 45 % plan — both losses were legacy hourly quotes.
- Pipeline coverage 0.65x of the Q4 plan vs the 2x floor (K4 row breached; sales sprint owed).
- Tarlac Agro (DL-6) has had no activity for 36 days and is one week from disqualification.

### Asks
- Warm introductions to two CALABARZON plant operations heads (San Miguel network preferred).
- A referral to a fractional CFO who has closed an SB Corp Business Expansion file.

## B1. KPIs vs plan

North Star: accepted-milestone revenue per month (productivity game); five input metrics below.

| KPI | Actual (2026-08) | Plan | Variance | Trend |
|---|---|---|---|---|
| rev_accepted · Accepted-milestone revenue (North Star) | 1,380,000 | 1,500,000 | -8.0 % | ↑ |
| leads_qualified · Qualified leads | 9 | 8 | +12.5 % | ↑ |
| win_rate · Proposal win rate | 40 | 45 | -11.1 % | ↓ |
| utilisation · Billable utilisation | 76 | 72 | +5.6 % | ↓ |
| first_pass · Milestone first-pass acceptance | 88 | 85 | +3.5 % | ↑ |
| repeat_share · Repeat and expansion revenue share | 31 | 30 | +3.3 % | ↓ |

## B2. Cash & runway

cash_now: 2,320,000
net_burn_avg_3m: -576,667
runway_months: cash-positive
DEFAULT_ALIVE: 1
months_to_zero: n/a

Revenue receipts have exceeded expenses since June; the PG simulation holds revenue growth at the
trailing compound rate with expenses flat, and the company is profitable on current cash.

| Month | Revenue in | Expenses out | Closing cash | Headcount |
|---|---|---|---|---|
| 2026-03-31 | 0 | 210,000 | 590,000 | 2 |
| 2026-04-30 | 150,000 | 260,000 | 480,000 | 2 |
| 2026-05-31 | 420,000 | 310,000 | 590,000 | 2 |
| 2026-06-30 | 650,000 | 360,000 | 880,000 | 2 |
| 2026-07-31 | 1,090,000 | 420,000 | 1,550,000 | 2 |
| 2026-08-31 | 1,240,000 | 470,000 | 2,320,000 | 2 |

## B3. Pipeline

weighted_pipeline: 2,740,000
next_quarter_plan: 4,200,000
coverage: 0.65x
stale_rows: 1

Open pipeline is five deals; DL-6 (Tarlac Agro) is the stale row — no activity since 2026-07-28.
Coverage is below the 2x floor: K4 mandates a marketing/sales sprint before any hire starts.

| Deal | Stage | ACV | Prob. | Next action (date) |
|---|---|---|---|---|
| DL-2 San Rafael Beverage | proposal | 1,400,000 | 60 % | plant walkthrough (2026-09-10) |
| DL-4 Batangas Cannery | proposal | 2,200,000 | 50 % | answer EWT/2307 AP question (2026-09-09) |
| DL-3 Laguna Dairy Co-op | meeting | 900,000 | 40 % | send paid discovery SOW (2026-09-05) |
| DL-5 Cavite Snacks Mfg | lead | 1,200,000 | 20 % | qualify vs ICP (2026-09-12) |
| DL-6 Tarlac Agro Processing | contacted | 800,000 | 25 % | re-engage or disqualify (2026-09-05) |

## B4. Delivery

milestones_delivered: 4
on_time_pct: 75.0

MS-3 (downtime dashboard MVP) delivered 3 days late against 2026-07-24 — root cause was scope
added without a change order; the change-control rule in MSA v1 §6 now applies. MS-5 and MS-6
are in progress and tracking to their committed dates.

## B5. People

headcount_actual: 2
headcount_plan: 2

The junior-embedded-engineer hire (ADR-9) is proposed for Q4 and is gated on K7: DEFAULT_ALIVE
must hold and backlog must stay above 60 % of the Q4 plan at this meeting.

| Month | Plan | Actual |
|---|---|---|
| 2026-03-31 | 2 | 2 |
| 2026-04-30 | 2 | 2 |
| 2026-05-31 | 2 | 2 |
| 2026-06-30 | 2 | 2 |
| 2026-07-31 | 2 | 2 |
| 2026-08-31 | 2 | 2 |

## B6. Risks

Top 5 of 8 open rows by probability × impact; the full register rides in risks.csv.

| Risk | Category | Score | Owner | Trigger | Next review |
|---|---|---|---|---|---|
| R-3 anchor-client concentration | cash | 16 | Jession Diwangan | concentration > 25 % two months running or any invoice > 45 d overdue | 2026-09-25 |
| R-2 beachhead buys slower than 60-day cycle | market | 12 | Jession Diwangan | median cycle > 90 d on 5+ deals | 2026-09-25 |
| R-4 DVT slip on pending NTC type approval | delivery | 12 | Marco Reyes | DVT exit slips > 2 weeks or NTC pending at PVT | 2026-09-25 |
| R-1 founder departure or deadlock before cliff | people | 10 | Jession Diwangan | two missed weekly syncs or notice given | 2026-09-25 |
| R-7 EOPT invoice / 2307 mismatch short-payments | compliance | 9 | Jession Diwangan | any paid invoice with EWT and no 2307 by day 20 after quarter | 2026-09-25 |

## B7. Decisions & asks

Proposed ADRs for this meeting; both decide-by dates are the meeting date.

| ADR | Title | Owner | Decide by | Money/legal |
|---|---|---|---|---|
| ADR-9 | Hire a junior embedded engineer in Q4 2026 (one-way; pre-mortem PM-3) | Marco Reyes | 2026-09-04 | true |
| ADR-10 | Apply for SB Corp Business Expansion Financing of ₱1,500,000 | Jession Diwangan | 2026-09-04 | true |

## C. Company building

Roadmap (owner in brackets):
- 2026-10: DVT exit for the line-monitor node; NTC type-approval file submitted with the marketed model name [Marco Reyes].
- 2026-11: junior engineer onboarding if ADR-9 is accepted; PVT pilot build [Marco Reyes].
- 2026-Q4: second anchor client signed to pull R-3 concentration under 25 % [Jession Diwangan].

Org (2026-09): two founders — CEO (sales, customers, cash, board pack) and CTO (delivery,
hardware NPI, engineering hires); advisor chair on FAST terms mediates deadlocks.

## D. Closed session

Held without the pack; feedback to founders is not mechanized and is never read by the loop.
