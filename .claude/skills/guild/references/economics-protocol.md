# Economics Protocol — the driver register, corners, cash, default-alive and studio KPIs

Companion to `/guild:build` P7 and every `/guild:board` cycle. The business analogue of anvil's
worst-case simulation gate: **an offer whose model does not close at the worst corner is not an
offer, it is a hope** — and `economics` is a must-pass dimension, so a red row here blocks the
verdict. Research basis: briefs 05 (unit economics), 12 (studio business model), 10 (finance ops)
and 11 §5.2 (default-alive) in `research/raw/`, plus the numbers annex `references/benchmarks.md`.
Citation convention: `[05:S8]` = brief 05, source S8 (each brief's §8 has the URL, type and grade);
provenance grades P1/P2/P3 as defined there. Thresholds with no published rule are tagged
**policy** and are env-overridable (`GUILD_*`, §15) — never presented as literature.

Gates: `score-guild.sh economics <model.csv> <assertions.tsv>` → `ECON_PASS: x/y` ·
`cash <cash13.csv> [variance.csv]` → `CASH_PASS: x/y` · `alive <cash_ledger.csv>` →
`DEFAULT_ALIVE: 1|0` · `studio <studio-ledger.csv>` → `STUDIO_PASS: x/y`. One stdout line each;
per-row PASS/FAIL with value, threshold and rule on stderr; exit 2 only on hard error.

## §0 The five rules

1. **Inputs are never calculations** (the FAST standard — Flexible, Appropriate, Structured,
   Transparent [05:S37] P1). `model.csv` holds *drivers* only; every derived metric (LTV, landed
   cost, runway…) is computed by the gate. A derived-metric name typed in as a driver is a
   register violation: the loop cannot "type in" a passing LTV.
2. **Every driver states how it knows.** `evidence ∈ measured|quote|statute|benchmark|assumption`;
   benchmark and statute rows carry `source_id`; measured rows carry `measured_from` (the ledger,
   bank line, anvil output or forge run the number can be re-read from); assumption rows are
   surfaced as **open risks** in every verdict until discovery or sales evidence converts them.
3. **Worst corner wins.** Every assertion that matters holds at the worst corner, not the base
   case; margins are recorded maximin. A model that only closes at base is default-fragile.
4. **Cash is a weekly ledger, not a quarterly slide.** The 13-week direct-method forecast is
   reconciled to actuals weekly [10:S47] P2; default-alive is recomputed monthly from the cash
   ledger [11:1] P1.
5. **Statutes have dates.** PH statute drivers carry the RA/RR/wage-order id, the effective date
   and `last_verified`; a statute row older than 12 months is re-verified before it is relied on
   (this domain moved in 2018, 2021, 2024, 2025 and 2026).

## §1 Metric dictionary — declare the business model first

The first deliverable of P7 is `economics/metric-dictionary.csv`
(`metric, formula, inclusions, exclusions, source`) because metric definitions drift and a16z
lists definitional drift as the top startup-metrics mistake (bookings counted as revenue,
LTV on revenue instead of net profit) [05:S3] P1. Declare the model mix and its dictionary:

| Model | The metrics that rule | Dictionary notes |
|---|---|---|
| **Recurring (SaaS)** | ARR/MRR, gross margin, gross + net churn, NRR/GRR, CAC (paid AND blended), LTV, CAC payback, burn multiple, runway | ARR excludes one-time fees; churn reported gross *and* net (net alone "understates the losses" [05:S3]); paid CAC is the scaling number, blended is informational [05:S3][05:S7] |
| **Hardware (transactional)** | landed cost (fully loaded COGS), contribution margin per unit, channel margin, sell-through, inventory turns, cash conversion cycle, working capital | BOM ≠ landed cost — Bolt's worked stack: MSRP $99, BOM $32.16, fully loaded ≈ $65.80 at 5k units [05:S25] P1 |
| **Services (studio)** | billable utilisation, realisation, project margin, revenue per billable FTE, overrun, leakage, DSO, EBITDA | SPI's five-that-matter list [12:S1] P1; delivery margin centres ~35 %, **not** the 40–60 % folklore (v0.0.1 correction) |

Gross margin is the equalizer across all three [05:S4] P1: software ideal 80–90 %, Bessemer
private-cloud floor 65–70 % [05:S8] P1; hardware ≥ 50 % direct or "your price is too low"
[05:S28] P1, ≥ 30 % hard floor (**policy**); services delivery/project margin ≥ 35 % [12:S1] P1.

## §2 The driver register — `economics/model.csv` (validator: `score-guild.sh economics`)

```
driver_id,name,unit,segment,base,worst,best,evidence,source_id,measured_from,owner,last_verified
```
First line `# as_of: YYYY-MM-DD` (fixes staleness checks). Loader rules (each breach is a
register violation counted by `register_violations`, asserted by ALL-03; the offending row is
still listed on stderr):

- `evidence ∈ measured|quote|statute|benchmark|assumption` — nothing else, "guess" is not a class.
- `benchmark` and `statute` rows ⇒ non-empty `source_id` (a benchmark without a source is an
  assumption wearing a costume).
- `measured` rows ⇒ non-empty `measured_from` — a re-readable seam: `ledger:<path>`,
  `bank:<account-statement>`, `anvil:<product>:BOM_COST`, `forge:<run-dir>` (§6).
- `assumption` rows are legal but land on the **open-risk list** in every run; only evidence
  converts them (Gurley: the LTV inputs are interdependent predictions, not facts [05:S7] P1).
- A **derived-metric name typed as a driver** (`ltv`, `landed_cost`, `runway_months`,
  `project_margin`, …) violates the FAST inputs-≠-calculations rule [05:S37]: the row is ignored
  and the violation counted — documented choice: *violation, not hard error*, so the rest of the
  model still reports and the scorer still sees `ECON_PASS: x/y` with x < y.
- Non-numeric corner values: violation, row ignored. Missing file / missing columns / zero rows:
  hard error (exit 2).

**The driver vocabulary** (design contract for the loop; segment tags `saas_*`, `hw_*`, `svc`,
`all` are informational):

| Family | Drivers |
|---|---|
| Recurring | `price_arpa` (PHP/account/mo), `gm_pct`, `churn_m`, `expansion_m`, `cac_paid`, `cac_blended` |
| Company P&L | `revenue_m`, `cogs_m`, `sm_monthly`, `opex_fixed`, `cash_open`, `new_arr_monthly`, `growth_m` |
| Hardware | `bom_unit`, `asm_test_pack_unit`, `freight_duty_unit`, `scrap_pct`, `warranty_pct`, `price_unit`, `channel_margin`, `tooling_total`, `moq_units`, `first_run_units` (defaults to `moq_units`), `deposit_pct`, `units_monthly`, `dso_days`, `dio_days`, `dpo_days` |
| Services | `bill_rate`, `utilization`, `annual_hours`, `loaded_cost_fte`, `delivery_cost_pct`, `overrun_pct` |
| Shared / PH | `top_client_share`, `wage_floor`, `sss_er_pct`, `philhealth_er_pct`, `pagibig_er_php`, `ec_er_php`, `cit_rate`, `vat_rate`, `vat_registered`, `total_assets`, `nti_annual`, `years_operating` |

## §3 Corners and sensitivity

**Corners.** `base`, `worst`, `best` are three *scenario-consistent* columns per driver (CFI
scenario mechanics: full duplicate assumption sets, identical layout [05:S34] P2; BSP itself
publishes alternative scenarios beside its central projection [05:S43] P1). "Worst" is a coherent
bad world — churn up, CAC up, channel margin at physical retail, DSO at Bolt's 150 observed days
[05:S27] P1 — not per-cell pessimism.

**Sensitivity / tornado (ALL-02).** One driver at a time, ±20 % (`GUILD_SENS_PCT`, **policy**) at
the base corner, over the *uncertain* classes — `assumption` and `benchmark` rows (`measured` and
`quote` rows are facts about this business, `statute` rows are law; `GUILD_SENS_ALL=1` widens the
sweep to every non-statute driver). `fragility` = the number of base-corner assertions flipped
pass→fail by any single move; the gate prints a tornado listing (drivers ranked by flips) on
stderr. ALL-02 asserts `fragility le 0`: a model that dies when one uncertain driver moves 20 %
is not a plan, it is a coin toss (Gurley's interdependence critique [05:S7]).

## §4 Derivations (what the gate computes — never typed in)

**Recurring** [05:S1][05:S2][05:S3][05:S19]:
- `lifetime_months = min(1 ÷ churn_m, 24)` — LTV is measured on **contribution (gross-margin
  adjusted, on net profit — never on revenue)** and **capped at 24 months** (a16z: prefer measured
  12/24-month LTV over projected lifetimes [05:S3] P1).
- `ltv = price_arpa × gm_pct × lifetime_months` · `ltv_cac = ltv ÷ cac_paid` (paid CAC — the
  fully loaded S&M cost per *paid* customer — not blended; blended flatters [05:S3][05:S7]).
- `cac_payback = cac_paid ÷ (price_arpa × gm_pct)` months — GM-adjusted per Skok's original with
  the Aleph/Benchmarkit margin adjustment [05:S2][05:S19] P1 (the cohort form
  S&M ÷ (new ARR × GM %) × 12 is identical when CAC is computed from the same S&M).
- `net_churn_m = churn_m − expansion_m`; report gross AND net; NRR/GRR are the annual
  complements — benchmark NRR by ACV band ($5–25k ≈ 100 % … $100k+ ≈ 110 % [05:S14] P1; B2B
  bottom-up median 82 %, AI-native 48 % [05:S15] P1 — never borrow the wrong band).
- `new_customers_m = sm_monthly ÷ cac_paid` (informational).

**Company level** [05:S3][05:S5]:
- `gross_profit_m = revenue_m − cogs_m` · `fixed_monthly = opex_fixed + sm_monthly` ·
  `net_burn = fixed_monthly − gross_profit_m` (≤ 0 ⇒ profitable).
- `runway_months = cash_open ÷ net_burn` (999 when profitable) — Bessemer runway tiers 12/18/24+
  months good/better/best [05:S10] P1.
- `burn_multiple = net_burn ÷ new_arr_monthly` — Sacks: ≤ 2 reasonable early-stage, seed ~3,
  5× terrible [05:S5] P1; 0 when net burn ≤ 0.
- **Break-even and default-alive simulation** (UE-07/UE-09): revenue compounds at `growth_m`,
  costs held at `fixed_monthly`, margin at the blended rate; `break_even_month` = first month
  gross profit covers fixed costs (contribution-margin break-even, CFI: break-even units =
  fixed ÷ CM per unit [05:S35] P2 — `break_even_accounts` and `break_even_units` report the same
  point in units); `cash_out_month` = first month simulated cash < 0; `be_gap_months` =
  cash_out − break_even must be ≥ 0 at base AND worst; `default_alive` = 1 iff break-even comes
  first (Paul Graham's question, mechanized [05:S39] P1).

**Hardware landed cost** [05:S25][05:S26][05:S27][05:S28][05:S31][05:S36]:
- `landed_cost = (bom_unit + asm_test_pack_unit + freight_duty_unit) ÷ (1 − scrap_pct)
  + warranty_pct × price_unit` — fully-loaded COGS: BOM + assembly + test + packaging + freight +
  duties, divided by yield (scrap ~5 % on a first run → ~0.5 % after cycles [05:S26] P1), plus the
  warranty reserve booked at sale (ASC 460; the rate itself is UNVERIFIED in the literature —
  model it as an assumption [05:S31] P2).
- `channel_net_price = price_unit × (1 − channel_margin)` — channel margin bands: e-tail 15–20 %,
  specialty retail 30–35 % (to 40 %+), keystone 50 %, distributor 10–15 % [05:S27] P1.
- `cm_unit = channel_net_price − landed_cost` (contribution margin per unit) · `hw_gm = cm_unit ÷
  channel_net_price` — checked per channel row, every corner.
- `landed_cost_amortised = landed_cost + tooling_total ÷ first_run_units` (HW-04: tooling, NRE and
  certification amortised into run-1 economics — Bolt: tooling ~$6.5k/tool in China, certification
  ≥ $15k [05:S26] P1).
- `first_po_cash = deposit_pct × moq_units × landed_cost + tooling_total` — the CM wants ~50 %
  down on a ~5k MOQ [05:S26] P1; HW-02 requires it to fit inside cash minus a
  `GUILD_PO_RESERVE_MONTHS` (6, **policy**) cushion of fixed costs.
- `ccc_days = dio_days + dso_days − dpo_days` (cash conversion cycle, DIO + DSO − DPO [05:S36]
  P2) · `working_capital = ccc_days ÷ 30 × units_monthly × landed_cost`; worst corner uses DSO 150
  if any physical retail (PO terms 90 days, actual ~150 [05:S27] P1).

**Services** [12:S1]: `project_margin = 1 − delivery_cost_pct` · `revenue_per_fte = bill_rate ×
utilization × annual_hours` · `revenue_per_fte_ratio = revenue_per_fte ÷ loaded_cost_fte`.

**PH statute** (§10): `min_wage_loaded_monthly = wage_floor × 26 × (1 + sss_er_pct +
philhealth_er_pct + 1/12) + pagibig_er_php + ec_er_php` (computed from driver rows, never
hard-coded [05 §4]); `cit_rate_effective` = 20 % iff total_assets ≤ ₱100M ∧ NTI ≤ ₱5M else 25 %,
and `cit_rate_gap = cit_rate − cit_rate_effective` must be ≥ 0 (you may model conservatively
high, never below statute); `mcit_rate` = 2 % from year 4; `vat_rate_effective` = 12 % above the
₱3M threshold (or when `vat_registered`), `vat_gap` likewise ≥ 0 [05:S46][05:S47] P2.

## §5 The assertion table — `economics/assertions.tsv`

`id  metric  op  limit  corner  traces` (tab-separated; `op ∈ le|ge|within`, `corner ∈
base|worst|best|all`; `within` = ±`GUILD_WITHIN_PCT` % of the limit, for statute rates; `traces`
joins `V-n` rows and brief source ids). x = passing rows; if no row references
`register_violations` the gate appends ALL-03 itself. The standard table (thresholds carry their
grade; SMB/mid-market/enterprise payback limits are Bessemer's segment bands):

| Row | Assertion | Threshold · corner | Source · grade |
|---|---|---|---|
| UE-01 | `gm_pct` ≥ model floor | SaaS ≥ 0.65 base AND worst; hardware via UE-01h/hw; services via SV-02 | [05:S8] P1; [05:S28] P1; 0.30 HW hard floor **policy** |
| UE-02 | `ltv_cac` | ≥ 3 base (Skok's viability line; best 5–8) · ≥ 1 worst | [05:S1][05:S2] P1 |
| UE-03 | `cac_payback` | ≤ 12 SMB · ≤ 18 mid-market · ≤ 24 enterprise at base (put the elected segment's limit in the row) · ≤ 24 worst | [05:S8] P1 (12/18/24); median 16 mo FY2025 [05:S19] P1 |
| UE-04 | `net_churn_m` | ≤ 2 %/month base — above it "something is wrong" | [05:S1] P1 |
| UE-05 | `burn_multiple` | ≤ 2 base (seed stage: relax the row's limit to 3) | [05:S5] P1 |
| UE-06 | `runway_months` | ≥ 18 base · ≥ 12 worst | [05:S10] P1 tiers |
| UE-07 | `default_alive` | = 1 at base once revenue exists ≥ 8 months | [05:S39] P1 |
| UE-09 | `be_gap_months` | ≥ 0 base AND worst (contribution-margin break-even before cash-out) | [05:S35] P2, [05:S3] P1 |
| HW-01 | `hw_gm` | ≥ 0.30 at ALL corners (hard floor) and ≥ 0.50 base direct (UE-01h) | [05:S25][05:S28] P1 / **policy** |
| HW-02 | `first_po_headroom` | ≥ 0 worst — first PO cash inside cash − 6 months fixed | [05:S26] P1; cushion **policy** |
| HW-03 | `wc_headroom` | ≥ 0 worst — CCC-driven working capital funded after the PO | [05:S36] P2, [05:S27] P1 |
| HW-04 | `hw_gm_amortised` | ≥ 0.30 base — tooling amortised at run-1 volume still clears the floor | [05:S25] P1 |
| SV-01 | `utilization` | ≥ 0.70 base (SPI healthy floor; optimal 0.75) · ≥ 0.60 worst | [12:S1] P1; worst **policy** |
| SV-02 | `project_margin` | ≥ 0.35 base | [12:S1] P1 (35.9 % avg) |
| SV-03 | `revenue_per_fte_ratio` | ≥ 1.5 base (plan on 2×) — the PH-derived form of SPI's $200k/consultant, USD thresholds stay informational | [12:S1] P1 |
| SV-04 | `overrun_pct` | ≤ 0.10 base (measured from timesheets) | [12:S1] P1 (> 10 % concern) |
| ALL-01 | `top_client_share` | ≤ 0.20 base (red at 0.25 in the studio gate) | [05:S4] P1 example; 20 % **policy** |
| ALL-02 | `fragility` | ≤ 0 base (±20 % sweep, §3) | [05:S34] P2; **policy** |
| ALL-03 | `register_violations` | ≤ 0 all — §2 rules, incl. every benchmark/statute row cites and every assumption is an open risk | [05:S37] P1 |
| PH-01 | `wage_floor` ≥ 780 worst; `sss_er_pct` within 0.10, `philhealth_er_pct` within 0.025, `pagibig_er_php` within 200 (all corners) | wage worst = the HIGHER of the enjoined and un-enjoined floors (§10) | [05:S48] P1, [05:S49] P2, [05:S50] P2 |
| PH-02 | `cit_rate_gap` ≥ 0 all · `vat_gap` ≥ 0 all — tax rates computed from thresholds, not typed | CIT 25 % / 20 % small-corp; MCIT 2 % yr 4+; VAT 12 % above ₱3M | [05:S46][05:S47] P2 |

(UE-08, the 13-week floor + variance check, lives in the `cash` gate — §7. HW rows apply only
when hardware drivers exist; SV rows when services drivers exist; a metric the model cannot derive
fails its row, so the assertions file must match the declared model.)

## §6 The cross-harness COGS seam (anvil PRODUCT_COST / BOM_COST, forge)

COGS drivers are **measured from the build harnesses**, not estimated twice:

- **anvil → guild:** `score-anvil.sh product-bom <product-bom.csv>` emits
  `PRODUCT_COST: X.XX CUR` (full-unit cost+mass rollup) and `score-anvil.sh bom-cost <bom.csv>
  <catalog.csv>` emits `BOM_COST: X.XX CUR` (pinned-catalog BOM). The `bom_unit` driver is typed
  `measured` with `measured_from: anvil:<product>:BOM_COST` (or `…:PRODUCT_COST` when assembly is
  already inside anvil's rollup — never double-count `asm_test_pack_unit` in that case). Hardware
  regulatory rows (NTC / BPS) also flow from anvil's product spec into `ops/regulatory.csv`.
- **forge → guild:** forge emits no cost token; the software COGS/delivery drivers cite the run
  itself — `measured_from: forge:<run-dir>/handoff.json` for build effort (iterations, wall time)
  priced at the loaded rate, and the hosting/API line from the venture's expense ledger. A SaaS
  `cogs_m` that nobody can trace to a forge run or a hosting invoice is an `assumption`, and says
  so.
- Quotes from CMs/EMS (`asm_test_pack_unit`, `tooling_total`, `moq_units`, `deposit_pct`,
  `dpo_days`) are `quote` rows carrying the quote id; a quote older than its validity window is
  re-verified before a PO draft is even prepared (the PO itself is human-gated, §11).

## §7 13-week cash — `economics/cash13.csv` + `economics/variance.csv` (gate: `cash`)

Direct-method weekly forecast (Wall Street Prep TWCF [10:S47] P2; brief 10 §5a schema):
`week_start, opening_cash, rcpt_ar, rcpt_new_sales, rcpt_other, disb_payroll,
disb_rent_overhead, disb_vendors_components, disb_taxes, disb_debt_service, disb_capex,
net_flow, closing_cash, min_cash_floor, actual_closing, variance` — first line
`# as_of: YYYY-MM-DD`. Actuals for elapsed weeks are **human-entered** into `variance.csv`
(`week_start, forecast_receipts, actual_receipts`); the loop never writes actuals.

The gate's rows: 13 contiguous weekly rows · arithmetic ties (±₱1) · every `closing_cash ≥
min_cash_floor` (floor = one payroll cycle, **policy**) · ending cash never negative · freshness
(first week within 7 days of today — a TWCF "must be updated weekly" [10:S47]) · receipts
variance over the last 4 actual weeks ≤ 15 % (**policy**, practitioner consensus from [05:S32])
· reserve = opening cash ÷ avg monthly **fixed** disbursements ≥ `GUILD_RESERVE_MONTHS` (3 —
the only fetched anchor is 1–3 months of fixed opex [10:S48] P3; the popular "3–6 months" has no
published source, so 3 floor / 6 target is **policy**) · runway from 13-week net flow ≥
`GUILD_RUNWAY_MONTHS` (6, **policy**) · cash-buffer days = cash ÷ avg daily outflow ≥ 27 (JPMC
Institute median across 597k firms; 25th percentile 13 = ALARM; 75th 62 [12:S36] P1).

VAT is accrual post-EOPT: output VAT is owed on the invoice, not on collection — tax
disbursements in the forecast follow invoice dates [10:S26][10:S4]. Receipts are forecast from
observed payment behaviour, never stated terms [10:S48], with EWT withheld by clients netted out
(the 2307 credit is a tax asset, not cash — brief 10 §4b).

## §8 Default-alive — `board/cash_ledger.csv` (gate: `alive`)

Monthly rows `month, revenue, expenses, cash` (≥ 6 — PG: the question "switches from meaningless
to critical" around month 8–9, and asking too early is its own failure [05:S39] P1). The gate
mechanizes brief 11 §5.2: expenses held **flat at the last month**, revenue compounding at the
trailing 3–6-month rate (window `GUILD_ALIVE_WINDOW`, default 6), simulated to 60 months:
**ALIVE iff revenue ≥ expenses before cash < 0.** Emits `DEFAULT_ALIVE: 1|0` with
`months_to_breakeven` / `months_to_zero` on the line and stderr, plus the trailing 3-month net
burn. `months_to_zero ≤ 6` (**policy**) is the **fatal pinch** [11:1] P1: the gate demands a
fatal-pinch ADR and a hiring freeze — PG: "overhiring is by far the biggest killer of startups
that raise money". `/guild:board` reads this line every cycle; a breached K1 kill row is decided
by humans, computed by this gate.

## §9 Studio KPIs — `economics/studio-ledger.csv` (gate: `studio`)

Brief 12 §5 columns with a `row_type` discriminator so period totals, per-project facts, invoices
and bids live in one ledger (per-person time rows + per-project rows, as the brief allows):

- `time` rows (per person per period): `hours_available, hours_billable, hours_billed,
  list_rate, revenue_recognized, fully_loaded_cost_per_fte` (monthly loaded cost).
- `project` rows: `project_id, client_id, model (fixed|tm|retainer|product|nre),
  revenue_recognized, direct_labor_cost, subcontractor_cost, passthru_cost, estimate_cost,
  actual_cost, project_value, deposit_received, change_order_id, scope_delta_value`.
- `invoice` rows: `invoice_id, client_id, revenue_recognized, invoice_date, paid_date` (open
  invoices age against `as_of`).
- `period` rows: `revenue_recognized, total_cost, cash_balance, avg_daily_outflow_30d,
  pipeline_weighted_value, forecast_next_q, backlog_value, quarterly_target` (latest row rules).
- `bid` rows: `bid_id, bid_won`.

KPI floors (SPI 2025 benchmark, 403 firms [12:S1] P1 unless noted):

| KPI | Floor / band | Benchmark context | Action on breach |
|---|---|---|---|
| Billable utilisation | ≥ 65 % floor (under-10 firms average 64.3 %), target 75 % "optimal"; > 85 % | 68.9 % avg 2024; 66.4 % 2025 [12:S1], Deltek | < 65 % blocks new hires; > 85 % blocks new sales commitments without a hire |
| Realisation | ≥ 90 % | avg discount 9.1 %; > 20 % discounting correlates with attrition | pricing review |
| Revenue per billable FTE | ≥ 1.5× fully loaded cost (min), 2× plan | SPI $199k/consultant; PH form is the ratio | freeze headcount, raise rates |
| Project margin | ≥ 35 % aggregate; any project < 25 % | 35.9 % avg | post-mortem before a similar bid |
| Overrun | ≤ 10 % | 11.3 % avg — already past SPI's concern line | estimation-method change |
| Revenue leakage | ≤ 5 % (billable vs billed) | 5.3 % avg; under-10 firms 6.4 % | invoice audit |
| Pipeline coverage | ≥ 2× next-quarter forecast | 49.3 % of firms sit below 2× | BD hours mandatory; < 1× freezes hiring |
| Backlog | ≥ 40 % of quarterly target | 42.8 % avg | alarm at < 30 % |
| Bid win rate | 40–60 % band (amber outside), 30–70 % hard | 47.3 % avg | > band: raise prices; < band: positioning review |
| Client concentration | top ≤ 20 % amber / 25 % red; top-3 ≤ 50 % | Projectworks [12:S21] P2 | above red: no new work for that client until another signs |
| DSO | ≤ 45 days (open invoices aged to as_of) | 43.3 avg; under-10 37.4 | collections script + stop-work clause |
| Deposit | ≥ 20 % of project value before countersign | Sakas 20–50 %, 50/25/25 mid-size, never 50/50 on big jobs [12:S19] P2 | SOW is not countersigned |
| EBITDA | ≥ 10 % | 9.8 % 2024 avg; under-10 10.5 % | cost plan after 2 red quarters |
| Cash-buffer days | ≥ 27; ALARM < 13 | JPMC median / 25th pct [12:S36] P1 | cash-in-advance work only; founders' salary hold |
| Product bet | product time capped until product revenue > services revenue | the 37signals rule [12:S8] P1 | informational note, never auto-passed |

## §10 PH statute drivers (all statute rows carry source + effective date + last_verified)

- **NCR wage order.** Wage Order NCR-27: ₱695 → **₱755**/day from 25 Jul 2026 → **₱780** from
  20 Jan 2027 [05:S48] P1 — restrained by a TRO (30 Jul 2026) and preliminary injunction
  (13 Aug 2026) under Supreme Court review [05:S49] P2. **Model both floors:** the enjoined floor
  (₱695 stays while the injunction holds) and the un-enjoined tranche path; the worst corner
  carries the HIGHER floor (₱780) so a lifted injunction cannot sink the model (PH-01).
- **Employer on-costs (2026)** [05:S50] P2: SSS 15 % of MSC — employer 10 % / employee 5 %,
  MSC ceiling ₱35,000; EC ₱10–30/month employer-only; PhilHealth 5 % split 2.5/2.5 (floor
  ₱10,000, ceiling ₱100,000); Pag-IBIG 2 % + 2 % capped ₱200 each; 13th-month pay = 1/12 of
  basic annual pay by 24 December (PD 851). The fully loaded minimum-wage cost is *computed* from
  these drivers (§4), ≈ wage × 26 days × 1.208 + ₱230 — never hard-coded.
- **CIT** [05:S46] P2 (PwC, rev. Aug 2026): regular 25 %; **20 %** for domestic corporations with
  total assets ≤ ₱100M (excl. land) AND net taxable income ≤ ₱5M; **MCIT 2 %** of gross income
  from the 4th taxable year. PH-02 forbids typing a rate below the computed statute rate.
- **VAT** [05:S47][10:S5] P1/P2: 12 % above the **₱3,000,000** gross-sales threshold
  (CPI-indexed); below it, 3 % percentage tax (or the 8 % option — individuals only, ≤ ₱3M,
  elected Q1, irrevocable per year); voluntary VAT registration locks in for 3 years. Crossing
  ₱3M also triggers the CPA-audit test (Sec. 232) — and SEC MC 4 s.2026 audits at ₱3M of assets
  OR liabilities independently, so the model watches both.
- EWT is a **cash-flow** driver, not a cost: clients withhold 5/10 % (individuals) or 10/15 %
  (corporations, ₱720k test) and must issue Form 2307 by the 20th after quarter-end; the cash
  forecast nets it out and the AR gate chases the certificate (brief 10 §4b).

## §11 Human sign-off rows (the loop drafts, a named human passes)

The economics gates never mark these `pass`: electing the payback **segment** (SMB / mid-market /
enterprise) and the "profit" definition in the metric dictionary; every **spend** the model
implies — signing a PO with a 50 % MOQ deposit, committing tooling/NRE/certification, a retail
program, ad budget; **VAT / 8 % elections** and the books method; hiring against the plan
(blocked outright while DEFAULT_DEAD); accepting a fatal-pinch ADR; writing actuals into
`variance.csv`, `studio-ledger.csv` facts (deposits, paid dates, bids) and the monthly cash
ledger. Accountant/lawyer review rows for §10 stay red until a professional's sign-off path is
recorded — this protocol is not legal, tax or financial advice.

## §12 Early irreversibles (charter rows with decide-by dates)

1. **Business-model mix** — sets the whole margin band and cash profile: 80–90 % software vs
   ≈33–50 % hardware vs ~35 % project margin / ~10 % EBITDA services [05:S4][05:S25][12:S1].
2. **Hardware channel** — physical retail costs 30–50 margin points plus ~150-day terms and
   display fees; Bolt's first run *loses money* in retail — direct/e-tail first [05:S25][05:S27].
3. **MOQ / tooling / certification commitments** — sunk on PO signature; tooling capitalised and
   impaired at EOL [05:S26][05:S31].
4. **Price floor** — < 50 % direct hardware GM means the price is too low, and prices are far
   easier to cut than raise; raising ARPU later raises churn [05:S28][05:S7].
5. **Fixed-cost base and hiring** — wage floors ratchet (₱695 → ₱780 by Jan 2027), BSP forecasts
   6.4 % inflation for 2026 [05:S48][05:S43]; payroll is the least reversible expense [11:1].
6. **Entity/tax posture** — staying under ₱100M assets / ₱5M NTI keeps CIT at 20 %; crossing ₱3M
   flips VAT + audit; voluntary VAT locks 3 years [05:S46][05:S47].
7. **Metric definitions** — once bookings are "revenue" or LTV sits on revenue, every downstream
   board number is wrong [05:S3].

## §13 Failure modes the gates guard against

| Anti-pattern | Guard |
|---|---|
| LTV on revenue, unbounded lifetime | UE-02 computes LTV on contribution, 24-month cap [05:S3] |
| Blended CAC reported while paid CAC is what scales | `cac_paid` is the required driver; blended informational [05:S3] |
| LTV:CAC treated as science; interdependent inputs ignored | ALL-02 fragility sweep [05:S7] |
| Growth reported without the burn that bought it | UE-05 burn multiple once ARR > 0 [05:S5] |
| Not knowing default-alive until the fatal pinch | UE-07 + monthly `alive` runs + K1 ADR [05:S39] |
| BOM mistaken for landed cost; tooling un-amortised; first-run scrap ignored | HW-01/HW-04 formulas [05:S25][05:S26] |
| First run straight into physical retail | worst corner carries channel 30 %+ and DSO 150 [05:S27] |
| Utilisation drift, overruns, leakage eating the studio | SV-01/SV-04 + studio gate floors [12:S1] |
| USD benchmarks pasted into a PHP model | SV-03 uses the ratio, not $199k [12:S1] |
| One wage floor modelled while the order is enjoined | PH-01 takes the higher floor [05:S48][05:S49] |
| Forecast built once, never reconciled | cash C-05 freshness + C-06 variance [10:S47] |
| Hard-coded numbers inside formulas; derived values typed as inputs | ALL-03 register rules (FAST) [05:S37] |
| Customer concentration hidden inside a growth story | ALL-01 + studio S-09 [05:S4][12:S21] |

## §14 What the economics gates block

- A venture spec whose `economics` acceptance rows cannot cite a driver register — or a register
  whose benchmark/statute rows have no source, whose measured rows have no seam to re-read, or
  that types `ltv` in as an input.
- `OPEN_FOR_BUSINESS` while any of: worst-corner GM under the floor, LTV:CAC < 1 at worst,
  payback beyond the segment limit, break-even after cash-out, the 13-week forecast stale or
  breaching its floor, DEFAULT_DEAD with no accepted fatal-pinch ADR, studio utilisation /
  deposit / concentration / DSO outside the floors.
- Any PO / tooling / hiring / election **draft** from being marked sent or signed — those rows
  wait for humans (§11).

## §15 Policy thresholds (env-overridable; defaults = the researched values above)

| Env | Default | Meaning |
|---|---|---|
| `GUILD_LTV_CAP_MONTHS` | 24 | LTV lifetime cap [05:S3] |
| `GUILD_SENS_PCT` / `GUILD_SENS_ALL` | 20 / off | sensitivity sweep size / widen to non-statute |
| `GUILD_WITHIN_PCT` | 1 | tolerance of `within` (statute rates) |
| `GUILD_SIM_MONTHS` | 60 | break-even / default-alive horizon |
| `GUILD_PO_RESERVE_MONTHS` | 6 | fixed-cost cushion HW-02 keeps outside the first PO |
| `GUILD_CIT_STD` / `GUILD_CIT_LOW` / `GUILD_CIT_ASSET_CAP` / `GUILD_CIT_NTI_CAP` | 0.25 / 0.20 / ₱100M / ₱5M | CIT computation [05:S46] |
| `GUILD_MCIT_RATE` / `GUILD_MCIT_FROM_YEAR` | 0.02 / 4 | MCIT [05:S46] |
| `GUILD_VAT_RATE` / `GUILD_VAT_THRESHOLD` | 0.12 / ₱3,000,000 | VAT [05:S47] |
| `GUILD_STATUTE_MAX_AGE_DAYS` | 365 | statute re-verification warning |
| `GUILD_RESERVE_MONTHS` / `GUILD_RUNWAY_MONTHS` | 3 / 6 | cash reserve + runway floors (policy; [10:S48] P3 anchor) |
| `GUILD_CASH_FRESH_DAYS` / `GUILD_VAR_PCT` / `GUILD_VAR_WEEKS` / `GUILD_CASH_WEEKS` | 7 / 15 / 4 / 13 | TWCF discipline [10:S47] |
| `GUILD_BUFFER_DAYS` / `GUILD_BUFFER_ALARM` | 27 / 13 | JPMC cash-buffer days [12:S36] |
| `GUILD_ALIVE_WINDOW` / `GUILD_ALIVE_MIN_ROWS` / `GUILD_FATAL_PINCH_MONTHS` | 6 / 6 / 6 | default-alive mechanics [05:S39][11:1] |
| `GUILD_STUDIO_*` (UTIL_FLOOR .65, UTIL_TARGET .75, UTIL_CEILING .85, REALISATION .90, REV_FTE_RATIO 1.5, PROJECT_MARGIN .35, PM_POSTMORTEM .25, OVERRUN .10, LEAKAGE .05, COVERAGE 2.0, BACKLOG .40, CONC_AMBER .20, CONC_RED .25, TOP3 .50, DSO 45, DEPOSIT .20, EBITDA .10, WIN_LO .30, WIN_HI .70, WIN_BAND_LO .40, WIN_BAND_HI .60) | SPI/JPMC/Sakas values | studio floors [12:S1][12:S19][12:S21][12:S36] |
