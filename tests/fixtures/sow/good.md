# as_of: 2026-09-02
# Statement of Work SOW-2026-007 — Sukat W1 cold-room logger: pilot firmware + monitoring dashboard

msa_reference: MSA-2026-003 (Sigla Engineering Studio OPC ↔ Mabuhay Cold Chain Corp., countersigned 2026-05-11; legal terms — confidentiality, warranties, indemnities, governing law — live in the MSA; this SOW carries commercial terms only)
engagement_type: software
review_window_days: 5
deposit_pct: 30
warranty_days: 60
support_sla_reference: none
liability_cap: 1× the total fees paid under this SOW; carve-outs for IP infringement, breach of confidentiality and wilful misconduct per MSA §11
change_control_reference: MSA §7 (Change Control) and the change-order form in Annex C

## scope_in
- Firmware for the Sukat W1 logger (ESP32-C3 module, pre-certified radio) reporting temperature and door-open events every 60 s over WiFi to the Mabuhay dashboard.
- A web dashboard (Next.js, PostgreSQL) for 3 cold rooms at the Laguna plant: live readings, 30-day history, threshold alarms by SMS/Viber.
- Deployment on Mabuhay's existing VPS and a 2-week pilot with 12 loggers supplied under PO-2026-118.

## deliverables
| id | deliverable | format |
|---|---|---|
| D-1 | Firmware release candidate | tagged git release `fw-v1.0.0-rc` + signed binary + release notes (PDF) |
| D-2 | Dashboard release | tagged git release `dash-v1.0.0` + Docker image + admin guide (PDF) |
| D-3 | Pilot report | PDF: uptime, alarm precision/recall, open defects, recommendations |
| D-4 | Handover pack | repo access transfer, credentials in Mabuhay's vault, runbook (Markdown), 2-hour training session recording |

## acceptance_criteria
- D-1: 12 loggers report for 72 h continuously with ≤ 1 % missed samples; reconnect within 120 s after a WiFi drop; measured error ≤ ±0.5 °C against the calibrated reference at 2 °C and 8 °C.
- D-2: every user story in Annex A passes its listed test; alarm delivered within 90 s of threshold breach in 10 of 10 trials; page load < 2 s on the plant's 10 Mbps link.
- D-3: report delivered with the metrics above measured over the 14-day pilot.
- D-4: Mabuhay's IT lead signs the handover checklist in Annex D.

## review_window
Mabuhay reviews each deliverable within 5 business days of the delivery notice (review_window_days: 5) and returns either written acceptance or an itemised defect list referencing the acceptance criteria. If neither arrives within the window the deliverable is deemed accepted and the linked milestone invoice issues.

## assumptions_client_dependencies
- Mabuhay provides plant WiFi credentials, VPS access and the calibrated reference thermometer by kickoff.
- Mabuhay names one product owner with authority to accept deliverables.
- 12 loggers from PO-2026-118 are on site before M-2 begins.

## out_of_scope
Mobile apps, integration with Mabuhay's SAP instance, cold-room retrofits, NTC filings for any radio other than the pre-certified module, and support beyond the warranty period. Any work not set forth in scope_in is out of scope and requires a change order under MSA §7 — no signature, no work.

## change_control
Written change request → Sigla estimate within 2–5 business days → Mabuhay written approval (Annex C form, e-mail approval accepted for changes under 5 hours or ₱20,000) → work begins. Cumulative approved changes above 25 % of the contract value trigger a rebaseline of milestones and dates.

## milestones
| id | deliverable | evidence of completion | planned_date |
|---|---|---|---|
| M-0 | contract signature | countersigned SOW + deposit invoice | 2026-05-11 |
| M-1 | D-1 firmware release candidate | release tag + 72-hour bench log | 2026-06-19 |
| M-2 | D-2 dashboard release + pilot start | release tag + pilot kickoff minutes | 2026-07-10 |
| M-3 | D-3 pilot report + D-4 handover | signed handover checklist | 2026-08-07 |
| M-4 | warranty expiry | defect log closed | 2026-10-06 |

## payment_schedule
Total fees ₱1,200,000 exclusive of VAT; subject to creditable withholding at the client's applicable rate (BIR Form 2307 to follow each payment).
- 30 % (₱360,000) deposit on M-0 — invoiced on countersignature, payable before kickoff.
- 30 % (₱360,000) on acceptance of M-1.
- 35 % (₱420,000) on acceptance of M-3, less a 5 % warranty holdback (₱60,000).
- 5 % (₱60,000) holdback released at M-4 when the warranty defect log is closed.

## ip_ownership
Deliverables D-1 to D-4 are assigned to Mabuhay upon receipt of final payment for the milestone that produced them (RA 8293 §180 written assignment). Background IP — Sigla's sensor drivers, OTA bootloader, dashboard component library and test rigs — remains Sigla's property; Mabuhay receives a perpetual, non-exclusive, royalty-free licence to the background IP embedded in the deliverables. Open-source components keep their own licences (listed in the release notes).

## warranty
Sigla warrants D-1 and D-2 against defects for 60 days from acceptance of M-3 (warranty_days: 60): reproducible deviations from the acceptance criteria are fixed at no charge; fixes are delivered within 10 business days of report. The 5 % holdback is released at M-4.

## support_sla
None under this SOW. Post-warranty support is available under the retainer SOW template (P1 respond 1 h / resolve 8 h business hours; P2 4 h / next business day; P3 next business day / 5 business days) if elected.

## key_personnel
- J. Diwangan — engagement lead and firmware (Sigla); replacement only with Mabuhay's written consent.
- R. Salazar — dashboard lead (Sigla).
- A. Villanueva — product owner and acceptance authority (Mabuhay).

## termination
- For cause: either party may terminate on written notice if a material breach is not cured within 14 days of notice.
- For convenience: Mabuhay may terminate on 30 days' written notice; fees for accepted milestones and for work in progress at the day rate in Annex B are payable; the deposit is non-refundable once M-1 has started.

## liability_cap
Each party's aggregate liability under this SOW is capped at 1× the total fees paid (MSA §11), except for IP infringement, breach of confidentiality and wilful misconduct.
