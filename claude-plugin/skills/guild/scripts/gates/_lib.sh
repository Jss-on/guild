#!/usr/bin/env bash
# scripts/gates/_lib.sh — helpers shared by gate_<name>() implementations. Sourced by
# score-guild.sh before the gates (files sort first because of the underscore).
#
#   guild_today [ledger]        → YYYY-MM-DD used for every staleness / deadline check:
#                                 $GUILD_TODAY if set, else a "# as_of: YYYY-MM-DD" comment line
#                                 in <ledger>, else the system date. Fixtures ALWAYS carry
#                                 "# as_of:" so the frozen scorer never decays with the calendar.
#   guild_days_between A B      → integer days from A to B (both YYYY-MM-DD; negative if B < A)
#   guild_yaml_json <file>      → JSON on stdout. YAML subset: block mappings, block sequences,
#                                 "- key: value" item maps, flow {a: 1, b: x} and [a, b], quoted
#                                 strings, numbers, booleans, null, # comments. No anchors,
#                                 multi-line scalars (| >) or tags.
#   guild_csv_json <file> [sep] → JSON array of row objects (header row → keys; RFC 4180 quotes;
#                                 lines starting with # skipped). sep defaults to "," — pass
#                                 $'\t' for TSV.
#   guild_json_query <json> <js-expr>
#                               → evaluates a JS expression over `d` (the parsed JSON) with node
#                                 and prints the result (objects/arrays as JSON, scalars raw).
#
# Gates keep their one-line stdout contract; helpers write nothing to stdout except their result.

guild_today() {
  local ledger="${1:-}" d=""
  if [[ -n "${GUILD_TODAY:-}" ]]; then printf '%s\n' "$GUILD_TODAY"; return 0; fi
  if [[ -n "$ledger" && -f "$ledger" ]]; then
    d="$(grep -m1 -oE '^#[[:space:]]*as_of:[[:space:]]*20[0-9]{2}-[0-9]{2}-[0-9]{2}' "$ledger" 2>/dev/null | grep -oE '20[0-9]{2}-[0-9]{2}-[0-9]{2}')"
  fi
  [[ -n "$d" ]] && { printf '%s\n' "$d"; return 0; }
  date +%Y-%m-%d
}

guild_days_between() { # A B → B - A in days
  node -e 'const a=new Date(process.argv[1]+"T00:00:00Z"),b=new Date(process.argv[2]+"T00:00:00Z");if(isNaN(a)||isNaN(b)){console.log("NaN");process.exit(0)}console.log(Math.round((b-a)/86400000))' "$1" "$2"
}

guild_yaml_json() {
  local f="${1:?usage: guild_yaml_json <file>}"
  [[ -f "$f" ]] || { echo "guild_yaml_json: missing $f" >&2; return 2; }
  node -e '
const fs=require("fs");
const raw=fs.readFileSync(process.argv[1],"utf8").replace(/\r\n?/g,"\n").split("\n");
function stripComment(s){let q=null,out="";for(let i=0;i<s.length;i++){const c=s[i];if(q){out+=c;if(c===q)q=null;continue;}if(c==="\""||c==="\x27"){q=c;out+=c;continue;}if(c==="#"&&(i===0||/\s/.test(s[i-1])))break;out+=c;}return out.replace(/\s+$/,"");}
const lines=[];for(const r of raw){const t=stripComment(r);if(t.trim()==="")continue;if(t.trim()==="---")continue;const indent=t.match(/^ */)[0].length;lines.push({indent,text:t.trim()});}
function splitTop(s,sep){const parts=[];let depth=0,q=null,cur="";for(const c of s){if(q){cur+=c;if(c===q)q=null;continue;}if(c==="\""||c==="\x27"){q=c;cur+=c;continue;}if(c==="{"||c==="[")depth++;if(c==="}"||c==="]")depth--;if(c===sep&&depth===0){parts.push(cur);cur="";continue;}cur+=c;}if(cur.trim()!=="")parts.push(cur);return parts;}
function scalar(s){s=s.trim();if(s==="")return null;if((s[0]==="\""&&s[s.length-1]==="\"")||(s[0]==="\x27"&&s[s.length-1]==="\x27"))return s.slice(1,-1);if(s==="true")return true;if(s==="false")return false;if(s==="null"||s==="~")return null;if(/^-?\d+(\.\d+)?$/.test(s))return Number(s);if(s[0]==="{"){const inner=s.slice(1,s.lastIndexOf("}"));const o={};for(const p of splitTop(inner,",")){const i=p.indexOf(":");if(i<0)continue;o[p.slice(0,i).trim()]=scalar(p.slice(i+1));}return o;}if(s[0]==="["){const inner=s.slice(1,s.lastIndexOf("]"));return splitTop(inner,",").map(scalar);}return s;}
function parseBlock(i,indent){const l=lines[i];if(!l)return[null,i];if(l.text==="-"||l.text.startsWith("- "))return parseSeq(i,l.indent);return parseMap(i,l.indent);}
function parseMap(i,indent){const o={};while(i<lines.length){const l=lines[i];if(l.indent<indent)break;if(l.indent>indent)throw new Error("bad indent at line "+(i+1)+": "+l.text);if(l.text==="-"||l.text.startsWith("- "))break;const m=l.text.match(/^([^:]+?):(?:\s+(.*))?$/);if(!m)throw new Error("expected key: at line "+(i+1)+": "+l.text);const key=m[1].trim().replace(/^["\x27]|["\x27]$/g,"");const rest=(m[2]||"").trim();if(rest===""){const n=lines[i+1];if(n&&n.indent>indent){const[v,j]=parseBlock(i+1,n.indent);o[key]=v;i=j;}else if(n&&n.indent===indent&&(n.text==="-"||n.text.startsWith("- "))){const[v,j]=parseSeq(i+1,indent);o[key]=v;i=j;}else{o[key]=null;i++;}}else{o[key]=scalar(rest);i++;}}return[o,i];}
function parseSeq(i,indent){const a=[];while(i<lines.length){const l=lines[i];if(l.indent!==indent||!(l.text==="-"||l.text.startsWith("- ")))break;const rest=l.text.slice(1).trim();if(rest===""){const n=lines[i+1];if(n&&n.indent>indent){const[v,j]=parseBlock(i+1,n.indent);a.push(v);i=j;}else{a.push(null);i++;}}else if(/^[^:{\[\"\x27]+:(\s|$)/.test(rest)){lines[i]={indent:indent+2,text:rest};const[v,j]=parseMap(i,indent+2);a.push(v);i=j;}else{a.push(scalar(rest));i++;}}return[a,i];}
try{const[v]=lines.length?parseBlock(0,lines[0].indent):[{}];process.stdout.write(JSON.stringify(v));}catch(e){console.error("guild_yaml_json: "+e.message);process.exit(2);}
' "$f"
}

guild_csv_json() {
  local f="${1:?usage: guild_csv_json <file> [sep]}" sep="${2:-,}"
  [[ -f "$f" ]] || { echo "guild_csv_json: missing $f" >&2; return 2; }
  node -e '
const fs=require("fs");const sep=process.argv[2];
const txt=fs.readFileSync(process.argv[1],"utf8").replace(/\r\n?/g,"\n");
const rows=[];let row=[],cur="",q=false;
for(let i=0;i<txt.length;i++){const c=txt[i];if(q){if(c==="\""){if(txt[i+1]==="\""){cur+="\"";i++;}else q=false;}else cur+=c;continue;}if(c==="\""){q=true;continue;}if(c===sep){row.push(cur);cur="";continue;}if(c==="\n"){row.push(cur);rows.push(row);row=[];cur="";continue;}cur+=c;}
if(cur!==""||row.length)row.push(cur),rows.push(row);
const data=rows.filter(r=>!(r.length===1&&r[0].trim()==="")&&!(r[0]||"").startsWith("#"));
if(!data.length){process.stdout.write("[]");process.exit(0);}
const hdr=data[0].map(h=>h.trim());
const out=data.slice(1).map(r=>{const o={};hdr.forEach((h,k)=>o[h]=(r[k]===undefined?"":r[k]).trim());return o;});
process.stdout.write(JSON.stringify(out));
' "$f" "$sep"
}

guild_json_query() { # <json-string> <js-expr over d>
  node -e 'const d=JSON.parse(process.argv[1]);const r=eval(process.argv[2]);process.stdout.write(typeof r==="object"?JSON.stringify(r):String(r));' "$1" "$2"
}
