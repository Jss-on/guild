#!/usr/bin/env bash
# gate: offers — offer-ladder structure lint: paid discovery, Good-Better-Best fences, bundling,
# guarantees, whole product, PH first-engagement terms and tax note.
#   score-guild.sh offers <offers.yaml>   → "OFFER_VIOLATIONS: N"
#     (each violation → stderr "rule <offer>.<field>: …"; warnings "warn …")
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing / unparsable file)
#
# offers.yaml (offer/offers.yaml, loop-written; full layout: references/offer-protocol.md §11):
#   offers:
#     - id · name · tier: discovery|good|better|best|pilot|retainer · ladder (optional grouping,
#       default "default") · price_php · price_basis: fixed|range|per_sprint ·
#       discovery_pct_basis (optional expected build value the 5–10 % rule is checked against;
#       default = median of the good/better prices) · scope_in[] · scope_out[] ·
#       fence_attributes[] · deliverables[] · duration_days · prepay_pct · payment_terms_days ·
#       guarantee {trigger, remedy, cap_pct} · credit_to_next {amount_php, deadline_days} ·
#       whole_product {install, training, support_months, warranty_months, docs} ·
#       hardware: true|false · first_engagement: true|false · bundle: true|false ·
#       a_la_carte_available: true|false (required true for bundles) · tax_note
#
# Checks (brief 03 §5 G3.6): exactly one discovery offer, priced 5–10 % of the expected build value
# (Sakas), credit deadline 14–42 d when a credit exists · per ladder: good < better < best strictly,
# each tier ≥ 1 fence attribute absent from the tier below, good.scope_out non-empty
# (cannibalisation guard), good ≥ 0.6 × better and best ≤ 1.5 × better as WARN (−25 % / +50 %
# spacing) · bundles carry a_la_carte_available: true (mixed bundling, Derdenger & Kumar) · every
# guarantee has trigger + remedy + cap_pct ∈ (0, 100] (an uncapped guarantee is an unpriced
# liability) · hardware offers: support_months ≥ warranty_months (PH after-sales expectation) ·
# first-engagement offers: prepay_pct ≥ 50 and payment_terms_days ≤ 30 (PH trust ladder) ·
# pilots ≤ 56 d · tax_note says "ex-VAT" and "EWT" on every offer.
#
# Policy (env-overridable; research default in brackets):
#   GUILD_OFFER_DISC_PCT_MIN/_MAX     [5/10]   discovery % of expected build value (Sakas 5–10 %)
#   GUILD_OFFER_CREDIT_MIN/_MAX_DAYS  [14/42]  credit-to-next deadline (Sakas 2–6 weeks)
#   GUILD_OFFER_GOOD_MIN_RATIO        [0.6]    good ≥ ratio × better (≈ −25 % rule, warn)
#   GUILD_OFFER_BEST_MAX_RATIO        [1.5]    best ≤ ratio × better (≈ +50 % rule, warn)
#   GUILD_OFFER_PREPAY_MIN            [50]     first-engagement prepay % (PH trust ladder)
#   GUILD_OFFER_TERMS_MAX             [30]     first-engagement payment terms, days
#   GUILD_OFFER_PILOT_MAX_DAYS        [56]     paid pilots stay short (≤ 8 weeks)
#   GUILD_OFFER_CAP_MAX               [100]    guarantee cap ceiling, % of the offer price
# Contract: references/offer-protocol.md §10–§11, §19; references/metrics.md.

_off_num() { if [[ "${1:-}" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then printf '%s' "$1"; else printf '%s' "$2"; fi; }

gate_offers() {
  local yml="${1:?usage: offers <offers.yaml>}"
  [[ -f "$yml" ]] || { echo "score-guild: offers: missing $yml" >&2; return 2; }
  local oj cfg
  oj="$(guild_yaml_json "$yml")" || { echo "score-guild: offers: cannot parse $yml" >&2; return 2; }
  cfg="$(printf '{"discMin":%s,"discMax":%s,"creditMin":%s,"creditMax":%s,"goodMin":%s,"bestMax":%s,"prepayMin":%s,"termsMax":%s,"pilotMax":%s,"capMax":%s}' \
    "$(_off_num "${GUILD_OFFER_DISC_PCT_MIN:-}" 5)" "$(_off_num "${GUILD_OFFER_DISC_PCT_MAX:-}" 10)" \
    "$(_off_num "${GUILD_OFFER_CREDIT_MIN_DAYS:-}" 14)" "$(_off_num "${GUILD_OFFER_CREDIT_MAX_DAYS:-}" 42)" \
    "$(_off_num "${GUILD_OFFER_GOOD_MIN_RATIO:-}" 0.6)" "$(_off_num "${GUILD_OFFER_BEST_MAX_RATIO:-}" 1.5)" \
    "$(_off_num "${GUILD_OFFER_PREPAY_MIN:-}" 50)" "$(_off_num "${GUILD_OFFER_TERMS_MAX:-}" 30)" \
    "$(_off_num "${GUILD_OFFER_PILOT_MAX_DAYS:-}" 56)" "$(_off_num "${GUILD_OFFER_CAP_MAX:-}" 100)")"
  printf '{"doc":%s,"cfg":%s}' "$oj" "$cfg" | node -e '
const fs=require("fs");
const inp=JSON.parse(fs.readFileSync(0,"utf8"));
const D=inp.doc&&typeof inp.doc==="object"&&!Array.isArray(inp.doc)?inp.doc:{};
const C=inp.cfg;
let V=0,W=0;
const fail=(r,m)=>{V++;console.error("rule "+r+": "+m);};
const warn=(r,m)=>{W++;console.error("warn "+r+": "+m);};
const s=x=>x==null?"":String(x).trim();
const norm=x=>s(x).toLowerCase();
const arr=x=>Array.isArray(x)?x.filter(e=>e!=null&&s(e)!==""):(x==null||s(x)===""?[]:[x]);
const bool=x=>x===true||norm(x)==="true"||norm(x)==="y"||norm(x)==="yes";
const O=arr(D.offers).filter(o=>o&&typeof o==="object");
if(O.length===0)fail("offers","offers: list is empty or missing");
const tiers=["discovery","good","better","best","pilot","retainer"];
const bases=["fixed","range","per_sprint"];
const seen=new Set();
O.forEach((o,i)=>{o.__lab=s(o.id)||s(o.name)||("#"+(i+1));o.__tier=norm(o.tier);o.__price=Number(o.price_php);});
for(const o of O){
 const lab=o.__lab;
 if(s(o.id)!==""){if(seen.has(s(o.id)))fail(lab+".id","duplicate id");seen.add(s(o.id));}
 if(s(o.name)==="")fail(lab+".name","empty");
 if(!tiers.includes(o.__tier))fail(lab+".tier",`"${s(o.tier)}" is not one of ${tiers.join("|")}`);
 if(!(o.__price>0))fail(lab+".price_php",`"${s(o.price_php)}" must be a number > 0 (PHP, ex-VAT)`);
 if(!bases.includes(norm(o.price_basis)))fail(lab+".price_basis",`"${s(o.price_basis)}" is not one of ${bases.join("|")}`);
 if(arr(o.scope_in).length===0)fail(lab+".scope_in","empty — an offer without a scope is a blank cheque");
 if(arr(o.deliverables).length===0)fail(lab+".deliverables","empty");
 const tn=s(o.tax_note);
 if(!/ex-?vat/i.test(tn)||!/ewt/i.test(tn))fail(lab+".tax_note",`"${tn||"(missing)"}" — every price carries "ex-VAT; subject to EWT" (PH clients withhold and issue BIR 2307)`);
 if(o.guarantee!=null){
  if(typeof o.guarantee!=="object"||Array.isArray(o.guarantee))fail(lab+".guarantee","must be a map {trigger, remedy, cap_pct}");
  else{const g=o.guarantee;
   if(s(g.trigger)==="")fail(lab+".guarantee.trigger","empty — an untriggerable guarantee is unenforceable");
   if(s(g.remedy)==="")fail(lab+".guarantee.remedy","empty");
   const cap=Number(g.cap_pct);
   if(s(g.cap_pct)===""||isNaN(cap))fail(lab+".guarantee.cap_pct","missing — an uncapped guarantee is an unpriced liability; cap it as % of the offer price");
   else if(!(cap>0&&cap<=C.capMax))fail(lab+".guarantee.cap_pct",`${s(g.cap_pct)} outside (0, ${C.capMax}]`);}}
 const hw=bool(o.hardware);
 const wp=o.whole_product&&typeof o.whole_product==="object"?o.whole_product:null;
 if(hw){
  if(!wp)fail(lab+".whole_product","hardware offer without a whole_product block (install, training, support_months, warranty_months, docs)");
  else{const sm=Number(wp.support_months),wm=Number(wp.warranty_months);
   if(isNaN(sm)||isNaN(wm))fail(lab+".whole_product","support_months / warranty_months must be numbers");
   else if(sm<wm)fail(lab+".whole_product.support_months",`${sm} < warranty_months ${wm} — PH buyers expect after-sales support during and after the warranty`);}}
 if(bool(o.first_engagement)){
  const pp=Number(o.prepay_pct),pt=Number(o.payment_terms_days);
  if(!(pp>=C.prepayMin))fail(lab+".prepay_pct",`${s(o.prepay_pct)||"(missing)"} < ${C.prepayMin} % on a first engagement (PH trust ladder: L/C first, open account only after trust)`);
  if(isNaN(pt)||pt>C.termsMax)fail(lab+".payment_terms_days",`${s(o.payment_terms_days)||"(missing)"} > ${C.termsMax} d on a first engagement — open-account terms lengthen with trust, never start long`);}
 if(bool(o.bundle)&&!bool(o.a_la_carte_available))
  fail(lab+".a_la_carte_available","bundle without à-la-carte availability — mixed bundling dominates pure bundling (Derdenger & Kumar)");
 if(o.__tier==="pilot"){const dd=Number(o.duration_days);
  if(isNaN(dd)||!(dd>0)||dd>C.pilotMax)fail(lab+".duration_days",`pilot of ${s(o.duration_days)||"(missing)"} d — paid pilots stay short (≤ ${C.pilotMax} d) with a fixed metric and end date`);}
}
// ---- exactly one paid discovery ---------------------------------------------------------------
const disc=O.filter(o=>o.__tier==="discovery");
if(disc.length===0)fail("offers.discovery","no paid-discovery offer — free proposals are worthless; the ladder opens with a small, paid, fixed-scope diagnostic");
if(disc.length>1)fail("offers.discovery",`${disc.length} discovery offers; exactly one — a single small first commitment, not a menu`);
const gb=O.filter(o=>o.__tier==="good"||o.__tier==="better").map(o=>o.__price).filter(p=>p>0).sort((a,b)=>a-b);
const median=gb.length?(gb.length%2?gb[(gb.length-1)/2]:(gb[gb.length/2-1]+gb[gb.length/2])/2):0;
for(const o of disc){
 const lab=o.__lab;
 const basis=Number(o.discovery_pct_basis)>0?Number(o.discovery_pct_basis):median;
 if(!(basis>0))warn(lab+".discovery_pct","no good/better price and no discovery_pct_basis — the 5–10 % rule cannot be checked");
 else if(o.__price>0){const pct=o.__price/basis*100;
  if(pct<C.discMin||pct>C.discMax)fail(lab+".discovery_pct",`₱${o.__price} is ${pct.toFixed(1)} % of the expected build value ₱${basis} — paid discovery prices at ${C.discMin}–${C.discMax} %`);}
 const cr=o.credit_to_next&&typeof o.credit_to_next==="object"?o.credit_to_next:null;
 if(cr&&Number(cr.amount_php)>0){const dl=Number(cr.deadline_days);
  if(isNaN(dl)||dl<C.creditMin||dl>C.creditMax)fail(lab+".credit_to_next.deadline_days",`${s(cr.deadline_days)||"(missing)"} outside ${C.creditMin}–${C.creditMax} d — credit toward the next engagement expires in 2–6 weeks`);}
 else warn(lab+".credit_to_next","no credit toward the next engagement (allowed; credit is what converts diagnostics into builds)");
}
// ---- Good-Better-Best per ladder ---------------------------------------------------------------
const ladders={};
for(const o of O){const L=s(o.ladder)||"default";(ladders[L]=ladders[L]||{});(ladders[L][o.__tier]=ladders[L][o.__tier]||[]).push(o);}
const fenceOf=o=>arr(o.fence_attributes).map(norm);
for(const [L,byTier] of Object.entries(ladders)){
 for(const t of ["good","better","best"]) if((byTier[t]||[]).length>1)fail(`ladder.${L}.${t}`,`${byTier[t].length} offers share tier ${t}; one per tier per ladder`);
 const g=(byTier.good||[])[0],b=(byTier.better||[])[0],x=(byTier.best||[])[0];
 const present=[g,b,x].filter(Boolean);
 if(present.length<2)continue;
 if(g&&b&&!(g.__price<b.__price))fail(`ladder.${L}.prices`,`good ₱${g.__price} ≥ better ₱${b.__price} — tier prices must be strictly increasing`);
 if(b&&x&&!(b.__price<x.__price))fail(`ladder.${L}.prices`,`better ₱${b.__price} ≥ best ₱${x.__price} — tier prices must be strictly increasing`);
 if(g&&x&&!b&&!(g.__price<x.__price))fail(`ladder.${L}.prices`,`good ₱${g.__price} ≥ best ₱${x.__price} — tier prices must be strictly increasing`);
 if(g){
  if(fenceOf(g).length===0)fail(`ladder.${L}.good.fence_attributes`,"empty — every tier carries ≥ 1 fence attribute buyers will not cross down for");
  if(arr(g.scope_out).length===0)fail(`ladder.${L}.good.scope_out`,"empty — a Good tier without a scope_out cannibalises Better");}
 if(b){const fg=new Set(g?fenceOf(g):[]);
  if(!fenceOf(b).some(f=>!fg.has(f)))fail(`ladder.${L}.better.fence_attributes`,"no fence attribute beyond good — nothing stops downgrading");}
 if(x){const fb=new Set(b?fenceOf(b):[]);
  if(!fenceOf(x).some(f=>!fb.has(f)))fail(`ladder.${L}.best.fence_attributes`,"no fence attribute beyond better — nothing stops downgrading");}
 if(g&&b&&g.__price<C.goodMin*b.__price)warn(`ladder.${L}.spacing`,`good ₱${g.__price} < ${C.goodMin} × better ₱${b.__price} — a too-cheap Good drags the anchor down (≈ −25 % rule)`);
 if(b&&x&&x.__price>C.bestMax*b.__price)warn(`ladder.${L}.spacing`,`best ₱${x.__price} > ${C.bestMax} × better ₱${b.__price} — Best beyond ≈ +50 % stops anchoring and starts scaring`);
}
console.error(`violations=${V} warnings=${W} offers=${O.length} discovery=${disc.length} ladders=${Object.keys(ladders).length}`);
console.log("OFFER_VIOLATIONS: "+V);
'
}
