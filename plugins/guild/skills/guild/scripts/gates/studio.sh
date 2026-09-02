#!/usr/bin/env bash
# gate: studio — engineering-studio KPI floors over the studio ledger (brief 12 §5 [12:S1] SPI,
# [12:S36] JPMC, [12:S19] Sakas, [12:S21] Projectworks; contract: references/economics-protocol.md §9).
#   score-guild.sh studio <studio-ledger.csv>   → "STUDIO_PASS: x/y"
#   exit 0 on well-formed input (a red studio is valid data) · 2 hard error
#
# studio-ledger.csv — brief 12 §5 columns plus a row_type discriminator (header required; first
# line "# as_of: YYYY-MM-DD"). Row types (unused columns stay empty):
#   time    — period, person_id, hours_available, hours_billable, hours_billed, list_rate,
#             revenue_recognized (realised revenue for the billed hours),
#             fully_loaded_cost_per_fte (that person's monthly fully loaded cost)
#   project — project_id, client_id, model (fixed|tm|retainer|product|nre), revenue_recognized,
#             direct_labor_cost, subcontractor_cost, passthru_cost, estimate_cost, actual_cost,
#             project_value, deposit_received (before countersign)
#   invoice — invoice_id, client_id, revenue_recognized (amount), invoice_date, paid_date
#             (open invoices age against guild_today)
#   period  — period, revenue_recognized (period total), total_cost (all-in), cash_balance,
#             avg_daily_outflow_30d, pipeline_weighted_value, forecast_next_q, backlog_value,
#             quarterly_target   (the LATEST period row feeds coverage/backlog/buffer)
#   bid     — bid_id, bid_won (Y|N)
#
# Checks (x/y rows; S-14 counted only when bid rows exist):
#   S-01 utilisation ≥ 65 % floor (target 75 → amber; > 85 → "no new sales without hire" note)
#   S-02 realisation ≥ 90 %                     S-03 revenue per billable FTE ≥ 1.5× loaded cost
#   S-04 project margin ≥ 35 % (any project < 25 % → post-mortem note)
#   S-05 overrun ≤ 10 %                         S-06 leakage ≤ 5 %
#   S-07 pipeline coverage ≥ 2×                 S-08 backlog ≥ 40 % of quarterly target
#   S-09 concentration: top client ≤ 25 % red (> 20 % amber), top-3 ≤ 50 %
#   S-10 DSO ≤ 45 days                          S-11 deposit ≥ 20 % on every project
#   S-12 EBITDA ≥ 10 %                          S-13 cash-buffer days ≥ 27 (alarm < 13)
#   S-14 bid win rate 30–70 % hard (40–60 SPI band → amber outside)
#   note: product rows (model=product) revenue ≤ services revenue ⇒ "product time capped
#   (37signals rule)" on stderr — informational, never a pass/fail row.
#
# Policy env (defaults = research values): GUILD_STUDIO_UTIL_FLOOR=0.65 UTIL_TARGET=0.75
#   UTIL_CEILING=0.85 REALISATION=0.90 REV_FTE_RATIO=1.5 PROJECT_MARGIN=0.35 PM_POSTMORTEM=0.25
#   OVERRUN=0.10 LEAKAGE=0.05 COVERAGE=2.0 BACKLOG=0.40 CONC_RED=0.25 CONC_AMBER=0.20 TOP3=0.50
#   DSO=45 DEPOSIT=0.20 EBITDA=0.10 (all GUILD_STUDIO_*) · GUILD_BUFFER_DAYS=27 GUILD_BUFFER_ALARM=13
#   · GUILD_STUDIO_WIN_LO=0.30 WIN_HI=0.70 WIN_BAND_LO=0.40 WIN_BAND_HI=0.60

STUDIO_JS="$(cat <<'JS'
const fs = require("fs");
let rows;
try { rows = JSON.parse(fs.readFileSync(0, "utf8")); } catch (e) { console.error("studio: bad CSV input: " + e.message); process.exit(2); }
if (!Array.isArray(rows) || rows.length === 0) { console.error("studio: no data rows"); process.exit(2); }
if (!("row_type" in rows[0])) { console.error("studio: missing row_type column (time|project|invoice|period|bid)"); process.exit(2); }
const E = process.env, envn = (k, d) => { const v = Number(E[k]); return (E[k] !== undefined && E[k] !== "" && Number.isFinite(v)) ? v : d; };
const P = {
  util_floor: envn("GUILD_STUDIO_UTIL_FLOOR", 0.65), util_target: envn("GUILD_STUDIO_UTIL_TARGET", 0.75), util_ceiling: envn("GUILD_STUDIO_UTIL_CEILING", 0.85),
  realisation: envn("GUILD_STUDIO_REALISATION", 0.90), rev_fte: envn("GUILD_STUDIO_REV_FTE_RATIO", 1.5),
  pmargin: envn("GUILD_STUDIO_PROJECT_MARGIN", 0.35), pm_post: envn("GUILD_STUDIO_PM_POSTMORTEM", 0.25),
  overrun: envn("GUILD_STUDIO_OVERRUN", 0.10), leakage: envn("GUILD_STUDIO_LEAKAGE", 0.05),
  coverage: envn("GUILD_STUDIO_COVERAGE", 2.0), backlog: envn("GUILD_STUDIO_BACKLOG", 0.40),
  conc_red: envn("GUILD_STUDIO_CONC_RED", 0.25), conc_amber: envn("GUILD_STUDIO_CONC_AMBER", 0.20), top3: envn("GUILD_STUDIO_TOP3", 0.50),
  dso: envn("GUILD_STUDIO_DSO", 45), deposit: envn("GUILD_STUDIO_DEPOSIT", 0.20), ebitda: envn("GUILD_STUDIO_EBITDA", 0.10),
  buffer: envn("GUILD_BUFFER_DAYS", 27), alarm: envn("GUILD_BUFFER_ALARM", 13),
  win_lo: envn("GUILD_STUDIO_WIN_LO", 0.30), win_hi: envn("GUILD_STUDIO_WIN_HI", 0.70), band_lo: envn("GUILD_STUDIO_WIN_BAND_LO", 0.40), band_hi: envn("GUILD_STUDIO_WIN_BAND_HI", 0.60),
};
const TODAY = E.STUDIO_TODAY || "";
const err = s => process.stderr.write(s + "\n");
const num = x => { const n = Number(String(x === undefined ? "" : x).replace(/[,₱\s]/g, "")); return String(x || "").trim() === "" ? 0 : (Number.isFinite(n) ? n : 0); };
const by = t => rows.filter(r => (r.row_type || "").trim() === t);
const T = by("time"), PR = by("project"), IV = by("invoice"), PD = by("period"), B = by("bid");
const sum = (a, f) => a.reduce((s, r) => s + f(r), 0);
let pass = 0, total = 0;
const row = (id, ok, msg) => { total++; if (ok) pass++; err((ok ? "PASS" : "FAIL") + " " + id + " " + msg); };
const pct = x => (100 * x).toFixed(1) + " %";
const days = (a, b) => { const x = new Date(a + "T00:00:00Z"), y = new Date(b + "T00:00:00Z"); return (isNaN(x) || isNaN(y)) ? NaN : Math.round((y - x) / 86400000); };

// S-01..S-03, S-06 — time rows
const avail = sum(T, r => num(r.hours_available)), billable = sum(T, r => num(r.hours_billable)), billed = sum(T, r => num(r.hours_billed));
const timeRev = sum(T, r => num(r.revenue_recognized)), atRate = sum(T, r => num(r.hours_billable) * num(r.list_rate));
const loaded = sum(T, r => num(r.fully_loaded_cost_per_fte));
const util = avail > 0 ? billable / avail : -1;
row("S-01", T.length > 0 && util >= P.util_floor, "utilisation " + (util < 0 ? "n/a (no time rows)" : pct(util)) + " (rule: >= " + pct(P.util_floor) + " floor, " + pct(P.util_target) + " target — SPI)");
if (util >= 0 && util < P.util_target && util >= P.util_floor) err("  amber: utilisation below the " + pct(P.util_target) + " SPI optimum");
if (util > P.util_ceiling) err("  note: utilisation " + pct(util) + " > " + pct(P.util_ceiling) + " — block new sales commitments without a hire (brief 12 §5)");
const realisation = atRate > 0 ? timeRev / atRate : -1;
row("S-02", realisation >= P.realisation, "realisation " + (realisation < 0 ? "n/a" : pct(realisation)) + " (rule: >= " + pct(P.realisation) + " — SPI discount 9.1 %, > 20 % churns clients)");
const ratio = loaded > 0 ? timeRev / loaded : -1;
row("S-03", ratio >= P.rev_fte, "revenue per billable FTE = " + (ratio < 0 ? "n/a" : ratio.toFixed(2) + "x loaded cost") + " (rule: >= " + P.rev_fte + "x min, 2x plan — SPI)");
// S-04, S-05, S-11 — project rows
const prRev = sum(PR, r => num(r.revenue_recognized));
const prCost = sum(PR, r => num(r.direct_labor_cost) + num(r.subcontractor_cost) + num(r.passthru_cost));
const pmargin = prRev > 0 ? (prRev - prCost) / prRev : -1;
row("S-04", pmargin >= P.pmargin, "project margin " + (pmargin < 0 ? "n/a (no project rows)" : pct(pmargin)) + " (rule: >= " + pct(P.pmargin) + " — SPI avg 35.9 %)");
for (const r of PR) { const rv = num(r.revenue_recognized), ct = num(r.direct_labor_cost) + num(r.subcontractor_cost) + num(r.passthru_cost);
  if (rv > 0 && (rv - ct) / rv < P.pm_post) err("  post-mortem: project " + r.project_id + " margin " + pct((rv - ct) / rv) + " < " + pct(P.pm_post) + " — required before a similar bid"); }
const est = sum(PR, r => num(r.estimate_cost)), act = sum(PR, r => num(r.actual_cost));
const overrun = est > 0 ? (act - est) / est : -1;
row("S-05", est > 0 && overrun <= P.overrun, "overrun " + (est > 0 ? pct(overrun) : "n/a") + " (rule: <= " + pct(P.overrun) + " — SPI concern > 10 %)");
for (const r of PR) { const e = num(r.estimate_cost), a = num(r.actual_cost); if (e > 0 && (a - e) / e > P.overrun) err("  overrun: project " + r.project_id + " " + pct((a - e) / e)); }
const leak = billable > 0 ? (billable - billed) / billable : -1;
row("S-06", leak >= 0 && leak <= P.leakage, "leakage " + (leak < 0 ? "n/a" : pct(leak)) + " (rule: <= " + pct(P.leakage) + " — SPI 5.3 %, under-10 firms 6.4 %)");
// S-07, S-08, S-12, S-13 — period rows (latest)
PD.sort((a, b) => String(a.period).localeCompare(String(b.period)));
const L = PD[PD.length - 1];
if (!L) { row("S-07", false, "pipeline coverage: no period rows"); row("S-08", false, "backlog: no period rows"); }
else {
  const cov = num(L.forecast_next_q) > 0 ? num(L.pipeline_weighted_value) / num(L.forecast_next_q) : -1;
  row("S-07", cov >= P.coverage, "pipeline coverage " + (cov < 0 ? "n/a" : cov.toFixed(2) + "x") + " next-quarter forecast @" + L.period + " (rule: >= " + P.coverage + "x — SPI; 49.3 % of firms are below)");
  const bl = num(L.quarterly_target) > 0 ? num(L.backlog_value) / num(L.quarterly_target) : -1;
  row("S-08", bl >= P.backlog, "backlog " + (bl < 0 ? "n/a" : pct(bl)) + " of quarterly target (rule: >= " + pct(P.backlog) + " — SPI avg 42.8 %)");
}
// S-09 concentration — project revenue by client
const cl = {}; for (const r of PR) { const c = (r.client_id || "?").trim(); cl[c] = (cl[c] || 0) + num(r.revenue_recognized); }
const shares = Object.entries(cl).sort((a, b) => b[1] - a[1]);
if (prRev > 0 && shares.length) {
  const top1 = shares[0][1] / prRev, top3 = shares.slice(0, 3).reduce((s, e) => s + e[1], 0) / prRev;
  row("S-09", top1 <= P.conc_red && top3 <= P.top3, "concentration: top client " + shares[0][0] + " = " + pct(top1) + ", top-3 = " + pct(top3) + " (rule: <= " + pct(P.conc_red) + " red / top-3 <= " + pct(P.top3) + ")");
  if (top1 > P.conc_amber && top1 <= P.conc_red) err("  amber: top client above " + pct(P.conc_amber) + " — no new work for " + shares[0][0] + " until another signs");
} else row("S-09", false, "concentration: no project revenue");
// S-10 DSO — invoices (open ones age against as_of)
let dsum = 0, dn = 0;
for (const r of IV) { const inv = (r.invoice_date || "").trim(); if (!inv) continue;
  const end = (r.paid_date || "").trim() || TODAY; const d = days(inv, end);
  if (Number.isFinite(d)) { dsum += d; dn++; if (d > P.dso) err("  aged: invoice " + r.invoice_id + " " + d + " days" + ((r.paid_date || "").trim() ? "" : " (open)")); } }
const dso = dn > 0 ? dsum / dn : -1;
row("S-10", dn > 0 && dso <= P.dso, "DSO " + (dn > 0 ? dso.toFixed(1) + " days over " + dn + " invoices" : "n/a (no invoice rows)") + " (rule: <= " + P.dso + " — SPI 43.3, under-10 37.4)");
// S-11 deposits
let depOk = PR.length > 0;
for (const r of PR) { const pv = num(r.project_value); if (pv <= 0) continue; const dp = num(r.deposit_received) / pv;
  if (dp < P.deposit) { depOk = false; err("  deposit: project " + r.project_id + " " + pct(dp) + " < " + pct(P.deposit) + " — SOW cannot be countersigned (Sakas floor)"); } }
row("S-11", depOk, "deposit >= " + pct(P.deposit) + " of project value before countersign on every project (Sakas 20–50 %)");
// S-12 EBITDA — period rows
const pRev = sum(PD, r => num(r.revenue_recognized)), pCost = sum(PD, r => num(r.total_cost));
const ebitda = pRev > 0 ? (pRev - pCost) / pRev : -1;
row("S-12", ebitda >= P.ebitda, "EBITDA " + (ebitda < 0 ? "n/a" : pct(ebitda)) + " (rule: >= " + pct(P.ebitda) + " — SPI 2024 avg 9.8 %, under-10 10.5 %)");
// S-13 cash-buffer days — latest period row
if (L && num(L.avg_daily_outflow_30d) > 0) {
  const bd = num(L.cash_balance) / num(L.avg_daily_outflow_30d);
  row("S-13", bd >= P.buffer, "cash-buffer days " + bd.toFixed(0) + " (rule: >= " + P.buffer + " JPMC median; alarm < " + P.alarm + ")");
  if (bd < P.alarm) err("  ALARM: buffer " + bd.toFixed(0) + " days < " + P.alarm + " (JPMC 25th pct) — cash-in-advance work only, hold founders' salary");
} else row("S-13", false, "cash-buffer days: no period row with avg_daily_outflow_30d");
// S-14 bid win rate — only when bid rows exist
if (B.length > 0) {
  const wins = B.filter(r => String(r.bid_won).trim().toUpperCase() === "Y").length, wr = wins / B.length;
  row("S-14", wr >= P.win_lo && wr <= P.win_hi, "bid win rate " + pct(wr) + " over " + B.length + " bids (band " + pct(P.band_lo) + "–" + pct(P.band_hi) + " SPI; hard " + pct(P.win_lo) + "–" + pct(P.win_hi) + ")");
  if ((wr < P.band_lo || wr > P.band_hi) && wr >= P.win_lo && wr <= P.win_hi) err("  amber: outside the SPI 40–60 % band (" + (wr > P.band_hi ? "raise prices" : "positioning review") + ")");
}
// product-bet note (37signals rule) — informational
const prodRev = sum(PR.filter(r => (r.model || "").trim() === "product"), r => num(r.revenue_recognized));
const svcRev = prRev - prodRev;
if (prodRev > 0 && prodRev <= svcRev) err("note: product revenue " + prodRev + " <= services revenue " + svcRev + " — product time stays capped (37signals rule, brief 12 §5)");
err("rows: time=" + T.length + " project=" + PR.length + " invoice=" + IV.length + " period=" + PD.length + " bid=" + B.length);
console.log("STUDIO_PASS: " + pass + "/" + total);
JS
)"

gate_studio() {
  local f="${1:?usage: studio <studio-ledger.csv>}"
  [[ -f "$f" ]] || { echo "score-guild: studio: missing $f" >&2; return 2; }
  local today; today="$(guild_today "$f")"
  guild_csv_json "$f" | STUDIO_TODAY="$today" node -e "$STUDIO_JS"
}
