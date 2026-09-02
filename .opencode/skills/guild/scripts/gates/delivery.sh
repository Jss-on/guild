#!/usr/bin/env bash
# gate: delivery — delivery-ledger discipline (brief 08 §5.2–5.4; references/operations-protocol.md §3).
#   score-guild.sh delivery <dir>   → "DELIVERY_VIOLATIONS: N"   (every violation / flag → stderr)
#   reads <dir>/projects.csv, milestones.csv, change_orders.csv, time.csv (+ rma.csv when present)
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing dir / file / column)
#
# Columns (header row required, order free, extra columns ignored; "# …" lines skipped; RFC 4180 quotes ok):
#   projects.csv      project_id client_id engagement_model contract_value currency signed_date deposit_pct
#                     deposit_paid_date kickoff_date planned_end actual_end accepted_end_date status
#   milestones.csv    milestone_id project_id deliverable acceptance_ref planned_date delivered_date
#                     review_deadline accepted_date deemed_accepted invoice_id invoice_date paid_date amount
#   change_orders.csv co_id project_id requested_date description delta_cost delta_days estimate_sent_date
#                     approved_date signed_doc_ref hours_logged_before_approval
#   time.csv          date person project_id hours billable standard_rate billed_rate billed_flag written_off_hours
#   rma.csv           rma_id order_id sku received_date defect_class remedy resolved_date days_to_resolve
# Dates are YYYY-MM-DD. "today" = GUILD_TODAY, else "# as_of: YYYY-MM-DD" in projects.csv, else the
# system date (fixtures always carry as_of so the frozen scorer never decays).
#
# Checks (V = violation, F = flag on stderr only):
#   V start-work   kickoff_date ⇒ signed_date and deposit_paid_date present and ≤ kickoff_date;
#                  deposit_pct ≥ GUILD_DEPOSIT_MIN (20)                                  [brief 08 §5.4]
#   V invoice      milestone invoice_date ≥ accepted_date; or deemed_accepted=Y with a review_deadline
#                  and invoice_date > review_deadline; otherwise "invoiced without acceptance"
#   V change ctrl  hours_logged_before_approval must be 0 ("no signature, no work"); an approved CO
#                  needs signed_doc_ref; every CO / milestone references a project row
#   F rebaseline   Σ approved delta_cost per project > GUILD_CO_REBASELINE_PCT (25) % of contract_value
#   V on-time      closed projects (status closed|complete|completed|accepted|done): share with
#                  actual_end ≤ planned_end ≥ GUILD_ONTIME_MIN (75) %                    [SPI 73.4 %]
#   V overrun      mean schedule overrun max(0, actual_days/planned_days − 1) over closed projects
#                  ≤ GUILD_OVERRUN_MAX (10) %, days measured from kickoff_date (or signed_date)
#   V realisation  time.csv rows with billable=Y and billed_flag=Y:
#                  Σ((hours − written_off_hours) × billed_rate) / Σ(hours × standard_rate) ≥ GUILD_REALISATION_MIN (90) %
#   V write-off    Σ written_off_hours / Σ hours over billable=Y rows ≤ GUILD_WRITEOFF_MAX (5) %
#   V rma          rma.csv: days_to_resolve (or resolved_date − received_date) ≤ GUILD_RMA_MAX_DAYS (30);
#                  an open RMA older than that counts too                                 [RA 7394 Art. 68(f)]
# Thresholds are harness policy anchored on brief 08 §3 (SPI on-time 73.4 %, overrun concern > 10 %,
# deposits 20–50 %) — override with the GUILD_* variables above.

gate_delivery() {
  local dir="${1:?usage: delivery <dir>}"
  [[ -d "$dir" ]] || { echo "score-guild: delivery: missing directory $dir" >&2; return 2; }
  local f miss=0
  for f in projects milestones change_orders time; do
    [[ -f "$dir/$f.csv" ]] || { echo "score-guild: delivery: missing $dir/$f.csv" >&2; miss=1; }
  done
  [[ $miss -eq 0 ]] || return 2
  local today; today="$(guild_today "$dir/projects.csv")"
  local files=("$dir/projects.csv" "$dir/change_orders.csv" "$dir/milestones.csv" "$dir/time.csv")
  [[ -f "$dir/rma.csv" ]] && files+=("$dir/rma.csv")
  awk -v today="$today" \
      -v depmin="${GUILD_DEPOSIT_MIN:-20}" -v rebase="${GUILD_CO_REBASELINE_PCT:-25}" \
      -v ontime_min="${GUILD_ONTIME_MIN:-75}" -v overrun_max="${GUILD_OVERRUN_MAX:-10}" \
      -v real_min="${GUILD_REALISATION_MIN:-90}" -v wo_max="${GUILD_WRITEOFF_MAX:-5}" \
      -v rma_max="${GUILD_RMA_MAX_DAYS:-30}" '
    function trim(s) { sub(/^[ \t\r]+/, "", s); sub(/[ \t\r]+$/, "", s); return s }
    function csvsplit(s, a,   n, i, c, q, f, L) {          # RFC 4180 split of one line into a[1..n]
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
    function dnum(s,   a, y, m, d, era, yoe, doy, doe) {    # YYYY-MM-DD → days since 1970-01-01, "" if not a date
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
    function viol(msg) { print msg > "/dev/stderr"; V++ }
    function flag(msg) { print "flag: " msg > "/dev/stderr"; FL++ }
    function F(name) { return (name in col) ? row[col[name]] : "" }
    function D(name,   s, v) {                               # date field → day number, -1 when empty
      s = F(name); if (s == "") return -1
      v = dnum(s); if (v == "") { viol(W ": bad date in " name " \"" s "\" (want YYYY-MM-DD)"); return -1 }
      return v
    }
    function need(names,   n, i, a) {
      n = split(names, a, " ")
      for (i = 1; i <= n; i++) if (!(a[i] in col)) { print "score-guild: delivery: " base ".csv lacks column " a[i] > "/dev/stderr"; hard = 2 }
    }
    BEGIN { tdn = dnum(today); hard = 0; V = 0; FL = 0; closed = 0; ontime = 0; ovn = 0; ovsum = 0; pot = 0; billed = 0; bh = 0; wosum = 0 }
    FNR == 1 { fn = FILENAME; gsub(/\\/, "/", fn); n = split(fn, p, "/"); base = p[n]; sub(/\.csv$/, "", base); hdr = 0; delete col }
    { sub(/\r$/, "") }
    /^[[:space:]]*$/ || /^#/ { next }
    !hdr {
      nf = csvsplit($0, row); for (i = 1; i <= nf; i++) col[tolower(row[i])] = i; hdr = 1
      if (base == "projects")      need("project_id contract_value signed_date deposit_pct deposit_paid_date kickoff_date planned_end actual_end status")
      if (base == "milestones")    need("milestone_id project_id delivered_date review_deadline accepted_date deemed_accepted invoice_date paid_date")
      if (base == "change_orders") need("co_id project_id delta_cost approved_date signed_doc_ref hours_logged_before_approval")
      if (base == "time")          need("project_id hours billable standard_rate billed_rate billed_flag written_off_hours")
      if (base == "rma")           need("rma_id received_date resolved_date days_to_resolve")
      if (hard) exit hard
      next
    }
    { nf = csvsplit($0, row); W = base " row " FNR }
    base == "projects" {
      id = F("project_id"); W = "project " id
      if (id == "") { viol(base " row " FNR ": empty project_id"); next }
      if (id in contract) viol(W ": duplicate project_id")
      cv = num(F("contract_value")); contract[id] = (cv == "" ? 0 : cv)
      st = tolower(F("status"))
      kick = D("kickoff_date"); signed = D("signed_date"); dep = D("deposit_paid_date"); dpct = num(F("deposit_pct"))
      if (kick >= 0) {
        if (signed < 0) viol(W ": kickoff " F("kickoff_date") " without signed_date (no signature, no kickoff)")
        else if (signed > kick) viol(W ": signed_date " F("signed_date") " after kickoff " F("kickoff_date"))
        if (dep < 0) viol(W ": kickoff " F("kickoff_date") " without deposit_paid_date (no deposit, no kickoff)")
        else if (dep > kick) viol(W ": kickoff " F("kickoff_date") " before the deposit was paid " F("deposit_paid_date"))
        if (dpct == "") viol(W ": deposit_pct missing (≥ " depmin " %)")
        else if (dpct < depmin) viol(W ": deposit_pct " dpct " < " depmin " %")
      }
      pe = D("planned_end"); ae = D("actual_end")
      if (st ~ /^(closed|complete|completed|accepted|done)$/) {
        if (pe < 0 || ae < 0) viol(W ": status " st " but planned_end/actual_end missing")
        else {
          closed++
          if (ae <= pe) ontime++
          start = (kick >= 0 ? kick : signed)
          if (start >= 0 && pe > start) { ov = (ae - start) / (pe - start) - 1; if (ov < 0) ov = 0; ovsum += ov; ovn++ }
        }
      }
      next
    }
    base == "change_orders" {
      id = F("co_id"); pid = F("project_id"); W = "change order " id
      if (!(pid in contract)) viol(W ": references unknown project \"" pid "\"")
      appr = D("approved_date"); hb = num(F("hours_logged_before_approval")); dc = num(F("delta_cost")); sref = F("signed_doc_ref")
      if (hb == "") hb = 0
      if (hb > 0) viol(W ": " hb " h logged before approval — no signature, no work" (appr < 0 ? " (still unapproved)" : " (approved " F("approved_date") ")"))
      if (appr >= 0) {
        if (sref == "") viol(W ": approved " F("approved_date") " without signed_doc_ref")
        if (dc != "") cosum[pid] += dc
      }
      next
    }
    base == "milestones" {
      id = F("milestone_id"); pid = F("project_id"); W = "milestone " id
      if (!(pid in contract)) viol(W ": references unknown project \"" pid "\"")
      inv = D("invoice_date"); acc = D("accepted_date"); rd = D("review_deadline"); del = D("delivered_date"); paid = D("paid_date")
      deemed = toupper(F("deemed_accepted"))
      if (acc >= 0 && del >= 0 && acc < del) viol(W ": accepted_date " F("accepted_date") " before delivered_date " F("delivered_date"))
      if (del >= 0 && rd >= 0 && rd < del) viol(W ": review_deadline " F("review_deadline") " before delivered_date " F("delivered_date"))
      if (deemed == "Y" && rd >= 0 && tdn != "" && tdn < rd) viol(W ": deemed accepted before the review window lapses (" F("review_deadline") ")")
      if (inv >= 0) {
        if (acc >= 0) { if (inv < acc) viol(W ": invoice_date " F("invoice_date") " before accepted_date " F("accepted_date") " (invoice on acceptance, never on a calendar date)") }
        else if (deemed == "Y") {
          if (rd < 0) viol(W ": deemed acceptance without a review_deadline")
          else if (inv <= rd) viol(W ": invoice_date " F("invoice_date") " inside the review window (deadline " F("review_deadline") ")")
        }
        else viol(W ": invoiced " F("invoice_date") " without acceptance (no accepted_date, not deemed)")
      }
      if (paid >= 0 && inv < 0) viol(W ": paid_date without invoice_date")
      if (paid >= 0 && inv >= 0 && paid < inv) viol(W ": paid_date before invoice_date")
      next
    }
    base == "time" {
      h = num(F("hours")); bl = toupper(F("billable")); sr = num(F("standard_rate")); br = num(F("billed_rate")); bf = toupper(F("billed_flag")); wo = num(F("written_off_hours"))
      if (h == "") { viol(W ": bad hours \"" F("hours") "\""); next }
      if (wo == "") wo = 0
      if (bl == "Y") {
        bh += h; wosum += wo
        if (bf == "Y") {
          if (sr == "" || br == "") viol(W ": billed row without standard_rate/billed_rate")
          else { pot += h * sr; billed += (h - wo) * br }
        }
      }
      next
    }
    base == "rma" {
      id = F("rma_id"); W = "RMA " id
      rec = D("received_date"); res = D("resolved_date"); dtr = num(F("days_to_resolve"))
      if (res >= 0) {
        if (dtr == "" && rec >= 0) dtr = res - rec
        if (dtr != "" && dtr > rma_max) viol(W ": resolved in " dtr " days > " rma_max " (RA 7394 Art. 68(f): repair within 30 days)")
      } else if (rec >= 0 && tdn != "" && tdn - rec > rma_max) viol(W ": open for " (tdn - rec) " days > " rma_max)
      next
    }
    END {
      if (hard) exit hard
      for (pid in cosum) if (contract[pid] > 0 && cosum[pid] / contract[pid] * 100 > rebase)
        flag("project " pid ": approved change orders " cosum[pid] " = " sprintf("%.1f", cosum[pid] / contract[pid] * 100) " % of contract_value " contract[pid] " > " rebase " % — rebaseline the plan")
      if (closed > 0) {
        share = ontime / closed * 100
        if (share < ontime_min) viol(sprintf("on-time delivery %.1f %% (%d/%d closed) < %s %%", share, ontime, closed, ontime_min))
        if (ovn > 0) { ovp = ovsum / ovn * 100; if (ovp > overrun_max) viol(sprintf("mean schedule overrun %.1f %% > %s %%", ovp, overrun_max)) }
        printf "closed=%d on_time=%.1f%% overrun=%.1f%%\n", closed, share, (ovn > 0 ? ovsum / ovn * 100 : 0) > "/dev/stderr"
      } else print "closed=0 (on-time / overrun not evaluated)" > "/dev/stderr"
      if (pot > 0) {
        real = billed / pot * 100
        if (real < real_min) viol(sprintf("billing realisation %.1f %% < %s %%", real, real_min))
        printf "realisation=%.1f%%\n", real > "/dev/stderr"
      } else print "realisation: no billed rows" > "/dev/stderr"
      if (bh > 0) {
        wop = wosum / bh * 100
        if (wop > wo_max) viol(sprintf("write-off %.1f %% of billable hours > %s %%", wop, wo_max))
        printf "write_off=%.1f%%\n", wop > "/dev/stderr"
      }
      printf "flags=%d today=%s\n", FL, today > "/dev/stderr"
      printf "DELIVERY_VIOLATIONS: %d\n", V
    }
  ' "${files[@]}"
}
