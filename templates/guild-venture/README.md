# Venture tree — the layout `/guild:build` creates in a venture's own private repo

Every directory is a ledger set that one or more `scripts/score-guild.sh` gates read. Files marked
**HUMAN** are human-entered: the loop reads them and drafts candidate rows into `drafts/`, but never
writes to them (a diff touching them is reverted). Every ledger with dates starts with a
`# as_of: YYYY-MM-DD` comment so gates evaluate against a declared date, not the system clock.

```
venture.spec.yaml            the validated spec from /guild:discover (score-guild.sh validate)
charter.md                   the early-irreversibles register with decide-by dates + owners
guild-results.tsv            acceptance ledger: n dimension assertion status weight evidence traces
vrs/requirements.md          V-n rows (assumption + metric + threshold + test method + owner + decide-by)
evidence/                    sources.tsv (13 cols, archived + hashed) · claims.tsv · S-<n>.md reading notes
discovery/                   assumptions.csv · segments.csv (election = HUMAN sign-off)
                             interviews.tsv HUMAN · consent.tsv HUMAN · commitments.csv HUMAN · codes.csv
market/                      charter.csv · factors.csv · claims.csv · alternatives.csv · snapshots.csv
                             five-forces.csv · why-now.csv
offer/                       positioning.yaml · offers.yaml · messaging.yaml · narrative.md · one-pager.md
                             pitch_tests.csv HUMAN
pricing/                     price-book.csv · tax-status.csv HUMAN · competitor-band.csv
                             wtp-interviews.csv HUMAN · discount-log.csv · price-change-log.csv
economics/                   metric-dictionary.csv · model.csv · assertions.tsv · cash13.csv
                             variance.csv (actuals HUMAN) · studio-ledger.csv
gtm/                         hypothesis.md · plan.md · playbook.md · targets.tsv · leads.csv
                             pipeline.tsv HUMAN · outreach.csv HUMAN-approved
marketing/                   plan.md · channel-plan.csv · assets.csv + assets/ · calendar.csv
                             experiments.csv · consent.csv HUMAN · spend.csv HUMAN-approved
ops/                         msa.md · sow-template.md · projects.csv HUMAN · milestones.csv HUMAN
                             change_orders.csv HUMAN · time.csv HUMAN · regulatory.csv HUMAN · lots.csv · rma.csv
finance/                     policy.md · ar_ledger.csv HUMAN · wtax_2307_ledger.csv HUMAN · rail_fees.csv
compliance/                  profile.yaml HUMAN · register.csv (documents + sign-offs HUMAN) · evidence/
board/                       founders-agreement.yaml HUMAN · kpi-tree.yaml · kill-criteria.csv · plan.csv
                             kpi_actuals.csv · cash_ledger.csv · decisions.tsv · risks.csv · pack-YYYY-MM.md
drafts/                      everything the loop prepares for a human to send, sign, file, enter or decide
guild/                       run directories (loop-*, build-*, board-*, improve-*, evals-*)
```

Gate → ledger map: `sources`/`claims`/`citations` → evidence/ · `interviews`/`icp`/`vrs` →
discovery/, vrs/ · `market`/`competitors` → market/ · `positioning`/`offers` → offer/ · `pricing`
→ pricing/ · `economics`/`cash`/`alive`/`studio` → economics/, board/cash_ledger.csv ·
`funnel`/`paying`/`experiments`/`assets`/`consent` → gtm/, marketing/ · `sow`/`delivery`/
`regulatory`/`ar` → ops/, finance/ · `compliance` → compliance/ · `board`/`decisions`/`founders`
→ board/ · `pass-rate`/`coverage`/`validate`/`verdict` → the root files.

The template ledgers in this directory are header-only (plus `# as_of`) and pass their own gates —
a fresh venture starts clean, not red.
