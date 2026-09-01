#!/usr/bin/env bash
# sync-plugin.sh — mirror the canonical .claude tree into claude-plugin/ (the
# distributable Claude Code plugin), as PURE BYTE COPIES.
#
#   sync-plugin.sh          → copy canonical → plugin tree, prune orphans
#   sync-plugin.sh --check  → verify byte-parity, no writes (CI gate)
#
# NEVER transform contents while mirroring — a transformed mirror diverges from
# canonical and the divergence hides until an install breaks (the forge lesson).
# Canonical sources: .claude/commands/**, .claude/skills/guild/**, scripts/*.sh
# (the seam scripts ship INSIDE the plugin at skills/guild/scripts/ so
# ${CLAUDE_PLUGIN_ROOT}/skills/guild resolution works in installed repos).
set -uo pipefail
export LC_ALL=C

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 2
CHECK=0
[[ "${1:-}" == "--check" ]] && CHECK=1

# --- build the src|dst mapping ---------------------------------------------
pairs=()
add() { pairs+=("$1|$2"); }

[[ -f .claude/commands/guild.md ]] && add ".claude/commands/guild.md" "claude-plugin/commands/guild.md"
for f in .claude/commands/guild/*.md; do
  [[ -f "$f" ]] && add "$f" "claude-plugin/commands/guild/$(basename "$f")"
done
add ".claude/skills/guild/SKILL.md" "claude-plugin/skills/guild/SKILL.md"
for f in .claude/skills/guild/references/*.md; do
  [[ -f "$f" ]] && add "$f" "claude-plugin/skills/guild/references/$(basename "$f")"
done
for s in score-guild.sh doctor.sh validate-handoff.sh; do
  add "scripts/$s" "claude-plugin/skills/guild/scripts/$s"
done

# --- expected destination set (for orphan detection) ------------------------
expected() {
  local p
  for p in "${pairs[@]}"; do echo "${p#*|}"; done
  echo "claude-plugin/.claude-plugin/plugin.json"
}

actual() {
  [[ -d claude-plugin ]] || return 0
  find claude-plugin -type f | sed 's|^\./||' | sort
}

# --- check mode --------------------------------------------------------------
if [[ $CHECK -eq 1 ]]; then
  bad=0
  for p in "${pairs[@]}"; do
    src="${p%%|*}"; dst="${p#*|}"
    if [[ ! -f "$dst" ]]; then echo "missing in plugin: $dst" >&2; bad=$((bad + 1))
    elif ! cmp -s "$src" "$dst"; then echo "diverged: $dst != $src" >&2; bad=$((bad + 1)); fi
  done
  while IFS= read -r f; do
    expected | grep -qxF "$f" || { echo "orphan in plugin (no canonical source): $f" >&2; bad=$((bad + 1)); }
  done < <(actual)
  [[ -f claude-plugin/.claude-plugin/plugin.json ]] || { echo "missing plugin.json" >&2; bad=$((bad + 1)); }
  if [[ $bad -eq 0 ]]; then echo "PLUGIN_PARITY: OK"; exit 0
  else echo "PLUGIN_PARITY: DIVERGED ($bad)"; exit 1; fi
fi

# --- sync mode ---------------------------------------------------------------
n=0
for p in "${pairs[@]}"; do
  src="${p%%|*}"; dst="${p#*|}"
  [[ -f "$src" ]] || { echo "sync-plugin: missing canonical source $src" >&2; exit 2; }
  mkdir -p "$(dirname "$dst")"
  cp -f "$src" "$dst"
  n=$((n + 1))
done
# prune orphans (stale copies of deleted canonical files)
while IFS= read -r f; do
  if ! expected | grep -qxF "$f"; then
    rm -f "$f"
    echo "pruned orphan: $f" >&2
  fi
done < <(actual)
echo "PLUGIN_SYNC: $n files"
