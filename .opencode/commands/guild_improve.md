---
name: guild_improve
description: "Optimization loop on an existing venture: maximize conversion | gross_margin | ltv_cac | utilization, minimize cac | payback | dso — under a hard non-regression ratchet (evidence clean ∧ economics close ∧ compliance intact)"
argument-hint: "Metric: conversion|gross_margin|ltv_cac|utilization|cac|payback|dso [Scope: <venture dir>] [Iterations: N] [--evals]"
---

EXECUTE IMMEDIATELY.

The optimizer. Where `/guild_build` takes a venture from nothing to `OPEN_FOR_BUSINESS`, `improve`
takes a venture that already has ledgers and makes one number better without letting any other
number get worse. It is the `Classic` loop of `/guild` with a **named metric** and a **hard
ratchet**.

## Seam & reference resolution (read once)
Resolve `GUILD_ROOT` as in SKILL.md; every `scripts/<x>` is `$GUILD_ROOT/scripts/<x>`, every
`references/<x>` is `$GUILD_ROOT/references/<x>`. Run `bash scripts/doctor.sh`.

## Parse Arguments
- `Metric:` (required) — one of the named metrics below; `Direction:` is implied.
- `Scope:` — the venture directory (default: the current directory if it holds `venture.spec.yaml`).
- `Iterations:` — default 20; `unlimited` opts out of the bound.
- `--evals` / `--evals-interval N` — checkpoints; `--chain evals|board`.

## Named metrics → Verify commands

| Metric | Verify (must print one number) | Direction |
|---|---|---|
| `conversion` | `scripts/score-guild.sh funnel gtm/pipeline.tsv gtm/targets.tsv` → stage conversion (opportunity → won over the trailing 90 days, from stderr detail) | maximize |
| `gross_margin` | `scripts/score-guild.sh economics economics/model.csv economics/assertions.tsv` → GM at the **worst** corner | maximize |
| `ltv_cac` | same gate → LTV/CAC at base | maximize |
| `utilization` | `scripts/score-guild.sh studio economics/studio-ledger.csv` → trailing-90-day billable utilisation | maximize |
| `cac` | `economics` → paid CAC (PHP) | minimize |
| `payback` | `economics` → CAC payback months | minimize |
| `dso` | `scripts/score-guild.sh ar finance/ar_ledger.csv` → days sales outstanding | minimize |

The number is read from the gate's stderr detail line named for the metric; the gate's stdout
contract line is unchanged.

## The non-regression ratchet (checked every iteration, before the metric decides)

| Ratchet | Command | Must hold |
|---|---|---|
| Evidence | `scripts/score-guild.sh sources evidence/sources.tsv` · `claims evidence/claims.tsv evidence/sources.tsv` · `citations <every doc in scope> evidence/claims.tsv` | VALID · VALID · `UNSOURCED_CLAIMS: 0` |
| Economics | `scripts/score-guild.sh economics economics/model.csv economics/assertions.tsv` · `cash economics/cash13.csv economics/variance.csv` | all assertions pass · all cash checks pass |
| Compliance | `scripts/score-guild.sh compliance compliance/register.csv compliance/profile.yaml` | no overdue applicable row |
| Pricing | `scripts/score-guild.sh pricing pricing/price-book.csv pricing/tax-status.csv` | `PRICE_VIOLATIONS: 0` (a cheaper price that breaks the floor is not an improvement) |
| Pass-rate | `scripts/score-guild.sh pass-rate guild-results.tsv --strict-evidence` | never lower than at iteration 0 |

A change that improves the metric and breaks any ratchet row is **reverted** — non-regression is a
hard gate, not a tie-breaker. The ratchet also refuses any diff that touches a human-entered ledger.

## Loop

0. Baseline: run the metric and every ratchet command on the untouched venture; record both in
   `guild/improve-{YYMMDD}-{HHMM}/iterations.tsv` (`# metric_direction: …`, columns `iteration
   timestamp commit metric delta ratchet status description`).
1. Review git history and the last rows: what moved the metric, what was reverted.
2. Make ONE focused change inside Scope (a driver re-sourced, a tier fence, a discount-policy cap,
   a follow-up cadence, a milestone-billing term, a collections script drafted into `drafts/`).
3. Commit `experiment: …`. 4. Verify metric → delta. 5. Ratchet. 6. **keep** / **discard**
   (`git revert HEAD --no-edit`) / **crash** / **no-op**. 7. Log the row.
8. Stop at `Iterations`, or earlier when `--evals` reports a plateau across 3 checkpoints.

## What improve may never do
Send outreach, publish a price, spend, sign, bid, file, or mark a professional sign-off row as
done. When the best next move is one of those, the iteration writes the draft and the sign-off row
into `drafts/` and logs `no-op: awaiting human`.

## Summary + handoff
Print iterations, kept/discarded, start → end metric, ratchet breaches reverted, the top-3
effective changes, and the human actions now pending. Write `handoff.json` (v3.1.0, `source:
"improve"`, `status`, `timestamp`, `results_tsv`, `metric {name, start, end, direction}`,
`config`), validated with `bash scripts/validate-handoff.sh <file> improve`.
