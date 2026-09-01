#!/usr/bin/env bash
# gate: pricing — price-book discipline: cost floor, fresh inputs, competitor band, WTP evidence,
# research adequacy, PH tax consistency (VAT / 8 % / CWT / zero-rating), discount and increase policy.
#   score-guild.sh pricing <price-book.csv> <tax-status.csv> [competitor-band.csv] [wtp-interviews.csv] [discount-log.csv]
#     → "PRICE_VIOLATIONS: N"   (each violation → stderr "rule <name> [<offer>/<tier>]: …"; warnings "warn …")
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing / unparsable file)
#
# price-book.csv (pricing/price-book.csv, loop-written, one row per offer × tier × metric; the
# scorer calls the gate with the first two args only — the book row columns carry the competitor
# band and WTP summary; the optional files add per-capture / per-interview detail):
#   offer_id · tier · price_metric: seat|per_seat|usage|flat|tiered|tm|fixed|milestone|retainer|
#     value|per_device|per_unit · list_price_exvat · currency (ISO-4217) ·
#   vat_treatment: vatable12|exempt_nonvat|zero_rated_108B2 · display: exclusive|inclusive ·
#   cost_floor_exvat · floor_method · floor_date · floor_utilization (fraction; required for
#     tm/fixed/milestone/retainer/value rows) · target_gm_pct (fraction) · cwt_rate_expected ·
#   buyer_type: b2b|b2c (empty ⇒ b2b) · channel: direct|retail|distributor (empty ⇒ direct) ·
#   cogs_exvat (hardware) · foreign_currency_client: Y|N · segment_id ·
#   competitor_low · competitor_high · competitor_n · competitor_capture_date ·
#   wtp_n · wtp_pmc · wtp_opp · wtp_ipp · wtp_pme · research_method: none|interviews|
#     van_westendorp|gabor_granger|cbc · cbc_exposures · justification_ref ·
#   max_discount_pct · discount_authority · prev_price_exvat · change_reason_text ·
#   change_notice_date · realised_pct · grandfather_until · effective_from · last_reviewed · approver
#   ("-" reads as empty; every column is documented in references/pricing-protocol.md §12)
# tax-status.csv (HUMAN-ENTERED): entity_type: sole_prop|corp|opc · vat_registered ·
#   eight_pct_elected · trailing_12m_gross_sales · cor_date
# competitor-band.csv: offer_id, competitor, url, capture_date, hash, price, metric, vat_treatment
# wtp-interviews.csv (HUMAN-ENTERED): interview_id, date, segment_id, offer_id, …
# discount-log.csv: quote_id, offer_id, tier, date, list_exvat, invoiced_exvat, pocket_exvat, approver
#
# Checks (brief 04 §5, checks 1–11): list ≥ floor ÷ (1 − target_gm) · hardware GM ≥ 40 % and
# retail rows ≥ 3× COGS (warn) / ≥ 4× (pass) · floor_date ≤ 90 d and utilisation ≤ 75 %
# (> 70 % needs justification_ref) · competitor_n ≥ 3, captures ≤ 90 d, list outside
# [0.8 × low, 1.5 × high] needs justification_ref · new offers (effective_from within 180 d)
# need wtp_n ≥ 10 · van_westendorp ⇒ n ≥ 150 ∧ PMC ≤ list ≤ PME; gabor_granger ⇒ n ≥ 100;
# cbc ⇒ cbc_exposures ≥ 500 · tax: trailing > ₱3M ⇒ VAT-registered and no exempt_nonvat rows
# (warn at 80 %); VAT ⇒ no 8 %; 8 % ⇒ sole_prop and ≤ ₱3M; non-VAT seller cannot issue
# vatable12 / zero-rated rows; zero_rated_108B2 needs foreign_currency_client=Y; B2B rows
# display=exclusive · cwt_rate_expected ∈ {5,10} sole prop ({10} once VAT-registered) /
# {10,15} corp|opc; 0 only for b2c or foreign-currency buyers · max_discount_pct ≤ 20 and
# discount_authority set · increases > 2 % need change_reason_text, ≥ 30 d notice,
# grandfather_until set (date or "null") · book reviewed within 90 d · with the optional files:
# per-offer captures ≥ 3, fresh, hex-hashed, min/max agreeing with the book band; new offers
# backed by ≥ 10 interview rows (interview-method wtp_n may not exceed the file); every quote
# pocket ≥ (1 − max_discount) × list and ≥ floor with an approver; P90/P10 pocket band > 1.6 →
# review warn.
#
# Policy (env-overridable; research default in brackets):
#   GUILD_PRICE_FLOOR_MAX_DAYS [90] · GUILD_PRICE_UTIL_MAX [0.75] · GUILD_PRICE_UTIL_JUSTIFY [0.70]
#   GUILD_PRICE_COMP_MIN_N [3] · GUILD_PRICE_COMP_MAX_DAYS [90] · GUILD_PRICE_BAND_LOW [0.8]
#   GUILD_PRICE_BAND_HIGH [1.5] · GUILD_PRICE_NEW_DAYS [180] · GUILD_PRICE_WTP_MIN [10]
#   GUILD_PRICE_VW_MIN_N [150] · GUILD_PRICE_GG_MIN_N [100] · GUILD_PRICE_CBC_MIN [500]
#   GUILD_PRICE_HW_GM_MIN [0.40] · GUILD_PRICE_HW_RETAIL_WARN [3] · GUILD_PRICE_HW_RETAIL_PASS [4]
#   GUILD_PRICE_VAT_THRESHOLD [3000000] · GUILD_PRICE_VAT_MONITOR [0.80] · GUILD_PRICE_MAX_DISCOUNT [20]
#   GUILD_PRICE_NOTICE_MIN_DAYS [30] · GUILD_PRICE_INCREASE_FREE_PCT [2] · GUILD_PRICE_BAND_REVIEW [1.6]
#   GUILD_PRICE_REVIEW_DAYS [90]
# Contract: references/pricing-protocol.md §12–§13, §17; references/metrics.md.

_prc_num() { if [[ "${1:-}" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then printf '%s' "$1"; else printf '%s' "$2"; fi; }

gate_pricing() {
  local book="${1:?usage: pricing <price-book.csv> <tax-status.csv> [competitor-band.csv] [wtp-interviews.csv] [discount-log.csv]}"
  local tax="${2:?usage: pricing <price-book.csv> <tax-status.csv> [competitor-band.csv] [wtp-interviews.csv] [discount-log.csv]}"
  local comp="${3:-}" wtp="${4:-}" disc="${5:-}" f
  for f in "$book" "$tax" ${comp:+"$comp"} ${wtp:+"$wtp"} ${disc:+"$disc"}; do
    [[ -f "$f" ]] || { echo "score-guild: pricing: missing $f" >&2; return 2; }
  done
  local bj tj cj wj dj today cfg
  bj="$(guild_csv_json "$book")" || { echo "score-guild: pricing: cannot parse $book" >&2; return 2; }
  tj="$(guild_csv_json "$tax")"  || { echo "score-guild: pricing: cannot parse $tax" >&2; return 2; }
  if [[ -n "$comp" ]]; then cj="$(guild_csv_json "$comp")" || { echo "score-guild: pricing: cannot parse $comp" >&2; return 2; }; else cj=null; fi
  if [[ -n "$wtp" ]];  then wj="$(guild_csv_json "$wtp")"  || { echo "score-guild: pricing: cannot parse $wtp" >&2; return 2; };  else wj=null; fi
  if [[ -n "$disc" ]]; then dj="$(guild_csv_json "$disc")" || { echo "score-guild: pricing: cannot parse $disc" >&2; return 2; }; else dj=null; fi
  today="$(guild_today "$book")"
  cfg="$(printf '{"floorMaxDays":%s,"utilMax":%s,"utilJustify":%s,"compMinN":%s,"compMaxDays":%s,"bandLow":%s,"bandHigh":%s,"newDays":%s,"wtpMin":%s,"vwMinN":%s,"ggMinN":%s,"cbcMin":%s,"hwGmMin":%s,"hwWarnX":%s,"hwPassX":%s,"vatThreshold":%s,"vatMonitor":%s,"maxDiscount":%s,"noticeMin":%s,"increaseFree":%s,"bandReview":%s,"reviewDays":%s}' \
    "$(_prc_num "${GUILD_PRICE_FLOOR_MAX_DAYS:-}" 90)"   "$(_prc_num "${GUILD_PRICE_UTIL_MAX:-}" 0.75)" \
    "$(_prc_num "${GUILD_PRICE_UTIL_JUSTIFY:-}" 0.70)"   "$(_prc_num "${GUILD_PRICE_COMP_MIN_N:-}" 3)" \
    "$(_prc_num "${GUILD_PRICE_COMP_MAX_DAYS:-}" 90)"    "$(_prc_num "${GUILD_PRICE_BAND_LOW:-}" 0.8)" \
    "$(_prc_num "${GUILD_PRICE_BAND_HIGH:-}" 1.5)"       "$(_prc_num "${GUILD_PRICE_NEW_DAYS:-}" 180)" \
    "$(_prc_num "${GUILD_PRICE_WTP_MIN:-}" 10)"          "$(_prc_num "${GUILD_PRICE_VW_MIN_N:-}" 150)" \
    "$(_prc_num "${GUILD_PRICE_GG_MIN_N:-}" 100)"        "$(_prc_num "${GUILD_PRICE_CBC_MIN:-}" 500)" \
    "$(_prc_num "${GUILD_PRICE_HW_GM_MIN:-}" 0.40)"      "$(_prc_num "${GUILD_PRICE_HW_RETAIL_WARN:-}" 3)" \
    "$(_prc_num "${GUILD_PRICE_HW_RETAIL_PASS:-}" 4)"    "$(_prc_num "${GUILD_PRICE_VAT_THRESHOLD:-}" 3000000)" \
    "$(_prc_num "${GUILD_PRICE_VAT_MONITOR:-}" 0.80)"    "$(_prc_num "${GUILD_PRICE_MAX_DISCOUNT:-}" 20)" \
    "$(_prc_num "${GUILD_PRICE_NOTICE_MIN_DAYS:-}" 30)"  "$(_prc_num "${GUILD_PRICE_INCREASE_FREE_PCT:-}" 2)" \
    "$(_prc_num "${GUILD_PRICE_BAND_REVIEW:-}" 1.6)"     "$(_prc_num "${GUILD_PRICE_REVIEW_DAYS:-}" 90)")"
  printf '{"book":%s,"tax":%s,"comp":%s,"wtp":%s,"disc":%s,"cfg":%s,"today":"%s"}' \
    "$bj" "$tj" "$cj" "$wj" "$dj" "$cfg" "$today" | node -e '
const fs=require("fs");
const inp=JSON.parse(fs.readFileSync(0,"utf8"));
const BOOK=Array.isArray(inp.book)?inp.book:[];
const TAX=Array.isArray(inp.tax)?inp.tax:[];
const COMP=Array.isArray(inp.comp)?inp.comp:null;
const WTP=Array.isArray(inp.wtp)?inp.wtp:null;
const DISC=Array.isArray(inp.disc)?inp.disc:null;
const C=inp.cfg, today=inp.today;
let V=0,W=0;
const fail=(r,l,m)=>{V++;console.error("rule "+r+(l?" ["+l+"]":"")+": "+m);};
const warn=(r,l,m)=>{W++;console.error("warn "+r+(l?" ["+l+"]":"")+": "+m);};
const raw=x=>{const t=x==null?"":String(x).trim();return t==="-"?"":t;};
const num=x=>{const t=raw(x);return t===""?NaN:Number(t.replace(/,/g,""));};
const frac=x=>{const v=num(x);return isNaN(v)?NaN:(v>1?v/100:v);};
const isDate=x=>/^20[0-9]{2}-[01][0-9]-[0-3][0-9]$/.test(raw(x));
const days=(a,b)=>{const x=new Date(a+"T00:00:00Z"),y=new Date(b+"T00:00:00Z");return(isNaN(x)||isNaN(y))?NaN:Math.round((y-x)/86400000);};
const age=d=>days(d,today);            // today − d; negative = future
const norm=x=>raw(x).toLowerCase();

// ---- schema ------------------------------------------------------------------------------------
if(BOOK.length===0)fail("schema","","price-book.csv has no data rows");
const REQ=["offer_id","tier","price_metric","list_price_exvat","currency","vat_treatment","display",
 "cost_floor_exvat","floor_method","floor_date","target_gm_pct","cwt_rate_expected","competitor_low",
 "competitor_high","competitor_n","competitor_capture_date","wtp_n","wtp_pmc","wtp_opp","wtp_ipp",
 "wtp_pme","research_method","justification_ref","max_discount_pct","discount_authority",
 "grandfather_until","effective_from","approver"];
const hdr=BOOK.length?Object.keys(BOOK[0]):[];
const has=c=>hdr.includes(c);
for(const c of REQ)if(BOOK.length&&!has(c))fail("schema.columns","",`missing required column ${c} (schema: references/pricing-protocol.md §12)`);
const METRICS=["seat","per_seat","usage","flat","tiered","tm","fixed","milestone","retainer","value","per_device","per_unit"];
const SERVICES=["tm","fixed","milestone","retainer","value"];
const HARDWARE=["per_device","per_unit"];
const VATS=["vatable12","exempt_nonvat","zero_rated_108B2"];
const RESEARCH=["","none","interviews","van_westendorp","gabor_granger","cbc"];

// ---- tax status (HUMAN-ENTERED) ---------------------------------------------------------------
const bool=x=>{const t=norm(x);if(["true","yes","y","1"].includes(t))return true;if(["false","no","n","0"].includes(t))return false;return null;};
let entity="",vat=null,eight=null,trailing=NaN;
if(TAX.length===0)fail("tax_status","","tax-status.csv has no data row (entity_type, vat_registered, eight_pct_elected, trailing_12m_gross_sales, cor_date)");
else{const t=TAX[0];entity=norm(t.entity_type);vat=bool(t.vat_registered);eight=bool(t.eight_pct_elected);trailing=num(t.trailing_12m_gross_sales);
 if(!["sole_prop","corp","opc"].includes(entity))fail("tax_status.entity_type","",`"${raw(t.entity_type)}" is not sole_prop|corp|opc`);
 if(vat===null)fail("tax_status.vat_registered","",`"${raw(t.vat_registered)}" is not a boolean`);
 if(eight===null)fail("tax_status.eight_pct_elected","",`"${raw(t.eight_pct_elected)}" is not a boolean`);
 if(isNaN(trailing))fail("tax_status.trailing_12m_gross_sales","",`"${raw(t.trailing_12m_gross_sales)}" is not a number`);
 if(!isDate(t.cor_date))warn("tax_status.cor_date","",`"${raw(t.cor_date)}" is not YYYY-MM-DD`);
 if(vat===true&&eight===true)fail("tax_status.eight_pct_elected","","eight_pct_elected while VAT-registered — the 8 % option is only for non-VAT taxpayers (RMO 23-2018)");
 if(eight===true&&entity!=="sole_prop"&&entity!=="")fail("tax_status.eight_pct_elected","",`8 % option elected by a ${entity} — individuals (sole proprietors) only (RMO 23-2018)`);
 if(!isNaN(trailing)&&trailing>C.vatThreshold){
  if(vat===false)fail("tax_status.vat_registered","",`trailing 12-month gross sales ₱${trailing} exceed the ₱${C.vatThreshold} VAT threshold — registration is compulsory and graduated rates + VAT apply from the breach date`);
  if(eight===true)fail("tax_status.eight_pct_elected","",`8 % option with gross sales ₱${trailing} above the ₱${C.vatThreshold} VAT threshold — the option lapses from the breach date (RMO 23-2018)`);}
 else if(!isNaN(trailing)&&vat===false&&trailing>=C.vatMonitor*C.vatThreshold)
  warn("tax_status.vat_threshold","",`trailing gross sales ₱${trailing} ≥ ${Math.round(C.vatMonitor*100)} % of the ₱${C.vatThreshold} VAT threshold — plan the VAT registration before the breach forces it`);}

// ---- per-row checks ---------------------------------------------------------------------------
const seen=new Set();
let freshest=Infinity;
for(const r of BOOK){
 const id=raw(r.offer_id),tier=raw(r.tier),lab=(id||"?")+"/"+(tier||"?");
 if(id==="")fail("schema.offer_id",lab,"empty offer_id");
 if(tier==="")fail("schema.tier",lab,"empty tier");
 const metric=norm(r.price_metric);
 if(has("price_metric")&&!METRICS.includes(metric))fail("schema.price_metric",lab,`"${raw(r.price_metric)}" is not one of ${METRICS.join("|")}`);
 const key=id+"|"+tier+"|"+metric;
 if(seen.has(key))fail("schema.duplicate",lab,"duplicate offer_id × tier × price_metric row");
 seen.add(key);
 const list=num(r.list_price_exvat),floor=num(r.cost_floor_exvat),gm=frac(r.target_gm_pct);
 if(has("list_price_exvat")&&!(list>0))fail("schema.list_price_exvat",lab,`"${raw(r.list_price_exvat)}" must be a number > 0`);
 if(has("currency")&&!/^[A-Z]{3}$/.test(raw(r.currency)))fail("schema.currency",lab,`"${raw(r.currency)}" is not an ISO-4217 code`);
 if(has("cost_floor_exvat")&&!(floor>0))fail("schema.cost_floor_exvat",lab,`"${raw(r.cost_floor_exvat)}" must be a number > 0 — no price row without a computed floor`);
 if(has("floor_method")&&raw(r.floor_method)==="")fail("schema.floor_method",lab,"empty — record how the floor was computed");
 if(has("target_gm_pct")&&!(gm>0&&gm<1))fail("schema.target_gm_pct",lab,`"${raw(r.target_gm_pct)}" must be a fraction in (0,1)`);
 if(has("approver")&&raw(r.approver)==="")fail("schema.approver",lab,"empty — every price row is approved by a named human");
 if(has("effective_from")&&!isDate(r.effective_from))fail("schema.effective_from",lab,`"${raw(r.effective_from)}" is not YYYY-MM-DD`);
 const vt=raw(r.vat_treatment),disp=norm(r.display);
 if(has("vat_treatment")&&!VATS.includes(vt))fail("schema.vat_treatment",lab,`"${vt}" is not one of ${VATS.join("|")}`);
 if(has("display")&&!["exclusive","inclusive"].includes(disp))fail("schema.display",lab,`"${raw(r.display)}" is not exclusive|inclusive`);
 const buyer=norm(r.buyer_type)||"b2b";
 const channel=norm(r.channel)||"direct";
 const fx=norm(r.foreign_currency_client)==="y";

 // 1 · floor
 if(list>0&&floor>0&&gm>0&&gm<1){
  const need=floor/(1-gm);
  if(list<need-0.005)fail("floor",lab,`list ${list} is below the cost floor ÷ (1 − GM) = ${need.toFixed(0)} (floor ${floor}, target GM ${gm}) — a price below the floor sells work at a loss`);}
 // hardware GM + retail multiple
 if(HARDWARE.includes(metric)){
  if(gm>0&&gm<C.hwGmMin)fail("hardware.gm",lab,`target GM ${gm} < ${C.hwGmMin} — hardware needs ≥ 40 % gross margin to survive the channel stack`);
  const cogs=num(r.cogs_exvat)>0?num(r.cogs_exvat):floor;
  if(channel==="retail"&&list>0&&cogs>0){const x=list/cogs;
   if(x<C.hwWarnX)fail("hardware.retail_multiple",lab,`retail list ${list} is ${x.toFixed(1)}× COGS ${cogs} — below the ${C.hwWarnX}× floor (keystone retailer + distributor margins leave nothing)`);
   else if(x<C.hwPassX)warn("hardware.retail_multiple",lab,`retail list ${list} is ${x.toFixed(1)}× COGS ${cogs} — target ≥ ${C.hwPassX}×`);}}
 // 2 · floor freshness + utilisation
 if(has("floor_date")){
  if(!isDate(r.floor_date))fail("floor_date",lab,`"${raw(r.floor_date)}" is not YYYY-MM-DD`);
  else{const a=age(raw(r.floor_date));
   if(a<0)fail("floor_date",lab,`floor_date ${raw(r.floor_date)} is in the future`);
   else if(a>C.floorMaxDays)fail("floor_date",lab,`floor_date ${raw(r.floor_date)} is ${a} d old (> ${C.floorMaxDays} d) — recompute the floor before quoting`);
   else freshest=Math.min(freshest,a);}}
 const util=frac(r.floor_utilization);
 if(raw(r.floor_utilization)!==""){
  if(isNaN(util))fail("utilisation",lab,`floor_utilization "${raw(r.floor_utilization)}" is not a fraction`);
  else{if(util>C.utilMax)fail("utilisation",lab,`floor assumes ${util} utilisation > ${C.utilMax} — SPI actuals are 68.9 % (2024) / 66.4 % (2025); an optimistic floor is a hidden discount`);
   else if(util>C.utilJustify&&raw(r.justification_ref)==="")fail("utilisation",lab,`floor assumes ${util} utilisation > ${C.utilJustify} with no justification_ref`);}}
 else if(SERVICES.includes(metric)&&has("floor_utilization"))
  fail("utilisation",lab,"services row without floor_utilization — a labour floor is meaningless without the utilisation assumption");
 // 3 · competitor band
 const cn=num(r.competitor_n),clo=num(r.competitor_low),chi=num(r.competitor_high);
 if(has("competitor_n")){
  if(!(cn>=C.compMinN))fail("competitor.n",lab,`competitor_n ${raw(r.competitor_n)||0} < ${C.compMinN} — the band needs ≥ 3 dated captures`);
  if(!isDate(r.competitor_capture_date))fail("competitor.capture_date",lab,`"${raw(r.competitor_capture_date)}" is not YYYY-MM-DD`);
  else{const a=age(raw(r.competitor_capture_date));
   if(a<0)fail("competitor.capture_date",lab,`capture date is in the future`);
   else if(a>C.compMaxDays)fail("competitor.capture_date",lab,`captures are ${a} d old (> ${C.compMaxDays} d) — refresh the band`);
   else freshest=Math.min(freshest,a);}
  if(clo>0&&chi>0){
   if(clo>chi)fail("competitor.band",lab,`competitor_low ${clo} > competitor_high ${chi}`);
   else if(list>0){const lo=C.bandLow*clo,hi=C.bandHigh*chi;
    if((list<lo||list>hi)){
     if(raw(r.justification_ref)==="")fail("competitor.band",lab,`list ${list} is outside [${C.bandLow} × ${clo}, ${C.bandHigh} × ${chi}] = [${lo.toFixed(0)}, ${hi.toFixed(0)}] with no justification_ref`);
     else warn("competitor.band",lab,`list ${list} outside [${lo.toFixed(0)}, ${hi.toFixed(0)}], justified by ${raw(r.justification_ref)}`);}}}}
 // 4/5 · WTP + research adequacy
 const wtpN=num(r.wtp_n);
 const isNew=isDate(r.effective_from)&&days(raw(r.effective_from),today)<=C.newDays;
 if(isNew&&has("wtp_n")&&!(wtpN>=C.wtpMin))
  fail("wtp",lab,`new offer (effective_from ${raw(r.effective_from)}) with wtp_n ${raw(r.wtp_n)||0} < ${C.wtpMin} — price before product: run the WTP conversations first (Ramanujam)`);
 const rm=norm(r.research_method);
 if(has("research_method")&&!RESEARCH.includes(rm))fail("research",lab,`research_method "${raw(r.research_method)}" is not one of ${RESEARCH.filter(Boolean).join("|")}`);
 if(rm==="van_westendorp"){
  if(!(wtpN>=C.vwMinN))fail("research.van_westendorp",lab,`n ${raw(r.wtp_n)||0} < ${C.vwMinN} per segment — intersections are unstable below the floor`);
  const pmc=num(r.wtp_pmc),pme=num(r.wtp_pme);
  if(!(pmc>0&&pme>0))fail("research.van_westendorp",lab,"wtp_pmc / wtp_pme missing — record the four intersection points");
  else if(list>0&&!(pmc<=list&&list<=pme))fail("research.van_westendorp",lab,`list ${list} outside the acceptable range PMC ${pmc} – PME ${pme}`);}
 if(rm==="gabor_granger"&&!(wtpN>=C.ggMinN))fail("research.gabor_granger",lab,`n ${raw(r.wtp_n)||0} < ${C.ggMinN}`);
 if(rm==="cbc"){const ex=num(r.cbc_exposures);
  if(!(ex>=C.cbcMin))fail("research.cbc",lab,`cbc_exposures ${raw(r.cbc_exposures)||0} < ${C.cbcMin} (Johnson-Orme n·t·a/c ≥ 500)`);}
 // 6 · tax consistency per row
 if(vat===true&&vt==="exempt_nonvat")fail("tax.vat_treatment",lab,"exempt_nonvat row while the seller is VAT-registered — every sale is vatable or zero-rated");
 if(vat===false&&vt==="vatable12")fail("tax.vat_treatment",lab,"vatable12 row while the seller is not VAT-registered — a non-VAT seller cannot charge output VAT");
 if(vat===false&&vt==="zero_rated_108B2")fail("tax.vat_treatment",lab,"zero-rated row while the seller is not VAT-registered — §108(B)(2) zero-rating applies to VAT-registered sellers");
 if(vt==="zero_rated_108B2"&&!fx)fail("tax.zero_rated",lab,"zero_rated_108B2 without foreign_currency_client=Y — §108(B)(2) requires payment in acceptable foreign currency (BSP rules)");
 if(buyer==="b2b"&&disp==="inclusive")fail("tax.display",lab,"B2B row displayed VAT-inclusive — quote ex-VAT with the 12 % VAT as a separate line or the seller eats 12/112 of the price");
 // 7 · CWT expectation
 const cwt=num(r.cwt_rate_expected);
 if(has("cwt_rate_expected")){
  if(isNaN(cwt))fail("cwt",lab,`cwt_rate_expected "${raw(r.cwt_rate_expected)}" is not a number`);
  else if(cwt===0){if(!(buyer==="b2c"||fx))fail("cwt",lab,"cwt_rate_expected 0 on a domestic B2B row — corporate clients withhold EWT on professional fees");}
  else{let allowed=[];
   if(entity==="sole_prop")allowed=(vat===true)?[10]:[5,10];
   else if(entity==="corp"||entity==="opc")allowed=[10,15];
   if(allowed.length&&!allowed.includes(cwt))fail("cwt",lab,`cwt_rate_expected ${cwt} not in {${allowed.join(",")}} for a ${entity}${vat===true?" (VAT-registered)":""} payee (RR 11-2018 / RR 14-2018)`);
   if((entity==="corp"||entity==="opc")&&!isNaN(trailing)&&trailing>720000&&cwt===10)warn("cwt",lab,"gross income above the ₱720,000 test — clients will likely withhold 15 %, not 10 %");}}
 // 8 · discount policy
 const md=num(r.max_discount_pct);
 if(has("max_discount_pct")&&!(md>=0&&md<=C.maxDiscount))fail("discount.max",lab,`max_discount_pct ${raw(r.max_discount_pct)} outside [0, ${C.maxDiscount}] — discounts beyond 20 % correlate with attrition (SPI)`);
 if(has("discount_authority")&&raw(r.discount_authority)==="")fail("discount.authority",lab,"empty discount_authority — name who may approve a discount before one is asked for");
 // 10 · price-change discipline
 const prev=num(r.prev_price_exvat);
 if(raw(r.prev_price_exvat)!==""&&prev>0&&list>0&&list>prev){
  const pct=(list/prev-1)*100;
  if(pct>C.increaseFree&&raw(r.change_reason_text)==="")fail("increase.reason",lab,`+${pct.toFixed(1)} % increase with no change_reason_text — increases above ${C.increaseFree} % need a stated reason (Simon-Kucher)`);
  else if(pct<=C.increaseFree&&raw(r.change_reason_text)==="")warn("increase.reason",lab,`+${pct.toFixed(1)} % increase with no stated reason`);
  if(!isDate(r.change_notice_date))fail("increase.notice",lab,"no change_notice_date — existing customers get ≥ 30 d notice");
  else if(isDate(r.effective_from)){const n=days(raw(r.change_notice_date),raw(r.effective_from));
   if(n<C.noticeMin)fail("increase.notice",lab,`${n} d notice < ${C.noticeMin} d before effective_from`);}
  if(raw(r.grandfather_until)==="")fail("increase.grandfather",lab,`grandfather_until empty — set a date or an explicit "null" decision for existing customers`);
  if(raw(r.realised_pct)==="")warn("increase.realised",lab,"track realised_pct — companies realise < 50 % of attempted increases (Simon-Kucher GPS 2025)");}
 // cadence input
 for(const c of ["effective_from","last_reviewed"])if(isDate(r[c])){const a=age(raw(r[c]));if(a>=0)freshest=Math.min(freshest,a);else freshest=Math.min(freshest,0);}
}
// 11 · quarterly cadence
if(BOOK.length&&!(freshest<=C.reviewDays))fail("cadence","",`no floor / capture / effective / review date within ${C.reviewDays} d — the price book is reviewed at least quarterly`);

// ---- optional competitor-band.csv --------------------------------------------------------------
if(COMP){
 const by={};
 for(const c of COMP){const o=raw(c.offer_id);if(o==="")continue;(by[o]=by[o]||[]).push(c);}
 for(const [o,rows] of Object.entries(by)){
  if(rows.length<C.compMinN)fail("competitor.file",o,`${rows.length} capture(s) in competitor-band.csv < ${C.compMinN}`);
  let lo=Infinity,hi=-Infinity;
  rows.forEach((c,i)=>{const lab=o+"#"+(i+1);
   if(!isDate(c.capture_date))fail("competitor.file.capture",lab,`"${raw(c.capture_date)}" is not YYYY-MM-DD`);
   else{const a=age(raw(c.capture_date));if(a<0||a>C.compMaxDays)fail("competitor.file.capture",lab,`capture ${raw(c.capture_date)} is ${a} d old (> ${C.compMaxDays} d)`);}
   if(!/^[0-9a-f]{16,64}$/i.test(raw(c.hash)))fail("competitor.file.hash",lab,`hash "${raw(c.hash)}" is not 16–64 hex chars of the captured page`);
   const p=num(c.price);if(!(p>0))fail("competitor.file.price",lab,`price "${raw(c.price)}" is not a number > 0`);else{lo=Math.min(lo,p);hi=Math.max(hi,p);}});
  for(const r of BOOK){if(raw(r.offer_id)!==o)continue;const bl=num(r.competitor_low),bh=num(r.competitor_high);
   if(lo<Infinity&&bl>0&&Math.abs(bl-lo)>0.01*lo)fail("competitor.file.band",o,`book competitor_low ${bl} ≠ file min ${lo}`);
   if(hi>-Infinity&&bh>0&&Math.abs(bh-hi)>0.01*hi)fail("competitor.file.band",o,`book competitor_high ${bh} ≠ file max ${hi}`);break;}}
 for(const r of BOOK){const o=raw(r.offer_id);if(o!==""&&num(r.competitor_n)>0&&!by[o])warn("competitor.file",o,"no captures on file for this offer");}}

// ---- optional wtp-interviews.csv (HUMAN-ENTERED) -----------------------------------------------
if(WTP){
 for(const r of BOOK){
  const id=raw(r.offer_id),tier=raw(r.tier),lab=(id||"?")+"/"+(tier||"?");
  const seg=norm(r.segment_id);
  const matches=WTP.filter(w=>norm(w.offer_id)===norm(id)||(seg!==""&&norm(w.segment_id)===seg)).length;
  const isNew=isDate(r.effective_from)&&days(raw(r.effective_from),today)<=C.newDays;
  if(isNew&&matches<C.wtpMin)fail("wtp.file",lab,`${matches} interview row(s) in wtp-interviews.csv < ${C.wtpMin} for a new offer`);
  const rm=norm(r.research_method);
  if((rm===""||rm==="none"||rm==="interviews")&&num(r.wtp_n)>matches)
   fail("wtp.file",lab,`wtp_n ${num(r.wtp_n)} overstates the ledger — only ${matches} interview row(s) on file`);}}

// ---- optional discount-log.csv -----------------------------------------------------------------
if(DISC){
 const pockets={};
 DISC.forEach((q,i)=>{const lab=raw(q.quote_id)||("Q#"+(i+1));
  const o=raw(q.offer_id),t=raw(q.tier);
  const row=BOOK.find(r=>raw(r.offer_id)===o&&(t===""||raw(r.tier)===t))||BOOK.find(r=>raw(r.offer_id)===o);
  const list=num(q.list_exvat),pocket=num(q.pocket_exvat);
  if(raw(q.approver)==="")fail("pocket.approver",lab,"quote with no approver — every discount is a named human decision");
  if(!row){warn("pocket",lab,`offer ${o} not in the price book`);return;}
  const md=num(row.max_discount_pct);
  if(list>0&&pocket>0&&md>=0&&pocket/list<1-md/100-1e-9)
   fail("pocket.discount",lab,`pocket ${pocket} is ${(100*(1-pocket/list)).toFixed(1)} % off list ${list} — beyond max_discount_pct ${md}`);
  const floor=num(row.cost_floor_exvat);
  if(pocket>0&&floor>0&&pocket<floor)fail("pocket.floor",lab,`pocket ${pocket} is below the cost floor ${floor} — quotes below floor block`);
  if(pocket>0)(pockets[o]=pockets[o]||[]).push(pocket);});
 for(const [o,ps] of Object.entries(pockets)){
  if(ps.length<5)continue;
  ps.sort((a,b)=>a-b);
  const q=p=>ps[Math.min(ps.length-1,Math.floor(p*(ps.length-1)))];
  const band=q(0.9)/q(0.1);
  if(band>C.bandReview)warn("pocket.band",o,`P90/P10 pocket-price band ${band.toFixed(2)} > ${C.bandReview} — review discounting (Marn & Rosiello)`);}}

console.error(`rows=${BOOK.length} violations=${V} warnings=${W} entity=${entity||"?"} vat_registered=${vat} eight_pct=${eight} trailing=${isNaN(trailing)?"?":trailing} today=${today}`);
console.log("PRICE_VIOLATIONS: "+V);
'
}
