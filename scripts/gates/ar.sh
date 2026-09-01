#!/usr/bin/env bash
# gate: ar — accounts-receivable ledger discipline under EOPT (brief 10 §4b, §5a–b;
# references/finance-protocol.md §5–8).
#   score-guild.sh ar <ar_ledger.csv>   → "AR_VIOLATIONS: N"   (every violation → stderr; summary → stderr)
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing file / column)
#
# ar_ledger.csv columns (brief 10 §5a; header row required, order free; "# …" lines skipped; RFC 4180 ok):
#   invoice_no invoice_date client_id client_name client_tin line_type amount_ex_vat vat_amount gross
#   credit_term_days due_date ewt_rate ewt_amount expected_cash paid_date paid_amount rail rail_fee
#   form2307_received form2307_quarter status demand_letter_date
#   line_type ∈ service|product|recurring · status ∈ open|paid|short|disputed|written_off
#   · form2307_received Y|N · amounts plain numbers in PHP · dates YYYY-MM-DD
# "today" = GUILD_TODAY, else "# as_of: YYYY-MM-DD" in the ledger, else the system date.
#
# Checks (each breach +1):
#   invoice fields  invoice_date, amount_ex_vat, vat_amount (a separate VAT line — 0 when non-VAT /
#                   zero-rated) on every row; an invoice_no also needs client_name, client_tin
#                   (NNN-NNN-NNN[-NNNNN]) and line_type; amount_ex_vat + vat_amount = gross (± tolerance);
#                   vat_amount > 0 must equal GUILD_VAT_RATE (12) % of amount_ex_vat (± tolerance)
#   ₱500 rule       gross ≥ GUILD_INVOICE_MIN (500) needs an invoice_no (EOPT; RA 11976)
#   credit term     vat_amount > 0 and not a cash sale (paid on the invoice date) ⇒ credit_term_days > 0
#                   — the printed term is a condition of the output-VAT credit on uncollected
#                   receivables (RMC 65-2024)
#   short-payment   status paid ⇒ paid_date, paid_amount and paid_amount + ewt_amount + rail_fee = gross
#                   within GUILD_AR_TOLERANCE (1); a short payment labelled paid is a violation (use short)
#   2307            paid/short rows with ewt_amount > 0: form2307_received = Y once today >
#                   quarter-end(paid_date) + GUILD_2307_DAYS (20)   [RR 11-2018: 2307 by the 20th after quarter-end]
#   aging           open|short|disputed balances: share in current / 1–30 days past due ≥ GUILD_AR_AGING_MIN (80) %;
#                   any balance > GUILD_AR_DEMAND_DAYS (90) days past due needs demand_letter_date
#                   (the written demand starts the 6 % p.a. legal-interest clock — BSP Circular 799; Nacar 2013)
#   DSO             open balance ÷ gross invoiced in the trailing GUILD_DSO_WINDOW_DAYS (90) × window:
#                   > GUILD_DSO_TARGET (45) warns, > GUILD_DSO_MAX (60) is a violation
# Thresholds: HighRadius "80–90 % current" and CFI "DSO below 45 is low" (brief 10 §2/§5b); the 60-day
# violation line and ₱1 tolerance are harness policy.

gate_ar() {
  local file="${1:?usage: ar <ar_ledger.csv>}"
  [[ -f "$file" ]] || { echo "score-guild: ar: missing file $file" >&2; return 2; }
  local today; today="$(guild_today "$file")"
  awk -v today="$today" -v tol="${GUILD_AR_TOLERANCE:-1}" -v inv_min="${GUILD_INVOICE_MIN:-500}" \
      -v vat_rate="${GUILD_VAT_RATE:-12}" -v f2307_days="${GUILD_2307_DAYS:-20}" \
      -v aging_min="${GUILD_AR_AGING_MIN:-80}" -v demand_days="${GUILD_AR_DEMAND_DAYS:-90}" \
      -v dso_target="${GUILD_DSO_TARGET:-45}" -v dso_max="${GUILD_DSO_MAX:-60}" -v dso_window="${GUILD_DSO_WINDOW_DAYS:-90}" '
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
    function qend(s,   y, m, em, ed) {                        # YYYY-MM-DD → quarter-end date string
      y = substr(s, 1, 4); m = substr(s, 6, 2) + 0; em = int((m - 1) / 3) * 3 + 3
      ed = (em == 6 || em == 9) ? 30 : 31
      return sprintf("%s-%02d-%02d", y, em, ed)
    }
    function abs(x) { return x < 0 ? -x : x }
    function num(s) { gsub(/[, ]/, "", s); return (s ~ /^-?[0-9]*\.?[0-9]+$/) ? s + 0 : "" }
    function viol(msg) { print msg > "/dev/stderr"; V++ }
    function F(name) { return (name in col) ? row[col[name]] : "" }
    function D(name,   s, v) {
      s = F(name); if (s == "") return -1
      v = dnum(s); if (v == "") { viol(W ": bad date in " name " \"" s "\" (want YYYY-MM-DD)"); return -1 }
      return v
    }
    function need(names,   n, i, a) {
      n = split(names, a, " ")
      for (i = 1; i <= n; i++) if (!(a[i] in col)) { print "score-guild: ar: ledger lacks column " a[i] > "/dev/stderr"; hard = 2 }
    }
    BEGIN { tdn = dnum(today); hard = 0; V = 0; rows = 0; open_total = 0; cur30 = 0; win_sales = 0; b0 = 0; b30 = 0; b60 = 0; b90 = 0; b90p = 0 }
    { sub(/\r$/, "") }
    /^[[:space:]]*$/ || /^#/ { next }
    !hdr {
      nf = csvsplit($0, row); for (i = 1; i <= nf; i++) col[tolower(row[i])] = i; hdr = 1
      need("invoice_no invoice_date client_name client_tin line_type amount_ex_vat vat_amount gross credit_term_days due_date ewt_amount paid_date paid_amount rail_fee form2307_received status demand_letter_date")
      if (hard) exit hard
      next
    }
    {
      nf = csvsplit($0, row); rows++
      inv = F("invoice_no"); W = (inv != "" ? "invoice " inv : "row " FNR)
      idt = D("invoice_date"); if (idt < 0) viol(W ": missing invoice_date")
      ex = num(F("amount_ex_vat")); vat = num(F("vat_amount")); gross = num(F("gross"))
      if (ex == "") viol(W ": missing amount_ex_vat")
      if (vat == "") viol(W ": missing vat_amount (VAT is a separate line on the invoice; 0 when non-VAT or zero-rated)")
      if (gross == "") { if (ex != "" && vat != "") gross = ex + vat; else { viol(W ": missing gross"); next } }
      else if (ex != "" && vat != "" && abs(ex + vat - gross) > tol) viol(W ": amount_ex_vat " ex " + vat_amount " vat " ≠ gross " gross)
      if (vat != "" && vat > 0 && ex != "" && abs(vat - ex * vat_rate / 100) > tol) viol(W ": vat_amount " vat " ≠ " vat_rate " % of " ex)
      if (inv == "") { if (gross >= inv_min) viol(W ": sale of " gross " ≥ " inv_min " without an invoice_no (EOPT: an invoice is mandatory at ₱" inv_min " and above)") }
      else {
        tin = F("client_tin")
        if (F("client_name") == "") viol(W ": missing client_name")
        if (tin == "") viol(W ": missing client_tin (buyer name + TIN are required invoice information)")
        else if (tin !~ /^[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9](-[0-9][0-9][0-9][0-9]?[0-9]?)?$/) viol(W ": malformed client_tin \"" tin "\" (NNN-NNN-NNN[-NNNNN])")
        lt = tolower(F("line_type"))
        if (lt == "") viol(W ": missing line_type (service|product|recurring — the description line)")
        else if (lt !~ /^(service|product|recurring)$/) viol(W ": bad line_type \"" lt "\"")
      }
      st = tolower(F("status"))
      if (st !~ /^(open|paid|short|disputed|written_off)$/) { viol(W ": bad status \"" F("status") "\" (open|paid|short|disputed|written_off)"); next }
      ct = num(F("credit_term_days")); pdt = D("paid_date")
      cash_sale = (st == "paid" && pdt >= 0 && idt >= 0 && pdt == idt)
      if (vat != "" && vat > 0 && !cash_sale && (ct == "" || ct <= 0))
        viol(W ": VAT invoice without a credit term (credit_term_days > 0 printed on the invoice is a condition of the output-VAT credit on uncollected receivables — RMC 65-2024)")
      paid = num(F("paid_amount")); ewt = num(F("ewt_amount")); fee = num(F("rail_fee"))
      if (ewt == "") ewt = 0
      if (fee == "") fee = 0
      if (st == "paid") {
        if (pdt < 0) viol(W ": status paid without paid_date")
        if (paid == "") viol(W ": status paid without paid_amount")
        else if (abs(gross - (paid + ewt + fee)) > tol)
          viol(sprintf("%s: paid_amount %.2f + ewt_amount %.2f + rail_fee %.2f = %.2f ≠ gross %.2f — a short payment labelled paid (status must be short until the balance or the 2307 arrives)", W, paid, ewt, fee, paid + ewt + fee, gross))
      }
      if (st == "short" && paid == "") viol(W ": status short without paid_amount")
      if ((st == "paid" || st == "short") && ewt > 0 && pdt >= 0) {
        qe = qend(F("paid_date")); deadline = dnum(qe) + f2307_days
        if (tdn != "" && tdn > deadline && toupper(F("form2307_received")) != "Y")
          viol(W ": EWT " ewt " withheld on " F("paid_date") " (quarter ending " qe ") but Form 2307 not received — due by the " f2307_days "th after quarter-end; without the certificate the withheld cash is not creditable")
      }
      if (st == "open" || st == "short" || st == "disputed") {
        bal = gross - (paid == "" ? 0 : paid) - (st == "short" ? ewt + fee : 0)
        if (bal < 0) bal = 0
        open_total += bal
        due = D("due_date")
        if (due < 0 && idt >= 0 && ct != "") due = idt + ct
        if (due < 0) viol(W ": open balance without due_date or credit_term_days (cannot be aged)")
        else if (tdn != "") {
          past = tdn - due
          if (past <= 0) b0 += bal; else if (past <= 30) b30 += bal; else if (past <= 60) b60 += bal; else if (past <= 90) b90 += bal; else b90p += bal
          if (past <= 30) cur30 += bal
          if (past > demand_days && F("demand_letter_date") == "")
            viol(W ": " past " days past due (" bal " open) without demand_letter_date — a written demand starts the 6 % p.a. legal-interest clock and the dunning ladder")
        }
      }
      if (idt >= 0 && tdn != "" && tdn - idt >= 0 && tdn - idt < dso_window) win_sales += gross
    }
    END {
      if (hard) exit hard
      share = (open_total > 0) ? cur30 / open_total * 100 : 100
      if (open_total > 0 && share < aging_min) viol(sprintf("aging: %.1f %% of open AR is current / 1–30 days past due < %s %% (open %.2f: current %.2f · 1–30 %.2f · 31–60 %.2f · 61–90 %.2f · 90+ %.2f)", share, aging_min, open_total, b0, b30, b60, b90, b90p))
      if (win_sales > 0) {
        dso = open_total / win_sales * dso_window
        if (dso > dso_max) viol(sprintf("DSO %.1f days > %s (open AR %.2f over %.2f invoiced in the trailing %d days)", dso, dso_max, open_total, win_sales, dso_window))
        else if (dso > dso_target) printf "warn: DSO %.1f days > target %s\n", dso, dso_target > "/dev/stderr"
        printf "rows=%d open_ar=%.2f current_1_30=%.1f%% dso=%.1f today=%s\n", rows, open_total, share, dso, today > "/dev/stderr"
      } else printf "rows=%d open_ar=%.2f current_1_30=%.1f%% dso=n/a (no invoices in the trailing %d days) today=%s\n", rows, open_total, share, dso_window, today > "/dev/stderr"
      printf "AR_VIOLATIONS: %d\n", V
    }
  ' "$file"
}
