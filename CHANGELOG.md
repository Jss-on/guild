# Changelog

## 0.0.2 — 2026-09-02

Research pass + forge-grade seam. The scorer is re-frozen at 66 rows before the improvement loop
has run a single iteration; from here on it is never edited to pass.

- **Research dossier** `research/business-process-research-260902.md` synthesised from 12 domain
  briefs (`research/raw/01–12`, ~560 sources read 2026-09-02, graded P1/P2/P3, UNVERIFIED marked):
  discovery, market, positioning/offer, pricing, unit economics, GTM/sales, marketing, operations,
  PH legal/tax/compliance, finance ops/payments, governance/board, studio business model. Process
  map (12 phases with deliverables, gates, sign-off rows, irreversibles), gate registry (27 gates
  with planted-defect fixtures), ledger registry, early-irreversibles register, PH compliance
  register seed, open items.
- **`references/benchmarks.md`** — numbers annex (10 sections) with grade, source, retrieval date,
  policy tags and the verify-with caveat.
- **Frozen scorer v2** `scripts/score-e2e-capability.sh` — 66 rows: forge-style multi-token
  rubrics for 13 protocols and 6 commands; every gate = dispatch ∧ fixture test ∧ good/bad
  execution (the bad fixture carries a planted defect the gate must catch); template ledgers must
  pass their own gates; exemplar spec must validate; command contract rows; dossier row.
- **Seam** `scripts/score-guild.sh` — floored pass-rate with single weighted division;
  `--strict-evidence` / `GUILD_EVIDENCE_STRICT=1` (pass rows with unresolvable `evidence:` paths
  become fail); no implicit ledger discovery; unknown dims scored at 0.10 and named; `validate`
  (discover → build contract: name, thesis, segment/icp election, 7 dims with weights, gated rows
  in evidence/customer/economics); `verdict` honours strict evidence; `paying`.
- **Handoff** `scripts/validate-handoff.sh` — forge schema v3.1.0 with guild sources (discover,
  build, improve, board, guild) and expected-source check.
- **Contracts** — `references/metrics.md` (gate surface with inputs/outputs/checks per gate,
  verdict grammars incl. `CONTINUE | PIVOT | KILL`, ledgers writer table, fixture convention,
  Goodhart guards); `SKILL.md` (13 protocols mapped to briefs, ledgers, method provenance).
- **Tests** `tests/score.test.sh` — 38 cases (strict evidence, validate, handoff v3.1.0, verdicts).
- Corrections to v0.0.1 assumptions recorded in the dossier: services gross margin (SPI 35.9 %
  project margin, not 40–60 %), pipeline coverage = 1 ÷ win-rate (not 3×), 8 % option is
  individuals-only, "3–6 months reserve" unsourced, Stripe unavailable in PH, corporate
  InstaPay/PESONet fees survived the July-2026 waivers.

## 0.0.1 — 2026-09-02

Skeleton. The harness that will build businesses starts, like anvil did, with its own gate.

- `scripts/score-guild.sh` — scoring seam: `pass-rate` (7 weighted dimensions, EVIDENCE GATE cap),
  `coverage` (VRS `V-n` traceability), `verdict` (`NOT_READY | OPEN_FOR_BUSINESS | FIRST_CUSTOMER`;
  the last requires a human-entered `won` pipeline row carrying invoice + payment evidence).
- `scripts/score-e2e-capability.sh` — **frozen** 39-row end-to-end capability scorer (baseline 9/39).
- `tests/score.test.sh` + fixtures — the seam's own self-test (filter arg; zero matches = fail).
- `scripts/sync-plugin.sh`, `doctor.sh`, `validate-handoff.sh` — mirror parity, toolchain check,
  handoff gate, ported from anvil.
- `SKILL.md` + `references/metrics.md` — doctrine, safety invariants, scoring contract.
