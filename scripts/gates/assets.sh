#!/usr/bin/env bash
# gate: assets — marketing/sales asset lint over an asset directory + registry.
#   score-guild.sh assets <dir> <claims.tsv> <icp.yaml>   → "ASSET_LINT: N"
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing dir/registry/
#   claims/icp)
#
# <dir>/assets.csv registry columns:
#   asset_id type version path icp_id offer_id price_ref claims_ref release_form_on_file
#   [price_on_request] [last_reviewed]
#   type ∈ landing|one_pager|deck|case_study|pricing|email_seq|listing · path relative to <dir>
#
# Inline marker conventions (documented in references/marketing-protocol.md §6):
#   [CTA]                               — conversion-goal marker; a landing page carries EXACTLY one
#                                         (HTML assets may use a <cta> element instead)
#   [ev:C-n]                            — sources a numeric claim against claims.tsv
#   [price:<price-book-ref>]            — sources a price line (own prices cite the price book,
#                                         not the claims ledger)
#   [vs: <comparator>]                  — names the comparator for comparative copy
#   [evidence: third-party, YYYY-MM-DD, <src>] — ASC substantiation marker for superlatives;
#                                         must be independent and ≤ 12 months old
#
# Lint (contract: references/metrics.md; the citation regexes mirror scripts/gates/citations.sh):
#   placeholders   \[TBD\] | lorem | XX% | {{ | INSERT | TODO | ???  ⇒ violation per line
#   icp/offer      icp_id must resolve in icp.yaml (top-level segment_id / id / icp_id keys);
#                  offer_id + price_ref required (price_on_request=Y is the explicit exemption)
#   numbers        every numeric claim (%, x, currency, thousands groups, 5+ digits; years
#                  ignored; headings and fenced code skipped) needs a resolving [ev:C-n]
#                  (or [price:…] for own prices) in the same unit
#   superlatives   best | #1 | No. 1 | most preferred/recommended | only | fastest | leading |
#                  guaranteed ⇒ need an [evidence: third-party, YYYY-MM-DD, …] marker ≤ 12 months
#   comparatives   than | vs | versus | faster | cheaper | better | … ⇒ need [vs: <comparator>]
#   landing        exactly one CTA marker
#   case_study     the 10 HubSpot components as headings + release_form_on_file=Y
#   pricing        currency + unit + inclusions + VAT note present
#   email_seq      unsubscribe line + List-Unsubscribe header + consent_source: line
#   listing        merchant name + address + contact (ITA) + return/refund + warranty policy
#   reading grade  Flesch-Kincaid estimate > 9 ⇒ warn (grade 5–7 copy converts ~2× — Unbounce)
#
# Policy env: GUILD_ASC_FRESH_DAYS=365 (ASC substantiation validity) ·
#   GUILD_READING_GRADE_WARN=9

gate_assets() {
  local dir="${1:?usage: assets <dir> <claims.tsv> <icp.yaml>}"
  local claims="${2:?usage: assets <dir> <claims.tsv> <icp.yaml>}"
  local icp="${3:?usage: assets <dir> <claims.tsv> <icp.yaml>}"
  [[ -d "$dir" ]] || { echo "score-guild: assets: missing dir $dir" >&2; return 2; }
  local reg="$dir/assets.csv"
  [[ -f "$reg" ]] || { echo "score-guild: assets: missing registry $reg" >&2; return 2; }
  [[ -f "$claims" ]] || { echo "score-guild: assets: missing claims $claims" >&2; return 2; }
  [[ -f "$icp" ]] || { echo "score-guild: assets: missing icp $icp" >&2; return 2; }
  local today rj
  today="$(guild_today "$reg")"
  rj="$(guild_csv_json "$reg")" || { echo "score-guild: assets: cannot parse $reg" >&2; return 2; }
  local js
  js="$(cat <<'NODE'
let raw="";process.stdin.on("data",c=>raw+=c);process.stdin.on("end",()=>{try{main(JSON.parse(raw));}catch(e){console.error("assets: "+e.message);process.exit(2);}});
function main(rowsIn){
const fs=require("fs"),path=require("path");
const A=process.argv.slice(1);
const dir=A[0],claimsPath=A[1],icpPath=A[2],today=A[3],FRESH=+A[4],GRADE=+A[5];
const rows=rowsIn||[];
const D=s=>{const m=/(20\d\d-\d\d-\d\d)/.exec(String(s||""));if(!m)return null;const d=new Date(m[1]+"T00:00:00Z");return isNaN(d)?null:d;};
const days=(a,b)=>Math.round((b-a)/864e5);
const T=D(today);
const yes=v=>/^(y|yes|true|1)$/i.test(String(v||"").trim());
let n=0;
const V=(id,rule,msg)=>{n++;console.error("violation "+id+" ["+rule+"]: "+msg);};
const W=(id,rule,msg)=>console.error("warn "+id+" ["+rule+"]: "+msg);
// claims ledger -> C-id set
const claimIds=new Set();
for(const line of fs.readFileSync(claimsPath,"utf8").split(/\r?\n/)){
  const c=line.split("\t")[0];
  if(/^C-\d+$/.test((c||"").trim()))claimIds.add(c.trim());
}
// icp.yaml -> id set (top-level / nested segment_id | icp_id | id keys, regex over lines)
const icpIds=new Set();
for(const line of fs.readFileSync(icpPath,"utf8").split(/\r?\n/)){
  const m=line.match(/^\s*-?\s*(segment_id|icp_id|id):\s*["']?([^"'#\r\n]+?)["']?\s*(#.*)?$/);
  if(m)icpIds.add(m[2].trim());
}
const TYPES=["landing","one_pager","deck","case_study","pricing","email_seq","listing"];
function countClaims(s){
  s=s.replace(/(^|[^0-9])(1[89]|20)[0-9][0-9](?=[^0-9]|$)/g,"$1 ");
  let c=0;
  c+=(s.match(/[0-9]+(\.[0-9]+)?[ ]?%/g)||[]).length;s=s.replace(/[0-9]+(\.[0-9]+)?[ ]?%/g," ");
  c+=(s.match(/[0-9]+(\.[0-9]+)?[ ]?[xX×](?=[^A-Za-z0-9]|$)/g)||[]).length;s=s.replace(/[0-9]+(\.[0-9]+)?[ ]?[xX×](?=[^A-Za-z0-9]|$)/g," ");
  c+=(s.match(/(₱|\$|PHP|USD|EUR)[ ]?[0-9][0-9,]*(\.[0-9]+)?/g)||[]).length;s=s.replace(/(₱|\$|PHP|USD|EUR)[ ]?[0-9][0-9,]*(\.[0-9]+)?/g," ");
  c+=(s.match(/[0-9]{1,3}(,[0-9]{3})+/g)||[]).length;s=s.replace(/[0-9]{1,3}(,[0-9]{3})+/g," ");
  c+=(s.match(/[0-9]{5,}/g)||[]).length;
  return c;
}
function units(text){
  const out=[];const lines=text.split("\n");
  let cur="",start=0,fence=false;
  const flush=()=>{if(cur.trim())out.push({t:cur,l:start});cur="";};
  for(let i=0;i<lines.length;i++){
    const L=lines[i];
    if(/^```/.test(L)){flush();fence=!fence;continue;}
    if(fence)continue;
    if(/^#/.test(L)){flush();continue;}
    if(/^\s*$/.test(L)){flush();continue;}
    if(/^\s*\|/.test(L)){flush();out.push({t:L,l:i+1});continue;}
    if(/^\s*([-*+]|[0-9]+\.)\s/.test(L)){flush();cur=L;start=i+1;continue;}
    if(!cur)start=i+1;
    cur+=(cur?" ":"")+L;
  }
  flush();return out;
}
function fkGrade(text){
  const prose=text.replace(/\[[^\]]*\]/g," ").replace(/https?:\S+/g," ").replace(/[#*_|`>]/g," ");
  const sents=prose.split(/[.!?]+\s/).filter(s=>(s.match(/[A-Za-z]+/g)||[]).length>2);
  const words=prose.match(/[A-Za-z]+/g)||[];
  if(!sents.length||words.length<40)return 0;
  let syl=0;
  for(const w of words){const m=w.toLowerCase().replace(/e$/,"").match(/[aeiouy]+/g);syl+=Math.max(1,(m||[]).length);}
  return 0.39*(words.length/sents.length)+11.8*(syl/words.length)-15.59;
}
const SUP=/(^|[^\w])(best|#\s?1|no\.?\s?1|most preferred|most recommended|only|fastest|leading|guaranteed)($|[^\w])/gi;
const CMP=/(^|[^\w])(than|vs\.?|versus|faster|cheaper|quicker|slower|better|stronger|fewer|lower|higher|more accurate|more reliable|safer|longer)($|[^\w])/i;
const EVMARK=/\[evidence:\s*(third.?party|independent)[^\]]*?(20\d\d-\d\d-\d\d)[^\]]*\]/i;
const seen=new Set();
for(let i=0;i<rows.length;i++){
  const r=rows[i];const id=r.asset_id||("row"+(i+2));
  if(seen.has(id))V(id,"DUP","duplicate asset_id");
  seen.add(id);
  const type=String(r.type||"").trim();
  if(!TYPES.includes(type))V(id,"TYPE",'type "'+r.type+'" not in '+TYPES.join("|"));
  if(!icpIds.has(String(r.icp_id||"").trim()))V(id,"ICP",'icp_id "'+(r.icp_id||"")+'" does not resolve in '+icpPath+" (ids: "+([...icpIds].join(",")||"none")+")");
  if(!String(r.offer_id||"").trim())V(id,"OFFER","offer_id empty — every asset sells a specific offer");
  if(!String(r.price_ref||"").trim()&&!yes(r.price_on_request))V(id,"PRICE","price_ref empty and price_on_request not set — reference the price book or flag on-request explicitly");
  const lr=D(r.last_reviewed);
  if(!lr)W(id,"REVIEW","no last_reviewed date");
  else if(days(lr,T)>FRESH)W(id,"REVIEW","last_reviewed "+r.last_reviewed+" is "+days(lr,T)+" d old (> "+FRESH+") — ASC substantiation expires after 12 months");
  const rel=String(r.path||"").trim();
  const fp=rel?path.join(dir,rel):"";
  if(!rel||!fs.existsSync(fp)){V(id,"FILE",'asset file "'+rel+'" not found under '+dir);continue;}
  const text=fs.readFileSync(fp,"utf8").replace(/\r\n?/g,"\n");
  const lines=text.split("\n");
  // placeholders (any line, incl. headings/code — a placeholder is a placeholder)
  const PH1=/\[TBD\]|XX%|\{\{|\bINSERT\b|\bTODO\b|\?\?\?/;
  const PH2=/\blorem\b|\[tbd\]/i;
  lines.forEach((L,k)=>{
    const hits=[];
    const m1=L.match(new RegExp(PH1.source,"g"));if(m1)hits.push(...m1);
    const m2=L.match(new RegExp(PH2.source,"gi"));if(m2)hits.push(...m2);
    if(hits.length)V(id,"PLACEHOLDER",rel+" line "+(k+1)+": placeholder "+[...new Set(hits)].join(" "));
  });
  // unit-level lint
  for(const u of units(text)){
    const cl=countClaims(u.t);
    let sourced=false;
    let m;const evre=/\[ev:(C-\d+)\]/g;
    while((m=evre.exec(u.t))){
      if(claimIds.has(m[1]))sourced=true;
      else V(id,"EV-ORPHAN",rel+" line "+u.l+": orphan token [ev:"+m[1]+"] (not in claims ledger)");
    }
    if(/\[price:[^\]]+\]/.test(u.t))sourced=true;
    if(cl>0&&!sourced)V(id,"NUMBER",rel+" line "+u.l+": "+cl+" numeric claim(s) without a resolving [ev:C-n]: \""+u.t.slice(0,90)+"\"");
    const sups=[];let sm;const supre=new RegExp(SUP.source,"gi");
    while((sm=supre.exec(u.t)))sups.push(sm[2]);
    if(sups.length){
      const ev=u.t.match(EVMARK);
      if(!ev)V(id,"SUPERLATIVE",rel+" line "+u.l+": superlative \""+sups.join('", "')+"\" without independent third-party substantiation ≤ 12 months (ASC) — add [evidence: third-party, YYYY-MM-DD, source]");
      else{const ed=D(ev[2]);if(ed&&days(ed,T)>FRESH)V(id,"SUPERLATIVE",rel+" line "+u.l+": substantiation dated "+ev[2]+" is "+days(ed,T)+" d old (> "+FRESH+" d) — ASC substantiation expires after 12 months");}
    }
    const cm=u.t.match(CMP);
    if(cm&&!/\[vs:[^\]]+\]/.test(u.t))V(id,"COMPARATIVE",rel+" line "+u.l+": comparative \""+cm[2]+"\" without a named comparator — add [vs: <comparator>] (ASC: comparatives identify the comparison)");
  }
  // type-specific
  if(type==="landing"){
    const cta=(text.match(/\[CTA\]/g)||[]).length+(text.match(/<cta\b/gi)||[]).length;
    if(cta!==1)V(id,"CTA",rel+": cta_count="+cta+" — a landing page has exactly one conversion goal (one [CTA] marker)");
    if(!/^# /m.test(text))W(id,"LANDING",rel+": no H1 / USP headline");
    if(!/(proof|testimonial|client|customer|reference)/i.test(text))W(id,"LANDING",rel+": no social-proof block");
  }
  if(type==="case_study"){
    const comps=[
      ["title",/^# ./m],
      ["subtitle",/^(Subtitle:\s*\S.*|_[^_\n]+_|\*[^*\n]+\*)\s*$/m],
      ["executive summary",/^#{2,3}\s*(executive summary|summary)/im],
      ["about the customer",/^#{2,3}\s*about/im],
      ["challenges",/^#{2,3}\s*challenge/im],
      ["solution",/^#{2,3}\s*solution/im],
      ["results",/^#{2,3}\s*results/im],
      ["quotes/visuals",/^#{2,3}\s*(quote|testimonial|visual)/im],
      ["future plans",/^#{2,3}\s*(future|next steps|what.s next)/im],
      ["call to action",/^#{2,3}\s*(call to action|cta)|\[CTA\]/im]
    ];
    for(const[nm,re]of comps)if(!re.test(text))V(id,"CASE-STUDY",rel+": missing component: "+nm+" (HubSpot 10-part structure)");
    if(!yes(r.release_form_on_file))V(id,"RELEASE",'release_form_on_file="'+(r.release_form_on_file||"")+'" — a case study publishes a client\'s data; a signed release form must be on file');
  }
  if(type==="pricing"){
    if(!/[₱$]|\bPHP\b|\bUSD\b/.test(text))V(id,"PRICING",rel+": no currency on the pricing page");
    if(!/\bper\s+\w+|\/\s?(mo|month|project|seat|user|device|unit|hour|day|sprint)\b/i.test(text))V(id,"PRICING",rel+": no unit (per project / per month / per seat …)");
    if(!/includ|inclusion/i.test(text))V(id,"PRICING",rel+": no inclusions listed");
    if(!/\bVAT\b/i.test(text))V(id,"PRICING",rel+": no VAT note (ex-VAT / VAT-inclusive; EWT expectation)");
  }
  if(type==="email_seq"){
    if(!/unsubscribe/i.test(text))V(id,"EMAIL",rel+": no unsubscribe line in the body");
    if(!/List-Unsubscribe/.test(text))V(id,"EMAIL",rel+": no List-Unsubscribe header (RFC 8058 one-click — Gmail bulk-sender rule)");
    if(!/consent_source\s*:/i.test(text))V(id,"EMAIL",rel+": no consent_source: line naming where the opt-in lives");
  }
  if(type==="listing"){
    if(!/(merchant|seller|sold by)/i.test(text))V(id,"LISTING",rel+": no merchant/seller name (ITA merchant disclosure)");
    if(!/address/i.test(text))V(id,"LISTING",rel+": no business address (ITA merchant disclosure)");
    if(!/(contact|e-?mail|phone|tel\b)/i.test(text))V(id,"LISTING",rel+": no contact details (ITA merchant disclosure)");
    if(!/(return|refund)/i.test(text))V(id,"LISTING",rel+": no return/refund policy");
    if(!/warrant/i.test(text))V(id,"LISTING",rel+": no warranty policy");
  }
  const g=fkGrade(text);
  if(g>GRADE)W(id,"READING",rel+": estimated reading grade "+g.toFixed(1)+" > "+GRADE+" — grade 5–7 copy converts ~2x (Unbounce)");
}
console.error("assets: rows="+rows.length+" icp_ids="+[...icpIds].join(",")+" claim_ids="+claimIds.size);
console.log("ASSET_LINT: "+n);
}
NODE
)"
  printf '%s' "$rj" | node -e "$js" "$dir" "$claims" "$icp" "$today" \
    "${GUILD_ASC_FRESH_DAYS:-365}" "${GUILD_READING_GRADE_WARN:-9}"
}
