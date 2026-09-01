#!/usr/bin/env bash
# gate: board — the board pack is DERIVED from ledgers, fresh, and pre-read on time.
#   score-guild.sh board <run-dir>   → "BOARD_PACK: OK" | "BOARD_PACK: STALE" | "BOARD_PACK: INCOMPLETE"
#   exit 0 OK · 1 STALE|INCOMPLETE · 2 hard error (missing run-dir / meta.yaml / unparseable input)
#   STALE WINS over INCOMPLETE when both apply: stale inputs poison every section, so freshness is
#   reported first; all reasons (stale: … / incomplete: …) still go to stderr, plus a derived:
#   line with every computed value (the generator seam for /guild:board).
#
# Run-dir layout (a SNAPSHOT the board command copies/derives from the venture tree, so the pack
# is auditable against the exact rows it was derived from):
#   pack.md            — the board pack, Sequoia order: ## A. Big picture (### Highlights ≥ 3,
#                        ### Lowlights ≥ 3, ### Asks ≤ 3) · ## B1. KPIs vs plan · ## B2. Cash &
#                        runway · ## B3. Pipeline · ## B4. Delivery · ## B5. People · ## B6. Risks
#                        · ## B7. Decisions & asks · ## C. Company building (· ## D. Closed
#                        session — human, never checked)
#   meta.yaml          — venture, meeting_date (YYYY-MM-DD), meeting_time ("HH:MM", default 09:00),
#                        timezone (default +08:00), generated_at (ISO-8601), period (YYYY-MM),
#                        next_period (YYYY-Qn), as_of; "# as_of: YYYY-MM-DD" first line
#   kpi_actuals.csv    — kpi_id,period,actual,recorded_on,source            (freshness: recorded_on)
#   plan.csv           — kpi_id,name,unit,direction,role,period,plan; role ∈ north_star|input|
#                        quarter_plan — a plan is a commitment, not an observation: presence-checked,
#                        never freshness-checked
#   cash_ledger.csv    — month_end,opening_cash,revenue_in,other_in,expenses_out,closing_cash
#                        (monthly, human-entered bank actuals; freshness: month_end)
#   deals.csv          — deal_id,account,segment,stage,amount_acv,currency,probability,owner,
#                        next_action,next_action_date,last_activity_at,expected_close_date
#                        (or pipeline.tsv, same columns tab-separated; freshness: last_activity_at)
#   milestones.csv     — milestone_id,project_id,title,committed_date,delivered_date,accepted_date,
#                        status,updated_on                                  (freshness: updated_on)
#   headcount.csv      — month_end,plan,actual                              (freshness: month_end)
#   risks.csv          — schema of gates/decisions.sh                       (freshness: last_reviewed)
#   decisions.tsv      — schema of gates/decisions.sh; append-only history: presence-checked, its
#                        freshness is the presence of this cycle's proposed rows in B7
#   (premortems.csv, founders-agreement.yaml, kill-criteria.csv ride along for the decisions /
#    founders gates and the kill-row evaluation; this gate does not read them)
#
# Checks (contract: references/governance-protocol.md §4–§6):
#   STALE      — any freshness ledger's latest date > GUILD_BOARD_STALE_DAYS (31) before
#                meeting_date, or generated_at < GUILD_BOARD_PREREAD_HOURS (48) before the meeting
#   INCOMPLETE — a section missing, or its required ledger-derived content absent or disagreeing
#                with the ledgers: A bullet counts; B1 a row per plan KPI (actual/plan/variance/
#                trend recomputed, one north_star + 3–5 inputs); B2 cash_now, net_burn_avg_3m,
#                runway_months, DEFAULT_ALIVE, months_to_zero recomputed (PG simulation, inline —
#                no dependency on the economics `alive` gate) + monthly waterfall months; B3
#                weighted_pipeline, next_quarter_plan, coverage, stale_rows recomputed; B4
#                on_time_pct + milestones_delivered; B5 headcount_actual/plan + waterfall; B6 the
#                top-GUILD_BOARD_TOP_RISKS (5) risks by score and every score ≥
#                GUILD_RISK_PACK_SCORE (16), each with owner + trigger + next_review within
#                GUILD_RISK_REVIEW_DAYS (30) of last_reviewed and not overdue; B7 every proposed
#                ADR with owner + decide-by + money/legal flag; C present and dated
#   Dates come from guild_today / meta.yaml — never the system clock.
# Policy env: GUILD_BOARD_STALE_DAYS (31), GUILD_BOARD_PREREAD_HOURS (48),
#   GUILD_PIPELINE_STALE_DAYS (30), GUILD_RISK_REVIEW_DAYS (30), GUILD_BOARD_TOP_RISKS (5),
#   GUILD_RISK_PACK_SCORE (16), GUILD_PACK_MIN_HIGHLIGHTS (3), GUILD_PACK_MIN_LOWLIGHTS (3),
#   GUILD_PACK_MAX_ASKS (3), GUILD_ALIVE_GROWTH_MONTHS (3), GUILD_BOARD_WATERFALL_MONTHS (6).

gate_board() {
  local dir="${1:?usage: board <run-dir>}"
  [[ -d "$dir" ]] || { echo "score-guild: board: missing run-dir $dir" >&2; return 2; }
  [[ -f "$dir/meta.yaml" ]] || { echo "score-guild: board: missing $dir/meta.yaml (meeting_date, generated_at)" >&2; return 2; }
  local meta
  meta="$(guild_yaml_json "$dir/meta.yaml")" || { echo "score-guild: board: unparseable $dir/meta.yaml" >&2; return 2; }
  local today=""
  if [[ -n "${GUILD_TODAY:-}" ]] || grep -qE '^#[[:space:]]*as_of:' "$dir/meta.yaml"; then
    today="$(guild_today "$dir/meta.yaml")"
  fi
  local kpi="null" plan="null" cash="null" deals="null" milestones="null" headcount="null" risks="null" decisions="null"
  [[ -f "$dir/kpi_actuals.csv" ]] && { kpi="$(guild_csv_json "$dir/kpi_actuals.csv")" || return 2; }
  [[ -f "$dir/plan.csv"        ]] && { plan="$(guild_csv_json "$dir/plan.csv")" || return 2; }
  [[ -f "$dir/cash_ledger.csv" ]] && { cash="$(guild_csv_json "$dir/cash_ledger.csv")" || return 2; }
  if [[ -f "$dir/deals.csv" ]]; then deals="$(guild_csv_json "$dir/deals.csv")" || return 2
  elif [[ -f "$dir/pipeline.tsv" ]]; then deals="$(guild_csv_json "$dir/pipeline.tsv" $'\t')" || return 2; fi
  [[ -f "$dir/milestones.csv"  ]] && { milestones="$(guild_csv_json "$dir/milestones.csv")" || return 2; }
  [[ -f "$dir/headcount.csv"   ]] && { headcount="$(guild_csv_json "$dir/headcount.csv")" || return 2; }
  [[ -f "$dir/risks.csv"       ]] && { risks="$(guild_csv_json "$dir/risks.csv")" || return 2; }
  [[ -f "$dir/decisions.tsv"   ]] && { decisions="$(guild_csv_json "$dir/decisions.tsv" $'\t')" || return 2; }
  printf '{"meta":%s,"kpi":%s,"plan":%s,"cash":%s,"deals":%s,"milestones":%s,"headcount":%s,"risks":%s,"decisions":%s}' \
    "$meta" "$kpi" "$plan" "$cash" "$deals" "$milestones" "$headcount" "$risks" "$decisions" | node -e '
const fs = require("fs");
const dir = process.argv[1]; let today = process.argv[2] || "";
const num = (v, d) => (v !== undefined && v !== "" && !isNaN(Number(v)) ? Number(v) : d);
const STALE = num(process.env.GUILD_BOARD_STALE_DAYS, 31);
const PREREAD = num(process.env.GUILD_BOARD_PREREAD_HOURS, 48);
const PIPESTALE = num(process.env.GUILD_PIPELINE_STALE_DAYS, 30);
const REVIEW = num(process.env.GUILD_RISK_REVIEW_DAYS, 30);
const TOPN = num(process.env.GUILD_BOARD_TOP_RISKS, 5);
const PACKSCORE = num(process.env.GUILD_RISK_PACK_SCORE, 16);
const MINHI = num(process.env.GUILD_PACK_MIN_HIGHLIGHTS, 3);
const MINLO = num(process.env.GUILD_PACK_MIN_LOWLIGHTS, 3);
const MAXASK = num(process.env.GUILD_PACK_MAX_ASKS, 3);
const GROWTHM = num(process.env.GUILD_ALIVE_GROWTH_MONTHS, 3);
const WATER = num(process.env.GUILD_BOARD_WATERFALL_MONTHS, 6);
const D = JSON.parse(fs.readFileSync(0, "utf8"));
const meta = D.meta || {};
const g = (r, k) => (r && r[k] !== undefined && r[k] !== null ? String(r[k]) : "").trim();
const isDate = (s) => /^20\d\d-\d\d-\d\d$/.test(s) && !isNaN(Date.parse(s + "T00:00:00Z"));
const days = (a, b) => Math.round((Date.parse(b + "T00:00:00Z") - Date.parse(a + "T00:00:00Z")) / 86400000);
const parseNum = (s) => {
  if (s === undefined || s === null) return NaN;
  const t = String(s).replace(/−/g, "-").replace(/[^0-9.+-]/g, "");
  return t === "" ? NaN : Number(t);
};
const stale = [], inc = [], derived = [];
// ---- dates ------------------------------------------------------------------------------------
const meeting = g(meta, "meeting_date");
const mtime = g(meta, "meeting_time") || "09:00";
const tz = g(meta, "timezone") || "+08:00";
const genAt = g(meta, "generated_at");
if (!today) today = isDate(g(meta, "as_of")) ? g(meta, "as_of") : (isDate(genAt.slice(0, 10)) ? genAt.slice(0, 10) : meeting);
if (!isDate(meeting)) inc.push("meta.yaml: meeting_date missing or not YYYY-MM-DD — staleness cannot be established");
const genMs = Date.parse(genAt), meetMs = Date.parse(`${meeting}T${mtime}:00${tz}`);
let preread = NaN;
if (isNaN(genMs)) inc.push("meta.yaml: generated_at missing or not ISO-8601");
else if (!isNaN(meetMs)) {
  preread = (meetMs - genMs) / 3600000;
  if (preread < PREREAD) stale.push(`pack generated ${preread.toFixed(1)} h before the meeting (< ${PREREAD} h pre-read window)`);
}
// ---- ledger freshness (as_of / latest row date vs meeting_date) -------------------------------
const fresh = [
  ["kpi_actuals.csv", D.kpi, "recorded_on"],
  ["cash_ledger.csv", D.cash, "month_end"],
  ["deals.csv", D.deals, "last_activity_at"],
  ["milestones.csv", D.milestones, "updated_on"],
  ["headcount.csv", D.headcount, "month_end"],
  ["risks.csv", D.risks, "last_reviewed"],
];
for (const [name, rows, col] of fresh) {
  if (!Array.isArray(rows)) { inc.push(`missing ledger ${name} — its section cannot be derived`); continue; }
  const dates = rows.map((r) => g(r, col)).filter(isDate).sort();
  if (!dates.length) { inc.push(`${name}: no valid ${col} dates — freshness cannot be established`); continue; }
  const latest = dates[dates.length - 1];
  if (isDate(meeting)) {
    const dd = days(latest, meeting);
    if (dd > STALE) stale.push(`${name}: latest ${col} ${latest} is ${dd} d before meeting ${meeting} (> ${STALE} d)`);
  }
}
if (!Array.isArray(D.plan)) inc.push("missing ledger plan.csv — B1/B3 cannot be derived");
if (!Array.isArray(D.decisions)) inc.push("missing ledger decisions.tsv — B7 cannot be derived");
// ---- pack sections ----------------------------------------------------------------------------
let pack = null;
try { pack = fs.readFileSync(dir.replace(/\/+$/, "") + "/pack.md", "utf8").replace(/\r\n?/g, "\n"); }
catch (e) { inc.push("missing pack.md — there is no pack to evaluate"); }
const S = {};
if (pack !== null) {
  const defs = [["A", /^##\s*A\b/], ["B1", /^##\s*B1\b/], ["B2", /^##\s*B2\b/], ["B3", /^##\s*B3\b/],
    ["B4", /^##\s*B4\b/], ["B5", /^##\s*B5\b/], ["B6", /^##\s*B6\b/], ["B7", /^##\s*B7\b/], ["C", /^##\s*C\b/]];
  const lines = pack.split("\n");
  const heads = [];
  lines.forEach((l, i) => { if (/^##\s/.test(l)) heads.push([i, l]); });
  for (const [key, re] of defs) {
    const hi = heads.findIndex(([, l]) => re.test(l));
    if (hi < 0) continue;
    const start = heads[hi][0] + 1;
    const end = hi + 1 < heads.length ? heads[hi + 1][0] : lines.length;
    S[key] = lines.slice(start, end).join("\n");
  }
  const names = { A: "A (big picture)", B1: "B1 (KPIs vs plan)", B2: "B2 (cash & runway)", B3: "B3 (pipeline)",
    B4: "B4 (delivery)", B5: "B5 (people)", B6: "B6 (risks)", B7: "B7 (decisions & asks)", C: "C (company building)" };
  for (const k of Object.keys(names)) if (!(k in S)) inc.push(`missing section ${names[k]}`);
}
const mline = (sec, key) => {
  const m = sec && sec.match(new RegExp("^\\s*\\**" + key + "\\**\\s*:\\s*(.+)$", "mi"));
  return m ? m[1].trim() : null;
};
const tableRows = (sec) => (sec || "").split("\n")
  .filter((l) => /^\s*\|/.test(l))
  .map((l) => l.replace(/^\s*\|/, "").replace(/\|\s*$/, "").split("|").map((c) => c.trim()))
  .filter((cells) => !cells.every((c) => /^:?-{2,}:?$/.test(c) || c === ""));
// ---- A. big picture ---------------------------------------------------------------------------
if (S.A !== undefined) {
  const sub = (name) => {
    const m = S.A.match(new RegExp("^###[^\\n]*" + name + "[^\\n]*$([\\s\\S]*?)(?=^###|\\s*$(?![\\s\\S]))", "mi"));
    if (!m) return null;
    return m[1].split("\n").filter((l) => /^\s*[-*]\s+\S/.test(l)).length;
  };
  const hi = sub("Highlights"), lo = sub("Lowlights"), asks = sub("Asks");
  if (hi === null) inc.push("A: no Highlights subsection");
  else if (hi < MINHI) inc.push(`A: ${hi} highlight bullet(s) (need >= ${MINHI})`);
  if (lo === null) inc.push("A: no Lowlights subsection");
  else if (lo < MINLO) inc.push(`A: ${lo} lowlight bullet(s) (need >= ${MINLO})`);
  if (asks === null) inc.push("A: no Asks subsection (where the company needs help)");
  else if (asks > MAXASK) inc.push(`A: ${asks} asks (max ${MAXASK} — more than three asks is a list, not a request)`);
}
// ---- B1. KPIs vs plan -------------------------------------------------------------------------
const period = g(meta, "period"), nextPeriod = g(meta, "next_period");
const planRows = Array.isArray(D.plan) ? D.plan : [];
const kpiRows = Array.isArray(D.kpi) ? D.kpi : [];
const actualOf = (id, p) => { const r = kpiRows.find((x) => g(x, "kpi_id") === id && g(x, "period") === p); return r ? parseNum(g(r, "actual")) : NaN; };
const prevPeriod = (p) => { const m = p.match(/^(20\d\d)-(\d\d)$/); if (!m) return ""; const d = new Date(Date.UTC(+m[1], +m[2] - 1 - 1, 1)); return d.toISOString().slice(0, 7); };
if (S.B1 !== undefined && Array.isArray(D.plan) && Array.isArray(D.kpi)) {
  const need = planRows.filter((r) => g(r, "period") === period && /^(north_star|input)$/.test(g(r, "role")));
  const ns = need.filter((r) => g(r, "role") === "north_star").length;
  const inputs = need.filter((r) => g(r, "role") === "input").length;
  if (ns !== 1) inc.push(`B1: plan.csv has ${ns} north_star row(s) for ${period} (need exactly 1)`);
  if (inputs < 3 || inputs > 5) inc.push(`B1: plan.csv has ${inputs} input metric(s) for ${period} (need 3–5)`);
  if (!/north star/i.test(S.B1)) inc.push("B1: the North Star row is not marked");
  const rows = tableRows(S.B1);
  for (const p of need) {
    const id = g(p, "kpi_id"), planV = parseNum(g(p, "plan"));
    const actV = actualOf(id, period);
    if (isNaN(actV)) { inc.push(`B1: no actual recorded in kpi_actuals.csv for ${id} ${period}`); continue; }
    const row = rows.find((c) => c[0] && c[0].toLowerCase().includes(id.toLowerCase()));
    if (!row) { inc.push(`B1: no table row for KPI ${id}`); continue; }
    if (row.length < 5 || row.slice(1, 5).some((c) => c === "")) { inc.push(`B1: row for ${id} needs actual/plan/variance/trend cells`); continue; }
    if (Math.abs(parseNum(row[1]) - actV) > 0.01) inc.push(`B1: ${id} actual ${row[1]} disagrees with kpi_actuals.csv (${actV})`);
    if (Math.abs(parseNum(row[2]) - planV) > 0.01) inc.push(`B1: ${id} plan ${row[2]} disagrees with plan.csv (${planV})`);
    if (planV !== 0) {
      const varC = (actV - planV) / planV * 100;
      if (Math.abs(parseNum(row[3]) - varC) > 0.6) inc.push(`B1: ${id} variance ${row[3]} disagrees with (actual−plan)/plan = ${varC.toFixed(1)} %`);
    }
    const prevV = actualOf(id, prevPeriod(period));
    if (!isNaN(prevV)) {
      const dirWant = actV > prevV ? "up" : actV < prevV ? "down" : "flat";
      const cell = row[4];
      const dirGot = /↑|▲|\bup\b/i.test(cell) ? "up" : /↓|▼|\bdown\b/i.test(cell) ? "down" : /→|\bflat\b|\bsteady\b/i.test(cell) ? "flat" : "";
      if (dirGot !== dirWant) inc.push(`B1: ${id} trend "${cell}" disagrees with actuals ${prevV} → ${actV} (${dirWant})`);
    }
  }
}
// ---- B2. cash & runway (PG default-alive, inline) ---------------------------------------------
let cashNow = NaN, burnAvg = NaN, runway = null, alive = null, m2z = null, growth = NaN;
const cashRows = (Array.isArray(D.cash) ? D.cash : []).filter((r) => isDate(g(r, "month_end")))
  .sort((a, b) => g(a, "month_end") < g(b, "month_end") ? -1 : 1);
if (cashRows.length) {
  const last = cashRows[cashRows.length - 1];
  cashNow = parseNum(g(last, "closing_cash"));
  const w3 = cashRows.slice(-3);
  burnAvg = w3.reduce((s, r) => s + parseNum(g(r, "expenses_out")) - parseNum(g(r, "revenue_in")) - parseNum(g(r, "other_in")), 0) / w3.length;
  runway = burnAvg > 0 ? cashNow / burnAvg : "cash-positive";
  const wg = cashRows.slice(-(GROWTHM + 1));
  const r0 = parseNum(g(wg[0], "revenue_in")), r1 = parseNum(g(wg[wg.length - 1], "revenue_in"));
  growth = wg.length >= 2 && r0 > 0 && r1 > 0 ? Math.pow(r1 / r0, 1 / (wg.length - 1)) - 1 : 0;
  const expAvg = w3.reduce((s, r) => s + parseNum(g(r, "expenses_out")), 0) / w3.length;
  let rev = parseNum(g(last, "revenue_in")), cashSim = cashNow;
  if (rev >= expAvg) { alive = 1; m2z = "n/a"; }
  else {
    alive = null;
    for (let m = 1; m <= 120; m++) {
      rev = rev * (1 + growth);
      cashSim += rev - expAvg;
      if (cashSim < 0) { alive = 0; m2z = m; break; }
      if (rev >= expAvg) { alive = 1; m2z = "n/a"; break; }
    }
    if (alive === null) { alive = cashSim >= 0 ? 1 : 0; m2z = alive ? "n/a" : 120; }
  }
}
if (S.B2 !== undefined && cashRows.length) {
  const cn = mline(S.B2, "cash_now"), nb = mline(S.B2, "net_burn_avg_3m"), rw = mline(S.B2, "runway_months");
  const da = mline(S.B2, "DEFAULT_ALIVE"), mz = mline(S.B2, "months_to_zero");
  if (cn === null) inc.push("B2: no cash_now line"); else if (Math.abs(parseNum(cn) - cashNow) > 1) inc.push(`B2: cash_now ${cn} disagrees with cash_ledger.csv closing_cash ${cashNow}`);
  if (nb === null) inc.push("B2: no net_burn_avg_3m line"); else if (Math.abs(parseNum(nb) - burnAvg) > 1) inc.push(`B2: net_burn_avg_3m ${nb} disagrees with computed ${Math.round(burnAvg)}`);
  if (rw === null) inc.push("B2: no runway_months line");
  else if (runway === "cash-positive") { if (!/cash-positive/i.test(rw)) inc.push(`B2: runway_months "${rw}" — ledger shows negative net burn (cash-positive)`); }
  else if (Math.abs(parseNum(rw) - runway) > 0.5) inc.push(`B2: runway_months ${rw} disagrees with cash/burn = ${runway.toFixed(1)}`);
  if (da === null) inc.push("B2: no DEFAULT_ALIVE line");
  else if (parseNum(da) !== alive) inc.push(`B2: DEFAULT_ALIVE ${da} disagrees with the PG simulation (${alive})`);
  if (mz === null) inc.push("B2: no months_to_zero line");
  else if (m2z === "n/a") { if (!/^(n\/a|-|none)/i.test(mz)) inc.push(`B2: months_to_zero "${mz}" should be n/a (default-alive)`); }
  else if (parseNum(mz) !== m2z) inc.push(`B2: months_to_zero ${mz} disagrees with the simulation (${m2z})`);
  for (const r of cashRows.slice(-WATER)) {
    const mo = g(r, "month_end").slice(0, 7);
    if (!S.B2.includes(mo)) inc.push(`B2: monthly waterfall is missing ${mo}`);
  }
}
// ---- B3. pipeline -----------------------------------------------------------------------------
let weighted = NaN, coverage = null, staleDeals = NaN, nextPlanV = NaN;
const dealRows = Array.isArray(D.deals) ? D.deals : [];
const openDeals = dealRows.filter((r) => !/^(won|lost|no_decision|closed|abandoned)$/i.test(g(r, "stage")));
if (dealRows.length) {
  weighted = 0;
  for (const r of openDeals) {
    const amt = parseNum(g(r, "amount_acv") || g(r, "amount") || g(r, "value"));
    let p = parseNum(g(r, "probability"));
    if (isNaN(amt) || isNaN(p)) { inc.push(`B3: open deal ${g(r, "deal_id") || g(r, "id")} lacks amount/probability — weighted pipeline needs both`); continue; }
    if (p > 1) p = p / 100;
    weighted += amt * p;
  }
  staleDeals = openDeals.filter((r) => isDate(g(r, "last_activity_at")) && days(g(r, "last_activity_at"), today) > PIPESTALE).length;
  const np = planRows.find((r) => g(r, "role") === "quarter_plan" && g(r, "period") === nextPeriod);
  if (np) { nextPlanV = parseNum(g(np, "plan")); coverage = nextPlanV > 0 ? weighted / nextPlanV : null; }
  else inc.push(`B3: plan.csv has no quarter_plan row for next_period ${nextPeriod} — coverage has no denominator`);
}
if (S.B3 !== undefined && dealRows.length) {
  const wp = mline(S.B3, "weighted_pipeline"), npl = mline(S.B3, "next_quarter_plan");
  const cv = mline(S.B3, "coverage"), sr = mline(S.B3, "stale_rows");
  if (wp === null) inc.push("B3: no weighted_pipeline line"); else if (Math.abs(parseNum(wp) - weighted) > 1) inc.push(`B3: weighted_pipeline ${wp} disagrees with Σ amount × probability = ${Math.round(weighted)}`);
  if (!isNaN(nextPlanV)) { if (npl === null) inc.push("B3: no next_quarter_plan line"); else if (Math.abs(parseNum(npl) - nextPlanV) > 1) inc.push(`B3: next_quarter_plan ${npl} disagrees with plan.csv (${nextPlanV})`); }
  if (coverage !== null) { if (cv === null) inc.push("B3: no coverage line"); else if (Math.abs(parseNum(cv) - coverage) > 0.1) inc.push(`B3: coverage ${cv} disagrees with computed ${coverage.toFixed(2)}x`); }
  if (sr === null) inc.push("B3: no stale_rows line"); else if (parseNum(sr) !== staleDeals) inc.push(`B3: stale_rows ${sr} disagrees with computed ${staleDeals} (last activity > ${PIPESTALE} d before ${today})`);
}
// ---- B4. delivery -----------------------------------------------------------------------------
let onTime = null, delivered = 0;
const msRows = Array.isArray(D.milestones) ? D.milestones : [];
const done = msRows.filter((r) => isDate(g(r, "delivered_date")));
delivered = done.length;
if (delivered) onTime = 100 * done.filter((r) => isDate(g(r, "committed_date")) && days(g(r, "committed_date"), g(r, "delivered_date")) <= 0).length / delivered;
if (S.B4 !== undefined && Array.isArray(D.milestones)) {
  const ot = mline(S.B4, "on_time_pct"), md = mline(S.B4, "milestones_delivered");
  if (md === null) inc.push("B4: no milestones_delivered line"); else if (parseNum(md) !== delivered) inc.push(`B4: milestones_delivered ${md} disagrees with milestones.csv (${delivered})`);
  if (ot === null) inc.push("B4: no on_time_pct line");
  else if (onTime === null) { if (!/^(n\/a|-)/i.test(ot)) inc.push(`B4: on_time_pct "${ot}" should be n/a (nothing delivered yet)`); }
  else if (Math.abs(parseNum(ot) - onTime) > 1) inc.push(`B4: on_time_pct ${ot} disagrees with delivered-on-or-before-committed = ${onTime.toFixed(1)} %`);
}
// ---- B5. people -------------------------------------------------------------------------------
const hcRows = (Array.isArray(D.headcount) ? D.headcount : []).filter((r) => isDate(g(r, "month_end")))
  .sort((a, b) => g(a, "month_end") < g(b, "month_end") ? -1 : 1);
if (S.B5 !== undefined && hcRows.length) {
  const last = hcRows[hcRows.length - 1];
  const ha = mline(S.B5, "headcount_actual"), hp = mline(S.B5, "headcount_plan");
  if (ha === null) inc.push("B5: no headcount_actual line"); else if (parseNum(ha) !== parseNum(g(last, "actual"))) inc.push(`B5: headcount_actual ${ha} disagrees with headcount.csv (${g(last, "actual")})`);
  if (hp === null) inc.push("B5: no headcount_plan line"); else if (parseNum(hp) !== parseNum(g(last, "plan"))) inc.push(`B5: headcount_plan ${hp} disagrees with headcount.csv (${g(last, "plan")})`);
  for (const r of hcRows.slice(-WATER)) {
    const mo = g(r, "month_end").slice(0, 7);
    if (!S.B5.includes(mo)) inc.push(`B5: monthly waterfall is missing ${mo}`);
  }
}
// ---- B6. risks --------------------------------------------------------------------------------
const riskRows = Array.isArray(D.risks) ? D.risks : [];
const openRisks = riskRows.filter((r) => g(r, "status") !== "closed");
const scored = openRisks.map((r) => ({ r, id: g(r, "id"), score: (parseNum(g(r, "probability")) || 0) * (parseNum(g(r, "impact")) || 0) }))
  .sort((a, b) => b.score - a.score || (a.id < b.id ? -1 : 1));
const mustShow = scored.slice(0, TOPN);
for (const s of scored.slice(TOPN)) if (s.score >= PACKSCORE) mustShow.push(s);
if (S.B6 !== undefined && riskRows.length) {
  for (const { r, id, score } of mustShow) {
    if (!new RegExp("\\b" + id + "\\b").test(S.B6)) { inc.push(`B6: top risk ${id} (score ${score}) is not in the pack`); continue; }
    if (!g(r, "owner")) inc.push(`B6: ${id} has no owner in risks.csv`);
    if (!g(r, "trigger")) inc.push(`B6: ${id} has no trigger in risks.csv`);
    const lr = g(r, "last_reviewed"), nr = g(r, "next_review");
    if (!isDate(lr) || !isDate(nr)) inc.push(`B6: ${id} last_reviewed/next_review missing or malformed`);
    else {
      if (days(lr, nr) > REVIEW) inc.push(`B6: ${id} next_review ${nr} is ${days(lr, nr)} d after last_reviewed (> ${REVIEW} d)`);
      if (days(today, nr) < 0) inc.push(`B6: ${id} next_review ${nr} is overdue (today ${today})`);
    }
  }
}
// ---- B7. decisions & asks ---------------------------------------------------------------------
const decRows = Array.isArray(D.decisions) ? D.decisions : [];
const proposed = decRows.filter((r) => g(r, "status") === "proposed");
if (S.B7 !== undefined && Array.isArray(D.decisions)) {
  for (const r of proposed) {
    const id = g(r, "id");
    if (!new RegExp("\\b" + id + "\\b").test(S.B7)) { inc.push(`B7: proposed ${id} is not in the pack`); continue; }
    if (!g(r, "owner")) inc.push(`B7: ${id} has no owner`);
    if (!isDate(g(r, "review_date"))) inc.push(`B7: ${id} has no decide-by date (review_date)`);
    if (!/^(true|false)$/i.test(g(r, "money_or_legal_effect"))) inc.push(`B7: ${id} money_or_legal_effect must be true|false`);
  }
}
// ---- C. company building ----------------------------------------------------------------------
if (S.C !== undefined) {
  const body = S.C.split("\n").filter((l) => l.trim() !== "" && !/^#/.test(l));
  if (body.length < 2) inc.push("C: roadmap/org content missing (need at least two content lines)");
  if (!/20\d\d-(\d\d|Q[1-4])/.test(S.C)) inc.push("C: roadmap/org must be dated (no 20YY-MM or 20YY-Qn token found)");
}
// ---- emit -------------------------------------------------------------------------------------
stale.forEach((m) => console.error("stale: " + m));
inc.forEach((m) => console.error("incomplete: " + m));
const fmt = (v, dec) => (v === null || (typeof v === "number" && isNaN(v)) ? "?" : (typeof v === "number" ? v.toFixed(dec === undefined ? 0 : dec) : v));
console.error(`derived: today=${today} meeting=${meeting} preread_h=${fmt(preread, 1)} cash_now=${fmt(cashNow)} net_burn_avg_3m=${fmt(burnAvg)} runway_months=${runway === "cash-positive" ? runway : fmt(runway, 1)} default_alive=${fmt(alive)} months_to_zero=${m2z === null ? "?" : m2z} growth_mom=${fmt(growth * 100, 1)}% weighted_pipeline=${fmt(weighted)} next_quarter_plan=${fmt(nextPlanV)} coverage=${coverage === null ? "?" : coverage.toFixed(2) + "x"} stale_rows=${fmt(staleDeals)} milestones_delivered=${delivered} on_time_pct=${onTime === null ? "n/a" : onTime.toFixed(1)} headcount=${hcRows.length ? g(hcRows[hcRows.length - 1], "actual") + "/" + g(hcRows[hcRows.length - 1], "plan") : "?"} top_risks=${mustShow.map((s) => s.id).join(",") || "-"} proposed_adrs=${proposed.map((r) => g(r, "id")).join(",") || "-"}`);
const verdict = stale.length ? "STALE" : inc.length ? "INCOMPLETE" : "OK";
console.log("BOARD_PACK: " + verdict);
process.exit(verdict === "OK" ? 0 : 1);
' "$dir" "$today"
}
