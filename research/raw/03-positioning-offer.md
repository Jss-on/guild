# Positioning, value proposition & offer design — research brief (2026-09-02)

Domain 03 of the guild body-of-knowledge. Scope: positioning (Dunford, Moore), value proposition (Osterwalder/Strategyzer), messaging hierarchy, ICP/anti-ICP, offer design for an engineering studio (productized services, paid discovery, Good-Better-Best, bundling, guarantees, pilots), category design, one-pager and sales narrative (Raskin, Dunford's Sales Pitch), positioning-statement lint, Philippine B2B buyer norms. All numbers come from URLs fetched on 2026-09-02; anything not fetched is marked UNVERIFIED. Provenance: P1 = author/primary/government, P2 = reputable secondary, P3 = weak/practitioner blog. Sources are numbered [S#] and listed in section 8.

Context note: the founders are a PH engineering studio selling software+hardware build capacity with no customer yet. Positioning here is therefore *service* positioning first (what engagement, for whom, against what alternative), and product positioning only once a repeatable product emerges.

---

## 1. Standard process — ordered steps and named deliverables

Synthesised from Dunford's 10-step method [S1][S21][S22], Osterwalder's VPC [S2][S3][S4], Moore [S11][S13], Raskin [S9], Dunford's Sales Pitch [S23], and paid-discovery practice [S14][S15][S16]. Each step names the ledger artifact the harness keeps.

| # | Step | What a competent practitioner does | Deliverable (artifact) |
|---|------|-------------------------------------|------------------------|
| 0 | Evidence intake | Import interview ledger from domain 02 (interview ids, quotes, jobs/pains/gains, alternatives named, trigger events). Positioning is downstream of evidence, never upstream. Dunford: early-stage teams should "allow the market and customers to pull you" before locking positioning [S20]. | `interviews.csv` (read-only input) |
| 1 | Identify customers who love you / best-fit signals | Dunford step 1: start from customers who "really, really care a lot about that value"; look for shared firmographics, tools, company stage [S20][S21]. With zero customers, substitute: interviewees who showed buying intent (Do > Tell [S18]). | `bestfit_signals.csv` (interview_id, intent_signal, segment_attrs) |
| 2 | Form positioning team + drop baggage | Dunford steps 2–3: cross-functional team, agreed vocabulary, explicitly discard legacy positioning [S21]. | `positioning_team.md` |
| 3 | List true competitive alternatives | Dunford: "what would a customer do if your offering didn't exist?" — includes status quo (spreadsheets, manual, do nothing, in-house build) [S1]. Reject "phantom competitors" never met in deals [S1]. Userlist found 4 alternative clusters incl. manual and in-house [S21]. | `alternatives.csv` (alt_id, name, type=status_quo/in_house/vendor, evidence interview_ids) |
| 4 | Isolate unique attributes | "What do we have that the alternatives do not?" [S1]; feature-function first, then translate. Non-defensible adjectives ("simple", "affordable") get reframed or dropped [S21]. | `attributes.csv` (attr_id, attribute, lacking_alt_ids) |
| 5 | Map attributes → value themes + proof | For each attribute ask "so what for customers?" [S1]; cluster into 2–4 value themes (Userlist: 3) [S21]; attach proof [S22]. Cross-check with VPC: each theme must relieve a ranked pain or create a ranked gain [S3][S4]. | `value_themes.csv` (theme_id, statement, attr_ids, pain_gain_ids, proof_ids) |
| 6 | Customer profile (VPC right side) | Jobs (functional/social/emotional), pains, gains; rank pains by intensity and frequency, gains by relevance, products by importance [S3][S4]. | `customer_profile.csv` (item_id, type, text, rank, interview_ids) |
| 7 | Determine who cares a lot → ICP + anti-ICP | Dunford step 7 [S21]; beachhead criteria: burning pain, high willingness to pay, growth, proximity/access, sub-segment of expandable market [S18]. Anti-ICP codifies disqualifiers from worst-fit patterns [S17]. Add triggers (push/pull/anxiety/habit; switch when push+pull > anxiety+habit [S25]). | `icp.yaml` + `anti_icp.yaml` (each attribute traced to interview_ids) |
| 8 | Choose market category / frame of reference | Dunford styles: head-to-head, big-fish-small-pond, create-a-new-game [S22]; Userlist chose big-fish-small-pond inside "customer messaging tools" [S21]. Dunford: "90% of tech companies that have gone public over the past five years have been positioned in existing markets" [S1]. | `category_decision.md` (style, category, rationale, rejected options) |
| 9 | Layer a relevant trend | Dunford step 9/canvas field 6: trend supports but never replaces value [S21][S22]. | field in `positioning_canvas.yaml` |
| 10 | Capture positioning canvas + statement | Dunford canvas: competitive alternatives, unique attributes, value (and proof), target segments, market category, relevant trends [S22]. Moore statement: "For (target customer) who (need), the (product) is a (category) that (key benefit). Unlike (primary alternative), our product (primary differentiation)" [S13]. Moore's whole-product framing adds "we have assembled (key whole product features)" — UNVERIFIED wording (search-snippet only). | `positioning_canvas.yaml`, `positioning_statement.md` |
| 11 | Messaging hierarchy | Top: value statement/tagline; then 3–5 messaging pillars; then proof points per pillar; plus target audience and use cases [S19]. Positioning (internal) informs messaging (external) [S19]; positioning "is not a tagline" [S1]. | `messaging.yaml` |
| 12 | Whole-product / offer design | Whole product = "a generic or core product, augmented by everything that is needed for the customer to have a compelling reason to buy" [S12]; Moore's three chasm dependencies: "a compelling use case that will create pull, a whole product that nails the use case, and a word-of-mouth community" [S11]. Design the offer ladder: paid discovery → scoped build → retainer/support; Good-Better-Best tiers [S6]; mixed (not pure) bundling [S38]; guarantee with cap; pilot terms. | `offers.yaml` (tiers, prices, fences, scope-in/out, guarantee, pilot) |
| 13 | Sales narrative + one-pager | Raskin: 1 name the big change, 2 winners and losers, 3 tease the promised land, 4 features as "magic gifts", 5 evidence [S9]. Dunford pitch: setup (insight, alternatives, perfect world) → follow-through (introduction, differentiated value, proof, objections, ask) [S23]. Do not ship the investor deck to customers [S24]. | `narrative.md`, `one_pager.md` |
| 14 | Test in live sales conversations | Dunford: watch for "back up and pitch it to me again"; every function saying something different = weak positioning [S20]. Ship changes to homepage/one-pager and record reactions per conversation. | `pitch_tests.csv` (conversation_id, version, confusion_flag, next_step_agreed) |

---

## 2. Frameworks & methods

| Framework | Originator | Produces | When to use | Known critiques / caveats |
|-----------|-----------|----------|-------------|---------------------------|
| Positioning components + 10-step method + canvas [S1][S21][S22] | April Dunford, *Obviously Awesome* (2019) | Alternatives → attributes → value → segments → category (+ trends); shareable canvas | Once there are customers (or intent-showing interviewees) who love something specific; repeat when market shifts | Author herself warns against locking positioning pre-PMF [S20]; "takes a week" only if team is aligned [S20]; canvas is not messaging [S1] |
| Market category styles (head-to-head / big fish small pond / create new game) [S22][S21] | Dunford | Category decision | Step 8 | Tension with category-design school (below): Dunford cites 90% of IPOs positioned in existing markets [S1] vs Play Bigger's 76% market-cap claim [S8] |
| Positioning statement template [S13] | Geoffrey Moore, *Crossing the Chasm* | One-sentence statement with 6 slots | After canvas; as the lintable artifact | Statement ≠ positioning work; slots can be filled with fluff — lint required (section 5) |
| Whole product [S11][S12] | Levitt (total product) → McKenna → Moore | Inventory of everything the pragmatist buyer needs beyond the core deliverable (install, training, support, integrations, warranty) | Offer design, esp. hardware+software | Studio must decide which whole-product parts it delivers vs partners; Levitt: "There is no such thing as a commodity. All goods and services are differentiable" [S26] |
| Value Proposition Canvas [S2][S3][S4] | Osterwalder & Pigneur, *Value Proposition Design* (2014), Strategyzer | Customer profile (jobs/pains/gains, ranked) ↔ value map (products, pain relievers, gain creators); "fit" | Steps 5–6; keeps value claims tethered to ranked evidence | Strategyzer's summary states fit "typically means your value proposition addresses 50-70% of your customers' most significant pains and gains" [S3] — editorial figure, not an empirical study; ranking is subjective unless tied to interview counts |
| Four forces / switch timeline [S25] | Bob Moesta & Chris Spiek (JTBD) | Push, pull, anxiety, habit per segment; switch rule "Push + Pull > Anxiety + Habit" | Deriving ICP triggers and objections; "you hear them live in a good interview" [S25] | Qualitative; forces must be quoted from interviews, not inferred |
| ICP / anti-ICP [S17][S18] | Practitioner (B2B Playbook; Maja Voje) | Firmographics, demographics/roles, technographics, behavioural fit, disqualifiers; beachhead criteria | Step 7; before any outbound spend | Without customers the ICP is a hypothesis — must be versioned and re-derived after first 5–10 paying customers (practitioner consensus) |
| Messaging framework / hierarchy [S19] | Aha! template (generic PMM practice) | Value statement → pillars → proof points; audience; use cases | Step 11 | Pillars without proof ids are slogans |
| Good-Better-Best [S5][S6] | Rafi Mohammed, HBR Sept–Oct 2018 | Three tiers: Good attracts, Better retains, Best expands; fence attributes; anchoring | Offer packaging for repeatable engagements (audit, build, support) | Cannibalisation if Good is too rich; price-partitioned "Good" with many fees breeds resentment [S6]; compromise effect is a lab finding (Simonson 1989 [S39]) — magnitudes vary |
| Bundling (mixed vs pure) [S38] | Derdenger & Kumar, *Marketing Science* 2013 | Bundle price + à-la-carte availability | Hardware + firmware + app + support bundles | Evidence is from video-game consoles; "mixed bundling dominates pure bundling and pure components" [S38] — directional for services |
| Paid discovery / roadmapping [S14][S15][S16] | Brennan Dunn; Karl Sakas; agency practice | Fixed-price, fixed-scope diagnostic (audit 4–20 pages, workshop, spec) that outputs 2–3 scoped next projects | First offer in the ladder; converts "free proposal" time into revenue and proof | Sakas: it is a "polite battle for control" and sets precedent; skip only for strong-fit clients when you already have enough info to quote [S15] |
| Productized service ladder [S16] | Haus Advisors (practitioner) | e.g. $5K audit → $15K roadmap → $50K+ implementation; productize what you've delivered ≥6 times with ~80% repeatable | Once ≥6 similar deliveries exist | P3 source; studio with zero deliveries cannot productize yet — start with discovery only |
| Money-back / performance guarantees [S37] | Suwelack, Hogreve & Hoyer, *J. Retailing* 2011 (metadata verified; findings UNVERIFIED — abstract not retrievable) | Risk-reversal clause | Pilots, first customer | Consumer-retail evidence; B2B services guarantees need trigger, remedy and cap or they are unpriced liabilities (practitioner consensus) |
| Category design [S7][S8] | Yoon (HBR 2013); Ramadan/Peterson/Lochhead/Maney, *Play Bigger* | New category + POV + ecosystem | Only if a genuinely new problem frame exists and there is budget to educate a market | Contradicted for early-stage by Dunford's 90% figure [S1]; HBR 2019: category creation "involves not just a breakthrough product, but also a business model innovation" [S8] — expensive; not a default for a zero-customer studio |
| Strategic narrative [S9][S10] | Andy Raskin | 5-part story: change, winners/losers, promised land, magic gifts, evidence | Sales deck, homepage, one-pager | Requires CEO ownership [S9]; over-dramatised "change" without evidence reads as hype |
| Sales Pitch structure [S23] | Dunford, *Sales Pitch* (2023) | Insight → alternatives → perfect world → introduction → differentiated value → proof → objections → ask | Live pitch script | Built for products with a category; services need "perfect world" reframed as "what a good engagement looks like" |
| Investor deck ≠ customer messaging [S24] | Emily Kramer via First Round Review | Website copy translated for customers | Step 13 | — |

---

## 3. Numbers annex

All retrieved 2026-09-02.

| Metric | Benchmark / threshold | Context | Source URL | Grade | Retrieved |
|--------|-----------------------|---------|------------|-------|-----------|
| Share of recent tech IPOs positioned in existing markets | "90% … over the past five years" | Dunford's argument against default category creation | https://www.aprildunford.com/post/a-quickstart-guide-to-positioning | P1 (author claim, underlying study not cited on page) | 2026-09-02 |
| Category creator share of category market cap | 76% | HBR 2019, quoting SAP CEO on Qualtrics; originates from Play Bigger | https://hbr.org/2019/11/the-difference-between-a-first-mover-and-a-category-creator | P1 (partial page) | 2026-09-02 |
| Keurig category example | K-Cups >200 flavors, ~50¢ apiece, "10 times the cost per cup" of traditional brewing; 2012 US sales >$3.8B; >40% dollar share of coffeemakers | HBR 2013 Yoon | https://hbr.org/2013/03/why-it-pays-to-be-a-category-creator | P1 (partial page) | 2026-09-02 |
| Positioning exercise duration | "takes a week" (if aligned) | Dunford via Lenny's summary | https://www.lennysnewsletter.com/p/summary-april-dunford-on-product | P2 | 2026-09-02 |
| B2B deals lost to "no decision" | "about 40%" [S20]; "40-60%" [S23] | Dunford (citing external research, UNVERIFIED at origin) | https://www.lennysnewsletter.com/p/summary-april-dunford-on-product ; https://www.antoinebuteau.com/sales-pitch-book-summary/ | P2 | 2026-09-02 |
| VPC "strong fit" | addresses "50-70%" of most significant pains/gains | Strategyzer summary page (editorial) | https://www.strategyzer.com/library/value-proposition-design-book-summary | P1 site / P3 for the number | 2026-09-02 |
| Customer-understanding test | "predict 75% of what a customer tells you" | Christina Cacioppo (Vanta) via First Round | https://review.firstround.com/articles/positioning/ | P2 | 2026-09-02 |
| Userlist positioning evidence window | ~6 months of demo calls; 4 alternative clusters; 3 value themes | Applied Dunford case | https://userlist.com/blog/positioning-overhaul/ | P2 | 2026-09-02 |
| Paid discovery price | "$500 to $2,500", up to $10,000 on-site; "5-10%" of expected project/retainer value; enterprise "$25,000 to $125,000" | Sakas | https://sakasandcompany.com/start-using-paid-discovery/ | P2 | 2026-09-02 |
| Paid-discovery credit deadline | "between 2-6 weeks" | Sakas | same | P2 | 2026-09-02 |
| Roadmapping example price | $297 for 1-hour call + spreadsheet | Brennan Dunn case | https://doubleyourfreelancing.com/3-reasons-roadmapping/ | P2 | 2026-09-02 |
| Unpaid sales effort baseline | "3-4 hours per lead"; close "25%" of proposals ⇒ ~14 h per landed client | Dunn | same | P2 | 2026-09-02 |
| Productized ladder example | $5K audit → $15K roadmap → $50K+ implementation; productize after "six or more" similar deliveries; 80/20 repeatable | Haus Advisors | https://www.hausadvisors.com/blog/productize-agency-services | P3 | 2026-09-02 |
| G-B-B price spacing rule of thumb | Better ≈ +10% over average sale price; Good ≈ −25%; Best ≤ +50% | Jewelry consultant cited in Wikipedia (from HBR 2018) | https://en.wikipedia.org/wiki/Good%E2%80%93better%E2%80%93best | P2 | 2026-09-02 |
| Anchoring effect example | Williams-Sonoma $279 bread machine "sales almost doubled" after $429 model | Wikipedia citing Mohammed | same | P2 | 2026-09-02 |
| Upgrade behaviour | Airlines: ">50%" of consumers starting at lower price upgrade | same | same | P2 | 2026-09-02 |
| Peloton tiering | Basic $2,245 → $1,895; premium introduced at $2,495 | same | same | P2 | 2026-09-02 |
| Bundling | "mixed bundling dominates pure bundling and pure components" in revenues | Derdenger & Kumar 2013, Marketing Science, DOI 10.1287/mksc.2013.0810 | https://api.crossref.org/works?query.bibliographic=The+Dynamic+Effects+of+Bundling+as+a+Product+Strategy+Derdenger+Kumar | P1 (abstract via Crossref) | 2026-09-02 |
| Pure-bundling revenue penalty | ">20 percent" lower vs mixed | search snippet of HBS Working Knowledge; page fetch failed | UNVERIFIED | — | — |
| Wasted spend per bad-fit prospect | "$5K–$10K" anecdote | B2B Playbook | https://theb2bplaybook.com/b2b-ideal-customer-profile-anti-icp | P3 | 2026-09-02 |
| PH first-time trade payment | Letter of Credit "common and secure" for first-time/unestablished relationships; D/A "30 to 60 days"; O/A "30 days to 180 days" | US ITA Country Commercial Guide | https://www.trade.gov/country-commercial-guides/philippines-trade-financing | P1 | 2026-09-02 |
| PH B2B payment terms/methods | Net 15/30/60/90 used; check or bank deposit typical, "up to ₱2,000,000.00"; GCash cap ₱100,000 | Shoppable.ph | https://shoppable.ph/terms-of-payment-for-b2b-procurement/ | P2 | 2026-09-02 |
| PH after-sales expectation | "Philippine partners expect strong after-sales service and support … during and after the warranty period" | ITA CCG | https://www.trade.gov/country-commercial-guides/philippines-selling-factors-and-techniques | P1 | 2026-09-02 |
| PH internet/social | "72% of the nation's population are on the internet"; ">four hours a day" on social | ITA CCG | same | P1 | 2026-09-02 |
| PH government tenders | RA 9184 framework; PhilGEPS Platinum membership required; bid docs "$10 to $1,500"; "minimum of 60 percent Filipino ownership is usually required"; award to "lowest calculated and responsive bid"; retention/bank guarantee "1 to 5 percent"; specs "do not often take life cycle cost into account" | ITA CCG | https://www.trade.gov/country-commercial-guides/philippines-selling-public-sector | P1 | 2026-09-02 |
| PH RA 12009 (NGPA) | Competitive bidding default; 7 phases; LCRB + new MEARB (weighted technical/financial) for goods/infra; consulting = "Highest Rated Responsive Bid" | GPPB | https://www.gppb.gov.ph/understanding-competitive-bidding-under-ra-12009/ | P1 | 2026-09-02 |
| PhilGEPS Platinum fee | ₱5,000.00; certificate required for Public Bidding, Limited Source, Negotiated (two failed biddings); "official receipt … is not equivalent to the issuance of the certificate" | PS-PhilGEPS advisory | https://ps-philgeps.gov.ph/home/index.php/about-ps/news/250-advisory-on-submission-of-philgeps-certificate-of-registration-to-procuring-entities | P1 | 2026-09-02 |
| PH expanded withholding tax on the studio's invoices | Professional fees: individuals 5% (≤₱3M) / 10%; juridical 10% (≤₱720K) / 15%; contractors 2%; Top Withholding Agents 1% goods / 2% services (≥6 transactions or casual ≥₱10,000); BIR 2307 within 20 days after quarter end; sworn declaration by Jan 15 | Tax & Accounting Center PH | https://taxacctgcenter.ph/items-subject-expanded-withholding-tax-train-ra-10963-philippines/ | P2 | 2026-09-02 |

---

## 4. Philippine specifics (verifiable only)

1. **Relationship-first, hierarchy-heavy buying** — Commisceo: "Building relationships is essential"; "relationships [are] personal rather than purely transactional"; "Face-to-face interaction is preferred"; "Hierarchy influences decision making, with authority concentrated at senior levels"; difficulty "identifying who the true decision maker is"; indirect communication and *hiya* (avoid causing embarrassment); "Negotiations tend to be relationship-oriented and can take time" [S36]. Grade P3 (culture-guide vendor). The ITA guide corroborates only indirectly: agents/distributors "are essential" and buyers "expect strong after-sales service … during and after the warranty period" [S29][S30]. Harness implication: ICP must carry a `decision_maker_role` and `relationship_owner` field; pipeline stage "sponsor identified" cannot be skipped.
2. **Payment and trust ladder** — First-time counterparties use L/C; open account 30–180 days only after trust [S28]. Domestic B2B: Net 15–90, paid by check/bank deposit [S27]. Implication: the first offer (paid discovery) should be small enough to be prepaid or 50/50; do not extend Net-60 on a first deal (practitioner consensus).
3. **Withholding tax shapes the invoice** — Corporate clients withhold 2% (contractor/TWA services) up to 10–15% (professional fees to a juridical entity) and issue BIR 2307 [S33]. Implication: price lists must state "exclusive of VAT; subject to creditable withholding tax" and the cash-flow model must net out EWT; a 2307 ledger is a harness artifact.
4. **Government as ICP is a structural decision** — PhilGEPS Platinum membership (₱5,000) and certificate are prerequisites [S35]; foreign participation "usually" needs 60% Filipino ownership [S31] (moot for a PH studio, but relevant if foreign investors come in); awards are LCRB, or MEARB with weighted technical/financial scoring under RA 12009 [S34]; consulting services use Highest Rated Responsive Bid [S34]; specs often ignore life-cycle cost [S31]; retention 1–5% [S31]. Implication: a value/TCO positioning does not win LCRB tenders; if government is in the ICP, positioning must be spec-compliance + price, or target MEARB/consulting modes where technical weight exists.
5. **Scams** — ITA warns of "many reported scams from entities impersonating the Philippine Government" [S31]. Implication: anti-ICP disqualifier: inbound "government" leads without a PhilGEPS-published notice.
6. **After-sales as whole product** — expectation of support beyond warranty [S29] means the hardware whole product must include a support tier; this is a PH-verified whole-product component.

Not verifiable in this pass: Hofstede scores for PH (page returned empty), *pakikisama*/*utang na loob* in a B2B procurement study, typical PH DSO for SME suppliers. Mark UNVERIFIED.

---

## 5. Mechanical gate candidates

Every gate is a script over CSV/YAML ledgers. "Cannot mechanize" lists what stays human.

### G3.1 Alternatives ledger (`alternatives.csv`)
- Fields: `alt_id, name, type{status_quo,in_house,vendor,do_nothing}, evidence_interview_ids[], lost_deal_ids[]`.
- Lint: (a) ≥1 row with `type=status_quo` or `do_nothing` (Dunford: status quo is an alternative [S1]); (b) every row has ≥2 distinct `evidence_interview_ids` — rows with 0 are "phantom competitors" [S1] → FAIL; (c) ≥3 rows total.
- Cannot mechanize: whether the alternative list is *complete*.

### G3.2 Attribute → value → evidence chain (`attributes.csv`, `value_themes.csv`, `customer_profile.csv`)
- Fields: attribute rows carry `lacking_alt_ids[]`; theme rows carry `attr_ids[], pain_gain_ids[], proof_ids[]`; profile rows carry `rank, interview_ids[]`.
- Lint: (a) every attribute lists ≥1 `lacking_alt_id` that exists in G3.1 (else it is not unique); (b) every value theme maps to ≥1 attribute and ≥1 pain/gain whose `rank ≤ 5`; (c) top-5 ranked pains/gains each have ≥3 `interview_ids` (VPC ranking must be evidence-weighted [S4]); (d) 2 ≤ themes ≤ 4 (Userlist: 3 [S21]); (e) banned undifferentiated adjectives as sole attribute text (`simple|affordable|cheap|quality|innovative|best`) → WARN, per the Userlist reframe [S21]; (f) each theme has ≥1 `proof_id` resolving to an evidence file (quote, case, metric).
- Cannot mechanize: whether the "so what" is actually valuable.

### G3.3 ICP / anti-ICP (`icp.yaml`, `anti_icp.yaml`)
- Fields (ICP): `firmographics{industry, size_band, geography, revenue_band}`, `roles{economic_buyer, champion, decision_maker_role, relationship_owner}`, `technographics[]`, `pains[]`, `triggers{push[], pull[], anxiety[], habit[]}`, `buying_process{procurement_mode, payment_terms_expected, withholding_class}`, `beachhead_criteria{burning_pain, willingness_to_pay, growth, access, expandable}`; every leaf carries `evidence_interview_ids[]`.
- Fields (anti-ICP): `disqualifiers[] {rule, evidence_ids[]}`.
- Lint: (a) every ICP leaf has ≥3 interview ids (threshold; raise to 5 once ≥20 interviews exist); (b) all 4 force buckets non-empty [S25]; (c) all 5 beachhead criteria have a value and a source id [S18]; (d) ≥3 anti-ICP disqualifiers [S17], and at least one PH-specific (e.g., unverifiable government lead [S31]); (e) `decision_maker_role` ≠ null (PH hierarchy [S36]); (f) `procurement_mode ∈ {private, philgeps_lcrb, philgeps_mearb, philgeps_consulting}` and if PhilGEPS, `philgeps_certificate_status` present [S35].
- Cannot mechanize: judging that the segment is reachable and large enough — that is domain 04/05's sizing gate.

### G3.4 Positioning statement completeness lint (`positioning_statement.md` + `positioning_canvas.yaml`)
Moore's six slots [S13] cross-checked against the canvas [S22]:
- Slots present and non-empty: `target`, `need`, `category`, `benefit`, `primary_alternative`, `differentiator` (+ optional `whole_product_assembled`).
- Referential integrity: `target` ⊆ `icp.yaml` segment; `primary_alternative` ∈ `alternatives.csv`; `category` == `category_decision.category`; `differentiator` resolves to ≥1 `attr_id`; `benefit` resolves to ≥1 `theme_id`.
- Form: each slot ≤ 25 words; statement ≤ 75 words; no banned adjectives (G3.2e); `category` is a noun phrase a buyer already uses unless `category_decision.style == create_new_game` (then require a written education budget line — Dunford's 90% caution [S1]).
- Trend field present but not used as `benefit` [S21].
- Pass: 0 FAIL, ≤2 WARN.
- Cannot mechanize: whether the category makes the value "obvious" — tested only in G3.8 conversations.

### G3.5 Messaging hierarchy (`messaging.yaml`)
- Fields: `value_statement`, `pillars[] {name, capability, benefit, proof_ids[]}`, `audience_ids[]`, `use_cases[]`.
- Lint: exactly 1 value statement; 3 ≤ pillars ≤ 5 [S19]; every pillar has ≥1 `proof_id`; every pillar maps to a `theme_id`; audience ids ∈ ICP.
- Cannot mechanize: tone, clarity.

### G3.6 Offer ledger (`offers.yaml`)
- Fields per offer: `name, tier{discovery,good,better,best,pilot,retainer}, price_php, price_basis{fixed,range,per_sprint}, scope_in[], scope_out[], fence_attributes[], deliverables[], duration_days, prepay_pct, payment_terms_days, guarantee{trigger, remedy, cap_pct}, credit_to_next{amount, deadline_days}, whole_product{install, training, support_months, warranty_months, docs}`.
- Lint: (a) exactly one `discovery` offer exists and `price_php` is within 5–10% of the median `good/better` build price [S15]; (b) discovery `credit_to_next.deadline_days ∈ [14,42]` if a credit is offered [S15]; (c) if G-B-B present: `good.price < better.price < best.price`; `good.price ≥ 0.6 × better.price` and `best.price ≤ 1.5 × better.price` (from the −25%/+50% rule of thumb [S6]) → WARN outside; each tier has ≥1 `fence_attribute` absent from the tier below [S6]; `good.scope_out` non-empty (cannibalisation guard [S6]); (d) any bundle must have `a_la_carte_available: true` (mixed bundling [S38]); (e) every guarantee has non-null `trigger`, `remedy`, `cap_pct ≤ 100`; (f) hardware offers have `support_months ≥ warranty_months` (PH after-sales expectation [S29]); (g) `payment_terms_days ≤ 30` for a first engagement and `prepay_pct ≥ 50` for `discovery` (PH trust ladder [S28]) → WARN otherwise; (h) prices carry `tax_note: "ex-VAT; subject to EWT"` [S33].
- Cannot mechanize: whether the price is right — that is the unit-economics/pricing domain; here only structure is linted.

### G3.7 Narrative + one-pager (`narrative.md`, `one_pager.md`)
- Narrative lint: sections in order `change, winners_losers, promised_land, magic_gifts, evidence` [S9]; product name must not appear in `change` section (lead with change, not product [S9][S10]); `evidence` cites ≥2 `proof_ids`.
- One-pager lint (practitioner consensus for sections; each must resolve to a ledger): `who_for` (ICP id), `problem` (top-ranked pain ids), `what_we_do` (positioning statement verbatim), `offer` (offer ids + price/range + tax note), `proof` (proof ids), `why_us` (differentiator attr ids), `next_step` (discovery offer id), `contact`, `version/date`. Max 1 page (≤ 450 words) → WARN.
- Cannot mechanize: persuasiveness.

### G3.8 Pitch-test ledger (`pitch_tests.csv`) — the only outcome gate in this domain
- Fields: `conversation_id, date, icp_match{y,n}, positioning_version, confusion_flag{y,n}, alternative_named_by_buyer, next_step_agreed{y,n}, next_step_type{discovery_paid, proposal, none}`.
- Threshold (harness-set, not literature-derived): over the last ≥8 ICP-matched conversations, `confusion_flag = n` in ≥75% and `next_step_agreed = y` in ≥50%; else positioning is re-opened. Dunford's "predict 75%" [S24] and "back up and pitch it again" [S20] motivate the confusion metric; the 8/75/50 numbers are harness policy, UNVERIFIED as benchmarks.
- Cannot mechanize: the sending of outreach and the pitch itself (human-gated irreversibles).

---

## 6. Early irreversibles

| Decision | Why it's hard to reverse | Source |
|----------|--------------------------|--------|
| Beachhead segment / ICP v1 | First references, case studies, network and content all accrete to it; Moore's chasm strategy depends on one compelling use case and whole product [S11]; gtmstrategist calls beachhead "the one GTM decision you can't wing" [S18] | S11, S18 |
| Market category / frame of reference | Sets buyer assumptions about competitors, pricing and features [S1]; switching categories rewrote Userlist's site and sales materials repeatedly [S21] | S1, S21 |
| Category-creation attempt | Requires business-model innovation and market education [S8]; contradicts the base rate for early companies [S1] | S1, S8 |
| Paid-vs-free discovery precedent | Sakas: the first negotiation is a "polite battle for control" that sets relationship precedent [S15]; Dunn: free proposals are "worthless" [S14] | S14, S15 |
| Published price anchors / tier names | Anchoring effects run both ways [S6]; lowering a public "Best" price re-anchors all tiers | S6 |
| Guarantee terms | Contractual; once given to customer 1 it is expected by customer 2 (practitioner consensus) | — |
| Payment terms and withholding treatment on the first PH invoice | Sets the client's vendor-master record; O/A terms lengthen with trust, rarely shorten [S28]; EWT class fixed by registration and sworn declaration deadlines (Jan 15) [S33] | S28, S33 |
| Government route (PhilGEPS registration, ownership structure) | Registration and certificates are prerequisites; ownership thresholds constrain future investors [S31][S35] | S31, S35 |
| The narrative's "big change" thesis | Becomes homepage, deck, recruiting story; CEO-owned [S9] | S9 |
| Company/offer naming inside the category | Name that encodes a category (e.g., "email automation") drags when the category changes [S21] | S21 |

---

## 7. Failure modes / anti-patterns

| Anti-pattern | Guard in harness | Source |
|--------------|------------------|--------|
| Phantom competitors — positioning against rivals never met in deals | G3.1(b) evidence ids per alternative | Dunford [S1] |
| Ignoring the status quo / "do nothing" as the real alternative | G3.1(a) | Dunford [S1]; 40–60% no-decision losses [S20][S23] |
| Locking positioning before any customer pull | Gate G3.x runs only after ≥N interviews with intent signals; canvas is versioned | Dunford via Lenny [S20] |
| Defaulting to "create a new category" | G3.4 requires education budget line when `create_new_game` | Dunford 90% [S1] vs Play Bigger 76% [S8] — harness treats new-category as opt-in |
| Positioning ≠ messaging confusion — writing a tagline instead of a canvas | Separate artifacts; G3.5 depends on G3.4 | Dunford [S1] |
| Non-defensible attributes ("simple", "affordable") | G3.2(e) banned-adjective WARN | Userlist reframe [S21] |
| Value claims untethered to ranked pains/gains | G3.2(b)(c) | Strategyzer ranking rules [S4] |
| ICP built from assumptions, no anti-ICP | G3.3(a)(d) | B2B Playbook [S17] |
| Free discovery / free proposals as sales motion | G3.6(a) mandatory discovery offer | Dunn [S14]; Sakas [S15] |
| Productizing before repetition exists | G3.6 allows only `discovery` + custom until ≥6 similar deliveries logged | Haus Advisors [S16] (P3) |
| Feature-rich "Good" tier cannibalising "Better"; fee-riddled "Good" breeding resentment | G3.6(c) fences + scope_out | Mohammed via Wikipedia [S6] |
| Pure bundling of hardware+software+support | G3.6(d) mixed bundling | Derdenger & Kumar [S38] |
| Uncapped guarantee | G3.6(e) | practitioner consensus |
| Leading the pitch with the product instead of the change | G3.7 narrative order + product-name check | Raskin [S9][S10] |
| Shipping the investor deck to customers | G3.7 one-pager derives from ledgers, not the deck | First Round / Kramer [S24] |
| PH: positioning on TCO/value for LCRB tenders | G3.3(f) procurement_mode drives allowed pitch | ITA: specs "do not often take life cycle cost into account" [S31] |
| PH: invoicing without EWT/VAT note; cash model ignores withholding | G3.6(h) | [S33] |
| PH: extending long credit on first deal | G3.6(g) | ITA trade-financing trust ladder [S28] |
| PH: no after-sales tier on hardware | G3.6(f) | ITA [S29] |
| PH: sponsor/decision-maker not identified; expecting fast decisions | G3.3(e) | Commisceo [S36] (P3) |
| PH: fake government leads | anti-ICP disqualifier | ITA [S31] |
| Positioning document nobody uses | pitch_tests.csv must reference a `positioning_version`; stale version >90 days → WARN | practitioner consensus |

---

## 8. Sources

Retrieved 2026-09-02. Type: P1 primary/author/government; P2 reputable secondary; P3 weak. "partial" = only the public intro was fetchable.

1. A Quickstart Guide to Positioning — April Dunford · https://www.aprildunford.com/post/a-quickstart-guide-to-positioning · P1 · five components, ordered steps, phantom competitors, 90% existing-market claim, positioning ≠ messaging, case results.
2. The Value Proposition Canvas (official template page) — Strategyzer · https://www.strategyzer.com/library/the-value-proposition-canvas · P1 · six blocks, purpose.
3. Value Proposition Design: Book Summary — Strategyzer · https://www.strategyzer.com/library/value-proposition-design-book-summary · P1 site · job types, pains/gains definitions, "50-70%" fit statement, "focus on fit, not features".
4. Achieve product-market fit with the Value Proposition Designer canvas — Strategyzer · https://www.strategyzer.com/library/achieve-product-market-fit-with-our-brand-new-value-proposition-designer-canvas · P1 · plug-in to BMC; ranking rules for pains (intensity, frequency), gains (relevance), products (importance).
5. The Good-Better-Best Approach to Pricing — Rafi Mohammed, HBR Sept–Oct 2018 · https://hbr.org/2018/09/the-good-better-best-approach-to-pricing · P1 partial · thesis and Allstate example only (paywall).
6. Good–better–best — Wikipedia · https://en.wikipedia.org/wiki/Good%E2%80%93better%E2%80%93best · P2 · tier roles, Goldilocks/anchoring/halo, −25%/+10%/+50% spacing rule, Williams-Sonoma, airlines >50% upgrade, Peloton prices, cannibalisation and price-partitioning pitfalls.
7. Why It Pays to Be a Category Creator — Eddie Yoon, HBR March 2013 · https://hbr.org/2013/03/why-it-pays-to-be-a-category-creator · P1 partial · Keurig numbers.
8. The Difference Between a First Mover and a Category Creator — HBR Nov 2019 · https://hbr.org/2019/11/the-difference-between-a-first-mover-and-a-category-creator · P1 partial · 76% market-cap claim; category creation needs business-model innovation.
9. The Making of a Great Strategic Narrative — Andy Raskin (LinkedIn) · https://www.linkedin.com/pulse/making-great-sales-narrative-andy-raskin · P1 · five elements, definitions, CEO ownership, Uberflip example.
10. andyraskin.com — Andy Raskin · https://www.andyraskin.com/ · P1 · "company story is the company strategy"; start with the Promised Land rather than the product.
11. Crossing the Chasm — Wikipedia · https://en.wikipedia.org/wiki/Crossing_the_Chasm · P2 · adoption segments, chasm definition, three dependencies quote.
12. Whole product — Wikipedia · https://en.wikipedia.org/wiki/Whole_product · P2 · McKenna definition; intangible complements.
13. Positioning statement — TechTarget · https://www.techtarget.com/whatis/definition/positioning-statement · P2 · Moore template verbatim, six components, Avis example.
14. 3 Reasons You Should Be Roadmapping — Brennan Dunn, Double Your Freelancing · https://doubleyourfreelancing.com/3-reasons-roadmapping/ · P2 · roadmapping definition, $297 case, 3–4 h/lead, 25% close, risk/elasticity claim.
15. Get started with Paid Discovery at your agency — Karl Sakas · https://sakasandcompany.com/start-using-paid-discovery/ · P2 · price bands, 5–10% rule, credit deadlines 2–6 weeks, deliverable formats, "polite battle for control".
16. How to Productize Agency Services — Haus Advisors · https://www.hausadvisors.com/blog/productize-agency-services · P3 · $5K/$15K/$50K+ ladder, ≥6 deliveries, 80/20.
17. The Fatal Flaw in Your B2B ICP (Anti-ICP) — The B2B Playbook · https://theb2bplaybook.com/b2b-ideal-customer-profile-anti-icp · P2 · anti-ICP definition, attribute classes, derivation from churn/ACV/cycle/NPS and internal interviews.
18. In search for your Ideal Customer Profile — Maja Voje, GTM Strategist · https://knowledge.gtmstrategist.com/p/in-search-for-your-ideal-customer · P2 · ICP as early-majority target; 5 beachhead criteria; rank existing clients by ARR + other factors; "Do > Tell".
19. Marketing Messaging Templates — Aha! · https://www.aha.io/roadmapping/guide/marketing-templates/messaging-templates · P2 · value statement → pillars → proof points; audience; use cases; positioning informs messaging.
20. Summary: April Dunford on product positioning — Lenny's Newsletter · https://www.lennysnewsletter.com/p/summary-april-dunford-on-product · P2 · best-fit customers, sales-floor testing, "takes a week", ~40% no-decision, pre-PMF caveat.
21. How We Used April Dunford's 10-Step Method — Userlist · https://userlist.com/blog/positioning-overhaul/ · P2 · all ten steps applied; four alternative clusters; three value themes; big-fish-small-pond; trend layering; canvas as reference doc; repositioning cycles.
22. April Dunford's Positioning Framework / Canvas — kathirvel.com · https://www.kathirvel.com/guide-april-dunford-positioning-framework/ · P2 · six canvas fields incl. value-and-proof and relevant trends; three category styles.
23. Sales Pitch: Book Summary — Antoine Buteau · https://www.antoinebuteau.com/sales-pitch-book-summary/ · P2 · eight-step pitch (setup/follow-through); 40–60% no-decision.
24. Positioning (topic hub) — First Round Review · https://review.firstround.com/articles/positioning/ · P2 · Kramer "don't ship your pitch deck to your website"; Cacioppo 75% prediction test; Rachleff/Song quotes.
25. The Four Forces of Progress — jobstobedone.org (Moesta/Spiek) · https://jobstobedone.org/the-four-forces/ · P1 · push/pull/anxiety/habit definitions; switch rule; forces heard in interviews.
26. Marketing Success Through Differentiation—of Anything — Theodore Levitt, HBR 1980 · https://hbr.org/1980/01/marketing-success-through-differentiation-of-anything · P1 partial · "no such thing as a commodity".
27. Terms of Payment for B2B Procurement — Shoppable.ph · https://shoppable.ph/terms-of-payment-for-b2b-procurement/ · P2 PH · net terms, check/bank deposit, ₱2M and e-wallet caps.
28. Philippines – Trade Financing — US ITA Country Commercial Guide · https://www.trade.gov/country-commercial-guides/philippines-trade-financing · P1 PH · L/C for first-time, D/A 30–60 d, O/A 30–180 d, trust ladder.
29. Philippines – Selling Factors and Techniques — US ITA CCG · https://www.trade.gov/country-commercial-guides/philippines-selling-factors-and-techniques · P1 PH · after-sales expectation, 72% online, markups.
30. Philippines – Market Entry Strategy — US ITA CCG · https://www.trade.gov/country-commercial-guides/philippines-market-entry-strategy · P1 PH · agents/distributors essential; local partner for government; patience.
31. Philippines – Selling to the Public Sector — US ITA CCG · https://www.trade.gov/country-commercial-guides/philippines-selling-public-sector · P1 PH · RA 9184, PhilGEPS Platinum, 60% ownership, LCRB, retention 1–5%, life-cycle cost ignored, scams.
32. Philippines Country Commercial Guide (index) — US ITA · https://www.trade.gov/philippines-country-commercial-guide · P1 PH · section map (business-travel page returned no body text).
33. Items Subject to Expanded Withholding Tax under TRAIN — Tax and Accounting Center PH · https://taxacctgcenter.ph/items-subject-expanded-withholding-tax-train-ra-10963-philippines/ · P2 PH · EWT rates/thresholds, TWA 1%/2%, BIR 2307 timing, sworn declaration.
34. Understanding Competitive Bidding under RA 12009 — GPPB-TSO · https://www.gppb.gov.ph/understanding-competitive-bidding-under-ra-12009/ · P1 PH · default mode, seven phases, LCRB vs MEARB, HRRB for consulting.
35. Advisory on Submission of PhilGEPS Certificate of Registration — PS-PhilGEPS · https://ps-philgeps.gov.ph/home/index.php/about-ps/news/250-advisory-on-submission-of-philgeps-certificate-of-registration-to-procuring-entities · P1 PH · Platinum ₱5,000; modes requiring certificate; receipt ≠ certificate.
36. Philippines Guide (business culture) — Commisceo Global · https://www.commisceo-global.com/resources/country-guides/philippines-guide · P3 PH · relationships, face-to-face, hierarchy, hiya, slow negotiations.
37. Understanding Money-Back Guarantees: Cognitive, Affective, and Behavioral Outcomes — Suwelack, Hogreve & Hoyer, Journal of Retailing 2011, DOI 10.1016/j.jretai.2011.09.002 (Crossref metadata) · https://api.crossref.org/works?query.bibliographic=Understanding+Money-Back+Guarantees+Cognitive+Affective+and+Behavioral+Outcomes · P1 metadata only · existence/venue verified; effect sizes UNVERIFIED (abstract not retrievable; ResearchGate/Springer blocked).
38. The Dynamic Effects of Bundling as a Product Strategy — Derdenger & Kumar, Marketing Science 2013, DOI 10.1287/mksc.2013.0810 (Crossref abstract) · https://api.crossref.org/works?query.bibliographic=The+Dynamic+Effects+of+Bundling+as+a+Product+Strategy+Derdenger+Kumar · P1 · "mixed bundling dominates pure bundling and pure components".
39. Choice Based on Reasons: The Case of Attraction and Compromise Effects — Simonson, Journal of Consumer Research 1989, DOI 10.1086/209205 (Crossref metadata) · https://api.crossref.org/works?query.bibliographic=Simonson+Choice+Based+on+Reasons+The+Case+of+Attraction+and+Compromise+Effects · P1 metadata · academic basis for the middle-option (compromise) effect behind G-B-B.

Fetch failures (not used for any claim): Raskin's Medium article (403), the.gt Moore page (refused), joelhooks.com discovery page (404), BrightSight G-B-B summary (socket), ResearchGate and Springer guarantee papers (403/redirect), Forbes/HBS Working Knowledge bundling article (403/404), Hofstede PH page (empty), abinoda.com messaging template (DNS), Semantic Scholar API (429).
