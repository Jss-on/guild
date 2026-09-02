# GTM Protocol — founder-led B2B sales, pipeline hygiene, Philippine procurement

Companion to `/guild_build` P8 and P11. The loop plans, drafts and lints; **a human sells**. Every
send, call, quote, pilot commitment, bid, contract and PO in this protocol is a human sign-off row
the loop never marks `pass` — send/call/quote/bid/sign rows are **never loop-passed**. Research
basis: `research/raw/06-gtm-sales.md` (S-numbered sources below, retrieved 2026-09-02; grades
P1 = primary/originator, P2 = reputable secondary, P3 = weak). Mechanical teeth:
`score-guild.sh funnel` over the human-entered deals ledger, `paying` for the verdict seam,
`consent` (with marketing) for every outreach row.

## §0 The three rules

1. **The loop drafts; the human sends.** Drafts of emails, scripts, proposals and bid packs live
   in `drafts/`. `gtm/pipeline.tsv` (`deals.csv`) and `gtm/outreach.csv` are **human-entered
   ledgers**: stage moves, sends, outcomes, invoices and payments are typed by the person who did
   them, with `human_approved_by` / `human_approved_at` on every outreach row.
2. **A deal is what the ledger says, not what the founder feels.** Forecast, coverage and win
   rate derive from ledger fields (dated next step, stage-exit flags, slips, staleness) — "feels
   warm" is not a field. HubSpot's rule verbatim: exit criteria are things like "discovery
   completed with decision maker," not "feels warm" [S20].
3. **Numbers cite.** Every benchmark in a GTM doc carries its `[C-n]` claims-ledger row per
   `references/evidence-protocol.md`; the figures in this protocol carry their brief-06 source
   anchors and grades.

## §1 Sales hypothesis, then a GTM plan

Selling starts with a written **sales hypothesis** (`gtm/hypothesis.md`): the customer segment,
their specific problem, and why this solution wins — Koomen's step zero [S9]. It names the ICP
(firmographics, decision-maker role, trigger event), the problem statement in the customer's
words (from discovery interviews, brief 01), and the value equation.

The **GTM plan** (`gtm/plan.md`) fills five fields — segment · value proposition · channel ·
pricing · sales motion — and must justify the motion by expected ACV (§2). A plan whose motion
does not match its ACV band is the classic self-kill: field-selling ₱150k projects or
self-serving ₱5M systems.

## §2 Motion by ACV — the deal size chooses the machine

| Expected ACV (Janz "animals") | Motion | CAC that motion can carry | Anchor |
|---|---|---|---|
| ~$100/yr | virality / paid, product-led, self-serve | ~$100 lead-gen per customer | Janz [S26] P2; Skok touchless example [S1] P1 |
| ~$1k/yr | inbound, no-touch self-serve | low hundreds | Janz [S26] P2 |
| ~$10k/yr | **inside sales** — "$10k per year usually isn't enough to make traditional enterprise field sales work" | "$400 to $5,000 per customer acquired" | Janz [S26] P2; Skok [S1] P1 |
| ~$100k/yr | **field sales** (enterprise) | up to "$100,000" per customer at ~10 deals/rep/yr | Janz [S26] P2; Skok [S1] P1 |

Skok's guardrails on any motion: LTV ≈ 3× CAC and CAC payback < 12 months [S1] (P1; illustrative,
SaaS-centric). a16z's layering rule: start bottom-up where a self-serve/product-led wedge exists
and add top-down sales only when users ask "How can I get this in the hands of my entire
department?" — "If you layer on sales too early… the organic motion never matures" [S2] (P1).
Leslie & Holloway (HBR 2006): a new product's selling process must be *learned* before it is
scaled — initiation, transition, execution phases each need "a different size—and kind—of sales
force"; "hiring a full sales force too early just causes the firm to burn through cash" [S4]
(P1, abstract; numeric thresholds paywalled). **No sales headcount before repeatability** is the
scale gate in §8. For a PH studio at ₱150k–₱2.5M ACV, the declared motion is founder-led /
inside; `targets.tsv` records `segment · primary · quarter_target_php · motion · acv_band` and
the funnel gate flags deals outside the band.

## §3 Founder-led sales — the ladder to the first 10 customers

Founder-led sales runs "from 0 to ~30 customers" before any sales hire (Kazanjy [S10] P1). The
Kolysh ladder [S7] (P1):

- **Customers 1–3: warm network.** Personal contacts, investors, communities. Anecdotal but
  directional: ~50 % LinkedIn connection acceptance and 20 % of those to calls for a founder with
  a sharp ask [S7].
- **Customers 4–10: manual, unscalable, in-person.** Graham: "You have to go out and get them" —
  recruit users one at a time (the Collison installation); weekly growth is the metric — 100
  users growing 10 %/week is 14,000 in a year [S6] (P1). Micro-events of 6–10 people; paid
  ($100–200/h) feedback sessions convert ~30 % of asks [S7].
- **Customers 10–50: tooling and sequences** — "prospecting tools only start to matter once you
  have 10 to 20 quality customers" [S7]. Sequenced outbound is unlocked only after §8's
  case-study gate.

**Outreach discipline** (`gtm/outreach.csv`, every row human-approved): founder emails are kept
**under 75 words** [S7] and never over 100 — Gong's 28M-email dataset puts the best replies at
3–4 sentences, "100 words or fewer", and shows pitching in a cold email cuts replies by as much
as 57 % [S15] (P2). Follow up **three or four times over a couple weeks** [S7]; follow-ups, not
first touches, carry the sequence, and the total cadence stays near the Bridge Group average of
10.6 attempts [S12] (P2, secondary). Expect cold outbound to be brutal arithmetic: 344 cold
emails per meeting booked on average (≈ 0.29 %), typical reply rates 1–5 % [S15][S12]. After
≥ 200 sends of a template, positive-reply < 1 % locks the template for rewrite. In the
Philippines, automation before ~10 customers reads as spam against a relationship-first market
(§9); warm and manual beats sequenced.

## §4 Discovery calls and qualification — MEDDPICC as the stage-exit checklist

A **discovery** call is questions, not pitch: Gong's 519,291-conversation dataset — top calls ask
**11–14 targeted questions**, surface **3–4 customer problems**, and keep talk:listen near
**46:54** [S16] (P2). Koomen's six questions and disqualify-fast discipline apply: "talking to
bad customers gives you the illusion that you're making progress" [S9] (P1). Discovery notes lint:
≥ 3 problems captured, pain quantified, next step dated.

Qualification frameworks and their caveats [S19] (P2): **BANT** (Budget, Authority, Need,
Timeline) is fast triage but authority "could be more than one person" and a strict timeline
cycles out next-year buyers; **CHAMP** prioritizes Challenges over Authority; **SPIN** (Rackham —
35,000 calls, 20 countries, 12 years) structures Situation → Problem → Implication → Need-payoff
questioning for larger sales [S22][S23]; Sandler adds the up-front contract [S21]. The harness
standard for multi-stakeholder deals is **MEDDPICC** (Dunkel at PTC, 1996 [S18]): Metrics,
Economic buyer, Decision criteria, Decision process, Paper process, Identify pain, Champion,
Competition — because its letters map one-to-one onto ledger columns and become **stage exit
criteria** the funnel gate enforces:

- No deal enters `proposal` without `economic_buyer_named=Y`, `metrics_agreed=Y` and a
  `decision_process_doc` on file.
- No deal sits in forecast `commit` without `paper_process_started=Y`.
- A **champion** is validated by an action, not a vibe — e.g. the champion brings the economic
  buyer to a meeting. Challenger research (CEB: > 6,000 reps, 83 companies): customers complete
  "nearly 60 % of a typical purchasing decision" before talking to a supplier; sell to
  Mobilizers, not Talkers — a senior Talker is "more likely to head to the graveyard than to the
  income statement" [S24] (P1). Buying committees average 6.8 stakeholders [S13] (P2);
  multi-threading lifts win rates +130 % on deals > $50k [S13].

## §5 Paid pilots — metric fixed before start, never free, never long

Blomfield's ladder [S8] (P1): design partnership → free pilot → **paid pilot** → recurring
contract. Unpaid 3–6-month partnerships are "where 90 % of founders get stuck"; a paid pilot of
"$10,000 or $20,000 charge on their corporate credit card" bypasses procurement approvals. The
pilot charter is fixed **before** start and linted by the funnel gate:

- `pilot_metric` — the single success metric the customer will judge, agreed in writing;
- `pilot_end_date` — time-boxed, **≤ 8 weeks** from start (Blomfield: two–three months is
  already "too long" [S8]);
- price > 0 — a ₱0 pilot is a violation, and an unpaid pilot (no price or never invoiced)
  running > 60 days is red;
- the post-pilot ROI **review meeting is scheduled before the pilot starts** [S8].

Close into a **recurring contract with a 30 or 60-day money-back / opt-out** rather than a
one-off pilot renewal [S8] — recurring-with-exit beats project-by-project re-selling.
**Implementation is the vendor's job**: "the single biggest mistake that founders make is
thinking that implementation is the customer's job" [S9]; Blomfield signed $4M and implemented
< $2M for lack of customer success [S8]. Onboarding plan and time-to-first-value are deliverables
before `won` means anything.

## §6 Proposals and the paper process

A proposal (`proposal_path` on the deal) carries: scope, deliverables, acceptance criteria,
timeline, **price with ≥ 2 tiers** and conservative-vs-aggressive ROI scenarios (Cranney's tiered
options [S3] P1), assumptions/exclusions, payment terms (days, milestones, currency), a validity
date, warranty/support, IP ownership, liability cap, signature block. Koomen on the number:
"Pick a number, ideally one that makes you a little uncomfortable" — his $10,000/month ask was
negotiated to $2,000 *and purchased anyway* [S9]; the first quote sets the anchor forever (§10).

The **paper process** — security review, privacy, legal redlines, procurement — is expected on
every enterprise/government deal; keep documents simple (Common Paper-style templates [S9]) and
log every redline. Fight only the **company-ending clauses** [S8]; the ledger's
`tripwires`/`clauses` column blocks on any of:

- **unlimited liability**,
- **IP transfer** / assignment of background IP,
- **exclusivity**,
- **auto-renew** without an opt-out window,

unless `tripwire_reviewed_by` names the human/lawyer who cleared it. Under RA 12009 §37 STI
direct procurement, IP in commissioned R&D goods **defaults to the Procuring Entity** unless
agreed otherwise [S32] — a statutory tripwire (§9).

## §7 The pipeline ledger and forecast hygiene (what `funnel` enforces)

`gtm/pipeline.tsv` (`deals.csv`) — one human-entered row per opportunity:

```
deal_id account segment source_channel stage stage_entered_at days_in_stage amount_acv
amount_tcv currency forecast_category probability owner next_action next_action_date
last_activity_at expected_close_date close_date_slips champion_named economic_buyer_named
metrics_agreed decision_criteria_doc decision_process_doc paper_process_started pain_statement
competition pilot_metric pilot_start_date pilot_end_date proposal_path payment_terms_days
withholding_pct po_number contract_signed_at invoice_date paid_date outcome loss_reason
loss_note [opened_at] [tripwires] [tripwire_reviewed_by]
```

`gtm/outreach.csv`: `send_id sequence_id template_id word_count contact_id channel sent_at
delivered replied reply_sentiment meeting_booked meeting_held opp_created human_approved_by
human_approved_at` — joined to the consent ledger by the consent gate.

**Forecast categories** (Salesforce defaults [S25] P2): `pipeline | best_case | commit | closed |
omitted` — one category per deal, mapped from stage, with the definitions written down per org
("how each forecast category is defined can be different based on your business process" [S25]).
The weekly pipeline review reads only ledger-derived lines:

- **Next step**: any open deal with an empty or past `next_action_date` is downgraded one
  forecast category and listed — "if there's no dated next step, we downgrade it" [S20] (P2).
- **Staleness**: no touch for 14–21 days ⇒ flag [S20]; the gate warns at **21 days** and at
  **45 days** demands the deal move to nurture/lost with `loss_reason=no_decision`.
- **Slips**: `close_date_slips ≥ 2` while in commit ⇒ out of commit — deals that slip repeatedly
  cut win rate −113 % (Ebsta × Pavilion, 655,000 opps [S13][S14] P2/P1).
- **Coverage**: required pipeline coverage = **1 ÷ trailing win rate**, with a 1.2× planning
  buffer — 33 % → 3×, 25 % → 4×, 20 % → 5×; the blanket 3× rule is wrong unless win rate ≈ 33 %
  (Clari [S17] P2). Until ≥ 20 decided outcomes exist the harness uses **5×** (the 19–21 % B2B
  baseline win rate [S13]) — policy. Open *qualified* pipeline over the quarter target is what
  counts; unqualified top-of-funnel is not coverage.
- **Win rate**: trailing win rate on ≥ 20 decided deals below **10 %** triggers a qualification
  review, not more outbound [S13]. Context: B2B win rates fell to 19–21 % in 2025 from 29 % in
  2024; 76 % of sellers missed H1-2025 quota [S13][S14].
- **Cycle-time budget**: average B2B cycle 6.5 months; < $25k ACV closes in ~90 days; > $100k
  runs 6–9+ months [S13]. Deals over 2× their band are flagged for disqualification review.
- **Loss reasons**: every lost deal carries `loss_reason ∈ timing | need | budget | authority |
  feature | price | competition | no_decision | other` (InsightSquared categories [S5] P2) —
  `no_decision` is a real and common outcome, and the tally drives the next iteration.
- **Cash-in**: `paid_date − invoice_date` tracked against `payment_terms_days` + 15 days slack;
  beyond that the dunning step fires (finance protocol owns collection).

Sales velocity check (YC): a working founder-led motion closes "new ARR every week", maturing to
a recurring contract "every week or two" [S8].

## §8 References, case studies, channels, and the scale gate

- **Reference/case-study gate**: before any *sequenced* outbound is enabled, ≥ 1 written case
  study (with customer consent) per target segment is on file — automation becomes viable "once
  you've refined messaging and have case studies" [S7]. The case study itself is linted by the
  assets gate (marketing protocol §6).
- **Channels and partners come later.** Prerequisites are product-market fit, a proven ICP and a
  proven direct sales strategy; programs "should be driven by a genuine and organic need", not a
  revenue target (BVP [S27] P2). Margin structure is structural: **VAR 20–30 %**, **reseller
  5–10 %** [S27]; **PH agent commissions 5–10 %** and distributors/indenters are the standard
  import channel (trade.gov [S38] P1). Exclusivity in a channel agreement is a §6 tripwire.
- **Scale gate — no sales headcount before repeatability** [S4][S2][S10]: hire the first
  non-founder seller only when **≥ 10 paid customers** exist, trailing win rate and cycle time
  sit within band for **two consecutive quarters**, and a written playbook (`gtm/playbook.md`)
  exists. Reversal cost of an early hire: severance, ~3.0-month ramp, lost quarters (Bridge
  Group [S11] P1).

## §9 Philippine field rules

**Buying norms** (US Commercial Service, P1): "Strong relationships of mutual trust with
Philippine clients are the key to clinching a sale"; an aggressive, transactional approach is
discouraged; visit regularly and make in-person sales calls [S40]. "Philippine partners expect
strong after-sales service and support… during and after the warranty period" in a
brand-conscious market [S37]. English is the language of trade correspondence; quote in USD with
a peso equivalent noted where relevant [S40]. Metro Manila hosts most national
importers/distributors, with hubs in Pampanga, Baguio, Cebu, Iloilo, Davao and Batangas [S38].

**Payment terms** (verified for trade instruments, trade.gov [S39] P1): L/C typically 30 or 60
days; D/A 30–60 days; **open account 30–180 days**; collection agencies take 30–120 days at a
20–40 % fee of the amount recovered. Local net-30 / 2-10-net-30 / COD vocabulary is P3-grade
[S45]. Because domestic creditable-withholding rates were not verifiable in this pass, the
ledger carries the facts from the signed contract, not a benchmark: **every deal row records
`payment_terms_days` and `withholding_pct`**, and paid rows reconcile against the **BIR Form
2307** certificate in the AR ledger (finance protocol). Terms once granted lengthen and never
shorten — a §10 irreversible.

**Government selling under RA 12009** (New Government Procurement Act, signed 2024-07-20,
effective 2024-08-13; IRR published 2025-02-10; all P1 [S29]–[S36]):

- Eligibility needs a valid **PhilGEPS Certificate of Registration (Platinum)** — six documents
  (DTI/SEC/CDA registration, mayor's permit, BIR-stamped AFS, sworn statement, tax clearance,
  PCAB where applicable), valid one year, downgrading to Red if unrenewed [S42]; corporations
  add a SEC-received GIS with beneficial ownership from 2025-07-15 [S43]. The bid-pack lint
  checks `expires_at > bid_date`.
- Award: **LCRB** (lowest calculated responsive bid) or **MEARB** (most economically advantageous
  responsive bid) where **price is weighted 15–40 %** alongside quality, after-sales service and
  sustainability (§49, §61 [S31]); bid opening to award "shall not exceed sixty (60) calendar
  days" (§67 [S31][S32]).
- Modality by ABC: **Direct Acquisition ≤ ₱200,000**; **Small Value Procurement ≤ ₱2,000,000**
  (≥ 3 quotations requested, 1 sufficient); competitive bidding above; plus Direct Sales (§36 —
  a satisfactorily completed government contract becomes a reusable channel) and **§37 STI
  direct procurement** from qualified startups — where **IP defaults to the Procuring Entity**
  unless otherwise agreed [S32].
- Securities and penalties: **bid security** 2 % (cash) / 5 % (surety) of the ABC or a Bid
  Securing Declaration; **performance security** 5 % (goods/consulting) / 10 % (infrastructure)
  in cash, 30 % via bank instruments; liquidated damages **0.1 %/day** of the undelivered
  portion with rescission possible at 10 %; warranty 3 months (expendable) / 1 year
  (non-expendable) with 1–5 % warranty security [S32]. Startups and other inclusive-procurement
  registry sectors may post a **Performance Securing Declaration** instead — breach means
  blacklisting 1 year (first offense) / 2 years [S32]: one failed government delivery locks out
  every procuring entity.
- Cash timing: the only statutory anchors are advance payment ≤ 15 % against a bank guarantee
  paid within 60 days of signing, and a consultant's right to terminate when payment lags 60
  days past a certified claim [S32]; actual payment lag is UNVERIFIED — plan cash for 60–90+
  days after acceptance and let the funnel's cash-in warn carry it.

## §10 Human sign-off rows and early irreversibles

**Never mechanized — logged with `human_approved_by`, never loop-passed:** sending any
email/message/DM; placing calls; quoting a price or discount; committing to a pilot; submitting
a proposal or bid; signing NDAs/contracts/POs; posting bid or performance securities;
registering/renewing PhilGEPS; issuing invoices; agreeing payment terms; appointing
agents/distributors; any ad or event spend. The loop drafts, lints and gates; a human sends,
spends, signs, files.

Early irreversibles (charter rows with decide-by dates; brief 06 §6):

1. **Segment/ICP choice** — switching resets the sales learning curve [S4]; buyer channel
   habits differ by persona [S7].
2. **Sales motion and the first sales hire** — early reps burn cash [S4]; early top-down kills
   the organic motion [S2].
3. **Price anchor and discount precedent** — the first quote is the reference forever [S9];
   opt-out recurring vs one-off pilots decides whether revenue recurs [S8].
4. **Pilot scope** — the metric agreed up front is what the customer judges [S8].
5. **Contract clauses** — unlimited liability, IP transfer, exclusivity are company-ending
   [S8]; §37 STI IP default [S32].
6. **Government track** — securities, LD exposure and blacklisting are one-way [S32].
7. **Channel/agent appointments** — margins are structural and exclusivity is hard to unwind
   [S27][S38][S41].
8. **Reference customers** — the first references define the segment story; a completed
   government contract is a Direct Sales channel [S32].
9. **Payment-terms precedent** — open-account terms lengthen, never shorten [S39].

## §11 Failure modes the gate exists to catch

| Anti-pattern | Mechanical guard |
|---|---|
| Scaling sellers before the process is learned | scale gate (§8) |
| Unpaid, ill-scoped 3–6-month design partnerships | pilot lint: price > 0, ≤ 8 weeks, unpaid > 60 d red |
| Deals with no dated next step inflating the forecast | next-step downgrade |
| Stale deals held open for hope | 21 d warn / 45 d ⇒ no_decision |
| Serial slippers still in commit | slip counter ≥ 2 |
| Blanket 3× coverage at a 20 % win rate | coverage = 1/win-rate × 1.2 |
| More outbound instead of better qualification at < 10 % win rate | win-rate floor review |
| Pitching essays in cold email (−57 % replies) | word-count lint ≤ 100 / ≤ 75 founder |
| Courting Talkers instead of Mobilizers | champion validated by an action [S24] |
| Responding to RFPs never shaped ("If I'm getting an RFP and I haven't influenced it, I've probably wasted my time" [S3]) | bid/no-bid requires prior logged contact |
| Signing unlimited liability / IP transfer / exclusivity / auto-renew unread | tripwire block |
| Bidding without Platinum, wrong modality for the ABC, unbudgeted securities | government bid-pack lint (§9) |
| Treating implementation as the customer's job | onboarding plan before closed-won [S9][S8] |
| Aggressive automation in a relationship-first market | no sequences before 10 customers + case studies [S40][S7] |

## §12 What the funnel gate blocks (contract summary)

`score-guild.sh funnel <deals.csv> [targets.tsv]` → `FUNNEL_VIOLATIONS: N`, detail to stderr,
exit 0 even when N > 0 (a red ledger is valid data), exit 2 only on hard error. Violations:
unknown stage; open deal without segment / dated next step / activity within 45 d; proposal+
without economic buyer, metrics, decision-process doc; commit without paper process started or
with ≥ 2 slips; pilot without end date, over 8 weeks, priced at zero, or unpaid over 60 d;
unreviewed contract tripwires; lost without a loss reason; and — when targets are given — deals
outside the segment hypothesis or ACV band, < 80 % of open value in the primary segment,
coverage below required, win rate < 10 % on ≥ 20 decided. Warns (stderr): 21-day staleness,
cash-in beyond terms + 15 d, cycle > 2× band. Policy env: `GUILD_STALE_WARN_DAYS`,
`GUILD_STALE_FAIL_DAYS`, `GUILD_SLIP_MAX`, `GUILD_PRIMARY_SHARE_PCT`, `GUILD_COVERAGE_MULT`,
`GUILD_COVERAGE_DEFAULT`, `GUILD_MIN_DECIDED`, `GUILD_WINRATE_FLOOR_PCT`, `GUILD_PILOT_MAX_DAYS`,
`GUILD_PILOT_UNPAID_DAYS`, `GUILD_CASH_SLACK_DAYS`, `GUILD_FX_USD_PHP`.

## §13 Sources (brief 06 numbering; retrieved 2026-09-02)

[S1] Skok, forentrepreneurs "Startup Killer" (P1) · [S2] Lauten & Casado, a16z Growth+Sales (P1)
· [S3] Cranney, a16z field-sales bootcamp (P1) · [S4] Leslie & Holloway, HBR Sales Learning
Curve (P1, abstract) · [S5] InsightSquared loss-reason whitepaper (P2) · [S6] Graham, "Do Things
That Don't Scale" (P1) · [S7] Kolysh, YC first-10-customers (P1) · [S8] Blomfield, YC founder
sales playbook (P1) · [S9] Koomen, YC enterprise sales (P1) · [S10] Kazanjy, Founding Sales
(P1) · [S11] Bridge Group 2025 SDR report (P1) · [S12][S13] Gradient Works compilations (P2) ·
[S14] Ebsta × Pavilion 2025 GTM benchmarks (P1, sample only) · [S15] Gong cold-email data (P2)
· [S16] Gong discovery-call data (P2) · [S17] Clari pipeline coverage (P2) · [S18] MEDDICC
origin (P2) · [S19] HubSpot qualification guide (P2) · [S20] HubSpot pipeline guide (P2) ·
[S21] Sandler (P1) · [S22][S23] SPIN/Huthwaite (P3/P1) · [S24] Adamson, Dixon & Toman, HBR "The
End of Solution Sales" (P1) · [S25] Salesforce Ben forecast categories (P2) · [S26] Janz, five
ways to $100M (P2) · [S27] BVP channel partnerships (P2) · [S29]–[S36] RA 12009 / GPPB / IRR /
DBM / trade.gov NGPA texts (P1) · [S37]–[S41] trade.gov & export.gov CCGs (P1) · [S42] PhilGEPS
help (P1) · [S43] PS-PhilGEPS ADV 2025-007 (P1) · [S44] First Circle PhilGEPS fee (P3) · [S45]
Shoppable payment-terms guide (P3) · [S46] RA 11032 (P1).
