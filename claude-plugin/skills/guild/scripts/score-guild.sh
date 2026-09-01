#!/usr/bin/env bash
# score-guild.sh — scoring backend for guild (business: idea → first paying customer).
#
#   pass-rate [results.tsv] [--strict-evidence] → weighted acceptance pass-rate    "PASS_RATE: 0.NN"
#   coverage  [results.tsv] [vrs.md]            → VRS traceability (RTM gate)      "REQ_COVERAGE: 0.NN"
#   validate  <venture.spec.yaml>               → discover → build contract        "VALIDATION: VALID|INVALID|ERROR"
#   verdict   [results.tsv] [vrs.md|-] [pipeline.tsv]
#                                               → NOT_READY | OPEN_FOR_BUSINESS | FIRST_CUSTOMER
#   paying    <pipeline.tsv>                    → won rows with invoice + payment evidence "PAYING_CUSTOMERS: N"
#
# Planned gates — each lands together with its fixture test AND a good/bad fixture pair the
# frozen scripts/score-e2e-capability.sh executes (references/metrics.md has the full surface):
#   sources    <sources.tsv>                    → source-ledger validity (forge research schema)  "SOURCES: VALID|INVALID …"
#   claims     <claims.tsv> <sources.tsv>       → claims-ledger validity (tier floors, anchoring) "CLAIMS: VALID|INVALID …"
#   citations  <doc.md> <claims.tsv>            → numeric claims in a doc without a [C-n] ref     "UNSOURCED_CLAIMS: N"
#   interviews <interviews.tsv> [quota.tsv]     → ledger completeness + per-segment quota          "INTERVIEWS: x/y"
#   icp        <icp.md> <interviews.tsv>        → ICP attributes traced to ≥ k interview ids       "ICP_TRACE: 0.NN"
#   vrs        <vrs.md>                         → V-n measurability (metric+threshold+method)      "VRS_MEASURABLE: x/y"
#   economics  <model.csv> [assertions.tsv]     → unit-economics assertions at corners             "ECON_PASS: x/y"
#   pricing    <pricing.csv> <model.csv> <competitors.csv>
#                                               → floor / band / VAT violations                    "PRICE_VIOLATIONS: N"
#   funnel     <pipeline.tsv> [targets.tsv]     → stage conversion + paying customers              "PAYING_CUSTOMERS: N"
#   assets     <dir>                            → sales/marketing asset lint                       "ASSET_LINT: N"
#   sow        <sow.md>                         → SOW completeness lint                            "SOW_MISSING: N"
#   compliance <register.csv>                   → registrations with document evidence             "COMPLIANCE: x/y"
#   cash       <forecast.csv>                   → 13-week cash forecast closes; reserve months      "CASH_PASS: x/y"
#   board      <run-dir>                        → board pack derived from ledgers                   "BOARD_PACK: OK|STALE|INCOMPLETE"
#
# pass-rate (higher_is_better):
#   - guild-results.tsv, 7 tab-separated cols: n dimension assertion status weight evidence traces
#   - weights renormalized over the dims that actually ran:
#       evidence 0.25 · customer 0.20 · offer 0.15 · economics 0.15 · gtm 0.10
#       · operations 0.05 · governance 0.10
#   - EVIDENCE GATE: while ANY `evidence` row is red, the headline rate is capped at
#     EVIDENCE_GATE_CAP (default 0.50) — a business built on fabricated or unsourced numbers
#     cannot be polished over.
#   - per-dimension score = sum(weight of pass) / sum(weight of pass|fail); skip excluded.
#   - headline is FLOORED to 2 decimals (never rounds up); single weighted division keeps an
#     all-pass ledger at exactly 1.00 (the forge lesson).
#   - --strict-evidence (or GUILD_EVIDENCE_STRICT=1): a `pass` row whose `evidence:<relpath>`
#     does not resolve (relative to GUILD_EVIDENCE_DIR, the TSV's dir, or cwd) is scored `fail`
#     and tagged EVIDENCE-MISSING — a claim of evidence is not evidence.
#   - no results file / no measurable rows → PASS_RATE: 0.00 (honest baseline). No implicit
#     discovery of some other ledger — score only what the caller named (or GUILD_RESULTS).
#   - STDOUT is exactly one line; breakdown goes to STDERR.
#   - exit 0 on well-formed input (a red baseline is valid data); exit 2 on hard error only.
#
# validate — the contract between discover → build. A venture spec is VALID iff it has a `name`,
#   a `thesis` (or `summary`), a top-level `segment:` block with an `icp:` line (the ICP election,
#   a charter-level early irreversible), and an `acceptance:` block covering ALL SEVEN dimensions
#   with ≥ 1 weighted assertion, where the gating/must-pass dimensions (evidence, customer,
#   economics) each carry ≥ 1 gated row (gate: true).   exit 0 VALID / 1 INVALID / 2 ERROR
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
#   Strict evidence applies to the verdict when GUILD_EVIDENCE_STRICT=1.
#
# Overridable env: GUILD_RESULTS, VRS_MD, EVIDENCE_GATE_CAP, TARGET_RATE, GUILD_EVIDENCE_STRICT,
#   GUILD_EVIDENCE_DIR, GUILD_W_EVIDENCE, GUILD_W_CUSTOMER, GUILD_W_OFFER, GUILD_W_ECONOMICS,
#   GUILD_W_GTM, GUILD_W_OPERATIONS, GUILD_W_GOVERNANCE
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
DIMS="evidence customer offer economics gtm operations governance"
GATED_DIMS="evidence customer economics"

die() { echo "score-guild: $*" >&2; exit 2; }

# Domain gates live one per file in scripts/gates/<name>.sh and define gate_<name>(); they are
# sourced here so the plugin tree (skills/guild/scripts/gates/) resolves the same way.
GUILD_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GATES_DIR="$GUILD_SCRIPT_DIR/gates"
if [[ -d "$GATES_DIR" ]]; then
  for _g in "$GATES_DIR"/*.sh; do [[ -f "$_g" ]] && source "$_g"; done
fi
run_gate() { # run_gate <name> [args…] — dispatch to gate_<name> or fail closed
  local name="$1"; shift
  if declare -F "gate_$name" >/dev/null 2>&1; then "gate_$name" "$@"
  else echo "score-guild: gate '$name' not implemented (scripts/gates/$name.sh)" >&2; return 2; fi
}

# resolve_results [args…] → path or return 1. Explicit arg or GUILD_RESULTS only — never a
# discovered file the caller did not name (a stale ledger scoring 1.00 is a false green).
resolve_results() {
  local a
  for a in "$@"; do
    if [[ "$a" == *.tsv && -f "$a" ]]; then printf '%s' "$a"; return 0; fi
  done
  if [[ -n "${GUILD_RESULTS:-}" ]]; then
    [[ -f "$GUILD_RESULTS" ]] && { printf '%s' "$GUILD_RESULTS"; return 0; }
  fi
  return 1
}

# apply_evidence_strict <results.tsv> → path of a temp TSV where every `pass` row whose
# evidence path does not resolve is rewritten to `fail … EVIDENCE-MISSING`.
apply_evidence_strict() {
  local results="$1" evdir tmp miss=0 line
  evdir="${GUILD_EVIDENCE_DIR:-$(dirname "$results")}"
  tmp="$(mktemp)"
  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      '#'*|'n'$'\t'*) printf '%s\n' "$line" >> "$tmp"; continue ;;
    esac
    local IFS=$'\t'; read -r -a c <<< "$line"; unset IFS
    if [[ "${#c[@]}" -ge 5 && "${c[3]}" == "pass" ]]; then
      local detail="${c[5]:-}" ref="" ok=0
      ref="$(printf '%s' "$detail" | grep -oE 'evidence:[^#[:space:],;]+' | head -1 | cut -d: -f2-)"
      if [[ -n "$ref" ]]; then
        if [[ -f "$evdir/$ref" || -f "$(dirname "$results")/$ref" || -f "$ref" ]]; then ok=1; fi
      fi
      if [[ "$ok" -eq 0 ]]; then
        c[3]="fail"
        c[5]="${detail:+$detail; }EVIDENCE-MISSING"
        miss=$((miss + 1))
        local out="" i
        for i in "${!c[@]}"; do out+="${c[$i]}"$'\t'; done
        printf '%s\n' "${out%$'\t'}" >> "$tmp"
        continue
      fi
    fi
    printf '%s\n' "$line" >> "$tmp"
  done < "$results"
  echo "evidence_violations=$miss" >&2
  printf '%s' "$tmp"
}

# effective_tsv <results.tsv> → the TSV to score (strict-rewritten temp file when strict is on).
# Caller removes the temp file when it differs from the input.
effective_tsv() {
  if [[ "${GUILD_EVIDENCE_STRICT:-0}" == "1" ]]; then apply_evidence_strict "$1"; else printf '%s' "$1"; fi
}

pass_rate() {
  local a args=()
  for a in "$@"; do
    if [[ "$a" == "--strict-evidence" ]]; then GUILD_EVIDENCE_STRICT=1; else args+=("$a"); fi
  done
  set -- ${args[@]+"${args[@]}"}
  local results
  if ! results="$(resolve_results "$@")"; then
    echo "PASS_RATE: 0.00"
    echo "dims_ran=none" >&2
    echo "reason=no-results-tsv (pass an explicit path or set GUILD_RESULTS)" >&2
    return 0
  fi
  local eff; eff="$(effective_tsv "$results")"
  awk -F'\t' \
    -v cap="$EVIDENCE_GATE_CAP" -v ORDER="$DIMS" \
    -v wEv="$GUILD_W_EVIDENCE" -v wCu="$GUILD_W_CUSTOMER" -v wOf="$GUILD_W_OFFER" \
    -v wEc="$GUILD_W_ECONOMICS" -v wGt="$GUILD_W_GTM" -v wOp="$GUILD_W_OPERATIONS" \
    -v wGo="$GUILD_W_GOVERNANCE" '
    /^#/ { next } $1 == "n" { next } NF < 5 { next }
    {
      dim = $2; st = $4; w = $5 + 0
      if (w <= 0) w = 1
      if (st == "skip") next
      den[dim] += w
      if (st == "pass") num[dim] += w
      if (dim == "evidence" && st == "fail") efail++
      rows++
    }
    END {
      if (rows == 0) { print "PASS_RATE: 0.00"; print "dims_ran=none" > "/dev/stderr"; exit 0 }
      W["evidence"] = wEv; W["customer"] = wCu; W["offer"] = wOf; W["economics"] = wEc
      W["gtm"] = wGt; W["operations"] = wOp; W["governance"] = wGo
      n = split(ORDER, order, " ")
      tot = 0; ran = ""; unavail = ""; unknown = ""
      for (i = 1; i <= n; i++) {
        d = order[i]
        if ((d in den) && den[d] > 0) { score[d] = num[d] / den[d]; tot += W[d]; ran = ran (ran == "" ? "" : ",") d }
        else unavail = unavail (unavail == "" ? "" : ",") d
      }
      for (d in den) if (!(d in W)) {   # unknown dimension: counted at 0.10 so a typo cannot hide a red row
        score[d] = num[d] / den[d]; W[d] = 0.10; tot += 0.10; unknown = unknown (unknown == "" ? "" : ",") d
      }
      if (tot == 0) { print "PASS_RATE: 0.00"; print "dims_ran=none" > "/dev/stderr"; exit 0 }
      wnum = 0
      for (d in score) wnum += W[d] * score[d]
      pr = wnum / tot
      disp = int(pr * 100 + 1e-9) / 100
      gate = "PASS"
      if (efail > 0) { if (disp > cap + 0) disp = cap + 0; gate = sprintf("CAPPED@%.2f (%d red evidence row(s))", cap + 0, efail) }
      printf "PASS_RATE: %.2f\n", disp
      printf "dims_ran=%s\n", (ran == "" ? "none" : ran) > "/dev/stderr"
      printf "dims_unavailable=%s\n", (unavail == "" ? "none" : unavail) > "/dev/stderr"
      if (unknown != "") printf "dims_unknown=%s (scored at 0.10 — fix the dimension name)\n", unknown > "/dev/stderr"
      printf "evidence_gate=%s\n", gate > "/dev/stderr"
      for (i = 1; i <= n; i++) { d = order[i]; if (d in score) printf "  %-11s score=%.2f weight=%.2f\n", d, int(score[d] * 100 + 1e-9) / 100, W[d] > "/dev/stderr" }
    }' "$eff"
  [[ "$eff" != "$results" ]] && rm -f "$eff"
  return 0
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
  awk -v c="$covered" -v t="$total" 'BEGIN { r = (t > 0) ? c / t : 0; printf "REQ_COVERAGE: %.2f\n", int(r * 100 + 1e-9) / 100 }'
}

validate() {
  local spec="${1:?usage: validate <venture.spec.yaml>}"
  if [[ ! -f "$spec" ]]; then echo "VALIDATION: ERROR"; echo "reason=missing-file"; return 2; fi
  local has_name has_thesis has_segment has_icp has_accept weights
  has_name=$(grep -cE '^name:' "$spec" || true)
  has_thesis=$(grep -cE '^(thesis|summary):' "$spec" || true)
  has_segment=$(grep -cE '^segment:' "$spec" || true)
  has_icp=$(grep -cE '^[[:space:]]+icp:' "$spec" || true)
  has_accept=$(grep -cE '^acceptance:' "$spec" || true)
  weights=$(grep -cE '(^|[[:space:],{])weight:' "$spec" || true)
  # per-dimension presence + gated-row counts, scoped to the acceptance block
  local table
  table=$(awk -v DIMS="$DIMS" '
    BEGIN { n = split(DIMS, d, " "); for (i = 1; i <= n; i++) { want[d[i]] = 1; seen[d[i]] = 0; gated[d[i]] = 0 } }
    /^acceptance:/ { inacc = 1; cur = ""; next }
    inacc && /^[^[:space:]#]/ { inacc = 0 }
    inacc && /^  [a-z_]+:/ { cur = $1; sub(":", "", cur); if (cur in want) seen[cur] = 1; next }
    inacc && cur != "" && /gate:[[:space:]]*true/ { gated[cur]++ }
    END { for (i = 1; i <= n; i++) printf "%s %d %d\n", d[i], seen[d[i]], gated[d[i]] }' "$spec")
  local present="" missing="" gatedok=1 gatedrep="" line dname dseen dgated
  while read -r dname dseen dgated; do
    [[ -z "$dname" ]] && continue
    if [[ "$dseen" -eq 1 ]]; then present="$present${present:+,}$dname"; else missing="$missing${missing:+,}$dname"; fi
    for g in $GATED_DIMS; do
      if [[ "$dname" == "$g" ]]; then
        gatedrep="$gatedrep${gatedrep:+,}$dname:$dgated"
        [[ "$dgated" -ge 1 ]] || gatedok=0
      fi
    done
  done <<<"$table"
  local ok=1
  [[ "$has_name" -ge 1 ]]    || ok=0
  [[ "$has_thesis" -ge 1 ]]  || ok=0
  [[ "$has_segment" -ge 1 && "$has_icp" -ge 1 ]] || ok=0
  [[ "$has_accept" -ge 1 ]]  || ok=0
  [[ -z "$missing" ]]        || ok=0
  [[ "$weights" -ge 1 ]]     || ok=0
  [[ "$gatedok" -eq 1 ]]     || ok=0
  if [[ "$ok" -eq 1 ]]; then echo "VALIDATION: VALID"; else echo "VALIDATION: INVALID"; fi
  echo "name=$([[ $has_name -ge 1 ]] && echo yes || echo no) thesis=$([[ $has_thesis -ge 1 ]] && echo yes || echo no) segment_icp=$([[ $has_segment -ge 1 && $has_icp -ge 1 ]] && echo yes || echo no) acceptance=$([[ $has_accept -ge 1 ]] && echo yes || echo no) weights=$weights"
  echo "dims_present=${present:-none}"
  echo "dims_missing=${missing:-none}"
  echo "gated=${gatedrep:-none} (evidence, customer, economics each need >= 1 gate: true row)"
  [[ "$ok" -eq 1 ]] && return 0 || return 1
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
  local eff; eff="$(effective_tsv "$tsv")"
  local rate efail mustfail cov="1.00" target="${TARGET_RATE:-1.00}" paying=0
  rate=$(pass_rate "$eff" 2>/dev/null | awk '{print $2}')
  efail=$(awk -F'\t' '$1 != "n" && !/^#/ && $2 == "evidence" && $4 == "fail" { c++ } END { print c + 0 }' "$eff")
  mustfail=$(awk -F'\t' '$1 != "n" && !/^#/ && ($2 == "customer" || $2 == "economics") && $4 == "fail" { c++ } END { print c + 0 }' "$eff")
  [[ -n "$vrs" && "$vrs" != "-" ]] && cov=$(coverage "$eff" "$vrs" 2>/dev/null | awk '{print $2}')
  [[ "$eff" != "$tsv" ]] && rm -f "$eff"
  if [[ -n "$pipe" ]]; then
    [[ -f "$pipe" ]] || die "verdict: missing pipeline $pipe"
    paying=$(paying_count "$pipe")
  fi
  if awk -v r="$rate" -v t="$target" 'BEGIN { exit !(r + 0 >= t + 0) }' \
    && [[ "$efail" == 0 && "$mustfail" == 0 && "$cov" == "1.00" ]]; then
    echo "rate=$rate target=$target coverage=$cov paying_customers=$paying strict=${GUILD_EVIDENCE_STRICT:-0}" >&2
    if [[ "$paying" -ge 1 ]]; then echo "FIRST_CUSTOMER"; else echo "OPEN_FOR_BUSINESS"; fi
  else
    echo "blocking: rate=$rate target=$target evidence_fails=$efail must-pass_fails=$mustfail coverage=$cov paying_customers=$paying strict=${GUILD_EVIDENCE_STRICT:-0}" >&2
    echo "NOT_READY"
  fi
}

paying() {
  local pipe="${1:?usage: paying <pipeline.tsv>}"
  [[ -f "$pipe" ]] || die "paying: missing pipeline $pipe"
  echo "PAYING_CUSTOMERS: $(paying_count "$pipe")"
}

usage() {
  cat >&2 <<'USAGE'
usage: score-guild.sh <subcommand> [args]
  seam:    pass-rate [results.tsv] [--strict-evidence] | coverage [results.tsv] [vrs.md] |
           coverage --spec <spec.yaml> <vrs.md> | validate <venture.spec.yaml> |
           verdict [results.tsv] [vrs.md|-] [pipeline.tsv] | paying <pipeline.tsv>
  gates:   sources claims citations interviews icp vrs market competitors positioning offers
           pricing economics cash alive studio funnel experiments assets consent sow delivery
           regulatory ar compliance board decisions founders   (each: scripts/gates/<name>.sh;
           inputs + one-line output contract in references/metrics.md)
USAGE
}

sub="${1:-}"; [[ $# -gt 0 ]] && shift
case "$sub" in
  pass-rate)   pass_rate "$@" ;;
  coverage)    coverage "$@" ;;
  validate)    validate "$@" ;;
  verdict)     verdict "$@" ;;
  paying)      paying "$@" ;;
  # ---- evidence ----
  sources)     run_gate sources "$@" ;;
  claims)      run_gate claims "$@" ;;
  citations)   run_gate citations "$@" ;;
  # ---- discovery / market ----
  interviews)  run_gate interviews "$@" ;;
  icp)         run_gate icp "$@" ;;
  vrs)         run_gate vrs "$@" ;;
  market)      run_gate market "$@" ;;
  competitors) run_gate competitors "$@" ;;
  # ---- offer / pricing ----
  positioning) run_gate positioning "$@" ;;
  offers)      run_gate offers "$@" ;;
  pricing)     run_gate pricing "$@" ;;
  # ---- economics ----
  economics)   run_gate economics "$@" ;;
  cash)        run_gate cash "$@" ;;
  alive)       run_gate alive "$@" ;;
  studio)      run_gate studio "$@" ;;
  # ---- gtm / marketing ----
  funnel)      run_gate funnel "$@" ;;
  experiments) run_gate experiments "$@" ;;
  assets)      run_gate assets "$@" ;;
  consent)     run_gate consent "$@" ;;
  # ---- operations / finance / compliance ----
  sow)         run_gate sow "$@" ;;
  delivery)    run_gate delivery "$@" ;;
  regulatory)  run_gate regulatory "$@" ;;
  ar)          run_gate ar "$@" ;;
  compliance)  run_gate compliance "$@" ;;
  # ---- governance ----
  board)       run_gate board "$@" ;;
  decisions)   run_gate decisions "$@" ;;
  founders)    run_gate founders "$@" ;;
  *) usage; exit 2 ;;
esac
