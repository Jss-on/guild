# Metrics Contract

The scoring spine. Everything here is mechanical; nothing here is impressions.

## guild-results.tsv (7 tab-separated columns)

```
n   dimension   assertion                                            status  weight  evidence                              traces
1   evidence    every market figure traces to a claims-ledger row    pass    1.0     evidence:evidence/claims.tsv          V-1
2   customer    12 interviews across 2 segments, consent recorded    pass    1.0     evidence:discovery/interviews.tsv     V-2
3   economics   gross margin >= 60 % at worst corner                 fail    1.0     evidence:economics/model.csv          V-4
```
`status ∈ pass|fail|skip` (skip = not applicable, excluded from scoring — never a parking lot for
hard rows). `weight` scales within the dimension. `evidence:` is a repo-relative path — a row
without evidence is `fail` by definition. `traces` = comma-joined `V-n` (the RTM against the VRS).

## Dimensions & weights (renormalized over dims that ran)

| Dimension | Weight | Owns |
|---|---|---|
| `evidence` | 0.25 | unsourced numeric claims = 0 · every source has locator + retrieval date · interview ledger complete + consented · no fabricated rows |
| `customer` | 0.20 | interview quota per segment · ICP attributes traced to ≥ k interviews · problem validated on the ladder · segment election recorded |
| `offer` | 0.15 | positioning statement complete · value proposition per segment · packaging tiers · pricing ladder with floor + band + justification |
| `economics` | 0.15 | model drivers cited · assertions (GM, LTV/CAC, payback, runway) hold at base AND worst corners · COGS from anvil/forge outputs where applicable |
| `gtm` | 0.10 | channel matrix · playbook stages · assets lint = 0 · funnel targets set · marketing calendar + experiments with thresholds |
| `operations` | 0.05 | delivery process (SOW → milestones → acceptance → invoice) · support/SLA · compliance register rows evidenced |
| `governance` | 0.10 | board pack derived from ledgers · decision log · risk register · numeric kill/pivot criteria · cadence kept |

**EVIDENCE GATE:** while ANY `evidence` row is red, headline pass-rate is capped at
`EVIDENCE_GATE_CAP` (default 0.50). A business built on invented numbers cannot be polished over.

**Must-pass:** `customer` and `economics` fails block the verdict — a beautiful deck for a
customer nobody interviewed, or an offer whose worst-corner margin is negative, is `NOT_READY`.

## Verdict grammar

| Verdict | Meaning |
|---|---|
| `NOT_READY` | evidence gate red, or a must-pass dim red, or rate < `TARGET_RATE` (1.00), or VRS coverage < 1.00 |
| `OPEN_FOR_BUSINESS` | ledger green — the offer, price, economics, plan, and compliance are ready for a human to launch |
| `FIRST_CUSTOMER` | `OPEN_FOR_BUSINESS` **and** `gtm/pipeline.tsv` holds ≥ 1 `won` row with an invoice id and `payment = evidence:<path>` |

`/guild:board` adds the governance verdicts `CONTINUE | PIVOT | KILL`, computed from the board pack
against the numeric criteria in `references/governance-protocol.md` — never from sentiment.

## Ledgers — human-entered vs loop-written

| Ledger | Writer | Notes |
|---|---|---|
| `evidence/sources.tsv`, `evidence/claims.tsv` | loop | schema in `evidence-protocol.md`; every source has a locator and a retrieval date; every claim cites ≥ 1 citable source |
| `discovery/interviews.tsv` | **human-entered** | who (role, segment — no personal data beyond need), when, consent, pains, past behavior, willingness-to-pay signal, quote; loop drafts scripts + candidate rows in `drafts/` |
| `gtm/pipeline.tsv` | **human-entered** | 10 cols: `id segment account stage value currency next_action updated invoice payment`; stage ∈ lead \| contacted \| meeting \| proposal \| won \| lost |
| `economics/model.csv` | loop | every driver row carries a `source` (claim id, interview id, or an anvil/forge output line) |
| `compliance/register.csv` | **human-entered** documents + sign-offs; loop writes the checklist rows | sign-off rows are `fail` until a named human marks them, never loop-passed |
| `board/decisions.tsv` | human + loop | decision, date, owner, review-by, outcome |

## score-guild.sh surface

| Subcommand | Emits (stdout, one line) | Status |
|---|---|---|
| `pass-rate [tsv]` | `PASS_RATE: 0.NN` | shipped — per-dim breakdown → stderr |
| `coverage [tsv] [vrs]` | `REQ_COVERAGE: 0.NN` | shipped — every V-n traced ≥ 1 row; orphans → stderr |
| `verdict [tsv] [vrs\|-] [pipeline]` | `NOT_READY \| OPEN_FOR_BUSINESS \| FIRST_CUSTOMER` | shipped |
| `citations <doc> <claims>` | `UNSOURCED_CLAIMS: N` | planned — numeric claims in a doc without a `[C-n]` ledger reference |
| `interviews <tsv> [quota]` | `INTERVIEWS: x/y` | planned — required fields, consent, per-segment quota |
| `icp <icp.md> <interviews>` | `ICP_TRACE: 0.NN` | planned — each ICP attribute cites ≥ k interview ids |
| `economics <model> [assertions]` | `ECON_PASS: x/y` | planned — assertions evaluated at base/worst/best corners |
| `pricing <pricing> <model> <competitors>` | `PRICE_VIOLATIONS: N` | planned — below floor, outside band without justification, VAT mishandled |
| `funnel <pipeline> [targets]` | `PAYING_CUSTOMERS: N` | planned — stage rates → stderr; won + invoice + payment evidence counts |
| `assets <dir>` | `ASSET_LINT: N` | planned — placeholders, missing ICP/offer/price/CTA, unsourced numbers |
| `compliance <register>` | `COMPLIANCE: x/y` | planned — document evidence per row; sign-off rows never auto-pass |
| `board <run-dir>` | `BOARD_PACK: OK \| STALE \| INCOMPLETE` | planned — sections derived from ledgers; staleness > cadence flagged |

## Goodhart guards

- **Ledgers, not prose.** No gate reads a narrative; every gate reads a TSV/CSV the loop cannot
  fabricate (human-entered) or must source (claims with locators + retrieval dates).
- **Worst corner wins.** Economics assertions must hold at the worst corner, not the base case;
  margins are recorded maximin.
- **Pinned snapshots.** Sources carry retrieval dates; competitor prices carry capture dates; a
  model built on stale inputs is flagged by `board` staleness.
- **Paired rows.** Every gate capability in the frozen scorer pairs a dispatch check with a fixture
  test — a hollow implementation cannot pass alone.
- **Human sign-off rows** (sends, spend, contracts, filings, professional review) are `fail` until
  a named human marks them; the loop's only move is to prepare the draft and surface the row.
