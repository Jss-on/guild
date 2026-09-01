#!/usr/bin/env bash
# validate-handoff.sh — mechanical gate for the chain contract (handoff.json).
# Schema: forge handoff-schema v3.1.0, guild sources. A command's run is not finished
# until its handoff validates.
#
#   validate-handoff.sh <handoff.json> [expected-source]
#
#   exit 0 VALID · exit 1 INVALID (missing fields on stderr) · exit 2 unreadable
#
# Required core (every source): version, source (short name — never the colon form),
#   status ∈ COMPLETE|CONVERGED|BOUNDED|PLATEAU|BLOCKED|USER_INTERRUPT|ERROR, timestamp (ISO-8601).
# Required per source:
#   discover  → spec (venture.spec.yaml path) or vrs (VRS path)
#   build     → results_tsv, metric, config; CONVERGED additionally requires coverage
#   improve   → results_tsv
#   board     → verdict ∈ CONTINUE|PIVOT|KILL and pack (board-pack path)
#   guild     → results_tsv or metric (classic loop)
#   evals, plan → core only
# Parsing uses node's real JSON parser (node is a hard CORE dependency).
set -uo pipefail
export LC_ALL=C

FILE="${1:?usage: validate-handoff.sh <handoff.json> [expected-source]}"
EXPECT_SRC="${2:-}"

if [[ ! -f "$FILE" ]]; then
  echo "HANDOFF: INVALID"; echo "file not found: $FILE" >&2; exit 2
fi

ERRORS=0
err() { echo "$1" >&2; ERRORS=$((ERRORS + 1)); }

PARSED="$(node -e '
  const fs = require("fs");
  let j;
  try { j = JSON.parse(fs.readFileSync(process.argv[1], "utf8")); }
  catch { console.log("__PARSE_ERROR__"); process.exit(0); }
  const s = (k) => (typeof j[k] === "string" ? j[k] : "");
  const h = (k) => (k in j ? "1" : "0");
  console.log([s("version"), s("source"), s("status"), s("timestamp"), s("verdict"),
               h("results_tsv"), h("metric"), h("config"), h("coverage"),
               h("spec"), h("vrs"), h("pack")]
              .join(String.fromCharCode(31)));
' "$FILE" 2>/dev/null)"

if [[ "$PARSED" == "__PARSE_ERROR__" || -z "$PARSED" ]]; then
  echo "HANDOFF: INVALID"; echo "not valid JSON: $FILE" >&2; exit 1
fi
IFS=$'\x1f' read -r VERSION SOURCE STATUS TS VERDICT \
  H_RESULTS H_METRIC H_CONFIG H_COVERAGE H_SPEC H_VRS H_PACK <<< "$PARSED"

has_field() {
  case "$1" in
    results_tsv) [[ "$H_RESULTS"  == "1" ]] ;;
    metric)      [[ "$H_METRIC"   == "1" ]] ;;
    config)      [[ "$H_CONFIG"   == "1" ]] ;;
    coverage)    [[ "$H_COVERAGE" == "1" ]] ;;
    spec)        [[ "$H_SPEC"     == "1" ]] ;;
    vrs)         [[ "$H_VRS"      == "1" ]] ;;
    pack)        [[ "$H_PACK"     == "1" ]] ;;
    *) return 1 ;;
  esac
}

[[ -n "$VERSION" ]] || err "missing: version"
[[ -n "$SOURCE"  ]] || err "missing: source"
[[ -n "$STATUS"  ]] || err "missing: status"
[[ -n "$TS"      ]] || err "missing: timestamp"

if [[ -n "$SOURCE" ]] && printf '%s' "$SOURCE" | grep -q ':'; then
  err "source must be the short name, not a colon form (got: $SOURCE)"
fi

if [[ -n "$STATUS" ]]; then
  case "$STATUS" in
    COMPLETE|CONVERGED|BOUNDED|PLATEAU|BLOCKED|USER_INTERRUPT|ERROR) ;;
    *) err "status not in enum: $STATUS" ;;
  esac
fi

if [[ -n "$EXPECT_SRC" && -n "$SOURCE" && "$SOURCE" != "$EXPECT_SRC" ]]; then
  err "source mismatch: expected $EXPECT_SRC, got $SOURCE"
fi

case "$SOURCE" in
  discover)
    has_field spec || has_field vrs || err "missing: spec or vrs (required for discover)"
    ;;
  build)
    has_field results_tsv || err "missing: results_tsv (required for build)"
    has_field metric      || err "missing: metric (required for build)"
    has_field config      || err "missing: config (required for build)"
    if [[ "$STATUS" == "CONVERGED" ]] && ! has_field coverage; then
      err "missing: coverage (a CONVERGED build without coverage numbers is unverifiable)"
    fi
    ;;
  improve)
    has_field results_tsv || err "missing: results_tsv (required for improve)"
    ;;
  board)
    case "$VERDICT" in
      CONTINUE|PIVOT|KILL) ;;
      "") err "missing: verdict (CONTINUE|PIVOT|KILL) — required for board" ;;
      *)  err "verdict not in enum for board: $VERDICT (CONTINUE|PIVOT|KILL)" ;;
    esac
    has_field pack || err "missing: pack (board-pack path — required for board)"
    ;;
  guild)
    has_field results_tsv || has_field metric || err "missing: results_tsv or metric (required for guild)"
    ;;
  evals|plan|"") ;;
  *) echo "warn: unknown source $SOURCE (core fields only checked)" >&2 ;;
esac

if [[ "$ERRORS" -gt 0 ]]; then
  echo "HANDOFF: INVALID"; exit 1
fi
echo "HANDOFF: VALID"; exit 0
