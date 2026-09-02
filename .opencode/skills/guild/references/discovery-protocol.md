# Discovery Protocol — hypotheses, consented interviews, synthesis, experiments, election

Companion to `/guild_discover` and Phase P2 of `/guild_build`. This is the doctrine the loop
follows from "we have an idea" to "we have an elected segment, an evidenced ICP and a set of
tested assumptions". Research basis: brief 01, `research/raw/01-customer-discovery.md`
(retrieved 2026-09-02; `[S#]` below = its §8 source list; grades P1 primary / P2 secondary /
P3 weak), plus the ICP sheet from brief 03 §5 G3.3 (cited as `03[S#]`). The interview and consent
ledger schemas are defined once in `references/evidence-protocol.md` §5 and reused here unchanged
so the same validators apply. Gates owned by this protocol: `interviews`, `icp`
(`scripts/gates/interviews.sh`, `scripts/gates/icp.sh`); the VRS built on top of it is
`references/venture-requirements-protocol.md`.

## §0 The five rules

1. **There are no facts inside the building — so get outside** (Blank [S3]). Every customer,
   problem, product, channel and pricing statement is a *guess* until a ledger row supports it.
   Guesses are written as hypotheses — "We believe that…" — never as facts [S13].
2. **Say ≠ do.** Stated intentions, compliments and "would you buy?" answers are opinions.
   Evidence is past behaviour and commitments of time, reputation or money [S6][S11][S12]. The
   ledger encodes this as columns (`past_behavior`, `current_spend_php`, `current_spend_time`,
   `wtp_signal`, `commitment_type`, `evidence_kind`), so compliments are excluded by construction,
   not by judgment.
3. **Humans write the human ledgers; the loop drafts.** `discovery/interviews.tsv`,
   `discovery/consent.tsv` and `discovery/commitments.csv` are human-entered. The loop writes
   interview scripts, screeners, consent forms and candidate rows into `drafts/` and surfaces the
   row a human must fill. A gate that reads a human ledger reads what a human typed.
4. **Consent is statutory, not etiquette.** RA 10173 (the Data Privacy Act) makes interview
   recordings and attributable quotes personal information; the consent ledger implements its
   sections mechanically (§4 below) [S25].
5. **Elect narrow, then widen — never the reverse.** Superhuman moved its PMF score from 22 % to
   33 % by *narrowing* the respondent set to its High-Expectation Customer, then to 58 % three
   quarters later [S8]. Segment election is the first irreversible (§13).

## §1 Hypotheses — `discovery/assumptions.csv` (loop-written; scores human)

```
id, statement, type, importance, evidence, risk, experiment_ids, status, owner, scored_by, scored_at
```

- `id` `A-<n>`, unique · `statement` MUST start `"We believe that …"` — one falsifiable sentence
  [S13] · `type ∈ D|F|V|A` — Desirability (do they want it), Feasibility (can we build/deliver
  it), Viability (does it pay), Adaptability (does the environment allow it) [S13][S11]
- `importance` 1–5 and `evidence` 0–3 are **human-scored** (`scored_by`, `scored_at` are a human
  sign-off row — the machine cannot know what matters to the venture) [S13]
- `risk = importance × (3 − evidence)` — high importance with little evidence is a leap-of-faith
  assumption · `status ∈ open|supported|refuted` · `experiment_ids` join §9

## §2 The assumption map — riskiest first

Plot every hypothesis on importance × evidence. The top-right quadrant — "critical for success
and yet have the least amount of evidence" — is the leap-of-faith set and is tested FIRST
[S13][S11]. Rules (brief 01 G1):

- The top-3 assumptions by `risk` (policy N=3, `GUILD_RISKIEST_N`) each need ≥ 1 linked experiment
  with a recorded verdict before any build step or paid experiment starts.
- No assumption with `importance ≥ 4` and `evidence = 0` may remain `open` when a build starts.
- "Reduce uncertainty as much as you can before you build anything" [S14]. Testing convenient
  assumptions instead of riskiest ones is the named anti-pattern this blocks [S13].

## §3 Segment + market-type hypothesis — `discovery/segments.csv`

```
segment_id, icp_firmographics, persona_role, job_story, market_type, interviews_n,
evidence_grade_n, commitments_money_n, elected, elected_at, elected_by, board_ack
```

- ICP = firmographics/technographics of the *account*; persona = the person and the progress they
  want (03[S27], P3 — vendor consensus). The `job_story` is written "When ___, I want to ___,
  so I can ___" [S15] — jobs and motivations, never demographics-only personas [S16].
- `market_type ∈ existing | resegmented_lowend | resegmented_niche | new` [S3]. This hypothesis
  has a **cash-horizon consequence**: a new market can be "unprofitable for 5 or more years"
  while an existing market is "generating cash in 12–18 months" (Blank, P1 [S2] — Handspring did
  $170M in year one in an existing market). "Market Type effects everything you do in this step:
  Positioning, Branding, Spending, Launch" [S3]. It is an early irreversible (§16) and feeds the
  viability rows of the VRS.
- One row per candidate segment. Two contrasting candidates minimum (policy): a discovery that
  never compared segments cannot claim to have chosen one.

## §4 Recruiting + consent (RA 10173) — `discovery/consent.tsv` (human-entered)

Recruit where the users already are — YC founders "dropped by fire stations in person" [S7]; for
a PH studio that means industrial associations, supplier introductions and peer referrals, never
scraped contact lists (SKILL.md safety invariant).

Statutory mechanics, encoded in the ledger (all P1, statute text [S25]):

- Consent must be **"freely given, specific, informed"** (§3(b)). Specific means the recording
  and quotes may be used only for the consented purpose; re-use for marketing needs fresh consent.
- **Age, marital status, health and education are sensitive personal information (SPI, §3(l)).**
  A screener that collects any of them triggers §13: processing prohibited except with consent
  "specific to the purpose prior to the processing". Either drop those fields or set
  `spi_collected=Y` with `spi_explicit_consent=Y` from a dedicated checkbox.
- **Retention (§11)** → every consent row carries `deletion_due`; no interview row may be used
  past it. **Data-subject rights (§16)** → `participant_id` is a **pseudonym** (names and contact
  details stay outside the repo), `withdrawal_date` stops all use, and a deletion path must exist.
- Penalties for violation run 6 months–7 years imprisonment and ₱100,000–₱4,000,000 in fines
  (§§25–32 as summarised) [S25] — consent is a hard 100 % gate, not a percentage.

Schema (from `evidence-protocol.md` §5, unchanged):

```
participant_id  date  consent_version  recording  quotes_allowed  spi_collected
spi_explicit_consent  incentive_given_at_start  withdrawal_date  deletion_due
```

Incentives are given **at the start** and are never contingent on positive feedback — the
participant can withdraw and keep the incentive [S20][S21]. `drafts/consent-form.md` (loop-drafted,
human-issued) carries modular checkboxes: recording Y/N, quotes Y/N, SPI fields Y/N, retention
date, withdrawal contact — plain language, in the participant's language.

**Bias note (why the ledger weights behaviour):** social desirability is measurable in Filipino
samples — Cagasan (2016) built a Filipino Social Desirability Scale (reliabilities .706 n=157,
.731 n=162) precisely because Western instruments may not transfer [S26, P1 peer-reviewed]. That
is evidence that stated-attitude data needs a bias control, not that Filipinos are more biased
than others; the *hiya*/*pakikisama* mechanism is practitioner consensus, UNVERIFIED. Weight past
behaviour and commitments, never agreement or praise. Interview in the respondent's preferred
language (Tagalog/Bisaya/English/Taglish) and keep verbatims in the original language —
practitioner consensus, UNVERIFIED.

## §5 The interviews — Mom Test discipline; `discovery/interviews.tsv` (human-entered)

The Mom Test rules [S6, P2 notes of the book]: **talk about their life, not your idea; ask about
specifics in the past, not generics or opinions about the future; talk less and listen more.**
YC's five questions [S7]: hardest part? last time it happened? why was it hard? what did you try?
what don't you love about the attempts? First problem interviews run 10–15 minutes [S6]; experts
get up to an hour.

- **No pitching.** "Stop selling, start listening" [S3]; the interview "is not the time to be
  pitching the product" [S7]. The moment the solution is revealed, the respondent is contaminated
  — and in a small Philippine niche the pool does not refill [S6]. Ledger rule:
  `solution_revealed = N` for the **first 6 interviews of every segment in date order** (policy
  `GUILD_INTERVIEW_NOPITCH=6`; solution conversations come after the problem is established).
- **Record it or quote it.** `recorded = Y` (with consent `recording=Y`) or a non-empty
  `verbatim_quote` (with `quotes_allowed=Y`) on 100 % of rows [S6][S7].
- **End with advancement.** A meeting that ends without a commitment of **time, reputation or
  money** "was pointless" [S6]. `commitment_type ∈ none|time|reputation|money`,
  `commitment_detail`, `next_step_date`. Currencies: time = another meeting, an observation
  shift; reputation = an introduction to a buyer or peers; money = an LOI, a deposit, a paid
  pilot.
- **Earlyvangelists** — "Only earlyvangelists are crazy enough to buy" [S3]: respondents who have
  the problem, know they have it, have budget and have hacked a workaround. Tag them via
  `workaround` + `commitment_type`; they become the first references, which is itself an
  irreversible (§16).

Schema — 25 columns + optional `evidence_kind` (evidence-protocol §5; the gate matches columns by
header name):

```
interview_id  date  segment_id  role  org_type  org_size  channel  language  interviewer
consent_id  recorded  solution_revealed  top_pains  last_occurrence_date  past_behavior
workaround  current_spend_php  current_spend_time  wtp_signal  verbatim_quote  commitment_type
commitment_detail  next_step_date  new_codes_count  snapshot_link  [evidence_kind]
```

- `consent_id` = the `participant_id` (pseudonym) of the consent row; the join is a hard rule.
- `top_pains` = comma/semicolon-joined code ids from the codebook (§6); `last_occurrence_date` =
  when the pain last actually happened (a pain with no last occurrence is a story).
- `past_behavior` = what they DID, dated; `workaround` = what they built or bought instead;
  `current_spend_php` / `current_spend_time` = what the problem costs them today per month.
- `wtp_signal ∈ unprompted|prompted|none` — unprompted willingness-to-pay is the only strong say
  signal.
- **Evidence-grade row** (brief 01 G4): `past_behavior` non-empty AND (`current_spend_php > 0` OR
  `current_spend_time > 0` OR `wtp_signal ≠ none` OR `commitment_type ≠ none`).
  `evidence_kind = do` for behaviour/commitment rows, `say` for opinion rows; if the column is
  present, `do` on a non-evidence-grade row is a violation (typed evidence must be evidence).
- Every date is compared against `guild_today` — the ledger carries `# as_of: YYYY-MM-DD` as its
  first line so gate results never decay with the calendar.

**Who writes what:** humans conduct the interviews and enter the rows. The loop drafts
`drafts/interview-script.md` (opening, five questions, deflections for compliments/fluff/ideas,
advancement asks), `drafts/screener.md`, `drafts/consent-form.md` and — from call notes a human
pastes — candidate rows in `drafts/interviews-candidate.tsv`. A human moves rows into the ledger.

## §6 Synthesis — codes, job stories, saturation

After every batch: affinity-map observations (5–10 minutes of silent generation, cluster,
dot-vote, assign owners) [S18]; code each interview against the codebook; write job stories.

`discovery/codes.csv` (loop-written from human coding sessions):

```
code_id, code, segment_id, first_interview_id, mentions, coder_id, created_at
```

- Double-code a random 20 % of interviews and record agreement (policy — the coding itself is
  human judgment; the gate only reads counts).
- `new_codes_count` in the interview ledger = how many NEW codes this interview added. The
  stopping rule reads it mechanically: **saturation = `new_codes_count = 0` for the last 3
  consecutive interviews of the segment** (policy k=3, `GUILD_INTERVIEW_SATURATION_K`;
  Fitzpatrick's informal version: stop when "you can predict what they will say next" [S6]).
- Anchors: code saturation lands around the **12th interview** and ~80 % of codes appear within
  the **first 6** in homogeneous samples (Guest, Bunce & Johnson 2006, *Field Methods*
  18(1):59–82; P2 via [S23]); Hennink, Kaiser & Marconi 2017: code saturation 9–17, *meaning*
  saturation 16–24 [S23]. The I-Corps reference ceiling is ≥ 100 interviews in 7 weeks [S22, P1];
  Blank's often-quoted "50–100" is UNVERIFIED and not used.
- Cadence: ≥ 1 interview per week while discovery is open, snapshot within 15–20 minutes of the
  call (Torres [S24, P1]). One interview snapshot per conversation (`snapshot_link`): quick
  facts, memorable quote, opportunities, insights.

## §7 Discovery exit — quota, evidence grade, the Blank memo

Mechanical preconditions (gate `interviews`, §14):

| Rule | Threshold | Source |
|---|---|---|
| Interviews per segment under active discovery | ≥ 12 (`GUILD_INTERVIEW_QUOTA`) | saturation anchor [S23]; harness floor |
| Before any theme is called "common" | ≥ 6 interviews (`GUILD_INTERVIEW_COMMON`) | 80 %-of-codes-by-6 [S23] |
| Evidence-grade share per segment | ≥ 50 % (`GUILD_INTERVIEW_EVIDENCE_PCT`) | policy (G4) |
| Cadence while open | ≥ 1/week (stderr, informational) | [S24] |
| Saturation | `new_codes_count=0` × 3 (stderr) | [S23][S6] |

Then the **discovery exit memo** `discovery/exit-memo.md` answers Blank's exit questions [S3]:

1. What are the customers' top problems — and **how much will they pay** to solve them?
2. Does the product concept solve them — do customers agree, and how much will they pay?
3. **Draw a day-in-the-life** of the customer before and after the product (for the beachhead
   account: the count day, the stockout, the audit — before/after, hour by hour).
4. **Draw the org chart of users and buyers** (economic buyer, champion, decision maker,
   relationship owner — the same roles the ICP sheet carries, §8).

A memo whose numbers do not trace to interview ids or `[C-n]` claims fails the citations gate.

## §8 The ICP sheet — `discovery/icp.yaml` (gate `icp`)

The evidenced profile of the candidate (later elected) segment — brief 03 §5 G3.3, with the four
forces from Moesta/Spiek (03[S25]) and the beachhead criteria from 03[S18]. **Layout is the
`guild_yaml_json` subset — block maps, block lists, flow lists for ids — and every leaf is a map
`{ value, evidence_interview_ids }`:**

```yaml
segment_id: smb-mfg               # must exist in interviews.tsv
firmographics:
  industry:      { value: "…", evidence_interview_ids: [I-1, I-2, I-4] }
  size_band:     { value: "…", evidence_interview_ids: [I-1, I-2, I-5] }
  geography:     { value: "…", evidence_interview_ids: [I-1, I-3, I-4] }
  revenue_band:  { value: "…", evidence_interview_ids: [I-5, I-7, I-10] }
roles:
  economic_buyer:      { value: "…", evidence_interview_ids: […] }
  champion:            { value: "…", evidence_interview_ids: […] }
  decision_maker_role: { value: "…", evidence_interview_ids: […] }   # non-null — who signs
  relationship_owner:  { value: "…", evidence_interview_ids: […] }
technographics:                    # list of leaves, ≥ 1
  - value: "…"
    evidence_interview_ids: [I-1, I-2, I-12]
pains: [ … ]                       # list of leaves, ≥ 1
triggers:                          # the four forces — all four buckets non-empty
  push: [ … ]                      # what pushes them off the status quo
  pull: [ … ]                      # what attracts them to a new way
  anxiety: [ … ]                   # what makes them hesitate
  habit: [ … ]                     # what keeps them where they are
buying_process:
  procurement_mode:        { value: private, evidence_interview_ids: […] }
  payment_terms_expected:  { value: "…", evidence_interview_ids: […] }
  withholding_class:       { value: "…", evidence_interview_ids: […] }
beachhead_criteria:                # all five, each with a value and evidence
  burning_pain: { … }  willingness_to_pay: { … }  growth: { … }  access: { … }  expandable: { … }
anti_icp:
  disqualifiers:                   # ≥ 3; rule + evidence_interview_ids or evidence_claim_ids
    - rule: "…"
      evidence_interview_ids: [I-15, I-16]
```

Rules (gate `icp`, §14): every leaf ≥ 3 distinct interview ids that exist in the ledger
(`GUILD_ICP_MIN_IDS=3`; ≥ 5 once the segment has ≥ 20 interviews — the profile must deepen as the
evidence pool grows); ICP leaves cite only the ICP's segment, while **anti-ICP rules may cite any
segment** — worst-fit respondents are exactly their evidence (03[S17]); all four force buckets
non-empty (a force nobody voiced is a force nobody heard — "you hear them live in a good
interview", 03[S25]); all five beachhead criteria present with a value (03[S18]);
`decision_maker_role` non-null — PH buying is relationship-first and hierarchy-heavy, and a deal
without a named signer stalls (03[S36], P3 culture guide; corroborated only indirectly by the ITA
country guide); `procurement_mode ∈ private|philgeps_lcrb|philgeps_mearb|philgeps_consulting`,
and any `philgeps_*` mode requires `philgeps_certificate_status` — the ₱5,000 Platinum
certificate is a prerequisite and "the official receipt … is not equivalent to the issuance of
the certificate" (03[S35], P1).

## §9 The experiment ladder — say → do; `discovery/experiments.csv`

```
exp_id, assumption_id, type, evidence_kind, setting, cost_php, setup_days, run_days, metric,
pass_criterion, preregistered_at, started_at, n, result, verdict, learning, spend_approved_by
```

- `type ∈ interview|survey|landing_page|concierge|wizard_of_oz|mock_sale|pre_sale|LOI|paid_pilot|crowdfunding`
  · `evidence_kind ∈ say|do` · `verdict ∈ pass|fail|inconclusive`
- **Climb the ladder cheap → expensive, say → do** [S11][S12][S14]: interviews and surveys first,
  then landing pages, concierge and Wizard-of-Oz, then mock sales, pre-orders, LOIs and paid
  pilots. The Testing-Business-Ideas library grades 44 experiments by cost, setup/run time and
  evidence strength [S11]; pacing reference: "12 experiments in 12 weeks" [S14].
- **Pre-registration is mandatory:** `preregistered_at < started_at` on 100 % of rows — metric
  and pass criterion are fixed on a test card before the experiment runs, and a learning card
  records what came back [S12][S11]. Moving the goalposts after the data arrives is the
  anti-pattern this kills.
- Quantitative floors: n > 30 per quantitative test; in B2B, 50 % participation of a small
  defined pool is already excellent [S12, P1].
- The top-3 riskiest desirability assumptions each need ≥ 1 `evidence_kind=do` experiment — or a
  commitment (§10) where the market is B2B and n is structurally small (brief 01 G5).
- `spend_approved_by` is a **human sign-off**: the loop plans experiments; any peso spent, page
  published or message sent is a human act (SKILL.md safety invariants).

## §10 Commitments — `discovery/commitments.csv` (human-entered)

```
customer_id, segment_id, type, amount_php, date, doc_link, signed_by_human
```

`type ∈ next_meeting|intro_to_buyer|LOI|pre_order|paid_pilot|deposit`. Conversion of
conversations into commitments is the advancement engine [S6][S3]. Policy floor for
problem/solution fit: **≥ 3 money-class commitments** (LOI / pre-order / paid pilot / deposit)
from the candidate segment (N=3 is harness policy — Blank's criterion is "a set of orders ($'s)
validating the roadmap" without a number [S3]); commitment rate over the last 10 interviews
should trend up (policy, stderr-level signal). Sending, signing and invoicing are human-gated.

## §11 Validation, PMF and retention (post-MVP gates this protocol feeds)

**Customer Validation exit** (Blank [S3]): a proven, repeatable sales roadmap; the org chart and
influence map; the sales cycle understood (ASP, LTV, ROI); a set of orders validating the
roadmap; a financial model that makes sense. If orders do not materialise, the process loops
**back to discovery** — the deck's only backward arrow — never to "sell harder".

**PMF survey** (brief 01 G7): Sean Ellis question — "How would you feel if you could no longer
use [product]?" — asked only of **engaged users (used ≥ 2× in the prior two weeks**, the
Superhuman sampling rule); pass = **≥ 40 % "very disappointed"**, computed **per segment**, with
"not disappointed" respondents politely disregarded from the roadmap, and **n ≥ 30** (policy;
Strategyzer's quantitative floor [S12] — Ellis's original benchmark base is UNVERIFIED) [S8][S7].
Superhuman's trajectory 22 % → 33 % (after narrowing to the High-Expectation Customer) → 58 %
three quarters later [S8, P1]; roadmap allocation 50/50 between doubling down on what users love
and fixing what holds back the somewhat-disappointed [S8]. Ledger `discovery/pmf_survey.csv`:
`respondent_id, segment_id, used_2x_in_2w, q1, q2_who_benefits, q3_main_benefit, q4_improve, date`.

**Retention cohorts** (brief 01 G8): `discovery/retention_cohorts.csv` —
`cohort_month, model, n0, m1..m6`. A cohort curve that **flattens** is the PMF signal (Balfour
[S9]); 6-month user-retention benchmarks by model (poll of 20 growth experts, US venture context,
P2 [S10]): consumer social ~25/45 %, consumer SaaS ~40/70 %, SMB SaaS ~60/80 %, enterprise
~70/90 % (good/great). Averaging across segments hides fit — report per segment [S8].

## §12 Pivot-or-persevere

Validated learning is the unit of progress [S4]. When the numbers say the model is not working,
make "a structural course correction to test a new fundamental hypothesis" using the ten-pivot
catalog (Ries via P2 [S5]): zoom-in, zoom-out, customer segment, customer need, platform,
business architecture, value capture, engine of growth, channel, technology. A pivot decision is
recorded (which hypothesis died, what was learned, which pivot type) and spawns NEW rows in
`assumptions.csv` — discovery restarts for a segment pivot. The board's pre-committed PIVOT rows
(references/metrics.md): PMF < 40 % on n ≥ 40, zero paid invoices by date D, OKR average < 0.3
for two quarters.

## §13 Segment election — the human sign-off row (brief 01 G9)

- At most **one** segment carries `elected = Y` in `discovery/segments.csv`.
- Election is allowed only when, for that segment: the interview quota and evidence-grade share
  pass (gate `interviews`), the ICP traces clean (gate `icp`), and ≥ 3 money-class commitments
  exist (§10).
- `market_type` must be non-null — it drives positioning, branding, spending, launch and the
  cash horizon [S3][S2].
- The election row carries `elected_at`, `elected_by` (a named human) and `board_ack`: **the loop
  never marks it**. The elected ICP becomes the `segment: icp:` line of `venture.spec.yaml` — a
  charter-level early irreversible checked by `score-guild.sh validate`.

## §14 Gate surface (what `interviews` and `icp` enforce)

`score-guild.sh interviews <interviews.tsv> <consent.tsv> [quota.tsv]` → `INTERVIEW_VIOLATIONS: N`

| # | Check | Threshold / env | Source (grade) |
|---|---|---|---|
| 1 | every row joins a consent row (`consent_id` → `participant_id`) | 100 % | RA 10173 §3(b) [S25] (P1) |
| 2 | `spi_collected=Y ⇒ spi_explicit_consent=Y` | 100 % | RA 10173 §13 [S25] (P1) |
| 3 | no row used past `deletion_due`; none after `withdrawal_date` | vs `guild_today` | RA 10173 §11, §16 [S25] (P1) |
| 4 | consent dated on/before the interview; `recorded=Y ⇒ recording=Y`; quote ⇒ `quotes_allowed=Y` | 100 % | consent is specific [S25][S20] |
| 5 | `recorded=Y` or `verbatim_quote` non-empty | 100 % | Mom Test / YC [S6][S7] (P2/P1) |
| 6 | `solution_revealed=N` for the first N interviews per segment, date order | N=6 `GUILD_INTERVIEW_NOPITCH` | contamination [S6][S7]; policy count |
| 7 | enums + dates + numerics valid; `evidence_kind=do` ⇒ evidence-grade | schema | G4 [S6][S12] |
| 8 | quota per segment under active discovery (quota.tsv lists segments + quotas; absent ⇒ most-interviewed segment at default) | ≥ 12 `GUILD_INTERVIEW_QUOTA` | saturation ~12 [S23] (P2) |
| 9 | evidence-grade share per active segment | ≥ 50 % `GUILD_INTERVIEW_EVIDENCE_PCT` | policy (G4) |
| 10 | cadence gaps, days-since-last, saturation, "< 6 = nothing common" | stderr only | [S24][S23] |

`score-guild.sh icp <icp.yaml> <interviews.tsv>` → `ICP_VIOLATIONS: N`

| # | Check | Threshold / env | Source (grade) |
|---|---|---|---|
| 1 | every leaf has value + ≥ k distinct existing interview ids | k=3 `GUILD_ICP_MIN_IDS`; 5 at ≥ 20 (`GUILD_ICP_MIN_IDS_20`/`_AT`) | 03 G3.3 (policy floors) |
| 2 | ICP leaves cite only the ICP segment; anti-ICP any segment | 100 % | trace integrity |
| 3 | 16 singleton leaves present (firmographics 4, roles 4, buying_process 3, beachhead 5) | present | 03[S17][S18] |
| 4 | four force buckets non-empty | ≥ 1 each | Moesta 03[S25] (P1) |
| 5 | anti-ICP disqualifiers | ≥ 3, each evidenced (`GUILD_ICP_MIN_IDS_ANTI`) | 03[S17] (P2) |
| 6 | `decision_maker_role` non-null | — | PH hierarchy 03[S36] (P3) |
| 7 | `procurement_mode` in enum; `philgeps_*` ⇒ certificate status | — | RA 12009 / PhilGEPS 03[S34][S35] (P1) |

## §15 What the loop drafts vs what humans enter

| Loop drafts (into `drafts/` or loop-owned ledgers) | Humans enter (the loop never writes) |
|---|---|
| `assumptions.csv`, `segments.csv` rows, `codes.csv`, `icp.yaml`, exit memo, experiment plans | `interviews.tsv`, `consent.tsv`, `commitments.csv` rows |
| `drafts/interview-script.md`, `drafts/screener.md`, `drafts/consent-form.md`, `drafts/recruiting-plan.md` | conducting interviews, issuing consent forms, incentives |
| `drafts/interviews-candidate.tsv` from pasted call notes | moving candidate rows into the ledger |
| election *proposal* with the evidence attached | the election itself (`elected_by`, `board_ack`), assumption scores, any send or spend |

## §16 Early irreversibles fixed in discovery

| Decision | Why one-way | Source |
|---|---|---|
| Segment election | positioning, channel, pricing, sales roadmap, references all accrete to it; a segment pivot restarts discovery; narrow → widen only | [S8][S3][S5] |
| Market-type hypothesis | commits the cash horizon (5+ years vs 12–18 months) and positioning/branding/spending/launch | [S2][S3] |
| Contaminating the participant pool | a pitched respondent stays biased; a small PH niche does not refill | [S6][S7] |
| Consent scope | quotes/recordings usable only for the consented purpose; retroactive widening impossible | [S25] |
| Business architecture / value capture | whole-model pivots if defaulted rather than evidenced | [S5] |
| First earlyvangelist references | the first signed customer becomes the reference story and shapes the roadmap | [S3] |

## §17 Failure modes this protocol guards against

| Anti-pattern | Guard | Source |
|---|---|---|
| Pitching in the interview | `solution_revealed` rule (§5) | [S6][S7] |
| "Would you buy?" hypotheticals | `past_behavior` + `last_occurrence_date` required for evidence-grade | [S6][S12] |
| Counting compliments as evidence | evidence-grade filter; share ≥ 50 % | [S6] |
| Meetings without advancement | `commitment_type` mandatory; zero-commitment streaks visible | [S6] |
| Treating say as do | `evidence_kind` column; riskiest need do-class tests | [S11][S12] |
| Building before reducing uncertainty | §2 riskiest-first + §9 pre-registration | [S13][S14] |
| Stopping too early or never stopping | quota floor + saturation stopping rule | [S23] |
| Small-n quantitative claims | n > 30 floor | [S12] |
| SPI without explicit consent; incentives contingent on praise | consent gate rules | [S25][S20][S21] |
| Averaging across segments | per-segment quotas, shares, PMF and retention | [S8] |
| Skipping the loop back from validation | §11 backward arrow | [S3] |

## §18 What these gates block

- An interview row with no consent join, sensitive fields without explicit consent, a row past
  its deletion date or after withdrawal, a recording nobody consented to.
- A "validated" segment built on compliments: quota shortfalls, evidence-grade share below 50 %,
  early pitching in the first six conversations.
- An ICP whose attributes trace to fewer than three interviews, cite phantom interview ids, skip
  a force bucket, name no decision maker, or claim a PhilGEPS route without the certificate.
- A segment election without the numbers behind it — the election row itself stays human.
