# Venture Requirements Protocol — the VRS, the validation ladder, and the discover → build contract

Companion to `$guild discover` Phase 4 and the entry gate of `$guild build`. The Venture
Requirements Spec (VRS) is the business analogue of anvil's HRS: every load-bearing assumption
becomes a **`V-n` row** — a "We believe" statement with a metric, a threshold with a direction, a
test method on the validation ladder, an owner and a decide-by date — and the venture spec's
acceptance rows trace back to those ids. Research basis: brief 01
(`research/raw/01-customer-discovery.md`, `[S#]` = its §8 list) and brief 03
(`research/raw/03-positioning-offer.md`, cited `03[S#]`); grades P1/P2/P3 as in the briefs.
Gate owned here: `vrs` (`scripts/gates/vrs.sh`); consumers: `score-guild.sh coverage` (the RTM)
and `score-guild.sh validate` (the spec contract).

## §0 The four rules

1. **No assumption without a metric.** "We think owners will love it" is not a row. Every V-n
   names what is counted, in what unit, over what population and period.
2. **No metric without a threshold that has a number and a direction.** "High conversion" is an
   adjective; `≥ 3 paid pilots signed by 2026-11-30` is a threshold. Direction means a comparator:
   ≥, ≤, >, <, =, "at least", "at most", "within", "between".
3. **No threshold without a test method on the validation ladder** (§3) — and no method stronger
   on paper than in fact: the declared evidence grade is capped by what the method can yield.
4. **The riskiest assumptions are tested by doing, not asking.** The three lowest risk ranks must
   carry a do-class method — paid pilot, LOI, pre-order/deposit, or another money/reputation
   commitment. Desk research or a survey on the riskiest assumption fails the gate [S11][S12].

A V-n row is a **hypothesis, not a requirement to build**: it graduates to `supported`, dies as
`refuted`, and either way produces a recorded learning. The build inherits only what survived.

## §1 The V-n row — anatomy and file format

`vrs/requirements.md` is a markdown document; each row is one fenced ` ```vrs ` block (prose,
headings and tables around the blocks are free-form; `score-guild.sh coverage` reads the `V-n`
ids, the `vrs` gate reads the blocks):

```
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
```

| Field | Meaning | Rule |
|---|---|---|
| `id` | `V-<n>`, stable, unique | referenced by claims (`rq`), experiments, acceptance rows (`traces:`) |
| `statement` | the assumption, verbatim from `discovery/assumptions.csv` | starts `"We believe"` — a hypothesis to test, not a fact [S13] |
| `type` | `D` desirability · `F` feasibility · `V` viability · `A` adaptability | one letter [S13] |
| `metric` | what is counted: unit, population, period | non-empty; countable |
| `threshold` | pass line | a number AND a direction; adjectives fail |
| `method` | the test method (`verify:` in anvil's dialect) | on the ladder, §3 |
| `evidence_grade` | `strong` / `moderate` / `weak` | ≤ the method's ceiling, §3 |
| `risk_rank` | 1 = riskiest (from the assumption map's importance × evidence) | positive integer, no ties |
| `owner` | the named human accountable for running the test | non-empty |
| `decide_by` | the date the row must be dispositioned | `YYYY-MM-DD`; a deadline, not a wish |
| `status` | `open` / `supported` / `refuted` | optional; overdue open rows are flagged |

Thresholds are the venture's own pass lines, so they carry no `[C-n]`; the **baselines that
justify them do** — put them in rationale lines under the block ("three money commitments already
exist [C-12]") where the `citations` gate patrols them.

## §2 Measurability — what `score-guild.sh vrs <vrs.md>` checks

Emits `VRS_MEASURABLE: x/y` (x = rows passing every check, y = fenced rows found); every failure
is named on stderr with the row id.

| # | Check | Fails when |
|---|---|---|
| 1 | id `V-n`, unique | missing, malformed, duplicated |
| 2 | statement starts "We believe" | stated as a fact |
| 3 | `type ∈ D\|F\|V\|A` | anything else |
| 4 | metric non-empty | missing |
| 5 | threshold has a number | `high`, `good`, `strong` — an adjective is not a threshold |
| 6 | threshold has a direction/comparator | `3 pilots` with no ≥/≤/at-least |
| 7 | method on the ladder (§3) | `gut_feel`, `benchmark`, off-ladder strings |
| 8 | evidence_grade ∈ strong/moderate/weak AND ≤ method ceiling | an `interview` row claiming `strong` |
| 9 | owner present | anonymous rows |
| 10 | decide_by `YYYY-MM-DD` | missing or malformed deadline |
| 11 | risk_rank positive integer, no ties | missing rank; two rows both "rank 2" |
| 12 | the `GUILD_VRS_TOP_DO` (3) lowest ranks carry a do-class method | riskiest row on desk/survey/interview |

Informational (stderr): a `V-n` mentioned in prose without a block (coverage would expect a row);
`decide_by` past `as_of` while still `open`.

## §3 The validation ladder — evidence strength by test method

Ordered by the strength of the evidence the method can produce (brief 01 §5 G5; Strategyzer's
say/do and strong/weak grading [S11][S12]; "Do > Tell", 03[S18]):

```
paid pilot  >  LOI  >  pre-order / deposit  >  commitment  >  interview  >  survey  >  desk
└────────── do-class (behaviour / stake) ──────────┘        └───── say-class (words) ─────┘
```

| Method | What it is | Evidence kind | Grade ceiling |
|---|---|---|---|
| `paid_pilot` | money changed hands for a scoped trial with a pre-fixed metric | behaviour | **strong** |
| `pre_order` (deposit) | money at stake before the product exists | behaviour | **strong** |
| `LOI` (letter of intent) | signed intent — reputation on the line, no cash yet | intent | **moderate** |
| `commitment` | time or reputation staked: buyer introduction, observation shift, next meeting with the signer | intent | **moderate** |
| `interview` | consented Mom-Test conversation about past behaviour | opinion / reported behaviour | **weak** |
| `survey` | structured say-data; n > 30 or it is anecdote [S12] | opinion | **weak** |
| `desk` | analysis, models, benchmarks, prototypes measured in-house | analysis | **weak** |

- `strong / moderate / weak = behaviour / intent / opinion`. A row may declare a grade at or
  below its method's ceiling — never above (check 8). Feasibility rows verified by an in-house
  prototype or model are `desk` by this taxonomy: honest about the fact that no customer
  behaviour was observed.
- Mapping to the discovery ledgers: methods correspond to `discovery/experiments.csv` types
  (survey, landing_page, concierge, wizard_of_oz, mock_sale, pre_sale → `pre_order`;
  LOI, paid_pilot) and `discovery/commitments.csv` types (next_meeting, intro_to_buyer →
  `commitment`; LOI, pre_order, deposit, paid_pilot). Every do-class V-n should name (in its
  rationale) the experiment or commitment rows that will disposition it.
- Sequencing: cheap say-tests may run first to sharpen the question, but a riskiest-3 row is not
  `supported` until its do-class test passes (checks 12; [S14][S12]).

## §4 The must-be checklist — assumptions every venture must disposition

Kano's lesson: must-be qualities are the ones nobody states in an interview because they are
assumed — and their absence kills the deal anyway. The VRS therefore carries a fixed checklist;
each item is **dispositioned** as either (a) a V-n row (usually type `A` or `V`), or (b) an
explicit `n/a — <reason>` line in a "Must-be dispositions" table. Silence is not a disposition.

| Must-be item | Why it can kill the venture | Source |
|---|---|---|
| **Payment terms & withholding** | PH corporate clients withhold 2–15 % EWT and issue BIR Form 2307; first-time counterparties expect deposits/L/C, open account only with trust (30–180 d); quotes must say ex-VAT, subject to EWT | 03[S33][S28] (P2/P1) |
| **Compliance posture** | entity, VAT vs 8 % at the ₱3M line, DPA consent for every dataset touched — register rows with deadlines, not vibes | compliance-protocol; brief 01 [S25] |
| **Delivery capacity** | founder hours and build slots are finite; a services promise beyond realistic utilisation is a viability lie | economics-protocol floors (brief 12) |
| **Cash horizon vs market type** | a `new` market can be unprofitable for 5+ years; an existing one should cash in 12–18 months — the runway must match the election | [S2] (P1) |
| **Founder time** | discovery alone needs ≥ 1 interview/week and 15 h/week at I-Corps pace | [S24][S22] (P1) |
| **Decision maker & relationship owner** | PH buying is relationship-first, hierarchy-heavy; no named signer = no deal | 03[S36] (P3) |
| **After-sales expectation (hardware)** | PH partners expect support during AND after warranty — the whole product includes a support tier | 03[S29] (P1) |
| **Procurement route** | government ICP requires PhilGEPS Platinum, LCRB/MEARB rules; TCO stories do not win LCRB | 03[S31][S34][S35] (P1) |
| **Data privacy** | RA 10173 consent on every interview, pilot dataset and contact list | [S25] (P1) |
| **Whole product** | install, training, docs, integrations — "everything needed for a compelling reason to buy" | 03[S11][S12] (P2) |

The must-be checklist is why a VRS with only desirability rows is incomplete: desirability,
feasibility, viability AND adaptability all appear, and the spec's seven acceptance dimensions
(§7) have somewhere to trace from.

## §5 Blank exit criteria — when discovery and validation are DONE

The VRS operationalises Blank's two exit checklists [S3] (P1 deck): each question must be
answerable by pointing at supported V-n rows and ledger evidence — never by narrative.

**Discovery exit** (gates: `interviews`, `icp`; memo `discovery/exit-memo.md`):
1. Top problems known — and how much customers pay today (spend columns, evidence-grade rows).
2. Product concept agreed to solve them — and how much they will pay (WTP signals, commitments).
3. Day-in-the-life drawn, before and after.
4. Org chart of users and buyers drawn (the ICP `roles` block).

**Validation exit** (the build's GTM phase inherits these as gated rows):
1. A proven, repeatable sales roadmap (playbook with stage exits).
2. Org chart + influence map per account.
3. Sales cycle understood: ASP, LTV, ROI.
4. A set of orders ($'s) validating the roadmap — `paying` gate rows, human-entered.
5. A financial model that makes sense — `economics` gate at corners.

Failing validation loops **back to discovery** (the only backward arrow in Blank's process), not
to "sell harder": refuted rows spawn new assumptions and, if segment-fatal, a pivot record.

## §6 Segment + market-type election — the sign-off row

The election (discovery-protocol §13) is the bridge from VRS to spec:

- `discovery/segments.csv` holds at most one `elected = Y` row, with `elected_at`, `elected_by`
  (a named human) and `board_ack`. **The loop proposes; a human elects.** The gate treats an
  election row written by the loop as fabricated evidence.
- Election preconditions: interview quota + evidence-grade share green for the segment, ICP
  trace green, ≥ 3 money-class commitments, `market_type` non-null.
- The elected ICP text becomes `segment: icp:` in the spec — a charter-level early irreversible:
  everything downstream (positioning, pricing, GTM, references) accretes to it, and undoing it
  restarts discovery [S8][S3].
- The market-type hypothesis rides along as a viability row (cash horizon, §4) — electing a
  `new` market without an 18+-month runway plan is a contradiction the board must see.

## §7 From VRS to `venture.spec.yaml` — the validate contract

`$guild discover` may not hand a spec to `$guild build` until `score-guild.sh validate` says
VALID (references/metrics.md):

- `name:` and `thesis:` (or `summary:`) present.
- A top-level `segment:` block with an `icp:` line — the election of §6.
- An `acceptance:` block covering **all seven dimensions** (`evidence`, `customer`, `offer`,
  `economics`, `gtm`, `operations`, `governance`), each with ≥ 1 weighted assertion, and the
  gating/must-pass dimensions (`evidence`, `customer`, `economics`) each carrying ≥ 1
  `gate: true` row.
- Every acceptance row carries `traces: V-n` — the requirements-traceability seam.
  `score-guild.sh coverage --spec venture.spec.yaml vrs/requirements.md` computes
  `REQ_COVERAGE`: every V-n traced by ≥ 1 row, orphan traces named on stderr; the verdict
  requires coverage 1.00.

Skeleton (see `tests/fixtures/spec/valid.spec.yaml` for a full example):

```yaml
name: <venture>
thesis: "<the elected segment> will pay <price basis> for <offer> because <evidenced pain>"
segment:
  icp: "<elected ICP, one line>"
  anti_icp: "<top disqualifier>"
  elected: <date>
  evidence: discovery/icp.yaml
acceptance:
  evidence:
    - { id: EV-1, assert: "unsourced numeric claims == 0", weight: 2, traces: V-1, gate: true }
  customer:
    - { id: CU-1, assert: ">= 12 consented interviews in the elected segment; ICP trace clean", weight: 2, traces: V-1, gate: true }
  # … offer, economics (gate: true), gtm, operations, governance …
```

Handoff: `handoff.json` (schema v3.1.0, `scripts/validate-handoff.sh`, source `discover`) must
carry `spec` and/or `vrs` paths; `--chain build` passes the spec forward.

## §8 Human sign-off rows and early irreversibles

Human-only (the loop drafts, surfaces and never marks pass): the riskiest-assumption scoring
(`scored_by`), the segment + market-type election (§6), every do-class test that sends, spends or
signs (pilot invoices, LOI signatures, deposits), and the decision to proceed to build with any
must-be item dispositioned `n/a`.

Irreversibles fixed at this stage (dossier §6): segment/ICP election and market type (#4), the
counting frame the sizing inherits (#5), paid-vs-free discovery precedent and first-deal payment
terms (#9) — each gets a decide-by date in the charter, never a default.

## §9 Failure modes

| Anti-pattern | Guard |
|---|---|
| Adjective thresholds ("meaningful traction") | checks 5–6: number + direction or fail |
| Riskiest assumption "validated" by a survey | check 12: do-class on the top-3 ranks |
| Grade inflation (interview data called strong) | check 8: ceiling by method |
| Rows nobody owns, deadlines nobody set | checks 9–10; overdue-open flagged |
| A VRS of desirability rows only | must-be checklist §4 + seven-dimension spec §7 |
| Acceptance rows tracing to nothing | `coverage` orphans; verdict requires 1.00 |
| Spec handed to build unvalidated | `validate` exit gate in `$guild discover` Phase 5 |
| The loop electing the segment itself | §6: election is a human sign-off row |

## §10 What the `vrs` gate blocks

- A spec whose assumptions cannot fail: no metric, no threshold, no direction, no date, no owner.
- Evidence theatre: strong grades on say-class methods; the riskiest rows tested at a desk.
- Untraceable builds: acceptance criteria with no `V-n` lineage, V-n rows no acceptance row
  covers, and a build started before `VALIDATION: VALID` and `REQ_COVERAGE: 1.00`.
