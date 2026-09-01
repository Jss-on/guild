#!/usr/bin/env bash
# gate: citations — numeric claims in a document that do not carry a resolving [C-n] token.
#   score-guild.sh citations <doc.md> <claims.tsv>   → "UNSOURCED_CLAIMS: N"   (offenders → stderr)
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error
#
# Unit of evaluation = a markdown "unit": a paragraph (lines until a blank line), a heading-free
# block, one table row (lines starting with |), or one list item (with its wrapped continuation
# lines). A unit is SOURCED when it carries ≥ 1 [C-n] token whose id exists in claims.tsv; an
# orphan token ([C-n] that resolves to nothing) does not source the unit.
# Numeric claims counted once each, in priority order: 12 % · 3.5x / 3× · ₱ / $ / PHP / USD / EUR
# amounts · 1,200 thousands groups · runs of 5+ digits. Four-digit years are ignored; headings and
# fenced code are skipped.
# Contract: references/evidence-protocol.md §4.

gate_citations() {
  local doc="${1:?usage: citations <doc.md> <claims.tsv>}"
  local claims="${2:?usage: citations <doc.md> <claims.tsv>}"
  [[ -f "$doc" ]]    || { echo "score-guild: citations: missing doc $doc" >&2; return 2; }
  [[ -f "$claims" ]] || { echo "score-guild: citations: missing claims $claims" >&2; return 2; }
  awk -v FS='\t' '
    function count_claims(s,   num) {
      gsub(/(^|[^0-9])(1[89]|20)[0-9][0-9]([^0-9]|$)/, " ", s)      # years are dates, not claims
      num = 0
      num += gsub(/[0-9]+(\.[0-9]+)?[ ]?%/, " ", s)
      num += gsub(/[0-9]+(\.[0-9]+)?[ ]?[xX×]([^A-Za-z0-9]|$)/, " ", s)
      num += gsub(/(₱|\$|PHP|USD|EUR)[ ]?[0-9][0-9,]*(\.[0-9]+)?/, " ", s)
      num += gsub(/[0-9]{1,3}(,[0-9]{3})+/, " ", s)
      num += gsub(/[0-9]{5,}/, " ", s)
      return num
    }
    function flush(   num, sourced, t, id) {
      if (unit == "") return
      num = count_claims(unit)
      if (num > 0) {
        sourced = 0; t = unit
        while (match(t, /\[C-[0-9]+\]/)) {
          id = substr(t, RSTART + 1, RLENGTH - 2)
          if (id in have) sourced = 1
          else printf "line %d: orphan token [%s] (not in claims ledger)\n", ustart, id > "/dev/stderr"
          t = substr(t, RSTART + RLENGTH)
        }
        if (!sourced) {
          unsourced += num
          printf "line %d: %d numeric claim(s) without a resolving [C-n]: %s\n", ustart, num, substr(unit, 1, 100) > "/dev/stderr"
        }
      }
      unit = ""; ustart = 0
    }
    FNR == NR {   # claims.tsv → id set
      if ($0 ~ /^#/ || ($1 == "id" && $2 == "rq") || NF == 0) next;
      if ($1 ~ /^C-[0-9]+$/) have[$1] = 1;
      next;
    }
    /^```/ { flush(); fence = !fence; next }
    fence { next }
    /^#/ { flush(); next }
    /^[[:space:]]*$/ { flush(); next }
    /^[[:space:]]*\|/ { flush(); unit = $0; ustart = FNR; flush(); next }               # table row = own unit
    /^[[:space:]]*([-*+]|[0-9]+\.)[[:space:]]/ { flush(); unit = $0; ustart = FNR; next } # list item starts a unit
    { if (unit == "") ustart = FNR; unit = unit " " $0 }
    END { flush(); printf "UNSOURCED_CLAIMS: %d\n", unsourced + 0 }
  ' "$claims" "$doc"
}
