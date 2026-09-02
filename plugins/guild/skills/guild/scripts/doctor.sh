#!/usr/bin/env bash
# doctor.sh — guild toolchain check. Prescribes, never installs.
#   usage: doctor.sh [--require-build]
#   FOUND/MISSING line per tool; last line "DOCTOR: READY" (exit 0) or
#   "DOCTOR: BLOCKED <n> missing" (exit 1). Without --require-build only CORE blocks.
#   --require-build additionally blocks on the build tier (gh — `build` pushes every venture to
#   its own private repo as part of the standard loop; that is how its CI runs).
#   Web research runs through Claude Code's own WebSearch/WebFetch seams, not a CLI — nothing
#   to check here; the evidence protocol requires a locator + retrieval date per claim instead.
set -uo pipefail
export LC_ALL=C

REQUIRE_BUILD=0
for a in "$@"; do [[ "$a" == "--require-build" ]] && REQUIRE_BUILD=1; done

core_missing=0
build_missing=0

found()   { echo "FOUND   $1 $2"; }
missing() { echo "MISSING $1 — $2"; }

# --- CORE ------------------------------------------------------------------
if command -v git >/dev/null 2>&1; then found git "$(git --version | head -1)"; else missing git "install git"; core_missing=$((core_missing+1)); fi
if command -v node >/dev/null 2>&1; then found node "$(node --version)"; else missing node "install node (JSON/CSV parsing seam)"; core_missing=$((core_missing+1)); fi
if command -v awk >/dev/null 2>&1; then found awk "$(awk --version 2>/dev/null | head -1 || echo present)"; else missing awk "install gawk (TSV ledgers)"; core_missing=$((core_missing+1)); fi
if [[ "${BASH_VERSINFO[0]:-0}" -ge 4 ]]; then found bash "${BASH_VERSION}"; else missing bash "bash >= 4 required (arrays, [[ =~ ]])"; core_missing=$((core_missing+1)); fi

# --- BUILD -----------------------------------------------------------------
if command -v gh >/dev/null 2>&1; then found gh "$(gh --version | head -1)"; else missing gh "install GitHub CLI (venture output repos)"; build_missing=$((build_missing+1)); fi

total=$core_missing
[[ $REQUIRE_BUILD -eq 1 ]] && total=$((total + build_missing))
if [[ $total -eq 0 ]]; then
  echo "DOCTOR: READY"; exit 0
else
  echo "DOCTOR: BLOCKED $total missing"; exit 1
fi
