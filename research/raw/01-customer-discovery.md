# Customer discovery & validation — research brief (2026-09-02)

Scope: the discovery → validation slice of the guild harness (idea → validated customer + offer). All numbers below come from URLs fetched on 2026-09-02; anything not fetched is marked **UNVERIFIED**. Provenance grades: **P1** primary (framework author / statute / journal / the company's own write-up), **P2** secondary (reputable summary or interview of the primary), **P3** weak (vendor blog, self-reported claim). Source numbers [Sn] refer to §8.

## 1. Standard process — ordered steps and named deliverables

| # | Step | What a competent practitioner does | Named deliverable (the harness artifact) | Anchor |
|---|---|---|---|---|
| 0 | Write the hypotheses | Treat customer, problem, product, channel and pricing as *guesses*, not facts. "The product development model assumes that customers needs are known, the product features are known, and your business model is known" — Blank. Write each as "We believe that…" typed Desirability / Feasibility / Viability (+ Adaptability). | `assumptions.csv` (hypothesis ledger) | [S1][S13] |
| 1 | Assumption mapping | Plot every hypothesis on importance × evidence; the top-right ("critical for success and yet have the least amount of evidence") are the leap-of-faith / riskiest assumptions and are tested first. | Prioritised assumption map (risk rank column in `assumptions.csv`) | [S13][S11] |
| 2 | Segment + market-type hypothesis | Pick one candidate segment (ICP = firmographics of the account; persona/job story = the person and the progress they want) and a market-type hypothesis: Existing (faster/better), Resegmented (low-end "good enough at lower price" or niche "addresses their *specific* needs"), or New ("a large customer base who *couldn't do this before*"). "Market Type effects everything you do in this step: Positioning, Branding, Spending, Launch." | `segments.csv` + ICP sheet + draft job stories | [S3][S15][S27] |
| 3 | Recruit + consent | Go where the users are (YC: founders "dropped by fire stations in person"). Obtain informed consent that is "freely given, specific, informed" (RA 10173 §3(b)); modular checkboxes for recording; incentive not contingent on positive feedback; incentive given at start so the participant can withdraw. | `consent_register.csv`, screener | [S7][S20][S21][S25] |
| 4 | Problem interviews (Discovery) | "Stop selling, start listening — There are no facts inside your building, so get outside." Mom Test rules: talk about their life not your idea; ask about specifics in the past; talk less. YC's five questions (hardest part / last time / why hard / what tried / what don't you love). Record; capture exact quotes; end with a commitment (time, reputation or money) or the meeting "was pointless". | `interviews.csv` (ledger, §5) + one interview snapshot per conversation | [S3][S6][S7][S24] |
| 5 | Synthesis | Affinity-map observations into clusters (5–10 min generation, cluster, dot-vote, assign owners); code each interview; write job stories "When ___, I want to ___, so I can ___"; refine ICP vs persona; log new-code count per interview to detect saturation. | Codebook (`codes.csv`), job stories, saturation log | [S18][S15][S23] |
| 6 | Discovery exit check | Blank's exit criteria: "What are your customers top problems? — How much will they pay to solve them"; "Does your product concept solve them? — Do customers agree? How much will they pay?"; "Draw a day-in-the-life of a customer before & after your product"; "Draw the org chart of users & buyers". | Discovery exit memo (problem statement + WTP evidence + day-in-life + buyer org chart) | [S3] |
| 7 | Solution / offer experiments | Climb the evidence ladder: cheap "say" tests first (interviews, surveys), then "do" tests (landing page, concierge, Wizard of Oz, mock sale, pre-sale, LOI). "Reduce uncertainty as much as you can before you build anything." Pre-register metric + pass criterion on a test card; record the learning card. | `experiments.csv` (test + learning cards) | [S11][S12][S14] |
| 8 | Commitment & advancement | Convert conversations into commitments: next meeting, intro to buyer, LOI, paid pilot, pre-order/deposit. "Only earlyvangelists are crazy enough to buy." | `commitments.csv` | [S3][S6] |
| 9 | Customer Validation | "Develop a repeatable sales process." Exit criteria: "Do you have a proven sales roadmap? Org chart? Influence map?"; "Do you understand the sales cycle? ASP, LTV, ROI"; "Do you have a set of orders ($'s) validating the roadmap?"; "Does the financial model make sense?" If not, loop back to Discovery (the deck draws the only backward arrow here). | Sales roadmap + orders ledger + financial-model check | [S3] |
| 10 | PMF measurement | Sean Ellis survey on *engaged* users (Superhuman: used ≥2× in prior two weeks): "How would you feel if you could no longer use [product]?" — ≥40% "very disappointed"; segment respondents and "politely disregard those who would not be disappointed"; retention cohorts that flatten. | `pmf_survey.csv`, `retention_cohorts.csv`, PMF scorecard by segment | [S8][S9][S10] |
| 11 | Pivot-or-persevere | Validated learning is the unit of progress; when the model isn't working, "make a structural course correction to test a new fundamental hypothesis" using Ries's ten-pivot catalog. | Pivot decision record → new hypotheses in `assumptions.csv` | [S4][S5] |

## 2. Frameworks & methods

| Framework | Originator | Produces | When to use | Known critiques |
|---|---|---|---|---|
| Customer Development (Discovery → Validation → Creation → Company Building) | Steve Blank, *Four Steps to the Epiphany* [S1][S3] | Per-step exit criteria; "Measurable Checkpoints… tied to customer milestones"; market-type hypothesis; sales roadmap | Whole discovery→first-customer arc; Creation "comes after proof of sales" | Deck gives no interview counts (a "50–100 interviews" figure surfaced in an auto-summary is **UNVERIFIED** — not in the fetched deck); B2B/enterprise flavour; Blank's own HBR claim "75% of all start-ups fail" (Ghosh) fetched only as header [S28] |
| Lean Startup (Build-Measure-Learn, validated learning, MVP, innovation accounting, pivot) | Eric Ries [S4][S5] | Learning milestones; pivot catalog: zoom-in, zoom-out, customer segment, customer need, platform, business architecture, value capture, engine of growth, channel, technology | After a segment hypothesis exists; every persevere/pivot review | Principles page carries no thresholds; "vanity metrics" warning not on fetched pages (practitioner consensus); pivot list fetched from P2 pages quoting the book |
| The Mom Test | Rob Fitzpatrick [S6] | Interview rules; deflection of compliments/fluff/ideas; commitment currencies (time, reputation, money); advancement = next-step commitment | Every conversation; the harness's "evidence vs compliment" classifier | Book site fetched has no rules (landing page only); rules verified via P2 notes; Fitzpatrick's own "how many conversations" number **UNVERIFIED** |
| Jobs-to-be-Done (progress in a circumstance; functional/social/emotional) | Clayton Christensen [S16][S29] | Job definition; "hiring" circumstances (milkshake: morning commute vs kids' treat) | Framing the problem before segmenting by demographics | HBR article fetched only as header (84%/94% innovation stats) |
| Outcome-Driven Innovation | Tony Ulwick / Strategyn [S17] | Solution-free core job ("cut a piece of wood in a straight line"), job map (10–20 steps), 50–150 desired outcomes, opportunity score = importance + (importance − satisfaction) | Quantitative need-prioritisation once a segment is elected | Success-rate claim ("86%… vs roughly 17%") is self-reported — P3 |
| Job stories | Paul Adams (Intercom, mid-2013), named by Alan Klement [S15] | "[When ____] [I want to ____] [So I can ____]" | Replacing persona-based user stories in synthesis | Klement's original post not fetched (**UNVERIFIED** wording) |
| Testing Business Ideas (experiment library, assumptions mapping) | David J. Bland & Alex Osterwalder / Strategyzer [S11][S12][S13][S14] | 44 experiments graded by cost, setup/run time, evidence strength; discovery vs validation split; test/learning cards; "We believe that…" hypotheses | Choosing the next experiment; sequencing cheap→expensive | Per-experiment dot ratings live in the book/poster (not fetched); only the grading rules were retrievable |
| Sean Ellis PMF survey + Superhuman engine | Sean Ellis; Rahul Vohra [S8][S9] | % "very disappointed"; High-Expectation-Customer profile; 50/50 roadmap | Once there are engaged users (post-MVP) | Ellis's original post not fetched (**UNVERIFIED** benchmark base); min-n guidance not fetched |
| Retention curves | Balfour / Chen / Winters et al. via Lenny [S9][S10] | Flattening cohort curve; model-specific "good/great" benchmarks | Post-launch PMF check | Benchmarks are expert-poll medians, US/venture context — P2 |
| Affinity diagramming | KJ method; NN/g write-up [S18] | Clusters → prioritised themes | Synthesis after each batch of interviews | "The journey is more important than the destination" — output is judgment-laden, not mechanical |
| Interview snapshot | Teresa Torres [S24] | One-page per interview: name/photo/quick facts, memorable quote, opportunities, insights, experience map; weekly cadence | Continuous discovery | Product-team framing; assumes weekly access to customers |
| Saturation sampling | Guest, Bunce & Johnson 2006; Hennink et al. 2017 [S23] | Stopping rule by new-code rate | Sizing interviews per segment | Homogeneous samples; primary paper blocked (P2) |
| Usability sample sizes | Nielsen / NN/g [S19] | N(1−(1−L)^n), L≈31% → 5 users find ~85% | Prototype/usability rounds only, not problem discovery | Applies to usability defects, not market demand |
| ICP vs persona | B2B practitioner consensus [S27] | ICP = firmographics/technographics of the account; persona = role, goals, pains of the individual; 6–10 people in a B2B buying group (vendor claim) | Segment election and outreach lists | Vendor sources only — P3 |

## 3. Numbers annex

| Metric | Benchmark / threshold | Context | Source URL | Grade | Retrieved |
|---|---|---|---|---|---|
| PMF survey | ≥40% answer "very disappointed" | Users who used product ≥2× in prior 2 weeks (Superhuman sampling); YC repeats the 40% | https://review.firstround.com/how-superhuman-built-an-engine-to-find-product-market-fit/ ; https://www.ycombinator.com/blog/startup-school-week-1-recap-kevin-hale-and-eric-migicovsky/ | P2 (Ellis origin) / P1 (Superhuman, YC) | 2026-09-02 |
| Superhuman PMF trajectory | 22% → 33% (after segmenting to HXC) → 58% (three quarters later) | Consumer/prosumer email client, 2017–18 | https://review.firstround.com/how-superhuman-built-an-engine-to-find-product-market-fit/ | P1 | 2026-09-02 |
| Roadmap allocation | 50/50 between "what users love" and "what holds back somewhat-disappointed users" | Same | same | P1 | 2026-09-02 |
| Retention flattening | "If it flattens off at some point, you have probably found product/market fit" (Balfour) | Any model | https://www.lennysnewsletter.com/p/how-to-know-if-youve-got-productmarket | P2 | 2026-09-02 |
| Organic share | ">50% of your new accounts come from direct or organic traffic" (M. V. Grace) | PMF signal | same | P2 | 2026-09-02 |
| Sales yield | >1.0 (Rachleff) | Enterprise PMF | same | P2 | 2026-09-02 |
| 6-month user retention, good / great | Consumer social ~25/~45%; consumer transactional ~30/~50%; consumer SaaS ~40/~70%; SMB/mid-market SaaS ~60/~80%; enterprise SaaS ~70/~90% | Poll of 20 growth experts, US venture context | https://www.lennysnewsletter.com/p/what-is-good-retention-issue-29 | P2 | 2026-09-02 |
| 12-month net revenue retention, good / great | Consumer SaaS ~55/~80%; bottom-up SaaS ~100/~120%; land&expand VSB ~80/~100%; SMB/mid ~90/~110%; enterprise ~110/~130% | Same | same | P2 | 2026-09-02 |
| Qualitative saturation | Code saturation by the 12th interview; 80% of codes within first 6 | 60 interviews, homogeneous sample, Guest/Bunce/Johnson, *Field Methods* 18(1):59–82, 2006 | https://skimle.com/blog/how-many-interviews-qualitative-research (primary https://journals.sagepub.com/doi/10.1177/1525822X05279903 blocked; citation via https://bibbase.org/network/publication/guest-bunce-johnson-howmanyinterviewsareenoughanexperimentwithdatasaturationandvariability-2006) | P2 | 2026-09-02 |
| Saturation, deeper | Code saturation 9–17 interviews; meaning saturation 16–24 (Hennink, Kaiser & Marconi 2017) | Same secondary | same | P2 | 2026-09-02 |
| I-Corps interview floor | "at least 100 interviews with potential customers and other stakeholders" in 7 weeks; ≥15 h/week | NSF National Teams (Blank's Lean LaunchPad lineage) | https://www.nsf.gov/funding/initiatives/i-corps/information-accepted-national-teams | P1 | 2026-09-02 |
| Interview cadence | "at least one customer interview each week"; snapshot in 15–20 min | Continuous discovery (Torres) | https://www.producttalk.org/interview-snapshot/ | P1 | 2026-09-02 |
| Conversation length | "10–15 minutes" for initial research; up to an hour for experts | Mom Test | https://www.ricklindquist.com/notes/the-mom-test-by-rob-fitzpatrick | P2 | 2026-09-02 |
| Quant sample floor | "samples of over 30 participants"; in B2B, 50% participation of a limited pool is "excellent" | Strategyzer experiment design | https://www.strategyzer.com/library/designing-strong-experiments | P1 | 2026-09-02 |
| Experiment pacing | "12 experiments in 12 weeks" | Strategyzer | https://www.strategyzer.com/library/how-to-select-the-next-best-test-from-the-experiment-library | P1 | 2026-09-02 |
| Experiment library size | 44 experiments, graded by cost, time, evidence strength | Testing Business Ideas | https://www.strategyzer.com/library/testing-business-ideas-book-summary | P1 | 2026-09-02 |
| Usability sample | 5 users ≈ 85% of problems (L=31%); 3 rounds × 5 beats 1 × 15; 20 users for quantitative; 3–4 per group (2 groups), 3 per group (3+ groups) | Usability testing only | https://www.nngroup.com/articles/why-you-only-need-to-test-with-5-users/ | P1 | 2026-09-02 |
| Affinity generation | 5–10 minutes of sticky-note generation | NN/g | https://www.nngroup.com/articles/affinity-diagram/ | P1 | 2026-09-02 |
| Market-type cash horizon | New market "unprofitable for 5 or more years"; existing market "generating cash in 12–18 months"; Handspring $170M revenue in first 12 months (existing market) | Blank | https://steveblank.com/2009/09/10/customer-development-manifesto-part-4/ | P1 | 2026-09-02 |
| Startup failure | "75% of all start-ups fail" (Ghosh, HBS) | Blank, HBR 2013 (header only) | https://hbr.org/2013/05/why-the-lean-start-up-changes-everything | P1 (partial fetch) | 2026-09-02 |
| Innovation dissatisfaction | 84% of executives say innovation extremely important; 94% dissatisfied with performance | Christensen et al., HBR 2016 (header only) | https://hbr.org/2016/09/know-your-customers-jobs-to-be-done | P1 (partial fetch) | 2026-09-02 |
| ODI structure | 50–150 desired outcomes per market; job map 10–20 steps; opportunity = importance + (importance − satisfaction); "20% better" heuristic; 86% vs 17% success | Strategyn | https://strategyn.com/jobs-to-be-done/ | P1 (structure) / P3 (success claim) | 2026-09-02 |
| Research-ethics maturity | ≥90% excellent; 75–89% good; <75% poor | NN/g checklist | https://www.nngroup.com/articles/user-research-ethics/ | P1 | 2026-09-02 |
| PH DPA penalties | 6 months–7 years imprisonment; ₱100,000–₱4,000,000 fines (as summarised from §§25–32) | RA 10173 | https://lawphil.net/statutes/repacts/ra2012/ra_10173_2012.html | P1 | 2026-09-02 |
| Filipino social-desirability scale | reliability .706 (n=157), .731 (n=162); correlates with BIDR and Marlowe-Crowne | Cagasan 2016, *Phil. J. Psychology* 49(1):19–42 | https://www.pap.ph/file/pjp/pjp2016-49-1-pp19-42-cagasan-the_development_and_va.pdf | P1 | 2026-09-02 |
| **UNVERIFIED** | Blank "50–100 interviews" per discovery phase; Ellis's "~100 startups" benchmark base; Fitzpatrick's "3–5 conversations" stopping heuristic; minimum n for the PMF survey | Not present in any fetched page | — | — | — |

## 4. Philippine specifics

1. **Consent is statutory, not just etiquette.** RA 10173 §3(b): consent is "any freely given, specific, informed indication of will, whereby the data subject agrees to the collection and processing of personal information." §12 lists six lawful bases — (a) consent, (b) contract, (c) legal obligation, (d) vital interests, (e) public authority/emergency, (f) legitimate interests not overridden by fundamental rights. Interview recordings and verbatim quotes tied to a name are personal information (§3(g)) [S25].
2. **Age, marital status, health and education are *sensitive personal information* (§3(l)).** A typical screener ("age bracket", "health condition", "education") triggers §13, where processing is prohibited except with consent "specific to the purpose prior to the processing" or another listed exception. The harness screener must therefore either drop those fields or attach an explicit-consent checkbox [S25].
3. **Data-subject rights (§16)** — to be informed, to access, to dispute/correct, to suspend or block, to damages, to portability — imply the interview ledger needs a pseudonymous participant ID and a deletion path. §11 requires retention "only as necessary" [S25].
4. **The regulator's own site (privacy.gov.ph) and officialgazette.gov.ph returned 403 on fetch**; the statute was read from lawphil.net. Any NPC circulars on research consent are **UNVERIFIED** here.
5. **Response bias is measurable in Filipino samples.** Cagasan (2016) built and validated a Filipino Social Desirability Scale precisely because Western instruments "may not function similarly for western and eastern subjects" (citing Li & Reb 2009) — a point the author states is "quite valid even for Filipinos" [S26]. This is evidence that stated-attitude data from Filipino respondents needs a bias control; it is *not* evidence that Filipinos are more biased than others. The widely repeated claim that *hiya* / *pakikisama* inflate compliments in interviews is **practitioner consensus / UNVERIFIED** (no primary fetched). Consequence for the harness: weight past-behaviour and commitment evidence, never agreement or praise.
6. Interviewing in the respondent's preferred language (Tagalog/Bisaya/English/Taglish) and coding verbatims in the original language: **practitioner consensus, no source fetched**.

## 5. Mechanical gate candidates

Each gate is a script reading a CSV and comparing to a threshold. Thresholds marked *(harness default)* have no external source and must be tunable; thresholds marked with a source are anchored.

**G1 — Riskiest-assumption gate** (before any build or paid experiment)
- Ledger `assumptions.csv`: `id, statement("We believe that…"), type(D/F/V/A), importance(1–5), evidence(0–3), risk=importance×(3−evidence), experiment_ids, status(open|supported|refuted), owner, updated_at`.
- Check: every assumption in the top-N by `risk` (N=3, harness default) has ≥1 linked experiment with a recorded verdict; no `status=open` with `evidence=0` and `importance≥4` may remain when a build step starts [S13][S14].
- Not mechanisable: the importance score and the "have evidence / no evidence" judgment — a **human sign-off row** (`scored_by`, `scored_at`).

**G2 — Consent gate** (hard, 100%)
- Ledger `consent_register.csv`: `participant_id(pseudonym), date, consent_version, recording(Y/N), quotes_allowed(Y/N), spi_collected(Y/N), spi_explicit_consent(Y/N), incentive_given_at_start(Y/N), withdrawal_date, deletion_due`.
- Check: every `interviews.csv` row joins to a consent row; `spi_collected=Y ⇒ spi_explicit_consent=Y` (RA 10173 §13); no row past `deletion_due` (§11) [S25][S20][S21].
- Not mechanisable: whether the explanation was actually understood (NN/g "plain language" requirement) — human attestation row.

**G3 — Interview volume + saturation gate** (Discovery exit, per segment)
- Ledger `interviews.csv`: `interview_id, date, segment_id, role, org_type, org_size, channel, language, interviewer, consent_id, recorded(Y/N), solution_revealed(Y/N), top_pains(code_ids), last_occurrence_date, past_behavior(text), workaround(text), current_spend_php, current_spend_time, wtp_signal(unprompted|prompted|none), verbatim_quote, commitment_type(none|time|reputation|money), commitment_detail, next_step_date, new_codes_count, snapshot_link`.
- Checks: (a) interviews per elected segment ≥12 (Guest et al.; harness floor) and ≥6 before any theme is called "common" [S23]; (b) saturation: `new_codes_count=0` for the last 3 consecutive interviews (harness default k=3; Fitzpatrick's "you can predict what they will say next" [S6]); (c) `solution_revealed=N` for the first ≥6 interviews per segment (contamination guard; harness default); (d) weekly cadence ≥1 interview/week while Discovery is open [S24]; (e) `recorded=Y` or `verbatim_quote` non-empty for 100% of rows [S6][S7].
- Not mechanisable: the coding itself; the script can enforce double-coding on a random 20% and compute agreement (harness default), but the codes are human.

**G4 — Evidence-quality gate** (what counts toward Discovery exit)
- Same ledger. Check: count only rows where `past_behavior` non-empty AND (`current_spend_php>0` OR `current_spend_time>0` OR `wtp_signal≠none` OR `commitment_type≠none`). Compliments and "would you use it" answers are excluded by construction [S6][S12]. Discovery exit requires ≥50% of segment interviews to be evidence-grade (harness default) and a Blank exit memo linking: top problems, how much they pay today, product-concept agreement, day-in-life before/after, buyer org chart [S3].
- Not mechanisable: reading a verbatim as pain vs politeness — coder judgment, logged with `coder_id`.

**G5 — Experiment ladder gate** (before pricing/GTM work)
- Ledger `experiments.csv`: `exp_id, assumption_id, type(interview|survey|landing_page|concierge|wizard_of_oz|mock_sale|pre_sale|LOI|paid_pilot|crowdfunding), evidence_kind(say|do), setting(lab|field), cost_php, setup_days, run_days, metric, pass_criterion, preregistered_at, started_at, n, result, verdict(pass|fail|inconclusive), learning, spend_approved_by`.
- Checks: `preregistered_at < started_at` for 100% of rows; the top-3 riskiest desirability assumptions each have ≥1 `evidence_kind=do` experiment with `n≥30` where the test is quantitative [S12], or a commitment (G6) where it is B2B; sequencing rule — no `cost_php` above a budget cap before a cheaper `say` test on the same assumption has run [S14].
- Not mechanisable: `spend_approved_by` — any peso spent is a human sign-off row.

**G6 — Commitment gate** (problem/solution fit → Validation entry)
- Ledger `commitments.csv`: `customer_id, segment_id, type(next_meeting|intro_to_buyer|LOI|pre_order|paid_pilot|deposit), amount_php, date, doc_link, signed_by_human`.
- Check: ≥N money-class commitments (LOI/pre-order/paid pilot/deposit) from the elected segment, N=3 (harness default; Blank's criterion is "a set of orders ($'s) validating the roadmap" without a number [S3]); commitment rate (rows with `commitment_type≠none` / interviews) trending up over the last 10 interviews (harness default).
- Not mechanisable: sending the LOI, signing, invoicing — all human-gated (`signed_by_human`).

**G7 — PMF survey gate** (post-MVP)
- Ledger `pmf_survey.csv`: `respondent_id, segment_id, used_2x_in_2w(Y/N), q1(very|somewhat|not), q2_who_benefits, q3_main_benefit, q4_improve, date`.
- Check: filter `used_2x_in_2w=Y`; `%very ≥ 40%` overall and per segment; n ≥ 30 (Strategyzer rule of thumb — Ellis/Superhuman minimum **UNVERIFIED**); recompute quarterly [S8][S12].
- Not mechanisable: building the HXC profile from q2/q3 text; the 50/50 roadmap allocation is a human decision recorded as a row.

**G8 — Retention gate** (post-launch)
- Ledger `retention_cohorts.csv`: `cohort_month, model(consumer_social|consumer_txn|consumer_saas|smb_saas|enterprise_saas), n0, m1..m6`.
- Check: m6/n0 ≥ Lenny "good" for the declared model (e.g., SMB SaaS ≥60%) and slope of m4→m6 ≥ −2 pts/month (flattening; harness default) [S9][S10].
- Not mechanisable: choosing which model row applies.

**G9 — Segment election gate**
- Ledger `segments.csv`: `segment_id, icp_firmographics, persona_role, job_story, market_type(existing|resegmented_lowend|resegmented_niche|new), interviews_n, evidence_grade_n, commitments_money_n, elected(Y/N), elected_at, elected_by, board_ack`.
- Check: at most one `elected=Y`; election allowed only when G3, G4 and G6 pass for that segment; `market_type` non-null (it drives spending/launch/positioning and the cash horizon) [S2][S3].
- Not mechanisable: the election itself — **human sign-off row** (see §6).

## 6. Early irreversibles

1. **Segment election.** Everything downstream (positioning, channel, pricing, sales roadmap, the "org chart of users & buyers") is built on it; a customer-segment pivot restarts Discovery. Superhuman only moved from 22% to 33% by *narrowing* the respondent set to its High-Expectation Customer — the harness should elect narrow and widen later, never the reverse [S8][S3][S5].
2. **Market-type hypothesis.** Blank: new-market startups "might be unprofitable for 5 or more years" versus "12–18 months" for existing markets, and "Market Type effects everything you do… Positioning, Branding, Spending, Launch." Choosing "new market" commits runway and a hockey-stick expectation; choosing "existing" commits to faster/better feature competition [S2][S3].
3. **Contaminating the participant pool.** Once a solution is pitched to a respondent, that respondent's future answers are biased ("The moment you mention your solution, you've contaminated the conversation") — in a small Philippine niche the pool does not refill [S6][S7].
4. **Consent scope.** Recordings and quotes may only be used within the consented purpose (§3(b) "specific"); re-use for marketing or a wider study requires fresh consent — retroactive widening is impossible, deletion obligations run [S25].
5. **Business architecture (B2B vs consumer) and value-capture choices** are pivots Ries lists as whole-model changes; deciding them by default (e.g., because the studio is engineering-led) rather than by evidence is the costliest reversal [S5].
6. **First earlyvangelist references.** "Only earlyvangelists are crazy enough to buy"; who is signed first becomes the reference in the sales roadmap; a mismatched first customer distorts the roadmap [S3].

## 7. Failure modes / anti-patterns the harness must guard against

| Anti-pattern | Guard | Source |
|---|---|---|
| Pitching in the interview ("that is not the time to be pitching the product") | `solution_revealed` flag; first ≥6 interviews per segment must be N | YC [S7]; Mom Test [S6] |
| Hypothetical / future questions ("would you buy?") | Ledger requires `past_behavior` + `last_occurrence_date`; empty ⇒ non-evidence row | Mom Test rule 2 [S6]; Strategyzer "ask about their past behaviour" [S12] |
| Counting compliments as evidence | G4 evidence-grade filter | Mom Test [S6] |
| Interviewer talks too much | Recording required; (optional) talk-ratio check on transcript — *harness default* | YC/Mom Test [S6][S7] |
| Meetings that end without advancement ("pointless") | `commitment_type` mandatory; zero-commitment streak alerts | Mom Test [S6] |
| Treating "say" as "do" | `evidence_kind` column; riskiest assumptions need a `do` test | Strategyzer [S11][S12] |
| Building before reducing uncertainty | G1 + G5 sequencing ("Reduce uncertainty… before you build anything") | Strategyzer [S14] |
| Testing convenient, not riskiest, assumptions | G1 top-N by risk | Strategyzer [S13] |
| Surveying the wrong population for PMF (casual users, or keeping "not disappointed" in the denominator) | G7 filters `used_2x_in_2w`; segment scores reported separately | Superhuman [S8] |
| Averaging across segments hides fit | Per-segment PMF and retention rows | Superhuman [S8] |
| Only doubling down on loved features, or only fixing gaps | 50/50 roadmap row | Superhuman [S8] |
| Demographic / attribute personas instead of jobs & motivations | Job story required per segment | Christensen Institute [S16]; Intercom [S15] |
| Stopping interviews too early (before 6/12) or never stopping | G3 floor + saturation rule | Guest et al. via [S23] |
| Small-n quantitative claims (<30) | G5/G7 n checks | Strategyzer [S12] |
| Incentives that reward positive feedback; no withdrawal path | Consent register fields | NN/g [S20][S21] |
| Collecting age/health/education without explicit consent | G2 SPI check | RA 10173 §13 [S25] |
| Social-desirability and acquiescence in stated-attitude data | Weight behaviour/commitment; avoid yes/no and agree/disagree formats | Cagasan [S26]; cultural mechanism **UNVERIFIED** |
| "Build it and they will come" (Blank: only true for "life and death products") | Customer-development checkpoints run in parallel with product work | Blank deck [S3] |
| Skipping the loop back from Validation to Discovery when orders don't materialise | G6 failure routes to G3, not to "sell harder" | Blank deck [S3] |
| Vanity metrics in place of innovation accounting | Innovation-accounting milestones (validated learning) — *practitioner consensus; not on the fetched page* | Ries [S4] |

## 8. Sources

1. Steve Blank — *The Customer Development Manifesto: Reasons for the Revolution (Part 1)* · https://steveblank.com/2009/08/31/the-customer-development-manifesto-reasons-for-the-revolution-part-1/ · P1 blog · "fail because they lack customers and a profitable business model"; hypotheses vs assumed knowledge. [S1]
2. Steve Blank — *Customer Development Manifesto: Market Type (Part 4)* · https://steveblank.com/2009/09/10/customer-development-manifesto-part-4/ · P1 blog · new vs existing market cash horizons (5+ yrs vs 12–18 months); Handspring $170M. [S2]
3. Steve Blank — *The Customer Development Methodology* (Stanford E140A Session 7 deck, hosted by UCSD) · https://innovation.ucsd.edu/startup/startup-toolkit/Steve-Blank-CustDev.pdf · P1 deck (read as page images) · four steps, Discovery/Validation/Company-Building exit criteria, market types, "no facts inside your building", earlyvangelists, Creation after proof of sales. [S3]
4. The Lean Startup — *Principles* · https://theleanstartup.com/principles · P1 · build-measure-learn, validated learning, MVP, innovation accounting, pivot definition. [S4]
5. Applied Frameworks — *10 types of business model pivots on Lean startups* · https://appliedframeworks.com/blog/types-of-business-model-pivots-in-lean-startup · P2 (quotes *The Lean Startup*) · full ten-pivot catalog; cross-checked with Kromatic https://kromatic.com/blog/the-taxonomy-of-the-lean-startup-pivot (8 of 10). [S5]
6. Rick Lindquist — *Notes and Takeaways from The Mom Test* · https://www.ricklindquist.com/notes/the-mom-test-by-rob-fitzpatrick · P2 · three rules, compliments/fluff/ideas, commitment currencies, advancement, stopping rule, note-taking, 10–15 min; book site https://www.momtestbook.com/ fetched (landing page only). [S6]
7. Y Combinator — *Startup School Week 1 Recap: Kevin Hale and Eric Migicovsky* · https://www.ycombinator.com/blog/startup-school-week-1-recap-kevin-hale-and-eric-migicovsky/ · P1 · five questions, three mistakes, three stages, go where users are, record, 40%. [S7]
8. First Round Review — *How Superhuman Built an Engine to Find Product/Market Fit* · https://review.firstround.com/how-superhuman-built-an-engine-to-find-product-market-fit/ · P1 (Superhuman) / P2 (Ellis) · survey questions, ≥2× in 2 weeks sampling, 22→33→58%, HXC, 50/50. [S8]
9. Lenny Rachitsky — *How to know if you've got product-market fit* · https://www.lennysnewsletter.com/p/how-to-know-if-youve-got-productmarket · P2 · Balfour flattening, Grace >50% organic, Rachleff sales yield >1.0, Altman/Gil qualitative signals. [S9]
10. Lenny Rachitsky — *What is good retention* · https://www.lennysnewsletter.com/p/what-is-good-retention-issue-29 · P2 · 6-month user retention and 12-month NRR benchmarks by model, 20 experts. [S10]
11. Strategyzer — *Testing Business Ideas: Book Summary* · https://www.strategyzer.com/library/testing-business-ideas-book-summary · P1 · 44 experiments; discovery vs validation; strong/moderate/weak evidence; high-impact low-evidence first. [S11]
12. Strategyzer — *Designing Strong Experiments* · https://www.strategyzer.com/library/designing-strong-experiments · P1 · say vs do; past behaviour; cheap→expensive sequencing; >30 participants; B2B 50%. [S12]
13. Strategyzer — *How Assumptions Mapping Can Focus Your Teams…* · https://www.strategyzer.com/library/how-assumptions-mapping-can-focus-your-teams-on-running-experiments-that-matter · P1 · D/F/V/A hypotheses, importance × evidence, riskiest quadrant, "We believe that…". [S13]
14. Strategyzer — *How to Select the Next Best Test from the Experiment Library* · https://www.strategyzer.com/library/how-to-select-the-next-best-test-from-the-experiment-library · P1 · cheap and fast early; discovery before validation; 12 experiments in 12 weeks. (Library page https://www.strategyzer.com/library/experiment-library fetched: poster only, no ratings.) [S14]
15. Intercom — *How we accidentally invented Job Stories* · https://www.intercom.com/blog/accidentally-invented-job-stories/ · P1 · format, origin (Adams 2013, Klement), critique of user stories and personas. [S15]
16. Christensen Institute — *Jobs to Be Done* · https://www.christenseninstitute.org/theory/jobs-to-be-done/ · P1 · definition, functional/social/emotional, milkshake, critique of demographics. [S16]
17. Strategyn — *Jobs-to-be-Done / Outcome-Driven Innovation* · https://strategyn.com/jobs-to-be-done/ · P1 structure, P3 success claims · solution-free job, 50–150 outcomes, opportunity algorithm, 10–20 step job map, 86%/17%. [S17]
18. Nielsen Norman Group — *Affinity Diagramming for Collaboratively Sorting UX Findings* · https://www.nngroup.com/articles/affinity-diagram/ · P1 · three steps, 5–10 min, dot voting. [S18]
19. Nielsen Norman Group — *Why You Only Need to Test with 5 Users* · https://www.nngroup.com/articles/why-you-only-need-to-test-with-5-users/ · P1 · formula, L=31%, 85%, 3×5, 20 for quant, per-group sizes. [S19]
20. Nielsen Norman Group — *Obtaining Consent for User Research* · https://www.nngroup.com/articles/informed-consent/ · P1 · consent-form elements, guardians, compensation not contingent on feedback. [S20]
21. Nielsen Norman Group — *Ethical Maturity in User Research* · https://www.nngroup.com/articles/user-research-ethics/ · P1 · definition, incentive at start, delete data when no longer needed, maturity thresholds. [S21]
22. NSF — *Information for Accepted National Teams (I-Corps)* · https://www.nsf.gov/funding/initiatives/i-corps/information-accepted-national-teams · P1 · ≥100 interviews, 7 weeks, 15 h/week, lessons-learned presentation. [S22]
23. Skimle — *How many qualitative interviews are enough? Guest, Bunce & Johnson (2006)…* · https://skimle.com/blog/how-many-interviews-qualitative-research · P2 · 12 / 6 (80%) and Hennink 9–17 / 16–24; citation metadata via BibBase (Field Methods 18(1):59–82); SAGE, Semantic Scholar, Bath SDR, SciSpace blocked. [S23]
24. Teresa Torres — *The Interview Snapshot* · https://www.producttalk.org/interview-snapshot/ · P1 · snapshot fields, weekly cadence, 15–20 min, stories of past behaviour. [S24]
25. Republic Act No. 10173 (Data Privacy Act of 2012), full text · https://lawphil.net/statutes/repacts/ra2012/ra_10173_2012.html · P1 statute · §3(b)(g)(l), §11, §12, §13, §16, penalties §§25–32; privacy.gov.ph and officialgazette.gov.ph returned 403. [S25]
26. Louie P. Cagasan Jr. — *The Development and Validation of a Filipino Social Desirability Scale*, Phil. J. Psychology 49(1):19–42, 2016 · https://www.pap.ph/file/pjp/pjp2016-49-1-pp19-42-cagasan-the_development_and_va.pdf · P1 peer-reviewed (read as PDF pages) · SD definition, reliabilities, Western scales may not transfer, Felipe 1969 precedent. [S26]
27. Factors.ai — *ICP vs. Buyer Persona* · https://www.factors.ai/blog/icp-vs-buyer-persona · P3 vendor · ICP firmographics/technographics vs persona role/goals/pains. [S27]
28. Steve Blank — *Why the Lean Start-Up Changes Everything*, HBR May 2013 · https://hbr.org/2013/05/why-the-lean-start-up-changes-everything · P1 (header/summary only fetched) · "75% of all start-ups fail" (Ghosh). [S28]
29. Christensen, Hall, Dillon, Duncan — *Know Your Customers' "Jobs to Be Done"*, HBR Sept 2016 · https://hbr.org/2016/09/know-your-customers-jobs-to-be-done · P1 (header only fetched) · 84% / 94% innovation statistics. [S29]

Blocked or empty on fetch (not counted as read): ycombinator.com/library/6g (404), strategyzer.com experiments page (404), privacy.gov.ph (403), officialgazette.gov.ph (403), journals.sagepub.com (403), fastcompany.com (403), jtbd.info (failed), jobs-to-be-done.com (403), pmfsurvey.com (footer only), startup-marketing.com (index only), seanellis.substack.com (landing only), medium.com/lean-stack (403), newsletter.leanfoundry.com (DNS), leanstack.com / leanfoundry.com / ashmaurya.com (landing pages only).
