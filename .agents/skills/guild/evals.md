---
name: guild:evals
description: "Analyze guild iteration results: trends, plateaus, regressions, funnel and cash trajectories, ratchet breaches — recommendations for the next loop"
argument-hint: "[Run: guild/<subcommand>-YYMMDD-HHMM] [Results: <path to *-results.tsv|iterations.tsv>] [--compare <older run>]"
---

EXECUTE IMMEDIATELY.

The analyst. Reads what the loops wrote and says what moved, what stalled, what regressed and what
to do next. Single pass, no iteration loop, no edits to any venture file.

## Seam & reference resolution (read once)
Resolve `GUILD_ROOT` as in SKILL.md (first existing of `${CLAUDE_PLUGIN_ROOT}/skills$guild`,
`.claude/skills$guild`, the directory containing this command file, else the glob fallback). Run
`bash scripts/doctor.sh`. Contracts: `references/metrics.md` (dimensions, verdict grammars).

## Parse Arguments
- `Run:` — a run directory (`guild/loop-*`, `guild/build-*`, `guild:improve` runs). Default: the
  most recent run directory under `guild/`.
- `Results:` — an explicit `iterations.tsv` or `*-results.tsv` (or `guild-results.tsv`).
- `--compare <older run>` — diff two runs (convergence quality across runs).

## Phase 1 — Inventory
List every run directory with its source, status (`handoff.json` — validated with
`bash scripts/validate-handoff.sh`), metric name, start/end values, iterations, kept/discarded
counts. A run without a valid handoff is reported as INCOMPLETE, never silently skipped.

## Phase 2 — Trajectory analysis (per run)
From `iterations.tsv`:
- **Trend** — metric over iterations (direction-aware); moving average over 5.
- **Plateau** — ≥ 5 consecutive iterations with |delta| < 1 % of range → flag, with the iteration
  where progress stopped and the last three descriptions (what was being tried).
- **Regression** — any `discard`/`crash` cluster (≥ 3 in 5) and any kept iteration later reverted;
  any iteration where the ratchet column is `fail` (evidence, economics or compliance breached).
- **Effectiveness ranking** — the kept changes ordered by delta; the top three named.

From `guild-results.tsv` (build runs):
- **Dimension breakdown** — per-dimension score and weight (`scripts/score-guild.sh pass-rate
  --strict-evidence`), which dimension is capping the verdict, must-pass rows still red.
- **Coverage** — `scripts/score-guild.sh coverage` against the VRS: untraced `V-n`, orphan traces.

From the venture ledgers, when present (read-only):
- **Funnel trajectory** — `scripts/score-guild.sh funnel gtm/pipeline.tsv`: stage counts, stale
  and next-step-less deals, coverage vs win rate; `paying gtm/pipeline.tsv`.
- **Cash trajectory** — `cash economics/cash13.csv economics/variance.csv` and
  `alive board/cash_ledger.csv`: runway, months_to_zero, variance.
- **Pipeline vs plan** — weighted pipeline ÷ next-quarter target, trend over the last three runs.

## Phase 3 — Verdict and recommendations
- Classify the run: `IMPROVING` | `PLATEAU` | `REGRESSING` | `CONVERGED` (metric at target and
  verdict `OPEN_FOR_BUSINESS`/`FIRST_CUSTOMER`) | `BLOCKED` (ratchet red).
- **Recommend** the next action in one line each: which dimension to attack next, which human
  sign-off rows are the actual blocker (interviews not entered, elections pending, professional
  reviews outstanding), whether to stop early (plateau ≥ 3 checkpoints), whether `$guild board`
  is due (last pack > 6 weeks old).
- Never recommend a send, spend, sign, bid or filing — recommend that a human decide it.

## Output
`guild/evals-{YYMMDD}-{HHMM}/evals-summary.md` with the tables above, plus `handoff.json`
(v3.1.0, `source: "evals"`, `status: COMPLETE`, `timestamp`, `results_tsv` = the analysed file,
`findings[]`), validated with `bash scripts/validate-handoff.sh <file> evals`.

Print: run · classification · start → end · kept/total · plateau/regression flags · top-3 changes ·
one-line recommendation.
