#!/usr/bin/env bash
# gate: vrs — Venture Requirements Spec measurability: every V-n row is a "We believe" assumption
# with a metric, a threshold that has a number AND a direction, a test method on the validation
# ladder, an evidence grade the method can actually yield, an owner, a decide-by date and a risk
# rank; the riskiest rows are tested by doing, not asking.
#   score-guild.sh vrs <vrs.md>   → "VRS_MEASURABLE: x/y"   (x = rows passing every check, y = rows found)
#   exit 0 on well-formed input (x < y is valid data) · 2 hard error (missing file)
#
# Row format (references/venture-requirements-protocol.md §1): one fenced block per row —
#   ```vrs
#   id: V-1
#   statement: We believe that <segment> <does / needs / pays> …
#   type: D | F | V | A                       (desirability, feasibility, viability, adaptability)
#   metric: <what is counted, in what unit, over what population and period>
#   threshold: <number + direction: >= 3, <= 30 days, >= 60 % of n >= 12 …>
#   method: paid_pilot | LOI | pre_order | commitment | interview | survey | desk   (the ladder)
#   evidence_grade: strong | moderate | weak   (behaviour | intent | opinion — capped by method)
#   risk_rank: 1                              (1 = riskiest; unique per row)
#   owner: <person>
#   decide_by: YYYY-MM-DD
#   status: open | supported | refuted        (optional)
#   ```
# Checks: id V-n unique · statement starts "We believe" · type ∈ D|F|V|A · metric non-empty ·
# threshold has a digit and a comparator/direction word (an adjective fails) · method on the
# ladder (deposit ⇒ pre_order, "letter of intent" ⇒ LOI) · evidence_grade ≤ ceiling of the method
# (paid_pilot, pre_order → strong; LOI, commitment → moderate; interview, survey, desk → weak) ·
# owner · decide_by YYYY-MM-DD · risk_rank positive integer, no ties · the GUILD_VRS_TOP_DO (3)
# lowest ranks carry a do-class method (paid_pilot|LOI|pre_order|commitment).
# Informational (stderr): a V-n mentioned in prose without a block; decide_by past as_of while open.

gate_vrs() {
  local file="${1:?usage: vrs <vrs.md>}"
  [[ -f "$file" ]] || { echo "score-guild: vrs: missing VRS $file" >&2; return 2; }
  local today; today="$(guild_today "$file")"
  awk -v today="$today" -v topn="${GUILD_VRS_TOP_DO:-3}" '
    function viol(msg) { print msg > "/dev/stderr"; rbad[cur]++; errs++ }
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    function isdate(s) { return s ~ /^20[0-9][0-9]-[01][0-9]-[0-3][0-9]$/ }
    function norm_method(m,   t) {
      m = trim(m); t = tolower(m); gsub(/[ -]/, "_", t)
      if (t == "paid_pilot") return "paid_pilot"
      if (t == "loi" || t == "letter_of_intent") return "LOI"
      if (t == "pre_order" || t == "preorder" || t == "deposit" || t == "pre_sale") return "pre_order"
      if (t == "commitment") return "commitment"
      if (t == "interview" || t == "interviews") return "interview"
      if (t == "survey") return "survey"
      if (t == "desk" || t == "desk_research" || t == "analysis") return "desk"
      return m
    }
    function check(   id, lab, st, ty, mt, th, tl, me, gr, ow, db, rr) {
      cur = nb
      id = trim(f["id"]); lab = (id == "" ? "block at line " bstart : id)
      rid[cur] = lab; rline[cur] = bstart
      if (id !~ /^V-[0-9]+$/) viol(lab ": missing or bad id (V-n)")
      else if (id in seenid) viol(lab ": duplicate id " id " (first at line " seenid[id] ")")
      else seenid[id] = bstart
      st = trim(f["statement"])
      if (st == "") viol(lab ": missing statement")
      else if (st !~ /^("|“)?[Ww]e believe/) viol(lab ": statement does not start with \"We believe\" (a hypothesis to test, not a fact)")
      ty = trim(f["type"]); if (ty !~ /^[DFVA]$/) viol(lab ": type \"" ty "\" not in D|F|V|A (desirability, feasibility, viability, adaptability)")
      mt = trim(f["metric"]); if (mt == "") viol(lab ": missing metric (what is counted, unit, population, period)")
      th = trim(f["threshold"]); tl = tolower(th)
      if (th == "") viol(lab ": missing threshold")
      else if (tl !~ /[0-9]/) viol(lab ": threshold \"" th "\" has no number (an adjective is not a threshold)")
      else if (tl !~ /(>=|<=|>|<|=|≥|≤|at least|at most|no more than|no fewer than|no less than|not more than|not less than|minimum|maximum|within|between|or more|or fewer|or less|or better|below|above|under|over|exactly|up to)/) viol(lab ": threshold \"" th "\" has no direction (>=, <=, >, <, =, at least, at most, within, between ...)")
      me = norm_method(f["method"]); rmethod[cur] = me
      if (me == "") viol(lab ": missing method (test method on the validation ladder)")
      else if (!(me in rung)) viol(lab ": method \"" me "\" not on the validation ladder (paid_pilot > LOI > pre_order > commitment > interview > survey > desk)")
      gr = tolower(trim(f["evidence_grade"]))
      if (gr == "") viol(lab ": missing evidence_grade (strong|moderate|weak)")
      else if (!(gr in gval)) viol(lab ": evidence_grade \"" gr "\" not in strong|moderate|weak")
      else if ((me in rung) && gval[gr] > ceil[me]) viol(lab ": evidence_grade " gr " exceeds what method=" me " can yield (" cname[me] ")")
      ow = trim(f["owner"]); if (ow == "") viol(lab ": missing owner")
      db = trim(f["decide_by"])
      if (db == "") viol(lab ": missing decide_by (YYYY-MM-DD)")
      else if (!isdate(db)) viol(lab ": bad decide_by \"" db "\" (YYYY-MM-DD)")
      else if (db < today && tolower(trim(f["status"])) !~ /^(supported|refuted|closed)$/) print "note: " lab ": decide_by " db " is past as_of " today " and status is not supported|refuted" > "/dev/stderr"
      rr = trim(f["risk_rank"])
      if (rr !~ /^[1-9][0-9]*$/) viol(lab ": missing or bad risk_rank (positive integer, 1 = riskiest)")
      else if (rr in rankof) viol(lab ": risk_rank " rr " already used by " rankof[rr] " (a ranking has no ties)")
      else { rankof[rr] = lab; rrank[cur] = rr + 0 }
    }
    BEGIN {
      rung["paid_pilot"] = 1; rung["LOI"] = 2; rung["pre_order"] = 3; rung["commitment"] = 4; rung["interview"] = 5; rung["survey"] = 6; rung["desk"] = 7
      doclass["paid_pilot"] = 1; doclass["LOI"] = 1; doclass["pre_order"] = 1; doclass["commitment"] = 1
      gval["strong"] = 3; gval["moderate"] = 2; gval["weak"] = 1
      ceil["paid_pilot"] = 3; ceil["pre_order"] = 3; ceil["LOI"] = 2; ceil["commitment"] = 2; ceil["interview"] = 1; ceil["survey"] = 1; ceil["desk"] = 1
      cname["paid_pilot"] = "behaviour: strong"; cname["pre_order"] = "behaviour: strong"; cname["LOI"] = "intent: moderate"; cname["commitment"] = "intent: moderate"
      cname["interview"] = "opinion or reported behaviour: weak"; cname["survey"] = "opinion: weak"; cname["desk"] = "desk analysis: weak"
      nb = 0; errs = 0; inb = 0; fence = 0
    }
    { sub(/\r$/, "") }
    !inb && /^```vrs[ \t]*$/ { inb = 1; bstart = FNR; nb++; split("", f); next }
    inb && /^```/ { inb = 0; check(); next }
    inb { if (match($0, /^[a-z_]+:/)) { k = substr($0, 1, RLENGTH - 1); f[k] = trim(substr($0, RLENGTH + 1)) } next }
    !inb && /^```/ { fence = !fence; next }
    !inb && !fence { t = $0; while (match(t, /V-[0-9]+/)) { m = substr(t, RSTART, RLENGTH); if (!(m in mention)) mention[m] = FNR; t = substr(t, RSTART + RLENGTH) } }
    END {
      if (inb) { cur = nb; viol("block at line " bstart ": unterminated vrs block (no closing fence)"); check() }
      for (t = 1; t <= topn; t++) {                             # ---- riskiest rows need a do-class test
        bi = 0
        for (i = 1; i <= nb; i++) if ((i in rrank) && !(i in picked) && (bi == 0 || rrank[i] < rrank[bi])) bi = i
        if (bi == 0) break
        picked[bi] = 1; cur = bi
        if ((rmethod[bi] in rung) && !(rmethod[bi] in doclass))
          viol(rid[bi] ": risk_rank " rrank[bi] " is among the riskiest " topn " but method=" rmethod[bi] " is say-class - the riskiest assumptions need a do-class test (paid_pilot|LOI|pre_order|commitment)")
        else if (rmethod[bi] in doclass) print "riskiest " topn ": " rid[bi] " (rank " rrank[bi] ") method=" rmethod[bi] " do-class ok" > "/dev/stderr"
      }
      for (m in mention) if (!(m in seenid)) print "note: " m " is mentioned at line " mention[m] " but has no vrs block (coverage will expect a row)" > "/dev/stderr"
      pass = 0
      for (i = 1; i <= nb; i++) if (!(i in rbad)) pass++
      if (nb == 0) print "no vrs blocks found (rows are fenced ```vrs blocks, one per V-n)" > "/dev/stderr"
      printf "VRS_MEASURABLE: %d/%d\n", pass, nb
    }' "$file"
}
