---
name: guild
description: "Autonomous business-building iteration: modify, verify (citations/interviews/economics/funnel/compliance), keep/discard against evidence-anchored metrics — idea to first paying customer, then a standing board"
version: 0.1.0
---

# Guild — Autonomous Goal-directed Business Iteration

AutoForge's business sibling. Forge builds software, anvil builds hardware; **guild finds who pays
for them, at what price, and how — then sits as the board that keeps the business honest.** Same
loop discipline — one metric, constrained scope, fast mechanical verification, automatic rollback,
git as memory — with business-correct gates: unsourced-claim counts against a claims ledger,
interview quotas from a human-entered ledger, unit-economics assertions at base and worst corners,
pricing floor/band checks, funnel hygiene from a human-entered pipeline, a compliance register with
document evidence and deadlines, and a board pack derived from ledgers rather than prose.

The body of knowledge behind every protocol is `research/business-process-research-260902.md`
(12 domain briefs in `research/raw/`, ~560 sources, retrieved 2026-09-02, provenance-graded).

## Safety Invariants (all subcommands)

- **Never send, publish, spend, sign, or file** without explicit user approval: no outreach
  (email / DM / executed call scripts), no public pricing or pages, no purchases or ad spend, no
  contracts, no government filings, no bids, no securities. `OPEN_FOR_BUSINESS` and
  `FIRST_CUSTOMER` are verdicts, not actions. Drafts are the loop's output; sends are the human's.
  Every such act is a **human-gated sign-off row** the loop never marks `pass`.
- **Never fabricate evidence.** `discovery/interviews.tsv`, `discovery/consent.tsv`,
  `gtm/pipeline.tsv`, payments, acceptance records, certificates and compliance documents are
  **human-entered ledgers**: the loop reads and derives from them and may write candidate rows
  into `drafts/`, but never into the ledgers. A market figure without a claims-ledger row is
  `fail`, not "approximately right"; a CAPTCHA page is not a source.
- **Not legal, tax, or financial advice.** Compliance and finance rows carry accountant / lawyer
  sign-off the loop cannot pass. Philippine specifics (DTI/SEC, BMBE, LGU permit, BIR/EOPT
  invoicing, VAT threshold, the 8 % option, creditable withholding, SSS/PhilHealth/Pag-IBIG,
  Data Privacy Act, Internet Transactions Act, Consumer Act, IP Code) are elicitation prompts and
  register rows with sources and `verified_on` dates, not rulings.
- **Personal data is minimal and consented.** Interview and lead rows carry a `consent` field
  (RA 10173: freely given, specific, informed; sensitive personal information needs explicit
  consent); pseudonymous participant ids; deletion dates; no scraping of personal contacts into
  ledgers; marketing consent is opt-in, never "continued use".
- `build` pushes to the venture's **own private output repo** as part of the standard loop (that is
  how its CI runs); everything beyond that repo is human-gated. Repo visibility is never changed.
- Bounded by default. Override with `Iterations: unlimited`.
- All results logged to `guild/{subcommand}-{YYMMDD}-{HHMM}/`. Chain handoff via `handoff.json`
  (schema v3.1.0, `scripts/validate-handoff.sh`). Evals reads `*-results.tsv`.
- **Numbers come from ledgers and gates only** — the loop never self-certifies market size, margin,
  traction, or compliance by prose.

## Dispatch (bare `$guild`)

| Condition | Mode |
|---|---|
| `Metric:` or `Verify:` present | **Classic** — metric loop over an existing venture tree (an `improve` alias) |
| `Spec:` file or free-form goal | Route to `build` (greenfield venture) — confirm once |
| Nothing | **Setup wizard** — interactive config builder |

Print a banner on every invocation: `[guild] mode: classic | build | wizard`.

## Subcommands

| Command | Does | Default Iterations |
|---|---|---|
| `$guild` | Bare metric loop over an existing venture (`Metric:`/`Verify:`), route to `build` (`Spec:`/`Goal:`), or setup wizard | 25 |
| `$guild discover` | Domain recon → founder interview (≤ 4 questions per round) → drafted customer-interview scripts and consent forms → human-entered interview ledger → synthesis → validated **Venture Requirements Spec** (VRS: `V-n` rows — every assumption = metric + threshold + test method on the validation ladder) + segment / market-type election + a `validate`-clean `build` spec | N/A |
| `$guild build` | Full gated pipeline: charter (early irreversibles fixed) → discovery → market → offer + positioning → pricing → unit economics + cash → GTM + marketing → operations + finance + compliance → launch (human-gated sends/spend/bids) → **first paying customer** → standing board | 40 |
| `$guild board` | BOD cadence every 6–12 weeks: board pack derived from ledgers (KPIs vs plan, cash / runway / DEFAULT_ALIVE, pipeline coverage, delivery, headcount, risks, decisions due) → decision log → kill/pivot rows → `CONTINUE \| PIVOT \| KILL` | N/A |
| `$guild improve` | Optimization loop on an existing venture: maximize `conversion` \| `gross_margin` \| `ltv_cac` \| `utilization`, minimize `cac` \| `payback` \| `dso`, under a hard non-regression ratchet (evidence clean ∧ economics close ∧ compliance intact) | 20 |
| `$guild evals` | Analyze iteration results: trends, plateaus, regressions, funnel + cash trajectories | N/A |

**Status v0.1.0:** fully capable — the frozen `scripts/score-e2e-capability.sh` reads 66/66
(1.00): all 13 protocols, all 27 gates (fixture-tested, planted-defect-verified), all 6 commands,
the venture template and the studio exemplar ship. Next engagement: dogfood `$guild discover` on
the studio itself, then `$guild build Spec: evals/venture/studio.spec.yaml` in its own private
venture repo.

## The Dimensions (scoring contract)

Measured by `scripts/score-guild.sh pass-rate` over `guild-results.tsv`
(7 tab-separated cols: `n dimension assertion status weight evidence traces`):

| Dimension | Weight | Gate |
|---|---|---|
| `evidence` | 0.25 | **GATING** — any red row caps headline pass-rate at 0.50 |
| `customer` | 0.20 | must-pass (interview quota + evidence grade, ICP trace, VRS measurable, election) |
| `offer` | 0.15 | positioning lint, offers ledger, pricing book |
| `economics` | 0.15 | must-pass (model closes at base AND worst corner; cash; default-alive; studio KPIs) |
| `gtm` | 0.10 | funnel hygiene, experiments, assets lint, consent |
| `operations` | 0.05 | SOW, delivery, regulatory ship-blockers, AR, compliance register |
| `governance` | 0.10 | founders agreement, board pack from fresh ledgers, decisions + risks, kill rows |

Weights renormalize over the dimensions that actually ran. Full contract, gate surface, ledgers
and fixture convention: `references/metrics.md`.

## References (protocols the loop writes, each anchored to its research brief)

| Reference | Covers | Brief |
|---|---|---|
| `evidence-protocol.md` | sources/claims ledgers (forge research schema), tiers, retrieval + archive + hash, `[C-n]` citations, interview ledger + consent | 01, 02 |
| `discovery-protocol.md` | hypotheses + assumption map, market type, Mom-Test interviews, consent (RA 10173), synthesis, saturation, experiment ladder say→do, commitments, PMF/retention, pivot, segment election | 01 |
| `market-protocol.md` | sizing charter (unit/frame), segments + beachhead, bottom-up TAM + triangulation, alternatives + price snapshots, feature matrix, five forces, why-now, PH data-source catalog | 02 |
| `venture-requirements-protocol.md` | VRS `V-n` measurability, validation ladder, must-be checklist, Blank exit criteria, election sign-off | 01, 03 |
| `offer-protocol.md` | Dunford positioning, Moore statement lint, VPC, ICP/anti-ICP, whole product, paid discovery, G-B-B, bundling, guarantees, narrative, one-pager, pitch tests | 03 |
| `pricing-protocol.md` | WTP-first, cost floor, competitor band, VW/GG/CBC, metric/model, channel stack, tiers/anchors, discounts and increases, VAT/8 %/CWT/zero-rating | 04 |
| `economics-protocol.md` | metric dictionary, driver register, corners + sensitivity, unit economics, hardware landed cost, services KPIs, 13-week cash, default-alive, PH statute drivers, anvil/forge COGS seam | 05, 12 |
| `gtm-protocol.md` | motion by ACV, founder-led sales, outreach, MEDDPICC exits, paid pilots, proposals, paper process, forecast hygiene, coverage, scale gate, channels, PH procurement (RA 12009 / PhilGEPS) | 06 |
| `marketing-protocol.md` | STP/7Ps, brand vs activation, channel plan with PH reach data, assets checklist + lint, content clusters, tracking, experiments, consent, deliverability, ASC / RA 7394 / ITA rules | 07 |
| `operations-protocol.md` | MSA/SOW, deposits + milestone billing, acceptance, change control, IP, warranty, SLA, handover, NPI EVT/DVT/PVT, AQL, EMS/RFQ, NTC/BPS, Consumer Act, RMA, fulfillment, ops manual | 08 |
| `finance-protocol.md` | accounting policy triad, books/ORUS, invoicing (EOPT), 2307 workflow, substantiation, AR/dunning/legal interest, 13-week cash, rails + fees, FX rules, audit triggers, dashboard | 10 |
| `compliance-protocol.md` | register schema + deadline engine; entity, BMBE, LGU, BIR, VAT/8 %/withholding, audit, employer obligations, contractor test, DPA, ITA, Consumer Act, e-sign, IP Code, trademark, FIA | 09 |
| `governance-protocol.md` | founders agreement, strategy kernel, KPI tree, OKRs, board pack, ADRs + pre-mortems, risk register, default-alive, kill/pivot rows, funding instruments, PH ecosystem time-gates | 11 |
| `metrics.md` | scoring contract, verdict grammars, validate contract, ledgers, gate surface, fixtures | — |
| `benchmarks.md` | numbers annex with provenance grade, retrieval date and verify-with caveats | all |

## Ledgers — who writes what (summary; full table in `references/metrics.md`)

| Written by humans (the loop drafts into `drafts/`, never writes these) | Written by the loop (every row sourced) |
|---|---|
| interviews, consent, commitments, pitch tests, WTP interviews, tax elections, pipeline stage moves / sends / outcomes / invoices / payments, acceptance records, change-order signatures, certificates, compliance documents and professional sign-offs, founders agreement, money/legal decisions | sources + claims, assumptions + segments + experiments, market factors + alternatives + snapshots, positioning + offers + price book, economics model + assertions + cash forecast, campaign plans + assets + calendars, SOW drafts, compliance checklist rows, board pack, KPI derivations |

## Method provenance

The protocols embed — with citations in the claims ledger — customer development and lean
hypothesis testing (Blank, Ries, Bland/Strategyzer), interview discipline (Fitzpatrick's *The Mom
Test*), jobs-to-be-done, Disciplined Entrepreneurship (Aulet) and the beachhead (Moore),
positioning (Dunford; Moore's statement), the value proposition canvas (Osterwalder), pricing
(Simon-Kucher, Ramanujam, Van Westendorp, Gabor-Granger, conjoint, Mohammed's G-B-B, Marn &
Rosiello), unit economics (Skok, a16z, Bessemer, Sacks, Graham's default-alive, SPI benchmarks,
Bolt hardware economics), founder-led sales (Kazanjy, YC, Skok, Janz, MEDDPICC, Challenger),
B2B marketing (Binet & Field, Ellis, Balfour, Evan Miller), services delivery and hardware NPI
(SPI, Instrumental/Bolt/Fictiv, ANSI/ASQ Z1.4), Philippine statute (BIR, SEC, DTI, DOLE, NPC,
GPPB, NTC, BPS — official texts on lawphil.net and agency sites; Big-4 summaries as P2), and
governance (YC founders' equity, Sequoia board packs, Doerr OKRs, Amplitude North Star, Nygard
ADRs, Klein pre-mortems, Wasserman).

## Cross-harness seams

- **guild → forge / anvil:** the validated ICP + offer feed `/forge:requirements` and
  `/anvil:requirements` (`Client:` and goal), so what gets built is what someone agreed to pay for.
- **anvil / forge → guild:** `score-anvil.sh product-bom` (`PRODUCT_COST`) / `bom-cost`
  (`BOM_COST`) and forge build effort/cost feed the COGS rows of `economics/model.csv`; hardware
  regulatory rows (NTC / BPS) come from anvil's product spec.
- **after the build ships:** `$guild board` tracks delivery (operations), cash (finance) and
  revenue (pipeline).

## Universal Flags

| Flag | Applies To | Purpose |
|---|---|---|
| `Iterations: N` | All looping | Set iteration count |
| `Iterations: unlimited` | All looping | Opt-in unbounded |
| `--evals` / `--evals-interval N` | All looping | Mid-loop checkpoints + final summary |
| `--chain <targets>` | All | Sequential handoff after completion |
| `--dry-run` | build, board | Print derived config + planned pipeline / pack outline; no execution |

## Seam & reference resolution

Gates ship in `skills$guild/scripts/` and contracts in `skills$guild/references/`. Resolve
`GUILD_ROOT` to the FIRST that exists:
1. `${CLAUDE_PLUGIN_ROOT}/skills$guild` — installed plugin.
2. `.claude/skills$guild` — project-local install (or this repo's canonical tree).
3. The directory containing the invoked command file.
4. Last resort: glob `**/skills$guild/scripts/score-guild.sh` and take its grandparent.

Then read every `scripts/<x>` as `$GUILD_ROOT/scripts/<x>` (falling back to the repo-root
`scripts/` when running inside this harness repo) and every `references/<x>` as
`$GUILD_ROOT/references/<x>`. If nothing resolves, STOP and tell the user to reinstall — the gates
are mechanical requirements of the pipeline, not optional helpers.

Run `bash scripts/doctor.sh` once at Phase 0 of any command (`--require-build` for `build`).
