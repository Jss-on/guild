#!/usr/bin/env bash
# score-guild.sh — scoring backend for guild (business: idea → first paying customer).
#
#   pass-rate [results.tsv]                    → weighted acceptance pass-rate        "PASS_RATE: 0.NN"
#   coverage  [results.tsv] [vrs.md]           → VRS traceability (RTM gate)          "REQ_COVERAGE: 0.NN"
#   verdict   [results.tsv] [vrs.md|-] [pipeline.tsv]
#                                              → NOT_READY | OPEN_FOR_BUSINESS | FIRST_CUSTOMER
#
# Planned gates — each lands together with its fixture test; the frozen
# scripts/score-e2e-capability.sh names the rows:
#   citations  <doc.md> <claims.tsv>           → unsourced numeric claims             "UNSOURCED_CLAIMS: N"
#   interviews <interviews.tsv> [quota.tsv]    → ledger completeness + segment quota   "INTERVIEWS: x/y"
#   icp        <icp.md> <interviews.tsv>       → ICP attributes traced to interviews   "ICP_TRACE: 0.NN"
#   economics  <model.csv> [assertions.tsv]    → unit-economics assertions at corners  "ECON_PASS: x/y"
#   pricing    <pricing.csv> <model.csv> <competitors.csv>
#                                              → floor / band / VAT violations         "PRICE_VIOLATIONS: N"
#   funnel     <pipeline.tsv> [targets.tsv]    → stage conversion + paying customers   "PAYING_CUSTOMERS: N"
#   assets     <dir>                           → sales/marketing asset lint            "ASSET_LINT: N"
#   compliance <register.csv>                  → registrations with document evidence  "COMPLIANCE: x/y"
#   board      <run-dir>                       → board pack derived from ledgers       "BOARD_PACK: OK|STALE|INCOMPLETE"
#
# pass-rate (higher_is_better):
#   - weights renormalized over the dims that actually ran:
#       evidence 0.25 · customer 0.20 · offer 0.15 · economics 0.15 · gtm 0.10
#       · operations 0.05 · governance 0.10
#   - EVIDENCE GATE: while ANY `evidence` row is red, the headline rate is capped at
#     EVIDENCE_GATE_CAP (default 0.50) — a business built on fabricated or unsourced numbers
#     cannot be polished over.
#   - per-dimension score = sum(weight of pass) / sum(weight of pass|fail); skip excluded.
#   - no measurable rows → PASS_RATE: 0.00 (honest baseline).
#   - STDOUT is exactly one line; breakdown goes to STDERR.
#   - exit 0 on well-formed input (a red baseline is valid data); exit 2 on hard error only.
#
# verdict:
#   NOT_READY          — evidence gate red, or a must-pass dim (customer, economics) red, or
#                        rate < TARGET_RATE (default 1.00), or VRS coverage < 1.00 when a VRS is given
#   OPEN_FOR_BUSINESS  — all of the above clear
#   FIRST_CUSTOMER     — OPEN_FOR_BUSINESS and pipeline.tsv holds ≥ 1 `won` row carrying BOTH an
#                        invoice id and a payment evidence path. pipeline.tsv is HUMAN-ENTERED —
#                        the loop never writes it (10 tab-separated cols):
#                          id segment account stage value currency next_action updated invoice payment
#                          stage ∈ lead|contacted|meeting|proposal|won|lost
#                          invoice = invoice number or "-"; payment = evidence:<relpath> or "-"
#
# Overridable env: GUILD_RESULTS, VRS_MD, EVIDENCE_GATE_CAP, TARGET_RATE,
#   GUILD_W_EVIDENCE, GUILD_W_CUSTOMER, GUILD_W_OFFER, GUILD_W_ECONOMICS, GUILD_W_GTM,
#   GUILD_W_OPERATIONS, GUILD_W_GOVERNANCE
set -uo pipefail
export LC_ALL=C

GUILD_W_EVIDENCE="${GUILD_W_EVIDENCE:-0.25}"
GUILD_W_CUSTOMER="${GUILD_W_CUSTOMER:-0.20}"
GUILD_W_OFFER="${GUILD_W_OFFER:-0.15}"
GUILD_W_ECONOMICS="${GUILD_W_ECONOMICS:-0.15}"
GUILD_W_GTM="${GUILD_W_GTM:-0.10}"
GUILD_W_OPERATIONS="${GUILD_W_OPERATIONS:-0.05}"
GUILD_W_GOVERNANCE="${GUILD_W_GOVERNANCE:-0.10}"
EVIDENCE_GATE_CAP="${EVIDENCE_GATE_CAP:-0.50}"

die() { echo "score-guild: $*" >&2; exit 2; }

pass_rate() {
  local tsv="${1:-${GUILD_RESULTS:-guild-results.tsv}}"
  [[ -f "$tsv" ]] || die "no results TSV: $tsv"
  awk -F'\t' \
    -v cap="$EVIDENCE_GATE_CAP" \
    -v wEv="$GUILD_W_EVIDENCE" -v wCu="$GUILD_W_CUSTOMER" -v wOf="$GUILD_W_OFFER" \
    -v wEc="$GUILD_W_ECONOMICS" -v wGt="$GUILD_W_GTM" -v wOp="$GUILD_W_OPERATIONS" \
    -v wGo="$GUILD_W_GOVERNANCE" '
    /^#/ { next } $1 == "n" { next } NF < 5 { next }
    {
      dim = $2; st = $4; w = $5 + 0
      if (st == "skip") next
      den[dim] += w
      if (st == "pass") num[dim] += w
      if (dim == "evidence" && st == "fail") efail++
      rows++
    }
    END {
      if (rows == 0) { print "PASS_RATE: 0.00"; exit 0 }
      W["evidence"] = wEv; W["customer"] = wCu; W["offer"] = wOf; W["economics"] = wEc
      W["gtm"] = wGt; W["operations"] = wOp; W["governance"] = wGo
      D = 0; N = 0
      for (d in den) {
        dw = (d in W) ? W[d] : 0.10
        frac = (den[d] > 0) ? num[d] / den[d] : 0
        D += dw; N += dw * frac
        printf "dim %-12s %.2f (w=%.2f)\n", d, frac, dw > "/dev/stderr"
      }
      rate = (D > 0) ? N / D : 0
      if (efail > 0) {
        printf "EVIDENCE_GATE: %d red row(s), cap %.2f\n", efail, cap > "/dev/stderr"
        if (rate > cap) rate = cap
      }
      printf "PASS_RATE: %.2f\n", rate
    }' "$tsv"
}

coverage() {
  local rows="${1:-${GUILD_RESULTS:-guild-results.tsv}}" vrs="${2:-${VRS_MD:-vrs/requirements.md}}"
  if [[ "$rows" == "--spec" ]]; then rows="${2:?spec file}"; vrs="${3:?vrs file}"; fi
  [[ -f "$rows" ]] || die "coverage: missing $rows"
  [[ -f "$vrs" ]] || die "coverage: missing $vrs"
  local id covered=0 total=0 ids
  ids=$(grep -oE 'V-[0-9]+' "$vrs" | sort -u)
  if [[ -z "$ids" ]]; then echo "no V-n ids found in $vrs" >&2; echo "REQ_COVERAGE: 0.00"; return 0; fi
  while IFS= read -r id; do
    total=$((total + 1))
    if grep -qE "\b${id}\b" "$rows"; then covered=$((covered + 1)); else echo "uncovered: $id" >&2; fi
  done <<<"$ids"
  local oid
  for oid in $(grep -oE 'V-[0-9]+' "$rows" | sort -u); do
    grep -qE "\b${oid}\b" "$vrs" || echo "orphan trace (not in VRS): $oid" >&2
  done
  awk -v c="$covered" -v t="$total" 'BEGIN { printf "REQ_COVERAGE: %.2f\n", (t > 0) ? c / t : 0 }'
}

# paying_count <pipeline.tsv> → number of won rows with BOTH invoice id and payment evidence
paying_count() {
  awk -F'\t' '
    /^#/ { next } $1 == "id" { next } NF < 10 { next }
    $4 == "won" && $9 != "" && $9 != "-" && $10 ~ /^evidence:/ { c++ }
    END { print c + 0 }' "$1"
}

verdict() {
  local tsv="${1:-${GUILD_RESULTS:-guild-results.tsv}}" vrs="${2:-}" pipe="${3:-}"
  [[ -f "$tsv" ]] || die "no results TSV: $tsv"
  local rate efail mustfail cov="1.00" target="${TARGET_RATE:-1.00}" paying=0
  rate=$(pass_rate "$tsv" 2>/dev/null | awk '{print $2}')
  efail=$(awk -F'\t' '$1 != "n" && !/^#/ && $2 == "evidence" && $4 == "fail" { c++ } END { print c + 0 }' "$tsv")
  mustfail=$(awk -F'\t' '$1 != "n" && !/^#/ && ($2 == "customer" || $2 == "economics") && $4 == "fail" { c++ } END { print c + 0 }' "$tsv")
  [[ -n "$vrs" && "$vrs" != "-" ]] && cov=$(coverage "$tsv" "$vrs" 2>/dev/null | awk '{print $2}')
  if [[ -n "$pipe" ]]; then
    [[ -f "$pipe" ]] || die "verdict: missing pipeline $pipe"
    paying=$(paying_count "$pipe")
  fi
  if awk -v r="$rate" -v t="$target" 'BEGIN { exit !(r + 0 >= t + 0) }' \
    && [[ "$efail" == 0 && "$mustfail" == 0 && "$cov" == "1.00" ]]; then
    echo "rate=$rate target=$target coverage=$cov paying_customers=$paying" >&2
    if [[ "$paying" -ge 1 ]]; then echo "FIRST_CUSTOMER"; else echo "OPEN_FOR_BUSINESS"; fi
  else
    echo "blocking: rate=$rate target=$target evidence_fails=$efail must-pass_fails=$mustfail coverage=$cov paying_customers=$paying" >&2
    echo "NOT_READY"
  fi
}

usage() {
  cat >&2 <<'USAGE'
usage: score-guild.sh {pass-rate|coverage|verdict} [args]
  pass-rate [results.tsv]
  coverage  [results.tsv] [vrs.md]  |  coverage --spec <spec.yaml> <vrs.md>
  verdict   [results.tsv] [vrs.md|-] [pipeline.tsv]
USAGE
}

sub="${1:-}"; [[ $# -gt 0 ]] && shift
case "$sub" in
  pass-rate) pass_rate "$@" ;;
  coverage)  coverage "$@" ;;
  verdict)   verdict "$@" ;;
  *) usage; exit 2 ;;
esac
