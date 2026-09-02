#!/usr/bin/env bash
# transform.sh — generate the OpenCode and Codex platform trees from the canonical Claude Code
# source (.claude/). Same convention as AutoForge's transform.sh.
#
#   ./scripts/transform.sh              # OpenCode + Codex
#   ./scripts/transform.sh --opencode   # OpenCode only
#   ./scripts/transform.sh --codex      # Codex only
#   ./scripts/transform.sh --check      # regenerate and fail (exit 1) if git sees a diff — CI gate
#
# Canonical: .claude/skills/guild/** and .claude/commands/guild.md + guild/*.md. Never edit the
# generated trees (.opencode/, .agents/, plugins/) by hand — run this script.
# The Claude Code plugin tree (claude-plugin/) is a pure BYTE mirror made by sync-plugin.sh, not
# by this script (the forge lesson: transformed mirrors diverge silently).
set -euo pipefail
export LC_ALL=C

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CLAUDE_SKILLS="$REPO_ROOT/.claude/skills/guild"
CLAUDE_COMMANDS="$REPO_ROOT/.claude/commands"

DO_OPENCODE=1; DO_CODEX=1; CHECK=0
for a in "$@"; do
  case "$a" in
    --opencode) DO_OPENCODE=1; DO_CODEX=0 ;;
    --codex)    DO_OPENCODE=0; DO_CODEX=1 ;;
    --check)    CHECK=1 ;;
    -h|--help)  printf 'Usage: %s [--opencode|--codex] [--check]\n' "$0"; exit 0 ;;
    *) printf 'unknown option: %s\n' "$a" >&2; exit 2 ;;
  esac
done

# Seam scripts that must ship inside every skill tree so GUILD_ROOT resolution finds the gates.
seam_scripts() {
  local dst="$1" s
  mkdir -p "$dst/scripts/gates"
  for s in score-guild.sh doctor.sh validate-handoff.sh; do cp "$REPO_ROOT/scripts/$s" "$dst/scripts/$s"; done
  for s in "$REPO_ROOT"/scripts/gates/*.sh; do [[ -f "$s" ]] && cp "$s" "$dst/scripts/gates/$(basename "$s")"; done
}

# --- OpenCode ---------------------------------------------------------------------------------
# Differences: /guild:x → /guild_x (flat command files), AskUserQuestion → question,
# .claude/ paths → .opencode/ paths.
transform_opencode() {
  local dst_skills="$REPO_ROOT/.opencode/skills/guild"
  local dst_commands="$REPO_ROOT/.opencode/commands"
  rm -rf "$dst_skills"; rm -f "$dst_commands"/guild*.md
  mkdir -p "$dst_skills/references" "$dst_commands"
  adapt_opencode() {
    sed -E \
      -e 's/`AskUserQuestion`/`question`/g' \
      -e 's/AskUserQuestion/question/g' \
      -e 's|/guild:([a-z]+)|/guild_\1|g' \
      -e 's|name: guild:([a-z]+)|name: guild_\1|g' \
      -e 's|\.claude/skills/|.opencode/skills/|g' \
      -e 's|\.claude/commands/|.opencode/commands/|g' \
      "$1"
  }
  adapt_opencode "$CLAUDE_SKILLS/SKILL.md" > "$dst_skills/SKILL.md"
  local ref cmd base
  for ref in "$CLAUDE_SKILLS"/references/*.md; do
    [[ -f "$ref" ]] || continue
    adapt_opencode "$ref" > "$dst_skills/references/$(basename "$ref")"
  done
  adapt_opencode "$CLAUDE_COMMANDS/guild.md" > "$dst_commands/guild.md"
  for cmd in "$CLAUDE_COMMANDS"/guild/*.md; do
    [[ -f "$cmd" ]] || continue
    base="$(basename "$cmd")"
    adapt_opencode "$cmd" > "$dst_commands/guild_${base}"
  done
  seam_scripts "$dst_skills"
  printf 'OpenCode: .claude/ → .opencode/ (%s commands)\n' "$(ls "$dst_commands"/guild*.md | wc -l | tr -d ' ')"
}

# --- Codex ------------------------------------------------------------------------------------
# Differences: /guild:x → $guild x, AskUserQuestion → request_user_input, commands merged into
# the skill directory; a local marketplace under .agents/plugins.
transform_codex() {
  local dst_skills="$REPO_ROOT/plugins/guild/skills/guild"
  local dst_agents="$REPO_ROOT/.agents/skills/guild"
  rm -rf "$dst_skills" "$dst_agents"
  mkdir -p "$dst_skills/references" "$dst_agents/references" "$dst_agents/agents" "$REPO_ROOT/.agents/plugins"
  adapt_codex() {
    sed -E \
      -e 's/`AskUserQuestion`/`request_user_input`/g' \
      -e 's/AskUserQuestion/request_user_input/g' \
      -e 's|/guild:([a-z]+)|\$guild \1|g' \
      -e 's|/guild|\$guild|g' \
      -e 's|\.claude/skills/|skills/guild/|g' \
      -e 's|\.claude/commands/|skills/guild/|g' \
      "$1"
  }
  adapt_codex "$CLAUDE_SKILLS/SKILL.md" > "$dst_skills/SKILL.md"
  cp "$dst_skills/SKILL.md" "$dst_agents/SKILL.md"
  local ref cmd base
  for ref in "$CLAUDE_SKILLS"/references/*.md; do
    [[ -f "$ref" ]] || continue
    base="$(basename "$ref")"
    adapt_codex "$ref" > "$dst_skills/references/$base"
    cp "$dst_skills/references/$base" "$dst_agents/references/$base"
  done
  adapt_codex "$CLAUDE_COMMANDS/guild.md" > "$dst_skills/guild.md"
  cp "$dst_skills/guild.md" "$dst_agents/guild.md"
  for cmd in "$CLAUDE_COMMANDS"/guild/*.md; do
    [[ -f "$cmd" ]] || continue
    base="$(basename "$cmd")"
    adapt_codex "$cmd" > "$dst_skills/$base"
    cp "$dst_skills/$base" "$dst_agents/$base"
  done
  seam_scripts "$dst_skills"; seam_scripts "$dst_agents"
  cat > "$dst_agents/agents/openai.yaml" <<'YAML'
interface:
  display_name: "Guild"
  short_description: "Autonomous business-building harness — idea to first paying customer, then a standing board"
  brand_color: "#B45309"
  default_prompt: "Set a thesis, run discovery, let Codex loop until the venture is OPEN_FOR_BUSINESS"

policy:
  allow_implicit_invocation: true
YAML
  mkdir -p "$dst_skills/agents"; cp "$dst_agents/agents/openai.yaml" "$dst_skills/agents/openai.yaml"
  cat > "$REPO_ROOT/.agents/plugins/marketplace.json" <<'JSON'
{
  "name": "guild-local",
  "interface": {
    "displayName": "Guild Local Plugins"
  },
  "plugins": [
    {
      "name": "guild",
      "source": {
        "source": "local",
        "path": "./plugins/guild"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Productivity"
    }
  ]
}
JSON
  printf 'Codex: .claude/ → plugins/guild/ + .agents/\n'
}

cd "$REPO_ROOT"
[[ $DO_OPENCODE -eq 1 ]] && transform_opencode
[[ $DO_CODEX -eq 1 ]] && transform_codex

if [[ $CHECK -eq 1 ]]; then
  if git diff --quiet -- .opencode .agents plugins && [[ -z "$(git ls-files --others --exclude-standard .opencode .agents plugins)" ]]; then
    echo "PLATFORM_MIRRORS: OK"
  else
    echo "PLATFORM_MIRRORS: STALE (run scripts/transform.sh and commit)" >&2
    git status --short -- .opencode .agents plugins >&2
    exit 1
  fi
fi
