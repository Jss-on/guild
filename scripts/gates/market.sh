#!/usr/bin/env bash
# gate: market — market-size ledger validity (brief 02 §5 G3 factor gate + G4 triangulation + G9
# source registry). Every TAM/SAM/SOM figure is the product of sourced, archived, graded factor
# rows; bottom-up unit counts come from named lists (P1/P2); layers nest (SOM ≤ SAM ≤ TAM); every
# (layer, segment) is triangulated by ≥ 2 methods that agree within 3×; sources are fresh.
#   score-guild.sh market <factors.csv> <claims.csv> <sources.tsv>   → "MARKET_VIOLATIONS: N"
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing file / column)
#   violations → stderr, one line each, naming the ledger line, the claim and the rule letter;
#   warnings (staleness inside the WARN band, refresh due) → stderr prefixed "WARN", never counted.
#
# factors.csv (loop-written; RFC 4180 quoting; "# …" comment lines skipped; first line
# "# as_of: YYYY-MM-DD" pins the date every staleness check uses — see guild_today):
#   claim_id layer segment_id method factor value unit currency source_id source_reference_period
#   source_publication_date retrieved_at archived_url grade note
#   layer   TAM|SAM|SOM                     method  top_down|bottom_up|value_theory
#   factor  unit_count|price_per_unit|frequency|adoption_share|filter   (shares/filters ∈ (0,1])
#   value   numeric > 0 — the claim's figure is the PRODUCT of its factor rows, nothing else
#   source_id  S-<n> in sources.tsv (status read|cited; T4 uncitable); grade P1|P2|P3 may not
#              exceed the source tier (P1 needs T1, P2 needs T1/T2)
#   source_reference_period  YYYY | YYYY-MM | YYYY-MM-DD | YYYYQn — the period the number describes
#   archived_url  https://web.archive.org/web/<14 digits>/<url>, or "-" when the source row is
#                 fetch_status=manual (a document a human obtained by hand)
# claims.csv:  claim_id stated_value currency computed_value method layer segment_id
# sources.tsv: the 13-column evidence ledger (references/evidence-protocol.md §2); an optional 14th
#              column `cadence` (monthly|quarterly|semiannual|annual|census) drives "refresh due".
#
# Checks (letters match references/market-protocol.md §3 and brief 02 G3/G4):
#   (a) product of a claim's factor rows within GUILD_FACTOR_TOLERANCE (1 %) of stated_value, and
#       computed_value equals that product within the same tolerance; every claim has ≥ 1 factor
#       row and a price_per_unit in the claim's currency
#   (b) every factor row cites a source_id that exists, is citable, carries a valid retrieved_at
#       (not after as_of), an archived Wayback URL (or manual source), and a grade ≤ source tier
#   (c) bottom_up claims carry a unit_count factor graded P1|P2 — P3 (Statista-class modeled
#       counts, vendor estimates) fails; a unit_count in "identities"/"connections" fails
#   (d) per segment: SOM ≤ SAM ≤ TAM within each method chain, evaluated on the factor product
#       AND on the stated values; across methods the largest SOM may not exceed the largest TAM
#   (e) a SOM claim applying an adoption_share needs a bottom_up claim in the same segment (the
#       "1 % of a huge market" guard, brief 02 §7 / Kawasaki)
#   (f) each (layer, segment) needs ≥ 2 distinct methods whose products agree within
#       GUILD_TRIANGULATION_MAX (3.0 — harness policy, no canonical tolerance exists)
#   (g) staleness vs as_of: reference period older than GUILD_STALE_WARN_MONTHS (24) → WARN;
#       census/LE/CPBI rows (note or unit says so) older than GUILD_STALE_CENSUS_WARN_MONTHS (36)
#       → WARN; older than GUILD_STALE_FAIL_MONTHS (60) → violation
# Env (research default in brackets): GUILD_FACTOR_TOLERANCE [0.01], GUILD_TRIANGULATION_MAX [3.0],
#   GUILD_STALE_WARN_MONTHS [24], GUILD_STALE_CENSUS_WARN_MONTHS [36], GUILD_STALE_FAIL_MONTHS [60],
#   GUILD_TODAY (overrides the as_of line).
# Contract: references/market-protocol.md §3, §6; references/metrics.md (gate surface).

gate_market() {
  local ffile="${1:?usage: market <factors.csv> <claims.csv> <sources.tsv>}"
  local cfile="${2:?usage: market <factors.csv> <claims.csv> <sources.tsv>}"
  local sfile="${3:?usage: market <factors.csv> <claims.csv> <sources.tsv>}"
  local f
  for f in "$ffile" "$cfile" "$sfile"; do
    [[ -f "$f" ]] || { echo "score-guild: market: missing file $f" >&2; return 2; }
  done
  local today; today="$(guild_today "$ffile")"
  awk -v FS='\n' -v today="$today" \
      -v TOL="${GUILD_FACTOR_TOLERANCE:-0.01}" -v TRI="${GUILD_TRIANGULATION_MAX:-3.0}" \
      -v WARN_M="${GUILD_STALE_WARN_MONTHS:-24}" -v CWARN_M="${GUILD_STALE_CENSUS_WARN_MONTHS:-36}" \
      -v FAIL_M="${GUILD_STALE_FAIL_MONTHS:-60}" '
    BEGIN {
      split("TAM SAM SOM", a, " ");                                    for (i in a) layerOK[a[i]] = 1
      split("top_down bottom_up value_theory", a, " ");                for (i in a) methodOK[a[i]] = 1
      split("unit_count price_per_unit frequency adoption_share filter", a, " "); for (i in a) factorOK[a[i]] = 1
      split("P1 P2 P3", a, " ");                                       for (i in a) gradeOK[a[i]] = 1
      nv = 0; nw = 0; hard = 0; ncl = 0; nseg = 0; nmeth = 0; pending = ""
      if (today !~ /^20[0-9][0-9]-[01][0-9]-[0-3][0-9]$/) { print "score-guild: market: bad as_of/today " today > "/dev/stderr"; hard = 1; exit 2 }
    }
    function viol(msg) { nv++; print msg > "/dev/stderr" }
    function warn(msg) { nw++; print "WARN " msg > "/dev/stderr" }
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    function isdate(s) { return s ~ /^20[0-9][0-9]-[01][0-9]-[0-3][0-9]$/ }
    function isnum(s) { return (s ~ /^[0-9]+(\.[0-9]+)?$/ || s ~ /^\.[0-9]+$/) }
    function fmt(x) { return (x < 1000 && x > -1000) ? sprintf("%.4g", x) : sprintf("%.0f", x) }
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
      for (k = 1; k <= m; k++) if (!(arr[k] in hc)) { print "score-guild: market: " which " lacks column " arr[k] > "/dev/stderr"; hard = 1 }
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
    function months_between(a, b,   pa, pb, m) { split(a, pa, "-"); split(b, pb, "-"); m = (pb[1] - pa[1]) * 12 + (pb[2] - pa[2]); if (pb[3] + 0 < pa[3] + 0) m--; return m }
    function period_end(p,   y, m, q, dim) {
      if (p ~ /^[0-9][0-9][0-9][0-9]$/) return p "-12-31"
      if (p ~ /^[0-9][0-9][0-9][0-9]Q[1-4]$/) { q = substr(p, 6, 1) + 0; return substr(p, 1, 4) "-" (q == 1 ? "03-31" : q == 2 ? "06-30" : q == 3 ? "09-30" : "12-31") }
      if (p ~ /^[0-9][0-9][0-9][0-9]-[01][0-9]$/) {
        y = substr(p, 1, 4) + 0; m = substr(p, 6, 2) + 0
        dim = (m == 2) ? (((y % 4 == 0 && y % 100 != 0) || y % 400 == 0) ? 29 : 28) : ((m == 4 || m == 6 || m == 9 || m == 11) ? 30 : 31)
        return sprintf("%04d-%02d-%02d", y, m, dim)
      }
      if (isdate(p)) return p
      return ""
    }
    function cadence_months(c) { c = tolower(c); return (c == "monthly") ? 1 : (c == "quarterly") ? 3 : (c == "semiannual" || c == "semi-annual") ? 6 : (c == "annual" || c == "yearly") ? 12 : (c ~ /census/) ? 60 : 0 }
    function census_class(note, unit,   t) { t = tolower(note " " unit); return (t ~ /census|cpbi|list of establishments/ || note ~ /(^|[^A-Za-z])LE([^A-Za-z]|$)/) }

    FNR == 1 { split("", hc); hdr = 0; pending = "" }   # file boundary: new header map
    {
      line = $0; sub(/\r$/, "", line)
      if (pending != "") { line = pending "\n" line; pending = "" }
      else if (line ~ /^[[:space:]]*$/ || line ~ /^#/) next
      tmp = line; if (gsub(/"/, "\"", tmp) % 2 == 1) { pending = line; next }   # quoted newline
    }

    # ---- sources.tsv → id → tier / status / retrieved_at / fetch_status / cadence ----------------
    # (files are told apart by ARGV position — -v strings would escape-process Windows backslashes)
    FILENAME == ARGV[1] {
      n = split(line, f, "\t")
      if (f[1] == "id" && f[2] == "tier") next
      if (n < 13) next                                   # malformed rows are the sources gate’s job
      id = trim(f[1]); srcTier[id] = trim(f[2]); srcStatus[id] = trim(f[9]); srcRet[id] = trim(f[10])
      srcFetch[id] = trim(f[13]); srcCad[id] = (n >= 14) ? trim(f[14]) : ""
      next
    }

    # ---- claims.csv ------------------------------------------------------------------------------
    FILENAME == ARGV[2] {
      n = csv_split(line, f)
      if (!hdr) { for (i = 1; i <= n; i++) hc[f[i]] = i; hdr = 1; need_cols("claims.csv", "claim_id stated_value currency computed_value method layer segment_id"); next }
      id = fld("claim_id"); lbl = "claims.csv line " FNR
      if (id == "") { viol(lbl ": empty claim_id"); next }
      if (id in clRow) { viol(lbl ": duplicate claim_id " id); next }
      clIds[++ncl] = id; clRow[id] = FNR
      clStated[id] = fld("stated_value"); clComputed[id] = fld("computed_value"); clCur[id] = fld("currency")
      clMethod[id] = fld("method"); clLayer[id] = fld("layer"); clSeg[id] = fld("segment_id")
      if (!isnum(clStated[id]) || clStated[id] + 0 <= 0) viol(lbl " (" id "): stated_value \"" clStated[id] "\" is not a positive number")
      if (!isnum(clComputed[id]))                       viol(lbl " (" id "): computed_value \"" clComputed[id] "\" is not a number")
      if (clCur[id] == "")                              viol(lbl " (" id "): empty currency")
      if (!(clMethod[id] in methodOK))                  viol(lbl " (" id "): bad method \"" clMethod[id] "\" (top_down|bottom_up|value_theory)")
      if (!(clLayer[id] in layerOK))                    viol(lbl " (" id "): bad layer \"" clLayer[id] "\" (TAM|SAM|SOM)")
      if (clSeg[id] == "")                              viol(lbl " (" id "): empty segment_id")
      key = clSeg[id] SUBSEP clMethod[id] SUBSEP clLayer[id]
      if (key in byKey) viol(lbl " (" id "): duplicates (" clSeg[id] ", " clMethod[id] ", " clLayer[id] ") already claimed by " byKey[key]); else byKey[key] = id
      if (!(clSeg[id] in segSeen)) { segSeen[clSeg[id]] = 1; segs[++nseg] = clSeg[id] }
      if (!(clMethod[id] in methSeen)) { methSeen[clMethod[id]] = 1; meths[++nmeth] = clMethod[id] }
      if (clMethod[id] == "bottom_up") segHasBU[clSeg[id]] = 1
      prod[id] = 1; nfac[id] = 0; hasUnit[id] = 0; hasPrice[id] = 0; hasAdopt[id] = 0
      next
    }

    # ---- factors.csv -----------------------------------------------------------------------------
    FILENAME == ARGV[3] {
      n = csv_split(line, f)
      if (!hdr) { for (i = 1; i <= n; i++) hc[f[i]] = i; hdr = 1; need_cols("factors.csv", "claim_id layer segment_id method factor value unit currency source_id source_reference_period source_publication_date retrieved_at archived_url grade note"); next }
      id = fld("claim_id"); fac = fld("factor"); val = fld("value"); unit = fld("unit"); cur = fld("currency")
      sid = fld("source_id"); grade = fld("grade"); arch = fld("archived_url"); note = fld("note")
      lbl = "factors.csv line " FNR " (" id " " fac ")"
      if (!(id in clRow)) { viol(lbl ": orphan claim_id " id " (not in claims.csv)"); next }
      if (fld("layer") != clLayer[id] || fld("segment_id") != clSeg[id] || fld("method") != clMethod[id])
        viol(lbl ": layer/segment/method disagree with claims.csv (" clLayer[id] ", " clSeg[id] ", " clMethod[id] ")")
      if (!(fac in factorOK)) { viol(lbl ": bad factor \"" fac "\" (unit_count|price_per_unit|frequency|adoption_share|filter)"); next }
      if (!isnum(val) || val + 0 <= 0) { viol(lbl ": value \"" val "\" is not a positive number"); next }
      if ((fac == "adoption_share" || fac == "filter") && val + 0 > 1) viol(lbl ": " fac " " val " exceeds 1 (shares and filters are fractions of the base)")
      if (unit == "") viol(lbl ": empty unit")
      if (fac == "unit_count" && tolower(unit) ~ /identit|connection/) viol(lbl ": (c) unit_count in \"" unit "\" — social identities and mobile connections are not people or establishments (DataReportal caveat)")
      if (fac == "price_per_unit") { hasPrice[id]++; if (cur != clCur[id]) viol(lbl ": (a) price currency \"" cur "\" differs from claim currency " clCur[id]) }
      if (fac == "unit_count") hasUnit[id]++
      if (fac == "adoption_share") hasAdopt[id] = 1
      nfac[id]++; prod[id] *= (val + 0)
      # (b) source, archive, grade
      if (!(grade in gradeOK)) viol(lbl ": (b) bad grade \"" grade "\" (P1|P2|P3)")
      if (sid == "") viol(lbl ": (b) no source_id")
      else if (!(sid in srcTier)) viol(lbl ": (b) source " sid " not in sources.tsv")
      else {
        tier = srcTier[sid]
        if (srcStatus[sid] == "rejected" || srcStatus[sid] == "unverified") viol(lbl ": (b) source " sid " has status=" srcStatus[sid] " (uncitable)")
        if (tier == "T4") viol(lbl ": (b) source " sid " is T4 — uncitable for a market factor")
        if (grade == "P1" && tier != "T1") viol(lbl ": (b) grade P1 exceeds source " sid " tier " tier " (P1 needs a T1 primary)")
        if (grade == "P2" && tier != "T1" && tier != "T2") viol(lbl ": (b) grade P2 exceeds source " sid " tier " tier " (P2 needs T1/T2)")
        if (arch ~ /^https:\/\/web\.archive\.org\/web\/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\//) { }
        else if (srcFetch[sid] == "manual" && (arch == "-" || arch == "")) { }
        else if (arch ~ /^https?:\/\//) viol(lbl ": (b) archived_url is a live URL with no archive (need https://web.archive.org/web/<14 digits>/…): " arch)
        else viol(lbl ": (b) missing archived_url and source " sid " is not fetch_status=manual")
        if (srcCad[sid] != "" && isdate(srcRet[sid])) { cm = cadence_months(srcCad[sid]); if (cm > 0 && months_between(srcRet[sid], today) > cm) warn(lbl ": source " sid " retrieved " srcRet[sid] " is past its " srcCad[sid] " cadence — refresh due") }
      }
      ret = fld("retrieved_at")
      if (!isdate(ret)) viol(lbl ": (b) bad retrieved_at \"" ret "\" (YYYY-MM-DD)")
      else if (days_between(ret, today) < 0) viol(lbl ": (b) retrieved_at " ret " is after as_of " today)
      if (period_end(fld("source_publication_date")) == "") viol(lbl ": (b) bad source_publication_date \"" fld("source_publication_date") "\"")
      # (c) bottom-up counts come from named lists
      if (clMethod[id] == "bottom_up" && fac == "unit_count" && grade == "P3") viol(lbl ": (c) bottom_up unit_count graded P3 (source " sid ") — a bottom-up count must come from a named list or registry (P1/P2), never a modeled or vendor estimate")
      # (g) staleness against as_of
      rp = fld("source_reference_period"); pe = period_end(rp)
      if (pe == "") viol(lbl ": (g) unparseable source_reference_period \"" rp "\" (YYYY | YYYY-MM | YYYY-MM-DD | YYYYQn)")
      else {
        age = months_between(pe, today); cc = census_class(note, unit)
        if (age > FAIL_M + 0) viol(lbl ": (g) reference period " rp " is " age " months old (> " FAIL_M " months) — stale, refresh or drop")
        else if (cc && age > CWARN_M + 0) warn(lbl ": (g) census/LE reference period " rp " is " age " months old (> " CWARN_M ")")
        else if (!cc && age > WARN_M + 0) warn(lbl ": (g) reference period " rp " is " age " months old (> " WARN_M ")")
      }
      next
    }

    END {
      if (hard) exit 2
      if (ncl == 0) viol("claims.csv: no claim rows — a market ledger with nothing in it is not clean")
      # (a) product vs stated / computed
      for (k = 1; k <= ncl; k++) {
        id = clIds[k]
        if (nfac[id] == 0) { viol("claim " id ": (a) no factor rows in factors.csv — a figure without factors is prose"); eff[id] = -1; continue }
        if (!hasPrice[id]) viol("claim " id ": (a) no price_per_unit factor — a " clCur[id] " figure needs a price per unit")
        if (clMethod[id] == "bottom_up" && !hasUnit[id]) viol("claim " id ": (c) bottom_up claim without a unit_count factor")
        p = prod[id]; eff[id] = p; s = clStated[id] + 0; c = clComputed[id] + 0
        if (s > 0) { dev = (p - s) / s; if (dev < 0) dev = -dev
          if (dev > TOL + 0) viol(sprintf("claim %s: (a) factor product %s differs from stated_value %s by %.1f %% (tolerance %.1f %%)", id, fmt(p), fmt(s), dev * 100, TOL * 100)) }
        if (c > 0) { dev = (p - c) / c; if (dev < 0) dev = -dev
          if (dev > TOL + 0) viol(sprintf("claim %s: (a) computed_value %s is not the factor product %s (%.1f %% off)", id, fmt(c), fmt(p), dev * 100)) }
      }
      # (d) SOM ≤ SAM ≤ TAM — on the factor product and on the stated values
      for (kind = 1; kind <= 2; kind++) {
        kname = (kind == 1) ? "factor product" : "stated value"
        for (si = 1; si <= nseg; si++) {
          seg = segs[si]; chainBad = 0; maxSOM = -1; maxTAM = -1
          for (mi = 1; mi <= nmeth; mi++) {
            m = meths[mi]
            hs = ((seg SUBSEP m SUBSEP "SOM") in byKey); ha = ((seg SUBSEP m SUBSEP "SAM") in byKey); ht = ((seg SUBSEP m SUBSEP "TAM") in byKey)
            vs = hs ? val_of(kind, byKey[seg SUBSEP m SUBSEP "SOM"]) : -1
            va = ha ? val_of(kind, byKey[seg SUBSEP m SUBSEP "SAM"]) : -1
            vt = ht ? val_of(kind, byKey[seg SUBSEP m SUBSEP "TAM"]) : -1
            if (vs >= 0 && va >= 0 && vs > va) { viol("segment " seg " / " m ": (d) SOM " fmt(vs) " > SAM " fmt(va) " (" kname ")"); chainBad = 1 }
            if (va >= 0 && vt >= 0 && va > vt) { viol("segment " seg " / " m ": (d) SAM " fmt(va) " > TAM " fmt(vt) " (" kname ")"); chainBad = 1 }
            if (vs >= 0 && va < 0 && vt >= 0 && vs > vt) { viol("segment " seg " / " m ": (d) SOM " fmt(vs) " > TAM " fmt(vt) " (" kname ")"); chainBad = 1 }
            if (vs > maxSOM) maxSOM = vs
            if (vt > maxTAM) maxTAM = vt
          }
          if (!chainBad && maxSOM >= 0 && maxTAM >= 0 && maxSOM > maxTAM) viol("segment " seg ": (d) largest SOM " fmt(maxSOM) " exceeds largest TAM " fmt(maxTAM) " across methods (" kname ")")
        }
      }
      # (e) adoption share needs a bottom-up anchor
      for (k = 1; k <= ncl; k++) {
        id = clIds[k]
        if (clLayer[id] == "SOM" && hasAdopt[id] && !(clSeg[id] in segHasBU)) viol("claim " id ": (e) SOM applies an adoption_share with no bottom_up claim in segment " clSeg[id] " — the \"1 % of a huge market\" pattern (Kawasaki); count the units first")
      }
      # (f) triangulation per (layer, segment)
      for (si = 1; si <= nseg; si++) {
        seg = segs[si]
        for (li = 1; li <= 3; li++) {
          layer = (li == 1) ? "TAM" : (li == 2) ? "SAM" : "SOM"
          cnt = 0; mn = -1; mx = -1; names = ""
          for (mi = 1; mi <= nmeth; mi++) {
            m = meths[mi]; key = seg SUBSEP m SUBSEP layer
            if (!(key in byKey)) continue
            v = eff[byKey[key]]; if (v < 0) continue
            cnt++; names = names (names == "" ? "" : ", ") m
            if (mn < 0 || v < mn) mn = v
            if (v > mx) mx = v
          }
          if (cnt == 0) continue
          if (cnt < 2) viol("segment " seg " / " layer ": (f) only one method (" names ") — triangulation needs >= 2 distinct methods")
          else if (mn > 0 && mx / mn > TRI + 0) viol(sprintf("segment %s / %s: (f) methods disagree %.2fx (max %s / min %s; %s) > %.1fx triangulation tolerance", seg, layer, mx / mn, fmt(mx), fmt(mn), names, TRI))
        }
      }
      printf "MARKET_VIOLATIONS: %d\n", nv
      if (nw > 0) print nw " warning(s) — see WARN lines" > "/dev/stderr"
      exit 0
    }
    function val_of(kind, id) { return (kind == 1) ? eff[id] : (clStated[id] + 0) }
  ' "$sfile" "$cfile" "$ffile"
}
