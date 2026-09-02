#!/usr/bin/env bash
# gate: claims — claims-ledger validity (forge research schema): citation anchoring, tier floors,
# orphan / uncitable references.
#   score-guild.sh claims <claims.tsv> <sources.tsv>
#     → "CLAIMS: VALID|INVALID total=N high=… moderate=… low=… contested=… orphans=N"
#   exit 0 VALID · 1 INVALID · 2 hard error
#
# claims.tsv — 6 tab-separated columns (header optional):
#   id  rq  claim  confidence  sources  evidence
#   id          C-<n>, unique            rq  RQ-<n> (the question / assumption the claim answers)
#   claim       one atomic, falsifiable sentence — magnitudes carry value · units · conditions
#   confidence  high|moderate|low|contested
#   sources     comma-joined S-ids; every id must exist in sources.tsv and be citable
#               (status read|cited); tier floors: high ≥ 2 distinct T1/T2 · moderate ≥ 1 T1/T2 ·
#               contested ≥ 2 sources incl. a T1/T2 · T3/T4-only ⇒ low · T4-only invalid
#   evidence    evidence:<relpath> into the reading notes
# Contract: references/evidence-protocol.md §3.

gate_claims() {
  local cfile="${1:?usage: claims <claims.tsv> <sources.tsv>}"
  local sfile="${2:?usage: claims <claims.tsv> <sources.tsv>}"
  [[ -f "$cfile" ]] || { echo "CLAIMS: INVALID total=0 high=0 moderate=0 low=0 contested=0 orphans=0"; echo "file not found: $cfile" >&2; return 2; }
  [[ -f "$sfile" ]] || { echo "CLAIMS: INVALID total=0 high=0 moderate=0 low=0 contested=0 orphans=0"; echo "file not found: $sfile" >&2; return 2; }
  local out
  out="$(awk -v FS='\t' '
    BEGIN {
      split("high moderate low contested", cArr, " "); for (i in cArr) cOK[cArr[i]] = 1;
      errs = 0; total = 0; orphans = 0;
    }
    FNR == NR {
      if ($0 ~ /^#/ || ($1 == "id" && $2 == "tier") || NF == 0 || $0 ~ /^[[:space:]]*$/) next;
      if (NF >= 9) { srcTier[$1] = $2; srcStatus[$1] = $9 }
      next;
    }
    /^#/ { next }
    $1 == "id" && $2 == "rq" { next }
    NF == 0 || $0 ~ /^[[:space:]]*$/ { next }
    {
      total++;
      if (NF < 6)        { print "row " FNR ": expected 6 columns, got " NF > "/dev/stderr"; errs++; next }
      if ($1 !~ /^C-[0-9]+$/) { print "row " FNR ": bad id \"" $1 "\" (C-<n>)" > "/dev/stderr"; errs++ }
      if (seen[$1]++)    { print "row " FNR ": duplicate id " $1 > "/dev/stderr"; errs++ }
      if ($2 !~ /^(RQ|V)-[0-9]+$/) { print "row " FNR ": bad rq \"" $2 "\" (RQ-<n> or V-<n>)" > "/dev/stderr"; errs++ }
      if (!($4 in cOK))  { print "row " FNR ": bad confidence \"" $4 "\"" > "/dev/stderr"; errs++ }
      if ($6 !~ /evidence:/) { print "row " FNR ": missing evidence: ref" > "/dev/stderr"; errs++ }
      if ($5 == "")      { print "row " FNR ": no sources cited" > "/dev/stderr"; errs++; next }
      n = split($5, refs, ",");
      t12 = 0; cited = 0; delete uniq;
      for (i = 1; i <= n; i++) {
        r = refs[i]; gsub(/^[ \t]+|[ \t]+$/, "", r);
        if (r == "" || (r in uniq)) continue;
        uniq[r] = 1;
        if (!(r in srcTier)) {
          print "row " FNR ": orphan citation " r " (not in sources.tsv)" > "/dev/stderr"; errs++; orphans++; continue;
        }
        if (srcStatus[r] == "rejected" || srcStatus[r] == "unverified") {
          print "row " FNR ": cites " r " with status=" srcStatus[r] " (uncitable)" > "/dev/stderr"; errs++; continue;
        }
        cited++;
        if (srcTier[r] == "T1" || srcTier[r] == "T2") t12++;
      }
      if (cited > 0 && t12 == 0 && $4 != "low") {
        print "row " FNR ": T3/T4-only support requires confidence=low (got " $4 ")" > "/dev/stderr"; errs++;
      }
      if (cited > 0 && t12 == 0) {
        allT4 = 1;
        for (r in uniq) if ((r in srcTier) && srcTier[r] != "T4") allT4 = 0;
        if (allT4) { print "row " FNR ": T4-only support is invalid at any confidence" > "/dev/stderr"; errs++ }
      }
      if ($4 == "high"      && t12 < 2) { print "row " FNR ": high requires >=2 distinct T1/T2 (got " t12 ")" > "/dev/stderr"; errs++ }
      if ($4 == "moderate"  && t12 < 1) { print "row " FNR ": moderate requires >=1 T1/T2 (got " t12 ")" > "/dev/stderr"; errs++ }
      if ($4 == "contested" && (cited < 2 || t12 < 1)) { print "row " FNR ": contested requires >=2 sources incl a T1/T2" > "/dev/stderr"; errs++ }
      conf[$4]++;
    }
    END {
      printf "CLAIMS: %s total=%d high=%d moderate=%d low=%d contested=%d orphans=%d\n",
        (errs == 0 ? "VALID" : "INVALID"), total, conf["high"], conf["moderate"], conf["low"], conf["contested"], orphans;
      exit (errs == 0 ? 0 : 1);
    }
  ' "$sfile" "$cfile")"
  local rc=$?
  printf '%s\n' "$out"
  return $rc
}
