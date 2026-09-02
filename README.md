<div align="center">

# Guild

**AutoForge's business sibling — turn Claude Code into a relentless business-building engine: from an idea to a validated customer and offer, a unit-economics model that closes, a go-to-market plan, and the first paying customer — with a standing board that keeps the business honest afterwards.**

Guild is the product; `guild` is its command namespace — every command is `/guild:*`.

[Forge](https://github.com/Jss-on/autoforge) builds software. [Anvil](https://github.com/Jss-on/anvil) builds hardware. **Guild finds who pays for them, at what price, and how.**

![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)
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

## Status — v0.1.0 fully capable

The frozen 66-row end-to-end capability scorer reads **1.00** (`bash scripts/score-e2e-capability.sh`).
Shipped: the scoring seam (`score-guild.sh` — pass-rate with strict evidence and forge-grade
flooring, coverage, validate, verdict, paying) plus **27 domain gates** in `scripts/gates/`
(fixture-tested by 333 cases across 12 suites; every gate proven against a planted-defect
fixture), **13 protocols** written from the research dossier
(`research/business-process-research-260902.md` — 12 domain briefs, ~560 graded sources), the
**benchmarks annex**, **6 commands** (`/guild`, `/guild:discover`, `/guild:build`, `/guild:board`,
`/guild:improve`, `/guild:evals`), the venture template whose header-only ledgers pass their own
gates, and the studio exemplar spec that validates. Built by a forge loop in 11 kept iterations
(baseline 0.23 → 1.00; `forge/loop-260902-0207/`). Next: dogfood `/guild:discover` on the studio
itself, then `/guild:build Spec: evals/venture/studio.spec.yaml` in its own private venture repo.

## Installation

> Guild is distributed from a **private repository** — [Jss-on/guild](https://github.com/Jss-on/guild).
> The account installing it needs access; authenticate first (`gh auth login`, or SSH).
> Requirements: `git`, `node`, `awk`, `bash ≥ 4` (`bash scripts/doctor.sh` checks; `gh` is needed
> by `/guild:build`, which pushes every venture to its own private repo).

### Claude Code (plugin — recommended, works in any repo)

```
/plugin marketplace add Jss-on/guild
/plugin install guild@guild
```

Restart the session. Commands surface as `/guild` and `/guild:discover`, `/guild:build`,
`/guild:board`, `/guild:improve`, `/guild:evals`; the gate scripts ship inside the plugin
(`skills/guild/scripts/` + `scripts/gates/`), so nothing else needs copying.

**Update** to the latest release:

```
/plugin marketplace update guild
/plugin update guild@guild
```

then restart the session. (`/plugin` also lists the installed version — compare with `VERSION`
in this repo or `git log --oneline -1` on `master`.)

**Project-local / file install** (no marketplace):

```bash
git clone https://github.com/Jss-on/guild
cd guild
./scripts/install.sh --claude --global     # or --local for the current project's .claude/
```

### OpenCode

```bash
git clone https://github.com/Jss-on/guild
cd guild
./scripts/install.sh --opencode --global   # ~/.config/opencode (or --local → ./.opencode)
```

Commands surface as `/guild`, `/guild_discover`, `/guild_build`, `/guild_board`, `/guild_improve`,
`/guild_evals` (OpenCode has no colon namespace); the skill lives at `skills/guild/` with the same
references and gate scripts. **Update:** `git pull` in the clone and re-run the installer with
`--force`.

### OpenAI Codex

```bash
git clone https://github.com/Jss-on/guild
cd guild
./scripts/install.sh --codex --global      # ~/.codex/skills/guild (or --local → ./.codex)
```

Invoke with the `$guild` mention: `$guild discover Goal: …`, `$guild build Spec: …`,
`$guild board`. **Update:** `git pull` then re-run the installer with `--force`.

### Manual (any agent)

```bash
git clone https://github.com/Jss-on/guild

# Claude Code
cp -r guild/claude-plugin/skills/guild  .claude/skills/guild
cp -r guild/claude-plugin/commands/guild .claude/commands/guild
cp    guild/claude-plugin/commands/guild.md .claude/commands/guild.md

# OpenCode
cp -r guild/.opencode/skills/guild .opencode/skills/guild
cp    guild/.opencode/commands/guild*.md .opencode/commands/

# Codex
cp -r guild/.agents/skills/guild ~/.codex/skills/guild
```

`claude-plugin/` is a byte mirror of the canonical `.claude/` tree (`scripts/sync-plugin.sh`,
parity-gated in CI); `.opencode/`, `.agents/` and `plugins/` are generated by
`scripts/transform.sh` (`--check` in CI). Edit canonical, never the mirrors.

## Which command, when

Guild is a lifecycle, not a menu. Pick the command by the question you are actually stuck on.

| Your situation | Run | What the loop produces | What only you can do |
|---|---|---|---|
| **"We can build things but don't know who the customer is, what to sell, or at what price."** (a new idea, a new capability, a pivot — the starting point) | `/guild:discover Goal: "<thesis>"` | domain recon with cited claims · founder interview in ≤ 4-question rounds · drafted interview scripts + consent forms · synthesis · a **VRS** (`V-n`: assumption + metric + threshold + test method) · segment + market-type election rows · a `venture.spec.yaml` that passes `validate` | run the ≥ 12 interviews per segment and **enter them yourself** (`discovery/interviews.tsv`, `consent.tsv`); sign the segment election |
| **"Discovery is done — turn this into a working business with a paying customer."** (you hold a validated spec) | `/guild:build Spec: <venture.spec.yaml>` | the charter (16 early irreversibles with decide-by dates) · every ledger the loop owns: market sizing, positioning, offers, price book, economics model + 13-week cash, GTM playbook, marketing plan + assets, SOW/MSA templates, finance policy, compliance register · drafts of every send/quote/bid/filing · `guild-results.tsv` scored to `OPEN_FOR_BUSINESS` | WTP conversations, quotes, pilots, contracts, filings, elections, payments — executed from `drafts/`; the `won` row with invoice + payment evidence that turns the verdict into `FIRST_CUSTOMER` |
| **"We're operating. Is this working? What do we decide this month?"** (every 6–12 weeks, or before any hire / spend / raise) | `/guild:board` | a board pack derived from ledgers ≤ 31 days old: KPIs vs plan, cash / runway / **DEFAULT_ALIVE**, pipeline coverage, delivery, headcount, top risks, decisions due · the pre-committed kill/pivot rows evaluated · `CONTINUE \| PIVOT \| KILL` | the decision itself (pivot, hire, raise, kill); the closed session |
| **"One number is bad — conversion, gross margin, CAC, payback, utilisation, DSO."** (an operating venture with ledgers) | `/guild:improve Metric: <name>` | a bounded loop that moves that one metric while the ratchet holds evidence, economics, pricing and compliance green; drafts of the human actions it cannot take | send the sequences, re-quote, collect — the loop drafts and stops |
| **"I have my own metric / a quick experiment over an existing venture tree."** | `/guild Metric: <name>` or `/guild Verify: "<cmd that prints a number>"` | the bare keep/discard loop with the business ratchet always on | same as improve |
| **"I have a spec or a thesis and just want to start."** | `/guild Spec: …` or `/guild Goal: …` (routes to `build` after one confirmation; nothing → setup wizard) | — | — |
| **"Did the last run help? Are we plateauing? What next?"** (after any loop, before spending more iterations) | `/guild:evals Run: guild/<run-dir>` | trend / plateau / regression analysis, dimension breakdown, funnel + cash trajectories, the human sign-off rows that are the real blocker, a one-line recommendation | act on the recommendation |

**The normal order** — `discover → build → board`, then `improve` or `evals` as needed:

```
/guild:discover Goal: "Metro Manila SMB manufacturers with manual inventory will pay for a scoped
                       automation build plus a support retainer"        # weeks 1–4: you interview, the loop scores
/guild:build Spec: ventures/studio/venture.spec.yaml Iterations: 40    # weeks 4–12: ledgers, drafts, verdict
/guild:board                                                           # first pack at the end of build, then every 6–12 weeks
/guild:improve Metric: conversion                                      # when a single number lags
/guild:evals Run: guild/build-260915-0900                              # before committing more iterations
```

**Where forge and anvil plug in:** once `discover` has an elected segment and `build` has a
validated offer, hand the ICP + offer to `/forge:requirements` (software) or
`/anvil:requirements` (hardware) as the `Client:` and goal — so what gets built is what someone
agreed to pay for. Their outputs feed back as COGS rows (`PRODUCT_COST`, build effort) in
`economics/model.csv`, and `/guild:board` tracks delivery and revenue after the build ships.

**Don't reach for:**
- `build` before the interview quota is met — it idles on `awaiting human: interviews` rather than
  inventing rows.
- `improve` to "get more customers" — sends are human sign-off rows; the loop will draft the
  sequence and stop.
- `board` to make the call — it computes the verdict from pre-committed numeric rows; deciding is
  yours.
- any command for legal, tax or financial rulings — compliance and finance rows stay red until a
  named accountant / lawyer signs.

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
