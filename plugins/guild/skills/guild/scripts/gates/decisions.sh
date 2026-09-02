#!/usr/bin/env bash
# gate: decisions — decision log (ADR) + pre-mortems + risk register hygiene.
#   score-guild.sh decisions <decisions.tsv> <risks.csv> [premortems.csv]
#     → "GOVERNANCE_VIOLATIONS: N"   (every violation → stderr with row, id and rule)
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing / unparseable file)
#   premortems.csv defaults to the file next to decisions.tsv.
#
# decisions.tsv — 14 tab-separated columns, header required, "# as_of: YYYY-MM-DD" first line:
#   id date title status context decision consequences owner money_or_legal_effect reversibility
#   premortem_ref signed_artifact review_date outcome
#   id                   ADR-<n>: monotonic in file order, NEVER reused (Nygard); a superseded or
#                        deprecated row is retained, never deleted
#   status               proposed | accepted | deprecated | superseded-by:ADR-<n> (target exists,
#                        is a later id)
#   consequences         items separated by ";", each prefixed "+" (positive), "-" (negative) or
#                        "~" (neutral); at least one "+" and one "-" — a consequences cell that
#                        lists only upside is not a decision record
#   money_or_legal_effect true | false — true ⇒ a signed_artifact (evidence:<path>) must exist
#                        before status=accepted (SAFE, loan, lease, hire, MSA, filing, election)
#   reversibility        one-way | two-way — one-way ⇒ premortem_ref = PM-<n> with ≥ 5 failure
#                        reasons in premortems.csv, each linked to an existing risk id
#   review_date          decide-by date for proposed rows, review date for accepted rows
# premortems.csv — premortem_id adr_id date failure_reason risk_id mitigation_ref (one reason per row)
# risks.csv     — id category description probability impact score trigger owner mitigation
#                 contingency status last_reviewed next_review
#   probability/impact 1–5 integers; score = probability × impact; owner + trigger required;
#   status ∈ open | mitigating | monitoring | closed; unless closed: next_review within
#   GUILD_RISK_REVIEW_DAYS (30) after last_reviewed and not before today (guild_today)
# Policy env: GUILD_RISK_REVIEW_DAYS (30), GUILD_PREMORTEM_MIN_REASONS (5).
# Contract: references/governance-protocol.md §7–§8.

gate_decisions() {
  local dfile="${1:?usage: decisions <decisions.tsv> <risks.csv> [premortems.csv]}"
  local rfile="${2:?usage: decisions <decisions.tsv> <risks.csv> [premortems.csv]}"
  local pfile="${3:-$(dirname "$dfile")/premortems.csv}"
  [[ -f "$dfile" ]] || { echo "score-guild: decisions: missing decisions ledger $dfile" >&2; return 2; }
  [[ -f "$rfile" ]] || { echo "score-guild: decisions: missing risk register $rfile" >&2; return 2; }
  local today="" f
  for f in "$dfile" "$rfile"; do
    [[ -n "$today" ]] && break
    if [[ -n "${GUILD_TODAY:-}" ]] || grep -qE '^#[[:space:]]*as_of:' "$f"; then today="$(guild_today "$f")"; fi
  done
  [[ -n "$today" ]] || today="$(guild_today)"
  local dj rj pj="null" has_pm=0
  dj="$(guild_csv_json "$dfile" $'\t')" || return 2
  rj="$(guild_csv_json "$rfile")" || return 2
  if [[ -f "$pfile" ]]; then pj="$(guild_csv_json "$pfile")" || return 2; has_pm=1; fi
  printf '{"decisions":%s,"risks":%s,"premortems":%s}' "$dj" "$rj" "$pj" | node -e '
const fs = require("fs");
const today = process.argv[1], hasPm = process.argv[2] === "1", pmPath = process.argv[3];
const num = (v, d) => (v !== undefined && v !== "" && !isNaN(Number(v)) ? Number(v) : d);
const REVIEW = num(process.env.GUILD_RISK_REVIEW_DAYS, 30);
const MINPM = num(process.env.GUILD_PREMORTEM_MIN_REASONS, 5);
const D = JSON.parse(fs.readFileSync(0, "utf8"));
const decisions = D.decisions || [], risks = D.risks || [], premortems = D.premortems || [];
const viol = []; const v = (m) => viol.push(m);
const isDate = (s) => /^20\d\d-\d\d-\d\d$/.test(s) && !isNaN(Date.parse(s + "T00:00:00Z"));
const days = (a, b) => Math.round((Date.parse(b + "T00:00:00Z") - Date.parse(a + "T00:00:00Z")) / 86400000);
const g = (r, k) => (r[k] === undefined || r[k] === null ? "" : String(r[k])).trim();
const want = ["id","date","title","status","context","decision","consequences","owner","money_or_legal_effect","reversibility","premortem_ref","signed_artifact","review_date","outcome"];
if (decisions.length) {
  const have = Object.keys(decisions[0]);
  const missing = want.filter((k) => !have.includes(k));
  if (missing.length) v(`decisions.tsv header: missing column(s) ${missing.join(", ")}`);
}
// ---- risk register ----------------------------------------------------------------------------
const riskIds = new Map();
risks.forEach((r, i) => {
  const ref = `risks.csv row ${i + 1}`, id = g(r, "id");
  if (!/^R-\d+$/.test(id)) v(`${ref}: bad id "${id}" (R-<n>)`);
  else if (riskIds.has(id)) v(`${ref} (${id}): duplicate risk id`);
  else riskIds.set(id, r);
  const p = Number(g(r, "probability")), im = Number(g(r, "impact")), sc = Number(g(r, "score"));
  if (!(Number.isInteger(p) && p >= 1 && p <= 5)) v(`${ref} (${id}): probability "${g(r, "probability")}" not an integer 1–5`);
  if (!(Number.isInteger(im) && im >= 1 && im <= 5)) v(`${ref} (${id}): impact "${g(r, "impact")}" not an integer 1–5`);
  if (Number.isInteger(p) && Number.isInteger(im) && sc !== p * im) v(`${ref} (${id}): score ${g(r, "score")} ≠ probability × impact (${p * im})`);
  if (!g(r, "trigger")) v(`${ref} (${id}): no trigger — a risk without a trigger is never noticed`);
  if (!g(r, "owner")) v(`${ref} (${id}): no owner — a risk without an owner is a graveyard row`);
  if (!g(r, "description")) v(`${ref} (${id}): empty description`);
  const st = g(r, "status");
  if (!/^(open|mitigating|monitoring|closed)$/.test(st)) v(`${ref} (${id}): status "${st}" not in open|mitigating|monitoring|closed`);
  if (st !== "closed") {
    const lr = g(r, "last_reviewed"), nr = g(r, "next_review");
    if (!isDate(lr)) v(`${ref} (${id}): last_reviewed "${lr}" not YYYY-MM-DD`);
    if (!isDate(nr)) v(`${ref} (${id}): next_review "${nr}" not YYYY-MM-DD`);
    if (isDate(lr) && isDate(nr)) {
      const gap = days(lr, nr);
      if (gap <= 0) v(`${ref} (${id}): next_review ${nr} is not after last_reviewed ${lr}`);
      else if (gap > REVIEW) v(`${ref} (${id}): next_review ${nr} is ${gap} d after last_reviewed (> ${REVIEW} d)`);
      if (days(today, nr) < 0) v(`${ref} (${id}): next_review ${nr} is in the past (today ${today}) — review overdue`);
    }
  }
});
// ---- pre-mortems ------------------------------------------------------------------------------
const pmByRef = new Map();
premortems.forEach((p, i) => {
  const ref = `premortems.csv row ${i + 1}`, pid = g(p, "premortem_id"), rid = g(p, "risk_id");
  if (!/^PM-\d+$/.test(pid)) { v(`${ref}: bad premortem_id "${pid}" (PM-<n>)`); return; }
  let ok = true;
  if (!g(p, "failure_reason")) { v(`${ref} (${pid}): empty failure_reason`); ok = false; }
  if (!riskIds.has(rid)) { v(`${ref} (${pid}): risk_id "${rid}" does not exist in risks.csv`); ok = false; }
  if (!pmByRef.has(pid)) pmByRef.set(pid, { rows: 0, linked: 0, adr: g(p, "adr_id") });
  const e = pmByRef.get(pid); e.rows++; if (ok) e.linked++;
});
// ---- decision log -----------------------------------------------------------------------------
const ids = new Map(); let maxN = 0;
const ST = /^(proposed|accepted|deprecated|superseded-by:ADR-\d+)$/;
const stats = { proposed: 0, accepted: 0, deprecated: 0, superseded: 0, one_way: 0, money: 0 };
decisions.forEach((r, i) => {
  const id = g(r, "id"), ref = `decisions.tsv row ${i + 1}`;
  if (!/^ADR-\d+$/.test(id)) v(`${ref}: bad id "${id}" (ADR-<n>)`);
  else {
    const n = Number(id.slice(4));
    if (ids.has(id)) v(`${ref} (${id}): ADR number reused — first used at row ${ids.get(id)}; numbers are never reused`);
    else if (n <= maxN) v(`${ref} (${id}): id not monotonic — previous highest is ADR-${maxN}`);
    if (!ids.has(id)) ids.set(id, i + 1);
    if (n > maxN) maxN = n;
  }
  const status = g(r, "status");
  if (!isDate(g(r, "date"))) v(`${ref} (${id}): date "${g(r, "date")}" not YYYY-MM-DD`);
  if (!g(r, "title")) v(`${ref} (${id}): empty title`);
  if (!g(r, "decision")) v(`${ref} (${id}): empty decision ("We will …")`);
  if (!g(r, "context")) v(`${ref} (${id}): empty context`);
  if (!g(r, "owner")) v(`${ref} (${id}): no owner`);
  if (!ST.test(status)) v(`${ref} (${id}): status "${status}" not in proposed|accepted|deprecated|superseded-by:ADR-<n>`);
  else if (status.startsWith("superseded-by:")) stats.superseded++; else stats[status]++;
  const cons = g(r, "consequences");
  const items = cons.split(";").map((s) => s.trim()).filter(Boolean);
  if (!items.some((s) => s.startsWith("+"))) v(`${ref} (${id}): consequences list no "+" (positive) item`);
  if (!items.some((s) => s.startsWith("-") || s.startsWith("−"))) v(`${ref} (${id}): consequences list no "-" (negative) item — only upside recorded`);
  const money = g(r, "money_or_legal_effect").toLowerCase();
  if (!/^(true|false)$/.test(money)) v(`${ref} (${id}): money_or_legal_effect "${g(r, "money_or_legal_effect")}" must be true|false`);
  if (money === "true") stats.money++;
  const signed = g(r, "signed_artifact");
  if (money === "true" && status === "accepted" && (!signed || signed === "-"))
    v(`${ref} (${id}): money_or_legal_effect=true and status=accepted but signed_artifact is empty — a money/legal decision is accepted only with a signed instrument`);
  const rev = g(r, "reversibility");
  if (!/^(one-way|two-way)$/.test(rev)) v(`${ref} (${id}): reversibility "${rev}" must be one-way|two-way`);
  if (rev === "one-way") {
    stats.one_way++;
    const pm = g(r, "premortem_ref");
    if (!pm || pm === "-") v(`${ref} (${id}): one-way door without a pre-mortem (premortem_ref empty; need PM-<n> with ≥ ${MINPM} failure reasons linked to risk rows)`);
    else if (!/^PM-\d+$/.test(pm)) v(`${ref} (${id}): premortem_ref "${pm}" is not PM-<n>`);
    else if (!hasPm) v(`${ref} (${id}): premortem_ref ${pm} but no premortems.csv at ${pmPath}`);
    else if (!pmByRef.has(pm)) v(`${ref} (${id}): premortem_ref ${pm} has no rows in premortems.csv`);
    else {
      const e = pmByRef.get(pm);
      if (e.adr && e.adr !== id) v(`${ref} (${id}): pre-mortem ${pm} belongs to ${e.adr}, not ${id}`);
      if (e.linked < MINPM) v(`${ref} (${id}): pre-mortem ${pm} has ${e.linked} failure reason(s) linked to existing risks (need ≥ ${MINPM})`);
    }
  }
  const rd = g(r, "review_date");
  if ((status === "proposed" || status === "accepted") && !isDate(rd))
    v(`${ref} (${id}): review_date "${rd}" required as ${status === "proposed" ? "decide-by" : "review"} date (YYYY-MM-DD)`);
  else if (rd && !isDate(rd)) v(`${ref} (${id}): review_date "${rd}" not YYYY-MM-DD`);
});
decisions.forEach((r, i) => {
  const id = g(r, "id"), status = g(r, "status");
  if (!status.startsWith("superseded-by:")) return;
  const target = status.slice("superseded-by:".length);
  if (target === id) v(`decisions.tsv row ${i + 1} (${id}): superseded by itself`);
  else if (!ids.has(target)) v(`decisions.tsv row ${i + 1} (${id}): superseded-by target ${target} does not exist — superseded rows point at a retained later decision`);
  else if (Number(target.slice(4)) < Number(id.slice(4))) v(`decisions.tsv row ${i + 1} (${id}): superseded-by target ${target} is an earlier id`);
});
premortems.forEach((p, i) => {
  const adr = g(p, "adr_id");
  if (adr && !ids.has(adr)) v(`premortems.csv row ${i + 1} (${g(p, "premortem_id")}): adr_id ${adr} does not exist in decisions.tsv`);
});
viol.forEach((m) => console.error(m));
console.error(`adrs=${decisions.length} proposed=${stats.proposed} accepted=${stats.accepted} deprecated=${stats.deprecated} superseded=${stats.superseded} money_or_legal=${stats.money} one_way=${stats.one_way} premortems=${pmByRef.size} risks=${risks.length} today=${today}`);
console.log(`GOVERNANCE_VIOLATIONS: ${viol.length}`);
' "$today" "$has_pm" "$pfile"
}
