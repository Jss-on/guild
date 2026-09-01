# Marketing — research brief (2026-09-02)

Scope: early-stage B2B (software + hardware engineering studio) with some B2C hardware retail; Philippines. All sources retrieved 2026-09-02. Provenance grades: P1 = primary/originator/regulator/statute text; P2 = secondary benchmark or law-firm/industry report; P3 = tertiary (encyclopedic summary). Anything not fetched in this pass is marked UNVERIFIED. Bracketed numbers refer to §8. Benchmark dollars are US-agency datasets and are ceilings/sanity checks, not PH targets.

## 1. Standard process — ordered steps and named deliverable

Precondition (from upstream harness stages): validated ICP + problem, positioning inputs, offer, price. Marketing must not start assets without these; the asset lint in §5 blocks it.

| # | Step | Deliverable (file the harness reads) | Source |
|---|------|---------------------------------------|--------|
| 1 | Segment → Target → Position (STP). Evaluate candidate segments on measurability, accessibility, sustainability (profit justifies effort), actionability; pick 1 primary segment; write positioning statement | `positioning.md` (segment table with 4 criteria scored; one positioning statement; category chosen) | [37] |
| 2 | Marketing mix: 4Ps (product, price, place, promotion) + 7Ps extension (people, process, physical evidence) for service-heavy offers | `mix.md` (one decision per P; "place" names the actual channels, e.g. direct sales, Shopee/TikTok Shop for hardware) | [36] |
| 3 | Messaging from positioning: value proposition, 3 pillars, proof points, objections; every claim tagged with substantiation | `messaging.md` + `claims.csv` (claim, type, evidence_ref, evidence_date) | [16], [20] |
| 4 | Budget split brand vs activation; set share-of-voice intent | `budget.csv` (channel, brand/activation flag, cap_php, period) | [27], [28] |
| 5 | Channel selection: ≤3 channels with a written hypothesis each; reach checked against PH platform data | `channel-plan.csv` | [1] |
| 6 | Asset build against checklist (§5): landing page (one goal), one-pager, deck, case study (10 parts + release form), pricing page, email sequences | `assets.csv` registry + files | [31], [32] |
| 7 | Content/SEO plan: 3–5 pillar candidates, each supporting 20–30 cluster articles; year-1 realistically 1–2 pillars fully built | `content-calendar.csv` | [30] |
| 8 | Instrumentation: UTM taxonomy, conversion events, CRM stage definitions (lead/MQL/SQL/opp), attribution model chosen (Google now supports only data-driven and last-click) | `tracking.md` | [33] |
| 9 | Growth-experiment loop: hypothesis → metric → threshold → sample size/duration → verdict; ICE/RICE prioritization | `experiments.csv` | [4], [11], [12], [13], [14], [15] |
| 10 | Outreach/launch with human gates: consent ledger, send log, spend log | `consent.csv`, `send-log.csv`, `spend.csv` | [21], [22], [34] |
| 11 | Weekly metrics review vs benchmarks: CPL, CAC by channel, stage conversion | `metrics.csv` | [9], [10] |
| 12 | Compliance review before every publish: ASC claim rules, RA 7394 Arts 110/115/116, DPA consent, ITA merchant disclosures | `compliance-check.csv` (asset_id, rule_id, PASS/FAIL, reviewer) | [16], [20], [21], [23] |

Order note (Ellis): invest in activation/onboarding → engagement → referral → revenue model → acquisition, in that order; paid acquisition before activation works is the classic waste [12].

## 2. Frameworks & methods

| Framework | Originator | Produces | Use when | Known critiques |
|-----------|-----------|----------|----------|-----------------|
| STP (segmenting–targeting–positioning) | Attributed to Kotler in refs [37]; Smith 1956 / Ries & Trout originators UNVERIFIED in this pass | Segment shortlist scored on measurability, accessibility, sustainability, actionability; positioning statement | Before any asset | Analytic vs discovery approach: discovery (observation) suits small customer bases [37] |
| 4Ps | E. Jerome McCarthy 1960, popularized by Kotler [36] | One decision per P; price is "the only revenue-generating variable" | Offer definition | Rafiq & Ahmed: services do not need a more complex mix; argue for a generic mix [36] |
| 7Ps | Booms & Bitner 1981 [36] | Adds people, process, physical evidence | Service/engineering-studio offers | Same as above |
| 4Cs | Lauterborn 1990 [36] | Customer-side restatement (wants, cost, convenience, communication) | Messaging sanity check | — |
| 5 Principles of B2B growth | Binet & Field, LinkedIn B2B Institute, IPA Databank 1998–2018 B2B cases [27] | SOV > SOM to grow; roughly 50/50 brand:activation; acquisition beats loyalty; maximise mental availability; emotion long-term, rational short-term | Budget split, brand vs demand-gen decision | Authors: "sample sizes are small, the case studies are skewed towards the UK & tend to have big budgets" [29]; IPA notes most B2B marketers do the opposite [28]. The 46:54 split cited in secondary summaries is UNVERIFIED against the primary page, which says "50/50" [27] |
| 95-5 rule (≈95% of category buyers not in-market at any time) | Dawes / Ehrenberg-Bass via B2B Institute — page not retrieved, UNVERIFIED | Justifies always-on brand presence | — | — |
| Topic clusters / pillar pages | HubSpot; research "Topics Over Keywords" by Hussain & Davies 2015 [30] | Pillar + 20–30 cluster articles; 3 linking rules | Content/SEO plan | Internal-link finding is HubSpot's own 2015 study; no external replication cited [30] |
| Landing page anatomy (USP, hero, benefits, social proof, single CTA) | Unbounce [32] | Lintable page structure; "one conversion goal—or else it ain't a landing page" | Every landing page | Vendor-published |
| Growth process / high-tempo testing; PMF survey | Sean Ellis [12] | Idea → ICE score → test → learn; ≥40% "very disappointed" = PMF signal | Experiment loop | ICE subjectivity [15] |
| Hypothesis-driven experiments | Brian Balfour [11] | Written, quantifiable hypotheses; team-wide experiment docs; learnings "captured and pushed across the team in a repeatable and systematic way" | Experiment loop | Balfour's public essay gives no template or tempo; templates are in paid Reforge content [11] |
| ICE (Impact × Confidence × Ease, 1–10 each) | Sean Ellis, Hacking Growth 2017 [12], [15] | Ranked experiment backlog | Fast prioritization | "Is it a 6 or an 8?" subjectivity; confidence gaming — ask "how much evidence do you have?"; over-weighting Ease kills big ideas [15] |
| RICE (Reach × Impact × Confidence ÷ Effort) | Sean McBride, Intercom, 5 Jan 2018 [4] | Impact scale 3/2/1/0.5/0.25; Confidence 100/80/50%; Effort in person-months | When reach differs a lot between ideas | "RICE scores shouldn't be used as a hard and fast rule" [4] |
| Fixed-horizon sample size; no peeking | Evan Miller [13], [14] | n per arm from baseline, MDE, power, α; n ≈ 16σ²/δ² | Every quantitative experiment | Sequential/Bayesian designs if early stopping is needed [14] |
| Attribution models | Google Ads [33] | Data-driven (default) or last click; first-click, linear, time-decay, position-based "no longer supported by Google" | Tracking setup | Model choice is a judgment; not mechanizable |
| Social Selling Index (0–100) | LinkedIn [26] | Score on: establish a professional brand, find the right prospects, engage with key insights, build relationships | Founder-led LinkedIn selling | Page now pushes Sales Navigator AI metrics; "25 points per pillar" UNVERIFIED |
| Case study structure (10 components) | HubSpot [31] | Title, subtitle, exec summary, about, challenges, solution, results (numbers), quotes/visuals, future, CTA; 500–1,500 words; release form | Proof asset | — |
| Cold-email sequencing | Woodpecker data [35] | 4–7 touches; follow-ups drive 42% of replies | Outbound | Vendor data |

## 3. Numbers annex

| Metric | Benchmark / threshold | Context (channel / geo / date) | Source URL | Grade | Retrieved |
|---|---|---|---|---|---|
| Landing page median CVR, all industries | 6.6% | Unbounce CBR 2024; 41k+ pages, 464M+ visitors, 57M+ conversions; global | https://unbounce.com/conversion-benchmark-report/ | P2 | 2026-09-02 |
| Landing page CVR by traffic channel (all industries, avg) | Email 19.3%; paid social 12%; paid search 10.9%; Google search 11.3%; Facebook 13% | Same | same | P2 | 2026-09-02 |
| SaaS landing page median CVR | 3.8%; hardware sub-industry 4.1%; data & infrastructure 3.3% | Unbounce CBR 2024 SaaS page | https://unbounce.com/conversion-benchmark-report/saas-conversion-rate/ | P2 | 2026-09-02 |
| SaaS LP CVR by channel | Email 16.9%; Google paid 5.1%; Instagram 9.2%; Facebook 3.5%; display 0.3% | Same | same | P2 | 2026-09-02 |
| Copy reading level | Grade 5–7 copy converts 11.1% vs 5.3% professional-level | Unbounce CBR 2024 | https://unbounce.com/conversion-benchmark-report/ | P2 | 2026-09-02 |
| Device | 83% of visits mobile; desktop converts 8% better | Unbounce CBR 2024 | same | P2 | 2026-09-02 |
| Email open / click / unsubscribe (all industries) | 35.63% / 2.62% / 0.22% | Mailchimp, data Dec 2023, campaigns ≥1,000 subs; opens inflated by Apple MPP | https://www.mailchimp.com/resources/email-marketing-benchmarks/ | P2 | 2026-09-02 |
| Email, Business & Finance | 31.35% / 2.78% / 0.15% | Same | same | P2 | 2026-09-02 |
| Email, Ecommerce | 29.81% / 1.74% / 0.19% | Same | same | P2 | 2026-09-02 |
| Cold email reply rate | Avg 3.43%; good 5–10%; excellent 10%+ | Woodpecker, 20M+ emails, updated 23 Jun 2026 | https://woodpecker.co/blog/cold-email-statistics/ | P2 | 2026-09-02 |
| Follow-up effect | 3–5 follow-ups 8.3% vs 4.1% without; 42% of replies from follow-ups; 48% of reps never follow up | Same | same | P2 | 2026-09-02 |
| Campaign size effect | <50 recipients 5.8% reply; 1,000+ contacts 2.1% | Same | same | P2 | 2026-09-02 |
| Bounce rate | Avg 5.1%; good <2%; excellent <1.5% | Same | same | P2 | 2026-09-02 |
| Gmail bulk-sender spam rate | Keep <0.10%; never reach 0.30%; SPF+DKIM+DMARC; one-click unsubscribe (RFC 8058) | Google, effective 1 Feb 2024, senders ≥5,000/day to Gmail | https://support.google.com/mail/answer/81126 | P1 | 2026-09-02 |
| Google Ads search, all industries | CPC $5.42; CTR 6.64%; CVR 8.18%; CPL $66.69 | LocaliQ/WordStream "2026 data", updated 1 Jun 2026; customer accounts (US-centric) | https://localiq.com/blog/search-advertising-benchmarks/ | P2 | 2026-09-02 |
| Google Ads search, B2B/Business Services | CPC $5.87; CTR 6.10%; CVR 4.85%; CPL $93.69 | Same | same | P2 | 2026-09-02 |
| Google Ads search, Industrial & Commercial | CPC $5.87; CTR 6.57%; CVR 8.20%; CPL $75.19 | Same | same | P2 | 2026-09-02 |
| Meta lead campaigns, all industries | CTR 2.59%; CPC $1.92; CVR 7.72%; CPL $27.66 | LocaliQ/WordStream 2025, updated 24 Oct 2025 | https://localiq.com/blog/facebook-advertising-benchmarks/ | P2 | 2026-09-02 |
| Meta lead campaigns, Industrial & Commercial | CPC $1.80; CTR 2.08%; CVR 9.34%; CPL $37.34 | Same | same | P2 | 2026-09-02 |
| Meta traffic campaigns | CTR 1.71%; CPC $0.70 | Same | same | P2 | 2026-09-02 |
| LinkedIn Ads CTR / CPC | Q1 0.82% / $10.48; Q3 0.96% / $15.72; Sept CTR 1.05% | HockeyStack, 15 Dec 2025; 70+ B2B SaaS cos, $28M spend, 2023–2025; no APAC cut | https://www.hockeystack.com/lab-blog-posts/linkedin-ads-benchmarks | P2 | 2026-09-02 |
| B2B CAC by channel | Email $510; public speaking $518; webinars $603; thought-leadership SEO $647; social $658; PPC $802; direct mail $864; LinkedIn Ads $982; content $1,254; PR $1,720; basic SEO $1,786; ABM $4,664; organic avg $942; inorganic avg $1,907 | First Page Sage, ~120 agency clients 2022–2024, 3-yr avg incl. 4–6 month learning period; updated 18 Jun 2025 | https://firstpagesage.com/marketing/cac-by-channel-fc/ | P2 | 2026-09-02 |
| B2C CAC by channel | Social $212; Facebook Ads $230; email $287; TL SEO $298; organic avg $480; inorganic avg $319 | Same (skewed to higher-value products) | same | P2 | 2026-09-02 |
| Visitor → lead by channel (B2B SaaS) | SEO 2.1%; PPC 0.7%; LinkedIn 2.2%; email 1.3%; webinar 0.9% | First Page Sage, 50+ clients, updated 11 Jun 2025 | https://firstpagesage.com/seo-blog/b2b-saas-funnel-conversion-benchmarks/ | P2 | 2026-09-02 |
| Lead → MQL | 36–44% by channel | Same | same | P2 | 2026-09-02 |
| MQL → SQL | SEO 51%; email 46%; webinar 39%; LinkedIn 30%; PPC 26% | Same | same | P2 | 2026-09-02 |
| SQL → opportunity | 38–49% | Same | same | P2 | 2026-09-02 |
| Opportunity → close | 32–40% (email 32%, webinar 40%) | Same | same | P2 | 2026-09-02 |
| PMF survey threshold | ≥40% "very disappointed" if product went away | Sean Ellis, interview 5 Sep 2024 | https://www.lennysnewsletter.com/p/the-original-growth-hacker-sean-ellis | P1 | 2026-09-02 |
| Sample size example | Baseline 10.2%, MDE to 13.2%, 80% power, α=5% → 2,545 per variation | Evan Miller calculator | https://www.evanmiller.org/ab-testing/sample-size.html | P1 | 2026-09-02 |
| Peeking penalty | Nominal 5% significance with continuous checking → 26.1% actual false-positive rate | Evan Miller, 18 Apr 2010 | https://www.evanmiller.org/how-not-to-run-an-ab-test.html | P1 | 2026-09-02 |
| Content cluster size | 20–30 supporting articles per pillar; start with 3–5 pillar candidates | HubSpot, updated 17 Jun 2026 | https://blog.hubspot.com/marketing/topic-clusters-seo | P2 | 2026-09-02 |
| Case study length | 500–1,500 words; 10 components; release form required | HubSpot, updated 1 Aug 2024 | https://blog.hubspot.com/blog/tabid/6307/bid/33282/the-ultimate-guide-to-creating-compelling-case-studies.aspx | P2 | 2026-09-02 |
| Brand vs activation | SOV > SOM correlates with growth; "50/50 split" brand:activation | LinkedIn B2B Institute (Binet & Field), IPA Databank 1998–2018 | https://business.linkedin.com/marketing-solutions/b2b-institute/marketing-as-growth | P1 | 2026-09-02 |

## 4. Philippine specifics

Channel landscape (DataReportal Digital 2025: Philippines, published 25 Feb 2025, data Jan 2025; platform figures from each platform's ad tools) [1]:

| Stat | Value |
|---|---|
| Population | 116 million; median age 26.1; 48.8% urban |
| Internet users | 97.5M (83.8% penetration); 18.8M offline |
| Cellular connections | 142M (122% of population); 98.2% broadband |
| Social media identities | 90.8M (78.0% of population; 116.6% of adults 18+) |
| Facebook ad reach | 90.8M = 93.1% of internet users |
| Messenger ad reach | 61.8M (53.1% of population) |
| TikTok ad reach (18+) | 62.3M = 80.1% of adults; +27.0% YoY |
| YouTube ad reach | 57.7M (49.6% of population); −0.7% YoY |
| Instagram ad reach | 22.9M (19.6%) |
| LinkedIn members | 19.0M (16.3% of population; 24.4% of adults); +18.8% YoY |
| X | 9.29M; −13.7% YoY |
| Median mobile download | 35.56 Mbps |

- Viber (company-reported, Philstar 19 Feb 2025, covering ~2024): PH among Viber's top-5 countries of 190; monthly active users +21%; business accounts +14%; business messages delivered +53%; 862M average monthly ad impressions; 17% more users joined channels/communities [25]. DataReportal publishes no Viber ad-reach figure [1].
- Hardware retail marketplaces (Cube.asia Tradewinds dataset, physical goods) [24]: combined Shopee + Lazada + TikTok Shop GMV USD 22B FY2025 (+15% from USD 19B). Shopee USD 12B (55% share, +25%, 399M orders); TikTok Shop USD 6B (29%, +53%); Lazada USD 3B (16%, −34%). AOV: Shopee PHP 316, Lazada PHP 416, TikTok Shop PHP 198. Shopee category mix: electronics/appliances 24%.

Rules with citations:

- Consumer Act RA 7394 (approved 13 Apr 1992) [20]. Art 50: deceptive when a seller represents a product has "sponsorship, approval, performance, characteristics, ingredients, accessories, uses, or benefits it does not have", is of a standard/quality it is not, is new when reconditioned, has a price advantage that does not exist, or misstates warranty. Art 108: State protects consumers "from misleading advertisements and fraudulent sales promotion practices". Art 110: unlawful to disseminate false, deceptive or misleading advertising in any medium; misleading "if it is misleading in a material respect", taking into account "the extent to which the advertisement fails to reveal material facts". Art 112: special requirements for food, drug, cosmetic, device (FDA-sense) or hazardous substance — no claim not on the approved label; a 30-day opinion mechanism. Art 115: special claims must be substantiated and "properly use research result, scientific terms, statistics or quotations". Art 116: sales promotion campaigns "national in character" need a permit from the concerned department "at least thirty (30) calendar days prior to the commencement"; deemed approved if no objection within 15 days of filing. Art 117: department may suspend promo publication after notice and hearing. Art 123: Arts 110–115 violations P500–P5,000 and/or 1–6 months; Arts 116–121 P200–P600 and/or 1–6 months. Art 60 (Title III Ch. I): P500–P10,000 and/or 5 months–1 year. DTI promo-permit procedure/fees (DAO): UNVERIFIED (dti.gov.ph page not retrieved).
- Ad Standards Council (self-regulatory; code first released 17 Mar 2008) [16]–[19]. Applies to "all advertising and other marketing communication, including Digital marketing" and "everyone concerned in the practice of marketing communication" [18]. Claim rules [16]: superiority / "Most Preferred" / "Most Recommended" → independent third-party quantitative research; No. 1 / leadership → "at least the immediately preceding 12-month cumulative data, both volume and monetary value, from an independent source"; exclusivity and comparative → independent third-party data; substantiation valid one year ("Should the Advertiser/Ad Agency decide to continue to use the claim after a year, an updated data must be submitted"); scientific/technical claims "presented fairly and in their correct context". Coverage [17]: digital includes "SMS, MMS, e-blast, opt in/opt out, digital video, static ads, ads in corporate websites" ("corporate websites, per se, are not included"); OOH pre-screening "mandatory prior to production"; digital/print default post-screening unless mandatory categories or regulated claims; claims needing technical substantiation, "especially ads ... that deal with technology and health", go to a 3-Man Screening Panel [19].
- Internet Transactions Act RA 11967 [23]: full effect 20 Jun 2025. Online merchants must submit corporate/trade names, business address, contact details (and professional accreditation if applicable) to DTI's E-Commerce Bureau and publish them on their website; listings must carry "accurate descriptions, prices, and conditions" and "promotional images or product samples ... consistent with what is delivered"; transactions "supported by electronic or paper receipts". DTI may issue takedown orders and blacklist sites/accounts; fines P5,000–P1,000,000.
- Data Privacy Act RA 10173 (approved 15 Aug 2012) [21]: consent = "freely given, specific, informed indication of will" (Sec 3(b)), evidenced in written, electronic or recorded form. Sec 11 principles: transparency, legitimate purpose, proportionality. Sec 12 lawful bases: consent; contract; legal obligation; vital interests; public safety/emergency; legitimate interests unless overridden by fundamental rights. Sec 16 rights include being informed, access, dispute/correct, block/remove/destroy, indemnification. Penalties: Sec 25 unauthorized processing 1–3 years + P500k–P2M (sensitive: 3–6 years + P500k–P4M); Sec 33 combination 3–6 years + P1M–P5M.
- NPC Advisory Opinion No. 2017-42 (14 Aug 2017), as reported by SyCipLaw [22]: a privacy notice stating that "continued use of the products and services ... will be deemed as consent" for direct marketing is "implied or inferred consent" and "not sufficient"; all three elements (freely given, specific, informed) were absent; NPC relied on GDPR Recital 32 ("Silence, pre-ticked boxes or inactivity should not therefore constitute consent"). Takeaways: an affirmative act (clickable agreement), a notice stating purposes/retention, and a separate mechanism for data sharing and automated decisions. Practical rule for the harness: marketing email/SMS/Viber requires an opt-in record per contact; no pre-ticked boxes; unsubscribe honored. Whether "legitimate interests" can carry B2B email to business contacts: NPC guidance not retrieved — UNVERIFIED; default to consent.
- Standalone anti-spam statute: none located; the Cybercrime Act's unsolicited-commercial-communications clause was reportedly struck down in 2014 — UNVERIFIED (search snippet only).
- Gmail bulk-sender rules apply to any PH sender reaching Gmail inboxes [34].

## 5. Mechanical gate candidates

Ledgers the harness scripts read (CSV, one row per record):

`experiments.csv`: id · opened · owner · funnel_stage · channel · hypothesis (must match "If we [change] for [ICP], [metric] moves from [baseline] to [target] because [assumption]") · primary_metric · baseline · target_threshold · mde_rel · alpha · power · required_n_per_arm · min_duration_days · ice_impact · ice_confidence · ice_evidence_ref · ice_ease · rice_reach · rice_effort_pm · budget_php · approved_by · status · actual_n · elapsed_days · observed · ci_or_p · verdict (WIN/LOSE/INCONCLUSIVE) · learning · next_action.

Gate rules (all scriptable):
- Hypothesis lint: five fields present, baseline and target numeric, metric ∈ metrics dictionary.
- Sample-size gate: `required_n_per_arm` computed from baseline/MDE/power/α [13]; `verdict` may be WIN/LOSE only if `actual_n ≥ required_n` AND `elapsed_days ≥ min_duration_days` (≥7 days, one business cycle); otherwise forced INCONCLUSIVE [14].
- Confidence gate: `ice_confidence > 5` requires non-empty `ice_evidence_ref` [15].
- Budget gate: `budget_php ≤ cap` and `approved_by` non-empty before status=running (spend is human-gated).
- Tempo gate: ≥1 experiment reaching verdict per week once channels are live (Ellis high-tempo — threshold is a harness choice, practitioner consensus).

`calendar.csv`: date · week · asset_id · channel · format · pillar · cluster · icp_id · funnel_stage · cta · owner · status (draft/review/approved/published) · approved_by · compliance_check · published_url · utm_campaign · cost_php. Gate: no `status=published` without `approved_by` and `compliance_check=PASS`; every `utm_campaign` matches the taxonomy regex; cadence floor per channel per week.

`assets.csv`: asset_id · type (landing/one-pager/deck/case-study/pricing/email-seq/listing) · version · path · icp_id · offer_id · price_ref · cta_count · claims_ref · placeholder_count · reading_grade · lint_status · last_reviewed.

Asset lint rules (regex/structural, run on every version):
- Placeholders: FAIL on `\[TBD\]|lorem|XX%|\{\{|INSERT|TODO|\?\?\?`.
- ICP/offer/price/CTA: FAIL if `icp_id` not in `icp.yaml`; FAIL if offer or price reference missing (B2B "pricing on request" allowed only with explicit flag); landing page FAIL if `cta_count ≠ 1` [32]; pricing page must contain currency, unit, inclusions, VAT note.
- Unsourced numbers: every `\d+(\.\d+)?\s?%|\d+x|PHP\s?\d` in copy must carry an `[ev:id]` token that resolves in `claims.csv` with an `evidence_date`.
- Superlatives: `best|#1|No\. ?1|most (preferred|recommended)|only|fastest|leading|guaranteed` → FAIL unless the claim row has independent third-party evidence dated ≤12 months [16]; comparative wording (`vs|than`) must name the comparator [16].
- Case study: 10 components present; `release_form_on_file=true` [31].
- Landing page: USP headline, hero, benefits, social proof, single CTA present [32]; reading grade ≤7 WARN, ≥9 FAIL for B2C [2].
- Email templates: unsubscribe link + List-Unsubscribe headers + sender identity + `consent_source` field [34].
- Marketplace listing (hardware): merchant name/address/contact present; images tagged to the delivered SKU; receipt flow enabled [23].

Metric thresholds (`metrics.csv`, weekly rows per channel; sources in §3):
- Landing page CVR < 3.8% after ≥500 visitors → FIX flag; < 2% → STOP traffic to page [3].
- Email: click < 1.5% or unsubscribe > 0.5% on ≥1,000 sends → WARN; opens are not a gate (MPP) [5].
- Deliverability: spam complaints ≥0.10% → STOP sends until fixed; ≥0.30% → hard STOP + domain review [34]; bounce > 2% → list-hygiene gate [35].
- Cold email: reply < 3% after ≥200 sends with ≥3 follow-ups → kill or rewrite sequence [35]; sequences with < 3 follow-ups are rejected at plan time [35].
- Paid: CPL > 2× the channel's benchmark row for ≥3 consecutive weeks → PAUSE proposal (human executes) [6], [7]; CTR below channel benchmark for 2 weeks → creative refresh task.
- Funnel: MQL→SQL < 26% (worst-channel benchmark) → ICP/qualification review [10]; opportunity→close < 30% → offer/pricing review [10].
- Unit economics: channel CAC ≤ LTV/3 (practitioner consensus; LTV from pricing domain).
- Brand/activation: activation share > 70% of spend for a quarter → WARN against Binet & Field balance [27].

`consent.csv`: contact_id · source · timestamp · consent_text_version · purposes · channels (email/SMS/Viber) · evidence (form id/screenshot) · withdrawn_at. Gate: no send row without a live consent row or a documented lawful basis reviewed by a human; SMS/Viber require explicit opt-in [21], [22].

`spend.csv`: date · channel · campaign · amount_php · approved_by · cap_ref. Gate: cumulative ≤ approved cap; any row without `approved_by` fails the run.

What cannot be mechanized (human sign-off row required every time): publishing any page/post/ad; sending any email/SMS/Viber batch; releasing any spend; judging whether substantiation actually supports a claim; ASC screening submission and DTI promo permit filing; positioning and creative quality (lint gives a floor only); attribution model choice; deciding to kill a channel.

## 6. Early irreversibles

1. Brand name, domain, social handles, trademark check — every asset, ASC-cleared material, DTI/ITA merchant disclosure, and SEO history hangs on it (practitioner consensus).
2. Category / positioning frame — anchors messaging and the SEO pillar set; a change re-does 20–30 articles per pillar [30].
3. Primary ICP segment — channel CAC varies ~5× by channel and motion, and content built for one segment does not transfer [9].
4. Channel commitment — CAC figures already include a "4–6 month learning period" [9]; abandoning a channel early forfeits it.
5. Sending domain reputation — spam-rate history is not resettable; use a dedicated subdomain from day one [34].
6. Consent capture design — retroactive consent is impossible and "continued use = consent" is invalid [22]; the first form must be right.
7. Public superlative claims — once published they need one-year-fresh third-party substantiation for as long as they run [16].
8. Marketplace choice for hardware — ratings/reviews are non-transferable; Lazada's GMV fell 34% while TikTok Shop grew 53% [24].
9. UTM/attribution taxonomy — changing it breaks historical comparability (practitioner consensus); Google's model set is already reduced to two [33].
10. Pricing page publication — anchors prospects (pricing domain owns the number; marketing owns the page).

## 7. Failure modes / anti-patterns the harness must guard against

- Peeking / early stopping: reported 5% significance becomes 26.1% false positives under continuous checking [14]. Guard: forced INCONCLUSIVE until n and duration met.
- Confidence gaming in ICE ("scoring their own ideas highly") [15]. Guard: evidence_ref required.
- Over-weighting Ease kills big bets [15]. Guard: quarterly review of the top-Impact-but-low-Ease backlog.
- Unsubstantiated superlatives → ASC disapproval [16]; RA 7394 Art 110/115 liability [20]. Guard: superlative lint.
- Implied consent ("continued use") for marketing → DPA breach [22], penalties [21]. Guard: consent ledger.
- Sending without one-click unsubscribe or above 0.30% spam rate → Gmail blocks [34].
- Volume blasting: 1,000+ contact campaigns reply at 2.1% vs 5.8% for <50; 48% of reps never follow up [35]. Guard: batch size cap and follow-up minimum.
- All-activation budgets and SOV below SOM; loyalty-only strategies — Binet & Field find the opposite works, and IPA notes most B2B marketers do the opposite [27], [28].
- Multiple CTAs on a landing page [32]; professional-grade copy halves conversion vs grade 5–7 [2].
- Treating US CPL/CAC benchmarks as PH targets — all paid/CAC datasets here are US-agency samples [6], [7], [9]; use as ceilings only.
- Disconnected posts instead of clusters [30].
- Publishing a case study without a release form [31].
- Running a national promo without a DTI permit filed ≥30 days prior [20].
- Marketplace images not matching delivered goods; missing merchant disclosures/receipts → ITA takedown/blacklist/fines [23].
- Open rate as a KPI after Apple MPP [5].
- Paid acquisition before activation/retention works (Ellis order) [12].
- Deprecated multi-touch models or last-click-only reasoning about brand channels [33] (practitioner consensus on the bias).
- MQL inflation / vanity metrics — practitioner consensus; guard with MQL→SQL floor [10].

## 8. Sources

1. Digital 2025: The Philippines — DataReportal · https://datareportal.com/reports/digital-2025-philippines · P1 report (platform ad-tool data) · population, internet, social, per-platform reach.
2. Conversion Benchmark Report 2024 — Unbounce · https://unbounce.com/conversion-benchmark-report/ · P2 · median CVR, channel/device/readability findings.
3. CBR SaaS conversion rate — Unbounce · https://unbounce.com/conversion-benchmark-report/saas-conversion-rate/ · P2 · SaaS/hardware CVR by channel.
4. RICE: Simple prioritization for product managers — Intercom (Sean McBride, 2018) · https://www.intercom.com/blog/rice-simple-prioritization-for-product-managers/ · P1 originator · RICE scales, formula, caveat.
5. Email Marketing Benchmarks — Mailchimp (Dec 2023 data) · https://www.mailchimp.com/resources/email-marketing-benchmarks/ · P2 · open/click/unsub by industry, MPP caveat.
6. Search Advertising Benchmarks (2026 data) — LocaliQ/WordStream · https://localiq.com/blog/search-advertising-benchmarks/ · P2 · Google Ads CPC/CTR/CVR/CPL.
7. Facebook Advertising Benchmarks 2025 — LocaliQ/WordStream · https://localiq.com/blog/facebook-advertising-benchmarks/ · P2 · Meta lead/traffic benchmarks.
8. 2025 LinkedIn Ads Benchmark Report — HockeyStack Labs · https://www.hockeystack.com/lab-blog-posts/linkedin-ads-benchmarks · P2 · CTR/CPC by quarter, sample.
9. CAC by Channel — First Page Sage · https://firstpagesage.com/marketing/cac-by-channel-fc/ · P2 · B2B/B2C CAC per channel, methodology.
10. B2B SaaS Funnel Conversion Benchmarks — First Page Sage · https://firstpagesage.com/seo-blog/b2b-saas-funnel-conversion-benchmarks/ · P2 · stage conversion by channel.
11. Maximize Learning — Brian Balfour · https://brianbalfour.com/growth-machine/maximize-learning · P1 · hypothesis-driven loop, learning capture.
12. The original growth hacker reveals his secrets — Lenny's Newsletter with Sean Ellis (2024) · https://www.lennysnewsletter.com/p/the-original-growth-hacker-sean-ellis · P1 interview · PMF 40%, ICE, investment order, north-star.
13. Sample Size Calculator — Evan Miller · https://www.evanmiller.org/ab-testing/sample-size.html · P1 · inputs, worked example.
14. How Not To Run an A/B Test — Evan Miller (2010) · https://www.evanmiller.org/how-not-to-run-an-ab-test.html · P1 · peeking inflation, fixed n, n=16σ²/δ².
15. ICE Framework: how (not) to score — Ward van Gasteren · https://growwithward.com/ice-prioritization-framework · P2 · ICE origin, scoring, critiques.
16. Advertising Claims — Ad Standards Council · https://asc.com.ph/our-standards/code-of-ethics/advertising-claims/ · P1 · claim types, substantiation, 12-month rule.
17. Materials covered by the ASC Code — Ad Standards Council · https://asc.com.ph/our-standards/manual-of-procedures/general-rules/materials-covered-by-the-asc-code-of-ethics-and-manual-of-procedures/ · P1 · digital coverage, pre- vs post-screening.
18. Code of Ethics overview — Ad Standards Council · https://asc.com.ph/our-standards/code-of-ethics/ · P1 · scope ("including Digital marketing"), 2008 release.
19. Screening — Ad Standards Council · https://asc.com.ph/our-standards/manual-of-procedures/screening-procedures/screening/ · P1 · 3-Man Screening Panel for technical claims, fees exist.
20. RA 7394 Consumer Act of the Philippines — LawPhil · https://lawphil.net/statutes/repacts/ra1992/ra_7394_1992.html · P1 statute · Arts 50, 60, 108, 110, 112, 115, 116, 117, 123 (raw HTML fetched and grepped).
21. RA 10173 Data Privacy Act of 2012 — LawPhil · https://lawphil.net/statutes/repacts/ra2012/ra_10173_2012.html · P1 statute · consent definition, Secs 11, 12, 16, 25, 33.
22. Data Privacy Update: NPC Advisory Opinion on Consent (AO 2017-42) — SyCipLaw client alert PDF · https://www.legal500.com/developments/wp-content/uploads/sites/19/2018/05/NPC20Advisory20Opinion20on20Consent2020180306.pdf · P2 · implied consent rejected, takeaways.
23. Philippines' Internet Transactions Act now fully enforced — Cruz Marcelo · https://cruzmarcelo.com/philippines-internet-transactions-act-now-fully-enforced-what-online-businesses-must-do-to-comply/ · P2 · effectivity, merchant duties, penalties.
24. E-commerce in Philippines — Cube.asia · https://cube.asia/e-commerce-in-philippines/ · P2 · Shopee/Lazada/TikTok Shop GMV, AOV, categories.
25. Viber: Philippines among top 5 user countries — Philstar (19 Feb 2025) · https://www.philstar.com/lifestyle/gadgets/2025/02/19/2422495/viber-philippines-among-top-5-user-countries-more-business-features-roll-out · P2 · Viber PH growth stats (company-reported).
26. The Social Selling Index — LinkedIn Sales Solutions · https://business.linkedin.com/sales-solutions/social-selling/the-social-selling-index-ssi · P1 · SSI definition and four components.
27. The 5 Principles of Growth in B2B Marketing — LinkedIn B2B Institute (Binet & Field) · https://business.linkedin.com/marketing-solutions/b2b-institute/marketing-as-growth · P1 · five principles, IPA dataset, 50/50.
28. Five Principles of Growth in B2B Marketing — IPA · https://ipa.co.uk/effworks/marketing-marketing-v2/five-principles-of-growth-in-b2b-marketing · P2 · principle list, "doing the opposite".
29. Summary of the B2B Institute report — Alex Murrell · https://www.alexmurrell.co.uk/summaries/the-b2b-institute-the-5-principles-of-growth-in-b2b-marketing · P3 · authors' sample-size caveat.
30. Topic clusters: the next evolution of SEO — HubSpot · https://blog.hubspot.com/marketing/topic-clusters-seo · P2 · cluster size, linking rules, 2015 study.
31. The ultimate guide to creating compelling case studies — HubSpot · https://blog.hubspot.com/blog/tabid/6307/bid/33282/the-ultimate-guide-to-creating-compelling-case-studies.aspx · P2 · 10 components, length, release form.
32. The anatomy of a landing page — Unbounce · https://unbounce.com/landing-page-articles/the-anatomy-of-a-landing-page/ · P2 · five elements, single-goal rule.
33. About attribution models — Google Ads Help · https://support.google.com/google-ads/answer/6259715 · P1 · supported vs deprecated models.
34. Email sender guidelines — Google Workspace/Gmail Help · https://support.google.com/mail/answer/81126 · P1 · bulk-sender rules, spam-rate thresholds.
35. Cold email statistics — Woodpecker · https://woodpecker.co/blog/cold-email-statistics/ · P2 · reply/bounce/follow-up data.
36. Marketing mix — Wikipedia · https://en.wikipedia.org/wiki/Marketing_mix · P3 · 4Ps/7Ps/4Cs attribution and critique.
37. Segmenting–targeting–positioning — Wikipedia · https://en.wikipedia.org/wiki/Segmenting-targeting-positioning · P3 · STP steps and segment criteria.

Not retrieved (UNVERIFIED; do not cite numbers from them): privacy.gov.ph DPA page (403), WordStream 2022 search benchmarks (403), HBR "A Refresher on A/B Testing" (content not extractable), CIM 7Ps PDF (403), dti.gov.ph sales-promotion page (404), B2B Institute 95-5 page (404), Official Gazette / Chan Robles RA 7394 mirrors (403), Backlinko cold-email study (404).
