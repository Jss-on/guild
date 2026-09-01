# Offer Protocol — positioning, value proposition, offer ladder, narrative, pitch tests

Companion to `/guild:build` phase P5 (positioning + offer). Research basis: brief 03
(`research/raw/03-positioning-offer.md`, retrieved 2026-09-02; sources [S#] listed there §8 with
provenance P1 author/primary/government · P2 reputable secondary · P3 weak). Numbers below carry
their grade; thresholds we chose because no published rule exists are tagged **policy**. The gates
`positioning` and `offers` (scripts/gates/) enforce the mechanical part; everything judgement-shaped
stays a human sign-off row. This protocol is method, not legal or tax advice.

## §0 The rules of this domain

1. **Positioning is downstream of evidence, never upstream.** It starts from the interview ledger
   and the alternatives ledger, not from a whiteboard. Dunford: let the market and customers "pull
   you" before locking positioning [S20, P2]; with zero customers, substitute interviewees who
   showed buying intent — Do > Tell [S18, P2].
2. **Every artifact resolves to a ledger.** Statement slots resolve to ICP / alternative /
   attribute / theme ids; themes resolve to ranked pains/gains and proof; pillars resolve to
   themes. Prose that resolves to nothing is a slogan and the gate counts it.
3. **The first offer is paid.** Free proposals are worthless unpaid selling (Dunn [S14, P2]);
   paid discovery is the entry rung and its price, credit and prepay terms are linted.
4. **Sends are human.** Pitching, publishing the one-pager, quoting, granting a guarantee —
   every outbound act is a human-gated sign-off row. The loop drafts and lints.

## §1 Dunford's ordered method (the P5 pipeline)

Synthesised from Dunford's 10-step method [S1][S21][S22], Osterwalder's VPC [S2][S3][S4],
Moore [S11][S13], Raskin [S9], Dunford's *Sales Pitch* [S23] and paid-discovery practice
[S14][S15][S16]. Each step names its artifact; the loop may not skip forward.

| # | Step | Artifact |
|---|---|---|
| 0 | Evidence intake — import the interview ledger (ids, quotes, jobs/pains/gains, alternatives named, triggers) | `discovery/interviews.tsv` (read-only) |
| 1 | Best-fit signals — interviewees who showed buying intent, shared firmographics | `offer/bestfit_signals.csv` |
| 2 | Positioning team + drop legacy baggage | `offer/positioning_team.md` |
| 3 | True competitive alternatives, status quo included | `market/alternatives.csv` |
| 4 | Unique attributes — what the alternatives lack | `attributes:` in `offer/positioning.yaml` |
| 5 | Attributes → value themes with proof (VPC cross-check) | `value_themes:` in `offer/positioning.yaml` |
| 6 | Customer profile — jobs, pains, gains, ranked | `offer/customer_profile.csv` |
| 7 | ICP + anti-ICP with the four forces and beachhead criteria | `offer/icp.yaml`, `anti_icp:` block |
| 8 | Market category / frame of reference | `category_decision:` block |
| 9 | Relevant trend (supports value, never replaces it) | `trend:` field |
| 10 | Positioning canvas + Moore statement (linted) | `offer/positioning.yaml` |
| 11 | Messaging hierarchy — value statement, pillars, proof | `messaging:` block |
| 12 | Whole product + offer ladder | `offer/offers.yaml` |
| 13 | Sales narrative + one-pager | `offer/narrative.md`, `offer/one-pager.md` |
| 14 | Pitch tests in live conversations (human-entered) | `offer/pitch_tests.csv` |

## §2 Competitive alternatives — no phantom competitors

`market/alternatives.csv` (owned by the market domain; read here):
`alt_id, name, type (direct|indirect|status_quo|diy|do_nothing|in_house), url,
why_customer_uses_it, evidence_interview_ids, lost_deal_ids`.

- The question is Dunford's: "what would a customer do if your offering didn't exist?" [S1, P1].
  The status quo — manual spreadsheets, an in-house macro, do nothing until the audit — is an
  alternative and usually the primary one; 40–60 % of B2B deals are lost to **no decision**
  [S20][S23, P2, Dunford citing external research, unverified at origin].
- **Phantom competitors** — rivals never met in a deal or an interview — are banned [S1, P1].
  Every alternative row carries ≥ 2 distinct interview ids; the `competitors` gate fails rows
  with zero evidence, and the `positioning` gate fails a `primary_alternative` that is not in the
  ledger at all.
- ≥ 3 alternatives total, ≥ 1 of type status_quo / diy / do_nothing (G3.1).

## §3 Unique attributes → value themes → proof (the VPC chain)

- **Unique attributes** answer "what do we have that the alternatives do not?" [S1, P1] —
  feature-function first, translated later. Each attribute lists the `lacking_alt_ids` that
  actually lack it; an attribute every alternative also has is not unique and fails the gate.
- Non-defensible adjectives — `simple | affordable | cheap | quality | innovative | best` — are
  **banned** as attribute or slot text; reframe them as the feature that makes them true
  (the Userlist reframe [S21, P2]). The gate lints the product / benefit / differentiator slots.
- **Value themes** (2–4; Userlist landed on 3 [S21, P2]) cluster attributes and answer "so what
  for customers?" [S1]. Each theme carries `attr_ids`, `pain_gain_ids` and `proof_ids` — the
  value-proposition cross-check: every theme must relieve a ranked pain or create a ranked gain
  [S3][S4, P1]. Rank pains by intensity and frequency, gains by relevance [S4, P1]; the top-5
  ranked pains/gains each trace to **≥ 3 interview ids** (evidence-weighted ranking, G3.2c;
  the ≥ 3 floor is **policy**). Strategyzer's "fit addresses 50–70 % of the most significant
  pains and gains" is editorial, not empirical [S3] — use it as a smell, not a threshold.
- A theme without proof (quote, case, metric file) is a slogan; the gate counts it.

## §4 ICP + anti-ICP — who it is for, and who it is not for

`offer/icp.yaml` (validated by the `icp` gate; read by `positioning` for the target slot):
top-level `segment_id`, then `firmographics`, `roles` (economic_buyer, champion,
`decision_maker_role`, relationship_owner), `technographics`, `pains`, `triggers`
(`push / pull / anxiety / habit`), `buying_process` (`procurement_mode`, payment terms expected,
withholding class), `beachhead_criteria`, `anti_icp` — every leaf traced to ≥ 3 interview ids.

- **Four forces** (Moesta/Spiek [S25, P1]): switching happens when Push + Pull > Anxiety + Habit.
  The forces are quoted from interviews, never inferred; all four buckets must be non-empty.
- **Five beachhead criteria** [S18, P2]: burning pain · high willingness to pay · growth ·
  proximity/access · a sub-segment of an expandable market — each with a value and a source id.
- **Anti-ICP** [S17, P2]: ≥ 3 disqualifiers derived from worst-fit patterns, at least one
  PH-specific. The standing PH rule: inbound "government" leads without a PhilGEPS-published
  notice are disqualified — the ITA warns of "many reported scams from entities impersonating the
  Philippine Government" [S31, P1].
- PH buying is relationship-first and hierarchy-heavy (Commisceo [S36, P3]; corroborated
  indirectly by ITA [S29][S30, P1]): `decision_maker_role` and `relationship_owner` may not be
  null, and `procurement_mode ∈ private | philgeps_lcrb | philgeps_mearb | philgeps_consulting`
  (with certificate status when PhilGEPS).
- The ICP is a hypothesis until ~5–10 paying customers exist; version it and re-derive.

## §5 Market category — head-to-head, big fish, or a new game

`category_decision:` records `style ∈ head_to_head | big_fish_small_pond | create_new_game`,
the category noun phrase, the rationale and the rejected options [S22][S21].

- Default to an **existing market frame**: Dunford — "90 % of tech companies that have gone
  public over the past five years have been positioned in existing markets" [S1, P1 author claim,
  underlying study not cited on page]. Category creation is the exception: it "involves not just
  a breakthrough product, but also a business model innovation" (HBR 2019 [S8, P1 partial]) —
  Play Bigger's 76 % market-cap claim [S8] is the other side of a contested trade-off.
- **The education-budget rule:** `create_new_game` is opt-in and requires a written
  `education_budget_php > 0` — if nobody budgets for educating the market, the new game is a
  default, not a decision. The gate enforces it.
- The category is a noun phrase buyers already use (unless creating a new game); the statement's
  category slot must equal the decision's category — the gate cross-checks.
- The trend (canvas field 6) supports the value story but is never the benefit [S21][S22];
  the gate fails a trend pasted into the benefit slot.

## §6 The Moore statement and its lint

Template (Moore, *Crossing the Chasm*, via [S13, P2]):

> **For** (target customer) **who** (need), **the** (product) **is a** (category) **that**
> (key benefit). **Unlike** (primary alternative), **our product** (primary differentiation).

Lint rules (gate `positioning`, brief 03 G3.4):

- Six slots + the product name present and non-empty; slots may hold an id (`T-n`, `A-n`,
  `ALT-n`) or the verbatim text — the gate renders the statement from resolved texts.
- **Referential integrity:** `target` resolves to the elected ICP id; `primary_alternative`
  resolves to an `alt_id` or name in the alternatives ledger; `differentiator` names an attribute
  id or its text; `benefit` names a value-theme id or its statement; `category` equals the
  category decision.
- **Form:** rendered statement ≤ **75 words** (the 9 template words count), each slot ≤ 25 words;
  no banned adjectives (`simple|affordable|cheap|quality|innovative|best`) in the product,
  benefit or differentiator slots. The 75/25 limits are **policy** (a statement nobody can say
  aloud is not a statement).
- A statement is not the positioning — it is the lintable residue of the canvas [S1][S39];
  keep the canvas fields (alternatives, attributes, value + proof, segments, category, trend)
  in the same file.

## §7 Messaging hierarchy — positioning is not a tagline

`messaging:` holds exactly **one** value statement and **3–5 pillars**, each pillar
`{name, capability, benefit, theme_id, proof_ids}` [S19, P2]. Positioning (internal) informs
messaging (external); "positioning is not a tagline" [S1, P1]. A pillar without a proof id is a
slogan; a pillar whose `theme_id` resolves to nothing is fiction — the gate counts both.

## §8 Whole product — what the pragmatist buyer actually needs

Whole product = "a generic or core product, augmented by everything that is needed for the
customer to have a compelling reason to buy" (Levitt → McKenna → Moore [S12, P2]); Moore's chasm
dependencies: a compelling use case, a whole product that nails it, word-of-mouth [S11, P2].
For a PH engineering studio the inventory is explicit per offer:
`whole_product: {install, training, support_months, warranty_months, docs}`.

- **PH after-sales is a verified whole-product component:** "Philippine partners expect strong
  after-sales service and support … during and after the warranty period" (ITA [S29, P1]).
  Hardware offers must carry `support_months ≥ warranty_months`; the `offers` gate fails the
  orphaned-hardware pattern.
- Decide which whole-product parts the studio delivers vs partners for; "there is no such thing
  as a commodity. All goods and services are differentiable" (Levitt [S26, P1 partial]).

## §9 `offer/positioning.yaml` — the layout the gate parses

```yaml
# as_of: 2026-09-02
version: 3
date: 2026-08-28
statement:
  target: smb-mfg                  # elected ICP id (segment_id in offer/icp.yaml)
  target_text: "Luzon manufacturers with 20–200 staff …"   # optional rendered phrase
  need: "need a daily stock count that matches the ERP …"
  product: Countline
  category: inventory automation for mid-size manufacturers
  benefit: T-1                     # theme id or its verbatim statement
  primary_alternative: ALT-1       # alt_id or its verbatim name
  differentiator: A-1              # attribute id or its verbatim text
attributes:
  - id: A-1
    text: "counts pallets nightly with a fixed camera rig …"
    lacking_alt_ids: [ALT-1, ALT-2]
value_themes:
  - id: T-1
    statement: "month-end variance under 1 % without a second counting shift"
    attr_ids: [A-1]
    pain_gain_ids: [PG-1]
    proof_ids: [PR-1]
category_decision:
  style: big_fish_small_pond       # head_to_head | big_fish_small_pond | create_new_game
  category: inventory automation for mid-size manufacturers
  education_budget_php: 0          # must be > 0 when style is create_new_game
trend: "EOPT invoicing pushes SMB finance teams to keep live stock ledgers"
messaging:
  value_statement: "Stock counts that match the books, every night."
  pillars:
    - {name: Nightly reconciliation, capability: …, benefit: …, theme_id: T-1, proof_ids: [PR-1]}
```

Gate: `score-guild.sh positioning offer/positioning.yaml market/alternatives.csv offer/icp.yaml`
→ `POSITIONING_VIOLATIONS: N` (0 required).

## §10 The offer ladder — paid discovery, G-B-B, bundles, guarantees, pilots

**Paid discovery is mandatory and exactly one exists.** Free proposals are "worthless" — unpaid
selling averaged 3–4 hours per lead at a 25 % proposal close, ≈ 14 h of free work per landed
client (Dunn [S14, P2]). Paid discovery converts that into revenue and proof: a fixed-price,
fixed-scope diagnostic (audit 4–20 pages, workshop, spec) that outputs 2–3 scoped next projects
[S15, P2]. Sakas: **$500–2,500 typical** (up to $10k on-site; enterprise $25k–125k), priced at
**5–10 %** of the expected project or retainer value, with any credit toward the next engagement
expiring in **2–6 weeks** (gate: credit deadline 14–42 days) [S15, P2]. The first negotiation is
a "polite battle for control" that sets the relationship precedent [S15]. For this studio:
₱25,000 against a ₱350k median build ≈ 7 % — inside the band.

**Good-Better-Best** (Mohammed, HBR 2018 [S5, P1 partial; S6, P2]):
- Good attracts the price-sensitive, Better is the Goldilocks default, Best expands and anchors.
- Prices strictly increasing; spacing rule of thumb Good ≈ −25 %, Better ≈ +10 % over the average
  sale, Best ≤ +50 % [S6, P2 trade-press] — the gate warns outside `good ≥ 0.6 × better` and
  `best ≤ 1.5 × better`.
- Every tier carries ≥ 1 **fence attribute** absent from the tier below — the thing a buyer will
  not give up — and **`good.scope_out` is non-empty**: a feature-rich Good cannibalises Better,
  and a fee-riddled Good breeds resentment [S6, P2]. Anchoring runs both ways: Williams-Sonoma's
  $279 bread machine "sales almost doubled" next to a $429 model; airlines see > 50 % of
  low-price starters upgrade; Peloton re-tiered $2,245 → $1,895 with a $2,495 premium [S6, P2].
  The compromise effect is a lab finding (Simonson 1989 [S39, P1 metadata]) — magnitudes vary.
- Productize only what has been delivered **≥ 6 times** at ~80 % repeatable (Haus [S16, P3]);
  until then the ladder is discovery + custom builds.

**Bundling is mixed, never pure.** "Mixed bundling dominates pure bundling and pure components"
in revenues (Derdenger & Kumar, *Marketing Science* 2013 [S38, P1 abstract]; evidence from game
consoles, directional for services). Any `bundle: true` offer carries
`a_la_carte_available: true` — the gate fails pure bundles.

**Guarantees have trigger, remedy and cap.** A B2B services guarantee without all three is an
unpriced liability (practitioner consensus; the underlying money-back-guarantee study [S37] has
verified metadata but unverified effect sizes). Gate: `guarantee: {trigger, remedy, cap_pct}` with
`cap_pct ∈ (0, 100]` of the offer price. Once given to customer 1 it is expected by customer 2 —
guarantee terms are an early irreversible.

**Pilots are paid, short and metric-fixed:** price > 0, a fixed pilot metric, `duration_days ≤ 56`
(≤ 8 weeks, **policy**, aligned with the GTM brief); the funnel gate reds an unpaid pilot at 60 d.

**PH first-engagement terms (the trust ladder).** First-time counterparties trade on L/C; open
account 30–180 days only after trust (ITA [S28, P1]); domestic B2B settles Net 15–90 by check or
bank deposit [S27, P2]. Therefore: `first_engagement: true` offers require **`prepay_pct ≥ 50`**
and **`payment_terms_days ≤ 30`** — never extend Net-60 on a first deal. Open-account terms
lengthen with trust; they never shorten [S28].

**The tax note.** Every price carries `tax_note: "ex-VAT; subject to EWT"` — corporate clients
withhold 2–15 % (professional fees: 10/15 % for juridical payees) and issue **BIR 2307**
[S33, P2]; a quote without the note either eats 12/112 as VAT or books withheld tax as a
shortfall. The pricing protocol (§10 there) carries the full mechanics.

## §11 `offer/offers.yaml` — the layout the gate parses

```yaml
# as_of: 2026-09-02
version: 2
date: 2026-09-01
offers:
  - id: O-DISC
    name: Stock-count diagnostic (paid discovery)
    tier: discovery            # discovery|good|better|best|pilot|retainer
    ladder: countline          # optional grouping; G-B-B checks run per ladder
    price_php: 25000
    price_basis: fixed         # fixed|range|per_sprint
    discovery_pct_basis: 350000  # optional; default = median good/better price
    scope_in: [ … ]            # non-empty
    scope_out: [ … ]           # non-empty on the good tier
    fence_attributes: [ … ]    # ≥ 1 per G-B-B tier, ≥ 1 beyond the tier below
    deliverables: [ … ]
    duration_days: 10
    prepay_pct: 100
    payment_terms_days: 0
    guarantee: {trigger: …, remedy: …, cap_pct: 100}
    credit_to_next: {amount_php: 25000, deadline_days: 30}   # 14–42 d when present
    whole_product: {install: …, training: …, support_months: 0, warranty_months: 0, docs: …}
    hardware: false            # true ⇒ support_months ≥ warranty_months
    first_engagement: true     # true ⇒ prepay ≥ 50 %, terms ≤ 30 d
    bundle: false              # true ⇒ a_la_carte_available: true
    tax_note: "ex-VAT; subject to EWT"
```

Gate: `score-guild.sh offers offer/offers.yaml` → `OFFER_VIOLATIONS: N` (0 required).
Checks: exactly one discovery offer priced 5–10 % of the expected build value with a 14–42 d
credit deadline; per ladder good < better < best with fences and a good scope_out; mixed bundling;
capped guarantees; hardware after-sales; first-engagement prepay/terms; the tax note everywhere.

## §12 Narrative and pitch — lead with the change, not the product

**Raskin's strategic narrative**, in order [S9, P1]: 1 name the **big change** in the world,
2 show winners and losers, 3 tease the **promised land**, 4 introduce features as **magic
gifts**, 5 present evidence. The product must be absent from the change section — start with the
change, never the product [S9][S10, P1]; the narrative is CEO-owned. An over-dramatised change
without evidence reads as hype — the evidence section cites ≥ 2 proof ids.

**Dunford's pitch** [S23, P2]: setup (insight → alternatives → perfect world) then follow-through
(introduction → differentiated value → proof → objections → ask). For services, "perfect world"
reframes as "what a good engagement looks like". 40–60 % of deals go to no decision [S23] — the
pitch must make the status quo's cost explicit.

**Never ship the investor deck to customers** (Kramer via First Round [S24, P2]) — the one-pager
derives from ledgers, not from the fundraising story.

## §13 The one-pager — every section resolves to a ledger id

`offer/one-pager.md`, ≤ 450 words (**policy**; it must stay one page), linted by the `assets`
gate. Sections, each resolving to a ledger:

| Section | Resolves to |
|---|---|
| who_for | ICP id (`offer/icp.yaml`) |
| problem | top-ranked pain ids |
| what_we_do | positioning statement, verbatim |
| offer | offer ids + price/range + the tax note |
| proof | proof ids |
| why_us | differentiator attribute ids |
| next_step | the paid-discovery offer id |
| contact, version/date | — |

## §14 Pitch tests — the only outcome gate in this domain

`offer/pitch_tests.csv` is **human-entered** (the loop never writes it):
`conversation_id, date, icp_match, positioning_version, confusion_flag,
alternative_named_by_buyer, next_step_agreed, next_step_type`.

Thresholds (**harness policy**, motivated by Dunford's "back up and pitch it to me again" signal
[S20, P2] and Cacioppo's "predict 75 % of what a customer tells you" test [S24, P2]): over the
last **≥ 8 ICP-matched conversations**, `confusion_flag = n` in ≥ 75 % (confusion ≤ 25 %) and
`next_step_agreed = y` in ≥ 50 %; otherwise positioning re-opens at §2. A positioning version
older than 90 days with no pitch tests against it is stale — the gate warns.

## §15 Philippine specifics (verified rows only)

- **EWT on the studio's invoices:** professional fees — individuals 5 % (≤ ₱3M, non-VAT COR) /
  10 %; juridical entities 10 % (≤ ₱720k) / 15 %; contractors 2 %; Top Withholding Agents 1 %
  goods / 2 % services; payor issues **BIR 2307** within 20 days after quarter end; sworn
  declaration by Jan 15 [S33, P2]. Hence the mandatory tax note and the 2307 ledger in finance.
- **PhilGEPS:** Platinum membership **₱5,000**, certificate required for public bidding; the
  official receipt is not the certificate [S35, P1]. Awards go to the **LCRB** (lowest calculated
  responsive bid) or, under RA 12009, **MEARB** with weighted technical/financial scoring;
  consulting uses Highest Rated Responsive Bid [S34, P1]. Specs "do not often take life cycle
  cost into account" [S31, P1] — TCO/value positioning does not win LCRB tenders; if government
  is in the ICP, position on spec-compliance + price or target MEARB/consulting modes.
- **Trust ladder:** L/C for first-time relationships; D/A 30–60 d; O/A 30–180 d only after trust
  [S28, P1]; domestic Net 15–90 by check/bank deposit, e-wallet caps (GCash ₱100k) [S27, P2].
- **After-sales beyond warranty is expected** [S29, P1] — the hardware support tier is not
  optional garnish; it is the whole product.
- **Gov-impersonation scams** [S31, P1] — the standing anti-ICP disqualifier.
- Not verifiable this pass (marked UNVERIFIED in the brief): Hofstede PH scores, *pakikisama* /
  *utang na loob* in B2B procurement studies, typical PH SME DSO.

## §16 Human sign-off rows (the loop never marks these pass)

| Row | Why human |
|---|---|
| Category style election (incl. any create_new_game budget) | early irreversible |
| "Compelling reason to buy" judgement on the whole product | taste, not lint |
| Publishing the one-pager / homepage copy | outbound send |
| Every pitch, and every `pitch_tests.csv` row | human conversation, human entry |
| Guarantee terms offered to a real customer | contractual precedent |
| Paid-vs-free discovery precedent; first-deal payment terms | relationship precedent [S15][S28] |
| Naming the company/offer inside a category | brand irreversible [S21] |

## §17 Early irreversibles (charter rows with decide-by dates)

Beachhead segment / ICP v1 (references and content accrete to it [S11][S18]) · market category
[S1][S21] · category-creation attempt [S1][S8] · paid-discovery precedent [S14][S15] · published
price anchors and tier names [S6] · guarantee terms · first-invoice payment terms and EWT class
[S28][S33] · government route (PhilGEPS registration, ownership structure) [S31][S35] · the
narrative's "big change" thesis [S9] · naming that encodes a category [S21].

## §18 Failure modes this protocol exists to prevent

Phantom competitors [S1] · ignoring the status quo (40–60 % no-decision [S20][S23]) · locking
positioning before any customer pull [S20] · defaulting to a new category [S1][S8] · writing a
tagline instead of a canvas [S1] · non-defensible adjectives [S21] · value claims untethered from
ranked pains/gains [S4] · ICP without an anti-ICP [S17] · free discovery [S14][S15] ·
productizing before ≥ 6 repetitions [S16] · a rich Good cannibalising Better [S6] · pure bundles
[S38] · uncapped guarantees · leading the pitch with the product [S9][S10] · shipping the
investor deck [S24] · TCO positioning at LCRB tenders [S31] · invoices without the EWT/VAT note
[S33] · Net-60 on a first deal [S28] · hardware with no after-sales tier [S29] · unverified
"government" leads [S31] · a positioning doc nobody pitches from (stale version).

## §19 What the gates block (mechanical surface)

- `positioning` → `POSITIONING_VIOLATIONS: N`: empty Moore slots; a target outside the elected
  ICP; a phantom primary alternative; a differentiator/benefit resolving to no attribute/theme;
  attributes lacking nothing; themes ≠ 2–4 or missing proof/pain/attr links; a rendered statement
  > 75 words or a slot > 25; banned adjectives; create_new_game without an education budget;
  category mismatch; a trend pasted as the benefit; ≠ 1 value statement; pillars ≠ 3–5 or
  unproven.
- `offers` → `OFFER_VIOLATIONS: N`: zero or two discovery offers; discovery outside 5–10 % of the
  build value; credit deadlines outside 14–42 d; non-monotone tiers; missing fences; an empty
  good scope_out; pure bundles; guarantees without trigger/remedy/cap ≤ 100; hardware with
  support < warranty; first engagements below 50 % prepay or beyond 30-day terms; pilots > 56 d;
  a missing "ex-VAT; subject to EWT" note.
- Both exit 0 with N > 0 (violations are valid data for the loop to fix) and 2 only on a missing
  or unparsable file. Every threshold is env-overridable (`GUILD_POS_*`, `GUILD_OFFER_*`)
  with the research defaults above.

## §20 Sources

[S#] resolve in `research/raw/03-positioning-offer.md` §8 (all retrieved 2026-09-02): S1 Dunford
Quickstart (P1) · S2–S4 Strategyzer VPC (P1) · S5 Mohammed HBR 2018 (P1 partial) · S6 G-B-B
summary (P2) · S7–S8 category-creator HBRs (P1 partial) · S9–S10 Raskin (P1) · S11 Crossing the
Chasm (P2) · S12 whole product (P2) · S13 Moore statement template (P2) · S14 Dunn roadmapping
(P2) · S15 Sakas paid discovery (P2) · S16 Haus productized ladder (P3) · S17 anti-ICP (P2) ·
S18 GTM Strategist beachhead (P2) · S19 Aha! messaging (P2) · S20 Lenny/Dunford (P2) · S21
Userlist case (P2) · S22 Dunford canvas guide (P2) · S23 Sales Pitch summary (P2) · S24 First
Round positioning hub (P2) · S25 four forces (P1) · S26 Levitt (P1 partial) · S27 Shoppable PH
B2B terms (P2) · S28 ITA trade financing (P1) · S29–S32 ITA CCG (P1) · S33 EWT under TRAIN (P2) ·
S34 GPPB RA 12009 (P1) · S35 PhilGEPS advisory (P1) · S36 Commisceo culture guide (P3) · S37
money-back-guarantee study (P1 metadata, findings UNVERIFIED) · S38 Derdenger & Kumar bundling
(P1 abstract) · S39 Simonson compromise effect (P1 metadata).
