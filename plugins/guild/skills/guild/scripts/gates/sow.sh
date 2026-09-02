#!/usr/bin/env bash
# gate: sow — statement-of-work completeness lint (brief 08 §5.1; references/operations-protocol.md §2).
#   score-guild.sh sow <sow.md>   → "SOW_MISSING: N"   (every missing field / broken rule → stderr)
#   exit 0 on well-formed input (N > 0 is valid data) · 2 hard error (missing file)
#
# Lintable SOW format (markdown):
#   scalar fields = `key: value` lines anywhere in the file (first match wins; a leading "- " is fine):
#     msa_reference · engagement_type (software|firmware|hardware|mixed|service|repair|service_repair)
#     · review_window_days · deposit_pct · warranty_days · support_sla_reference ("none" allowed)
#     · liability_cap · change_control_reference
#   block fields = `## key` sections (heading text starts with the key, case-insensitive, spaces and
#   hyphens read as underscores; body runs to the next heading):
#     scope_in · deliverables · acceptance_criteria · review_window · assumptions_client_dependencies
#     · out_of_scope · milestones · payment_schedule · ip_ownership · warranty · key_personnel
#     · termination   (liability_cap, support_sla and change_control may be sections instead of lines)
#   A first line "# as_of: YYYY-MM-DD" is ignored by the linter.
# Rules (each breach = +1 on SOW_MISSING):
#   all 18 fields present · deliverables state a format · out_of_scope says further work "requires a
#   change order" · review_window_days ≥ 1 AND a "deemed accepted" sentence exists · milestones carry
#   M-<n> ids · every payment line (list item / table row carrying a number) names an M-<n> id — a
#   payment tied to a calendar date is the classic defect (cash arrives whether or not work shipped)
#   · deposit_pct ≥ GUILD_SOW_DEPOSIT_MIN (20) · ip_ownership mentions assignment AND background IP
#   · warranty_days ≥ GUILD_SOW_WARRANTY_MIN (30); ≥ GUILD_SOW_SERVICE_WARRANTY_MIN (90) when
#     engagement_type is service/repair (RA 7394 Art. 71) · termination names a cure period and
#     termination for convenience · "No Return, No Exchange" anywhere → violation (DAO 2 s.1993)
# Policy defaults come from brief 08 §3/§5.4 (deposit 20–50 %, review window 5 BD, software
# warranty 30–90 d, service guaranty ≥ 90 d); override with the GUILD_SOW_* variables.

gate_sow() {
  local file="${1:?usage: sow <sow.md>}"
  [[ -f "$file" ]] || { echo "score-guild: sow: missing file $file" >&2; return 2; }
  awk -v depmin="${GUILD_SOW_DEPOSIT_MIN:-20}" -v wmin="${GUILD_SOW_WARRANTY_MIN:-30}" \
      -v svcmin="${GUILD_SOW_SERVICE_WARRANTY_MIN:-90}" '
    function viol(msg) { print msg > "/dev/stderr"; V++ }
    function firstnum(s) { if (match(s, /[0-9]+(\.[0-9]+)?/)) return substr(s, RSTART, RLENGTH) + 0; return "" }
    function norm(s) {                       # heading text → key token (lower, snake, no numbering)
      s = tolower(s); sub(/^[[:space:]]*[0-9]+[.)]?[[:space:]]*/, "", s)
      gsub(/[^a-z0-9]+/, "_", s); sub(/^_+/, "", s); sub(/_+$/, "", s); return s
    }
    function section_of(k,   i) {            # longest known section key the heading starts with
      for (i = 1; i <= nsec; i++) if (k == SEC[i] || index(k, SEC[i] "_") == 1) return SEC[i]
      if (k == "scope" || index(k, "scope_") == 1) return "scope_in"
      if (index(k, "assumptions") == 1) return "assumptions_client_dependencies"
      if (index(k, "payment") == 1) return "payment_schedule"
      if (k == "ip" || index(k, "ip_") == 1 || index(k, "intellectual_property") == 1) return "ip_ownership"
      if (index(k, "personnel") == 1) return "key_personnel"
      if (k == "sla" || index(k, "sla_") == 1) return "support_sla"
      if (index(k, "change_order") == 1) return "change_control"
      if (index(k, "acceptance") == 1) return "acceptance_criteria"
      return ""
    }
    function sec(name) {                     # section present with a non-empty body?
      if (!H[name]) { viol("missing section: " name); return 0 }
      return 1
    }
    function hasdate(s) {
      return (s ~ /[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/ ||
              tolower(s) ~ /(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.? [0-9][0-9]?(st|nd|rd|th)?([ ,]|$)/ ||
              tolower(s) ~ /[0-9][0-9]? (jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)/)
    }
    BEGIN {
      nsec = split("scope_in deliverables acceptance_criteria review_window assumptions_client_dependencies out_of_scope change_control milestones payment_schedule ip_ownership warranty support_sla key_personnel termination liability_cap", SEC, " ")
      nline = split("msa_reference engagement_type review_window_days deposit_pct warranty_days support_sla_reference liability_cap change_control_reference", LK, " ")
      for (i = 1; i <= nline; i++) LOK[LK[i]] = 1
      cur = ""; V = 0; npay = 0
    }
    { sub(/\r$/, "") }
    /^#[[:space:]]*as_of:/ { next }
    /^[[:space:]]*#{1,6}[[:space:]]+/ {
      t = $0; sub(/^[[:space:]]*#+[[:space:]]+/, "", t)
      cur = section_of(norm(t)); next
    }
    {
      ALL = ALL "\n" $0
      if (cur != "" && $0 !~ /^[[:space:]]*$/) { H[cur] = 1; B[cur] = B[cur] "\n" $0 }
      if (cur == "payment_schedule") {
        if (($0 ~ /^[[:space:]]*([-*+]|[0-9]+[.)])[[:space:]]/ || $0 ~ /^[[:space:]]*\|/) && $0 ~ /[0-9]/ && $0 !~ /^[[:space:]]*\|[[:space:]:|-]*$/)
          PAY[++npay] = $0
      }
      if (match($0, /^[[:space:]]*(- )?[a-z_]+[[:space:]]*:/)) {
        k = substr($0, RSTART, RLENGTH); sub(/^[[:space:]]*(- )?/, "", k); sub(/[[:space:]]*:$/, "", k)
        if ((k in LOK) && !(k in L)) { v = substr($0, RSTART + RLENGTH); sub(/^[[:space:]]+/, "", v); sub(/[[:space:]]+$/, "", v); if (v != "") L[k] = v }
      }
    }
    END {
      all = tolower(ALL)
      if (!("msa_reference" in L)) viol("missing msa_reference: (legal terms live in the MSA; the SOW carries commercial terms only)")
      et = ("engagement_type" in L) ? tolower(L["engagement_type"]) : ""
      if (et == "") viol("missing engagement_type: (software|firmware|hardware|mixed|service|repair|service_repair) — it selects the warranty floor")
      else if (et !~ /^(software|firmware|hardware|mixed|service|repair|service_repair)$/) viol("unknown engagement_type \"" et "\"")
      sec("scope_in")
      if (sec("deliverables") && tolower(B["deliverables"]) !~ /format/) viol("deliverables: no format stated per deliverable (repo tag, PDF, Gerbers, …)")
      sec("acceptance_criteria")
      rw = ("review_window_days" in L) ? firstnum(L["review_window_days"]) : ""
      if (rw == "" || rw < 1) viol("missing review_window_days: (default 5 business days) — without a window UAT never ends")
      if (all !~ /deemed[ -]*accept/) viol("no deemed-acceptance sentence (\"… is deemed accepted if no written acceptance or defect list arrives within the review window\")")
      sec("assumptions_client_dependencies")
      if (sec("out_of_scope") && tolower(B["out_of_scope"]) !~ /change order/) viol("out_of_scope: must state that any work not in scope_in requires a change order")
      if (!("change_control_reference" in L) && !H["change_control"]) viol("missing change_control_reference: (MSA clause / change-order process)")
      if (sec("milestones") && B["milestones"] !~ /M-[0-9]+/) viol("milestones: no M-<n> ids (payments must reference these)")
      if (sec("payment_schedule")) {
        if (npay == 0) viol("payment_schedule: no payment lines found (list items or table rows carrying an amount)")
        for (i = 1; i <= npay; i++) {
          p = PAY[i]; gsub(/^[[:space:]]+|[[:space:]]+$/, "", p)
          if (p !~ /M-[0-9]+/) {
            if (hasdate(p)) viol("payment tied to a calendar date, not a milestone id: " substr(p, 1, 90))
            else viol("payment line without a milestone id (M-<n>): " substr(p, 1, 90))
          }
        }
      }
      dp = ("deposit_pct" in L) ? firstnum(L["deposit_pct"]) : ""
      if (dp == "") viol("missing deposit_pct: (≥ " depmin " % before kickoff)")
      else if (dp < depmin) viol("deposit_pct " dp " < " depmin " % (no deposit, no kickoff)")
      if (sec("ip_ownership")) {
        b = tolower(B["ip_ownership"])
        if (b !~ /assign/) viol("ip_ownership: no assignment clause (deliverables assigned to the client on final payment; IP Code §178.4 otherwise keeps copyright with the creator)")
        if (b !~ /background/) viol("ip_ownership: no background-IP carve-out (pre-existing libraries, designs, tooling stay with the studio under licence)")
      }
      wd = ("warranty_days" in L) ? firstnum(L["warranty_days"]) : ""
      floor = (et ~ /service|repair/) ? svcmin : wmin
      if (wd == "") viol("missing warranty_days: (≥ " floor " for engagement_type " (et == "" ? "?" : et) ")")
      else if (wd < floor) viol("warranty_days " wd " < " floor (floor == svcmin ? " (RA 7394 Art. 71: service/repair invoices carry a ≥ 90-day workmanship guaranty)" : " (software warranty floor)"))
      if (!("support_sla_reference" in L) && !H["support_sla"]) viol("missing support_sla_reference: (a support SOW id, or \"none\")")
      sec("key_personnel")
      if (sec("termination")) {
        b = tolower(B["termination"])
        if (b !~ /cure/) viol("termination: no cure period for termination for cause (7–14 days typical)")
        if (b !~ /convenience/) viol("termination: no termination-for-convenience notice (30 days typical)")
      }
      if (!("liability_cap" in L) && !H["liability_cap"]) viol("missing liability_cap: (1–2× fees typical, with carve-outs)")
      if (all ~ /no[ -]*return[ ,;.\/-]*no[ -]*exchange/) viol("forbidden \"No Return, No Exchange\" wording (DTI DAO 2 s.1993 — receipts, contracts, templates, signage)")
      printf "SOW_MISSING: %d\n", V
    }
  ' "$file"
}
