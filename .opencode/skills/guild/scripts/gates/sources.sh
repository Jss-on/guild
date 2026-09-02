#!/usr/bin/env bash
# gate: sources — source-ledger validity (forge research schema + guild provenance columns).
#   score-guild.sh sources <sources.tsv>   → "SOURCES: VALID|INVALID total=N t1=… t2=… t3=… t4=… unverified=N"
#   exit 0 VALID · 1 INVALID · 2 hard error
#
# sources.tsv — 13 tab-separated columns (header optional):
#   id tier type year title venue locator depth status retrieved_at archived_url content_hash fetch_status
#   id           S-<n>, unique
#   tier         T1|T2|T3|T4 (publication class, never agreement)
#   locator      doi:|pmid:|pmcid:|arxiv:|isbn:|url:http(s)…
#   depth        full|abstract|secondary
#   status       read|cited|rejected|unverified   (rejected/unverified are uncitable)
#   retrieved_at YYYY-MM-DD
#   archived_url https://web.archive.org/web/<14 digits>/…  or "-" when fetch_status=manual
#   content_hash 16–64 hex chars of the fetched body, or "-" when fetch_status=manual
#   fetch_status live|archived|manual   ("captcha", "blocked", "" are NOT sources)
# Contract: references/evidence-protocol.md §2.

gate_sources() {
  local file="${1:?usage: sources <sources.tsv>}"
  [[ -f "$file" ]] || { echo "SOURCES: INVALID total=0 t1=0 t2=0 t3=0 t4=0 unverified=0"; echo "file not found: $file" >&2; return 2; }
  local out
  out="$(awk -v FS='\t' '
    BEGIN {
      split("T1 T2 T3 T4", tArr, " ");                 for (i in tArr) tOK[tArr[i]] = 1;
      split("full abstract secondary", dArr, " ");     for (i in dArr) dOK[dArr[i]] = 1;
      split("read cited rejected unverified", sArr, " "); for (i in sArr) sOK[sArr[i]] = 1;
      split("live archived manual", fArr, " ");        for (i in fArr) fOK[fArr[i]] = 1;
      errs = 0; total = 0; unv = 0;
    }
    /^#/ { next }
    $1 == "id" && $2 == "tier" { next }
    NF == 0 || $0 ~ /^[[:space:]]*$/ { next }
    {
      total++;
      if (NF < 13)        { print "row " NR ": expected 13 columns, got " NF > "/dev/stderr"; errs++; next }
      if ($1 !~ /^S-[0-9]+$/) { print "row " NR ": bad id \"" $1 "\" (S-<n>)" > "/dev/stderr"; errs++ }
      if (seen[$1]++)     { print "row " NR ": duplicate id " $1 > "/dev/stderr"; errs++ }
      if (!($2 in tOK))   { print "row " NR ": bad tier \"" $2 "\" (T1|T2|T3|T4)" > "/dev/stderr"; errs++ }
      if ($4 !~ /^(1[89]|20)[0-9][0-9]$/) { print "row " NR ": bad year \"" $4 "\"" > "/dev/stderr"; errs++ }
      if ($7 !~ /^(doi|pmid|pmcid|arxiv|isbn):./ && $7 !~ /^url:https?:\/\//) {
        print "row " NR ": bad locator \"" $7 "\" (doi:|pmid:|pmcid:|arxiv:|isbn:|url:http…)" > "/dev/stderr"; errs++
      }
      if (!($8 in dOK))   { print "row " NR ": bad depth \"" $8 "\" (full|abstract|secondary)" > "/dev/stderr"; errs++ }
      if (!($9 in sOK))   { print "row " NR ": bad status \"" $9 "\" (read|cited|rejected|unverified)" > "/dev/stderr"; errs++ }
      if ($10 !~ /^20[0-9][0-9]-[01][0-9]-[0-3][0-9]$/) { print "row " NR ": bad retrieved_at \"" $10 "\" (YYYY-MM-DD)" > "/dev/stderr"; errs++ }
      if (!($13 in fOK))  { print "row " NR ": bad fetch_status \"" $13 "\" (live|archived|manual — a CAPTCHA/blocked page is not a source)" > "/dev/stderr"; errs++ }
      if ($13 == "manual") {
        # a manually-obtained source may carry "-" for archive + hash but must say so
      } else {
        if ($11 !~ /^https:\/\/web\.archive\.org\/web\/[0-9]{14}/ && $11 !~ /^https?:\/\/.+/) {
          print "row " NR ": bad archived_url \"" $11 "\" (web.archive.org/web/<14 digits>/… or an archive URL)" > "/dev/stderr"; errs++
        }
        if ($12 !~ /^[0-9a-f]{16,64}$/) { print "row " NR ": bad content_hash \"" $12 "\" (16–64 hex)" > "/dev/stderr"; errs++ }
      }
      tc[tolower($2)]++;
      if ($9 == "unverified") unv++;
    }
    END {
      printf "SOURCES: %s total=%d t1=%d t2=%d t3=%d t4=%d unverified=%d\n",
        (errs == 0 ? "VALID" : "INVALID"), total, tc["t1"], tc["t2"], tc["t3"], tc["t4"], unv;
      exit (errs == 0 ? 0 : 1);
    }
  ' "$file")"
  local rc=$?
  printf '%s\n' "$out"
  return $rc
}
