<div align="center">

# Guild

**AutoForge's business sibling — turn Claude Code into a relentless business-building engine: from an idea to a validated customer and offer, a unit-economics model that closes, a go-to-market plan, and the first paying customer — with a standing board that keeps the business honest afterwards.**

Guild is the product; `guild` is its command namespace — every command is `/guild:*`.

[Forge](https://github.com/Jss-on/autoforge) builds software. [Anvil](https://github.com/Jss-on/anvil) builds hardware. **Guild finds who pays for them, at what price, and how.**

![Version](https://img.shields.io/badge/version-0.0.1-blue.svg)
![License: Proprietary](https://img.shields.io/badge/License-Proprietary-red.svg)

*"Set the THESIS → The agent runs the LOOP → You wake up to a board pack."*

</div>

---

```
 DISCOVER          MARKET            OFFER             ECONOMICS         GO-TO-MARKET      FIRST CUSTOMER
 ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
 │   VRS    │     │ TAM/SAM/ │     │ ICP +    │     │ model.csv│     │ playbook │     │ pipeline │
 │  V-n +   │────▶│ SOM cited│────▶│ position │────▶│ corners  │────▶│ assets   │────▶│ won +    │
 │ test     │     │ competi- │     │ pricing  │     │ GM·LTV/  │     │ calendar │     │ invoice +│
 │ method   │     │ tor matrix│    │ ladder   │     │ CAC·runway│    │ (sends   │     │ payment  │
 └──────────┘     └──────────┘     └──────────┘     └──────────┘     │ human-   │     │ evidence │
 /guild:                                                             │ gated)   │     └──────────┘
   discover       ───────────────── /guild:build orchestrates all phases ─────────────────────────

                   ┌──────────┐     ┌──────────┐     ┌──────────┐
                   │  Board   │     │ Improve  │     │  Evals   │
                   │ pack from│     │ conv/CAC │     │ trends   │
                   │ ledgers  │     │ /margin  │     │ plateaus │
                   └──────────┘     └──────────┘     └──────────┘
                   /guild:board     /guild:improve   /guild:evals
```

---

## Status — v0.0.1 skeleton

This repo is at the same point anvil was the day its frozen scorer landed: the **gate exists, the
harness does not yet**. Shipped: the scoring seam (`score-guild.sh pass-rate | coverage | verdict`),
its self-test, the plugin mirror, the doctor, and the frozen 39-row end-to-end capability scorer
that defines "done". Everything else — the protocols, the gates, the commands, the exemplar — lands
through the forge loop configured in `plans/reports/guild-business-harness-plan-260902.md`
(autoresearch repo). Baseline: run `bash scripts/score-e2e-capability.sh`.

## Why This Exists

AutoForge proved the loop generalizes: one metric, constrained scope, fast mechanical verification,
automatic rollback, git as memory. Anvil showed it survives contact with physics. Business has less
machine-readable truth than an EDA toolchain — but far more than founders use. Guild's discipline is
to **keep every business claim in a ledger a script can check**, and to keep every irreversible act
(send, spend, sign, file) in human hands:

| Question | Mechanical answer | Tool |
|---|---|---|
| Are our market numbers real? | unsourced numeric claims → **0** (every figure joins a claims ledger with locator + retrieval date) | `score-guild.sh citations` |
| Do we actually know the customer? | interviews ≥ quota per segment, human-entered with consent; every ICP attribute traced to ≥ k interview rows | `interviews` / `icp` |
| Does the business close? | gross margin, LTV/CAC, payback, runway assertions hold at base **and worst** corners | `economics` |
| Is the price defensible? | price ≥ cost floor, inside the competitor band or with a logged justification, VAT-aware | `pricing` |
| Is anyone buying? | stage conversion from the pipeline ledger; **paying customer = `won` + invoice + payment evidence** | `funnel` |
| Are we allowed to operate? | compliance register rows with document evidence; accountant/lawyer sign-off rows never auto-pass | `compliance` |
| Would the sales assets embarrass us? | placeholder text, missing ICP/offer/price/CTA, unsourced numbers → lint count | `assets` |
| Is the board pack honest? | every section derived from ledgers, not prose; stale data flagged | `board` |

None of these are vibes. All of them are numbers a loop can ratchet — and none of them can be
satisfied by inventing a customer.

## What the loop can never do

- **Send** outreach (email, DM, executed call scripts), **publish** pricing or pages, **spend**
  money, **sign** contracts, or **file** with any government office — without explicit approval.
  `OPEN_FOR_BUSINESS` is a verdict, not a launch.
- **Fabricate evidence.** Interview rows, pipeline rows, payments, and compliance documents are
  human-entered; the loop reads them and may draft, never write them.
- **Give advice it isn't licensed to give.** Guild is not legal, tax, or financial advice.
  Compliance and finance rows carry accountant/lawyer sign-off that the loop cannot mark `pass`.

## The Loop

```
LOOP (N iterations or until OPEN_FOR_BUSINESS / FIRST_CUSTOMER):
  1. Review current state + git history + guild-results.tsv
  2. Pick the next change (lowest-scoring dimension first; the evidence gate first of all)
  3. Make ONE focused change (a protocol, a ledger schema, a gate, a phase, a draft asset)
  4. Git commit (before verification)
  5. Mechanical verification — cheap gates first: citations → interviews/icp → economics/pricing
     → funnel/assets → compliance → board → pass-rate → verdict
  6. If improved → keep. If worse → git revert. If crashed → fix or skip.
  7. Log to guild-results.tsv / iterations.tsv
```

## Layout

```
.claude/commands/guild.md, guild/*.md   canonical commands (discover, build, board, improve, evals)
.claude/skills/guild/SKILL.md           doctrine, safety invariants, dispatch
.claude/skills/guild/references/        protocols (evidence, discovery, market, offer, economics,
                                        gtm, operations, compliance, governance), metrics, benchmarks
scripts/score-guild.sh                  the scoring seam (one-line stdout per gate)
scripts/score-e2e-capability.sh         FROZEN harness self-gate — never edited to pass
scripts/sync-plugin.sh                  canonical → claude-plugin/ byte mirror (--check in CI)
tests/*.test.sh, tests/fixtures/        every gate has a fixture test
evals/venture/*.spec.yaml               exemplar venture specs (dogfood: the studio itself)
templates/guild-venture/                the venture tree a build creates
```

## Quick start

```bash
bash scripts/doctor.sh                 # DOCTOR: READY
bash tests/score.test.sh               # seam self-test
bash scripts/score-e2e-capability.sh   # E2E_CAPABILITY: N/39
```
