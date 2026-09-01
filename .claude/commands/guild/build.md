---
name: guild:build
description: "Build a venture end to end through the gated business pipeline — charter (early irreversibles) → evidence → discovery → market → offer → pricing → economics + cash → GTM + marketing → operations + finance → compliance → launch (human-gated) → first paying customer → standing board — to passing weighted acceptance"
argument-hint: "[Spec: <venture.spec.yaml>] [Goal: <thesis text>] [Scope: <venture dir>] [Iterations: N] [--dry-run] [--evals] [--chain board]"
---

EXECUTE IMMEDIATELY.

The full pipeline. Takes a validated venture spec (from `/guild:discover`) or a thesis, and runs
the venture through every phase of the process map in
`research/business-process-research-260902.md` §2, each phase gated by a mechanical check and
each irreversible decision fixed in the charter with a decide-by date. The verdict at the end is
`score-guild.sh verdict`: `NOT_READY` → `OPEN_FOR_BUSINESS` → `FIRST_CUSTOMER`. The loop drafts,
lints and scores; **humans interview, quote, send, spend, sign, bid, file and elect**.

## Seam & reference resolution (read once)
Resolve `GUILD_ROOT` as in SKILL.md: first existing of `${CLAUDE_PLUGIN_ROOT}/skills/guild`,
`.claude/skills/guild`, the directory containing this command file, else glob
`**/skills/guild/scripts/score-guild.sh` and take its grandparent. Every `scripts/<x>` means
`$GUILD_ROOT/scripts/<x>`; every `references/<x>` means `$GUILD_ROOT/references/<x>`. Run
`bash scripts/doctor.sh --require-build` at Phase 0 — `gh` is needed because the venture lives in
its own private output repo.

## Output repository (transparency contract)
Every venture is a private GitHub repo `Jss-on/<venture-slug>` created at Phase 0 (`gh repo create
--private`), initialised from `templates/guild-venture/` (the venture tree — see its README for
which ledgers are human-entered). The loop pushes to that repo as part of the standard iteration
(that is how its CI runs `scripts/score-guild.sh` on every commit); everything beyond that repo —
sending, publishing, spending, signing, bidding, filing, changing repo visibility — is human-gated,
always.

## Parse Arguments
- `Spec:` — `venture.spec.yaml`; must pass `bash scripts/score-guild.sh validate` (name, thesis,
  `segment.icp` election, all seven acceptance dimensions with weights, gated rows in evidence /
  customer / economics). An invalid spec routes to `/guild:discover` first.
- `Goal:` — a thesis without a spec → run `/guild:discover` Phase 0–1 to produce one, then continue.
- `Scope:` — the venture directory (default `ventures/<slug>/`, the clone of the output repo).
- `Iterations:` — default 40; `unlimited` opts out. `--dry-run` prints the derived config, the
  phase plan and the charter questions, and stops. `--evals`, `--chain board|evals`.

## Phase 0 — Charter: fix the early irreversibles before anything is built
Read the spec. Then, in ≤ 4-question AskUserQuestion rounds with recommended defaults, decide and
write `charter.md` with a **decide-by date and owner per row** (dossier §6 — the register):

| # | Irreversible | Gate that reads it |
|---|---|---|
| 1 | Founders' equity split, 4-year vesting / 12-month cliff, roles, decision rights, IP assignment, departure terms — `board/founders-agreement.yaml` | `founders` (blocks the first external-money step) |
| 2 | Entity type (sole prop / OPC / corp) and fiscal year — `compliance/profile.yaml` | `compliance` |
| 3 | Tax posture: VAT vs non-VAT (voluntary = 3-year lock-in), the 8 % option (individuals only, elected Q1, irrevocable), books method, invoice series with printed credit term — `pricing/tax-status.csv` | `pricing`, `ar`, `compliance` |
| 4 | **ICP / segment election** and **market type** (existing / resegmented / new — the cash horizon) — `discovery/segments.csv` (`elected` is a human sign-off row) | `icp`, `interviews`, `vrs` |
| 5 | Counting unit + statistical frame for sizing; geography claimed — `market/charter.csv` | `market` |
| 6 | Category / frame of reference (new category = opt-in with an education budget) — `offer/positioning.yaml` | `positioning` |
| 7 | **Price metric**, first public list price, discount policy, T&C indexation — `pricing/price-book.csv` | `pricing` |
| 8 | Business-model mix and (hardware) channel — `economics/model.csv` | `economics`, `studio` |
| 9 | Paid-vs-free discovery precedent, guarantee terms, first-deal payment terms + EWT class — `offer/offers.yaml` | `offers` |
| 10 | Sales motion by ACV; government track (PhilGEPS) yes/no — `gtm/plan.md` | `funnel` |
| 11 | **Brand** name, domain, handles, trademark class, sending subdomain, consent-capture design, UTM taxonomy — `marketing/plan.md` | `assets`, `consent` |
| 12 | Hardware: IP/tooling ownership, radio architecture and certificate model name, BPS list — `ops/regulatory.csv` | `regulatory` |
| 13 | IP terms in the first MSA — `ops/msa.md` | `sow` |
| 14 | Bank(s) and payment-rail entity type — `finance/policy.md` | `ar` |
| 15 | North Star metric, board composition, funding instrument, hiring ahead of default-alive — `board/kpi-tree.yaml`, `board/kill-criteria.csv` | `board`, `alive` |
| 16 | First anchor client ≤ 25 % of revenue; first reference customers — `gtm/targets.tsv` | `studio`, `funnel` |

Rows the founders cannot decide yet get a decide-by date, not a default. The charter is the
Phase-1-of-anvil analogue: the irreversibles are fixed here and echoed on every later deliverable.

## Phase 1 — Evidence setup
`evidence/sources.tsv` (13 columns, archived + hashed; a CAPTCHA page is not a source) and
`evidence/claims.tsv`; every later document cites `[C-n]`. Gate: `sources` VALID, `claims` VALID,
`citations` = 0 on `charter.md`. Protocol: `references/evidence-protocol.md`.

## Phase 2 — Discovery (human-entered interviews)
Hypotheses typed D/F/V/A and the assumption map → segment + market-type hypotheses → drafted
interview scripts and consent forms into `drafts/` → **humans conduct the interviews and enter
`discovery/interviews.tsv` + `discovery/consent.tsv`** → synthesis (codes, job stories,
saturation) → Blank discovery-exit memo → `discovery/commitments.csv` (human). Gates: `interviews`
(consent join, SPI explicit consent, quota ≥ 12 per elected segment, evidence-grade ≥ 50 %, no
early pitch, saturation), `icp` (every leaf ≥ 3 interview ids, four forces, beachhead criteria,
anti-ICP, decision-maker role, procurement mode). Protocol: `references/discovery-protocol.md`.
Nothing downstream is written until the elected segment's quota is met — the loop idles on
`awaiting human: interviews` rather than inventing rows.

## Phase 3 — Market
Sizing charter → beachhead scoring → bottom-up TAM with top-down cross-check and triangulation
≤ 3× → alternatives incl. status quo with interview evidence → dated hashed price snapshots →
five forces + why-now → source refresh cadence. Gates: `market`, `competitors`; `citations` = 0
on `market/*.md`. Protocol: `references/market-protocol.md`.

## Phase 4 — VRS re-validation
`vrs/requirements.md` re-cut from the evidence (`vrs` = all rows measurable); `coverage --spec
venture.spec.yaml vrs/requirements.md` = 1.00; `validate venture.spec.yaml` VALID. Protocol:
`references/venture-requirements-protocol.md`.

## Phase 5 — Positioning + offer
Alternatives → unique attributes → value themes with proof → ICP + anti-ICP → category decision
→ Moore statement (linted) → messaging pillars → offer ladder (paid discovery first; tiers with
fences; capped guarantee; PH tax note) → narrative + one-pager → `offer/pitch_tests.csv` (human).
Gates: `positioning`, `offers`, `assets` on the one-pager. Protocol: `references/offer-protocol.md`.

## Phase 6 — Pricing
WTP conversations (human-entered `pricing/wtp-interviews.csv`, ≥ 10 per segment) → cost floor at
≤ 75 % utilisation → competitor band → price metric + model → tiers → tax treatment per line →
discount + increase policy. Gate: `pricing` = 0. Protocol: `references/pricing-protocol.md`.

## Phase 7 — Economics + cash
Metric dictionary → driver register (`evidence ∈ measured|quote|statute|benchmark|assumption`;
anvil `PRODUCT_COST` / forge build cost feed COGS) → unit economics → monthly model → corners +
sensitivity → 13-week cash + weekly variance → default-alive → studio KPI ledger. Gates:
`economics` (all assertions at base and worst corners), `cash`, `alive`, `studio`. Protocol:
`references/economics-protocol.md`.

## Phase 8 — GTM + marketing
Sales hypothesis → motion by ACV → founder-led ladder → materials → lead list → MEDDPICC stage
exits → paid pilots → proposals → paper-process tripwires → pipeline review; STP/7Ps → ≤ 3
channels with PH reach data → assets vs checklist → content clusters → tracking → experiments →
consent + spend ledgers → compliance review per publish. Gates: `funnel`, `experiments`,
`assets`, `consent`. Protocols: `references/gtm-protocol.md`, `references/marketing-protocol.md`.
**Every send, publish, spend and bid is a human sign-off row** — the loop drafts sequences,
pages and bid packs into `drafts/` and stops there.

## Phase 9 — Operations + finance
MSA/SOW templates (payments on milestone ids, deemed acceptance, change control, IP, warranty
floors, SLA) → delivery ledgers → hardware NPI/EMS/regulatory register → finance policy triad →
books → invoicing under EOPT (credit term printed) → rails on corporate fee schedules → 2307
workflow → substantiation → AR aging/dunning → dashboard. Gates: `sow`, `delivery`,
`regulatory`, `ar`. Protocols: `references/operations-protocol.md`, `references/finance-protocol.md`.

## Phase 10 — Compliance
`compliance/register.csv` generated from `compliance/profile.yaml` via `applies_if`; deadline
engine; evidence + hash per row; professional sign-off rows. Gate: `compliance` with zero overdue
applicable rows. Protocol: `references/compliance-protocol.md`. Not legal, tax or financial
advice: the accountant/lawyer rows stay red until a named human signs.

## Phase 11 — Launch → first paying customer (human-gated)
Humans execute outreach, pilots and proposals from the drafts; the loop keeps the pipeline honest
(`funnel`), collections honest (`ar`) and the verdict honest: `FIRST_CUSTOMER` = a `won` row in
`gtm/pipeline.tsv` with an invoice id and `payment = evidence:<path>` — never typed by the loop.

## Phase 12 — Board
Hand the venture to `/guild:board` (first pack at the end of the build; every 6–12 weeks after):
pack derived from ledgers, DEFAULT_ALIVE, kill/pivot rows, `CONTINUE | PIVOT | KILL`.

## Iteration loop — the forge first principle
```
LOOP (N iterations or until verdict ∈ OPEN_FOR_BUSINESS | FIRST_CUSTOMER):
  1. Review guild-results.tsv + git history; pick the lowest-scoring dimension (evidence first of all)
  2. ONE focused change (a ledger the loop owns, a draft, a protocol-conformant document)
  3. Commit (experiment: …) and push to the output repo
  4. Verify — cheap gates first: sources/claims/citations → interviews/icp/vrs → market/competitors
     → positioning/offers/pricing → economics/cash/alive/studio → funnel/experiments/assets/consent
     → sow/delivery/regulatory/ar → compliance → board/decisions/founders
     → pass-rate --strict-evidence → coverage → verdict
  5. keep if pass-rate rose and no must-pass row regressed; else revert (git revert HEAD --no-edit)
  6. Log to guild-results.tsv (n dimension assertion status weight evidence traces) + iterations.tsv
```
Every results row carries an `evidence:` path and a `V-n` trace; `pass-rate --strict-evidence`
turns a claimed-but-missing path red. The loop never marks a human sign-off row `pass`; when the
only red rows left are human rows, the build reports `awaiting human` with the exact rows.

## Coverage — every V-n is built
`scripts/score-guild.sh coverage guild-results.tsv vrs/requirements.md` must read 1.00 at
convergence; untraced `V-n` and orphan traces block the verdict.

## Safety invariants
Never send, publish, spend, sign, bid, file, elect, or change repo visibility. Never write a
human-entered ledger. Not legal, tax, or financial advice. Bounded by default. Everything logged
to `guild/build-{YYMMDD}-{HHMM}/`.

## Summary
Print: verdict, pass-rate per dimension, coverage, the human sign-off rows outstanding (with the
drafts prepared for each), the charter rows still undecided, and the output repo URL.

## Chain handoff
`guild/build-{YYMMDD}-{HHMM}/handoff.json` (v3.1.0): `source: "build"`, `status`, `timestamp`,
`results_tsv`, `metric {name: venture_pass_rate, value, direction}`, `config {spec, iterations,
scope}`, `coverage {req}` (required when CONVERGED), `verdict`, `repo`; validated with
`bash scripts/validate-handoff.sh <file> build`. `--chain board` invokes `/guild:board`.
