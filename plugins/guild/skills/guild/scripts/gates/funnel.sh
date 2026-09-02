#!/usr/bin/env bash
# gate: funnel — pipeline hygiene over the HUMAN-ENTERED deals ledger (gtm/pipeline.tsv / deals.csv).
#   score-guild.sh funnel <deals.csv|deals.tsv> [targets.tsv]   → "FUNNEL_VIOLATIONS: N"
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing file / unparseable /
#   a data-bearing ledger without deal_id+stage columns)
#
# Separator: TSV when the file ends in .tsv or the header line contains a tab; CSV otherwise.
# Extra columns (e.g. the template pipeline.tsv's trailing invoice/payment pair read by the
# paying/verdict seam) are ignored. A header-only ledger (no data rows) emits
# FUNNEL_VIOLATIONS: 0 — a fresh venture starts clean.
#
# deals columns (brief 06 §5; full doctrine in references/gtm-protocol.md):
#   deal_id account segment source_channel stage stage_entered_at days_in_stage amount_acv
#   amount_tcv currency forecast_category probability owner next_action next_action_date
#   last_activity_at expected_close_date close_date_slips champion_named economic_buyer_named
#   metrics_agreed decision_criteria_doc decision_process_doc paper_process_started
#   pain_statement competition pilot_metric pilot_start_date pilot_end_date proposal_path
#   payment_terms_days withholding_pct po_number contract_signed_at invoice_date paid_date
#   outcome loss_reason loss_note [opened_at] [pilot_price_php] [tripwires|clauses]
#   [tripwire_reviewed_by]
# targets.tsv (optional, tab-separated): segment primary quarter_target_php motion acv_band
#   (acv_band = "lo-hi" in ledger currency, declared from the Janz ACV bands)
#
# Checks (contract: references/metrics.md; research anchors: references/gtm-protocol.md):
#   stage exits    open deal at/after proposal needs economic_buyer_named=Y ∧ metrics_agreed=Y
#                  ∧ decision_process_doc; forecast_category=commit needs paper_process_started=Y
#   next step      open deal with empty or past next_action_date ⇒ violation (downgrade)
#   staleness      last_activity_at > 21 d ⇒ warn (stderr) · > 45 d ⇒ violation (→ no_decision)
#   slips          close_date_slips ≥ 2 while forecast_category=commit ⇒ violation
#   pilots         pilot_metric ⇒ pilot_end_date, ≤ 8 weeks from start, price > 0;
#                  unpaid (no price or never invoiced) > 60 d ⇒ violation
#   tripwires      unlimited_liability|ip_transfer|exclusivity|auto_renew without
#                  tripwire_reviewed_by ⇒ violation
#   loss reasons   lost ⇒ loss_reason ∈ enum (incl. no_decision)
#   cash-in        paid or open invoice beyond payment_terms_days + 15 d ⇒ warn
#   cycle          days in pipeline > 2× the ACV band (90/180/270 d) ⇒ warn
#   with targets   segment ∈ targets; ≥ 80 % of open value in the primary segment(s); ACV inside
#                  the declared motion band; coverage = open qualified pipeline ÷ Σ quarter target
#                  ≥ (1 ÷ trailing win rate) × 1.2, 5× until 20 decided outcomes
#   win rate       < 10 % on ≥ 20 decided deals ⇒ violation (qualification review)
# All date comparisons run against guild_today (the ledger's "# as_of:" line pins fixtures).
#
# Policy env (defaults per brief 06; FX is policy — set from the BSP reference rate):
#   GUILD_STALE_WARN_DAYS=21  GUILD_STALE_FAIL_DAYS=45  GUILD_SLIP_MAX=2
#   GUILD_PRIMARY_SHARE_PCT=80  GUILD_COVERAGE_MULT=1.2  GUILD_COVERAGE_DEFAULT=5
#   GUILD_MIN_DECIDED=20  GUILD_WINRATE_FLOOR_PCT=10  GUILD_PILOT_MAX_DAYS=56
#   GUILD_PILOT_UNPAID_DAYS=60  GUILD_CASH_SLACK_DAYS=15  GUILD_FX_USD_PHP=58

gate_funnel() {
  local deals="${1:?usage: funnel <deals.csv|deals.tsv> [targets.tsv]}" targets="${2:-}"
  [[ -f "$deals" ]] || { echo "score-guild: funnel: missing deals ledger $deals" >&2; return 2; }
  [[ -z "$targets" || -f "$targets" ]] || { echo "score-guild: funnel: missing targets $targets" >&2; return 2; }
  local today sep="," hdr dj tj="[]" tab
  tab="$(printf '\t')"
  today="$(guild_today "$deals")"
  hdr="$(grep -v '^#' "$deals" | head -1)"
  [[ "$deals" == *.tsv || "$hdr" == *"$tab"* ]] && sep=$'\t'
  dj="$(guild_csv_json "$deals" "$sep")" || { echo "score-guild: funnel: cannot parse $deals" >&2; return 2; }
  if [[ -n "$targets" ]]; then
    local tsep="," thdr
    thdr="$(grep -v '^#' "$targets" | head -1)"
    [[ "$targets" == *.tsv || "$thdr" == *"$tab"* ]] && tsep=$'\t'
    tj="$(guild_csv_json "$targets" "$tsep")" || { echo "score-guild: funnel: cannot parse $targets" >&2; return 2; }
  fi
  local js
  js="$(cat <<'NODE'
let raw="";process.stdin.on("data",c=>raw+=c);process.stdin.on("end",()=>{try{main(JSON.parse(raw));}catch(e){console.error("funnel: "+e.message);process.exit(2);}});
function main(inp){
const A=process.argv.slice(1);
const today=A[0],STW=+A[1],STF=+A[2],SLIP=+A[3],PRIM=+A[4],CMULT=+A[5],CDEF=+A[6],MIND=+A[7],WFLOOR=+A[8],PMAX=+A[9],PUNPAID=+A[10],CASH=+A[11],FX=+A[12];
const deals=inp.deals||[],targets=inp.targets||[];
const D=s=>{const m=/^(20\d\d-\d\d-\d\d)/.exec(String(s||"").trim());if(!m)return null;const d=new Date(m[1]+"T00:00:00Z");return isNaN(d)?null:d;};
const days=(a,b)=>Math.round((b-a)/864e5);
const T=D(today);
const yes=v=>/^(y|yes|true|1)$/i.test(String(v||"").trim());
const num=v=>{const s=String(v==null?"":v).replace(/PHP|USD|[,₱$\s]/g,"");return s===""?NaN:Number(s);};
const RANK={lead:1,contacted:2,meeting:3,discovery:3,qualified:4,pilot:5,proposal:6,negotiation:7,verbal:7,won:9,lost:9,nurture:0,omitted:0};
const FC=["pipeline","best_case","commit","closed","omitted"];
const LOSS=["timing","need","budget","authority","feature","price","competition","no_decision","other"];
let n=0;
const V=(id,rule,msg)=>{n++;console.error("violation "+id+" ["+rule+"]: "+msg);};
const W=(id,rule,msg)=>console.error("warn "+id+" ["+rule+"]: "+msg);
if(!deals.length){console.error("funnel: 0 data rows (header-only ledger — a fresh venture starts clean)");console.log("FUNNEL_VIOLATIONS: 0");return;}
const have=new Set(Object.keys(deals[0]));
const EXPECT=["deal_id","segment","stage","amount_acv","forecast_category","next_action","next_action_date","last_activity_at","close_date_slips","economic_buyer_named","metrics_agreed","decision_process_doc","paper_process_started","pilot_metric","pilot_end_date","payment_terms_days","outcome","loss_reason"];
const missing=EXPECT.filter(c=>!have.has(c));
if(missing.length)console.error("funnel: note: columns absent, treated as empty: "+missing.join(","));
if(!have.has("deal_id")||!have.has("stage")){console.error("funnel: deals ledger has no deal_id/stage column");process.exit(2);}
const MOT=["self_serve","inbound","inside","field","founder_led","channel"];
const tmap={};const anyT=targets.length>0;
for(const t of targets){
  if(!t.segment)continue;
  const b=String(t.acv_band||"").match(/^([\d,]+)\s*[-–]\s*([\d,]+)$/);
  tmap[String(t.segment).trim()]={primary:yes(t.primary),target:num(t.quarter_target_php)||0,motion:String(t.motion||"").trim(),lo:b?num(b[1]):NaN,hi:b?num(b[2]):NaN};
  if(t.motion&&!MOT.includes(String(t.motion).trim()))V("targets:"+t.segment,"MOTION",'motion "'+t.motion+'" not in '+MOT.join("|"));
}
let won=0,lost=0,openTotal=0,primOpen=0,qualified=0;const seen=new Set();
for(let i=0;i<deals.length;i++){
  const d=deals[i];const id=d.deal_id||("row"+(i+2));
  if(seen.has(id))V(id,"DUP","duplicate deal_id");
  seen.add(id);
  const stage=String(d.stage||"").trim().toLowerCase();
  const rank=RANK[stage];
  if(rank===undefined){V(id,"STAGE",'unknown stage "'+(d.stage||"")+'" (lead|contacted|meeting|discovery|qualified|pilot|proposal|negotiation|won|lost|nurture|omitted)');continue;}
  let out=String(d.outcome||"").trim().toLowerCase();
  if(!out)out=stage==="won"?"won":stage==="lost"?"lost":"open";
  if((stage==="won"&&out!=="won")||(stage==="lost"&&out!=="lost")||(out==="won"&&stage!=="won")||(out==="lost"&&stage!=="lost"))V(id,"OUTCOME",'outcome "'+out+'" inconsistent with stage "'+stage+'"');
  if(out==="won")won++;
  if(out==="lost")lost++;
  const open=out==="open";
  const acv=num(d.amount_acv)||0;
  const fc=String(d.forecast_category||"").trim().toLowerCase();
  if(open){
    if(!fc||!FC.includes(fc))V(id,"FORECAST",'forecast_category "'+(d.forecast_category||"")+'" not in '+FC.join("|"));
    openTotal+=acv;
    if(rank>=4&&rank<=7)qualified+=acv;
    const seg=String(d.segment||"").trim();
    if(tmap[seg]&&tmap[seg].primary)primOpen+=acv;
    const nad=D(d.next_action_date);
    if(!nad)V(id,"NEXT-ACTION","no dated next step — downgrade one forecast category (HubSpot rule)");
    else if(nad<T)V(id,"NEXT-ACTION","next_action_date "+d.next_action_date+" is in the past ("+days(nad,T)+" d) — downgrade");
    else if(!String(d.next_action||"").trim())W(id,"NEXT-ACTION","next_action_date set but next_action text empty");
    const la=D(d.last_activity_at);
    if(!la)V(id,"STALE","no last_activity_at on an open deal");
    else{const age=days(la,T);
      if(age>STF)V(id,"STALE","no activity for "+age+" d (> "+STF+" d) — move to nurture/lost with loss_reason=no_decision");
      else if(age>STW)W(id,"STALE","no activity for "+age+" d (> "+STW+" d)");}
    if(rank>=6){
      const miss=[];
      if(!yes(d.economic_buyer_named))miss.push("economic buyer named (economic_buyer_named=Y)");
      if(!yes(d.metrics_agreed))miss.push("metrics agreed (metrics_agreed=Y)");
      if(!String(d.decision_process_doc||"").trim())miss.push("decision_process_doc");
      if(miss.length)V(id,"STAGE-EXIT","in "+stage+" without: "+miss.join("; ")+" (MEDDPICC stage-exit criteria)");
    }
    if(fc==="commit"&&!yes(d.paper_process_started))V(id,"STAGE-EXIT","forecast_category=commit without paper_process_started=Y");
    const slips=num(d.close_date_slips)||0;
    if(fc==="commit"&&slips>=SLIP)V(id,"SLIP","close_date_slips="+slips+" (>= "+SLIP+") while forecast_category=commit — slipped deals cut win rate; pull out of commit");
    const op=D(d.opened_at)||D(d.created_at);
    if(op){const age=days(op,T);const usd=FX>0?acv/FX:0;const band=usd<25000?90:(usd>100000?270:180);
      if(age>2*band)W(id,"CYCLE",age+" d in pipeline > 2x the "+band+"-d band for this ACV — disqualification review");}
    if(!seg)V(id,"SEGMENT","no segment tag on the deal");
    else if(anyT&&!tmap[seg])V(id,"SEGMENT",'segment "'+seg+'" not in targets (the GTM hypothesis)');
    else if(anyT&&tmap[seg]&&!isNaN(tmap[seg].lo)&&acv>0&&(acv<tmap[seg].lo||acv>tmap[seg].hi))V(id,"MOTION","amount_acv "+acv+" outside the declared ACV band "+tmap[seg].lo+"-"+tmap[seg].hi+" for motion "+tmap[seg].motion+" (Janz bands)");
  }
  if(open&&String(d.pilot_metric||"").trim()){
    const ps=D(d.pilot_start_date)||D(d.stage_entered_at);
    const pe=D(d.pilot_end_date);
    const price=(have.has("pilot_price_php")&&String(d.pilot_price_php||"").trim()!=="")?num(d.pilot_price_php):acv;
    if(!pe)V(id,"PILOT","pilot without pilot_end_date — metric, price and end date are fixed before start");
    else if(ps&&days(ps,pe)>PMAX)V(id,"PILOT","pilot runs "+days(ps,pe)+" d (> "+PMAX+" d / 8 weeks)");
    if(!(price>0))V(id,"PILOT","pilot price must be > 0 — free design partnerships are where 90 % of founders get stuck");
    const inv=D(d.invoice_date);
    if((!(price>0)||!inv)&&ps&&days(ps,T)>PUNPAID)V(id,"PILOT","unpaid pilot running "+days(ps,T)+" d (> "+PUNPAID+" d) — convert to paid or end it");
    if(pe&&pe<T)W(id,"PILOT","pilot ended "+days(pe,T)+" d ago and the deal is still open — hold the pre-scheduled review meeting");
  }
  const tw=String((d.tripwires!==undefined&&d.tripwires!==""?d.tripwires:d.clauses)||"").toLowerCase();
  if(tw){
    const hits=[];
    for(const c of["unlimited_liability","ip_transfer","exclusivity","auto_renew"])if(tw.indexOf(c)>=0||tw.indexOf(c.replace(/_/g," "))>=0||tw.indexOf(c.replace(/_/g,"-"))>=0)hits.push(c);
    if(hits.length&&!String(d.tripwire_reviewed_by||"").trim())V(id,"TRIPWIRE","contract tripwire "+hits.join(",")+" without tripwire_reviewed_by — company-ending clauses need human/legal review before signature");
  }
  if(out==="lost"){
    const lr=String(d.loss_reason||"").trim().toLowerCase();
    if(!LOSS.includes(lr))V(id,"LOSS-REASON",'lost without loss_reason in {'+LOSS.join(",")+'} (got "'+(d.loss_reason||"")+'")');
  }
  const inv=D(d.invoice_date),paid=D(d.paid_date);
  const terms=num(d.payment_terms_days)||0;
  if(inv&&paid){const lag=days(inv,paid);if(lag>terms+CASH)W(id,"CASH-IN","paid "+lag+" d after invoice (terms "+terms+" + "+CASH+" d slack)");}
  else if(inv&&!paid&&out!=="lost"){const age=days(inv,T);if(age>terms+CASH)W(id,"CASH-IN","invoice open "+age+" d (terms "+terms+" + "+CASH+" d) — dunning / collection step due");}
}
const decided=won+lost;const wr=decided>0?won/decided:0;
if(anyT){
  if(openTotal>0){const share=100*primOpen/openTotal;
    if(share<PRIM)V("ledger","PRIMARY","only "+share.toFixed(0)+" % of open pipeline value in the primary segment(s) (< "+PRIM+" %) — the motion is unfocused");}
  const target=Object.values(tmap).reduce((s,t)=>s+t.target,0);
  if(target>0){
    const req=decided>=MIND?(wr>0?(1/wr)*CMULT:Infinity):CDEF;
    const cov=qualified/target;
    if(cov<req)V("ledger","COVERAGE","open qualified pipeline "+qualified+" / quarter target "+target+" = "+cov.toFixed(2)+"x < required "+(req===Infinity?"inf":req.toFixed(2))+"x ("+(decided>=MIND?("1/win-rate x "+CMULT):(CDEF+"x until "+MIND+" decided outcomes"))+")");
  }
}
if(decided>=MIND&&100*wr<WFLOOR)V("ledger","WIN-RATE","trailing win rate "+(100*wr).toFixed(0)+" % on "+decided+" decided deals (< "+WFLOOR+" %) — qualification review, not more outbound");
console.error("funnel: rows="+deals.length+" open_value="+openTotal+" qualified_open="+qualified+" won="+won+" lost="+lost+" win_rate="+(decided?(100*wr).toFixed(0)+"%":"n/a"));
console.log("FUNNEL_VIOLATIONS: "+n);
}
NODE
)"
  printf '{"deals":%s,"targets":%s}' "$dj" "$tj" | node -e "$js" "$today" \
    "${GUILD_STALE_WARN_DAYS:-21}" "${GUILD_STALE_FAIL_DAYS:-45}" "${GUILD_SLIP_MAX:-2}" \
    "${GUILD_PRIMARY_SHARE_PCT:-80}" "${GUILD_COVERAGE_MULT:-1.2}" "${GUILD_COVERAGE_DEFAULT:-5}" \
    "${GUILD_MIN_DECIDED:-20}" "${GUILD_WINRATE_FLOOR_PCT:-10}" "${GUILD_PILOT_MAX_DAYS:-56}" \
    "${GUILD_PILOT_UNPAID_DAYS:-60}" "${GUILD_CASH_SLACK_DAYS:-15}" "${GUILD_FX_USD_PHP:-58}"
}
