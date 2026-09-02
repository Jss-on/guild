#!/usr/bin/env bash
# gate: icp — every ICP leaf traces to ≥ k interview ids that exist in the HUMAN-ENTERED interview
# ledger; four forces quoted; five beachhead criteria sourced; ≥ 3 anti-ICP disqualifiers; a named
# decision maker; a legal procurement mode (+ PhilGEPS certificate status when public).
#   score-guild.sh icp <icp.yaml> <interviews.tsv>   → "ICP_VIOLATIONS: N"   (offenders → stderr)
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing file, unparseable YAML)
#
# icp.yaml layout (guild_yaml_json subset: block maps, block lists, flow lists for ids; documented
# in references/discovery-protocol.md §8). A LEAF is a map carrying `value` (or `rule`) and
# `evidence_interview_ids: [I-n, …]`:
#   segment_id: smb-mfg                      # top-level scalar: the segment the ICP describes
#   firmographics:    industry · size_band · geography · revenue_band          → one leaf each
#   roles:            economic_buyer · champion · decision_maker_role · relationship_owner
#   technographics:   - leaf …               pains: - leaf …
#   triggers:         push · pull · anxiety · habit → list of leaves each (Moesta four forces)
#   buying_process:   procurement_mode · payment_terms_expected · withholding_class → leaf each;
#                     philgeps_certificate_status (scalar or leaf) when procurement_mode = philgeps_*
#   beachhead_criteria: burning_pain · willingness_to_pay · growth · access · expandable → leaf each
#   anti_icp:         disqualifiers: - { rule, evidence_interview_ids | evidence_claim_ids } … (≥ 3)
# Checks (brief 03 §5 G3.3, brief 01 G9):
#   · every leaf has a non-empty value and ≥ GUILD_ICP_MIN_IDS (3) DISTINCT interview ids —
#     GUILD_ICP_MIN_IDS_20 (5) once the segment has ≥ GUILD_ICP_MIN_IDS_AT (20) interviews;
#     every id exists in interviews.tsv; ICP leaves cite only the ICP segment (anti-ICP rules may
#     cite any segment — worst-fit respondents are their evidence)
#   · the 16 singleton leaves above are present (a bare scalar without ids is a violation)
#   · technographics, pains ≥ 1; triggers.push/pull/anxiety/habit ≥ 1 each; disqualifiers ≥ 3,
#     each with ≥ GUILD_ICP_MIN_IDS_ANTI (1) interview id or claim id (C-n)
#   · roles.decision_maker_role non-null
#   · procurement_mode ∈ private|philgeps_lcrb|philgeps_mearb|philgeps_consulting; philgeps_* needs
#     buying_process.philgeps_certificate_status
# node is used only through the _lib helpers (guild_yaml_json, guild_json_query); the JSON travels
# on argv, so an ICP beyond ~30 KB of parsed JSON is out of contract (split the segment).

GUILD_ICP_FLATTEN_JS='(()=>{const out=[];const S=v=>String(v===null||v===undefined?"":v).replace(/[\t\r\n]+/g," ");
const isLeaf=o=>o!==null&&typeof o==="object"&&!Array.isArray(o)&&("evidence_interview_ids" in o||"evidence_claim_ids" in o||"value" in o||"rule" in o);
const arr=a=>Array.isArray(a)?a.filter(x=>x!==null&&x!=="").map(S):(a===null||a===undefined||a===""?[]:[S(a)]);
const walk=(n,p)=>{
 if(Array.isArray(n)){out.push(["LIST",p,String(n.length)].join("\t"));n.forEach((it,i)=>walk(it,p+"["+i+"]"));return;}
 if(n===null||typeof n!=="object"){out.push(["SCALAR",p,S(n)].join("\t"));return;}
 if(isLeaf(n)){const val=("value" in n)?n.value:(("rule" in n)?n.rule:null);out.push(["LEAF",p,S(val),arr(n.evidence_interview_ids).join(","),arr(n.evidence_claim_ids).join(","),("evidence_interview_ids" in n)?"1":"0"].join("\t"));return;}
 const ks=Object.keys(n);if(ks.length===0){out.push(["EMPTY",p,""].join("\t"));return;}
 for(const k of ks)walk(n[k],p?p+"."+k:k);};
walk(d,"");return out.join("\n");})()'

gate_icp() {
  local icp="${1:?usage: icp <icp.yaml> <interviews.tsv>}"
  local ifile="${2:?usage: icp <icp.yaml> <interviews.tsv>}"
  [[ -f "$icp" ]]   || { echo "score-guild: icp: missing icp.yaml $icp" >&2; return 2; }
  [[ -f "$ifile" ]] || { echo "score-guild: icp: missing interview ledger $ifile" >&2; return 2; }
  local json flat ids
  json="$(guild_yaml_json "$icp")" || { echo "score-guild: icp: cannot parse $icp (guild_yaml_json subset: block maps/lists, flow lists, quoted strings)" >&2; return 2; }
  flat="$(guild_json_query "$json" "$GUILD_ICP_FLATTEN_JS")" || { echo "score-guild: icp: cannot flatten $icp" >&2; return 2; }
  ids="$(awk -F'\t' '
    { sub(/\r$/, "") }
    /^#/ { next }
    NF == 0 || /^[[:space:]]*$/ { next }
    $1 == "interview_id" { for (i = 1; i <= NF; i++) col[$i] = i; next }
    { ci = ("interview_id" in col) ? col["interview_id"] : 1; cs = ("segment_id" in col) ? col["segment_id"] : 3
      x = $ci; gsub(/^[ \t]+|[ \t]+$/, "", x); s = $cs; gsub(/^[ \t]+|[ \t]+$/, "", s)
      if (x != "") printf "ID\t%s\t%s\n", x, s }' "$ifile")"
  { printf '%s\n' "$ids"; printf '%s\n' "$flat"; } | awk -F'\t' \
    -v kmin="${GUILD_ICP_MIN_IDS:-3}" -v k20="${GUILD_ICP_MIN_IDS_20:-5}" -v k20at="${GUILD_ICP_MIN_IDS_AT:-20}" \
    -v kanti="${GUILD_ICP_MIN_IDS_ANTI:-1}" -v ledger="$ifile" '
    function viol(msg) { print msg > "/dev/stderr"; errs++ }
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    BEGIN {
      nsing = split("firmographics.industry firmographics.size_band firmographics.geography firmographics.revenue_band roles.economic_buyer roles.champion roles.decision_maker_role roles.relationship_owner buying_process.procurement_mode buying_process.payment_terms_expected buying_process.withholding_class beachhead_criteria.burning_pain beachhead_criteria.willingness_to_pay beachhead_criteria.growth beachhead_criteria.access beachhead_criteria.expandable", sing, " ")
      nl = split("technographics:1 pains:1 triggers.push:1 triggers.pull:1 triggers.anxiety:1 triggers.habit:1 anti_icp.disqualifiers:3", lspec, " ")
      for (i = 1; i <= nl; i++) { j = index(lspec[i], ":"); lorder[i] = substr(lspec[i], 1, j - 1); lmin[lorder[i]] = substr(lspec[i], j + 1) + 0 }
      errs = 0; nint = 0; nleaf = 0
    }
    $1 == "ID"     { x = $2; if (!(x in have)) { have[x] = 1; nint++; if ($3 != "") nseg[$3]++ } segof[x] = $3; next }
    $1 == "SCALAR" { sc[$2] = $3; next }
    $1 == "LIST"   { lst[$2] = $3 + 0; next }
    $1 == "EMPTY"  { emp[$2] = 1; next }
    $1 == "LEAF"   { p = $2; leaf[p] = 1; lval[p] = trim($3); lids[p] = $4; lcl[p] = $5; lhas[p] = $6; lorder2[++nleaf] = p; next }
    END {
      seg = ("segment_id" in sc) ? trim(sc["segment_id"]) : ""
      ncount = (seg != "") ? (nseg[seg] + 0) : nint
      k = (ncount >= k20at) ? k20 : kmin
      if (seg != "" && ncount == 0) viol("segment_id \"" seg "\" has no interviews in " ledger " (an ICP describes an interviewed segment)")
      print "icp: segment=" (seg == "" ? "(undeclared: any segment accepted)" : seg) " interviews=" ncount " min_ids_per_leaf=" k " (" kmin " default, " k20 " once >= " k20at " interviews)" > "/dev/stderr"
      for (i = 1; i <= nleaf; i++) {                          # ---- every leaf
        p = lorder2[i]; anti = (p ~ /^anti_icp\./) ? 1 : 0
        if (p == "roles.decision_maker_role") {
          if (lval[p] == "" || lval[p] == "null") viol("leaf roles.decision_maker_role: null - name who signs (PH buying is hierarchy-heavy; a deal without a named decision maker stalls)")
        } else if (lval[p] == "" || lval[p] == "null") viol("leaf " p ": empty value")
        n = split(lids[p], ids, ","); split("", u); good = 0
        for (j = 1; j <= n; j++) {
          x = trim(ids[j]); if (x == "" || (x in u)) continue; u[x] = 1
          if (!(x in have)) { viol("leaf " p ": interview id " x " not in interviews.tsv (a leaf may only cite interviews that exist in the human-entered ledger)"); continue }
          if (!anti && seg != "" && segof[x] != seg) { viol("leaf " p ": interview " x " belongs to segment " segof[x] ", not the ICP segment " seg); continue }
          good++
        }
        if (anti) {
          nc = split(lcl[p], cl, ","); cgood = 0
          for (j = 1; j <= nc; j++) { x = trim(cl[j]); if (x == "") continue; if (x ~ /^C-[0-9]+$/) cgood++; else viol("leaf " p ": bad claim id \"" x "\" (C-n)") }
          if (good + cgood < kanti) viol("disqualifier " p ": " good " interview id(s) + " cgood " claim id(s) < " kanti " (an anti-ICP rule needs evidence, not taste)")
        } else if (lhas[p] != "1") viol("leaf " p ": no evidence_interview_ids list (every ICP leaf traces to interviews)")
        else if (good < k) viol("leaf " p ": " good " distinct interview id(s) < " k " required (GUILD_ICP_MIN_IDS)")
      }
      for (i = 1; i <= nsing; i++) {                          # ---- required singleton leaves
        p = sing[i]; if (p in leaf) continue
        if (p in sc) viol("leaf " p ": given as a bare scalar \"" sc[p] "\" without evidence_interview_ids")
        else viol("missing leaf " p (p == "roles.decision_maker_role" ? " (name who signs: PH buying is hierarchy-heavy)" : ""))
      }
      for (i = 1; i <= nl; i++) {                             # ---- required lists
        p = lorder[i]
        why = (p ~ /^triggers\./) ? " (four forces: push, pull, anxiety and habit must all be quoted from interviews)" : ((p ~ /^anti_icp/) ? " (>= 3 anti-ICP disqualifiers)" : "")
        if (p in lst) { if (lst[p] < lmin[p]) viol("list " p ": " lst[p] " item(s) < " lmin[p] why) }
        else if ((p in sc) || (p in emp)) viol("list " p ": empty, 0 item(s) < " lmin[p] why)
        else viol("missing list " p why)
      }
      if ("buying_process.procurement_mode" in leaf) {        # ---- procurement mode
        pm = lval["buying_process.procurement_mode"]
        if (pm !~ /^(private|philgeps_lcrb|philgeps_mearb|philgeps_consulting)$/) viol("procurement_mode \"" pm "\" not in private|philgeps_lcrb|philgeps_mearb|philgeps_consulting")
        else if (pm ~ /^philgeps_/) {
          cp = "buying_process.philgeps_certificate_status"
          cs = (cp in leaf) ? lval[cp] : ((cp in sc) ? trim(sc[cp]) : "")
          if (cs == "" || cs == "null") viol("procurement_mode " pm " requires buying_process.philgeps_certificate_status (PhilGEPS Platinum certificate; an official receipt is not the certificate)")
        }
      }
      printf "ICP_VIOLATIONS: %d\n", errs
    }'
}
