#!/usr/bin/env bash
# gate: positioning — Dunford-canvas + Moore-statement lint with referential integrity to the
# alternatives ledger and the elected ICP.
#   score-guild.sh positioning <positioning.yaml> <alternatives.csv> <icp.yaml>
#     → "POSITIONING_VIOLATIONS: N"   (each violation → stderr "rule <name>: …"; warnings "warn <name>: …")
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing / unparsable file)
#
# positioning.yaml (offer/positioning.yaml, loop-written; full layout: references/offer-protocol.md §9)
#   version · date
#   statement: {target, target_text?, need, product, category, benefit, primary_alternative, differentiator}
#     target = the elected ICP id (segment_id / id / icp_id in icp.yaml); target_text = the rendered
#     phrase; benefit / differentiator / primary_alternative may hold an id (T-n / A-n / ALT-n) or
#     the verbatim theme statement / attribute text / alternative name
#   attributes:        [{id: A-n, text, lacking_alt_ids: [ALT-n …]}]
#   value_themes:      [{id: T-n, statement, attr_ids: [], pain_gain_ids: [], proof_ids: []}]
#   category_decision: {style: head_to_head|big_fish_small_pond|create_new_game, category, education_budget_php}
#   trend
#   messaging:         {value_statement, pillars: [{name, capability, benefit, theme_id, proof_ids: []}]}
# alternatives.csv (market/alternatives.csv): alt_id, name, type, … — only alt_id + name are read
# icp.yaml (offer/icp.yaml): top-level segment_id | id | icp_id (grep fallback when not parsable)
#
# Checks (brief 03 §5 G3.2 / G3.4 / G3.5): six Moore slots + product non-empty · target ∈ ICP ids ·
# primary_alternative ∈ alternatives (no phantom competitors) · differentiator → attribute id/text ·
# benefit → value-theme id/statement · every attribute lacks ≥ 1 real alternative · 2–4 themes
# each with ≥ 1 attr_id, pain_gain_id, proof_id · rendered statement ≤ 75 words (the 9 Moore
# template words count), slot ≤ 25 · banned adjectives in product / benefit / differentiator ·
# style ∈ the three Dunford styles, create_new_game ⇒ education_budget_php > 0 ·
# statement.category = category_decision.category · trend present and not used as the benefit ·
# exactly one value_statement · 3–5 pillars each with an existing theme_id and ≥ 1 proof_id.
#
# Policy (env-overridable; research default in brackets):
#   GUILD_POS_MAX_WORDS        [75]  whole statement, Moore template words included
#   GUILD_POS_MAX_SLOT_WORDS   [25]  per slot
#   GUILD_POS_THEMES_MIN/_MAX  [2/4] value themes (Dunford; Userlist landed on 3)
#   GUILD_POS_PILLARS_MIN/_MAX [3/5] messaging pillars (Aha! hierarchy)
#   GUILD_POS_BANNED           [simple|affordable|cheap|quality|innovative|best] non-defensible adjectives
#   GUILD_POS_STALE_DAYS       [90]  version older than this → warn (pitch tests must cite a live version)
# Contract: references/offer-protocol.md §9, §19; references/metrics.md.

_pos_num() { if [[ "${1:-}" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then printf '%s' "$1"; else printf '%s' "$2"; fi; }

gate_positioning() {
  local pos="${1:?usage: positioning <positioning.yaml> <alternatives.csv> <icp.yaml>}"
  local alts="${2:?usage: positioning <positioning.yaml> <alternatives.csv> <icp.yaml>}"
  local icp="${3:?usage: positioning <positioning.yaml> <alternatives.csv> <icp.yaml>}"
  local f
  for f in "$pos" "$alts" "$icp"; do
    [[ -f "$f" ]] || { echo "score-guild: positioning: missing $f" >&2; return 2; }
  done
  local pj aj ij today cfg
  pj="$(guild_yaml_json "$pos")" || { echo "score-guild: positioning: cannot parse $pos" >&2; return 2; }
  aj="$(guild_csv_json "$alts")" || { echo "score-guild: positioning: cannot parse $alts" >&2; return 2; }
  ij="$(guild_yaml_json "$icp" 2>/dev/null)" || ij='{}'
  today="$(guild_today "$pos")"
  cfg="$(printf '{"maxWords":%s,"maxSlot":%s,"themesMin":%s,"themesMax":%s,"pillarsMin":%s,"pillarsMax":%s,"staleDays":%s,"templateWords":9,"banned":"%s"}' \
    "$(_pos_num "${GUILD_POS_MAX_WORDS:-}" 75)" "$(_pos_num "${GUILD_POS_MAX_SLOT_WORDS:-}" 25)" \
    "$(_pos_num "${GUILD_POS_THEMES_MIN:-}" 2)" "$(_pos_num "${GUILD_POS_THEMES_MAX:-}" 4)" \
    "$(_pos_num "${GUILD_POS_PILLARS_MIN:-}" 3)" "$(_pos_num "${GUILD_POS_PILLARS_MAX:-}" 5)" \
    "$(_pos_num "${GUILD_POS_STALE_DAYS:-}" 90)" \
    "${GUILD_POS_BANNED:-simple|affordable|cheap|quality|innovative|best}")"
  printf '{"pos":%s,"alts":%s,"icp":%s,"cfg":%s,"today":"%s"}' "$pj" "$aj" "$ij" "$cfg" "$today" | node -e '
const fs=require("fs");
const inp=JSON.parse(fs.readFileSync(0,"utf8"));
const P=inp.pos&&typeof inp.pos==="object"&&!Array.isArray(inp.pos)?inp.pos:{};
const ALTS=Array.isArray(inp.alts)?inp.alts:[];
const ICP=inp.icp&&typeof inp.icp==="object"?inp.icp:{};
const C=inp.cfg, today=inp.today;
let icpRaw=""; try{icpRaw=fs.readFileSync(process.argv[1],"utf8");}catch(e){}
let V=0,W=0;
const fail=(r,m)=>{V++;console.error("rule "+r+": "+m);};
const warn=(r,m)=>{W++;console.error("warn "+r+": "+m);};
const s=x=>x==null?"":String(x).trim();
const norm=x=>s(x).toLowerCase().replace(/[“”"]/g,"").replace(/\s+/g," ").replace(/[.\s]+$/,"").trim();
const words=x=>{const t=s(x);return t===""?0:t.split(/\s+/).length;};
const arr=x=>Array.isArray(x)?x.filter(e=>e!=null&&s(e)!==""):(x==null||s(x)===""?[]:[x]);
const esc=x=>x.replace(/[.*+?^${}()|[\]\\]/g,"\\$&");
const hasTok=(text,id)=>id!==""&&new RegExp("(^|[^A-Za-z0-9_-])"+esc(id)+"($|[^A-Za-z0-9_-])","i").test(s(text));
const days=(a,b)=>{const x=new Date(a+"T00:00:00Z"),y=new Date(b+"T00:00:00Z");return(isNaN(x)||isNaN(y))?NaN:Math.round((y-x)/86400000);};

// ---- statement slots --------------------------------------------------------------------------
const ST=P.statement&&typeof P.statement==="object"&&!Array.isArray(P.statement)?P.statement:null;
if(!ST)fail("statement","no statement: block — For (target) who (need), the (product) is a (category) that (benefit). Unlike (primary_alternative), our product (differentiator)");
const slots=["target","need","product","category","benefit","primary_alternative","differentiator"];
const slot={};
for(const k of slots){slot[k]=ST?s(ST[k]):"";if(slot[k]==="")fail("statement."+k,"slot is empty");}

// ---- target ⊆ ICP ------------------------------------------------------------------------------
const icpIds=new Set();
for(const k of ["segment_id","id","icp_id"])if(s(ICP[k])!=="")icpIds.add(norm(ICP[k]));
for(const k of ["segment","icp"])if(ICP[k]&&typeof ICP[k]==="object")for(const kk of ["segment_id","id","icp_id"])if(s(ICP[k][kk])!=="")icpIds.add(norm(ICP[k][kk]));
for(const m of icpRaw.matchAll(/^\s*(segment_id|id|icp_id):\s*([^#\r\n]+)/gm))icpIds.add(norm(m[2].replace(/^["\x27]|["\x27]$/g,"")));
if(icpIds.size===0)fail("icp","no segment_id / id / icp_id in icp.yaml — the ICP election is recorded before positioning");
if(slot.target!==""){const t=norm(slot.target);const ok=icpIds.has(t)||[...icpIds].some(id=>hasTok(t,id));
 if(!ok)fail("statement.target",`"${slot.target}" does not resolve to an ICP id (${[...icpIds].join(", ")||"none"}) — target ⊆ elected ICP segment`);}

// ---- primary_alternative ∈ alternatives (no phantoms) --------------------------------------------
const altIds=new Map(), altNames=new Map();
for(const r of ALTS){const id=s(r.alt_id),nm=s(r.name);if(id==="")continue;altIds.set(norm(id),nm);if(nm!=="")altNames.set(norm(nm),id);}
if(altIds.size===0)fail("alternatives","alternatives.csv has no alt_id rows");
let paName="";
if(slot.primary_alternative!==""){const pa=norm(slot.primary_alternative);let hit=null;
 if(altIds.has(pa))hit=pa;else if(altNames.has(pa))hit=norm(altNames.get(pa));else{for(const id of altIds.keys())if(hasTok(pa,id)){hit=id;break;}}
 if(hit===null)fail("statement.primary_alternative",`"${slot.primary_alternative}" is not in alternatives.csv (${[...altIds.keys()].join(", ")}) — a phantom competitor; the status quo is an alternative, an unmet rival is not`);
 else paName=altIds.get(hit)||slot.primary_alternative;}

// ---- attributes → differentiator ---------------------------------------------------------------
const attrs=arr(P.attributes).filter(a=>a&&typeof a==="object");
const attrById=new Map(), attrByText=new Map();
if(attrs.length===0)fail("attributes","no attributes: list — unique attributes are what the alternatives lack");
attrs.forEach((a,i)=>{const id=s(a.id),tx=s(a.text),lab=id||("#"+(i+1));
 if(id==="")fail("attributes."+lab,"missing id (A-n)");else if(attrById.has(norm(id)))fail("attributes."+lab,"duplicate id");else attrById.set(norm(id),tx);
 if(tx==="")fail("attributes."+lab,"missing text");else attrByText.set(norm(tx),id);
 const lack=arr(a.lacking_alt_ids);
 if(lack.length===0)fail("attributes."+lab,"lacking_alt_ids is empty — an attribute every alternative also has is not unique");
 for(const l of lack)if(!altIds.has(norm(l)))fail("attributes."+lab,`lacking_alt_id "${l}" not in alternatives.csv`);});
let diffText="";
if(slot.differentiator!==""){const d=norm(slot.differentiator);let hit=null;
 if(attrById.has(d))hit=attrById.get(d)||slot.differentiator;else if(attrByText.has(d))hit=slot.differentiator;
 else{for(const [id,tx] of attrById)if(hasTok(d,id)){hit=tx||slot.differentiator;break;}}
 if(hit===null)fail("statement.differentiator",`"${slot.differentiator}" names no attribute id or attribute text in attributes:`);else diffText=hit;}

// ---- value themes → benefit -------------------------------------------------------------------
const themes=arr(P.value_themes).filter(t=>t&&typeof t==="object");
const themeById=new Map(), themeByText=new Map();
if(themes.length<C.themesMin||themes.length>C.themesMax)fail("value_themes",`${themes.length} theme(s); need ${C.themesMin}–${C.themesMax} (Dunford; Userlist landed on 3)`);
themes.forEach((t,i)=>{const id=s(t.id),tx=s(t.statement),lab=id||("#"+(i+1));
 if(id==="")fail("value_themes."+lab,"missing id (T-n)");else if(themeById.has(norm(id)))fail("value_themes."+lab,"duplicate id");else themeById.set(norm(id),tx);
 if(tx==="")fail("value_themes."+lab,"missing statement");else themeByText.set(norm(tx),id);
 const at=arr(t.attr_ids),pg=arr(t.pain_gain_ids),pr=arr(t.proof_ids);
 if(at.length===0)fail("value_themes."+lab,"no attr_ids — a value theme rests on ≥ 1 unique attribute");
 for(const a of at)if(!attrById.has(norm(a)))fail("value_themes."+lab,`attr_id "${a}" not in attributes:`);
 if(pg.length===0)fail("value_themes."+lab,"no pain_gain_ids — every theme relieves a ranked pain or creates a ranked gain (VPC)");
 if(pr.length===0)fail("value_themes."+lab,"no proof_ids — a theme without proof is a slogan");});
let benText="";
if(slot.benefit!==""){const b=norm(slot.benefit);let hit=null;
 if(themeById.has(b))hit=themeById.get(b)||slot.benefit;else if(themeByText.has(b))hit=slot.benefit;
 else{for(const [id,tx] of themeById)if(hasTok(b,id)){hit=tx||slot.benefit;break;}}
 if(hit===null)fail("statement.benefit",`"${slot.benefit}" names no value-theme id or statement in value_themes:`);else benText=hit;}

// ---- rendered statement: length + banned adjectives ----------------------------------------------
const R={target:s(ST&&ST.target_text)||slot.target,need:slot.need,product:slot.product,category:slot.category,
 benefit:benText||slot.benefit,primary_alternative:paName||slot.primary_alternative,differentiator:diffText||slot.differentiator};
let total=C.templateWords;
for(const k of slots){const n=words(R[k]);total+=n;if(n>C.maxSlot)fail("statement."+k+".length",`${n} words > ${C.maxSlot} per slot`);}
if(total>C.maxWords)fail("statement.length",`${total} words (incl. ${C.templateWords} template words) > ${C.maxWords} words`);
console.error(`statement (${total} words): For ${R.target} who ${R.need}, the ${R.product} is a ${R.category} that ${R.benefit}. Unlike ${R.primary_alternative}, our product ${R.differentiator}.`);
const banned=new RegExp("\\b("+C.banned+")\\b","gi");
for(const k of ["product","benefit","differentiator"]){const hits=s(R[k]).match(banned)||[];
 if(hits.length)fail("statement."+k+".banned",`banned adjective(s) ${[...new Set(hits.map(h=>h.toLowerCase()))].join(", ")} — non-defensible; reframe as a feature the alternatives lack`);}

// ---- category decision --------------------------------------------------------------------------
const CD=P.category_decision&&typeof P.category_decision==="object"?P.category_decision:null;
const styles=["head_to_head","big_fish_small_pond","create_new_game"];
if(!CD)fail("category_decision","no category_decision: block (style, category, education_budget_php)");
else{const st=norm(CD.style).replace(/[\s-]+/g,"_");
 if(!styles.includes(st))fail("category_decision.style",`"${s(CD.style)}" is not one of ${styles.join("|")}`);
 if(s(CD.category)==="")fail("category_decision.category","empty");
 else if(slot.category!==""&&norm(CD.category)!==norm(slot.category))fail("category_decision.category",`"${s(CD.category)}" ≠ statement.category "${slot.category}"`);
 if(st==="create_new_game"){const b=Number(CD.education_budget_php);
  if(!(b>0))fail("category_decision.education_budget_php","create_new_game needs a market-education budget > 0 (Dunford: 90 % of recent tech IPOs were positioned in existing markets)");}}

// ---- trend ------------------------------------------------------------------------------------
const trend=s(P.trend);
if(trend==="")warn("trend","canvas field 6 (relevant trend) is empty");
else if(benText!==""&&norm(trend)===norm(benText))fail("trend","trend is used as the benefit — a trend supports value, it is not the value");

// ---- messaging hierarchy ------------------------------------------------------------------------
const M=P.messaging&&typeof P.messaging==="object"?P.messaging:null;
if(!M)fail("messaging","no messaging: block (value_statement + pillars)");
else{const vs=M.value_statement;
 if(Array.isArray(vs))fail("messaging.value_statement",`${vs.length} value statements; exactly one`);
 else if(s(vs)==="")fail("messaging.value_statement","empty; exactly one value statement");
 const pil=arr(M.pillars).filter(p=>p&&typeof p==="object");
 if(pil.length<C.pillarsMin||pil.length>C.pillarsMax)fail("messaging.pillars",`${pil.length} pillar(s); need ${C.pillarsMin}–${C.pillarsMax}`);
 pil.forEach((p,i)=>{const lab=s(p.name)||("#"+(i+1));
  if(s(p.name)==="")fail("messaging.pillars.#"+(i+1),"missing name");
  const th=s(p.theme_id);
  if(th==="")fail("messaging.pillars."+lab,"missing theme_id");else if(!themeById.has(norm(th)))fail("messaging.pillars."+lab,`theme_id "${th}" not in value_themes:`);
  if(arr(p.proof_ids).length===0)fail("messaging.pillars."+lab,"no proof_ids — a pillar without proof is a slogan");
  if(s(p.capability)===""||s(p.benefit)==="")warn("messaging.pillars."+lab,"capability or benefit is empty");});}

// ---- version staleness --------------------------------------------------------------------------
const d=s(P.date);
if(d===""||isNaN(days(d,today)))warn("date","no date: on this positioning version");
else if(days(d,today)>C.staleDays)warn("date",`version dated ${d} is ${days(d,today)} d old (> ${C.staleDays}); pitch tests must cite a live version`);
console.error(`violations=${V} warnings=${W} themes=${themes.length} attributes=${attrs.length} alternatives=${altIds.size} icp_ids=${icpIds.size}`);
console.log("POSITIONING_VIOLATIONS: "+V);
' "$icp"
}
