---
name: guild
description: "Iterate any venture against a mechanical business metric — modify, verify (citations/interviews/economics/funnel/compliance gates), keep/discard — or route a spec/goal to the right subcommand"
argument-hint: "[Metric: conversion|gross_margin|ltv_cac|cac|payback|utilization|dso|<name>] [Verify: <shell cmd>] [Direction: maximize|minimize] [Scope: <dir>] [Spec: <file>] [Goal: <text>] [Iterations: N]"
---

EXECUTE IMMEDIATELY.

The bare-loop entry point. Print the banner `[guild] mode: classic | build | wizard`, then dispatch:

| Condition | Mode |
|---|---|
| `Metric:` or `Verify:` present | **Classic** — the metric loop below over an existing venture tree |
| `Spec:` file or free-form `Goal:` | **Build** — confirm once, then run `/guild:build` with the same arguments |
| Nothing | **Wizard** — one AskUserQuestion batch: which venture tree, which metric (recommend from the named set), scope dir, iteration budget → then Classic |

## Seam & reference resolution (read once)
Resolve `GUILD_ROOT` as in SKILL.md: first existing of `${CLAUDE_PLUGIN_ROOT}/skills/guild`,
`.claude/skills/guild`, the directory containing this command file, else glob
`**/skills/guild/scripts/score-guild.sh` and take its grandparent. Every `scripts/<x>` below means
`$GUILD_ROOT/scripts/<x>` (repo-root `scripts/` when running inside the harness repo) and every
`references/<x>` means `$GUILD_ROOT/references/<x>`. Run `bash scripts/doctor.sh` first
(`--require-build` when the loop will push to an output repo).

## Safety invariants (from SKILL.md — restated because the bare loop is the least supervised mode)
- Never send, publish, spend, sign, bid or file. A metric that would improve by "sending more
  outreach" improves only when a **human** sends and enters the rows; the loop drafts into
  `drafts/` and surfaces the sign-off row.
- Never write to a human-entered ledger (`discovery/interviews.tsv`, `discovery/consent.tsv`,
  `discovery/commitments.csv`, `offer/pitch_tests.csv`, `pricing/wtp-interviews.csv`,
  `gtm/pipeline.tsv`, `gtm/outreach.csv`, `finance/ar_ledger.csv`, `ops/*` facts,
  `compliance/register.csv` documents, `board/founders-agreement.yaml`). A change that touches one
  is reverted regardless of the metric.
- Not legal, tax, or financial advice: rows with `requires_professional_signoff` stay red until a
  named human signs.

## Classic — the metric loop

**Setup (iteration #0):**
1. Resolve Scope (the venture directory — the tree described in `templates/guild-venture/README.md`;
   ask if ambiguous). Read the in-scope ledgers + git log + any prior `guild/*/iterations.tsv`.
2. Resolve the metric command:
   - Named metric → `scripts/score-guild.sh` subcommand: `conversion` → stage conversion from
     `funnel gtm/pipeline.tsv` (maximize) · `gross_margin` → `economics economics/model.csv
     economics/assertions.tsv` margin at the worst corner (maximize) · `ltv_cac` → same, LTV/CAC at
     base (maximize) · `cac` → paid CAC driver (minimize) · `payback` → payback months (minimize) ·
     `utilization` → `studio economics/studio-ledger.csv` utilisation (maximize) · `dso` → `ar
     finance/ar_ledger.csv` DSO (minimize) · `unsourced` → `citations` over the venture docs
     (minimize) · `pass_rate` → `pass-rate guild-results.tsv --strict-evidence` (maximize).
   - `Verify:` → that exact shell command; it must print a number. `Direction:` sets the sign
     (default: maximize). Safety-screen the command before the first run (no rm -rf, no curl|sh, no
     credentials, no outbound writes); refuse destructive ones.
3. Baseline: run the metric on the untouched venture. Record. A metric that won't run is a setup
   failure — fix the seam before iterating.
4. **Business ratchet — always on.** Every iteration must keep: `citations` = 0 on every document
   in scope, `claims`/`sources` VALID, `economics` assertions all passing at the worst corner,
   `compliance` with zero overdue rows, and the `evidence` dimension green. A change that improves
   the metric but breaks the ratchet is reverted.

**Loop (N iterations, default 25; `Iterations: unlimited` to opt out):**
1. Review: last 10–20 rows of `iterations.tsv`, `git log --oneline -20`, `git diff HEAD~1` when the
   last iteration was kept. Identify what worked, what failed, what is untried.
2. Modify: ONE focused change inside Scope — a driver re-estimated from a new sourced claim, a
   pricing-book row re-priced against its floor and band, an offer fence tightened, a stale deal
   dispositioned into `drafts/next-actions.md` for a human, a sequence template shortened, a
   compliance checklist row added, an asset lint fixed. Never a ledger row a human owns.
3. Commit (`experiment: …`) before verifying.
4. Verify: run the metric; compute the delta; run the ratchet gates (cheap first: citations →
   claims/sources → economics → compliance → pass-rate).
5. Decide: **keep** (metric improved in Direction ∧ ratchet green) · **discard** (`git revert HEAD
   --no-edit`) · **crash** (revert; note the error) · **no-op**.
6. Log a row to `guild/loop-{YYMMDD}-{HHMM}/iterations.tsv`:
   `iteration timestamp commit metric delta ratchet status description` (TSV; header line
   `# metric_direction: …`). `--evals` adds checkpoints every ⌊N/3⌋ iterations.

**Summary:** iterations run, kept/discarded, start → end metric, the three most effective changes,
the sign-off rows surfaced for humans (drafts written, nothing sent).

## Chain handoff
Write `guild/loop-{YYMMDD}-{HHMM}/handoff.json` (schema v3.1.0): `version`, `source: "guild"`,
`status ∈ COMPLETE|BOUNDED|PLATEAU|USER_INTERRUPT|ERROR`, `timestamp`, `results_tsv`, `metric`
`{name, start, end, direction}`, `config` `{scope, verify, iterations}`; validate with
`bash scripts/validate-handoff.sh <file> guild` before printing the summary. `--chain evals` hands
the TSV to `/guild:evals`; `--chain board` hands the venture tree to `/guild:board`.
