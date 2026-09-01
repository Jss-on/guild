#!/usr/bin/env bash
# gate: compliance — the Philippine compliance register scored against the company profile.
#   score-guild.sh compliance <register.csv> <profile.yaml>   → "COMPLIANCE: x/y"
#     y = register rows applicable under the profile (applies_if) + profile-consistency
#         violations with no row to blame (a missing mandatory row is an applicable-but-failed row)
#     x = applicable rows in good standing: done on time with resolving evidence (path exists and
#         is non-empty, evidence_hash is a 16–64-hex sha256 prefix that matches the file,
#         evidence_date ≤ the computed deadline), professional-sign-off rows only with a resolving
#         signoff_path, source_grade=S rows only with non-empty notes — or not yet due.
#   Overdue / failed / inconsistent rows → stderr, one line each with the row id and the rule.
#   Upcoming deadlines warn at T-30 / T-7 / T-0; verified_on older than 12 months → RE-VERIFY.
#   "Today" = $GUILD_TODAY, else the register's "# as_of: YYYY-MM-DD" first line, else the system
#   date (fixtures always carry as_of so the frozen scorer never decays with the calendar).
#   exit 0 on well-formed input (x < y is valid data) · 2 hard error (missing file, bad schema,
#   invalid profile). Deadline-rule + applies_if grammars, consistency rules C1–C6 and the timing
#   model: references/compliance-protocol.md §3, §4, §12.
#   NOT legal, tax or financial advice: the gate checks a register a human maintains; every
#   filing, election and signature stays human-gated.

gate_compliance() {
  local reg="${1:?usage: compliance <register.csv> <profile.yaml>}"
  local prof="${2:?usage: compliance <register.csv> <profile.yaml>}"
  [[ -f "$reg" ]]  || { echo "score-guild: compliance: missing register $reg" >&2; return 2; }
  [[ -f "$prof" ]] || { echo "score-guild: compliance: missing profile $prof" >&2; return 2; }
  local today; today="$(guild_today "$reg")"
  local regdir   # pwd -W gives the Windows form under Git Bash so node resolves it; else POSIX pwd
  regdir="$(cd "$(dirname "$reg")" && { pwd -W 2>/dev/null || pwd; })"
  [[ -n "$regdir" ]] || { echo "score-guild: compliance: cannot resolve register dir" >&2; return 2; }
  local tmpd; tmpd="$(mktemp -d)" || { echo "score-guild: compliance: mktemp failed" >&2; return 2; }
  if ! guild_csv_json "$reg" > "$tmpd/register.json"; then
    rm -rf "$tmpd"; echo "score-guild: compliance: cannot parse register $reg" >&2; return 2
  fi
  if ! guild_yaml_json "$prof" > "$tmpd/profile.json"; then
    rm -rf "$tmpd"; echo "score-guild: compliance: cannot parse profile $prof" >&2; return 2
  fi
  node -e '
const fs=require("fs"),path=require("path"),crypto=require("crypto");
const SQ="\x27";
const rows=JSON.parse(fs.readFileSync(process.argv[1],"utf8"));
const profile=JSON.parse(fs.readFileSync(process.argv[2],"utf8"));
const regdir=process.argv[3];
const TODAY=process.argv[4];
const E=(m)=>process.stderr.write(m+"\n");
function hard(m){E("score-guild: compliance: "+m);process.exit(2);}

// ---- dates (UTC, YYYY-MM-DD) ----------------------------------------------------------------
function pd(s){const m=/^(20[0-9]{2})-([0-9]{2})-([0-9]{2})$/.exec(String(s==null?"":s).trim());
  if(!m)return null;const t=new Date(Date.UTC(+m[1],+m[2]-1,+m[3]));
  if(isNaN(t.getTime())||t.getUTCDate()!==+m[3])return null;return t;}
function iso(t){return t.toISOString().slice(0,10);}
function addD(t,n){return new Date(t.getTime()+n*86400000);}
function mkd(y,mo,dd){return new Date(Date.UTC(y,mo-1,dd));}
function monthEnd(y,mo){return addD(mkd(mo===12?y+1:y,mo===12?1:mo+1,1),-1);}
function dim(y,mo){return monthEnd(y,mo).getUTCDate();}
function days(a,b){return Math.round((b.getTime()-a.getTime())/86400000);}
const today=pd(TODAY);if(!today)hard("bad as_of/GUILD_TODAY date "+TODAY);

// ---- profile ---------------------------------------------------------------------------------
const MON={jan:1,feb:2,mar:3,apr:4,may:5,jun:6,jul:7,aug:8,sep:9,oct:10,nov:11,dec:12};
function parseMD(s){s=String(s==null?"":s).trim();
  let m=/^([0-9]{2})-([0-9]{2})$/.exec(s);if(m)return{mo:+m[1],dd:+m[2]};
  m=/^([A-Za-z]{3})-([0-9]{1,2})$/.exec(s);
  if(m&&MON[m[1].toLowerCase()])return{mo:MON[m[1].toLowerCase()],dd:+m[2]};
  return null;}
const perr=[];
function needBool(k){const v=profile[k];
  if(typeof v!=="boolean"){perr.push(k+" must be true|false (got "+JSON.stringify(v)+")");return false;}
  return v;}
function needNum(k){const v=profile[k];
  if(typeof v!=="number"){perr.push(k+" must be a number (got "+JSON.stringify(v)+")");return 0;}
  return v;}
const ENT=["sole_prop","opc","corp","partnership"];
if(ENT.indexOf(profile.entity_type)<0)perr.push("entity_type must be sole_prop|opc|corp|partnership");
const hasEmp=needBool("has_employees"),vat=needBool("vat_registered"),
      eight=needBool("eight_pct_elected"),online=needBool("sells_online");
const gross=needNum("gross_sales_12m");
needNum("foreign_equity");needNum("total_assets");needNum("total_liabilities");
const fye=parseMD(profile.fiscal_year_end);
if(!fye)perr.push("fiscal_year_end must be MM-DD or Mon-DD (e.g. 12-31 or Dec-31)");
const regDate=pd(profile.registration_date);
if(!regDate)perr.push("registration_date must be YYYY-MM-DD");
if(!("first_hire_date" in profile))perr.push("first_hire_date key required (YYYY-MM-DD or null)");
const hireDate=(profile.first_hire_date==null)?null:pd(profile.first_hire_date);
if(profile.first_hire_date!=null&&!hireDate)perr.push("first_hire_date must be YYYY-MM-DD or null");
if(perr.length)hard("invalid profile: "+perr.join("; "));

// ---- register schema -------------------------------------------------------------------------
const COLS=["id","obligation","category","applies_if","agency","cadence","deadline_rule",
"evidence_type","evidence_path","evidence_date","evidence_hash","status","owner",
"requires_professional_signoff","signoff_path","source_url","source_grade","verified_on","notes"];
if(rows.length){const miss=COLS.filter(c=>!(c in rows[0]));
  if(miss.length)hard("register missing column(s): "+miss.join(", "));}

// ---- applies_if: tokenize + recursive descent (no eval of register text, ever) ---------------
function tokenize(src){const toks=[];let i=0;
  while(i<src.length){const c=src[i];
    if(/\s/.test(c)){i++;continue;}
    if(c==="("||c===")"){toks.push({t:c});i++;continue;}
    if(c==="\""||c===SQ){const q=c;let j=i+1,buf="";
      while(j<src.length&&src[j]!==q){buf+=src[j];j++;}
      if(j>=src.length)throw new Error("unterminated string");
      toks.push({t:"str",v:buf});i=j+1;continue;}
    let m=/^[0-9][0-9_]*(\.[0-9]+)?/.exec(src.slice(i));
    if(m){toks.push({t:"num",v:Number(m[0].replace(/_/g,""))});i+=m[0].length;continue;}
    m=/^(==|!=|>=|<=|>|<|=)/.exec(src.slice(i));
    if(m){toks.push({t:m[0]==="="?"==":m[0]});i+=m[0].length;continue;}
    m=/^[A-Za-z_][A-Za-z0-9_]*/.exec(src.slice(i));
    if(m){const w=m[0].toLowerCase();
      if(w==="and"||w==="or"||w==="not")toks.push({t:w});
      else if(w==="true")toks.push({t:"lit",v:true});
      else if(w==="false")toks.push({t:"lit",v:false});
      else if(w==="null")toks.push({t:"lit",v:null});
      else toks.push({t:"id",v:m[0]});
      i+=m[0].length;continue;}
    throw new Error("unexpected character "+JSON.stringify(c));}
  return toks;}
function veq(a,b){if(a===null||b===null)return a===b;
  if(typeof a!==typeof b)return false;return a===b;}
function compare(op,a,b){
  if(op==="==")return veq(a,b);
  if(op==="!=")return !veq(a,b);
  const ok=(typeof a==="number"&&typeof b==="number")||(typeof a==="string"&&typeof b==="string");
  if(!ok)throw new Error("ordered comparison needs two numbers or two strings");
  if(op===">")return a>b;if(op===">=")return a>=b;if(op==="<")return a<b;return a<=b;}
function toBool(v){if(typeof v!=="boolean")throw new Error("expected a boolean, got "+JSON.stringify(v));return v;}
function evalExpr(src){const toks=tokenize(src);let p=0;
  const peek=()=>toks[p];
  function eat(t){if(!toks[p]||toks[p].t!==t)throw new Error("expected "+t);return toks[p++];}
  function atom(){const tk=peek();if(!tk)throw new Error("unexpected end of expression");
    if(tk.t==="("){p++;const v=orx();eat(")");return v;}
    if(tk.t==="num"||tk.t==="str"||tk.t==="lit"){p++;return tk.v;}
    if(tk.t==="id"){p++;if(!(tk.v in profile))throw new Error("unknown profile field "+tk.v);
      return profile[tk.v];}
    throw new Error("unexpected token "+tk.t);}
  function cmpx(){const a=atom();const tk=peek();
    if(tk&&["==","!=",">",">=","<","<="].indexOf(tk.t)>=0){p++;const b=atom();return compare(tk.t,a,b);}
    return a;}
  function notx(){if(peek()&&peek().t==="not"){p++;return !toBool(notx());}return cmpx();}
  function andx(){let v=notx();while(peek()&&peek().t==="and"){p++;const b=notx();v=toBool(v)&&toBool(b);}return v;}
  function orx(){let v=andx();while(peek()&&peek().t==="or"){p++;const b=andx();v=toBool(v)||toBool(b);}return v;}
  const v=orx();
  if(p<toks.length)throw new Error("trailing tokens near "+(toks[p].t||""));
  return v;}

// ---- deadline_rule ---------------------------------------------------------------------------
function parseRule(rule){rule=String(rule==null?"":rule).trim();
  if(rule==="")throw new Error("empty deadline_rule");
  if(rule==="once")return{kind:"single",anchor:"registration",off:0};
  if(/^20[0-9]{2}-[0-9]{2}-[0-9]{2}$/.test(rule)){const t=pd(rule);
    if(!t)throw new Error("bad absolute date "+rule);return{kind:"abs",date:t};}
  let m=/^(registration|hire_date)\+([0-9]+)d$/.exec(rule);
  if(m)return{kind:"single",anchor:m[1],off:+m[2]};
  m=/^(fye|quarter_end|month_end)\+([0-9]+)d$/.exec(rule);
  if(m)return{kind:"period",unit:m[1],off:+m[2]};
  m=/^([A-Za-z]{3}-[0-9]{1,2}(\|[A-Za-z]{3}-[0-9]{1,2})*)(@fye)?$/.exec(rule);
  if(m){const ds=m[1].split("|").map(parseMD);
    if(ds.some(x=>!x))throw new Error("bad fixed date in "+rule);
    return{kind:"fixed",dates:ds,lookback:!!m[3]};}
  throw new Error("unparseable deadline_rule "+JSON.stringify(rule));}
function fyeOf(y){return mkd(y,fye.mo,Math.min(fye.dd,dim(y,fye.mo)));}
function lastFyeBefore(D){let P=fyeOf(D.getUTCFullYear());
  if(P>=D)P=fyeOf(D.getUTCFullYear()-1);return P;}
// owed occurrences {P|null, D} sorted by D, within [trigger year − 1, today year + 2]
function occurrences(R,trig){const out=[];
  const y0=trig.getUTCFullYear()-1,y1=today.getUTCFullYear()+2;
  if(R.kind==="single"){const base=(R.anchor==="hire_date")?hireDate:regDate;
    if(!base)throw new Error("rule needs first_hire_date but the profile has none");
    out.push({P:null,D:addD(base,R.off)});}
  else if(R.kind==="abs")out.push({P:null,D:R.date});
  else if(R.kind==="period"){
    if(R.unit==="fye"){for(let y=y0;y<=y1;y++){const P=fyeOf(y);
      if(P>=trig)out.push({P,D:addD(P,R.off)});}}
    else if(R.unit==="quarter_end"){for(let y=y0;y<=y1;y++)for(const mo of[3,6,9,12]){
      const P=monthEnd(y,mo);if(P>=trig)out.push({P,D:addD(P,R.off)});}}
    else{for(let y=y0;y<=y1;y++)for(let mo=1;mo<=12;mo++){
      const P=monthEnd(y,mo);if(P>=trig)out.push({P,D:addD(P,R.off)});}}}
  else{for(let y=y0;y<=y1;y++)for(const md of R.dates){
    const D=mkd(y,md.mo,Math.min(md.dd,dim(y,md.mo)));
    if(R.lookback){const P=lastFyeBefore(D);if(P>=trig)out.push({P,D});}
    else if(D>=trig)out.push({P:null,D});}}
  out.sort((a,b)=>a.D-b.D);return out;}
// which occurrence does evidence dated Ev cover?
function mapEvidence(R,occ,Ev){
  if(R.kind==="single"||R.kind==="abs")return occ[0]||null;
  if(R.kind==="period"||(R.kind==="fixed"&&R.lookback)){
    let m=null;for(const o of occ){if(o.P<=Ev)m=o;else break;}return m;}
  for(const o of occ){if(o.D>=Ev)return o;}
  return null;}

// ---- per-row evaluation ----------------------------------------------------------------------
const seen={};const res=[];
let nNa=0,nWarn=0,nRev=0;
for(const r of rows){
  const id=String(r.id||"").trim();
  const key=(id+" "+String(r.obligation||"")+" "+String(r.agency||"")).toLowerCase();
  const fails=[];const warns=[];let overdueMsg=null;
  if(id==="")fails.push("empty id");
  else if(seen[id])fails.push("duplicate id");
  seen[id]=1;
  let applies=true;
  const aexpr=String(r.applies_if||"").trim();
  if(aexpr!==""){
    try{const v=evalExpr(aexpr);
      if(typeof v!=="boolean")throw new Error("applies_if must evaluate to a boolean");
      applies=v;}
    catch(e){fails.push("applies_if error (fails closed, row treated as applicable): "+e.message);applies=true;}}
  r._applies=applies;r._id=id;r._key=key;r._demote=null;
  if(!applies){nNa++;E("na "+id+": does not apply under profile (applies_if: "+aexpr+")");continue;}
  // per-row schema
  if(!String(r.source_url||"").trim())fails.push("missing source_url");
  const grade=String(r.source_grade||"").trim();
  if(!/^[ABCS]$/.test(grade))fails.push("source_grade must be A|B|C|S (got "+JSON.stringify(grade)+")");
  const von=pd(r.verified_on);
  if(!von)fails.push("verified_on must be YYYY-MM-DD");
  else if(days(von,today)>365){nRev++;
    E("RE-VERIFY "+id+": verified_on "+iso(von)+" is over 12 months old - statute rows expire (2018/2021/2024/2025/2026 all moved something); re-verify the source");}
  if(!/^(once|monthly|quarterly|annual|event)$/.test(String(r.cadence||"").trim()))
    fails.push("cadence must be once|monthly|quarterly|annual|event");
  const st=String(r.status||"").trim();
  if(!/^(na|pending|done|overdue)$/.test(st))fails.push("status must be na|pending|done|overdue");
  if(st==="na")fails.push("marked status=na but the row applies under the profile");
  const rps=String(r.requires_professional_signoff||"").trim().toLowerCase();
  let signreq=false;
  if(rps==="true"||rps==="yes"||rps==="1")signreq=true;
  else if(!(rps===""||rps==="false"||rps==="no"||rps==="0"))
    fails.push("requires_professional_signoff must be true|false");
  // deadline engine
  let R=null,occ=[],cur=null,nxt=null;
  const trig=(String(r.category||"").trim().toLowerCase()==="employer"&&hireDate)?hireDate:regDate;
  try{R=parseRule(r.deadline_rule);occ=occurrences(R,trig);
    for(const o of occ){if(o.D<=today)cur=o;else{nxt=o;break;}}}
  catch(e){R=null;fails.push("deadline_rule: "+e.message);}
  // evidence checks for done rows
  let ev=null,covered=null;
  if(st==="done"){
    const ep=String(r.evidence_path||"").trim();
    if(!ep)fails.push("status=done but evidence_path is empty");
    else{const full=path.resolve(regdir,ep);let s=null;
      try{s=fs.statSync(full);}catch(e){}
      if(!s||!s.isFile())fails.push("evidence_path does not resolve: "+ep);
      else if(s.size===0)fails.push("evidence file is empty: "+ep);
      else{const h=String(r.evidence_hash||"").trim().toLowerCase();
        if(!/^[0-9a-f]{16,64}$/.test(h))
          fails.push("evidence_hash must be 16-64 hex chars of the sha256 of the evidence file");
        else{const dig=crypto.createHash("sha256").update(fs.readFileSync(full)).digest("hex");
          if(dig.indexOf(h)!==0)fails.push("evidence_hash does not match sha256 of "+ep);}}}
    ev=pd(r.evidence_date);
    if(!ev)fails.push("status=done but evidence_date is not YYYY-MM-DD");
    else if(ev>today)fails.push("evidence_date "+iso(ev)+" is in the future");
    if(signreq){const sp=String(r.signoff_path||"").trim();
      if(!sp)fails.push("requires_professional_signoff=true but signoff_path is missing - a professional sign-off row never passes without the signed artefact; the loop may not self-certify");
      else{const full=path.resolve(regdir,sp);let s=null;
        try{s=fs.statSync(full);}catch(e){}
        if(!s||!s.isFile()||s.size===0)fails.push("signoff_path does not resolve: "+sp);}}
    if(grade==="S"&&!String(r.notes||"").trim())
      fails.push("source_grade=S (snippet-only source) may not be marked done without notes recording the human verification");}
  // timing
  let state="pass";
  if(fails.length)state="fail";
  else if(R){
    if(st==="done"){
      if(cur){covered=mapEvidence(R,occ,ev);
        if(!covered||covered.D<cur.D){state="overdue";
          overdueMsg="OVERDUE "+id+": due "+iso(cur.D)+" ("+days(cur.D,today)+" days late) - latest evidence "+iso(ev)+(covered?" covers the period due "+iso(covered.D):" predates the first owed period");}
        else if(ev<=covered.D){/* on time (early for a later period included) */}
        else if(/\blate\b/i.test(String(r.notes||""))){
          E("LATE "+id+": filed "+iso(ev)+" against deadline "+iso(covered.D)+" - counted because notes record the late settlement");}
        else{state="fail";
          fails.push("filed late: evidence "+iso(ev)+" is after the deadline "+iso(covered.D)+" - settle the penalty and record it in notes (keyword: late) for the row to count");}}
      else covered=mapEvidence(R,occ,ev);}
    else{
      if(cur&&cur.D<today){state="overdue";
        overdueMsg="OVERDUE "+id+": due "+iso(cur.D)+" ("+days(cur.D,today)+" days late, no evidence)";}}
    // T-30 / T-7 / T-0 warnings for the next uncovered deadline
    if(state==="pass"){let up=null;
      if(cur&&iso(cur.D)===iso(today)&&st!=="done"&&!(covered&&covered.D>=cur.D))up=cur;
      else if(nxt&&!(covered&&covered.D>=nxt.D))up=nxt;
      if(up){const n=days(today,up.D);
        if(n>=0&&n<=30){nWarn++;
          const b=(n===0)?"(T-0: due today)":(n<=7)?"(T-"+n+", inside the T-7 window)":"(T-"+n+", inside the T-30 window)";
          warns.push("WARN "+id+": next deadline "+iso(up.D)+" "+b);}}}}
  res.push({r,id,state,fails,warns,overdueMsg});
}

// ---- consistency rules C1–C6 (an inconsistency is an applicable-but-failed row) --------------
function anyApp(re){return rows.some(x=>x._applies&&re.test(x._key));}
function demote(re,msg){for(const x of rows)if(x._applies&&re.test(x._key)&&!x._demote)x._demote=msg;}
const extra=[];
if(vat){
  if(!anyApp(/2550q/))extra.push("[C1] vat_registered=true but no 2550Q (quarterly VAT return) row applies");
  demote(/2551q/,"[C1] 2551Q (percentage tax) applies while vat_registered=true - VAT and percentage tax are mutually exclusive");
}else{
  demote(/2550q/,"[C1] 2550Q applies while vat_registered=false");
  if(!eight&&!anyApp(/2551q/))extra.push("[C1] non-VAT profile without the 8 pct election but no 2551Q (percentage tax) row applies");
}
if(eight){
  demote(/2551q/,"[C2] 2551Q applies while eight_pct_elected=true - the 8 pct option is in lieu of Sec. 116 percentage tax");
  if(vat)extra.push("[C2] eight_pct_elected=true with vat_registered=true - the 8 pct option is closed to VAT-registered taxpayers");
  if(profile.entity_type!=="sole_prop")extra.push("[C2] eight_pct_elected=true but entity_type="+profile.entity_type+" - the 8 pct option is for individuals only (RMO 23-2018)");
}
if(hasEmp){
  const need=[["SSS",/\bsss\b/],["PhilHealth",/philhealth/],["Pag-IBIG",/pag-?ibig|hdmf/],
              ["13th-month",/13th/],["OSH",/\bosh\b|11058/]];
  for(const nr of need)if(!anyApp(nr[1]))extra.push("[C3] has_employees=true but no "+nr[0]+" row applies");
  if(!hireDate)extra.push("[C3] has_employees=true but first_hire_date is not set in the profile");
}
if(profile.entity_type==="corp"||profile.entity_type==="opc"){
  if(!anyApp(/\bsec\b|\bgis\b|\bafs\b/))extra.push("[C4] entity_type="+profile.entity_type+" but no SEC row applies");
}
if(gross>3000000){
  if(!anyApp(/audit/))extra.push("[C5] gross_sales_12m > 3,000,000 but no audit row applies (Sec. 232)");
  if(!vat)extra.push("[C5] gross_sales_12m > 3,000,000 but vat_registered=false - VAT registration is mandatory past the threshold (Sec. 236(G))");
}
if(online&&!anyApp(/\bita\b|internet transactions|e-?commerce|online business/))
  extra.push("[C6] sells_online=true but no Internet Transactions Act row applies (RA 11967)");

// ---- print + tally ---------------------------------------------------------------------------
let x=0,yApp=0,nFail=0,nOver=0,nDem=0;
for(const q of res){
  yApp++;
  if(q.state==="pass"&&q.r._demote){q.state="fail";q.fails.push(q.r._demote);nDem++;}
  else if(q.r._demote)q.fails.push(q.r._demote);
  if(q.state==="fail"){nFail++;for(const f of q.fails)E("FAIL "+q.id+": "+f);}
  else if(q.state==="overdue"){nOver++;E(q.overdueMsg);}
  else{x++;for(const w of q.warns)E(w);}
}
for(const m of extra)E("FAIL register: "+m+" - counted as an applicable-but-failed row");
const y=yApp+extra.length;
E("today="+iso(today)+" applicable="+yApp+" pass="+x+" fail="+nFail+" overdue="+nOver+
  " na="+nNa+" consistency_row="+nDem+" consistency_missing="+extra.length+
  " warnings="+nWarn+" reverify="+nRev);
process.stdout.write("COMPLIANCE: "+x+"/"+y+"\n");
process.exit(0);
' "$tmpd/register.json" "$tmpd/profile.json" "$regdir" "$today"
  local rc=$?
  rm -rf "$tmpd"
  return $rc
}
