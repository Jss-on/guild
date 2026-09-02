# Marketing Protocol — STP to assets to experiments, consent-first, ASC/DPA/ITA-clean

Companion to `/guild_build` P8. Marketing here is B2B-first (software + hardware engineering
studio) with some B2C hardware retail, in the Philippines. The loop plans, drafts and lints;
**publishing, sending and spending are human sign-off rows the loop never passes.** Research
basis: `research/raw/07-marketing.md` (bracketed [n] sources below, retrieved 2026-09-02;
P1 = primary/regulator/originator, P2 = secondary benchmark or law-firm report, P3 = tertiary).
Mechanical teeth: `score-guild.sh experiments`, `assets`, `consent` — plus `citations` on every
marketing document.

## §0 The three rules

1. **No assets before positioning.** Marketing must not start until the validated ICP, problem,
   positioning inputs, offer and price exist upstream; the asset lint blocks drafts that name no
   ICP, no offer, no price reference.
2. **Every claim substantiated, every number cited.** Marketing copy carries `[ev:C-n]` tokens
   that resolve in the claims ledger; superlatives carry independent third-party substantiation
   ≤ 12 months old (ASC [16]); nothing publishes without a compliance check row.
3. **Consent before contact.** Marketing email/SMS/Viber requires a recorded opt-in per contact
   — an affirmative act, with evidence. "Continued use ≠ consent" (NPC AO 2017-42 [22]);
   pre-ticked boxes are void. Every send is human-approved.

## §1 STP — segment, target, position

Score candidate segments on the four criteria — **measurability, accessibility, sustainability
(the profit justifies the effort), actionability** [37] — pick **one primary segment**, and write
the positioning statement (`positioning.md`). Discovery-style segmentation (observation of the
actual customer base) suits a small base better than survey analytics [37]. The elected segment
(e.g. `smb-mfg`, Metro Manila SMB manufacturers with manual inventory) is the `icp_id` every
asset must carry.

## §2 The mix — 4Ps / 7Ps

One recorded decision per P (`mix.md`): the **4Ps** — product, price, place, promotion (McCarthy
1960; price is "the only revenue-generating variable" [36]) — extended to the **7Ps** marketing
mix for service-heavy offers with people, process, physical evidence (Booms & Bitner 1981 [36]).
"Place" names the actual channels (direct founder sales; Shopee/TikTok Shop for hardware).
Lauterborn's 4Cs restate the same from the customer side as a sanity check [36]. Critique on
record: Rafiq & Ahmed argue services need no more complex mix [36] — the point is the recorded
decision, not the taxonomy.

## §3 Messaging and the claims discipline

Messaging derives from positioning: value proposition, three pillars, proof points, objections
(`messaging.md`) — and **every claim lands in `claims.csv`** with `claim, type, evidence_ref,
evidence_date`. Claim types follow the ASC rules [16] (P1): superiority / "Most Preferred" /
"Most Recommended" claims need independent third-party quantitative research; **No. 1 /
leadership claims need "at least the immediately preceding 12-month cumulative data, both volume
and monetary value, from an independent source"**; exclusivity and comparative claims need
independent third-party data and must identify the comparison; **substantiation is valid one
year** — continue the claim past a year only with updated data. RA 7394 (Consumer Act) Art 110
outlaws misleading advertising "in a material respect" including omission of material facts;
Art 115 requires special claims to be substantiated and to "properly use research result,
scientific terms, statistics or quotations" [20] (P1).

## §4 Budget — brand vs activation, share of voice

Split the budget **brand vs activation roughly 50/50** and set share-of-voice intent: **SOV >
SOM correlates with growth** (Binet & Field, LinkedIn B2B Institute, IPA Databank 1998–2018 B2B
cases [27] P1). Caveats on record: the authors themselves — sample sizes are small, UK-skewed,
big-budget [29]; IPA notes most B2B marketers do the opposite [28]; the oft-quoted 46:54 split is
UNVERIFIED against the primary, which says 50/50 [27]. `budget.csv` rows carry `channel,
brand/activation flag, cap_php, period`; the metrics review warns when **activation exceeds 70 %
of a quarter's spend**.

## §5 Channel plan — at most three channels, each with a written hypothesis

Pick **≤ 3 channels** (three channels maximum), each with a written **channel hypothesis** in
`channel-plan.csv`, and check claimed reach against the PH platform data (DataReportal Digital
2025: Philippines, data Jan 2025 [1] P1 — ad-tool identities, not people):

| PH channel datum (Jan 2025) | Value |
|---|---|
| Internet users | 97.5M (83.8 % penetration) |
| **Facebook** ad reach | **90.8M** = 93.1 % of internet users |
| **Messenger** ad reach | **61.8M** |
| **TikTok** ad reach (18+) | **62.3M** adults (+27 % YoY) |
| YouTube ad reach | 57.7M (−0.7 %) |
| **LinkedIn** members | **19.0M** (+18.8 %) — the B2B surface |
| Instagram / X | 22.9M / 9.29M (−13.7 %) |

**Viber** is PH-mainstream but company-reported (P2): top-5 Viber country, MAU +21 %, business
messages +53 % [25]; DataReportal publishes no Viber reach [1]. Hardware retail marketplaces
(Cube.asia FY2025 [24] P2): **Shopee 55 % GMV** (+25 %, AOV ₱316), **TikTok Shop 29 %** (+53 %,
AOV ₱198), **Lazada 16 %** (−34 %, AOV ₱416) — marketplace choice is an irreversible (§12). US
CPL/CAC datasets ([6][7][9] P2) are **ceilings, not PH targets**: Google search B2B CPL $93.69;
Meta lead CPL $27.66; LinkedIn CPC $10–16; B2B CAC by channel from email $510 to ABM $4,664.
Channel CAC figures already include a 4–6-month learning period [9] — abandoning a channel early
forfeits the learning (§12).

## §6 Assets — checklist, registry, lint

Assets ship only through `assets.csv` (asset_id, type ∈ landing | one_pager | deck | case_study
| pricing | email_seq | listing, version, path, icp_id, offer_id, price_ref, claims_ref,
release_form_on_file, price_on_request, last_reviewed) and the file lint
(`score-guild.sh assets <dir> <claims.tsv> <icp.yaml>`; `icp_id` must resolve against the
`segment_id`/`id`/`icp_id` keys of the given `icp.yaml`).

**Marker conventions** (machine-lintable substantiation, defined here):

- `[CTA]` — the conversion-goal marker (HTML assets may use a `<cta>` element). A **landing
  page carries exactly one** — "one conversion goal—or else it ain't a landing page" (Unbounce
  [32]); the gate counts `cta_count` and fails on anything but 1. Navigation and unsubscribe
  lines never carry the marker.
- `[ev:C-n]` — sources a numeric claim against the claims ledger (same regexes as the citations
  gate: percentages, multipliers, currency amounts, thousands groups, 5+-digit runs; years
  ignored; headings and fenced code skipped).
- `[price:<ref>]` — sources a price line against the price book; own prices cite the price
  book, not the claims ledger.
- `[vs: <comparator>]` — names the comparator for comparative copy ("than", "vs", "faster",
  "cheaper" …).
- `[evidence: third-party, YYYY-MM-DD, <source>]` — the ASC substantiation marker for
  superlatives; must be independent and dated within 12 months.

**Lint rules** (each a violation): placeholder tokens `[TBD] | lorem | XX% | {{ | INSERT | TODO
| ???`; `icp_id` not in the ICP; missing offer_id; missing price_ref without an explicit
`price_on_request=Y` flag; a numeric claim without `[ev:C-n]`; a superlative (`best | #1 |
No. 1 | most preferred | most recommended | only | fastest | leading | guaranteed`) without
fresh third-party evidence [16]; a comparative without a named comparator [16]; a **landing
page** with `cta_count ≠ 1` [32]; a **case study** missing any of the 10 HubSpot components —
title, subtitle, executive summary, about the customer, challenges, solution, results (with
numbers), quotes/visuals, future plans, call to action; 500–1,500 words — or without
`release_form_on_file=Y` (**a signed release form is mandatory before publishing** [31]); a
**pricing page** without currency, unit, inclusions and a VAT note ("ex-VAT; subject to EWT" —
pricing protocol owns the numbers); an **email sequence** without an unsubscribe line, a
`List-Unsubscribe` header (RFC 8058 one-click [34]) and a `consent_source:` line; a
**marketplace listing** without merchant name/address/contact, return/refund and warranty
policy (ITA merchant disclosures [23]). Reading grade is a warn: grade 5–7 copy converts 11.1 %
vs 5.3 % for professional-grade copy (Unbounce [2]) — plain language sells.

## §7 Content — pillars and clusters

Start with **3–5 pillar candidates**, each backed by **20–30 cluster articles** linking to the
pillar (HubSpot topic clusters; the three linking rules and the 2015 "Topics Over Keywords"
study [30] P2 — internal replication only). Year 1 realistically builds 1–2 pillars fully. The
pillar set hangs off the category frame — changing category re-does 20–30 articles per pillar
(§12). Disconnected one-off posts are the anti-pattern [30].

## §8 Tracking — UTM, CRM stages, attribution

`tracking.md` fixes, before the first campaign: the **UTM taxonomy** (a regex the calendar gate
enforces; changing taxonomy breaks historical comparability — §12), conversion events, CRM
stage definitions (lead / MQL / SQL / opportunity), and the **attribution** model — Google now
supports only **data-driven and last-click**; first-click, linear, time-decay and position-based
are "no longer supported" [33] (P1). Model choice is judgment, not mechanizable; what is
mechanical is that every published URL carries a taxonomy-conformant `utm_campaign`.

## §9 Growth experiments — pre-registered, powered, honest

Every experiment is a row in `experiments.csv` (id, opened, owner, funnel_stage, channel,
hypothesis, primary_metric, baseline, target_threshold, mde_rel, alpha, power,
required_n_per_arm, min_duration_days, ice_impact, ice_confidence, ice_evidence_ref, ice_ease,
rice_reach, rice_effort_pm, budget_php, approved_by, preregistered_at, started_at, status,
actual_n, elapsed_days, observed, ci_or_p, verdict, learning, next_action), enforced by
`score-guild.sh experiments`:

- **Hypothesis grammar** (Balfour's written, quantifiable hypotheses [11]): `If we [change] for
  [ICP], [metric] moves from [baseline] to [target] because [assumption]` — baseline and target
  numeric and equal to the baseline / target_threshold columns.
- **Sample size**: `required_n_per_arm` is computed from baseline, relative MDE, α = 0.05 and
  power = 0.8 with the standard two-proportion formula, floored by Evan Miller's shorthand
  **n ≈ 16σ²/δ²** [13][14] (P1; his worked example: baseline 10.2 % → 13.2 %, 80 % power,
  α = 5 % → 2,545 per variation). A stated required_n below the computed value is a violation.
- **No peeking**: `verdict ∈ WIN | LOSE` only when `actual_n ≥ required_n` **and**
  `elapsed_days ≥ min_duration_days ≥ 7` (one full business cycle); otherwise the verdict is
  forced **INCONCLUSIVE** — continuous significance-checking turns a nominal 5 % level into a
  **26.1 % false-positive rate** (Evan Miller's peeking penalty [14]).
- **ICE/RICE prioritization** (Ellis [12][15]; McBride/Intercom [4]): Impact × Confidence ×
  Ease 1–10, or Reach × Impact × Confidence ÷ Effort. Confidence is gamed by default — "how
  much evidence do you have?" [15] — so `ice_confidence > 5` requires a non-empty
  `ice_evidence_ref`. Over-weighting Ease kills big bets: review the high-Impact/low-Ease
  backlog quarterly [15]. "RICE scores shouldn't be used as a hard and fast rule" [4].
- **Spend is human-gated**: `status ∈ running | done` requires `approved_by` and `budget_php ≤
  GUILD_EXPERIMENT_CAP` (default ₱50,000 — policy, per-venture override); `preregistered_at`
  strictly before `started_at`.
- **Tempo**: aim for ≥ 1 experiment reaching verdict per week once channels are live (Ellis
  high-tempo testing — threshold is policy [12]); learnings are captured in the row and pushed
  across the team [11].

**Investment order (Ellis)**: activation → engagement → referral → revenue model → acquisition
— paid acquisition before activation works is the classic waste [12]. The PMF survey threshold
(≥ 40 % "very disappointed") gates scaling spend [12].

## §10 Consent, deliverability, spend (what `consent` enforces)

`consent.csv` (human-evidenced): contact_id, source, timestamp, consent_text_version, purposes,
channels, evidence, withdrawn_at. `send-log` rows join it; `spend.csv` rows carry `approved_by`
and a `cap_ref`.

- **DPA baseline** (RA 10173 [21] P1): consent is a "freely given, specific, informed indication
  of will", evidenced in written, electronic or recorded form; transparency, legitimate purpose,
  proportionality (Sec 11); penalties for unauthorized processing run 1–3 years and ₱500k–₱2M
  (sensitive: 3–6 years, up to ₱4M).
- **NPC AO 2017-42** [22] (P2 report of the primary): a privacy notice deeming "continued use"
  as consent for direct marketing is "implied or inferred consent" and "not sufficient";
  silence, **pre-ticked** boxes or inactivity do not constitute consent. The gate voids consent
  rows whose source is pre-ticked / continued-use / implied, and treats an **opt-in** as an
  affirmative act with evidence.
- **SMS/Viber require an explicit channel opt-in**; whether legitimate interest can carry B2B
  email is UNVERIFIED (NPC guidance not retrieved) — 1:1 founder outreach citing
  `basis: legitimate_interest` is allowed but flagged on stderr, defaulting to consent [22].
- **Withdrawn contacts are never sent** — a withdrawal before `sent_at` is a violation on any
  marketing or outreach send.
- **Every send is a human sign-off row**: `human_approved_by` + `human_approved_at ≤ sent_at`.
- **Deliverability** (Gmail bulk-sender rules, effective 2024-02-01 [34] P1): keep **spam
  complaints < 0.10 %** and never reach **0.30 %**; SPF + DKIM + DMARC; one-click unsubscribe.
  Use a **dedicated sending subdomain** from day one — sending-domain reputation is not
  resettable (§12). Bounce > 2 % triggers list hygiene [35].
- **Cadence**: template word counts ≤ 100 (≤ 75 for founder-* templates), batch sizes ≤ 50
  (sub-50 campaigns reply 5.8 % vs 2.1 % for 1,000+ blasts [35]), sequences plan ≥ 3 follow-ups
  (3–5 follow-ups reply 8.3 % vs 4.1 %; 42 % of replies come from follow-ups; 48 % of reps
  never follow up [35]) and stop at ≤ 11 attempts per contact.

## §11 Metric thresholds (weekly review; sources §3 of brief 07)

| Signal | Threshold → action |
|---|---|
| Landing page CVR | < 3.8 % (SaaS median, Unbounce [3]) after ≥ 500 visitors → FIX; < 2 % → STOP traffic to the page |
| Email click / unsub | click < 1.5 % or unsubscribe > 0.5 % on ≥ 1,000 sends → WARN (opens are not a KPI post-MPP [5]) |
| Spam complaints | ≥ 0.10 % → STOP sends until fixed; ≥ 0.30 % → hard STOP + domain review [34] |
| Bounce | > 2 % → list-hygiene gate [35] |
| Cold email | reply < 3 % after ≥ 200 sends with ≥ 3 follow-ups → kill or rewrite the sequence [35] |
| Paid | CPL > 2× the channel benchmark row for 3 consecutive weeks → PAUSE proposal (human executes) [6][7] |
| Funnel | MQL→SQL < 26 % (worst-channel benchmark) → ICP/qualification review; opportunity→close < 30 % → offer/pricing review [10] |
| Unit economics | channel CAC ≤ LTV/3 (practitioner consensus; LTV from pricing) |
| Brand balance | activation > 70 % of a quarter's spend → WARN against the 50/50 split [27] |

## §12 Calendar, compliance-check, and early irreversibles

`calendar.csv` rows (date, week, asset_id, channel, format, pillar, cluster, icp_id,
funnel_stage, cta, owner, status, approved_by, compliance_check, published_url, utm_campaign,
cost_php): **nothing reaches `status=published` without `approved_by` and
`compliance_check=PASS`** — the pre-publish review runs the ASC claim rules [16], RA 7394 Arts
110/115/**116** (a sales promotion "national in character" needs a **DTI promo permit filed at
least thirty (30) calendar days** before commencement; deemed approved if no objection in 15
days [20]), DPA consent [21][22], and the **Internet Transactions Act (RA 11967**, full effect
2025-06-20 [23]): merchants submit corporate/trade name, business address and contact details to
the DTI E-Commerce Bureau and publish them; listings carry accurate descriptions, prices and
conditions with images consistent with what is delivered; transactions issue receipts —
takedowns, blacklisting and fines ₱5k–₱1M for breach.

**Early irreversibles** (charter rows; brief 07 §6): brand name / domain / handles / trademark
check; category and positioning frame (re-does the pillar set [30]); primary ICP segment
(channel CAC varies ~5× and content does not transfer [9]); channel commitment (the 4–6-month
learning period is sunk [9]); **sending-domain reputation** (dedicated subdomain from day one
[34]); **consent capture design** (retroactive consent is impossible [22]); public superlative
claims (one-year-fresh substantiation for as long as they run [16]); marketplace choice
(ratings are non-transferable; Lazada −34 % while TikTok Shop +53 % [24]); UTM/attribution
taxonomy [33]; pricing-page publication (anchors prospects — pricing protocol owns the number).

## §13 Failure modes the gates exist to catch

Peeking/early stopping (26.1 % false positives [14]) → forced INCONCLUSIVE. Confidence gaming
[15] → evidence_ref required. Unsubstantiated superlatives → ASC disapproval and RA 7394
liability [16][20] → superlative lint. "Continued use = consent" [22] → consent ledger. Sending
without one-click unsubscribe or above 0.30 % spam [34] → email lint + STOP. Volume blasting
[35] → batch cap + follow-up minimum. All-activation budgets and SOV below SOM [27][28] →
budget warn. Multiple CTAs [32] and professional-grade copy [2] → landing lint + reading-grade
warn. US benchmarks as PH targets [6][7][9] → ceilings only. Case study without a release form
[31] → release lint. National promo without a DTI permit ≥ 30 days prior [20] →
compliance-check row. Marketplace images that do not match delivery [23] → listing lint. Open
rate as a KPI after Apple MPP [5] → click-based thresholds. Paid acquisition before activation
works [12] → Ellis-order review. MQL inflation → MQL→SQL floor [10].

## §14 What the gates block (contract summary)

- `experiments <experiments.csv>` → `EXPERIMENT_VIOLATIONS: N`: malformed or inconsistent
  hypotheses; understated required_n; WIN/LOSE below n or under 7-day min_duration; confident
  rows without evidence refs; running/done without approved_by, over budget cap, or without
  pre-registration before start.
- `assets <dir> <claims.tsv> <icp.yaml>` → `ASSET_LINT: N`: placeholders; unresolved icp_id;
  missing offer/price refs; unsourced numbers; unsubstantiated superlatives; unnamed
  comparators; multi-CTA landing pages; incomplete case studies or missing release forms;
  pricing pages without currency/unit/inclusions/VAT; email sequences without
  unsubscribe/List-Unsubscribe/consent_source; listings without ITA merchant disclosures.
- `consent <consent.csv> <sends.csv>` → `CONSENT_VIOLATIONS: N`: unapproved sends; marketing
  sends with no live opt-in for the channel and purpose; invalid consent sources; SMS/Viber
  without explicit opt-in; withdrawn contacts sent; oversize templates and batches; sequences
  under 3 planned follow-ups or over 11 attempts.

Policy env: `GUILD_EXPERIMENT_CAP`, `GUILD_MIN_DURATION_FLOOR`, `GUILD_ASC_FRESH_DAYS`,
`GUILD_READING_GRADE_WARN`, `GUILD_SEND_BATCH_MAX`, `GUILD_EMAIL_WORDS_MAX`,
`GUILD_FOUNDER_WORDS_MAX`, `GUILD_FOLLOWUPS_MIN`, `GUILD_ATTEMPTS_MAX`, `GUILD_SEQ_AGE_DAYS`.

## §15 Sources (brief 07 numbering; retrieved 2026-09-02)

[1] DataReportal Digital 2025: Philippines (P1) · [2][3] Unbounce Conversion Benchmark Report
2024 (P2) · [4] McBride, Intercom RICE (P1) · [5] Mailchimp email benchmarks, Dec 2023 (P2) ·
[6][7] LocaliQ/WordStream search & Facebook benchmarks (P2) · [8] HockeyStack LinkedIn Ads
(P2) · [9][10] First Page Sage CAC-by-channel & funnel benchmarks (P2) · [11] Balfour,
Maximize Learning (P1) · [12] Ellis via Lenny's Newsletter 2024 (P1) · [13][14] Evan Miller
sample-size calculator & "How Not To Run an A/B Test" (P1) · [15] van Gasteren on ICE (P2) ·
[16]–[19] Ad Standards Council code, coverage, screening (P1) · [20] RA 7394 Consumer Act
(P1) · [21] RA 10173 Data Privacy Act (P1) · [22] SyCipLaw on NPC AO 2017-42 (P2) · [23] Cruz
Marcelo on RA 11967 ITA (P2) · [24] Cube.asia PH e-commerce (P2) · [25] Philstar on Viber PH
(P2) · [26] LinkedIn SSI (P1) · [27] LinkedIn B2B Institute / Binet & Field (P1) · [28] IPA
(P2) · [29] Murrell summary (P3) · [30] HubSpot topic clusters (P2) · [31] HubSpot case-study
guide (P2) · [32] Unbounce landing-page anatomy (P2) · [33] Google Ads attribution models
(P1) · [34] Gmail sender guidelines (P1) · [35] Woodpecker cold-email statistics (P2) ·
[36][37] Wikipedia marketing mix / STP (P3).
