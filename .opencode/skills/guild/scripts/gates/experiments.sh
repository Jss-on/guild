#!/usr/bin/env bash
# gate: experiments — growth-experiment discipline over marketing/experiments.csv.
#   score-guild.sh experiments <experiments.csv>   → "EXPERIMENT_VIOLATIONS: N"
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error
#
# Columns (brief 07 §5 + pre-registration pair):
#   id opened owner funnel_stage channel hypothesis primary_metric baseline target_threshold
#   mde_rel alpha power required_n_per_arm min_duration_days ice_impact ice_confidence
#   ice_evidence_ref ice_ease rice_reach rice_effort_pm budget_php approved_by
#   preregistered_at started_at status actual_n elapsed_days observed ci_or_p verdict
#   learning next_action
#
# Checks (contract: references/metrics.md; doctrine: references/marketing-protocol.md):
#   hypothesis   must match "If we [change] for [ICP], [metric] moves from [baseline] to
#                [target] because [assumption]" with numeric baseline/target that agree with
#                the baseline / target_threshold columns
#   required n   for proportion metrics (baseline/target in (0,1) or % in the hypothesis) the
#                gate computes n per arm with the standard two-proportion formula from
#                baseline + mde_rel at the row's alpha (default 0.05) and power (default 0.8),
#                floored by Evan Miller's n ≈ 16·sigma^2/delta^2; a stated required_n_per_arm
#                below the computed value is a violation
#   verdict      WIN|LOSE only when actual_n ≥ required n AND elapsed_days ≥ min_duration_days
#                (≥ 7 d) — otherwise the row must read INCONCLUSIVE (peeking turns a nominal
#                5 % significance level into 26.1 % false positives — Evan Miller)
#   ICE          ice_confidence > 5 requires a non-empty ice_evidence_ref
#   spend        status running|done requires approved_by (human) and
#                budget_php ≤ GUILD_EXPERIMENT_CAP
#   preregister  preregistered_at strictly before started_at
# Dates compare against guild_today (the ledger's "# as_of:" line pins fixtures).
#
# Policy env: GUILD_EXPERIMENT_CAP=50000 (PHP; policy — a founder-level discretionary cap,
#   override per venture) · GUILD_MIN_DURATION_FLOOR=7 (one full business cycle)

gate_experiments() {
  local file="${1:?usage: experiments <experiments.csv>}"
  [[ -f "$file" ]] || { echo "score-guild: experiments: missing ledger $file" >&2; return 2; }
  local today ej
  today="$(guild_today "$file")"
  ej="$(guild_csv_json "$file")" || { echo "score-guild: experiments: cannot parse $file" >&2; return 2; }
  local js
  js="$(cat <<'NODE'
let raw="";process.stdin.on("data",c=>raw+=c);process.stdin.on("end",()=>{try{main(JSON.parse(raw));}catch(e){console.error("experiments: "+e.message);process.exit(2);}});
function zq(p){
  const a=[-3.969683028665376e+01,2.209460984245205e+02,-2.759285104469687e+02,1.383577518672690e+02,-3.066479806614716e+01,2.506628277459239e+00];
  const b=[-5.447609879822406e+01,1.615858368580409e+02,-1.556989798598866e+02,6.680131188771972e+01,-1.328068155288572e+01];
  const c=[-7.784894002430293e-03,-3.223964580411365e-01,-2.400758277161838e+00,-2.549732539343734e+00,4.374664141464968e+00,2.938163982698783e+00];
  const d=[7.784695709041462e-03,3.224671290700398e-01,2.445134137142996e+00,3.754408661907416e+00];
  const pl=0.02425,ph=1-pl;let q,r;
  if(p<pl){q=Math.sqrt(-2*Math.log(p));return(((((c[0]*q+c[1])*q+c[2])*q+c[3])*q+c[4])*q+c[5])/((((d[0]*q+d[1])*q+d[2])*q+d[3])*q+1);}
  if(p>ph){q=Math.sqrt(-2*Math.log(1-p));return-(((((c[0]*q+c[1])*q+c[2])*q+c[3])*q+c[4])*q+c[5])/((((d[0]*q+d[1])*q+d[2])*q+d[3])*q+1);}
  q=p-0.5;r=q*q;return(((((a[0]*r+a[1])*r+a[2])*r+a[3])*r+a[4])*r+a[5])*q/(((((b[0]*r+b[1])*r+b[2])*r+b[3])*r+b[4])*r+1);
}
function nPerArm(p1,mde,alpha,power){
  const p2=p1*(1+mde),dl=p2-p1;
  if(!(p1>0&&p1<1&&p2>0&&p2<1)||dl===0)return NaN;
  const pbar=(p1+p2)/2,za=zq(1-alpha/2),zb=zq(power);
  const std=Math.pow(za*Math.sqrt(2*pbar*(1-pbar))+zb*Math.sqrt(p1*(1-p1)+p2*(1-p2)),2)/(dl*dl);
  const miller=16*p1*(1-p1)/(dl*dl);
  return Math.ceil(Math.max(std,miller));
}
function main(rows){
const A=process.argv.slice(1);
const today=A[0],CAP=+A[1],MINFLOOR=+A[2];
const D=s=>{const m=/^(20\d\d-\d\d-\d\d)/.exec(String(s||"").trim());if(!m)return null;const d=new Date(m[1]+"T00:00:00Z");return isNaN(d)?null:d;};
const num=v=>{const s=String(v==null?"":v).replace(/PHP|[,₱%\s]/g,"");return s===""?NaN:Number(s);};
let n=0;
const V=(id,rule,msg)=>{n++;console.error("violation "+id+" ["+rule+"]: "+msg);};
const W=(id,rule,msg)=>console.error("warn "+id+" ["+rule+"]: "+msg);
const STATUS=["planned","running","done","killed","paused"];
const seen=new Set();
for(let i=0;i<rows.length;i++){
  const r=rows[i];const id=r.id||("row"+(i+2));
  if(seen.has(id))V(id,"DUP","duplicate id");
  seen.add(id);
  const status=String(r.status||"").trim().toLowerCase();
  if(status&&!STATUS.includes(status))V(id,"STATUS",'status "'+r.status+'" not in '+STATUS.join("|"));
  const hyp=String(r.hypothesis||"").trim();
  const m=hyp.match(/^if we (.+?) for (.+?),\s*(.+?) moves? from ([0-9]+(?:\.[0-9]+)?)\s?(%?) to ([0-9]+(?:\.[0-9]+)?)\s?(%?) because (.+)$/i);
  if(!m)V(id,"HYPOTHESIS",'hypothesis does not match "If we [change] for [ICP], [metric] moves from [baseline] to [target] because [assumption]" (got "'+hyp.slice(0,70)+'")');
  const b=num(r.baseline),t=num(r.target_threshold);
  if(isNaN(b)||isNaN(t))V(id,"HYPOTHESIS","baseline / target_threshold must be numeric (got \""+(r.baseline||"")+"\" / \""+(r.target_threshold||"")+"\")");
  const close=(x,y)=>Math.abs(x-y)<=1e-9||Math.abs(x/100-y)<=1e-9;
  if(m&&!isNaN(b)&&!close(Number(m[4]),b))V(id,"HYPOTHESIS","hypothesis baseline "+m[4]+m[5]+" does not equal the baseline column "+r.baseline);
  if(m&&!isNaN(t)&&!close(Number(m[6]),t))V(id,"HYPOTHESIS","hypothesis target "+m[6]+m[7]+" does not equal the target_threshold column "+r.target_threshold);
  const alpha=isNaN(num(r.alpha))?0.05:num(r.alpha);
  const power=isNaN(num(r.power))?0.8:num(r.power);
  const pct=m&&(m[5]==="%"||m[7]==="%");
  const bp=(b>1&&(pct||b<=100))?b/100:b;
  const tp=(t>1&&(pct||t<=100))?t/100:t;
  let mde=num(r.mde_rel);
  if(isNaN(mde)&&bp>0&&!isNaN(tp))mde=(tp-bp)/bp;
  if(!isNaN(num(r.mde_rel))&&bp>0&&!isNaN(tp)&&Math.abs(bp*(1+num(r.mde_rel))-tp)>0.002)W(id,"MDE","mde_rel "+r.mde_rel+" inconsistent with baseline -> target ("+bp+" -> "+tp+")");
  const stated=num(r.required_n_per_arm);
  const proportion=bp>0&&bp<1&&tp>0&&tp<1;
  let comp=NaN;
  if(proportion&&isFinite(mde)&&mde!==0)comp=nPerArm(bp,mde,alpha,power);
  if(!isNaN(comp)){
    if(isNaN(stated)||stated<comp)V(id,"REQUIRED-N","required_n_per_arm "+(isNaN(stated)?"(empty)":stated)+" < computed "+comp+" per arm (two-proportion at baseline "+bp+", MDE "+(mde*100).toFixed(1)+" % rel, alpha="+alpha+", power="+power+"; Miller 16s^2/d^2 floor included)");
  } else if(isNaN(stated)||stated<=0)V(id,"REQUIRED-N","required_n_per_arm missing and not computable from baseline/mde_rel — pre-register a sample size");
  const minDur=num(r.min_duration_days);
  if(isNaN(minDur)||minDur<MINFLOOR)V(id,"MIN-DURATION","min_duration_days "+(r.min_duration_days||"(empty)")+" < "+MINFLOOR+" (one full business cycle)");
  const v=String(r.verdict||"").trim().toUpperCase();
  if(v&&!["WIN","LOSE","INCONCLUSIVE"].includes(v))V(id,"VERDICT",'verdict "'+r.verdict+'" not in WIN|LOSE|INCONCLUSIVE');
  const an=isNaN(num(r.actual_n))?0:num(r.actual_n);
  const el=isNaN(num(r.elapsed_days))?0:num(r.elapsed_days);
  const need=Math.max(isNaN(stated)?0:stated,isNaN(comp)?0:comp);
  if(v==="WIN"||v==="LOSE"){
    if(need>0&&an<need)V(id,"VERDICT","verdict "+v+" with actual_n "+an+" < required_n "+need+" — must be INCONCLUSIVE (peeking turns 5 % significance into 26.1 % false positives)");
    const floor=Math.max(isNaN(minDur)?0:minDur,MINFLOOR);
    if(el<floor)V(id,"VERDICT","verdict "+v+" at "+el+" elapsed days < min duration "+floor+" — must be INCONCLUSIVE");
  }
  if(status==="done"&&!v)V(id,"VERDICT","status=done without a verdict");
  const conf=num(r.ice_confidence);
  if(conf>5&&!String(r.ice_evidence_ref||"").trim())V(id,"ICE","ice_confidence "+conf+" > 5 without ice_evidence_ref — confidence above the midpoint is a claim of evidence; show it");
  const bud=isNaN(num(r.budget_php))?0:num(r.budget_php);
  const pre=D(r.preregistered_at),st=D(r.started_at);
  if(status==="running"||status==="done"){
    if(!String(r.approved_by||"").trim())V(id,"APPROVAL","status="+status+" without approved_by — spend and launch are human sign-off rows the loop never passes");
    if(bud>CAP)V(id,"BUDGET","budget_php "+bud+" > GUILD_EXPERIMENT_CAP "+CAP);
    if(!pre||!st)V(id,"PREREG","status="+status+" without preregistered_at/started_at — pre-register before you start");
    else if(!(pre<st))V(id,"PREREG","preregistered_at "+r.preregistered_at+" is not before started_at "+r.started_at+" — pre-register before you start");
  } else {
    if(pre&&st&&!(pre<st))V(id,"PREREG","preregistered_at "+r.preregistered_at+" is not before started_at "+r.started_at);
    if(bud>CAP)W(id,"BUDGET","planned budget_php "+bud+" > cap "+CAP+" — will be blocked at running");
  }
}
console.error("experiments: rows="+rows.length);
console.log("EXPERIMENT_VIOLATIONS: "+n);
}
NODE
)"
  printf '%s' "$ej" | node -e "$js" "$today" "${GUILD_EXPERIMENT_CAP:-50000}" "${GUILD_MIN_DURATION_FLOOR:-7}"
}
