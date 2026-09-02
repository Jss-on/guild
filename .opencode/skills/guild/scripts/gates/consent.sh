#!/usr/bin/env bash
# gate: consent — every outbound send joined to a live opt-in and a human approval.
#   score-guild.sh consent <consent.csv> <sends.csv>   → "CONSENT_VIOLATIONS: N"
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error
#
# consent.csv (human-entered): contact_id source timestamp consent_text_version purposes
#   channels evidence withdrawn_at
#   purposes/channels are ;-separated lists (channels ⊆ email|sms|viber|…)
# sends.csv (human-approved outreach/marketing log): send_id sequence_id template_id word_count
#   contact_id channel purpose sent_at human_approved_by human_approved_at follow_up_n
#   batch_size [planned_follow_ups]
#
# Checks (contract: references/metrics.md; doctrine: references/marketing-protocol.md §9):
#   approval      every send has human_approved_by AND human_approved_at ≤ sent_at — sends are
#                 human sign-off rows the loop never passes
#   consent join  marketing-purpose sends must join a consent row for that contact whose
#                 channels cover the send channel, purposes cover the send purpose, evidence is
#                 non-empty, timestamp ≤ sent_at, and that is not withdrawn before sent_at.
#                 Consent whose source is pre-ticked / continued_use / implied is NOT consent
#                 (NPC AO 2017-42) and never matches. Transactional sends need no consent row.
#                 purpose containing "basis: legitimate_interest" (1:1 founder outreach) is
#                 allowed but flagged on stderr — NPC guidance on B2B legitimate interest was
#                 not retrieved; default to consent.
#   SMS/Viber     require an explicit channel opt-in (legitimate interest never carries them)
#   word count    ≤ 100 words (Gong); ≤ 75 when template_id starts with "founder-" (YC)
#   batch size    ≤ GUILD_SEND_BATCH_MAX (50 — small batches reply ~3x better than 1,000+ blasts)
#   sequences     a sequence (non-empty sequence_id) plans ≥ 3 follow-ups (from
#                 planned_follow_ups, else observed once the sequence is ≥ 21 d old) and sends
#                 ≤ 11 attempts per contact (Bridge Group cadence ceiling)
# Dates compare against guild_today (the ledger's "# as_of:" line pins fixtures).
#
# Policy env: GUILD_SEND_BATCH_MAX=50 · GUILD_EMAIL_WORDS_MAX=100 · GUILD_FOUNDER_WORDS_MAX=75
#   · GUILD_FOLLOWUPS_MIN=3 · GUILD_ATTEMPTS_MAX=11 · GUILD_SEQ_AGE_DAYS=21

gate_consent() {
  local consent="${1:?usage: consent <consent.csv> <sends.csv>}"
  local sends="${2:?usage: consent <consent.csv> <sends.csv>}"
  [[ -f "$consent" ]] || { echo "score-guild: consent: missing consent ledger $consent" >&2; return 2; }
  [[ -f "$sends" ]] || { echo "score-guild: consent: missing sends ledger $sends" >&2; return 2; }
  local today cj sj
  today="$(guild_today "$sends")"
  cj="$(guild_csv_json "$consent")" || { echo "score-guild: consent: cannot parse $consent" >&2; return 2; }
  sj="$(guild_csv_json "$sends")" || { echo "score-guild: consent: cannot parse $sends" >&2; return 2; }
  local js
  js="$(cat <<'NODE'
let raw="";process.stdin.on("data",c=>raw+=c);process.stdin.on("end",()=>{try{main(JSON.parse(raw));}catch(e){console.error("consent: "+e.message);process.exit(2);}});
function main(inp){
const A=process.argv.slice(1);
const today=A[0],BATCH=+A[1],WMAX=+A[2],WFOUNDER=+A[3],FUMIN=+A[4],ATTMAX=+A[5],SEQAGE=+A[6];
const consents=inp.consent||[],sends=inp.sends||[];
const D=s=>{const m=/^(20\d\d-\d\d-\d\d)/.exec(String(s||"").trim());if(!m)return null;const d=new Date(m[1]+"T00:00:00Z");return isNaN(d)?null:d;};
const days=(a,b)=>Math.round((b-a)/864e5);
const T=D(today);
const num=v=>{const s=String(v==null?"":v).replace(/[,\s]/g,"");return s===""?NaN:Number(s);};
const list=v=>String(v||"").toLowerCase().split(/[;|\/ ]+/).map(x=>x.trim()).filter(Boolean);
let n=0;
const V=(id,rule,msg)=>{n++;console.error("violation "+id+" ["+rule+"]: "+msg);};
const W=(id,rule,msg)=>console.error("warn "+id+" ["+rule+"]: "+msg);
const INVALID_SOURCE=/pre.?ticked|continued.?use|implied|inferred|purchased|scraped|assumed/i;
// consent ledger index + ledger-level checks
const byContact={};
for(let i=0;i<consents.length;i++){
  const c=consents[i];const cid=String(c.contact_id||"").trim();
  const rid=cid||("consent-row"+(i+2));
  if(!cid){V(rid,"SCHEMA","consent row without contact_id");continue;}
  if(INVALID_SOURCE.test(String(c.source||"")))V(rid,"CONSENT-INVALID",'consent source "'+c.source+'" is not consent — NPC AO 2017-42: continued use, pre-ticked boxes and implied consent are insufficient');
  if(!String(c.evidence||"").trim())V(rid,"CONSENT-EVIDENCE","consent row without evidence (form id / screenshot / recording) — unevidenced consent is unprovable");
  (byContact[cid]=byContact[cid]||[]).push(c);
}
const MARKETING=/(marketing|newsletter|promo|nurture|event|announce|broadcast|campaign)/i;
const TRANSACTIONAL=/(transactional|service|invoice|receipt|support|delivery|account)/i;
const LI=/basis:\s*legitimate_interest/i;
const seen=new Set();const sq={};
for(let i=0;i<sends.length;i++){
  const s=sends[i];const id=s.send_id||("row"+(i+2));
  if(seen.has(id))V(id,"DUP","duplicate send_id");
  seen.add(id);
  const sent=D(s.sent_at);
  if(!sent)V(id,"SCHEMA","no parseable sent_at");
  if(!String(s.human_approved_by||"").trim())V(id,"APPROVAL","no human_approved_by — every send is a human sign-off row the loop never passes");
  else{
    const ap=D(s.human_approved_at);
    if(!ap)V(id,"APPROVAL","no human_approved_at");
    else if(sent&&ap>sent)V(id,"APPROVAL","human_approved_at "+s.human_approved_at+" is after sent_at "+s.sent_at+" — approval comes before the send");
  }
  const ch=String(s.channel||"").trim().toLowerCase();
  const purpose=String(s.purpose||"").trim();
  const wc=num(s.word_count);
  const founder=/^founder-/i.test(String(s.template_id||"").trim());
  const wlimit=founder?WFOUNDER:WMAX;
  if(!isNaN(wc)&&wc>wlimit)V(id,"WORDS","word_count "+wc+" > "+wlimit+(founder?" (founder-* templates cap at "+WFOUNDER+" words — YC)":" (best replies at 100 words or fewer — Gong)"));
  const batch=num(s.batch_size);
  if(!isNaN(batch)&&batch>BATCH)V(id,"BATCH","batch_size "+batch+" > GUILD_SEND_BATCH_MAX "+BATCH+" — sub-50 batches reply ~3x better than 1,000+ blasts");
  const contact=String(s.contact_id||"").trim();
  const cls=LI.test(purpose)?"li":(TRANSACTIONAL.test(purpose)?"transactional":(MARKETING.test(purpose)||!purpose?"marketing":"marketing"));
  if(cls==="li"){
    W(id,"LEGITIMATE-INTEREST","1:1 founder outreach on basis: legitimate_interest to "+contact+" — NPC guidance not retrieved; keep it 1:1, honour opt-outs, default to consent");
    if(ch==="sms"||ch==="viber")V(id,"CHANNEL-OPTIN",ch+" send on legitimate interest — SMS/Viber require an explicit channel opt-in");
    const rowsC=byContact[contact]||[];
    for(const c of rowsC){const wd=D(c.withdrawn_at);if(wd&&sent&&wd<=sent){V(id,"WITHDRAWN","send to "+contact+" after consent withdrawn "+c.withdrawn_at+" — withdrawn contacts are never sent");break;}}
  } else if(cls==="marketing"){
    const rowsC=byContact[contact]||[];
    if(!rowsC.length)V(id,"CONSENT","marketing "+ch+" send to "+contact+" with no opt-in consent row");
    else{
      let ok=false;const reasons=[];
      for(const c of rowsC){
        if(INVALID_SOURCE.test(String(c.source||""))){reasons.push('source "'+c.source+'" invalid (NPC AO 2017-42)');continue;}
        if(!list(c.channels).includes(ch)){reasons.push("channels="+(c.channels||"")+" does not cover "+ch);continue;}
        const purps=list(c.purposes);
        const ptok=(purpose.toLowerCase().match(/[a-z_]+/)||["marketing"])[0];
        if(!(purps.includes(ptok)||purps.includes("marketing")||purps.includes("all"))){reasons.push("purposes="+(c.purposes||"")+" does not cover "+ptok);continue;}
        if(!String(c.evidence||"").trim()){reasons.push("no evidence on the consent row");continue;}
        const ts=D(c.timestamp);
        if(ts&&sent&&ts>sent){reasons.push("consent recorded "+c.timestamp+" after the send");continue;}
        if((ch==="sms"||ch==="viber")&&/legitimate/i.test(String(c.source||""))){reasons.push("SMS/Viber need an explicit opt-in, not legitimate interest");continue;}
        const wd=D(c.withdrawn_at);
        if(wd&&sent&&wd<=sent){reasons.push("withdrawn "+c.withdrawn_at+" before the send");continue;}
        ok=true;break;
      }
      if(!ok)V(id,"CONSENT","marketing "+ch+" send to "+contact+" has no live consent: "+reasons.join("; "));
    }
  }
  // transactional: no consent join required
  const sid=String(s.sequence_id||"").trim();
  if(sid){
    const q=sq[sid]=sq[sid]||{first:null,maxFu:0,planned:NaN,per:{}};
    if(sent&&(!q.first||sent<q.first))q.first=sent;
    const fu=num(s.follow_up_n);if(!isNaN(fu))q.maxFu=Math.max(q.maxFu,fu);
    const p=num(s.planned_follow_ups);if(!isNaN(p))q.planned=isNaN(q.planned)?p:Math.max(q.planned,p);
    if(contact)q.per[contact]=(q.per[contact]||0)+1;
  }
}
for(const sid of Object.keys(sq)){
  const q=sq[sid];
  const plannedGiven=!isNaN(q.planned);
  const planned=plannedGiven?q.planned:q.maxFu;
  const aged=q.first&&T&&days(q.first,T)>=SEQAGE;
  if((plannedGiven||aged)&&planned<FUMIN)V(sid,"FOLLOW-UPS","sequence plans "+planned+" follow-up(s) (< "+FUMIN+") — 3–4 touches over ~2 weeks is the floor; 42 % of replies come from follow-ups");
  for(const c of Object.keys(q.per))if(q.per[c]>ATTMAX)V(sid,"ATTEMPTS",q.per[c]+" attempts to "+c+" (> "+ATTMAX+") — stop and mark no_response");
}
console.error("consent: consent_rows="+consents.length+" sends="+sends.length+" sequences="+Object.keys(sq).length);
console.log("CONSENT_VIOLATIONS: "+n);
}
NODE
)"
  printf '{"consent":%s,"sends":%s}' "$cj" "$sj" | node -e "$js" "$today" \
    "${GUILD_SEND_BATCH_MAX:-50}" "${GUILD_EMAIL_WORDS_MAX:-100}" "${GUILD_FOUNDER_WORDS_MAX:-75}" \
    "${GUILD_FOLLOWUPS_MIN:-3}" "${GUILD_ATTEMPTS_MAX:-11}" "${GUILD_SEQ_AGE_DAYS:-21}"
}
