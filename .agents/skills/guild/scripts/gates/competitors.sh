#!/usr/bin/env bash
# gate: competitors — alternatives register + price-snapshot ledger (brief 02 §5 G5; brief 03 §5
# G3.1). The status quo is a competitor; an alternative no interviewee named is a phantom; a price
# without a dated, archived, hashed capture is a rumour.
#   score-guild.sh competitors <alternatives.csv> <snapshots.csv>   → "COMPETITOR_VIOLATIONS: N"
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing file / column)
#   violations → stderr, one per line, naming the ledger line and the row; snapshots older than the
#   window → stderr "WARN" (history is kept, it just does not count as a current price).
#
# alternatives.csv (loop-written from interview codes; "# as_of: YYYY-MM-DD" first line):
#   alt_id name type url why_customer_uses_it evidence_interview_ids lost_deal_ids
#   type                    direct|indirect|status_quo|diy|do_nothing|in_house
#   evidence_interview_ids  semicolon-joined interview ids (I-7;I-12) from discovery/interviews.tsv
#   lost_deal_ids           semicolon-joined deal ids from gtm/pipeline.tsv, or "-"
# snapshots.csv (loop-captured; prices obtained by quote carry captured_by = the human):
#   snapshot_id alt_id plan_name list_price currency billing_period price_metric included_limits
#   discount_terms source_url archived_url captured_at captured_by screenshot_hash
#   price_metric    per_seat|per_device|per_site|flat|usage|project
#   billing_period  monthly|quarterly|annual|one_time|per_project|usage
#   archived_url    https://web.archive.org/web/<14 digits>/<url>; "-" only when source_url is
#                   quote:|email:|manual: (a quote a named human obtained) — the hash then covers
#                   the quote document
#   screenshot_hash 16–64 hex characters of the captured page / document
#
# Checks (references/market-protocol.md §4):
#   1. ≥ 1 row of type status_quo|diy|do_nothing (Dunford: the first alternative to beat is the
#      status quo; 20–30 % of enterprise deals end in "no decision")
#   2. ≥ GUILD_MIN_ALTERNATIVES (3) named alternatives (direct|indirect|in_house)
#   3. every non-do-nothing row has ≥ GUILD_MIN_INTERVIEWS_PER_ALT (2) distinct interview ids —
#      fewer is a phantom competitor
#   4. every non-do-nothing row has ≥ 1 VALID snapshot: captured_at within GUILD_SNAPSHOT_MAX_DAYS
#      (90) of as_of, archived_url per the grammar above, screenshot_hash 16–64 hex, price_metric
#      and billing_period in vocabulary, numeric list_price, currency, plan_name, captured_by
#   5. unknown types, duplicate ids, orphan snapshots (alt_id not in the register), empty
#      why_customer_uses_it, and named vendors without a url are violations
# Env (research default in brackets): GUILD_SNAPSHOT_MAX_DAYS [90], GUILD_MIN_ALTERNATIVES [3],
#   GUILD_MIN_INTERVIEWS_PER_ALT [2], GUILD_TODAY (overrides the as_of line).
# Contract: references/market-protocol.md §4; references/metrics.md (gate surface).

gate_competitors() {
  local afile="${1:?usage: competitors <alternatives.csv> <snapshots.csv>}"
  local sfile="${2:?usage: competitors <alternatives.csv> <snapshots.csv>}"
  local f
  for f in "$afile" "$sfile"; do
    [[ -f "$f" ]] || { echo "score-guild: competitors: missing file $f" >&2; return 2; }
  done
  local today
  if grep -qE '^#[[:space:]]*as_of:' "$sfile" 2>/dev/null; then today="$(guild_today "$sfile")"
  else today="$(guild_today "$afile")"; fi
  awk -v FS='\n' -v today="$today" -v MAX_DAYS="${GUILD_SNAPSHOT_MAX_DAYS:-90}" \
      -v MIN_ALT="${GUILD_MIN_ALTERNATIVES:-3}" -v MIN_IDS="${GUILD_MIN_INTERVIEWS_PER_ALT:-2}" '
    BEGIN {
      split("direct indirect status_quo diy do_nothing in_house", a, " "); for (i in a) typeOK[a[i]] = 1
      split("status_quo diy do_nothing", a, " ");                          for (i in a) sqOK[a[i]] = 1
      split("per_seat per_device per_site flat usage project", a, " ");    for (i in a) metricOK[a[i]] = 1
      split("monthly quarterly annual one_time per_project usage", a, " "); for (i in a) periodOK[a[i]] = 1
      nv = 0; nw = 0; hard = 0; na = 0; nSQ = 0; nOther = 0; pending = ""
      if (today !~ /^20[0-9][0-9]-[01][0-9]-[0-3][0-9]$/) { print "score-guild: competitors: bad as_of/today " today > "/dev/stderr"; hard = 1; exit 2 }
    }
    function viol(msg) { nv++; print msg > "/dev/stderr" }
    function warn(msg) { nw++; print "WARN " msg > "/dev/stderr" }
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    function isdate(s) { return s ~ /^20[0-9][0-9]-[01][0-9]-[0-3][0-9]$/ }
    function isnum(s) { return (s ~ /^[0-9]+(\.[0-9]+)?$/ || s ~ /^\.[0-9]+$/) }
    function csv_split(s, f,   n, i, c, q, cur, L) {   # RFC 4180: quotes, "" escapes, commas
      split("", f); n = 0; cur = ""; q = 0; L = length(s)
      for (i = 1; i <= L; i++) {
        c = substr(s, i, 1)
        if (q) { if (c == "\"") { if (substr(s, i + 1, 1) == "\"") { cur = cur "\""; i++ } else q = 0 } else cur = cur c }
        else if (c == "\"") q = 1
        else if (c == ",") { f[++n] = trim(cur); cur = "" }
        else cur = cur c
      }
      f[++n] = trim(cur); return n
    }
    function fld(name) { return (name in hc) ? f[hc[name]] : "" }
    function need_cols(which, list,   k, m, arr) {
      m = split(list, arr, " ")
      for (k = 1; k <= m; k++) if (!(arr[k] in hc)) { print "score-guild: competitors: " which " lacks column " arr[k] > "/dev/stderr"; hard = 1 }
      if (hard) exit 2
    }
    function dcivil(y, m, d,   era, yoe, doy, doe) {   # days since 1970-01-01 (Hinnant)
      y = (m <= 2) ? y - 1 : y
      era = int((y >= 0 ? y : y - 399) / 400); yoe = y - era * 400
      doy = int((153 * (m + (m > 2 ? -3 : 9)) + 2) / 5) + d - 1
      doe = yoe * 365 + int(yoe / 4) - int(yoe / 100) + doy
      return era * 146097 + doe - 719468
    }
    function days_between(a, b,   pa, pb) { split(a, pa, "-"); split(b, pb, "-"); return dcivil(pb[1]+0, pb[2]+0, pb[3]+0) - dcivil(pa[1]+0, pa[2]+0, pa[3]+0) }

    FNR == 1 { split("", hc); hdr = 0; pending = "" }
    {
      line = $0; sub(/\r$/, "", line)
      if (pending != "") { line = pending "\n" line; pending = "" }
      else if (line ~ /^[[:space:]]*$/ || line ~ /^#/) next
      tmp = line; if (gsub(/"/, "\"", tmp) % 2 == 1) { pending = line; next }
    }

    # ---- alternatives.csv (ARGV position, not -v strings: Windows backslashes) ----------------
    FILENAME == ARGV[1] {
      n = csv_split(line, f)
      if (!hdr) { for (i = 1; i <= n; i++) hc[f[i]] = i; hdr = 1; need_cols("alternatives.csv", "alt_id name type url why_customer_uses_it evidence_interview_ids lost_deal_ids"); next }
      id = fld("alt_id"); name = fld("name"); type = fld("type"); url = fld("url"); why = fld("why_customer_uses_it"); ids = fld("evidence_interview_ids")
      lbl = "alternatives.csv line " FNR " (" id ")"
      if (id == "") { viol(lbl ": empty alt_id"); next }
      if (id in altType) { viol(lbl ": duplicate alt_id " id); next }
      if (!(type in typeOK)) { viol(lbl ": unknown type \"" type "\" (direct|indirect|status_quo|diy|do_nothing|in_house)"); next }
      altIds[++na] = id; altType[id] = type; altName[id] = name; fresh[id] = 0
      if (name == "") viol(lbl ": empty name")
      if (why == "") viol(lbl ": empty why_customer_uses_it — record why the buyer would choose it (Dunford)")
      if ((type == "direct" || type == "indirect") && (url == "" || url == "-")) viol(lbl ": a named vendor (" type ") needs a url")
      if (type in sqOK) nSQ++; else nOther++
      if (type != "do_nothing") {
        m = split(ids, arr, ";"); split("", uniq); cnt = 0
        for (k = 1; k <= m; k++) {
          t = trim(arr[k]); if (t == "" || t == "-") continue
          if (t !~ /^[A-Za-z]+-?[0-9]+$/) { viol(lbl ": bad interview id \"" t "\" (expected e.g. I-7)"); continue }
          if (!(t in uniq)) { uniq[t] = 1; cnt++ }
        }
        if (cnt < MIN_IDS + 0) viol(lbl ": phantom competitor — " cnt " distinct evidence_interview_ids (need >= " MIN_IDS "); an alternative no interviewee named is not an alternative")
      }
      next
    }

    # ---- snapshots.csv ---------------------------------------------------------------------------
    FILENAME == ARGV[2] {
      n = csv_split(line, f)
      if (!hdr) { for (i = 1; i <= n; i++) hc[f[i]] = i; hdr = 1; need_cols("snapshots.csv", "snapshot_id alt_id plan_name list_price currency billing_period price_metric included_limits discount_terms source_url archived_url captured_at captured_by screenshot_hash"); next }
      sid = fld("snapshot_id"); alt = fld("alt_id"); plan = fld("plan_name"); price = fld("list_price"); cur = fld("currency")
      period = fld("billing_period"); metric = fld("price_metric"); src = fld("source_url"); arch = fld("archived_url")
      cap = fld("captured_at"); capby = fld("captured_by"); hash = fld("screenshot_hash")
      lbl = "snapshots.csv line " FNR " (" sid " -> " alt ")"
      if (sid == "") { viol(lbl ": empty snapshot_id"); next }
      if (sid in snapSeen) { viol(lbl ": duplicate snapshot_id " sid); next }
      snapSeen[sid] = 1
      if (!(alt in altType)) { viol(lbl ": orphan alt_id " alt " (not in alternatives.csv)"); next }
      ok = 1
      if (plan == "")             { viol(lbl ": empty plan_name"); ok = 0 }
      if (!isnum(price))          { viol(lbl ": list_price \"" price "\" is not a number"); ok = 0 }
      if (cur == "")              { viol(lbl ": empty currency"); ok = 0 }
      if (!(period in periodOK))  { viol(lbl ": bad billing_period \"" period "\" (monthly|quarterly|annual|one_time|per_project|usage)"); ok = 0 }
      if (!(metric in metricOK))  { viol(lbl ": bad price_metric \"" metric "\" (per_seat|per_device|per_site|flat|usage|project) — a price without its metric cannot be compared"); ok = 0 }
      if (hash !~ /^[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]+$/ || length(hash) > 64) {
        viol(lbl ": screenshot_hash \"" hash "\" is not 16-64 hex — a price without a hashed capture is a rumour"); ok = 0 }
      if (arch ~ /^https:\/\/web\.archive\.org\/web\/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\//) { }
      else if (src ~ /^(quote|email|manual):/ && (arch == "-" || arch == "")) {
        if (capby == "" || capby == "-" || tolower(capby) == "loop") { viol(lbl ": a quoted price needs captured_by = the human who obtained the quote"); ok = 0 } }
      else if (arch ~ /^https?:\/\//) { viol(lbl ": archived_url is a live URL with no archive (need https://web.archive.org/web/<14 digits>/…): " arch); ok = 0 }
      else { viol(lbl ": missing archived_url (or source_url quote:/email:/manual: with a human captured_by)"); ok = 0 }
      if (capby == "" || capby == "-") { viol(lbl ": empty captured_by"); ok = 0 }
      if (!isdate(cap)) { viol(lbl ": bad captured_at \"" cap "\" (YYYY-MM-DD)"); ok = 0 }
      else {
        age = days_between(cap, today)
        if (age < 0) { viol(lbl ": captured_at " cap " is after as_of " today); ok = 0 }
        else if (age > MAX_DAYS + 0) { warn(lbl ": captured " age " days ago (> " MAX_DAYS ") — history only, not a current price"); ok = 0 }
      }
      if (ok) fresh[alt]++
      next
    }

    END {
      if (hard) exit 2
      if (na == 0) viol("alternatives.csv: no alternative rows")
      if (nSQ < 1) viol("alternatives.csv: no status_quo|diy|do_nothing row — Dunford: \"the first competitive alternative we need to beat is the status quo\"")
      if (nOther < MIN_ALT + 0) viol("alternatives.csv: only " nOther " named alternative(s) (direct|indirect|in_house) — need >= " MIN_ALT " (entrants downplay competition: the Big Market Delusion)")
      for (k = 1; k <= na; k++) {
        id = altIds[k]
        if (altType[id] != "do_nothing" && fresh[id] == 0) viol("alternative " id " (" altName[id] "): no valid price snapshot <= " MAX_DAYS " days old (captured_at + archived_url + screenshot_hash + price_metric)")
      }
      printf "COMPETITOR_VIOLATIONS: %d\n", nv
      if (nw > 0) print nw " warning(s) — see WARN lines" > "/dev/stderr"
      exit 0
    }
  ' "$afile" "$sfile"
}
