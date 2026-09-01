#!/usr/bin/env bash
# gate: regulatory — hardware ship-blockers: NTC type approval, DTI-BPS PS/ICC, Consumer Act warranty
# floors, forbidden "No Return, No Exchange" (brief 08 §4–5; references/operations-protocol.md §6–7).
#   score-guild.sh regulatory <regulatory.csv> [lots.csv]   → "SHIP_BLOCKERS: N"   (detail → stderr)
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing file / column)
#
# regulatory.csv columns (header row required, order free; "# …" lines skipped; RFC 4180 quotes ok):
#   sku product_name has_radio ntc_status ntc_cert_no ntc_model_name marketed_model_name bps_mandatory
#   ps_icc_status cert_expiry consumer_product warranty_text_days service_invoice_guaranty_days
#   template_text [service_line]
#   has_radio / bps_mandatory / consumer_product ∈ Y|N · ntc_status ∈ approved|accepted|pending|none|…
#   · ps_icc_status ∈ valid|pending|expired|none|… · cert_expiry YYYY-MM-DD or empty (NTC validity is
#   unlimited; BPS licences/ICC expire) · template_text = the warranty / receipt / listing wording, or a
#   path (relative to the CSV or cwd) to the template file · service_line Y when the SKU is sold with
#   repair/service work (a non-empty service_invoice_guaranty_days also marks a service line)
# lots.csv (optional, incoming QC per ANSI/ASQ Z1.4): lot_id sku lot_size aql_level code_letter sample_n
#   critical_found major_found minor_found ac_major re_major result [ac_minor]
# "today" = GUILD_TODAY, else "# as_of: YYYY-MM-DD" in regulatory.csv, else the system date.
#
# Blockers (each +1):
#   has_radio=Y     ⇒ ntc_status approved|accepted with ntc_cert_no, ntc_model_name == marketed_model_name
#                     (one certificate per marketing model — NTC MC 02-01-2001 §I(d), memo 7 Aug 2019),
#                     cert_expiry not past
#   bps_mandatory=Y ⇒ ps_icc_status = valid (PS mark / ICC sticker before distribution), cert_expiry not past
#   consumer_product=Y ⇒ warranty_text_days ≥ GUILD_CONSUMER_WARRANTY_MIN (60)   [RA 7394 Art. 68(e)]
#   service line    ⇒ service_invoice_guaranty_days ≥ GUILD_SERVICE_GUARANTY_MIN (90) [RA 7394 Art. 71]
#   any template containing "No Return, No Exchange" (or words to that effect)      [DTI DAO 2 s.1993]
#   lots.csv: a lot with result accept while critical_found > 0, major_found > ac_major or
#             minor_found > ac_minor (AQL critical 0 / major 2.5 / minor 4.0, GII)

gate_regulatory() {
  local file="${1:?usage: regulatory <regulatory.csv> [lots.csv]}" lots="${2:-}"
  [[ -f "$file" ]] || { echo "score-guild: regulatory: missing file $file" >&2; return 2; }
  [[ -z "$lots" || -f "$lots" ]] || { echo "score-guild: regulatory: missing lots file $lots" >&2; return 2; }
  local today dir; today="$(guild_today "$file")"; dir="$(cd "$(dirname "$file")" && pwd)"
  local files=("$file"); [[ -n "$lots" ]] && files+=("$lots")
  awk -v today="$today" -v dir="$dir" \
      -v cw_min="${GUILD_CONSUMER_WARRANTY_MIN:-60}" -v svc_min="${GUILD_SERVICE_GUARANTY_MIN:-90}" '
    function trim(s) { sub(/^[ \t\r]+/, "", s); sub(/[ \t\r]+$/, "", s); return s }
    function csvsplit(s, a,   n, i, c, q, f, L) {
      n = 0; q = 0; f = ""; L = length(s)
      for (i = 1; i <= L; i++) {
        c = substr(s, i, 1)
        if (q) { if (c == "\"") { if (substr(s, i + 1, 1) == "\"") { f = f "\""; i++ } else q = 0 } else f = f c }
        else if (c == "\"") q = 1
        else if (c == ",") { a[++n] = trim(f); f = "" }
        else f = f c
      }
      a[++n] = trim(f); return n
    }
    function dnum(s,   a, y, m, d, era, yoe, doy, doe) {
      if (s !~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/) return ""
      split(s, a, "-"); y = a[1] + 0; m = a[2] + 0; d = a[3] + 0
      if (m < 1 || m > 12 || d < 1 || d > 31) return ""
      if (m <= 2) y--
      era = int((y >= 0 ? y : y - 399) / 400); yoe = y - era * 400
      doy = int((153 * (m + (m > 2 ? -3 : 9)) + 2) / 5) + d - 1
      doe = yoe * 365 + int(yoe / 4) - int(yoe / 100) + doy
      return era * 146097 + doe - 719468
    }
    function num(s) { gsub(/[, ]/, "", s); return (s ~ /^-?[0-9]*\.?[0-9]+$/) ? s + 0 : "" }
    function block(msg) { print msg > "/dev/stderr"; V++ }
    function F(name) { return (name in col) ? row[col[name]] : "" }
    function yn(name,   v) { v = toupper(F(name)); if (v != "Y" && v != "N") { block(W ": " name " must be Y or N (got \"" F(name) "\")"); return "N" } return v }
    function need(names,   n, i, a) {
      n = split(names, a, " ")
      for (i = 1; i <= n; i++) if (!(a[i] in col)) { print "score-guild: regulatory: " (fileno == 1 ? "regulatory" : "lots") ".csv lacks column " a[i] > "/dev/stderr"; hard = 2 }
    }
    function modelkey(s) { s = tolower(s); gsub(/[^a-z0-9]+/, "", s); return s }
    function textof(v,   path, line, txt, got, k, cand) {   # template_text: a path (relative to the CSV or cwd) or the text itself
      if (v == "" || v ~ /[[:space:]]/ && length(v) > 120) return v
      cand[1] = dir "/" v; cand[2] = v
      for (k = 1; k <= 2; k++) {
        path = cand[k]; txt = ""; got = 0
        while ((getline line < path) > 0) { txt = txt " " line; got = 1 }
        close(path)
        if (got) return txt
      }
      return v
    }
    BEGIN { tdn = dnum(today); hard = 0; V = 0; fileno = 0; prods = 0; radios = 0; bps = 0; consumer = 0; lots = 0 }
    FNR == 1 { fileno++; hdr = 0; delete col }
    { sub(/\r$/, "") }
    /^[[:space:]]*$/ || /^#/ { next }
    !hdr {
      nf = csvsplit($0, row); for (i = 1; i <= nf; i++) col[tolower(row[i])] = i; hdr = 1
      if (fileno == 1) need("sku has_radio ntc_status ntc_cert_no ntc_model_name marketed_model_name bps_mandatory ps_icc_status cert_expiry consumer_product warranty_text_days service_invoice_guaranty_days template_text")
      else need("lot_id result critical_found major_found ac_major")
      if (hard) exit hard
      next
    }
    { nf = csvsplit($0, row) }
    fileno == 1 {
      sku = F("sku"); W = "sku " (sku == "" ? "(row " FNR ")" : sku); prods++
      radio = yn("has_radio"); bpsm = yn("bps_mandatory"); cons = yn("consumer_product")
      ns = tolower(F("ntc_status")); ps = tolower(F("ps_icc_status"))
      cexp = F("cert_expiry"); cexpn = dnum(cexp)
      if (cexp != "" && cexpn == "") block(W ": bad cert_expiry \"" cexp "\" (want YYYY-MM-DD)")
      if (radio == "Y") {
        radios++
        if (ns != "approved" && ns != "accepted")
          block(W ": has_radio=Y but ntc_status=" (ns == "" ? "(empty)" : ns) " — no NTC type approval / acceptance certificate; nothing radiates on the PH network without one (MC 02-01-2001 §I(c))")
        else {
          if (F("ntc_cert_no") == "") block(W ": ntc_status " ns " without ntc_cert_no")
          if (F("ntc_model_name") == "") block(W ": ntc_status " ns " without ntc_model_name (the certificate names one marketing model)")
          else if (F("marketed_model_name") == "") block(W ": no marketed_model_name to compare against the certificate model \"" F("ntc_model_name") "\"")
          else if (modelkey(F("ntc_model_name")) != modelkey(F("marketed_model_name")))
            block(W ": marketed model name \"" F("marketed_model_name") "\" ≠ NTC certificate model \"" F("ntc_model_name") "\" — one certificate per marketing model; a changed model number needs a new certificate (MC 02-01-2001 §I(d))")
        }
      }
      if (bpsm == "Y") {
        bps++
        if (ps != "valid") block(W ": bps_mandatory=Y but ps_icc_status=" (ps == "" ? "(empty)" : ps) " — products on the DTI-BPS mandatory list bear the PS mark / ICC sticker before distribution")
      }
      if ((radio == "Y" || bpsm == "Y") && cexpn != "" && tdn != "" && cexpn < tdn) block(W ": certificate expired " cexp)
      if (cons == "Y") {
        consumer++
        wd = num(F("warranty_text_days"))
        if (wd == "") block(W ": consumer_product=Y without warranty_text_days (RA 7394 Art. 68(e): implied warranty 60 days to 1 year)")
        else if (wd < cw_min) block(W ": warranty text " wd " days < " cw_min " (RA 7394 Art. 68(e))")
      }
      svc = toupper(F("service_line")); sg = num(F("service_invoice_guaranty_days"))
      if (svc == "Y" || F("service_invoice_guaranty_days") != "") {
        if (sg == "") block(W ": service line without service_invoice_guaranty_days (RA 7394 Art. 71: ≥ 90 days, stated on the invoice)")
        else if (sg < svc_min) block(W ": service invoice guaranty " sg " days < " svc_min " (RA 7394 Art. 71)")
      }
      t = tolower(textof(F("template_text")))
      if (t ~ /no[ -]*return[ ,;.\/-]*no[ -]*exchange/) block(W ": template contains \"No Return, No Exchange\" (DTI DAO 2 s.1993 — prohibited on receipts, contracts, packaging, listings)")
      next
    }
    fileno == 2 {
      lid = F("lot_id"); W = "lot " lid; lots++
      res = tolower(F("result")); cf = num(F("critical_found")); mf = num(F("major_found")); acm = num(F("ac_major")); mn = num(F("minor_found")); acn = num(F("ac_minor"))
      if (res ~ /^(accept|accepted|pass|passed)$/) {
        if (cf != "" && cf > 0) block(W ": accepted with " cf " critical defect(s) (AQL critical = 0)")
        if (mf != "" && acm != "" && mf > acm) block(W ": accepted with " mf " majors > Ac " acm " (AQL 2.5)")
        if (mn != "" && acn != "" && mn > acn) block(W ": accepted with " mn " minors > Ac " acn " (AQL 4.0)")
      }
      next
    }
    END {
      if (hard) exit hard
      printf "products=%d radio=%d bps_mandatory=%d consumer=%d lots=%d today=%s\n", prods, radios, bps, consumer, lots, today > "/dev/stderr"
      printf "SHIP_BLOCKERS: %d\n", V
    }
  ' "${files[@]}"
}
