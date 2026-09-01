<div align="center">

# Guild

**AutoForge's business sibling — turn Claude Code into a relentless business-building engine: from an idea to a validated customer and offer, a unit-economics model that closes, a go-to-market plan, and the first paying customer — with a standing board that keeps the business honest afterwards.**

Guild is the product; `guild` is its command namespace — every command is `/guild:*`.

[Forge](https://github.com/Jss-on/autoforge) builds software. [Anvil](https://github.com/Jss-on/anvil) builds hardware. **Guild finds who pays for them, at what price, and how.**

![Version](https://img.shields.io/badge/version-0.0.2-blue.svg)
![License: Proprietary](https://img.shields.io/badge/License-Proprietary-red.svg)

*"Set the THESIS → The agent runs the LOOP → You wake up to a board pack."*

</div>

---

```
 DISCOVER          MARKET            OFFER + PRICE     ECONOMICS         GO-TO-MARKET      FIRST CUSTOMER
 ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
 │   VRS    │     │ TAM/SAM/ │     │ ICP +    │     │ model.csv│     │ playbook │     │ pipeline │
 │  V-n +   │────▶│ SOM cited│────▶│ position │────▶│ corners  │────▶│ assets   │────▶│ won +    │
 │ test     │     │ competi- │     │ price    │     │ GM·LTV/  │     │ consent  │     │ invoice +│
 │ method   │     │ tor snaps│     │ book+tax │     │ CAC·cash │     │ (sends   │     │ payment  │
 └──────────┘     └──────────┘     └──────────┘     └──────────┘     │ human-   │     │ evidence │
 /guild:                                                             │ gated)   │     └──────────┘
   discover       ───────────────── /guild:build orchestrates all phases ─────────────────────────

                   ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
                   │  Board   │     │ Ops +    │     │ Improve  │     │  Evals   │
                   │ pack from│     │ finance +│     │ conv/CAC │     │ trends   │
                   │ ledgers  │     │compliance│     │ /margin  │     │ plateaus │
                   └──────────┘     └──────────┘     └──────────┘     └──────────┘
                   /guild:board     (build P9–P10)   /guild:improve   /guild:evals
```

---

## Status — v0.0.2 skeleton + research

The gate exists, the harness does not yet. Shipped: the scoring seam (`score-guild.sh pass-rate |
coverage | validate | verdict | paying` with strict evidence and forge-grade flooring), its
self-test, the plugin mirror, the doctor, the handoff validator (schema v3.1.0), the **research
dossier** (`research/business-process-research-260902.md` — 12 domain briefs, ~560 sources), the
**benchmarks annex**, and the frozen 66-row end-to-end capability scorer that defines "done".
Everything else — 13 protocols, 27 domain gates with fixture tests, 6 commands, the venture template,
the studio exemplar — lands through the forge loop configured in
`plans/reports/guild-business-harness-plan-260902.md` (autoresearch repo). Baseline: run
`bash scripts/score-e2e-capability.sh`.

## Why This Exists

AutoForge proved the loop generalizes: one metric, constrained scope, fast mechanical verification,
automatic rollback, git as memory. Anvil showed it survives contact with physics. Business has less
machine-readable truth than an EDA toolchain — but far more than founders use. Guild's discipline is
to **keep every business claim in a ledger a script can check**, and to keep every irreversible act
(send, spend, sign, file) in human hands:

| Question | Mechanical answer | Gate |
|---|---|---|
| Are our market numbers real? | unsourced numeric claims → **0**; every source has a locator, retrieval date, archive URL and hash; CAPTCHA pages are not sources | `sources` / `claims` / `citations` |
| Do we actually know the customer? | ≥ 12 consented interviews per elected segment, ≥ 50 % evidence-grade (past behaviour + spend/commitment), no pitching in the first six; every ICP leaf traced to ≥ 3 interview ids | `interviews` / `icp` |
| Is every assumption testable? | every `V-n` = statement + metric + threshold + test method on the validation ladder | `vrs` |
| Is the market size auditable? | factor product = stated claim; SOM ≤ SAM ≤ TAM; ≥ 2 methods within 3×; status-quo alternative present; competitor prices dated + hashed | `market` / `competitors` |
| Is the positioning real? | six Moore slots resolving to ledger ids, ≤ 75 words, no "simple/affordable" | `positioning` / `offers` |
| Is the price defensible? | list ≥ cost floor/(1−GM) at ≤ 75 % utilisation; ≥ 10 WTP conversations; competitor band; VAT / 8 % / CWT consistency | `pricing` |
| Does the business close? | GM, LTV:CAC, payback, churn, burn multiple, runway assertions hold at the **worst** corner; 13-week cash never breaches the floor; default-alive | `economics` / `cash` / `alive` / `studio` |
| Is anyone buying? | no deal without a dated next step; slipped deals out of commit; coverage = 1 ÷ win-rate; **paying customer = `won` + invoice + payment evidence** | `funnel` / `paying` |
| Would the marketing embarrass us or break the law? | placeholders, single CTA, unsourced numbers, ASC superlatives, consent per send, spend approvals, experiment n + duration | `assets` / `experiments` / `consent` |
| Will delivery get paid? | SOW payments tied to milestone ids, deposit ≥ 20 %, invoice after acceptance, zero hours before change-order approval, NTC/BPS certificates before shipping, 2307 collected, credit term printed | `sow` / `delivery` / `regulatory` / `ar` |
| Are we allowed to operate? | compliance register rows with document evidence, hashes and deadlines; professional sign-off rows never auto-pass | `compliance` |
| Is the board honest? | pack derived from ledgers ≤ 31 days old; founders' agreement valid; ADRs and risks clean; kill/pivot rows evaluated → `CONTINUE \| PIVOT \| KILL` | `board` / `decisions` / `founders` |

None of these are vibes. All of them are numbers a loop can ratchet — and none of them can be
satisfied by inventing a customer.

## What the loop can never do

- **Send** outreach (email, DM, executed call scripts), **publish** pricing or pages, **spend**
  money, **sign** contracts, **bid**, or **file** with any government office — without explicit
  approval. `OPEN_FOR_BUSINESS` is a verdict, not a launch.
- **Fabricate evidence.** Interview rows, pipeline rows, payments, acceptance records, certificates
  and compliance documents are **human-entered**; the loop reads them and may draft into `drafts/`,
  never write them.
- **Give advice it isn't licensed to give.** Guild is not legal, tax, or financial advice.
  Compliance and finance rows carry accountant/lawyer sign-off that the loop cannot mark `pass`;
  every statute row carries its RA/RR number, effective date and `verified_on`.

## The Loop

```
LOOP (N iterations or until OPEN_FOR_BUSINESS / FIRST_CUSTOMER):
  1. Review current state + git history + guild-results.tsv
  2. Pick the next change (lowest-scoring dimension first; the evidence gate first of all)
  3. Make ONE focused change (a protocol, a ledger schema, a gate, a phase, a draft asset)
  4. Git commit (before verification)
  5. Mechanical verification — cheap gates first: sources/claims/citations → interviews/icp/vrs
     → market/competitors → positioning/offers/pricing → economics/cash/alive/studio
     → funnel/experiments/assets/consent → sow/delivery/regulatory/ar → compliance
     → board/decisions/founders → pass-rate → verdict
  6. If improved → keep. If worse → git revert. If crashed → fix or skip.
  7. Log to guild-results.tsv / iterations.tsv
```

## Layout

```
.claude/commands/guild.md, guild/*.md   canonical commands (discover, build, board, improve, evals)
.claude/skills/guild/SKILL.md           doctrine, safety invariants, dispatch
.claude/skills/guild/references/        13 protocols (evidence, discovery, market, venture-requirements,
                                        offer, pricing, economics, gtm, marketing, operations, finance,
                                        compliance, governance) + metrics.md + benchmarks.md
research/business-process-research-260902.md   the dossier the protocols are written from
research/raw/01–12                      the domain briefs with numbered, graded sources
scripts/score-guild.sh                  the scoring seam (one-line stdout per gate)
scripts/score-e2e-capability.sh         FROZEN harness self-gate (66 rows) — never edited to pass
scripts/sync-plugin.sh                  canonical → claude-plugin/ byte mirror (--check in CI)
tests/*.test.sh, tests/fixtures/<gate>/ every gate has a fixture test and a good/bad fixture pair
evals/venture/*.spec.yaml               exemplar venture specs (dogfood: the studio itself)
templates/guild-venture/                the venture tree a build creates (human-entered ledgers marked)
```

## Quick start

```bash
bash scripts/doctor.sh                 # DOCTOR: READY
bash tests/score.test.sh               # seam self-test
bash scripts/score-e2e-capability.sh   # E2E_CAPABILITY: N/66
```
