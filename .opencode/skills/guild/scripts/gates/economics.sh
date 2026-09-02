#!/usr/bin/env bash
# gate: economics — unit-economics assertions evaluated at the base / worst / best corners of a
# driver register (brief 05 §5.1–5.2; contract: references/economics-protocol.md §2–§5).
#   score-guild.sh economics <model.csv> <assertions.tsv>   → "ECON_PASS: x/y"   (x = passing rows)
#   exit 0 on well-formed input (a red model is valid data) · 2 hard error (missing file, no rows,
#   register without the required columns)
#
# model.csv — the driver register, 12 comma-separated columns (header required; "# …" lines skipped;
# first line "# as_of: YYYY-MM-DD" fixes the date used for last_verified staleness):
#   driver_id name unit segment base worst best evidence source_id measured_from owner last_verified
#   evidence ∈ measured|quote|statute|benchmark|assumption
#   benchmark|statute ⇒ source_id non-empty · measured ⇒ measured_from non-empty (a ledger path,
#   an anvil PRODUCT_COST/BOM_COST line, a forge run) · assumption ⇒ listed as an OPEN RISK on stderr
#   A derived-metric name typed as a driver (ltv, landed_cost, runway_months, …: FAST — inputs are
#   never calculations) is a REGISTER VIOLATION: the row is ignored and the violation counts against
#   ALL-03 (register_violations). It is not a hard error, so the rest of the model still reports.
#   Non-numeric corner values are register violations too (row ignored).
#
# assertions.tsv — 6 tab-separated columns (header required):
#   id metric op limit corner traces        op ∈ le|ge|within · corner ∈ base|worst|best|all
#   metric = a derived metric (§4 of the protocol) or any driver_id. `within` = |value − limit| ≤
#   GUILD_WITHIN_PCT % of |limit| (statute rates). corner=all passes only when all three corners pass.
#   A malformed row (bad op / corner / limit, or a metric the model cannot derive) is a FAILED row.
#   If no row references `register_violations`, the gate appends "ALL-03 register_violations le 0 all".
#
# Derived metrics (all per corner): ltv (GM-adjusted, lifetime = min(1/churn_m, cap)), ltv_cac,
#   cac_payback, net_churn_m, new_customers_m, gross_profit_m, gm_blended, fixed_monthly, net_burn,
#   runway_months, burn_multiple, break_even_month, cash_out_month, be_gap_months, default_alive,
#   break_even_accounts, landed_cost, landed_cost_amortised, channel_net_price, cm_unit, hw_gm,
#   hw_gm_amortised, break_even_units, first_po_cash, first_po_headroom, ccc_days, working_capital,
#   wc_headroom, project_margin, revenue_per_fte, revenue_per_fte_ratio, min_wage_loaded_monthly,
#   cit_rate_effective, cit_rate_gap, mcit_rate, gross_sales_annual, vat_rate_effective, vat_gap,
#   register_violations (corner-free), fragility (±GUILD_SENS_PCT one-driver-at-a-time sweep of the
#   assumption|benchmark drivers at the base corner; GUILD_SENS_ALL=1 sweeps every non-statute driver).
#
# Policy / statute env (defaults = research values, brief 05 §3–§4, verified 2026-09-02):
#   GUILD_LTV_CAP_MONTHS=24 (a16z S3) · GUILD_SENS_PCT=20 (CFI S34 scenario mechanics; policy) ·
#   GUILD_WITHIN_PCT=1 · GUILD_SIM_MONTHS=60 · GUILD_PO_RESERVE_MONTHS=6 (HW-02, Bolt S26; policy) ·
#   GUILD_CIT_STD=0.25 · GUILD_CIT_LOW=0.20 · GUILD_CIT_ASSET_CAP=100000000 · GUILD_CIT_NTI_CAP=5000000 ·
#   GUILD_MCIT_RATE=0.02 · GUILD_MCIT_FROM_YEAR=4 (CREATE, PwC S46) · GUILD_VAT_RATE=0.12 ·
#   GUILD_VAT_THRESHOLD=3000000 (RA 11976 / TRAIN, PwC S47) · GUILD_STATUTE_MAX_AGE_DAYS=365 (warn)
#
# Implementation: bash + the _lib CSV parser; the arithmetic runs in one node process fed two JSON
# lines on stdin (no temp files, no npm). Per-row PASS/FAIL with value + margin → stderr.

ECON_JS="$(cat <<'JS'
const fs = require("fs");
const lines = fs.readFileSync(0, "utf8").split("\n").filter(l => l.trim() !== "");
if (lines.length < 2) { console.error("economics: could not read model + assertions"); process.exit(2); }
let model, asserts;
try { model = JSON.parse(lines[0]); asserts = JSON.parse(lines[1]); }
catch (e) { console.error("economics: bad CSV/TSV input: " + e.message); process.exit(2); }
const E = process.env, num = (k, d) => { const v = Number(E[k]); return Number.isFinite(v) && E[k] !== undefined && E[k] !== "" ? v : d; };
const CAP = num("GUILD_LTV_CAP_MONTHS", 24), SENS = num("GUILD_SENS_PCT", 20) / 100, WITHIN = num("GUILD_WITHIN_PCT", 1) / 100;
const HORIZON = num("GUILD_SIM_MONTHS", 60), PO_RES = num("GUILD_PO_RESERVE_MONTHS", 6);
const CIT_STD = num("GUILD_CIT_STD", 0.25), CIT_LOW = num("GUILD_CIT_LOW", 0.20), CIT_ASSET = num("GUILD_CIT_ASSET_CAP", 100e6), CIT_NTI = num("GUILD_CIT_NTI_CAP", 5e6);
const MCIT = num("GUILD_MCIT_RATE", 0.02), MCIT_FROM = num("GUILD_MCIT_FROM_YEAR", 4), VAT = num("GUILD_VAT_RATE", 0.12), VAT_THR = num("GUILD_VAT_THRESHOLD", 3e6);
const STAT_AGE = num("GUILD_STATUTE_MAX_AGE_DAYS", 365), SENS_ALL = E.GUILD_SENS_ALL === "1", TODAY = E.ECON_TODAY || "";
const err = s => process.stderr.write(s + "\n");
const REQ = ["driver_id", "base", "worst", "best", "evidence"];
if (!Array.isArray(model) || model.length === 0) { err("economics: model.csv has no driver rows"); process.exit(2); }
for (const c of REQ) if (!(c in model[0])) { err("economics: model.csv missing column '" + c + "' (need driver_id name unit segment base worst best evidence source_id measured_from owner last_verified)"); process.exit(2); }
if (!Array.isArray(asserts) || asserts.length === 0) { err("economics: assertions.tsv has no rows"); process.exit(2); }
for (const c of ["id", "metric", "op", "limit", "corner"]) if (!(c in asserts[0])) { err("economics: assertions.tsv missing column '" + c + "' (id metric op limit corner traces)"); process.exit(2); }

const EVID = new Set(["measured", "quote", "statute", "benchmark", "assumption"]);
const DERIVED = new Set(("ltv ltv_cac cac_payback net_churn_m new_customers_m gross_profit_m gm_blended fixed_monthly net_burn gross_burn " +
  "runway_months burn_multiple break_even_month cash_out_month be_gap_months default_alive break_even_accounts landed_cost " +
  "landed_cost_amortised channel_net_price cm_unit hw_gm hw_gm_amortised break_even_units first_po_cash first_po_headroom ccc_days " +
  "working_capital wc_headroom cogs_hw_monthly project_margin revenue_per_fte revenue_per_fte_ratio min_wage_loaded_monthly " +
  "cit_rate_effective cit_rate_gap mcit_rate gross_sales_annual vat_rate_effective vat_gap pct_tax_rate register_violations fragility " +
  "lifetime_months gross_margin contribution_margin payback runway ltv_to_cac cac_ltv breakeven burn_rate landed_unit_cost").split(" "));
const CORNERS = ["base", "worst", "best"];
const toNum = s => { const n = Number(String(s === undefined ? "" : s).replace(/[,₱\s]/g, "")); return String(s).trim() === "" ? NaN : n; };
const drivers = {}, violations = [], risks = [], seen = new Set();
const daysBetween = (a, b) => { const x = new Date(a + "T00:00:00Z"), y = new Date(b + "T00:00:00Z"); return (isNaN(x) || isNaN(y)) ? NaN : Math.round((y - x) / 86400000); };
model.forEach((r, i) => {
  const id = (r.driver_id || "").trim(), ev = (r.evidence || "").trim(), where = "model row " + (i + 2) + " (" + (id || "?") + ")";
  let ok = true;
  if (!id) { violations.push(where + ": empty driver_id"); return; }
  if (seen.has(id)) { violations.push(where + ": duplicate driver_id"); return; }
  seen.add(id);
  if (!EVID.has(ev)) { violations.push(where + ": evidence '" + ev + "' not in measured|quote|statute|benchmark|assumption"); ok = false; }
  if ((ev === "benchmark" || ev === "statute") && !(r.source_id || "").trim()) { violations.push(where + ": " + ev + " row without source_id"); ok = false; }
  if (ev === "measured" && !(r.measured_from || "").trim()) { violations.push(where + ": measured row without measured_from"); ok = false; }
  if (DERIVED.has(id)) { violations.push(where + ": derived metric '" + id + "' typed as a driver (FAST: inputs are not calculations) — row ignored"); return; }
  const v = { base: toNum(r.base), worst: toNum(r.worst), best: toNum(r.best) };
  if (CORNERS.some(c => !Number.isFinite(v[c]))) { violations.push(where + ": non-numeric corner value (base/worst/best) — row ignored"); return; }
  if (ev === "assumption") risks.push(id);
  if (ev === "statute" && TODAY && (r.last_verified || "").trim()) { const age = daysBetween(r.last_verified.trim(), TODAY); if (Number.isFinite(age) && age > STAT_AGE) err("warn: statute driver " + id + " last_verified " + r.last_verified.trim() + " is " + age + " days old (> " + STAT_AGE + ") — re-verify before relying on it"); }
  drivers[id] = Object.assign({ evidence: ev, segment: (r.segment || "").trim(), unit: (r.unit || "").trim() }, v);
});
const has = (v, ...k) => k.every(x => x in v && Number.isFinite(v[x]));
function derive(v) {
  const m = {};
  if (has(v, "price_arpa", "gm_pct", "churn_m")) { const life = v.churn_m > 0 ? Math.min(1 / v.churn_m, CAP) : CAP; m.lifetime_months = life; m.ltv = v.price_arpa * v.gm_pct * life; }
  if ("ltv" in m && has(v, "cac_paid") && v.cac_paid > 0) m.ltv_cac = m.ltv / v.cac_paid;
  if (has(v, "cac_paid", "price_arpa", "gm_pct") && v.price_arpa * v.gm_pct > 0) m.cac_payback = v.cac_paid / (v.price_arpa * v.gm_pct);
  if (has(v, "churn_m")) m.net_churn_m = v.churn_m - (has(v, "expansion_m") ? v.expansion_m : 0);
  if (has(v, "sm_monthly", "cac_paid") && v.cac_paid > 0) m.new_customers_m = v.sm_monthly / v.cac_paid;
  if (has(v, "revenue_m", "cogs_m")) { m.gross_profit_m = v.revenue_m - v.cogs_m; m.gm_blended = v.revenue_m > 0 ? m.gross_profit_m / v.revenue_m : 0; }
  if (has(v, "opex_fixed")) { m.fixed_monthly = v.opex_fixed + (has(v, "sm_monthly") ? v.sm_monthly : 0); }
  if ("fixed_monthly" in m && "gross_profit_m" in m) { m.net_burn = m.fixed_monthly - m.gross_profit_m; m.gross_burn = m.fixed_monthly + v.cogs_m; }
  if ("net_burn" in m && has(v, "cash_open")) m.runway_months = m.net_burn > 0 ? v.cash_open / m.net_burn : 999;
  if ("net_burn" in m && has(v, "new_arr_monthly")) m.burn_multiple = m.net_burn <= 0 ? 0 : (v.new_arr_monthly > 0 ? m.net_burn / v.new_arr_monthly : 999);
  if ("gm_blended" in m && "fixed_monthly" in m && has(v, "cash_open", "growth_m")) {
    let rev = v.revenue_m, cash = v.cash_open, be = -1, out = -1;
    if (rev * m.gm_blended >= m.fixed_monthly) be = 0;
    if (cash < 0) out = 0;
    for (let t = 1; t <= HORIZON && (be < 0 || out < 0); t++) {
      rev *= 1 + v.growth_m; cash += rev * m.gm_blended - m.fixed_monthly;
      if (be < 0 && rev * m.gm_blended >= m.fixed_monthly) be = t;
      if (out < 0 && cash < 0) out = t;
    }
    m.break_even_month = be < 0 ? 999 : be; m.cash_out_month = out < 0 ? 999 : out;
    m.be_gap_months = be < 0 ? -(HORIZON + 1) : (m.cash_out_month - be);
    m.default_alive = (be >= 0 && be <= m.cash_out_month) ? 1 : 0;
  }
  if ("fixed_monthly" in m && has(v, "price_arpa", "gm_pct") && v.price_arpa * v.gm_pct > 0) m.break_even_accounts = m.fixed_monthly / (v.price_arpa * v.gm_pct);
  if (has(v, "bom_unit", "asm_test_pack_unit", "freight_duty_unit", "scrap_pct", "warranty_pct", "price_unit") && v.scrap_pct < 1) {
    m.landed_cost = (v.bom_unit + v.asm_test_pack_unit + v.freight_duty_unit) / (1 - v.scrap_pct) + v.warranty_pct * v.price_unit;
    const ch = has(v, "channel_margin") ? v.channel_margin : 0;
    m.channel_net_price = v.price_unit * (1 - ch); m.cm_unit = m.channel_net_price - m.landed_cost;
    m.hw_gm = m.channel_net_price > 0 ? m.cm_unit / m.channel_net_price : -1;
    if (has(v, "tooling_total")) { const run = has(v, "first_run_units") ? v.first_run_units : (has(v, "moq_units") ? v.moq_units : NaN);
      if (Number.isFinite(run) && run > 0) { m.landed_cost_amortised = m.landed_cost + v.tooling_total / run; m.hw_gm_amortised = m.channel_net_price > 0 ? (m.channel_net_price - m.landed_cost_amortised) / m.channel_net_price : -1; } }
    if ("fixed_monthly" in m && m.cm_unit > 0) m.break_even_units = m.fixed_monthly / m.cm_unit;
    if (has(v, "deposit_pct", "moq_units", "tooling_total")) { m.first_po_cash = v.deposit_pct * v.moq_units * m.landed_cost + v.tooling_total;
      if ("fixed_monthly" in m && has(v, "cash_open")) m.first_po_headroom = v.cash_open - PO_RES * m.fixed_monthly - m.first_po_cash; }
    if (has(v, "dio_days", "dso_days", "dpo_days")) { m.ccc_days = v.dio_days + v.dso_days - v.dpo_days;
      if (has(v, "units_monthly")) { m.cogs_hw_monthly = v.units_monthly * m.landed_cost; m.working_capital = m.ccc_days / 30 * m.cogs_hw_monthly;
        if ("first_po_cash" in m && has(v, "cash_open")) m.wc_headroom = v.cash_open - m.first_po_cash - m.working_capital; } }
  }
  if (has(v, "delivery_cost_pct")) m.project_margin = 1 - v.delivery_cost_pct;
  if (has(v, "bill_rate", "utilization", "annual_hours")) { m.revenue_per_fte = v.bill_rate * v.utilization * v.annual_hours; if (has(v, "loaded_cost_fte") && v.loaded_cost_fte > 0) m.revenue_per_fte_ratio = m.revenue_per_fte / v.loaded_cost_fte; }
  if (has(v, "wage_floor")) { const s = has(v, "sss_er_pct") ? v.sss_er_pct : 0, p = has(v, "philhealth_er_pct") ? v.philhealth_er_pct : 0, pg = has(v, "pagibig_er_php") ? v.pagibig_er_php : 0, ec = has(v, "ec_er_php") ? v.ec_er_php : 0;
    m.min_wage_loaded_monthly = v.wage_floor * 26 * (1 + s + p + 1 / 12) + pg + ec; }
  if (has(v, "total_assets", "nti_annual")) { m.cit_rate_effective = (v.total_assets <= CIT_ASSET && v.nti_annual <= CIT_NTI) ? CIT_LOW : CIT_STD; if (has(v, "cit_rate")) m.cit_rate_gap = v.cit_rate - m.cit_rate_effective; }
  if (has(v, "years_operating")) m.mcit_rate = v.years_operating >= MCIT_FROM ? MCIT : 0;
  if (has(v, "revenue_m")) { m.gross_sales_annual = v.revenue_m * 12; const reg = has(v, "vat_registered") && v.vat_registered >= 1;
    m.vat_rate_effective = (m.gross_sales_annual > VAT_THR || reg) ? VAT : 0; if (m.vat_rate_effective === 0) m.pct_tax_rate = 0.03;
    if (has(v, "vat_rate")) m.vat_gap = v.vat_rate - m.vat_rate_effective; }
  return m;
}
const cornerValues = c => { const v = {}; for (const id in drivers) v[id] = drivers[id][c]; return v; };
const base = cornerValues("base"), derivedAt = {}; for (const c of CORNERS) derivedAt[c] = derive(cornerValues(c));
const lookup = (vals, m, metric) => (metric in m) ? m[metric] : ((metric in vals) ? vals[metric] : undefined);
const fmt = x => (typeof x !== "number" || !Number.isFinite(x)) ? String(x) : (Math.abs(x) >= 100 ? x.toFixed(1) : x.toFixed(4));
function evalRow(a, vals, m, extra) {
  const op = (a.op || "").trim(), corner = (a.corner || "").trim(), metric = (a.metric || "").trim(), lim = toNum(a.limit);
  if (!metric) return { pass: false, detail: "empty metric" };
  if (!["le", "ge", "within"].includes(op)) return { pass: false, detail: "bad op '" + op + "' (le|ge|within)" };
  if (!Number.isFinite(lim)) return { pass: false, detail: "bad limit '" + a.limit + "'" };
  const corners = corner === "all" ? CORNERS : (CORNERS.includes(corner) ? [corner] : null);
  if (!corners) return { pass: false, detail: "bad corner '" + corner + "' (base|worst|best|all)" };
  let pass = true; const parts = [], margins = [];
  for (const c of corners) {
    const val = (metric in extra) ? extra[metric] : lookup(vals[c], m[c], metric);
    if (typeof val !== "number" || !Number.isFinite(val)) { pass = false; parts.push(c + ":undefined"); continue; }
    let ok, margin;
    if (op === "le") { ok = val <= lim; margin = lim - val; }
    else if (op === "ge") { ok = val >= lim; margin = val - lim; }
    else { const tol = lim === 0 ? 1e-9 : Math.abs(lim) * WITHIN; ok = Math.abs(val - lim) <= tol; margin = tol - Math.abs(val - lim); }
    if (!ok) pass = false; parts.push(c + ":" + fmt(val)); margins.push(margin);
  }
  const detail = "value=" + parts.join("|") + (margins.length ? " margin=" + fmt(Math.min(...margins)) : " (metric not derivable — missing drivers)");
  return { pass, detail };
}
const rows = asserts.map(a => Object.assign({}, a));
if (!rows.some(a => (a.metric || "").trim() === "register_violations")) rows.push({ id: "ALL-03", metric: "register_violations", op: "le", limit: "0", corner: "all", traces: "implicit" });
const valsAt = { base, worst: cornerValues("worst"), best: cornerValues("best") };
const extraBase = { register_violations: violations.length };
// fragility: one-driver-at-a-time ±SENS at the base corner over the uncertain drivers
const sweepIds = Object.keys(drivers).filter(id => SENS_ALL ? drivers[id].evidence !== "statute" : (drivers[id].evidence === "assumption" || drivers[id].evidence === "benchmark"));
const sensRows = rows.filter(a => { const mt = (a.metric || "").trim(), c = (a.corner || "").trim(); return mt !== "fragility" && mt !== "register_violations" && (c === "base" || c === "all"); });
const baseline = {}; for (const a of sensRows) baseline[a.id] = evalRow(Object.assign({}, a, { corner: "base" }), valsAt, derivedAt, extraBase).pass;
const tornado = []; let flips = 0;
for (const id of sweepIds) {
  const rec = { id, flips: {} };
  for (const f of [1 - SENS, 1 + SENS]) {
    const vv = Object.assign({}, base); vv[id] = base[id] * f; const mm = derive(vv); const lost = [];
    for (const a of sensRows) if (baseline[a.id] && !evalRow(Object.assign({}, a, { corner: "base" }), { base: vv }, { base: mm }, extraBase).pass) lost.push(a.id);
    rec.flips[f < 1 ? "-" : "+"] = lost; flips += lost.length;
  }
  tornado.push(rec);
}
const extra = Object.assign({ fragility: flips }, extraBase);
let x = 0;
for (const a of rows) {
  const r = evalRow(a, valsAt, derivedAt, extra); if (r.pass) x++;
  err((r.pass ? "PASS" : "FAIL") + " " + (a.id || "?") + " " + (a.metric || "?") + " " + (a.op || "?") + " " + (a.limit === undefined ? "?" : a.limit) + " @" + (a.corner || "?") + " " + r.detail + (a.traces ? " [" + a.traces + "]" : ""));
}
for (const c of CORNERS) err("derived @" + c + ": " + Object.keys(derivedAt[c]).map(k => k + "=" + fmt(derivedAt[c][k])).join(" "));
tornado.sort((p, q) => (Object.values(q.flips).flat().length) - (Object.values(p.flips).flat().length));
err("sensitivity (±" + Math.round(SENS * 100) + " % one driver at a time, " + (SENS_ALL ? "all non-statute" : "assumption|benchmark") + " drivers): swept=" + sweepIds.length + " flips=" + flips);
for (const t of tornado) if ((t.flips["-"] || []).length || (t.flips["+"] || []).length) err("  tornado " + t.id + " -" + Math.round(SENS * 100) + "%: [" + (t.flips["-"] || []).join(",") + "] +" + Math.round(SENS * 100) + "%: [" + (t.flips["+"] || []).join(",") + "]");
for (const v of violations) err("register: " + v);
err("open_risks (assumption rows, unverified until measured): " + (risks.length ? risks.join(", ") : "none"));
err("drivers=" + Object.keys(drivers).length + " violations=" + violations.length + " assertions=" + rows.length);
console.log("ECON_PASS: " + x + "/" + rows.length);
JS
)"

gate_economics() {
  local model="${1:?usage: economics <model.csv> <assertions.tsv>}"
  local asserts="${2:?usage: economics <model.csv> <assertions.tsv>}"
  [[ -f "$model" ]]   || { echo "score-guild: economics: missing model $model" >&2; return 2; }
  [[ -f "$asserts" ]] || { echo "score-guild: economics: missing assertions $asserts" >&2; return 2; }
  local today; today="$(guild_today "$model")"
  { guild_csv_json "$model" || exit 2; echo; guild_csv_json "$asserts" $'\t' || exit 2; echo; } \
    | ECON_TODAY="$today" node -e "$ECON_JS"
}
