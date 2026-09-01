---
name: guild
description: "Autonomous business-building iteration: modify, verify (citations/interviews/economics/funnel), keep/discard against evidence-anchored metrics — idea to first paying customer, then a standing board"
version: 0.0.1
---

# Guild — Autonomous Goal-directed Business Iteration

AutoForge's business sibling. Forge builds software, anvil builds hardware; **guild finds who pays
for them, at what price, and how — then sits as the board that keeps the business honest.** Same
loop discipline — one metric, constrained scope, fast mechanical verification, automatic rollback,
git as memory — with business-correct gates: unsourced-claim counts against a claims ledger,
interview quotas from a human-entered ledger, unit-economics assertions at base and worst corners,
pricing floor/band checks, funnel rates from a human-entered pipeline, a compliance register with
document evidence, and a board pack derived from ledgers rather than prose.

## Safety Invariants (all subcommands)

- **Never send, publish, spend, sign, or file** without explicit user approval: no outreach
  (email / DM / executed call scripts), no public pricing or pages, no purchases or ad spend, no
  contracts, no government filings. `OPEN_FOR_BUSINESS` and `FIRST_CUSTOMER` are verdicts, not
  actions. Drafts are the loop's output; sends are the human's. Every such act is a
  **human-gated sign-off row** the loop never marks `pass`.
- **Never fabricate evidence.** `discovery/interviews.tsv`, `gtm/pipeline.tsv`, payment evidence,
  and compliance documents are **human-entered ledgers**: the loop reads and derives from them and
  may write candidate rows into `drafts/`, but never into the ledgers. A market figure without a
  claims-ledger row is `fail`, not "approximately right".
- **Not legal, tax, or financial advice.** Compliance and finance rows carry accountant / lawyer
  sign-off the loop cannot pass. Philippine specifics (DTI/SEC, BIR, LGU permit,
  SSS/PhilHealth/Pag-IBIG, VAT threshold, BMBE) are elicitation prompts and register rows, not
  rulings — every one is verified with a professional before it is relied on.
- **Personal data is minimal and consented.** Interview and lead rows carry a `consent` field; no
  scraping of personal contacts into ledgers; leads are company-level until a human adds a person.
- `build` pushes to the venture's **own private output repo** as part of the standard loop (that is
  how its CI runs); everything beyond that repo is human-gated. Repo visibility is never changed.
- Bounded by default. Override with `Iterations: unlimited`.
- All results logged to `guild/{subcommand}-{YYMMDD}-{HHMM}/`. Chain handoff via `handoff.json`.
  Evals reads `*-results.tsv`.
- **Numbers come from ledgers and gates only** — the loop never self-certifies market size, margin,
  or traction by prose.

## Dispatch (bare `/guild`)

| Condition | Mode |
|---|---|
| `Metric:` or `Verify:` present | **Classic** — metric loop over an existing venture tree (an `improve` alias) |
| `Spec:` file or free-form goal | Route to `build` (greenfield venture) — confirm once |
| Nothing | **Setup wizard** — interactive config builder |

Print a banner on every invocation: `[guild] mode: classic | build | wizard`.

## Subcommands

| Command | Does | Default Iterations |
|---|---|---|
| `/guild` | Bare metric loop over an existing venture (`Metric:`/`Verify:`), route to `build` (`Spec:`/`Goal:`), or setup wizard | 25 |
| `/guild:discover` | Customer + market discovery → validated **Venture Requirements Spec** (VRS: `V-n` rows — every assumption = metric + threshold + test method on the validation ladder) + a ready `build` spec | N/A |
| `/guild:build` | Full gated pipeline: charter → discovery → market → **ICP election** (early irreversible) → positioning + offer → pricing + unit economics → GTM plan + assets → operations + compliance → launch (human-gated sends) → **first paying customer** → standing board | 40 |
| `/guild:board` | BOD cadence: board pack derived from ledgers (KPIs vs targets, funnel, cash/runway, risks, decisions due) → decision log → `CONTINUE \| PIVOT \| KILL` against numeric criteria | N/A |
| `/guild:improve` | Optimization loop on an existing venture: maximize `conversion` \| `gross_margin` \| `ltv_cac`, minimize `cac` \| `payback`, under a hard non-regression ratchet (evidence clean ∧ economics close ∧ compliance intact) | 20 |
| `/guild:evals` | Analyze iteration results: trends, plateaus, regressions, funnel + cash trajectories | N/A |

**Status v0.0.1:** only the scoring seam ships. The commands and protocols above are the target
state, defined row by row by the frozen `scripts/score-e2e-capability.sh`.

## The Dimensions (scoring contract)

Measured by `scripts/score-guild.sh pass-rate` over `guild-results.tsv`
(7 tab-separated cols: `n dimension assertion status weight evidence traces`):

| Dimension | Weight | Gate |
|---|---|---|
| `evidence` | 0.25 | **GATING** — any red row caps headline pass-rate at 0.50 |
| `customer` | 0.20 | must-pass (interview quota, ICP trace, problem validated) |
| `offer` | 0.15 | positioning, value proposition, packaging, pricing ladder |
| `economics` | 0.15 | must-pass (model closes at base AND worst corner) |
| `gtm` | 0.10 | playbook, assets lint, funnel targets, calendar |
| `operations` | 0.05 | delivery process, contracts, invoicing, compliance register |
| `governance` | 0.10 | board pack, decision log, numeric kill/pivot criteria |

Weights renormalize over the dimensions that actually ran. Full contract: `references/metrics.md`.

## Ledgers — who writes what

| Ledger | Written by | Read by |
|---|---|---|
| `evidence/sources.tsv`, `evidence/claims.tsv` | loop (from research; locator + retrieval date per source) | `citations` |
| `discovery/interviews.tsv` | **human** (loop drafts scripts + candidate rows into `drafts/`) | `interviews`, `icp` |
| `gtm/pipeline.tsv` | **human** (loop drafts next actions + assets) | `funnel`, `verdict` |
| `economics/model.csv` | loop — every driver cites a claim, an interview, or an anvil/forge cost output | `economics`, `pricing` |
| `compliance/register.csv` | **human** (documents, sign-offs); loop (checklist rows) | `compliance` |
| `board/decisions.tsv` | human + loop | `board` |

## Method provenance

The protocols embed — with citations in the claims ledger — customer development and lean
hypothesis testing (Blank, Ries), interview discipline (Fitzpatrick's *The Mom Test*: past
behavior over opinions, never pitch), jobs-to-be-done, positioning (Dunford), the value
proposition canvas (Osterwalder), pricing (cost floor, value-based, competitor band, Van
Westendorp), unit economics (contribution margin, LTV/CAC, payback), sales qualification
(BANT / MEDDIC), OKRs, board-pack discipline, and numeric kill/pivot criteria.

## Cross-harness seams

- **guild → forge / anvil:** the validated ICP + offer feed `/forge:requirements` and
  `/anvil:requirements` (`Client:` and goal), so what gets built is what someone agreed to pay for.
- **anvil / forge → guild:** `score-anvil.sh product-bom` (`PRODUCT_COST`) / `bom-cost`
  (`BOM_COST`) and forge build effort/cost feed the COGS rows of `economics/model.csv`.
- **after the build ships:** `/guild:board` tracks delivery (operations) and revenue (pipeline).

## Universal Flags

| Flag | Applies To | Purpose |
|---|---|---|
| `Iterations: N` | All looping | Set iteration count |
| `Iterations: unlimited` | All looping | Opt-in unbounded |
| `--evals` / `--evals-interval N` | All looping | Mid-loop checkpoints + final summary |
| `--chain <targets>` | All | Sequential handoff after completion |
| `--dry-run` | build, board | Print derived config + planned pipeline / pack outline; no execution |

## Seam & reference resolution

Gates ship in `skills/guild/scripts/` and contracts in `skills/guild/references/`. Resolve
`GUILD_ROOT` to the FIRST that exists:
1. `${CLAUDE_PLUGIN_ROOT}/skills/guild` — installed plugin.
2. `.claude/skills/guild` — project-local install (or this repo's canonical tree).
3. The directory containing the invoked command file.
4. Last resort: glob `**/skills/guild/scripts/score-guild.sh` and take its grandparent.

Then read every `scripts/<x>` as `$GUILD_ROOT/scripts/<x>` (falling back to the repo-root
`scripts/` when running inside this harness repo) and every `references/<x>` as
`$GUILD_ROOT/references/<x>`. If nothing resolves, STOP and tell the user to reinstall — the gates
are mechanical requirements of the pipeline, not optional helpers.

Run `bash scripts/doctor.sh` once at Phase 0 of any command (`--require-build` for `build`).
