# Governance Protocol — founders' agreement, strategy, the board, decisions, risks, kill rows

Companion to `$guild board` and the governance phase of `$guild build`. The doctrine: **the board
pack is derived from ledgers, the kill and pivot criteria are numbers written before the quarter,
the decision log is append-only, and every act with money or legal effect is a human signature the
loop never performs.** Research basis: brief 11 (`research/raw/11-governance-strategy-board.md`,
retrieved 2026-09-02) and the benchmarks annex §10. Citations `[S#]` below use brief 11's source
numbering (its §8); provenance grades P1 primary / P2 secondary / P3 weak ride along; thresholds
with no external source are marked **policy**.

## §0 The three rules

1. **Derived, not written.** Every exhibit in the board pack is computed from a ledger the gates
   can re-derive: KPIs from `kpi_actuals.csv` × `plan.csv`, cash and runway from
   `cash_ledger.csv`, pipeline from `deals.csv`, delivery from `milestones.csv`, people from
   `headcount.csv`, risks from `risks.csv`, decisions from `decisions.tsv`. The only hand-written
   text is the CEO narrative in section A. A pack number that disagrees with its ledger is
   INCOMPLETE; a ledger older than 31 days at the meeting is STALE (`board` gate).
2. **Pre-committed numbers decide.** Kill and pivot criteria (K1–K7, §9) are numeric rows with
   decide-by dates written *before* the period they judge. The `CONTINUE | PIVOT | KILL` verdict
   is computed against those rows — never against the mood of the meeting. Issuing the verdict is
   mechanical; acting on it is human.
3. **Humans sign; the loop drafts.** The founders' agreement, every SAFE/loan/grant/advisor
   instrument, every hire, every filing and the closed session are human acts. The loop prepares
   drafts, surfaces the rows and refuses to mark them `pass` (§11).

## §1 The founders' agreement — the gate before any external money

Wasserman (~10,000 founders / 3,500 startups): "People problems are the leading cause of failure
in startups" [S19] P1. The agreement is written and signed **before** outside money or serious IP
exists, because the terms are early irreversibles (§12): unwinding a split needs buy-backs or
litigation, and retrofitting IP assignment needs every contributor's signature.

Defaults (deviations need an ADR recorded in `vesting_adr_ref`):

| Term | Default | Source |
|---|---|---|
| Equity split | **equal** — "If you aren't willing to give your partner an equal share, then perhaps you are choosing the wrong partner"; a valuable company takes 7–10 years, year-one contribution differences do not price that | YC [S3] P1 |
| Vesting | **4 years**, 25 % at the cliff then 1/48 per month | YC [S3] P1 |
| Cliff | **12 months** — exists precisely so a mistake can be fixed "without harm in year one" | YC [S3] P1 |
| Roles | every split founder carries a role and an accountable_for line | policy |
| Decision rights | the list of decisions needing unanimity (equity, debt, hires, leases, contracts above a peso threshold) plus per-founder decide-alone lanes and a deadlock procedure — the "rich vs king" control-vs-wealth preference made explicit before the first investor forces it | Wasserman [S18][S20] P1/P2 |
| IP assignment | `ip_assigned_to_company: true`, in writing, covering pre-incorporation work | practitioner consensus (Cooley/Orrick forms not retrievable — UNVERIFIED); PH default keeps copyright with the creator absent assignment (IP Code, brief 09) |
| Departure terms | good leaver / bad leaver, buy-back mechanics, unvested forfeiture, notice | policy |
| Signature | `signed_date` + `signed_pdf` (the scanned instrument) | policy |

Machine-readable summary: `board/founders-agreement.yaml` (schema in `scripts/gates/founders.sh`).
Validator: `score-guild.sh founders <yaml>` → `FOUNDERS_AGREEMENT: VALID | INVALID`; INVALID
**blocks the first external-money step** — no SAFE, loan, grant application or advisor grant row
may be marked done while the agreement is invalid or unsigned. The cap table must reconcile with
the vesting schedule monthly [brief 11 §5.8].

## §2 Strategy kernel, Lean Canvas, and what a strategy is not

Rumelt's kernel is the one-page strategy artifact: **diagnosis → guiding policy → coherent
actions**; bad strategy is "fluff, excessively complex language, and the conflation of
goal-setting with strategy" [S28] P2. `strategy-kernel.md` must contain the three sections; a gate
can check presence and length, not truth (§13) — the kernel is re-examined whenever K6 fires.

Canvas election at idea stage: **Lean Canvas** (Maurya, 2010), which swaps the Business Model
Canvas's Key Partners / Key Activities / Key Resources / Customer Relationships for Problem /
Solution / Key Metrics / Unfair Advantage — "pursuing key partnerships from day one can be a form
of waste" [S11][S12] P1. The **Business Model Canvas** (Osterwalder 2004 thesis / 2010 book, nine
blocks) describes a model that already exists and is criticised as "static", blind to strategy
change and industry structure [S9][S10] P1/P2 — use it after revenue, not before. Both are
time-boxed sketches, never polished deliverables. SWOT is admitted only as an input list to the
diagnosis: "no-one subsequently used the outputs" is its recorded failure mode [S31] P2.

## §3 North Star and the KPI tree

Amplitude's test for a North Star: aligns to customer value, represents the product strategy, is a
leading indicator; pick the **game** first — attention, transaction, or productivity — then one
North Star and **3–5 input metrics** [S7] P1. DAU and registrations are vanity North Stars [S7].
The AARRR pirate-metrics funnel (Acquisition → Activation → Retention → Referral → Revenue,
McClure [S24] P1) hangs under the tree as the per-stage conversion view; McClure's example numbers
are illustrative, never benchmarks.

For this studio (productivity game, harness proposal per [S7]'s framing): North Star =
**accepted-milestone revenue per month**; inputs = qualified leads/month, proposal win rate,
billable utilisation, milestone first-pass acceptance, repeat/expansion revenue share. A hardware
product line runs the transaction game: North Star = units commissioned and reporting in the
field; inputs = units shipped, week-1 activation, RMA rate, gross margin per unit, reorder rate.

Ledger form: `board/plan.csv` rows `kpi_id,name,unit,direction,role,period,plan` with exactly one
`role: north_star` and 3–5 `role: input` rows per period, plus one `role: quarter_plan` revenue
row per coming quarter (the pipeline-coverage denominator, §6); actuals land in
`board/kpi_actuals.csv` (`kpi_id,period,actual,recorded_on,source` — `source` names the ledger
the number was derived from, so a KPI is a derivation, not an assertion). Changing the North Star
rebuilds the tree, the OKRs and every board exhibit — Amplitude gives it a playbook chapter
[S8] P1 — so the choice is an ADR and an early irreversible (§12).

## §4 OKRs — cadence and grading

Google re:Work / Doerr: **3–5 objectives, ~3 (≤ 5) key results each**, graded **0.0–1.0** at
quarter end, annual + quarterly cadence [S5][S6] P1. The **sweet spot is 0.6–0.7**; a consistent
1.0 means the objectives were not ambitious [S5] P1. File form: `board/okrs/<year>-Q<n>.yaml`
rows `objective · kr · baseline · target · current · score · graded_on`.

Mechanical flags (gate candidates; thresholds **policy** on Google's scale):
- objectives outside 3–5, or any objective with > 5 KRs;
- quarter ended with no `graded_on`;
- average ≥ 0.9 → "targets too easy"; average ≤ 0.3 → re-plan; **< 0.3 two quarters running is
  pivot row K6** (§9);
- KRs that are activities, not outcomes ("ship X" with no metric) — flagged for human review;
  OKR theatre cannot be fully mechanized.

## §5 The board pack — generated in Sequoia order, pre-read, fresh

Cadence: boards meet "four to six times per year" with materials "one to two days in advance"
[S4] P1 — `$guild board` runs **every 6–12 weeks**. Early boards spend "less than 5 % of
[their] time on governance … 95 % … on strategy and product market fit", size 3–7 (Blumberg
[S22] P2). Pre-priced-round companies on SAFEs owe no board seat ("SAFEs carry no board seats;
investors who want one negotiate a side letter" [S23] P3) — so the studio starts with an advisory
board on FAST terms (§10) and a self-imposed cadence; the discipline is the point, not the seat.

Sequoia's meeting arc — **big picture** (15 min) → **calibration** exhibits (45–60) → **company
building** (30) → working sessions (30/topic) → **closed session** (15), with pre-reads so the
meeting is "discussing rather than presenting" [S4] P1 — maps onto a pack the loop derives from
ledgers. Deck-building is founder-time waste; generation is the answer.

### Run-dir layout (`guild/board-{YYMMDD}-{HHMM}/` — a snapshot, so the pack is auditable)

```
pack.md            the pack (sections below)      meta.yaml   venture, meeting_date, meeting_time,
kpi_actuals.csv    KPI actuals (recorded_on)                  timezone, generated_at, period,
plan.csv           KPI plan + quarter_plan rows               next_period, as_of
cash_ledger.csv    monthly bank actuals (month_end, opening_cash, revenue_in, other_in,
deals.csv          pipeline (or pipeline.tsv)                 expenses_out, closing_cash)
milestones.csv     delivery (updated_on)          risks.csv   register (§8)
headcount.csv      people (month_end, plan, actual)           decisions.tsv + premortems.csv (§7)
kill-criteria.csv  K-rows (§9)                    founders-agreement.yaml (§1)
```
Every CSV/TSV/meta carries `# as_of: YYYY-MM-DD` as its first line; all date comparisons run
through `guild_today` — never the system clock.

### Section contract (checked by `score-guild.sh board <run-dir>`)

| Section | Derived from | Required content |
|---|---|---|
| A. Big picture | narrative (human) | ≥ 3 highlight bullets, ≥ 3 lowlight bullets, ≤ 3 asks ("where the company needs help") |
| B1. KPIs vs plan | kpi_actuals × plan | one row per plan KPI: actual, plan, variance % = (actual−plan)/plan, trend vs prior period; the North Star marked; 1 north_star + 3–5 inputs |
| B2. Cash & runway | cash_ledger | `cash_now`, `net_burn_avg_3m`, `runway_months` (= cash ÷ avg 3-month net burn, or cash-positive), `DEFAULT_ALIVE`, `months_to_zero` (§6) + the **monthly waterfalls** of revenue, burn, cash balance and headcount Sequoia asks for [S4] |
| B3. Pipeline | deals | `weighted_pipeline` (Σ amount × probability over open deals), `next_quarter_plan`, `coverage` (§6), `stale_rows` (no activity > 30 d) |
| B4. Delivery | milestones | `milestones_delivered`, `on_time_pct` (delivered ≤ committed) |
| B5. People | headcount | `headcount_actual` / `headcount_plan` (K7 watches the delta) + monthly waterfall |
| B6. Risks | risks | the top-5 by probability × impact **and every row with score ≥ 16**, each with owner, trigger, next_review ≤ 30 d and not overdue (§8) |
| B7. Decisions & asks | decisions | every `proposed` ADR with owner, decide-by date, money/legal flag (§7) |
| C. Company building | roadmap/org | present and dated |
| D. Closed session | — | human; never generated, never read by the loop |

Verdicts: **STALE** when any freshness ledger's latest row date is more than **31 days** before
`meeting_date`, or `generated_at` is less than **48 h** before the meeting (the pre-read window,
Sequoia's "one to two days" [S4]; 31 d staleness = **policy**: a monthly ledger one cycle old).
**INCOMPLETE** when a section or a required derived line is missing or disagrees with its ledger.
**STALE wins over INCOMPLETE** — stale inputs poison every section, so freshness is reported
first; both reason lists still land on stderr. `plan.csv` and `decisions.tsv` are presence-checked
but not freshness-checked: a plan is a commitment and a decision log is append-only history.

## §6 Default-alive, runway, and pipeline coverage

Paul Graham's question: "Assuming their expenses remain constant and their revenue growth is what
it has been over the last several months, do they make it to profitability on the money they have
left?" [S1] P1. Founders "start asking too early" is the wrong risk — the question becomes
relevant around 8–9 months in [S1]; the harness recomputes **monthly from month 6** (**policy**).

Mechanized simulation (inline in the `board` gate — no dependency on the economics `alive` gate;
the two implement the same definition and the pack's B2 lines must agree with the ledger):
- expenses held **constant** at the trailing 3-month average of `expenses_out`;
- revenue starts at the last month's `revenue_in` and compounds at the trailing rate over
  `GUILD_ALIVE_GROWTH_MONTHS` (3; smooth lumpy services months by raising it to 6);
- `other_in` (grants, founder loans) is excluded — one-off inflows are not growth;
- simulate month by month: **DEFAULT_ALIVE = 1** iff revenue ≥ expenses before cash < 0, else
  **DEFAULT_DEAD** with `months_to_zero`; a solvent run past the 120-month horizon counts alive.

`runway_months` = closing cash ÷ average 3-month **net burn** (expenses − revenue − other); a
negative net burn prints `cash-positive`. **The fatal pinch**: DEFAULT_DEAD + slow growth + not
enough time to fix it [S1]. `months_to_zero ≤ 6` auto-opens a **fatal-pinch ADR** (cut expenses
or raise; **hiring freeze** until DEFAULT_ALIVE) that a human must accept — kill row K1 (§9).
"Overhiring is by far the biggest killer of startups that raise money" [S1] P1, hence K7:
headcount above plan blocks hiring while default-dead. Investor interest needs "steep revenue
growth, say over 5x a year" and is unreliable even then [S1] — the plan of record is the ledger,
not a term sheet.

**Pipeline coverage** = weighted open pipeline ÷ next-quarter revenue plan (`quarter_plan` row).
Floor **2×** (**policy**; brief 06's coverage = 1/win-rate refines it once ≥ 20 outcomes exist).
Coverage below floor is K4: a marketing/sales sprint precedes any hire.

## §7 The decision log — ADRs, one-way doors, pre-mortems

Nygard's ADR discipline [S13] P1, adr.github.io [S14] P1: one or two pages; title, context,
decision ("We will …"), status, consequences; ids **numbered monotonically and never reused**;
**superseded records are retained, never deleted** — the log is history, not documentation of the
present. Ledger form `board/decisions.tsv` (validator `score-guild.sh decisions`):

```
id  date  title  status  context  decision  consequences  owner  money_or_legal_effect
reversibility  premortem_ref  signed_artifact  review_date  outcome
```
- `status ∈ proposed | accepted | deprecated | superseded-by:ADR-<n>` — the target must exist and
  be a later id;
- `consequences` items are `+` / `-` / `~` prefixed and must include at least one positive AND one
  negative — Nygard: consequences are "positive, negative, and neutral"; most teams list only
  positives [S13];
- **`money_or_legal_effect = true` ⇒ a `signed_artifact` (evidence:<path>) must exist before
  `status = accepted`** — a SAFE, loan, lease, hire, MSA, filing or election is accepted only as a
  signed instrument (§11);
- **`reversibility = one-way` ⇒ `premortem_ref` = `PM-<n>`** resolving in
  `board/premortems.csv` (`premortem_id, adr_id, date, failure_reason, risk_id, mitigation_ref` —
  one failure reason per row) with **≥ 5 reasons, each linked to an existing risk-register row**;
- `review_date` = decide-by for proposed rows, review date for accepted rows; `outcome` is filled
  at review — the log grades itself.

The pre-mortem (Klein, HBR 2007): assume the plan "has just failed" and list why, run "after a
team has been briefed on a plan" and before the irreversible act [S15][S17] P1 — the licensed way
to voice dissent that planning suppresses. The often-quoted 30 % prospective-hindsight gain
(Mitchell/Russo/Pennington 1989) was not retrievable — UNVERIFIED, do not cite it. Representation
is deliberately a ledger (reasons linked to risk rows), not prose, so the `decisions` gate can
count and join it.

## §8 The risk register

PMBOK/PRINCE2/ISO 31000 fields [S33] P2, ledger form `board/risks.csv`:
`id, category, description, probability (1–5), impact (1–5), score, trigger, owner, mitigation,
contingency, status, last_reviewed, next_review`. Mechanics:
- **score = probability × impact** (the gate recomputes; a hand-edited score is a violation);
- **no row without an owner and a trigger** — "becomes a graveyard without owners, triggers, and
  review dates" [S33];
- `next_review` ≤ **30 days** after `last_reviewed` (**policy**: one board cycle) and never in
  the past vs `guild_today` — reviewed each cycle;
- rows with **score ≥ 16** must appear in the board pack's B6 alongside the top-5 (**policy**:
  4×4 on a 5×5 grid);
- `status ∈ open | mitigating | monitoring | closed`; closed rows keep their history and leave
  the review treadmill.

## §9 Pre-committed kill/pivot rows and the board verdict

Written into `board/kill-criteria.csv` (`row, metric, operator, threshold, decide_by,
verdict_if_breached, action, source, status, breached_on`) **before** the period starts —
Ries's own gate is qualitative ("If and only if we can't find any market for our current vision is
it appropriate to change it" [S25] P1), so the rows exist to force the conversation on a date,
with numbers chosen while heads were cool.

| Row | Metric | Threshold | Decide-by | Breach → | Source |
|---|---|---|---|---|---|
| K1 | default-alive flag | DEFAULT_DEAD ∧ months_to_zero ≤ 6 | monthly | **KILL** unless a human accepts a fatal-pinch ADR (cut or raise) + hiring freeze | PG [S1] P1; 6-mo figure **policy** |
| K2 | PMF survey | < 40 % "very disappointed" on n ≥ 40 | quarter end | **PIVOT** review | Ellis via First Round [S27] P2; n = 40 **policy** |
| K3 | paying customers | 0 signed, paid invoices by date D | D set at plan time | **PIVOT**: stop build, restart discovery | Ries [S25] P1 (qualitative); date rule practitioner consensus |
| K4 | pipeline coverage | weighted < 2× next-quarter plan | monthly | sprint before any hire (action) | **policy** |
| K5 | gross margin | below plan floor 2 consecutive months | monthly | pricing/scope ADR (action) | **policy** |
| K6 | OKR average | < 0.3 two quarters running | quarter end | **PIVOT**: strategy-kernel rewrite | Google scale [S5]; 0.3 **policy** |
| K7 | headcount | actual > plan | monthly | hiring freeze until DEFAULT_ALIVE (action) | PG [S1] P1 |

Verdict grammar (`references/metrics.md`; issued by `$guild board`, computed from the rows):
- **CONTINUE** — no kill row breached; DEFAULT_ALIVE or a funded plan; pack fresh (`BOARD_PACK: OK`).
- **PIVOT** — a pre-committed pivot row breached (K2, K3, K6). The pivot ADR must name the
  **retained learning** and the **pivot type** — Ries: "pivot, don't jump to a new vision";
  his 2009 catalog names segment, customer-problem and feature pivots [S25] P1 (the 10-type book
  list was not retrievable — UNVERIFIED, cite the three).
- **KILL** — K1 breached with no accepted fatal-pinch ADR, or the founders' own kill date row.

A `PIVOT`/`KILL` verdict is a decision **proposed** to humans: the loop writes the ADR draft,
never accepts it.

## §10 Funding instruments and the Philippine time-gates

Every instrument is an ADR with `money_or_legal_effect = true` — accepted only with a signed
artifact, and only after the founders' agreement validates (§1).

**SAFE** (YC, 2013; post-money standard since 2018 [S2] P1): no interest, no maturity, no board
seat. Use the **unmodified YC form**; investor-specific terms (pro rata) go in a **side letter**,
never edits to the instrument; issuance requires **board approval** and accredited investors
[S2]. Post-money math is permanent: "$500k on a $6.7M post-money cap is about 7.5 %, and $1M on
the same cap is about 15 %" [S2]; discount variant "typically 10–20 %" [S2]; stacked SAFEs
compound dilution before any priced round — model the cap table before each one (§12).

**Advisors — FAST** (Founder Institute [S21] P1): equity by stage — Standard 0.50 / 0.25 /
0.10 %, Expert 1.00 / 0.75 / 0.50 % (pre-seed / seed / Series A) — **2-year vest, 3-month
cliff**, and a trial of **≥ 1 month and ≥ 8 hours** of working together before signing; the cliff
exists so "unproductive relationships can be ended within the initial three months without equity
allocation obligations" [S21]. Advisors are not fiduciaries.

**Revenue-based financing** (Lighter Capital, vendor terms [S34] P1): repaid as a % of monthly
revenue to a cap "expressed as 1.x" (example 1.2×); eligibility ≥ $15K MRR or $200K ARR and
growing, gross margin > 50 %, 12–18 months runway. PH availability UNVERIFIED.

**Philippine ecosystem — time-gates a two-founder studio actually faces** (all retrieved
2026-09-02; brief 11 §4):

| Source | Terms | Gate |
|---|---|---|
| RA 11337 (Innovative Startup Act, 2019) [S35] P1 | Startup Grant Fund (DOST/DICT/DTI), Startup Venture Fund (DTI/NDC), startup visas, registration subsidies | IRR dated 2021-10-06; per-agency SGF amounts **UNVERIFIED** (the PHP 500k–1M figure is a snippet) |
| SB Corp **Business Expansion Financing** [S43] P1, [S44] P2 | PHP 50,000–3,000,000; 0 % interest first 12 months then 1 %/month diminishing; ≤ 3 years + 6 months grace | **3–11 months of operation with ≥ 3 months of proven sales** — the earliest institutional money on the clock |
| SB Corp PO Financing [S43] P1 | up to 80 % of PO, max PHP 20,000,000; 1 % per 30 days | ≥ 1 year of operation + ≥ 3 consummated POs |
| SB Corp Venture Capital Program [S43] P1 | PHP 500,000–5,000,000 equity-type, 5–10 years | must be a **corporation**, not a sole proprietorship (§12) |
| NDC/DTI **Startup Venture Fund** [S36][S37] P1 | US$10M / PHP 500M allocation (2023); accredited co-investment partners incl. Gobi, Foxmont, Kaya, IdeaSpace | **≥ 1 year operating track record**, PH-registered, an MVP; "a Co-Investment Partner is needed" and the SVF "cannot invest alone and cannot be the lead investor" — never plan government money as lead |
| **MAIN** (Manila Angel Investors Network) [S38] P1 | pre-seed to Series A; 100 members, 30+ portfolio | ticket sizes unpublished — **UNVERIFIED** |
| **IdeaSpace** [S41] P1 | accelerator: **$10K USD for 1 % equity**, 3-month program, five pre-seed startups near first revenue; Opportunity Fund needs ≥ 6 months of traction | eligibility windows are program facts, verify per cohort |
| **QBO Innovation Hub** [S42] P1 | division of IdeaSpace; DTI/DOST/J.P. Morgan partners; WORQSHOP, SHOWQASE, INQBATION | the circulating "PHP 2B fund for 200 deep-tech startups" is absent from QBO's own site — **treat as false until QBO publishes it** |

**The aggregator rule:** a funding fact enters the register only from the organisation's own site,
the Official Gazette or the statute text; **aggregator claims are not facts** — P3 rows are
context, never gates [brief 11 §7]. Market context, same discipline: PH VC funding $1.12B in 2024
(Foxmont, a fund's own claims [S40] P1); H1 2025 equity funding "$86.4 million (down 55 percent
YoY)" (Kickstart via TechNode [S39] P2). Secondary seed folklore (Series A ≈ $3.5M ARR, ~20 %
seed→A [S23] P3) is context only. Implication: the only money without a ≥ 1-year clock or a lead
investor is SB Corp Business Expansion (from month 3, with 3 months of sales) and angel /
accelerator money (MAIN, IdeaSpace $10K/1 %) — so the venture's funding plan is a dated row per
instrument with its clock start, not a wish list.

## §11 Human sign-off rows (the loop never marks these pass)

- Signing the founders' agreement, any amendment, and the IP assignment (§1).
- Issuing any instrument: SAFE (board approval required [S2]), loan, grant application, advisor
  grant, shares, debt — send/spend/sign/file stays human-gated.
- Accepting a fatal-pinch ADR, a pivot ADR, a kill decision, or any one-way-door ADR.
- Hiring or terminating; anything that moves `headcount.csv` (K7 watches the plan delta).
- The closed session and feedback to founders [S4] — never generated, never read.
- The pivot/persevere judgement itself: Ries's test is judgment about frustration and market
  [S25]; the rows only force the conversation (§5.9 of brief 11).

## §12 Early irreversibles (charter rows with decide-by dates)

1. **Equity split and vesting terms** — fixed at founding; the cliff is the only cheap undo [S3].
2. **IP assignment to the company** — must precede the first customer deliverable.
3. **Corporate form and registration** — SB Corp VC requires a corporation [S43]; SVF requires PH
   registration [S36]; the ≥ 1-year ecosystem clock starts at registration.
4. **First SAFE valuation cap** — post-money math is permanent; stacking compounds [S2].
5. **Board composition and control terms** — rich-vs-king is decided de facto by the first board
   seat or protective provision [S20].
6. **Advisor grants without a cliff** — FAST's 3-month cliff is the escape hatch [S21].
7. **North Star choice** — every KPI tree, OKR and exhibit rebuilds when it changes [S8].
8. **Hiring ahead of default-alive** — payroll is the least reversible expense [S1].

## §13 Failure modes this protocol guards against

| Anti-pattern | Guard |
|---|---|
| Asking "default alive?" too late; entering the fatal pinch | K1 recomputed monthly from month 6 [S1] |
| Overhiring after a raise | K7: headcount > plan blocks hiring unless DEFAULT_ALIVE [S1] |
| Handshake split, no vesting or cliff | §1 gate blocks external money [S3] |
| Rich-vs-king never stated, fight at the first investor | decision_rights + departure_terms required [S18][S20] |
| Vanity North Star (DAU, registrations) | KPI tree declares the game and the value event [S7] |
| OKR sandbagging (all 1.0) or activity KRs | §4 score bands; 0.6–0.7 sweet spot [S5] |
| "Strategy" that is fluff or a goal list | kernel must contain diagnosis / guiding policy / coherent actions [S28] |
| SWOT lists that feed nothing | admitted only as diagnosis input [S31] |
| Key partnerships chased before a validated problem | Lean Canvas (no partners box) at idea stage [S12] |
| Board meeting as presentation; deck as founder-time sink | pack generated from ledgers; 48 h pre-read gate [S4] |
| Early board doing governance instead of strategy/PMF | agenda weights working sessions [S22] |
| Editing the SAFE text | unmodified YC form + side letter only [S2] |
| Advisor equity on day 1 without a trial | FAST ≥ 1 month / ≥ 8 h + 3-month cliff [S21] |
| "Jumping to a new vision" instead of a grounded pivot | pivot ADR names retained learning + pivot type [S25] |
| Dissent suppressed in planning | mandatory pre-mortem on one-way doors [S15][S17] |
| Risk register as a graveyard | owner + trigger + 30-day review, score ≥ 16 into the pack [S33] |
| Rewriting or deleting old decisions | ADR ids never reused; superseded rows retained [S13] |
| Planning on government money as lead | SVF cannot lead; CIP required first [S36] |
| Treating aggregator claims as facts | §10 aggregator rule; org's own site or gazette only |
| Stale exhibits steering a live meeting | 31-day staleness + 48 h pre-read → `BOARD_PACK: STALE` |

## §14 What the governance gates block

- A board pack with a missing section, a number that disagrees with its ledger, a source ledger
  older than 31 days at the meeting, or generation inside the 48 h pre-read window (`board`).
- An ADR with a reused or non-monotonic id, an unknown status, a dangling `superseded-by`, a
  consequences cell with no downside, a money/legal decision accepted without a signed artifact,
  or a one-way door without a 5-reason risk-linked pre-mortem (`decisions`).
- A risk row without an owner or trigger, a hand-edited score ≠ probability × impact, or a review
  date beyond 30 days / in the past (`decisions`).
- Any external-money step while `founders` reports INVALID: split ≠ 100, vesting off the 4 y /
  12 m default with no ADR, IP unassigned, roles / decision rights / departure terms missing, or
  the agreement unsigned (`founders`).
- A `CONTINUE | PIVOT | KILL` verdict issued from sentiment: the verdict is computed from K-rows
  and the pack, and the pack must be `OK` first (`$guild board`).

## Sources

`[S1]`–`[S47]` follow the source numbering of
`research/raw/11-governance-strategy-board.md` §8 (all retrieved 2026-09-02): S1 Paul Graham
default-alive · S2 YC SAFE documents · S3 YC equity split · S4 Sequoia board deck · S5 Google
re:Work OKRs · S6 Doerr/What Matters · S7 Amplitude North Star · S8 Amplitude playbook · S9/S10
Strategyzer/Wikipedia BMC · S11/S12 Maurya Lean Canvas · S13 Nygard ADRs · S14 adr.github.io ·
S15/S16/S17 Klein pre-mortem · S18/S19/S20 Wasserman · S21 FI FAST · S22 Blumberg · S23 PMF.show
(P3) · S24 McClure AARRR · S25/S26 Ries pivot · S27 First Round / Ellis 40 % · S28 Rumelt · S31
SWOT · S33 risk register · S34 Lighter Capital RBF · S35 RA 11337 · S36 NDC SVF · S37 Gobi-Core
CIP · S38 MAIN · S39 Kickstart/TechNode · S40 Foxmont · S41 IdeaSpace · S42 QBO · S43 SB Corp ·
S44 Philstar SB Corp. UNVERIFIED items stay UNVERIFIED here — never invent a number the brief
does not carry.
