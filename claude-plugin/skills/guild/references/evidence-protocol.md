# Evidence Protocol — sources, claims, citations, and the human-entered ledgers

Companion to every guild command. The business analogue of anvil's electrical gate: while any
`evidence` row is red the venture's pass-rate is capped at 0.50, because a plan built on invented
or unsourced numbers cannot be polished over. Research basis: briefs 01 (customer discovery) and
02 (market sizing) in `research/raw/`, and forge's research protocol whose ledger schemas this
protocol adopts unchanged so the same validators apply.

## §0 The three rules

1. **Every number cites.** A magnitude enters a document only with a `[C-n]` token that resolves
   in `evidence/claims.tsv`; every claim cites ≥ 1 citable row of `evidence/sources.tsv`; every
   source carries a locator, a retrieval date and (unless obtained manually) an archived URL and a
   content hash. `score-guild.sh citations` counts every numeric claim without a resolving token —
   percentages, multipliers, currency amounts, thousands groups, five-digit-plus figures — and the
   `evidence` row for that document is red while the count is above zero.
2. **Say ≠ do.** Stated intentions, compliments and "would you buy?" answers are opinions, not
   evidence. The interview ledger records `evidence_kind ∈ say|do`; only past behaviour and
   commitments of time, reputation or money count toward discovery exit (brief 01 §5, G4).
3. **Humans write the human ledgers; the loop drafts.** `discovery/interviews.tsv`,
   `discovery/consent.tsv`, `discovery/commitments.csv`, `gtm/pipeline.tsv`, payments, acceptance
   records, certificates and compliance documents are **human-entered**. The loop never writes to
   them — it writes candidate rows, scripts and templates into `drafts/` and surfaces the row a
   human must fill. A gate that reads a human ledger reads what a human typed.

## §1 Source tiers (assigned by publication class, never by agreement with the thesis)

| Tier | Class | Examples for this domain |
|---|---|---|
| **T1** | primary / authoritative: statute or regulation text, agency page or issuance, court decision, benchmark publisher's own report, framework author's own text, first-party dataset | lawphil.net RA texts, BIR RMO/RR PDFs, BSP fee table, SPI benchmark PDF, PSA release, NWPC wage order, Sequoia/YC/PG essays, Dunford's site |
| **T2** | reputable secondary quoting a named primary: Big-4 / major law-firm summaries, encyclopedic summaries, established practitioner references, vendor pages citing a named dataset | PwC Worldwide Tax Summaries, Grant Thornton / Forvis Mazars / ACCRALAW alerts, Deltek quoting SPI, Gong/Clari benchmark posts with sample sizes |
| **T3** | weak: vendor marketing, blogs, aggregators, unsourced "benchmarks" | agency-profitability roundups, courier comparison blogs, "industry says" pages |
| **T4** | uncitable on its own: forums, social posts, search-result snippets, AI summaries | — |

Confidence floors (validator-enforced): `high` needs ≥ 2 independent T1/T2 sources; `moderate`
≥ 1 T1/T2; `low` may rest on T3; `contested` needs ≥ 2 sources including a T1/T2 and presents both
sides. T4-only support is invalid at any confidence. "Independent" = different author groups and
not one citing the other as its sole basis.

## §2 `evidence/sources.tsv` — 13 tab-separated columns (validator: `score-guild.sh sources`)

```
id  tier  type  year  title  venue  locator  depth  status  retrieved_at  archived_url  content_hash  fetch_status
```
- `id` `S-<n>`, unique · `tier` T1–T4 · `type` free vocabulary (statute, official, benchmark,
  firm-summary, docs, blog, news, dataset…) · `year` 4 digits
- `locator` one of `doi:` `pmid:` `pmcid:` `arxiv:` `isbn:` `url:http(s)…` — resolvable as accessed
- `depth` full | abstract | secondary — what was actually read
- `status` read | cited | rejected | unverified — `rejected` and `unverified` rows may exist as
  leads but **no claim may cite them**
- `retrieved_at` YYYY-MM-DD — the day the content was read (statute rows older than 12 months
  trigger re-verification in the compliance gate)
- `archived_url` a Wayback snapshot `https://web.archive.org/web/<YYYYMMDDhhmmss>/<url>` (or
  another archive URL) — PH agencies (PSA, SEC, NPC, BIR, Official Gazette) and several publishers
  block scripted fetches, so the archive is the durable citation
- `content_hash` 16–64 hex characters of the fetched body — the mechanical proof that the page
  existed with this content on that day
- `fetch_status` live | archived | manual — **a CAPTCHA page, a 403, a JS shell or a blank body is
  not a source**; record `manual` (with `-` for archive and hash) only when a human obtained the
  document by hand and says so in `type`/`title`

## §3 `evidence/claims.tsv` — 6 columns (validator: `score-guild.sh claims`)

```
id  rq  claim  confidence  sources  evidence
```
- `id` `C-<n>`, unique · `rq` the research question `RQ-<n>` **or** the venture assumption
  `V-<n>` the claim answers (a claim that answers nothing is not written)
- `claim` one atomic, falsifiable sentence. **Numbers carry their conditions:** value (± interval
  when given) · units · population / geography / reference period / statute and effective date.
  "Utilisation is about 70 %" is not a claim; "billable utilisation averaged 68.9 % across 403
  professional-services firms in SPI's 2025 benchmark (2024 data) [S-2]" is.
- `confidence` high | moderate | low | contested per §1 floors
- `sources` comma-joined S-ids; every id must exist and be citable
- `evidence` `evidence:<relpath>` into the reading notes (`evidence/S-<n>.md`: findings with
  units and conditions, limitations, verbatim quotes with page/section)

Disconfirmation: for every load-bearing claim, search against it, check supersession (a newer
wage order, a later RR, a bigger benchmark) and record what came back; a conflicting source flips
the row to `contested` — never average into a fake middle.

## §4 Citations in documents (validator: `score-guild.sh citations <doc> <claims.tsv>`)

Every market, offer, pricing, economics or board document carries `[C-n]` tokens on the same line
as the figure it supports. The gate treats these as numeric claims: `12 %`, `3.5x` / `3×`,
`₱ 500` / `$ 99` / `PHP 3,000` / `USD 1M`, `1,241,476`, any five-digit-plus run. Four-digit years
are ignored; fenced code and headings are skipped. A token that resolves to no claim (`[C-99]`) is
an orphan and leaves the line unsourced. Target: `UNSOURCED_CLAIMS: 0` for every document the
loop writes.

Practical form in prose: "PH establishments numbered 1,241,476 in 2024 [C-7]". In tables: put
the token in the cell with the number or in a trailing `source` column on the same row.

## §5 The interview ledger and consent (human-entered; validator: `score-guild.sh interviews`)

Interviews are evidence only when they are consented, recorded or quoted, and coded for past
behaviour. Schema (brief 01 §5, G2–G4):

`discovery/consent.tsv` — `participant_id date consent_version recording quotes_allowed
spi_collected spi_explicit_consent incentive_given_at_start withdrawal_date deletion_due`
- `participant_id` is a **pseudonym**; names and contact details stay outside the repo.
- Consent must be freely given, specific and informed (RA 10173 §3(b), the Data Privacy Act).
  Age, marital status, health and education are **sensitive personal information** (§3(l)) — a
  screener that collects them needs `spi_explicit_consent = Y` (§13). `deletion_due` implements
  §11 retention; no row may be used past it.
- Incentives are given at the start and never contingent on positive feedback.

`discovery/interviews.tsv` — `interview_id date segment_id role org_type org_size channel language
interviewer consent_id recorded solution_revealed top_pains last_occurrence_date past_behavior
workaround current_spend_php current_spend_time wtp_signal verbatim_quote commitment_type
commitment_detail next_step_date new_codes_count snapshot_link evidence_kind`
- every row joins a consent row; `recorded = Y` or a non-empty `verbatim_quote`
- `solution_revealed = N` for the first six interviews in a segment (a pitched respondent is
  contaminated — in a small Philippine niche the pool does not refill)
- an **evidence-grade** row has non-empty `past_behavior` **and** (`current_spend_php > 0` or
  `current_spend_time > 0` or `wtp_signal ≠ none` or `commitment_type ≠ none`); `evidence_kind = do`
  for behaviour/commitment, `say` for opinion
- quota: ≥ 12 interviews per elected segment (code saturation lands around the 12th; 80 % of
  codes by the 6th), ≥ 6 before any theme is called common, ≥ 1 per week while discovery is open;
  saturation = `new_codes_count = 0` for the last three interviews

The loop may draft `drafts/interview-script.md`, `drafts/consent-form.md` and candidate
`drafts/interviews-candidate.tsv` rows from call notes a human pastes — the human moves rows into
the ledger. Praise is not evidence; Filipino social-desirability bias is measurable (Cagasan 2016),
so weight behaviour and commitment, never agreement.

## §6 What the evidence gate blocks

- A market size, competitor price, benchmark, wage, tax rate or fee stated without a resolving
  `[C-n]`.
- A claim citing a `rejected`/`unverified` source, a T4-only source, or a `high` claim with fewer
  than two independent T1/T2 sources.
- A source row whose `fetch_status` is anything but live | archived | manual (CAPTCHA and blocked
  pages), or that lacks a retrieval date.
- An interview row with no consent join, sensitive fields without explicit consent, a row past
  its deletion date, or a segment "validated" on compliments.
- Any row in a human-entered ledger that git blames to the loop rather than to a human commit
  (the build command records `human_entered` commits separately).

## §7 Reading-notes template — `evidence/S-<n>.md`

```
# S-<n> — <title> (<venue>, <year>) — tier T?, depth <full|abstract|secondary>
Retrieved <YYYY-MM-DD> · archived <url> · hash <hex> · fetch <live|archived|manual>
## Findings (numbers keep units + conditions)
## Limitations (theirs, stated; ours, observed)
## Verbatim quotes (with section / page)
## Supersession / disconfirmation checked
```
