#!/usr/bin/env bash
# gate: alive — Paul Graham default-alive/default-dead simulation from the monthly cash ledger
# (brief 11 §5.2 [11:1]; contract: references/economics-protocol.md §8).
#   score-guild.sh alive <cash_ledger.csv>
#     → "DEFAULT_ALIVE: 1 months_to_breakeven=M months_to_zero=… growth_m=…"   (alive)
#     → "DEFAULT_ALIVE: 0 months_to_zero=N …"                                  (dead)
#   exit 0 on well-formed input · 2 hard error (missing file, < GUILD_ALIVE_MIN_ROWS rows —
#   PG: the question is meaningless before there is a revenue history)
#
# cash_ledger.csv — monthly rows, comma-separated (header required), first line "# as_of: …":
#   month revenue expenses cash          (month = YYYY-MM; cash = end-of-month balance)
#
# Simulation (PG, mechanized): expenses held FLAT at the last month; revenue grows at the
# compound monthly rate of the trailing GUILD_ALIVE_WINDOW months (3–6; default 6, clipped to
# the rows available); ALIVE iff revenue >= expenses before cash < 0, capped at GUILD_SIM_MONTHS
# (60). months_to_zero <= GUILD_FATAL_PINCH_MONTHS (6) ⇒ FATAL_PINCH on stderr — the board must
# open a fatal-pinch ADR and freeze hiring (brief 11 K1; the 6-month figure is policy).
# stderr also reports net_burn_3m (average expenses − revenue over the last 3 months).
#
# Policy env: GUILD_ALIVE_WINDOW=6 · GUILD_SIM_MONTHS=60 · GUILD_FATAL_PINCH_MONTHS=6 ·
#   GUILD_ALIVE_MIN_ROWS=6

gate_alive() {
  local f="${1:?usage: alive <cash_ledger.csv>}"
  [[ -f "$f" ]] || { echo "score-guild: alive: missing $f" >&2; return 2; }
  awk -F, \
    -v W="${GUILD_ALIVE_WINDOW:-6}" -v H="${GUILD_SIM_MONTHS:-60}" \
    -v PINCH="${GUILD_FATAL_PINCH_MONTHS:-6}" -v MINROWS="${GUILD_ALIVE_MIN_ROWS:-6}" '
    function val(name,  i) { i = c[name]; return (i ? $i + 0 : 0) }
    { sub(/\r$/, "") }
    /^#/ { next }
    !h { for (i = 1; i <= NF; i++) { gsub(/^ +| +$/, "", $i); c[$i] = i } h = 1
         split("month revenue expenses cash", req, " ")
         for (i in req) if (!(req[i] in c)) { printf "alive: missing column %s (need month,revenue,expenses,cash)\n", req[i] > "/dev/stderr"; hard = 1; exit 2 }
         next }
    NF > 1 { n++; mo[n] = $(c["month"]); rev[n] = val("revenue"); ex[n] = val("expenses"); cash[n] = val("cash") }
    END {
      if (hard) exit 2
      if (n < MINROWS) { printf "alive: need >= %d monthly rows, got %d (PG: too early to ask)\n", MINROWS, n > "/dev/stderr"; exit 2 }
      # trailing compound growth over the last k intervals (k = W-1, clipped)
      k = W - 1; if (k > n - 1) k = n - 1; if (k < 1) k = 1
      r0 = rev[n-k]; r1 = rev[n]
      g = (r0 > 0 && r1 > 0) ? (r1 / r0) ^ (1.0 / k) - 1 : 0
      b3 = 0; kk = (n >= 3) ? 3 : n
      for (i = n - kk + 1; i <= n; i++) b3 += ex[i] - rev[i]
      b3 = b3 / kk
      # simulate: expenses flat at last month, revenue compounding at g
      r = rev[n]; e = ex[n]; cs = cash[n]; be = -1; out = -1
      if (r >= e) be = 0
      if (cs < 0) out = 0
      for (t = 1; t <= H && (be < 0 || out < 0); t++) {
        r = r * (1 + g); cs = cs + r - e
        if (be < 0 && r >= e) be = t
        if (out < 0 && cs < 0) out = t
      }
      alive = (be >= 0 && (out < 0 || be <= out)) ? 1 : 0
      mz = (out < 0) ? "never" : out ""
      if (out < 0 && !alive) mz = ">" H
      mb = (be < 0) ? ">" H : be ""
      printf "months=%d growth_window=%d growth_m=%.4f net_burn_3m=%.0f last: revenue=%.0f expenses=%.0f cash=%.0f\n", n, k, g, b3, rev[n], ex[n], cash[n] > "/dev/stderr"
      if (alive) printf "default ALIVE: revenue meets expenses at month %s before cash runs out (months_to_zero=%s)\n", mb, mz > "/dev/stderr"
      else       printf "default DEAD: cash out at month %s before break-even (months_to_breakeven=%s) — PG: fix growth or cut expenses NOW\n", mz, mb > "/dev/stderr"
      if (!alive && out >= 0 && out <= PINCH) printf "FATAL_PINCH: months_to_zero=%d <= %d — open a fatal-pinch ADR, freeze hiring (brief 11 K1)\n", out, PINCH > "/dev/stderr"
      printf "DEFAULT_ALIVE: %d months_to_breakeven=%s months_to_zero=%s growth_m=%.4f\n", alive, mb, mz, g
      exit 0
    }' "$f"
}
