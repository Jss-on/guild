---
name: guild:board
description: "BOD cadence every 6–12 weeks: board pack derived from ledgers (KPIs vs plan, cash/runway/DEFAULT_ALIVE, pipeline coverage, delivery, headcount, risks, decisions due) → decision log → kill/pivot rows → CONTINUE | PIVOT | KILL"
argument-hint: "[Venture: <dir>] [Meeting: YYYY-MM-DD] [--dry-run]"
---

EXECUTE IMMEDIATELY.

The **standing board** of the pipeline. Reads the venture's ledgers, derives the board pack in
Sequoia order, evaluates the pre-committed kill/pivot rows, and issues `CONTINUE | PIVOT | KILL`
from numbers — never from sentiment. Issuing the verdict is mechanical; **acting on it is human**:
the loop never sends, spends, signs, or files, and the closed session plus every hiring, funding
or pivot decision stays with the humans. Contract: `references/governance-protocol.md`;
verdict grammar: `references/metrics.md`.

## Seam & reference resolution (read once)

Resolve `GUILD_ROOT` as in SKILL.md (plugin root → `.claude/skills$guild` → command-file dir →
glob fallback). Read every `scripts/<x>` as `$GUILD_ROOT/scripts/<x>` (repo-root `scripts/` when
running inside this harness repo) and every `references/<x>` as `$GUILD_ROOT/references/<x>`.
Run `bash scripts/doctor.sh` once; stop if BLOCKED.

## Parse arguments

- `Venture:` — the venture tree (default: cwd if it holds `board/` + `economics/`, else ask).
- `Meeting:` — the meeting date (default: the nearest date ≥ 48 h + one weekday out; the pack
  must exist ≥ 48 h before the meeting — the pre-read window).
- `--dry-run` — print the pack outline (sections A–C, the ledger each derives from, the K-rows
  that would be evaluated, freshness of every source ledger) and exit without writing a run dir.

**Cadence:** every **6–12 weeks** (Sequoia: 4–6 meetings/year, materials 1–2 days ahead). If the
last `guild/board-*/handoff.json` is older than 12 weeks, say so in the pack's A section.

## Run directory

`guild/board-{YYMMDD}-{HHMM}/` — a **snapshot**: copy/derive the source ledgers into the run dir
so the pack is auditable against the exact rows it came from (layout in
`references/governance-protocol.md` §5): `meta.yaml` (venture, meeting_date, meeting_time,
timezone, generated_at, period, next_period, as_of; `# as_of:` first line), `kpi_actuals.csv`,
`plan.csv`, `cash_ledger.csv` (monthly actuals; derive from `economics/cash13.csv` actuals if no
monthly ledger exists), `deals.csv` (from `gtm/pipeline.tsv`), `milestones.csv` (from `ops/`),
`headcount.csv`, `risks.csv`, `decisions.tsv`, `premortems.csv`, `kill-criteria.csv`,
`founders-agreement.yaml` — plus the outputs `pack.md`, `kill-evaluation.tsv`,
`board-results.tsv`, `handoff.json`.

## Phase 1 — Read the ledgers (venture tree)

Load the board ledgers above. Missing ledger → name it and what human enters it; the loop may
draft candidate rows into `drafts/`, never into human-entered ledgers. Anchor "today" via
`guild_today` (`# as_of:`/`GUILD_TODAY`) — never the system clock.

## Phase 2 — Compute the calibration numbers

All mechanical, all reproduced later by the `board` gate (its `derived:` stderr line is the
generator seam — use it):
1. **KPIs vs plan** — actual/plan/variance/trend per KPI for `period`; the North Star marked;
   1 north_star + 3–5 inputs.
2. **Cash & runway** — cash_now, avg 3-month net burn, `runway_months` (or cash-positive).
3. **DEFAULT_ALIVE** — the PG simulation (expenses flat at the 3-month average, revenue at the
   trailing compound growth): alive iff revenue ≥ expenses before cash < 0, else DEFAULT_DEAD
   with `months_to_zero`. Run `bash scripts/score-guild.sh alive economics/cash_ledger.csv` when
   the economics domain ships it; the board gate recomputes inline either way and the pack's B2
   must agree with the ledger. `months_to_zero ≤ 6` ⇒ draft the **fatal-pinch ADR** (cut
   expenses or raise) and a **hiring freeze** note (K1/K7).
4. **Pipeline coverage** — weighted open pipeline ÷ next-quarter `quarter_plan`; stale rows
   (> 30 d without activity).
5. **Delivery** — milestones_delivered, on_time_pct.
6. **Headcount** — actual vs plan (K7 watches the delta) + monthly waterfalls of revenue, burn,
   cash and headcount.
7. **Risk register** — top-5 risks by probability × impact and every score ≥ 16, each with
   owner/trigger and a review inside 30 days.

## Phase 3 — Generate the pack

Write `pack.md` in Sequoia order — A big picture (≥ 3 highlights, ≥ 3 lowlights, ≤ 3 asks;
narrative is the ONE human-written part), B1–B7 calibration with the machine lines the gate
checks, C company building (dated roadmap/org), D closed session (a heading only — human, never
generated). Then gate it:

```
bash scripts/score-guild.sh board guild/board-{ts}/     # must print BOARD_PACK: OK
```
`STALE` (a ledger > 31 d before the meeting, or generated < 48 h pre-read) → list the stale
ledgers and the humans who own them, fix generation timing if that was the cause, and stop
BLOCKED if human rows are missing — the loop never fabricates freshness. `INCOMPLETE` → fix the
pack derivation and regenerate. A blocked run writes no verdict: its handoff is intentionally
INVALID until the humans refresh the ledgers.

## Phase 4 — Decisions due + kill/pivot rows

1. **Decision log** — every `proposed` ADR with owner + decide-by into B7; draft any ADRs this
   pack implies (fatal pinch, pricing/scope on K5, sales sprint on K4) into `drafts/`; then
   `bash scripts/score-guild.sh decisions board/decisions.tsv board/risks.csv` → must print
   `GOVERNANCE_VIOLATIONS: 0` (reused ids, unsigned money/legal ADRs, one-way doors without
   pre-mortems, ownerless risks all block).
2. **Founders' agreement** — if any funding ADR is on the table:
   `bash scripts/score-guild.sh founders board/founders-agreement.yaml` must print VALID first
   (the gate before any external money).
3. **Kill/pivot rows** — evaluate every row of `kill-criteria.csv` (K1–K7) against the computed
   numbers; write `kill-evaluation.tsv` (`row metric value threshold breached decide_by
   verdict_if_breached action`).

## Phase 5 — Verdict (numeric criteria, from metrics.md)

- **KILL** — K1 breached: DEFAULT_DEAD ∧ months_to_zero ≤ 6 ∧ no accepted fatal-pinch ADR in
  `decisions.tsv`; or the founders' own kill-date row.
- **PIVOT** — a pre-committed pivot row breached: PMF < 40 % on n ≥ 40 (K2), zero paid invoices
  by date D (K3), OKR average < 0.3 two quarters running (K6). The drafted pivot ADR must name
  the **retained learning** and the **pivot type** (segment / customer-problem / feature).
- **CONTINUE** — no kill row breached, DEFAULT_ALIVE or a funded plan, pack fresh
  (`BOARD_PACK: OK`). K4/K5/K7 breaches don't change the verdict; they attach mandatory actions
  (sales sprint, pricing ADR, hiring freeze) to B7.

Print the verdict banner and the one-line why. Log rows to `board-results.tsv`
(`n dimension assertion status weight evidence traces` — governance dimension) for evals.

## Phase 6 — Handoff

Write `handoff.json` (schema v3.1.0): `version`, `source: "board"` (short name, never the colon
form), `status: COMPLETE`, `timestamp`, **`verdict: CONTINUE|PIVOT|KILL`**, **`pack:
guild/board-{ts}/pack.md`**, plus `decisions_tsv`, `default_alive`, `months_to_zero`,
`kill_rows_breached`. Validate: `bash scripts/validate-handoff.sh guild/board-{ts}/handoff.json
board` → `HANDOFF: VALID`. The run is not finished until it validates.

## Safety invariants

- The pack is **derived from ledgers**; the loop never edits `gtm/pipeline.tsv`,
  `cash_ledger.csv` actuals, `risks.csv` reviews or any human-entered ledger — candidate rows go
  to `drafts/`.
- **Never send, spend, sign, or file.** Accepting ADRs, issuing instruments (SAFE/loan/grant),
  hiring, the pivot judgement and the closed session are human sign-off rows the loop never marks
  pass.
- Verdicts come from the pre-committed numeric rows; a red gate is reported, never papered over.
