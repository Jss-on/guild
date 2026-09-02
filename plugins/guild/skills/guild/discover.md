---
name: guild:discover
description: "Domain recon → founder interview → drafted customer-interview kits → human-entered interview ledger → synthesis + ICP → validated Venture Requirements Spec (V-n rows, measurable) + segment/market-type election + a validate-clean build spec"
argument-hint: "[Goal: <idea|file>] [Segments: <candidate, candidate>] [Capabilities: forge|anvil|both] [--chain build]"
---

EXECUTE IMMEDIATELY.

The **customer-discovery engineer** of the business pipeline. Takes a founding idea and runs
evidence-first discovery to a validated **Venture Requirements Spec (VRS)** plus a ready
`$guild build` spec. The discipline: **no assumption without a metric, no metric without a
threshold with a direction, no threshold without a test method on the validation ladder, and no
interview row the loop wrote itself.** Companion contracts:
`references/discovery-protocol.md` (hypotheses, consent RA 10173, Mom-Test ledger, synthesis,
saturation, ICP, election) and `references/venture-requirements-protocol.md` (V-n measurability,
validation ladder, must-be checklist, exit criteria, the validate contract).

## Seam & reference resolution (read once)

Resolve `GUILD_ROOT` as in SKILL.md (plugin root → `.claude/skills$guild` → command-file dir →
glob for `scripts/score-guild.sh`). Read every `scripts/<x>` as `$GUILD_ROOT/scripts/<x>`
(repo-root `scripts/` fallback inside this harness repo) and every `references/<x>` as
`$GUILD_ROOT/references/<x>`. Run `bash scripts/doctor.sh` once at Phase 0; STOP on
`DOCTOR: BLOCKED`.

## Parse arguments

- `Goal:` — the idea, inline or a file. Absent → the wizard asks for it first.
- `Segments:` — candidate segment names to seed §Phase 2 (optional; hypotheses, not elections).
- `Capabilities:` — what the studio can build (`forge` software, `anvil` hardware, `both`);
  calibrates feasibility rows and the COGS seam.
- `--chain build` — hand the validated spec straight to `$guild build` via the handoff.

## Run directory & deliverables

`guild/discover-{YYMMDD}-{HHMM}/` containing:

- `recon/brief.md` — domain recon with `[C-n]` citations; `evidence/sources.tsv` + `evidence/claims.tsv`
- `discovery/assumptions.csv`, `discovery/segments.csv`, `discovery/codes.csv`, `discovery/icp.yaml`, `discovery/exit-memo.md`
- `discovery/interviews.tsv`, `discovery/consent.tsv`, `discovery/commitments.csv` — **human-entered**; the loop reads them and never writes them
- `drafts/` — interview script, screener, consent form, recruiting plan, candidate rows
- `vrs/requirements.md` — the VRS (V-n rows per the protocol)
- `venture.spec.yaml` — must pass `scripts/score-guild.sh validate`
- `open-questions.md` — every undecided item with a recommended default and a decide-by date
- `discover-results.tsv` — gate outcomes (7-col guild-results format) for evals
- `handoff.json` — schema v3.1.0, `source: "discover"`, `spec` + `vrs` paths; validated with `scripts/validate-handoff.sh handoff.json discover`

## Phase 0 — Domain recon (before the first question)

Research the domain FIRST so the founder reacts to evidence instead of recalling from memory:
market structure and obvious alternatives, competitor price points, regulatory surface
(DTI/SEC/BIR posture, DPA touchpoints, sector rules), buyer norms. Write `recon/brief.md` with
every number carrying a `[C-n]` that resolves in `evidence/claims.tsv` (sources per
`references/evidence-protocol.md`: locator, retrieval date, archive, hash). Gate it:
`scripts/score-guild.sh citations recon/brief.md evidence/claims.tsv` must emit
`UNSOURCED_CLAIMS: 0`. A CAPTCHA page is not a source.

## Phase 1 — Founder interview (request_user_input, rounds of ≤ 4 questions)

Interview the founders in batched rounds — **max 4 questions per round, each with a recommended
default** (non-interactive: derive the default and log it as an explicit assumption in
`open-questions.md`). Cover: thesis (who hurts, how do we know), capabilities and build seams
(forge/anvil), constraints (time/week, geography, language), cash and runway posture, segment
candidates (≥ 2 for contrast), market-type hypothesis (existing / resegmented / new — with its
cash-horizon consequence), consent posture (who conducts interviews, incentive budget), and the
early irreversibles as decisions-with-dates, never defaults.

## Phase 2 — Hypotheses + drafted interview kits (the loop drafts; humans conduct)

1. Write `discovery/assumptions.csv` — every hypothesis "We believe that…", typed D/F/V/A,
   importance × evidence scored by a human, risk-ranked; the riskiest 3 named.
2. Write `discovery/segments.csv` — one row per candidate segment with job story + market type.
3. Draft into `drafts/`: `interview-script.md` (Mom-Test discipline: past behaviour, no pitching,
   advancement asks), `screener.md` (SPI fields only with explicit-consent checkboxes),
   `consent-form.md` (RA 10173: freely given, specific, informed; pseudonyms; deletion date),
   `recruiting-plan.md` (where the users are; no scraped lists).
4. **The hard rule: humans conduct the interviews and enter `discovery/interviews.tsv` and
   `discovery/consent.tsv` (schemas in evidence-protocol §5). The loop NEVER writes those
   ledgers** — it may convert pasted call notes into `drafts/interviews-candidate.tsv` for a
   human to review and move. Interactive: STOP here and ask for the ledger when it is empty.
   Non-interactive with no ledger: write `handoff.json` with `status: BLOCKED` naming what is
   missing, and finish.

## Phase 3 — Synthesis (quota + saturation gates)

When ledger rows exist: code the interviews (`discovery/codes.csv`), write job stories, update
the assumption map, and run the mechanical gates —

- `scripts/score-guild.sh interviews discovery/interviews.tsv discovery/consent.tsv` →
  `INTERVIEW_VIOLATIONS: 0` required. Violations (consent joins, SPI, deletion dates, early
  pitching, quota ≥ 12 per active segment, evidence-grade ≥ 50 %) go back to the humans by row;
  saturation and cadence are read from stderr (`new_codes_count` 0 on the last 3 = saturated;
  below quota or unsaturated = keep interviewing, ≥ 1/week).
- Build `discovery/icp.yaml` (layout in discovery-protocol §8) from the ledger and run
  `scripts/score-guild.sh icp discovery/icp.yaml discovery/interviews.tsv` →
  `ICP_VIOLATIONS: 0` (every leaf ≥ 3 interview ids, four forces, five beachhead criteria,
  ≥ 3 anti-ICP disqualifiers, decision maker, procurement mode).
- Write `discovery/exit-memo.md`: top problems + what they pay today, concept agreement + WTP,
  day-in-the-life before/after, buyer org chart.

## Phase 4 — VRS + election (measurability gate, human sign-off)

1. Write `vrs/requirements.md`: every surviving assumption becomes a `V-n` fenced block —
   statement ("We believe…"), type D/F/V/A, metric, threshold (number + direction), test method
   on the validation ladder (paid pilot > LOI > pre-order > commitment > interview > survey >
   desk), evidence grade within the method's ceiling, risk_rank, owner, decide_by. Disposition
   the **must-be checklist** (payment terms/EWT, compliance, delivery capacity, cash horizon,
   founder time, decision maker, after-sales, procurement route, privacy, whole product).
2. `scripts/score-guild.sh vrs vrs/requirements.md` → `VRS_MEASURABLE: y/y` (all rows) required;
   the riskiest 3 must be do-class or the gate says so.
3. **Segment + market-type election — a human sign-off row.** Present the evidence per segment
   (interviews_n, evidence-grade, money commitments, saturation) and ask the founder to elect
   AT MOST ONE segment (request_user_input, with a recommended default). Record the market type alongside it and
   `elected/elected_at/elected_by/board_ack` in `discovery/segments.csv`; the loop never marks
   it. Election requires the gates above green for that segment.

## Phase 5 — Validation, read-back, handoff

1. Generate `venture.spec.yaml` from the elected ICP + VRS: `name`, `thesis`, `segment: icp:`
   (the election), `acceptance:` across all seven dimensions with `gate: true` rows on evidence,
   customer and economics, every row `traces: V-n`.
2. Mechanical: `scripts/score-guild.sh validate venture.spec.yaml` → `VALIDATION: VALID`;
   `scripts/score-guild.sh coverage --spec venture.spec.yaml vrs/requirements.md` →
   `REQ_COVERAGE: 1.00` (orphans on stderr are fix-now items).
3. Write `discover-results.tsv` (gate outcomes with `evidence:` paths), `open-questions.md`
   (each with a recommended default and decide-by), and `handoff.json`
   (`version: 3.1.0`, `source: "discover"`, `status: COMPLETE|BLOCKED`, `timestamp`, `spec`,
   `vrs`, `interviews: <n>`); run `scripts/validate-handoff.sh handoff.json discover`.
4. Read-back: one request_user_input round confirming the election, the riskiest-3 test plan and
   the open questions with defaults (non-interactive: log as assumptions).
5. Verdict line: `DISCOVER: READY` (all gates green, spec valid) or `DISCOVER: BLOCKED <what>`.
   `--chain build`: invoke `$guild build Spec: venture.spec.yaml` with the handoff.

## Safety invariants (inherited from SKILL.md)

Never send outreach, publish, spend, sign or file — drafts only; every send is a human act. Never
fabricate interview, consent or commitment rows: those ledgers are human-entered, and a gate that
reads them reads what a human typed. Consent is RA 10173-shaped (freely given, specific,
informed; SPI needs explicit consent; pseudonyms; deletion dates). Not legal, tax or financial
advice — statute-touching rows carry sources and `verified_on` dates for a professional to check.
