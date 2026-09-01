#!/usr/bin/env bash
# gate: founders — founders'-agreement validity. The gate that blocks the first external-money
# step (SAFE, loan, grant, advisor grant): no split, no vesting, no IP assignment, no signature —
# no money.
#   score-guild.sh founders <founders-agreement.yaml>
#     → "FOUNDERS_AGREEMENT: VALID|INVALID founders=N split=NNN vesting=<y>y/<m>m signed=Y|N"
#   exit 0 VALID · 1 INVALID (every reason → stderr) · 2 hard error (missing / unparseable file)
#
# founders-agreement.yaml — HUMAN-ENTERED (the loop drafts drafts/founders-agreement.yaml only):
#   company:                     working or registered name
#   split:                       list of {founder, pct}; pct sums to 100 (YC default: equal split)
#   vesting_years: 4             YC default ("typical Valley arrangement"); other values need
#   cliff_months: 12             vesting_adr_ref: ADR-<n> recording the deviation (25 % at the
#                                cliff, then 1/48 per month)
#   vesting_adr_ref:             ADR id, only when vesting deviates from 4 y / 12 m
#   ip_assigned_to_company: true every founder's background + foreground IP assigned in writing
#   roles:                       list of {founder, role, accountable_for} — every split founder
#   decision_rights:             list of decisions needing unanimity / a named approver
#   departure_terms:             map or list: good_leaver, bad_leaver, buyback, unvested forfeiture
#   signed_date: YYYY-MM-DD      signed_pdf: evidence:<path to the signed instrument>
# Policy env: GUILD_VESTING_YEARS (4), GUILD_CLIFF_MONTHS (12).
# Contract: references/governance-protocol.md §1.

gate_founders() {
  local file="${1:?usage: founders <founders-agreement.yaml>}"
  if [[ ! -f "$file" ]]; then
    echo "FOUNDERS_AGREEMENT: INVALID founders=0 split=0 vesting=?/? signed=N"
    echo "file not found: $file" >&2
    return 2
  fi
  local json
  if ! json="$(guild_yaml_json "$file")"; then
    echo "FOUNDERS_AGREEMENT: INVALID founders=0 split=0 vesting=?/? signed=N"
    echo "unparseable YAML: $file" >&2
    return 2
  fi
  printf '%s' "$json" | node -e '
const fs = require("fs");
const num = (v, d) => (v !== undefined && v !== "" && !isNaN(Number(v)) ? Number(v) : d);
const VY = num(process.env.GUILD_VESTING_YEARS, 4), CM = num(process.env.GUILD_CLIFF_MONTHS, 12);
let d;
try { d = JSON.parse(fs.readFileSync(0, "utf8")); } catch (e) { d = null; }
if (!d || typeof d !== "object" || Array.isArray(d)) {
  console.log("FOUNDERS_AGREEMENT: INVALID founders=0 split=0 vesting=?/? signed=N");
  console.error("founders-agreement: top level must be a mapping");
  process.exit(2);
}
const errs = []; const err = (m) => errs.push(m);
const str = (v) => (v === undefined || v === null ? "" : String(v)).trim();
// ---- split: list of {founder, pct} summing to 100 ------------------------------------------
const split = Array.isArray(d.split) ? d.split : null;
let sum = 0; const founders = [];
if (!split || !split.length) err("split: missing or empty (list of {founder, pct})");
else split.forEach((s, i) => {
  if (!s || typeof s !== "object") { err(`split[${i}]: not a {founder, pct} map`); return; }
  const f = str(s.founder), p = Number(s.pct);
  if (!f) err(`split[${i}]: founder missing`); else founders.push(f);
  if (!(p > 0)) err(`split[${i}] (${f || "?"}): pct missing or not > 0`); else sum += p;
});
if (split && split.length && Math.abs(sum - 100) > 0.01)
  err(`split sums to ${Math.round(sum * 100) / 100} (must be 100)`);
// ---- vesting: 4 y / 12 m unless an ADR records the deviation --------------------------------
const adr = str(d.vesting_adr_ref || d.adr_ref);
const adrOk = /^ADR-\d+$/.test(adr);
if (adr && !adrOk) err(`vesting_adr_ref="${adr}" is not an ADR id (ADR-<n>)`);
const vy = d.vesting_years, cm = d.cliff_months;
if (vy === undefined || vy === null || vy === "") err(`vesting_years: missing (YC default ${VY})`);
else if (Number(vy) !== VY && !adrOk) err(`vesting_years=${vy} deviates from ${VY} without vesting_adr_ref (ADR-<n>)`);
if (cm === undefined || cm === null || cm === "") err(`cliff_months: missing — no cliff (YC default ${CM}; a deviation needs vesting_adr_ref)`);
else if (Number(cm) !== CM && !adrOk) err(`cliff_months=${cm} deviates from ${CM} without vesting_adr_ref (ADR-<n>)`);
// ---- IP assignment ---------------------------------------------------------------------------
if (d.ip_assigned_to_company !== true)
  err(`ip_assigned_to_company is ${d.ip_assigned_to_company === undefined ? "missing" : JSON.stringify(d.ip_assigned_to_company)} (must be true)`);
// ---- roles: every split founder has one -----------------------------------------------------
const roles = d.roles;
if (Array.isArray(roles)) {
  if (!roles.length) err("roles: empty");
  const named = new Set();
  roles.forEach((r, i) => {
    if (!r || typeof r !== "object" || !str(r.founder) || !str(r.role)) err(`roles[${i}]: needs founder + role`);
    else named.add(str(r.founder));
  });
  founders.forEach((f) => { if (!named.has(f)) err(`roles: founder ${f} in split has no role`); });
} else if (roles && typeof roles === "object") {
  if (!Object.keys(roles).length) err("roles: empty");
  founders.forEach((f) => { if (!(f in roles) || !str(roles[f])) err(`roles: founder ${f} in split has no role`); });
} else err("roles: missing (list of {founder, role})");
// ---- decision rights -------------------------------------------------------------------------
const dr = d.decision_rights;
const drItems = Array.isArray(dr) ? dr.filter((x) => str(typeof x === "object" && x ? JSON.stringify(x) : x)) : [];
if (!drItems.length) err("decision_rights: missing or empty (list of decisions needing unanimity / a named approver)");
// ---- departure terms -------------------------------------------------------------------------
const dt = d.departure_terms;
const dtOk = (typeof dt === "string" && dt.trim()) || (Array.isArray(dt) && dt.length) ||
             (dt && typeof dt === "object" && !Array.isArray(dt) && Object.keys(dt).length);
if (!dtOk) err("departure_terms: missing or empty (good/bad leaver, buy-back, unvested forfeiture)");
// ---- signature -------------------------------------------------------------------------------
const sd = str(d.signed_date);
if (!/^20\d\d-\d\d-\d\d$/.test(sd)) err(sd ? `signed_date="${sd}" is not YYYY-MM-DD` : "signed_date: missing — agreement unsigned");
const sp = str(d.signed_pdf);
if (!sp || sp === "-") err("signed_pdf: missing — no signed instrument on file");
// ---- emit ------------------------------------------------------------------------------------
errs.forEach((m) => console.error("founders-agreement: " + m));
const verdict = errs.length ? "INVALID" : "VALID";
const vys = vy === undefined || vy === null || vy === "" ? "?" : String(vy);
const cms = cm === undefined || cm === null || cm === "" ? "?" : String(cm);
console.log(`FOUNDERS_AGREEMENT: ${verdict} founders=${founders.length} split=${Math.round(sum * 100) / 100} vesting=${vys}y/${cms}m signed=${/^20\d\d-\d\d-\d\d$/.test(sd) && sp && sp !== "-" ? "Y" : "N"}`);
process.exit(errs.length ? 1 : 0);
'
}
