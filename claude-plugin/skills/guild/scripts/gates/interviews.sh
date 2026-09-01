#!/usr/bin/env bash
# gate: interviews — the HUMAN-ENTERED interview ledger: consent join, sensitive-data consent,
# retention and withdrawal, recording/verbatim, early-pitch contamination, per-segment quota and
# evidence-grade share; cadence and saturation reported on stderr.
#   score-guild.sh interviews <interviews.tsv> <consent.tsv> [quota.tsv]   → "INTERVIEW_VIOLATIONS: N"
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing file, no header row)
#
# interviews.tsv — 25 tab-separated columns (+ optional 26th `evidence_kind`), matched BY NAME from
# the header row (required); "# as_of: YYYY-MM-DD" as the first line pins every date comparison:
#   interview_id date segment_id role org_type org_size channel language interviewer consent_id
#   recorded solution_revealed top_pains last_occurrence_date past_behavior workaround
#   current_spend_php current_spend_time wtp_signal verbatim_quote commitment_type
#   commitment_detail next_step_date new_codes_count snapshot_link [evidence_kind]
# consent.tsv — 10 columns (consent_id in the interview row = participant_id here, a pseudonym):
#   participant_id date consent_version recording quotes_allowed spi_collected
#   spi_explicit_consent incentive_given_at_start withdrawal_date deletion_due
# quota.tsv (optional) — `segment_id quota`: the segments under active discovery and the quota each
#   must reach (empty quota = default). Absent ⇒ the most-interviewed segment is held to the default.
#   Segments not under active discovery are reported, never counted (a contrast segment with three
#   conversations is not a failed segment).
#
# Checks (references/discovery-protocol.md §14; evidence-protocol.md §5; brief 01 G2–G4):
#   per row — one violation each, "row <n> (<id>): <rule>" on stderr
#     · consent_id joins a consent row                                  RA 10173 §3(b)
#     · joined: spi_collected=Y ⇒ spi_explicit_consent=Y               RA 10173 §13
#     · joined: deletion_due ≥ as_of; withdrawal_date empty or > as_of  RA 10173 §11, §16
#     · joined: consent dated on/before the interview; recorded=Y ⇒ recording=Y;
#               verbatim_quote ⇒ quotes_allowed=Y                       consent scope is specific
#     · recorded=Y or verbatim_quote non-empty                          Mom Test / YC: record it
#     · enums: recorded, solution_revealed ∈ Y|N · wtp_signal ∈ unprompted|prompted|none ·
#       commitment_type ∈ none|time|reputation|money · evidence_kind ∈ say|do (do ⇒ evidence-grade) ·
#       dates YYYY-MM-DD and not after as_of · new_codes_count integer · spends numeric
#     · solution_revealed=N for the first GUILD_INTERVIEW_NOPITCH (6) interviews of every segment,
#       in date order — a pitched respondent is contaminated and the pool does not refill
#   per segment under active discovery — one violation each
#     · interviews ≥ GUILD_INTERVIEW_QUOTA (12; Guest, Bunce & Johnson 2006 saturation, brief 01)
#     · evidence-grade share ≥ GUILD_INTERVIEW_EVIDENCE_PCT (50 %, harness policy)
#   informational (stderr only): cadence gaps > GUILD_INTERVIEW_CADENCE_DAYS (7; Torres weekly
#   rule); saturation = new_codes_count 0 on the last GUILD_INTERVIEW_SATURATION_K (3);
#   segments below GUILD_INTERVIEW_COMMON (6) may not call any theme common.
# Evidence-grade row = past_behavior non-empty AND (current_spend_php > 0 OR current_spend_time > 0
# OR wtp_signal ≠ none OR commitment_type ≠ none). Compliments are excluded by construction.
# Dates compare against guild_today <interviews.tsv> (GUILD_TODAY, then "# as_of:", then today).

gate_interviews() {
  local ifile="${1:?usage: interviews <interviews.tsv> <consent.tsv> [quota.tsv]}"
  local cfile="${2:?usage: interviews <interviews.tsv> <consent.tsv> [quota.tsv]}"
  local qfile="${3:-}" quota_spec="" today
  [[ -f "$ifile" ]] || { echo "score-guild: interviews: missing interview ledger $ifile" >&2; return 2; }
  [[ -f "$cfile" ]] || { echo "score-guild: interviews: missing consent ledger $cfile" >&2; return 2; }
  if [[ -n "$qfile" ]]; then
    [[ -f "$qfile" ]] || { echo "score-guild: interviews: missing quota file $qfile" >&2; return 2; }
    quota_spec="$(awk -F'\t' '{ sub(/\r$/, "") } /^#/ { next } $1 == "segment_id" { next } $1 != "" { printf "%s=%s;", $1, $2 }' "$qfile")"
  fi
  today="$(guild_today "$ifile")"
  awk -F'\t' -v cf="$cfile" -v today="$today" -v quota_spec="$quota_spec" \
    -v quota_default="${GUILD_INTERVIEW_QUOTA:-12}" -v nopitch="${GUILD_INTERVIEW_NOPITCH:-6}" \
    -v evpct="${GUILD_INTERVIEW_EVIDENCE_PCT:-50}" -v satk="${GUILD_INTERVIEW_SATURATION_K:-3}" \
    -v cadence="${GUILD_INTERVIEW_CADENCE_DAYS:-7}" -v common="${GUILD_INTERVIEW_COMMON:-6}" '
    function v(name) { return (name in col) ? $(col[name]) : "" }
    function isdate(s) { return s ~ /^20[0-9][0-9]-[01][0-9]-[0-3][0-9]$/ }
    function dnum(d,   y, m, dd, era, yoe, doy, doe) {   # days since 1970-01-01 (civil calendar)
      y = substr(d, 1, 4) + 0; m = substr(d, 6, 2) + 0; dd = substr(d, 9, 2) + 0
      if (m <= 2) y--
      era = int((y >= 0 ? y : y - 399) / 400); yoe = y - era * 400
      doy = int((153 * (m + (m > 2 ? -3 : 9)) + 2) / 5) + dd - 1
      doe = yoe * 365 + int(yoe / 4) - int(yoe / 100) + doy
      return era * 146097 + doe - 719468
    }
    function viol(msg) { print "row " FNR " (" id "): " msg > "/dev/stderr"; errs++ }
    function segviol(msg) { print msg > "/dev/stderr"; errs++ }
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    BEGIN {
      nreq = split("interview_id date segment_id role org_type org_size channel language interviewer consent_id recorded solution_revealed top_pains last_occurrence_date past_behavior workaround current_spend_php current_spend_time wtp_signal verbatim_quote commitment_type commitment_detail next_step_date new_codes_count snapshot_link", req, " ")
      nq = split(quota_spec, qs, ";")
      for (i = 1; i <= nq; i++) if (qs[i] != "") {
        j = index(qs[i], "="); s = trim(substr(qs[i], 1, j - 1)); q = trim(substr(qs[i], j + 1))
        if (s == "") continue
        if (!(s in active)) { active[s] = 1; aorder[++nactive] = s }
        quota[s] = (q ~ /^[0-9]+$/) ? q + 0 : quota_default + 0
      }
      errs = 0; rows = 0; hdr = 0; hdrbad = 0; nohdr = 0; nseg = 0
    }
    { sub(/\r$/, "") }
    FILENAME == cf {                                   # ---- consent.tsv → per-participant map
      if ($0 ~ /^#/ || $1 == "participant_id" || NF == 0 || $0 ~ /^[[:space:]]*$/) next
      p = trim($1); if (p == "") next
      c_has[p] = 1; c_date[p] = trim($2); c_rec[p] = trim($4); c_quotes[p] = trim($5)
      c_spi[p] = trim($6); c_spiex[p] = trim($7); c_incent[p] = trim($8); c_wd[p] = trim($9); c_del[p] = trim($10)
      next
    }
    /^#/ { next }
    NF == 0 || /^[[:space:]]*$/ { next }
    !hdr && $1 == "interview_id" {                      # ---- header → column map (order-free)
      for (i = 1; i <= NF; i++) { h = trim($i); if (h != "") col[h] = i }
      for (i = 1; i <= nreq; i++) if (!(req[i] in col)) { print "header: missing column " req[i] > "/dev/stderr"; hdrbad++ }
      if (hdrbad) { print "score-guild: interviews: header lacks " hdrbad " required column(s)" > "/dev/stderr"; exit 2 }
      hdr = 1; next
    }
    !hdr { nohdr = 1; print "score-guild: interviews: no header row (the first non-comment line must start with interview_id)" > "/dev/stderr"; exit 2 }
    {                                                   # ---- one interview row
      rows++
      id = trim(v("interview_id")); if (id == "") id = "?"
      if (NF < nreq) { viol("expected >= " nreq " columns, got " NF); next }
      if (id == "?") viol("empty interview_id")
      else if (seen[id]++) viol("duplicate interview_id " id)
      d = trim(v("date")); seg = trim(v("segment_id")); cid = trim(v("consent_id"))
      rec = trim(v("recorded")); sr = trim(v("solution_revealed")); wtp = trim(v("wtp_signal"))
      ct = trim(v("commitment_type")); ncc = trim(v("new_codes_count")); quote = trim(v("verbatim_quote"))
      php = trim(v("current_spend_php")); tm = trim(v("current_spend_time"))
      if (!isdate(d)) viol("bad date \"" d "\" (YYYY-MM-DD)")
      else if (d > today) viol("date " d " is after as_of " today " (a future interview is not evidence)")
      if (seg == "") viol("empty segment_id")
      # consent join and consent scope (RA 10173)
      if (cid == "" || !(cid in c_has)) {
        viol("no consent row for consent_id \"" cid "\" in consent.tsv (RA 10173 s.3(b): every interview joins a consent row)")
      } else {
        if (c_spi[cid] == "Y" && c_spiex[cid] != "Y")
          viol("consent " cid ": spi_collected=Y but spi_explicit_consent=" (c_spiex[cid] == "" ? "(empty)" : c_spiex[cid]) " (RA 10173 s.13: sensitive personal information needs explicit consent)")
        if (!isdate(c_del[cid])) viol("consent " cid ": bad deletion_due \"" c_del[cid] "\" (YYYY-MM-DD)")
        else if (c_del[cid] < today) viol("consent " cid ": used past deletion_due " c_del[cid] " (as_of " today "; RA 10173 s.11 retention)")
        if (c_wd[cid] != "" && c_wd[cid] <= today) viol("consent " cid ": participant withdrew on " c_wd[cid] " - the row may not be used (RA 10173 s.16)")
        if (isdate(c_date[cid]) && isdate(d) && c_date[cid] > d) viol("consent " cid " is dated " c_date[cid] ", after the interview on " d)
        if (rec == "Y" && c_rec[cid] != "Y") viol("recorded=Y but consent " cid " has recording=" (c_rec[cid] == "" ? "(empty)" : c_rec[cid]))
        if (quote != "" && c_quotes[cid] != "Y") viol("verbatim_quote present but consent " cid " has quotes_allowed=" (c_quotes[cid] == "" ? "(empty)" : c_quotes[cid]))
        if (c_incent[cid] == "N") print "note: row " FNR " (" id "): consent " cid " incentive_given_at_start=N (give the incentive at the start, never contingent on feedback)" > "/dev/stderr"
      }
      # enumerations and formats
      if (rec != "Y" && rec != "N") viol("bad recorded \"" rec "\" (Y|N)")
      if (sr != "Y" && sr != "N") viol("bad solution_revealed \"" sr "\" (Y|N)")
      if (wtp != "unprompted" && wtp != "prompted" && wtp != "none") viol("bad wtp_signal \"" wtp "\" (unprompted|prompted|none)")
      if (ct != "none" && ct != "time" && ct != "reputation" && ct != "money") viol("bad commitment_type \"" ct "\" (none|time|reputation|money)")
      if (ncc !~ /^[0-9]+$/) viol("bad new_codes_count \"" ncc "\" (integer; 0 when the interview added no new codes)")
      if (php != "" && php !~ /^[0-9]+(\.[0-9]+)?$/) viol("bad current_spend_php \"" php "\" (number, PHP per month)")
      if (tm != "" && tm !~ /^[0-9]+(\.[0-9]+)?$/) viol("bad current_spend_time \"" tm "\" (number, hours per month)")
      lo = trim(v("last_occurrence_date")); if (lo != "" && !isdate(lo)) viol("bad last_occurrence_date \"" lo "\"")
      ns = trim(v("next_step_date")); if (ns != "" && !isdate(ns)) viol("bad next_step_date \"" ns "\"")
      if (rec != "Y" && quote == "") viol("neither recorded=Y nor a verbatim_quote (record the conversation or capture exact words)")
      if (ct != "none" && ct != "" && ns == "") print "note: row " FNR " (" id "): commitment_type=" ct " without a next_step_date" > "/dev/stderr"
      # evidence grade (brief 01 G4)
      eg = (trim(v("past_behavior")) != "" && ((php + 0) > 0 || (tm + 0) > 0 || (wtp != "none" && wtp != "") || (ct != "none" && ct != ""))) ? 1 : 0
      if ("evidence_kind" in col) {
        ek = trim(v("evidence_kind"))
        if (ek != "say" && ek != "do") viol("bad evidence_kind \"" ek "\" (say|do)")
        else if (ek == "do" && !eg) viol("evidence_kind=do but the row is not evidence-grade (needs past_behavior AND spend, time, WTP or commitment)")
      }
      # collect per segment for the ordered checks
      if (seg != "") {
        if (!(seg in segidx)) { segidx[seg] = ++nseg; segname[nseg] = seg }
        m = ++segn[seg]; if (eg) sege[seg]++
        key[seg, m] = (isdate(d) ? d : "9999-99-99") "|" id "|" FNR
        rid[seg, m] = id; rrow[seg, m] = FNR; rsr[seg, m] = sr; rncc[seg, m] = ncc; rdate[seg, m] = d
      }
    }
    END {
      if (hdrbad || nohdr) exit 2
      if (!hdr) { print "score-guild: interviews: no header row (the first non-comment line must start with interview_id)" > "/dev/stderr"; exit 2 }
      for (si = 1; si <= nseg; si++) {                  # ---- per segment, in date order
        s = segname[si]; m = segn[s]
        for (i = 1; i <= m; i++) ord[i] = i
        for (i = 2; i <= m; i++) { t = ord[i]; j = i - 1; while (j >= 1 && key[s, ord[j]] > key[s, t]) { ord[j + 1] = ord[j]; j-- } ord[j + 1] = t }
        for (p = 1; p <= m && p <= nopitch; p++) { r = ord[p]
          if (rsr[s, r] == "Y") { print "row " rrow[s, r] " (" rid[s, r] "): solution_revealed=Y at position " p " of segment " s " (the first " nopitch " interviews per segment must be N: a pitched respondent is contaminated)" > "/dev/stderr"; errs++ }
        }
        if (m >= satk) {
          z = 1; lst = ""
          for (p = m - satk + 1; p <= m; p++) { if (rncc[s, ord[p]] + 0 != 0) z = 0; lst = lst (lst == "" ? "" : ",") rncc[s, ord[p]] }
          print "saturation: segment " s ": " (z ? "reached" : "not reached") " (new_codes_count on the last " satk ": " lst ")" > "/dev/stderr"
        } else print "saturation: segment " s ": not assessable (" m " < " satk " interviews)" > "/dev/stderr"
        maxgap = 0; ga = ""; gb = ""
        for (p = 2; p <= m; p++) if (isdate(rdate[s, ord[p]]) && isdate(rdate[s, ord[p - 1]])) {
          g = dnum(rdate[s, ord[p]]) - dnum(rdate[s, ord[p - 1]]); if (g > maxgap) { maxgap = g; ga = rdate[s, ord[p - 1]]; gb = rdate[s, ord[p]] }
        }
        if (m >= 2) print "cadence: segment " s ": max gap " maxgap " d" (maxgap > cadence ? " > " cadence " d between " ga " and " gb " (policy: >= 1 interview per week while discovery is open)" : " (within " cadence " d)") > "/dev/stderr"
        if (isdate(rdate[s, ord[m]])) { since = dnum(today) - dnum(rdate[s, ord[m]]); if (since > cadence) print "cadence: segment " s ": last interview " rdate[s, ord[m]] " was " since " d before as_of " today > "/dev/stderr" }
      }
      if (nactive == 0) {                                # ---- which segments are held to the quota
        best = 0
        for (si = 1; si <= nseg; si++) if (segn[segname[si]] > best) best = segn[segname[si]]
        for (si = 1; si <= nseg; si++) if (segn[segname[si]] == best) { s = segname[si]; active[s] = 1; aorder[++nactive] = s; quota[s] = quota_default + 0 }
        if (nactive) print "quota: no quota.tsv - the most-interviewed segment is held to the default quota " quota_default > "/dev/stderr"
      }
      for (ai = 1; ai <= nactive; ai++) {
        s = aorder[ai]; m = segn[s] + 0; e = sege[s] + 0; share = (m > 0) ? int(100 * e / m + 1e-9) : 0
        if (m < quota[s]) segviol("segment " s ": " m " interviews < quota " quota[s] " (>= " quota[s] " per segment under active discovery before discovery exit)")
        if (m > 0 && 100 * e < evpct * m) segviol("segment " s ": evidence-grade share " e "/" m " = " share " % < " evpct " % (past behaviour AND spend, time, WTP or commitment)")
        else if (m > 0) print "segment " s ": evidence-grade " e "/" m " (" share " %)" > "/dev/stderr"
        if (m > 0 && m < common) print "segment " s ": " m " < " common " interviews - no theme may be called common yet" > "/dev/stderr"
      }
      for (si = 1; si <= nseg; si++) { s = segname[si]
        if (!(s in active)) print "segment " s ": " segn[s] " interviews, evidence-grade " sege[s] + 0 " - not under active discovery (quota not applied; list it in quota.tsv to hold it to one)" > "/dev/stderr"
      }
      if (rows == 0) print "no interview rows (header-only ledger: a fresh venture starts clean)" > "/dev/stderr"
      printf "INTERVIEW_VIOLATIONS: %d\n", errs
      exit 0
    }
  ' "$cfile" "$ifile"
}
