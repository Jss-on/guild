#!/usr/bin/env bash
# validate-handoff.sh — gate a handoff.json before a chained command trusts it.
#   usage: validate-handoff.sh <handoff.json>
#   Prints "HANDOFF: VALID" (exit 0) or "HANDOFF: INVALID — <reasons>" (exit 1).
#   exit 2 on hard error (missing file / not JSON).
set -uo pipefail
export LC_ALL=C

f="${1:?usage: validate-handoff.sh <handoff.json>}"
[[ -f "$f" ]] || { echo "validate-handoff: no such file $f" >&2; exit 2; }

node -e '
const fs = require("fs");
let j;
try { j = JSON.parse(fs.readFileSync(process.argv[1], "utf8")); }
catch (e) { console.error("validate-handoff: not JSON — " + e.message); process.exit(2); }
const problems = [];
if (typeof j.command !== "string" || !j.command) problems.push("missing string field: command");
const verdict = j.verdict ?? j.status;
if (typeof verdict !== "string" || !verdict) problems.push("missing string field: verdict (or status)");
// coarse types on known optional fields
const numeric = ["pass_rate", "req_coverage", "unsourced_claims", "interviews", "paying_customers", "gross_margin", "ltv_cac", "payback_months", "runway_months"];
for (const k of numeric) {
  if (k in j && typeof j[k] !== "number" && isNaN(parseFloat(j[k]))) problems.push("non-numeric field: " + k);
}
if ("results_tsv" in j && typeof j.results_tsv !== "string") problems.push("non-string field: results_tsv");
if ("repo" in j && typeof j.repo !== "string") problems.push("non-string field: repo");
if (problems.length) { console.log("HANDOFF: INVALID — " + problems.join("; ")); process.exit(1); }
console.log("HANDOFF: VALID");
' "$f"
