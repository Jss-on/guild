# as_of: 2026-09-02
# Statement of Work SOW-2026-008 — Sukat W1 cold-room logger: pilot firmware + monitoring dashboard (draft with defects)

msa_reference: MSA-2026-003 (Sigla Engineering Studio OPC ↔ Mabuhay Cold Chain Corp., countersigned 2026-05-11)
engagement_type: software
deposit_pct: 30
warranty_days: 14
support_sla_reference: none
liability_cap: 1× the total fees paid under this SOW; carve-outs per MSA §11
change_control_reference: MSA §7 (Change Control) and the change-order form in Annex C

## scope_in
- Firmware for the Sukat W1 logger (ESP32-C3 module, pre-certified radio) reporting temperature and door-open events every 60 s over WiFi.
- A web dashboard for 3 cold rooms at the Laguna plant: live readings, 30-day history, threshold alarms by SMS/Viber.

## deliverables
| id | deliverable | format |
|---|---|---|
| D-1 | Firmware release candidate | tagged git release + signed binary + release notes (PDF) |
| D-2 | Dashboard release | tagged git release + Docker image + admin guide (PDF) |
| D-3 | Pilot report | PDF |
| D-4 | Handover pack | repo transfer, credentials, runbook, training recording |

## acceptance_criteria
- D-1: 12 loggers report for 72 h continuously with ≤ 1 % missed samples; error ≤ ±0.5 °C at 2 °C and 8 °C.
- D-2: every user story in Annex A passes its listed test; alarm within 90 s in 10 of 10 trials.
- D-3: report delivered with the metrics above.
- D-4: Mabuhay's IT lead signs the handover checklist.

## assumptions_client_dependencies
- Mabuhay provides plant WiFi credentials, VPS access and the calibrated reference thermometer by kickoff.
- Mabuhay names one product owner with authority to accept deliverables.

## out_of_scope
Mobile apps, SAP integration, cold-room retrofits and support beyond the warranty period. Any work not set forth in scope_in is out of scope and requires a change order under MSA §7.

## milestones
| id | deliverable | evidence of completion | planned_date |
|---|---|---|---|
| M-0 | contract signature | countersigned SOW + deposit invoice | 2026-05-11 |
| M-1 | D-1 firmware release candidate | release tag + 72-hour bench log | 2026-06-19 |
| M-2 | D-2 dashboard release + pilot start | release tag + pilot kickoff minutes | 2026-07-10 |
| M-3 | D-3 pilot report + D-4 handover | signed handover checklist | 2026-08-07 |

## payment_schedule
Total fees ₱1,200,000 exclusive of VAT.
- 30 % (₱360,000) on 2026-05-15.
- 30 % (₱360,000) on 30 June 2026.
- 40 % (₱480,000) on 2026-08-31.

## ip_ownership
Deliverables are assigned to Mabuhay upon receipt of final payment. Background IP — Sigla's sensor drivers, OTA bootloader and dashboard component library — remains Sigla's property under a perpetual, non-exclusive licence to Mabuhay.

## warranty
Sigla warrants D-1 and D-2 against defects for 14 days from delivery (warranty_days: 14). Deliverables are otherwise provided as-is. No Return, No Exchange.

## key_personnel
- J. Diwangan — engagement lead and firmware (Sigla).
- A. Villanueva — product owner and acceptance authority (Mabuhay).

## termination
- For cause: either party may terminate on written notice if a material breach is not cured within 14 days of notice.
- For convenience: Mabuhay may terminate on 30 days' written notice; fees for accepted milestones and work in progress are payable.

## liability_cap
Each party's aggregate liability under this SOW is capped at 1× the total fees paid (MSA §11).
