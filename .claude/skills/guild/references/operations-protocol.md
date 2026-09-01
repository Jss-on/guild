# Operations Protocol — MSA/SOW, delivery discipline, hardware NPI, PH ship-blockers, after-sales

Companion to `/guild:build` P9 and to `/guild:board` delivery reviews. Research basis: brief 08
(`research/raw/08-operations-delivery.md`; [S#] below = its §8 source list, provenance P1–P3),
with statute rows shared with briefs 09/10. Gates: `score-guild.sh sow | delivery | regulatory`
(this file is their contract), plus `ar` in `finance-protocol.md`. Everything here is drafted by
the loop and **signed, sent, shipped, filed or refunded only by a human** (§9). Not legal advice —
warranty and regulatory rows go to the lawyer/CPA sign-off rows in `compliance/register.csv`.

## §0 The four operating rules

1. **No deposit, no kickoff.** `kickoff_date` requires `signed_date` and `deposit_paid_date`, with
   `deposit_pct ≥ 20 %` (deposits run 20–50 % in practice; 50/50 only on ~2-week jobs) [S8][S9].
2. **Cash follows acceptance, never the calendar.** Every payment line references a milestone id
   (`M-<n>`); milestone invoices issue on `accepted_date` or on deemed acceptance after the review
   window. Payments tied to dates pay for elapsed time whether or not work shipped [S9].
3. **No signature, no work. Ever** [S11]. `hours_logged_before_approval` on any change order must
   be 0; approved change orders carry a `signed_doc_ref`.
4. **Nothing ships without its certificate and its warranty text.** A radio product without NTC
   type approval under the exact marketed model name, a BPS-mandatory product without a PS mark /
   ICC sticker, consumer warranty text under 60 days, or the string "No Return, No Exchange"
   anywhere is a ship-blocker, not a nice-to-have [S27][S32][S34][S38][S39].

## §1 MSA vs SOW split

| Document | Carries | Changes how often |
|---|---|---|
| **MSA** (master services agreement) | legal terms: confidentiality, IP framework, warranties/disclaimers, indemnities, liability caps, dispute resolution, termination mechanics, change-control clause | once per client relationship |
| **SOW** (statement of work) under the MSA | commercial terms only: scope, deliverables, acceptance criteria, milestones, payment schedule, key personnel, engagement-specific warranty/SLA | per engagement |

Keeping legal terms out of the SOW keeps every new engagement a commercial negotiation, not a
legal one — over-lawyered SOWs slow sales [S6]. The **first MSA is an early irreversible**: its IP
clause and payment-terms precedent follow the relationship (§10).

## §2 SOW anatomy — the 18 lint fields (`score-guild.sh sow`, emits `SOW_MISSING: N`)

The SOW is lintable markdown: scalar fields as `key: value` lines, block fields as `## key`
sections (format details in the `sow.sh` header). The 18 fields, from [S6][S7][S8][S9]:

| # | Field | Rule the gate enforces | Why |
|---|---|---|---|
| 1 | `msa_reference` | present | legal terms live in the MSA [S6] |
| 2 | `engagement_type` | software \| firmware \| hardware \| mixed \| service \| repair \| service_repair | selects the warranty floor (#14) |
| 3 | `scope_in` | non-empty | the fence everything else references |
| 4 | `deliverables` | each names a **format** (repo tag, PDF, Gerbers, Docker image) | "done" must be a thing you can hand over [S6] |
| 5 | `acceptance_criteria` | non-empty, per deliverable, testable | acceptance is a measurement, not a mood |
| 6 | `review_window_days` | numeric ≥ 1 (default **5 business days**) **and** a deemed-acceptance sentence | without a window UAT never ends; if no written acceptance or defect list arrives in 5 BD the deliverable is deemed accepted [S8] |
| 7 | `assumptions_client_dependencies` | non-empty | client-caused delay needs a named dependency to point at [S6] |
| 8 | `out_of_scope` | states that any other work **requires a change order** | the fence's gate [S6] |
| 9 | `change_control_reference` | present (MSA clause / annex form) | see the tiers below |
| 10 | `milestones` | table with `M-<n>` ids, deliverable, objective evidence of completion, planned date | payment anchors [S8] |
| 11 | `payment_schedule` | **every payment line names an `M-<n>` id; a calendar-date payment line is a violation** | rule 2 above [S9] |
| 12 | `deposit_pct` | ≥ 20 (typical splits: 20–30 / 40–50 / 20–30; 20/30/50 on 8–12-week builds; deposits range 20–50 %) | [S8][S9] |
| 13 | `ip_ownership` | carries an **IP assignment** clause (deliverables assigned on receipt of final payment) **and** a **background IP** carve-out (pre-existing libraries, board designs, tooling stay with the studio under a perpetual licence) | without an express written assignment the creator keeps the copyright of commissioned work (RA 8293 §178.4, §180); "as-is + no IP clause" is a red-flag pair [S7] |
| 14 | `warranty_days` | ≥ **30** for software/firmware/hardware (30–90 days is the typical software warranty [S7]); ≥ **90 days** when `engagement_type` is service/repair — RA 7394 **Art. 71**: service firms guarantee workmanship and spare parts ≥ 90 days, **stated on the invoices** [S38] |
| 15 | `support_sla_reference` | a support-SOW id or the literal "none" | an SLA is a separate paid promise (§4) |
| 16 | `key_personnel` | named people; replacement needs client consent | small-studio deals are bought on people |
| 17 | `termination` | a **cure** period for cause (7–14 days) and termination for **convenience** notice (30 days) with payment for accepted milestones + WIP | [S7] |
| 18 | `liability_cap` | present — 1–2× contract value, carve-outs for IP infringement, confidentiality, wilful misconduct | [S7] |

Global lint: the string **"No Return, No Exchange"** (or words to that effect) anywhere in the
SOW, invoices, receipts or templates is a violation — DTI DAO 2 s.1993 prohibits it on receipts,
contracts, or anywhere in the establishment; administrative fines reach ₱300,000 plus ₱1,000/day
continuing [S39][S40].

**Change-control tiers** (reference for #9; process guide, P3): under ~₱50k or 5 h — e-mail
approval; mid-size — simplified change-request form; large — full re-estimate. Turn estimates
around in 2–5 business days; client **written approval before work** [S7][S10]. When cumulative
approved change-order value exceeds **25 % of contract value, rebaseline** the plan instead of
patching it [S10] (the `delivery` gate flags this).

**Warranty holdback**: 5–10 % of fees held until warranty expiry (30–90 days) is the standard way
to make the warranty real without an open-ended retainage [S8][S9].

**SLA tiers** (only when a support contract exists; a 24/7 P1 promise needs a 24/7 operation
behind it [S13]): typical severity ladder P1 response 15–60 min / resolution 2–8 h; P2 response
30–60 min–4 h / resolution ≤ 24 h; P3 response ≤ 1 business day / resolution 1–5 BD; P4 next
business day [S12][S13]. Uptime arithmetic: **99.9 %** allows 1 m 26 s/day, **43 m 50 s/month**,
8 h 45 m 57 s/year of downtime [S14] — never promise a nine you cannot staff.

## §3 Delivery lifecycle and ledgers (`score-guild.sh delivery`, emits `DELIVERY_VIOLATIONS: N`)

Lifecycle (brief 08 §1A): qualify → **signed MSA + SOW + deposit invoice** → kickoff record →
milestone builds with objective evidence → UAT inside the review window → acceptance → milestone
invoice → handover → warranty → optional SLA → close + retro with project P&L and CSAT/NPS.

Ledgers (human-entered facts; the loop lints, drafts invoicing tasks, never marks acceptance):

- `ops/projects.csv` — `project_id client_id engagement_model{fixed,tm,tm_nte,retainer}
  contract_value currency signed_date deposit_pct deposit_paid_date kickoff_date planned_end
  actual_end accepted_end_date status`. Fixed price carries a 10–20 % risk premium and belongs
  only on testable scope; 100 % upfront or 100 % at end are both red flags [S7].
- `ops/milestones.csv` — `milestone_id project_id deliverable acceptance_ref planned_date
  delivered_date review_deadline accepted_date deemed_accepted invoice_id invoice_date paid_date
  amount`.
- `ops/change_orders.csv` — `co_id project_id requested_date description delta_cost delta_days
  estimate_sent_date approved_date signed_doc_ref hours_logged_before_approval`.
- `ops/time.csv` — `date person project_id hours billable standard_rate billed_rate billed_flag
  written_off_hours`.
- `ops/ops_monthly.csv` (KPI roll-up read by the board) — `month projects_closed projects_on_time
  utilization_pct billing_realization_pct write_off_pct co_value_pct_of_contract csat nps p1_count
  p1_response_met_pct p1_resolve_met_pct uptime_pct avg_days_to_invoice_after_acceptance dso_days`.

Thresholds (B = benchmark, D = harness default; env-overridable in the gate):

| Check | Rule | Basis |
|---|---|---|
| Start-work | `signed_date` + `deposit_paid_date` ≤ `kickoff_date`; `deposit_pct ≥ 20` | B [S8][S9] |
| Milestone invoice | `invoice_date ≥ accepted_date`, or `deemed_accepted = Y` with `invoice_date > review_deadline` (5 BD window) | B [S8][S9] |
| Change control | `hours_logged_before_approval = 0`; approved COs have `signed_doc_ref` | B [S11] |
| Rebaseline | Σ approved CO value > 25 % of contract → **flag** for re-plan (stderr, not a violation) | B (P3) [S10] |
| On-time | closed projects delivered `actual_end ≤ planned_end` share ≥ **75 %** (industry on-time 73.4 % and falling) | B [S3] + D |
| Overrun | mean schedule overrun ≤ **10 %** (SPI: 11.3 % average overrun is already "a concern") | B [S1] + D |
| Realisation | billing realisation ≥ **90 %** — Σ((hours − written-off) × billed rate) ÷ Σ(hours × standard rate); illustrative practice figures run 90–95 % [S5] | D |
| Write-off | written-off hours ≤ **5 %** of billable hours (revenue leakage target < 5 %) | D (SPI leakage 5.3 %) |
| Utilisation | rolling utilisation ≥ 65 % warn / 70 target — SPI benchmark 68.9 % (2024), 66.4 % (2025), optimal 75 %; watched by the `studio` gate | B [S1][S4] |
| Satisfaction | CSAT ≥ **78**, NPS ≥ **+36** (B2B SaaS support medians; P75 85 / +50) | B (P3) [S15][S16] |
| SLA | `p1_response_met_pct ≥ 95`; a promised 99.9 % means monthly downtime ≤ 43 m 50 s | D + B [S14] |
| RMA | `days_to_resolve ≤ 30` — RA 7394 Art. 68(f) repair window (§7) | B statute [S38] |

## §4 Handover, knowledge transfer, close

Handover is a deliverable with its own acceptance row, not a courtesy: source repositories
transferred, credentials rotated into the client's vault, deployment **runbook**, architecture
notes, licence inventory, training session (recorded), and a signed handover checklist. The
knowledge-transfer record is what makes the warranty and any future SLA quotable. Close-out
writes the project P&L — realised rate, write-offs, margin [S5] — and sends the CSAT/NPS survey
[S15]; both land in `ops_monthly.csv` for the board pack.

## §5 Hardware NPI — EVT / DVT / PVT, incoming QC, EMS

Stage gates at **startup scale** (Bolt/EnCata numbers; Instrumental's 100–20,000-unit bands are
consumer-electronics scale, wrong for a PH studio's first runs) [S18][S20][S22]:

| Stage | Units (startup scale) | Exit criterion |
|---|---|---|
| Proto/POC | ≤ 10 | risk areas understood; concept selected [S18] |
| **EVT** | **≤ 20** (Bolt); 3–50 (EnCata) | one configuration passes all functional requirements **from intended materials and intended process** — up to ~40 % of EVT units may fail, that is what EVT is for [S18][S20] |
| **DVT** | 2–5× EVT | mass-production yields verified on one production-worthy design; **every part off its first hard tool**; reliability/abuse, regulatory pre-tests (EMC), cosmetic golden samples [S18][S20] |
| **PVT** | ≈ 10 % of first run | yields verified **at line speed**; units sellable; packaging passes transport tests (ISTA-3A) [S19][S20] |
| MP | — | continuous quality; good runs yield **≈ 98 %** — a lower yield accepted as "normal" is a margin leak [S20] |

Skipping the DVT hard-tool qualification is the classic PVT yield collapse [S18]; an EVT built
from non-production parts is false confidence [S18].

**Incoming QC**: attribute sampling per **ANSI/ASQ Z1.4**, General Inspection Level **GII**, AQL
**critical 0 / major 2.5 / minor 4.0** [S23][S24]. Worked example: lot 4,000 → code L → sample
200; at AQL 2.5 accept ≤ 10 majors, reject ≥ 11 [S23]. Every lot gets a row in `ops/lots.csv`
(`lot_id sku lot_size aql_level code_letter sample_n critical_found major_found minor_found
ac_major re_major result`); the `regulatory` gate (optional second argument) blocks a lot
recorded accept with criticals > 0 or majors over Ac. Pair sampling with 100 % functional test
for electronics — AQL does not catch systemic defects.

**EMS / contract manufacturer RFQ package** [S25]: cover letter with production start date and
volumes, BOM with AVL (approved vendor list), assembly + fab drawings, Gerbers, test
specification, labour/process expectations, packaging spec, firmware load process, certifications
required, NRE expectations, trade-compliance notes. An incomplete RFQ buys vague, padded quotes.
**MOQ and tooling are commitments, not details**: 5,000-unit final-assembly MOQs are common in
China [S20]; injection tooling ≈ $6.5k (China) and tooling runs 60–70 % of NRE (brief 05/12
numbers) — both are cash the studio cannot un-spend, so they are human-gated PO rows.

## §6 Regulatory ship-blockers (`score-guild.sh regulatory`, emits `SHIP_BLOCKERS: N`)

`ops/regulatory.csv` — `sku product_name has_radio ntc_status ntc_cert_no ntc_model_name
marketed_model_name bps_mandatory ps_icc_status cert_expiry consumer_product warranty_text_days
service_invoice_guaranty_days service_line template_text`.

- **NTC type approval / type acceptance** (MC 02-01-2001): no CPE connects to the public network
  without a certificate (§I(c)); WiFi/BT/SRD radios are covered (MC 03-05-2007); the NTC may
  accept foreign test reports at its discretion; tests take ≤ 15 working days, lead time ≈ 8
  weeks, validity unlimited, local representative required [S32][S33]. **One certificate per
  marketing model**: a change of trade name or model number needs a new certificate even without
  retest (§I(d)); a host product is approved per integrated RF module (NTC memo 7 Aug 2019)
  [S32][S34]. Gate: `has_radio = Y ⇒ ntc_status ∈ approved|accepted ∧ ntc_cert_no present ∧
  ntc_model_name = marketed_model_name ∧ certificate not expired`. Fixing the **radio
  architecture** (pre-certified module vs custom RF) early decides this whole path (§10).
- **DTI-BPS PS mark / ICC sticker**: products on the mandatory certification list — 111 products
  in 9 categories including extension cords, LED lamps, wires, breakers, EV chargers, 25
  appliances — must bear the PS mark (local manufacturer, needs ISO 9001 + product PNS) or ICC
  sticker (importer, per shipment) **before distribution** [S27][S28][S29][S30]. The list moves;
  check every SKU against it at design time and design to the PNS from day one. Gate:
  `bps_mandatory = Y ⇒ ps_icc_status = valid`.
- **Template lint**: `template_text` (inline or a path to the warranty card / receipt / listing
  template) must not contain "No Return, No Exchange" [S39][S40].

## §7 Consumer Act floors, RMA, fulfillment, online listings

**RA 7394 (Consumer Act) floors** — statutory minimums for consumer products; the studio's
engineering *services* sit in the Art. 70 professional-services carve-out, its *products* do not
[S37][S38]:

- Implied warranty of merchantability: **not less than 60 days nor more than 1 year** following
  the sale (Art. 68(e)) — so `warranty_text_days ≥ 60` on every consumer product.
- On breach: consumer elects repair or refund; repair must conform **within 30 days** (Art.
  68(f)), extendable only for causes beyond the warrantor's control; refund is net of use.
- Service invoices: workmanship + spare parts guaranteed **≥ 90 days, indicated on the invoices**
  (Art. 71).
- DAO 2 s.1993: remedies (replace / refund / proportionate price reduction) attach to **hidden
  defects**; change-of-mind returns are not required — but "No Return, No Exchange" wording is
  prohibited everywhere [S39][S40].

**RMA ledger** (`ops/rma.csv` — `rma_id order_id sku received_date defect_class
remedy{repair,replace,refund} resolved_date days_to_resolve`): `days_to_resolve ≤ 30`, open RMAs
older than 30 days count as violations (the `delivery` gate reads this when present).

**Fulfillment / COD facts** (P3 blogs — verify at contract time): COD is **13–23 % of PH
e-commerce payments** (2024) despite a stated preference of 71 % of shoppers — track actual COD
share, do not build a COD-heavy plan on the preference number [S44][S45]. Courier COD fees run
2.3–3 % (+ VAT), caps ₱25k–₱50k per parcel, remittance weekly or twice-weekly — that cadence is
working capital. Delivery norms: Metro Manila 1–3 business days, Luzon 3–5, interisland 5–7;
base rates ₱60–110, shipping ≈ 10–15 % of order value [S43][S44][S45]. Choose the courier
contract with the same care as a bank: remittance cadence and RTS (return-to-sender) handling
are cash terms.

**Online-listing lint (Internet Transactions Act, RA 11967 + JAO 24-03)** [S41][S42]: every
listing/marketplace page carries trade name, business address, contact information, price
consistent with the Consumer Act, delivery period, and the return/refund/warranty policy;
invoices issued at all times (paper or electronic); the business registers in the DTI Online
Business Database once established. The `assets` gate lints listings; the compliance register
holds the OBD row.

## §8 Ops manual

From ~3 people the studio keeps a 7-section **ops manual** [S17]: company overview; org + roles;
processes & SOPs (delivery lifecycle, change control, release, RMA); policies; vendor list;
emergency procedures; financial procedures. One named owner; review ~20–25 % of the document per
quarter — any section with `last_reviewed` older than **90 days** is stale. A runbook nobody
owns dies with the person who wrote it [S17].

## §9 Human sign-off rows (the loop drafts; a named human acts)

Signing MSA / SOW / change orders · sending any invoice or client e-mail · declaring or accepting
acceptance on the client's behalf · paying EMS/tooling deposits, issuing POs, releasing hard
tooling · submitting NTC / BPS applications · shipping any lot · issuing refunds or replacements
· closing a warranty claim as "unreasonable use" (Art. 68(d) defence) · choosing the courier /
COD terms. The gates only verify that the artefacts and dates exist [brief 08 §5.5].

## §10 Early irreversibles (charter rows with decide-by dates)

1. **IP terms in the first MSA** — assignment on final payment + background-IP carve-out;
   renegotiating later is a client-relationship event [S7].
2. **Engagement model on ambiguous scope** — fixed price without testable acceptance criteria
   locks in the margin loss [S7][S9].
3. **Radio architecture** — module vs custom RF fixes the NTC path and the certificate model
   name that every marketing name must match [S32][S34].
4. **Hard tooling at DVT** — DFM before tooling or pay twice [S18].
5. **EMS + MOQ commitment** — inventory liability lives in the RFQ terms [S20][S25].
6. **BPS-mandatory design-to-PNS** — if the SKU is on the list, design to the standard from day
   one [S28].
7. **Warranty text on packaging/invoices** — statutory floors cannot be reduced after sale [S38].
8. **COD vs prepaid policy and the courier contract** — remittance cadence and caps shape cash
   conversion [S43][S44].
9. **Channel choice** — physical retail loses money per unit at 5,000-unit scale in Bolt's worked
   example [S21].

## §11 Failure modes the gates exist to catch

| Anti-pattern | Guard |
|---|---|
| Work started on a verbal / chat scope change, never billed | change-control check: hours before approval = 0 [S10][S11] |
| Payments tied to dates — cash arrives whether or not work shipped | payment-line lint (milestone ids only) [S9] |
| "As-is", no IP clause, 100 % upfront or 100 % at end | SOW red-flag lint [S7] |
| No review window → UAT never ends | review_window_days + deemed acceptance [S8] |
| EVT from non-production parts → false confidence | EVT exit: intended materials + process [S18] |
| DVT tools skipped → PVT yield collapse | DVT exit: all parts hard-tooled [S18] |
| Sub-98 % MP yield normalised | PVT/MP yield threshold [S20] |
| WiFi product sold before NTC, or under a different model name | regulatory gate [S32][S34] |
| BPS-mandatory item without PS/ICC | regulatory gate [S27][S31] |
| "No Return, No Exchange" on receipts / site / packaging | string lint everywhere [S39][S40] |
| 24/7 P1 promised by a 5-person team | SLA staffing cross-check (human review) [S13] |
| Utilisation slides while founders sell and deliver | monthly utilisation row → `studio` gate [S3][S4] |
| Consumer repair dragging past 30 days | RMA days_to_resolve [S38] |
| Ops knowledge in one head | ops-manual owner + 90-day review [S17] |

## §12 Gate surface (env overrides; defaults in brackets)

| Gate | Emits | Overrides |
|---|---|---|
| `sow <sow.md>` | `SOW_MISSING: N` | `GUILD_SOW_DEPOSIT_MIN` [20] · `GUILD_SOW_WARRANTY_MIN` [30] · `GUILD_SOW_SERVICE_WARRANTY_MIN` [90] |
| `delivery <dir>` | `DELIVERY_VIOLATIONS: N` | `GUILD_DEPOSIT_MIN` [20] · `GUILD_CO_REBASELINE_PCT` [25] · `GUILD_ONTIME_MIN` [75] · `GUILD_OVERRUN_MAX` [10] · `GUILD_REALISATION_MIN` [90] · `GUILD_WRITEOFF_MAX` [5] · `GUILD_RMA_MAX_DAYS` [30] |
| `regulatory <regulatory.csv> [lots.csv]` | `SHIP_BLOCKERS: N` | `GUILD_CONSUMER_WARRANTY_MIN` [60] · `GUILD_SERVICE_GUARANTY_MIN` [90] |

All three: one stdout line, detail to stderr, exit 0 on valid data (violations included), exit 2
on hard error. Date comparisons use `GUILD_TODAY`, else the ledger's `# as_of: YYYY-MM-DD` line,
else the system date — fixtures always carry `as_of` so the frozen scorer never decays.
