#!/usr/bin/env bash
# gate: cash — 13-week direct-method cash forecast closes (briefs 10 §5a/§5b, 05 UE-08, 12 §5;
# contract: references/economics-protocol.md §7).
#   score-guild.sh cash <cash13.csv> [variance.csv]   → "CASH_PASS: x/y"
#   exit 0 on well-formed input (a red forecast is valid data) · 2 hard error
#
# cash13.csv — 16 comma-separated columns (header required; brief 10 §5a), first line
# "# as_of: YYYY-MM-DD" (the deterministic 'today' for the ledger; GUILD_TODAY overrides):
#   week_start opening_cash rcpt_ar rcpt_new_sales rcpt_other disb_payroll disb_rent_overhead
#   disb_vendors_components disb_taxes disb_debt_service disb_capex net_flow closing_cash
#   min_cash_floor actual_closing variance
#   (actual_closing / variance stay empty on a freshly rolled forecast; elapsed-week actuals
#   live in variance.csv.)
#
# variance.csv (optional) — week_start, forecast_receipts, actual_receipts[, …]: the human-entered
# actuals for elapsed weeks; the gate reads the LAST GUILD_VAR_WEEKS rows that carry actuals.
#
# Checks (each one row of x/y; C-06 only counted when variance.csv is given):
#   C-01 13 weekly rows, contiguous (week_start steps of exactly 7 days)          [10:S47]
#   C-02 arithmetic ties: receipts − disbursements = net_flow; opening + net_flow = closing;
#        next week's opening = this week's closing (all ± ₱1)                     [10:S47]
#   C-03 every closing_cash ≥ min_cash_floor (floor = one payroll cycle, policy)  [05:S32]
#   C-04 ending cash never negative                                               [05:S3]
#   C-05 forecast freshness: first week_start within GUILD_CASH_FRESH_DAYS of today —
#        a TWCF "must be updated weekly"; today = guild_today (GUILD_TODAY / # as_of) [10:S47]
#   C-06 receipts variance over the last GUILD_VAR_WEEKS actual weeks ≤ GUILD_VAR_PCT % [05:S32]
#   C-07 reserve months = opening cash (wk 1) ÷ avg monthly FIXED disbursements
#        (payroll + rent/overhead + debt service) ≥ GUILD_RESERVE_MONTHS          [10:S48 policy]
#   C-08 runway = opening cash ÷ monthly net burn (from the 13-week net flow) ≥
#        GUILD_RUNWAY_MONTHS; non-negative net flow ⇒ runway 999                  [05:S3 policy]
#   C-09 cash-buffer days = opening cash ÷ avg daily total disbursements ≥ GUILD_BUFFER_DAYS
#        (JPMC median 27); < GUILD_BUFFER_ALARM (13, 25th pct) ⇒ ALARM on stderr  [12:S36]
#
# Policy env (defaults = research values): GUILD_RESERVE_MONTHS=3 · GUILD_RUNWAY_MONTHS=6 ·
#   GUILD_CASH_FRESH_DAYS=7 · GUILD_VAR_PCT=15 · GUILD_VAR_WEEKS=4 · GUILD_BUFFER_DAYS=27 ·
#   GUILD_BUFFER_ALARM=13 · GUILD_CASH_WEEKS=13

gate_cash() {
  local f="${1:?usage: cash <cash13.csv> [variance.csv]}" var="${2:-}"
  [[ -f "$f" ]] || { echo "score-guild: cash: missing $f" >&2; return 2; }
  [[ -z "$var" || -f "$var" ]] || { echo "score-guild: cash: missing variance file $var" >&2; return 2; }
  local today; today="$(guild_today "$f")"

  # week_start list → day offsets from the first week (one node call), + freshness age
  local weeks w1 offsets age
  weeks="$(awk -F, '{sub(/\r$/,"")} /^#/{next} !h{h=1;next} NF>1{gsub(/^ +| +$/,"",$1); print $1}' "$f")"
  w1="$(printf '%s\n' "$weeks" | head -1)"
  [[ "$w1" =~ ^20[0-9]{2}-[0-9]{2}-[0-9]{2}$ ]] || { echo "score-guild: cash: no week_start data rows in $f" >&2; return 2; }
  # shellcheck disable=SC2086
  offsets="$(node -e 'const ws=process.argv.filter(a=>/^20\d\d-\d\d-\d\d$/.test(a)).map(d=>new Date(d+"T00:00:00Z"));const b=ws[0];console.log(ws.map(d=>Math.round((d-b)/86400000)).join(" "))' $weeks)"
  age="$(guild_days_between "$w1" "$today")"

  # receipts variance from variance.csv (last N rows with actuals); -1 = not evaluated
  local varpct="-1"
  if [[ -n "$var" ]]; then
    varpct="$(awk -F, -v N="${GUILD_VAR_WEEKS:-4}" '
      {sub(/\r$/,"")} /^#/{next}
      !h { for(i=1;i<=NF;i++){gsub(/^ +| +$/,"",$i); c[$i]=i} h=1
           if(!("forecast_receipts" in c)||!("actual_receipts" in c)){print -2; bad=1; exit} next }
      NF>1 && $(c["actual_receipts"])+0!=0 || ($(c["actual_receipts"])!="" && $(c["actual_receipts"])==0) {
        n++; fc[n]=$(c["forecast_receipts"])+0; ac[n]=$(c["actual_receipts"])+0 }
      END { if(bad) exit
            if(n==0){print -3; exit}
            s=n-N+1; if(s<1)s=1; F=0;A=0
            for(i=s;i<=n;i++){F+=fc[i];A+=ac[i]}
            if(F<=0){print -3; exit}
            d=A-F; if(d<0)d=-d
            printf "%.4f\n", d/F*100 }' "$var")"
    [[ "$varpct" == "-2" ]] && { echo "score-guild: cash: variance.csv lacks forecast_receipts/actual_receipts columns" >&2; return 2; }
  fi

  awk -F, \
    -v OFFS="$offsets" -v AGE="$age" -v TODAY="$today" -v VARPCT="$varpct" \
    -v WEEKS="${GUILD_CASH_WEEKS:-13}" -v FRESH="${GUILD_CASH_FRESH_DAYS:-7}" \
    -v VARLIM="${GUILD_VAR_PCT:-15}" -v VARN="${GUILD_VAR_WEEKS:-4}" \
    -v RESERVE="${GUILD_RESERVE_MONTHS:-3}" -v RUNWAY="${GUILD_RUNWAY_MONTHS:-6}" \
    -v BUF="${GUILD_BUFFER_DAYS:-27}" -v ALARM="${GUILD_BUFFER_ALARM:-13}" '
    function val(name,  i) { i = c[name]; return (i ? $i + 0 : 0) }
    function abs(x) { return x < 0 ? -x : x }
    function row(id, ok, msg) { total++; if (ok) { pass++; printf "PASS %s %s\n", id, msg > "/dev/stderr" }
                                else printf "FAIL %s %s\n", id, msg > "/dev/stderr" }
    { sub(/\r$/, "") }
    /^#/ { next }
    !h { for (i = 1; i <= NF; i++) { gsub(/^ +| +$/, "", $i); c[$i] = i } h = 1
         split("week_start opening_cash rcpt_ar rcpt_new_sales rcpt_other disb_payroll disb_rent_overhead disb_vendors_components disb_taxes disb_debt_service disb_capex net_flow closing_cash min_cash_floor", req, " ")
         for (i in req) if (!(req[i] in c)) { printf "cash: missing column %s\n", req[i] > "/dev/stderr"; hard = 1; exit 2 }
         next }
    NF > 1 {
      n++
      wk[n]    = $(c["week_start"])
      open[n]  = val("opening_cash");  close_[n] = val("closing_cash"); floor_[n] = val("min_cash_floor")
      net[n]   = val("net_flow")
      rc[n]    = val("rcpt_ar") + val("rcpt_new_sales") + val("rcpt_other")
      fixd[n]  = val("disb_payroll") + val("disb_rent_overhead") + val("disb_debt_service")
      disb[n]  = fixd[n] + val("disb_vendors_components") + val("disb_taxes") + val("disb_capex")
    }
    END {
      if (hard) exit 2
      if (n == 0) { print "cash: no data rows" > "/dev/stderr"; exit 2 }
      # C-01 rows + contiguity
      m = split(OFFS, off, " "); contig = (n == WEEKS && m == WEEKS)
      for (i = 1; i <= m && contig; i++) if (off[i] + 0 != (i - 1) * 7) contig = 0
      row("C-01", contig, sprintf("weekly rows: %d/%d, 7-day steps %s (rule: 13 contiguous weeks)", n, WEEKS, contig ? "ok" : "BROKEN"))
      # C-02 ties
      ties = 1
      for (i = 1; i <= n; i++) {
        if (abs(rc[i] - disb[i] - net[i]) > 1)        { ties = 0; printf "  tie: week %s receipts-disb=%d != net_flow=%d\n", wk[i], rc[i]-disb[i], net[i] > "/dev/stderr" }
        if (abs(open[i] + net[i] - close_[i]) > 1)    { ties = 0; printf "  tie: week %s opening+net=%d != closing=%d\n", wk[i], open[i]+net[i], close_[i] > "/dev/stderr" }
        if (i > 1 && abs(open[i] - close_[i-1]) > 1)  { ties = 0; printf "  tie: week %s opening=%d != prior closing=%d\n", wk[i], open[i], close_[i-1] > "/dev/stderr" }
      }
      row("C-02", ties, "arithmetic ties (receipts-disb=net; open+net=close; open=prior close; +/- 1)")
      # C-03 floor / C-04 non-negative
      okf = 1; okn = 1; minc = close_[1]
      for (i = 1; i <= n; i++) {
        if (close_[i] < minc) minc = close_[i]
        if (close_[i] < floor_[i]) { okf = 0; printf "  floor breach: week %s closing=%d < min_cash_floor=%d\n", wk[i], close_[i], floor_[i] > "/dev/stderr" }
        if (close_[i] < 0)         { okn = 0; printf "  negative cash: week %s closing=%d\n", wk[i], close_[i] > "/dev/stderr" }
      }
      row("C-03", okf, sprintf("min closing cash %d vs floor (rule: every closing_cash >= min_cash_floor, one payroll cycle)", minc))
      row("C-04", okn, sprintf("ending cash never negative (min %d)", minc))
      # C-05 freshness
      fresh = (AGE + 0 <= FRESH && AGE + 0 >= -FRESH)
      row("C-05", fresh, sprintf("forecast age %s days vs today=%s (rule: rolled weekly, <= %d days)", AGE, TODAY, FRESH))
      # C-06 receipts variance
      if (VARPCT + 0 >= 0)      row("C-06", VARPCT + 0 <= VARLIM, sprintf("receipts variance last %d actual weeks = %.1f %% (rule: <= %d %%)", VARN, VARPCT, VARLIM))
      else if (VARPCT == "-3")  row("C-06", 0, "variance.csv has no usable actual_receipts rows")
      else                       print "C-06 not evaluated (no variance.csv given)" > "/dev/stderr"
      # C-07 reserve months (fixed disbursements only)
      mf = 0; for (i = 1; i <= n; i++) mf += fixd[i]
      mfix = mf / n * 52 / 12
      resm = (mfix > 0) ? open[1] / mfix : 999
      row("C-07", resm >= RESERVE, sprintf("reserve = %.1f months of fixed disbursements (%.0f/mo) (rule: >= %s months, policy)", resm, mfix, RESERVE))
      # C-08 runway from net flow
      tn = 0; for (i = 1; i <= n; i++) tn += net[i]
      if (tn >= 0) rw = 999; else { burn = -tn / n * 52 / 12; rw = open[1] / burn }
      row("C-08", rw >= RUNWAY, sprintf("runway = %.1f months (13-wk net flow %d) (rule: >= %s months, policy)", rw, tn, RUNWAY))
      # C-09 cash-buffer days
      td = 0; for (i = 1; i <= n; i++) td += disb[i]
      daily = td / (n * 7); bd = (daily > 0) ? open[1] / daily : 999
      row("C-09", bd >= BUF, sprintf("cash-buffer days = %.0f (rule: >= %d, JPMC median; alarm < %d)", bd, BUF, ALARM))
      if (bd < ALARM) printf "ALARM: cash-buffer days %.0f < %d (JPMC 25th percentile) — cash-in-advance work only\n", bd, ALARM > "/dev/stderr"
      printf "CASH_PASS: %d/%d\n", pass, total
      exit 0
    }' "$f"
}
