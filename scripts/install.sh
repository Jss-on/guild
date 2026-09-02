#!/usr/bin/env bash
# Guild installer — Claude Code, OpenCode, or OpenAI Codex; global or project-local.
# Same shape as AutoForge's installer. The Claude Code payload is the byte-mirror plugin tree
# (claude-plugin/); OpenCode/Codex payloads are the generated trees from scripts/transform.sh.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TOOL=""; LOCATION=""; CONFIG_DIR=""; FORCE=0

cancelled() { printf "\nInstallation cancelled\n"; exit 0; }
trap cancelled INT

usage() {
  cat <<'EOF'
Usage: ./scripts/install.sh [options]

Options:
  --claude            Install for Claude Code (file install; the marketplace plugin is preferred)
  --opencode          Install for OpenCode
  --codex             Install for OpenAI Codex
  -g, --global        Install globally (~/.claude, ~/.config/opencode, ~/.codex)
  -l, --local         Install in the current project (.claude, .opencode, .codex)
  -c, --config-dir    Override the global config directory
  --force             Replace existing files without prompting
  -h, --help          Show this help message

Examples:
  ./scripts/install.sh                          # interactive
  ./scripts/install.sh --claude --global
  ./scripts/install.sh --opencode --local
  ./scripts/install.sh --codex --global
EOF
}

expand_path() { local raw="$1"; if [[ "$raw" == ~* ]]; then printf '%s\n' "${raw/#\~/$HOME}"; else printf '%s\n' "$raw"; fi; }
is_interactive() { [[ -t 0 && -t 1 ]]; }
die() { printf 'Error: %s\n' "$1" >&2; exit 1; }

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --claude)   [[ -n "$TOOL" && "$TOOL" != "claude" ]] && die "choose only one tool"; TOOL="claude" ;;
      --opencode) [[ -n "$TOOL" && "$TOOL" != "opencode" ]] && die "choose only one tool"; TOOL="opencode" ;;
      --codex)    [[ -n "$TOOL" && "$TOOL" != "codex" ]] && die "choose only one tool"; TOOL="codex" ;;
      -g|--global) [[ -n "$LOCATION" && "$LOCATION" != "global" ]] && die "choose --global or --local"; LOCATION="global" ;;
      -l|--local)  [[ -n "$LOCATION" && "$LOCATION" != "local" ]] && die "choose --global or --local"; LOCATION="local" ;;
      -c|--config-dir) [[ $# -ge 2 ]] || die "--config-dir needs a value"; CONFIG_DIR="$(expand_path "$2")"; shift ;;
      --force) FORCE=1 ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown option: $1" ;;
    esac
    shift
  done
  [[ -n "$CONFIG_DIR" && "$LOCATION" == "local" ]] && die "--config-dir can only be used with --global"
  return 0
}

get_global_dir() {
  local tool="$1"
  if [[ -n "$CONFIG_DIR" ]]; then printf '%s\n' "$CONFIG_DIR"; return; fi
  case "$tool" in
    claude)   if [[ -n "${CLAUDE_CONFIG_DIR:-}" ]]; then expand_path "$CLAUDE_CONFIG_DIR"; else printf '%s\n' "$HOME/.claude"; fi ;;
    opencode) if [[ -n "${OPENCODE_CONFIG_DIR:-}" ]]; then expand_path "$OPENCODE_CONFIG_DIR"
              elif [[ -n "${OPENCODE_CONFIG:-}" ]]; then dirname "$(expand_path "$OPENCODE_CONFIG")"
              elif [[ -n "${XDG_CONFIG_HOME:-}" ]]; then printf '%s\n' "$(expand_path "$XDG_CONFIG_HOME")/opencode"
              else printf '%s\n' "$HOME/.config/opencode"; fi ;;
    codex)    if [[ -n "${CODEX_HOME:-}" ]]; then expand_path "$CODEX_HOME"; else printf '%s\n' "$HOME/.codex"; fi ;;
  esac
}

get_target_dir() {
  local tool="$1" location="$2"
  if [[ "$location" == "local" ]]; then
    case "$tool" in claude) printf '%s\n' "$PWD/.claude" ;; opencode) printf '%s\n' "$PWD/.opencode" ;; codex) printf '%s\n' "$PWD/.codex" ;; esac
    return
  fi
  get_global_dir "$tool"
}

prompt_tool() {
  local answer
  printf 'Select the tool to install:\n  1) Claude Code\n  2) OpenCode\n  3) OpenAI Codex\nChoice [1]: '
  read -r answer || cancelled
  case "${answer:-1}" in 1) TOOL="claude" ;; 2) TOOL="opencode" ;; 3) TOOL="codex" ;; *) die "invalid selection: $answer" ;; esac
}

prompt_location() {
  local global_dir answer local_dir
  global_dir="$(get_global_dir "$TOOL")"
  case "$TOOL" in claude) local_dir="$PWD/.claude" ;; opencode) local_dir="$PWD/.opencode" ;; codex) local_dir="$PWD/.codex" ;; esac
  printf 'Install location:\n  1) Global (%s)\n  2) Local  (%s)\nChoice [1]: ' "$global_dir" "$local_dir"
  read -r answer || cancelled
  case "${answer:-1}" in 1) LOCATION="global" ;; 2) LOCATION="local" ;; *) die "invalid selection: $answer" ;; esac
}

ensure_context() {
  if [[ -z "$TOOL" ]]; then if is_interactive; then prompt_tool; else TOOL="claude"; fi; fi
  if [[ -z "$LOCATION" ]]; then if is_interactive; then prompt_location; else LOCATION="global"; fi; fi
}

sync_dir() {
  [[ -n "$2" && "$2" =~ ^(/|[A-Za-z]:/).{3,}/.{1,}/.{1,} ]] || die "sync_dir: refusing unsafe destination path: ${2:-<empty>}"
  rm -rf "$2"; mkdir -p "$(dirname "$2")"; cp -R "$1" "$2"
}
sync_file() { mkdir -p "$(dirname "$2")"; cp "$1" "$2"; }

confirm_overwrite() {
  local target_root="$1"
  [[ $FORCE -eq 1 ]] && return 0
  [[ -d "$target_root/skills/guild" ]] || return 0
  is_interactive || return 0
  local answer
  printf 'Existing guild files found in %s. Replace? [Y/n]: ' "$target_root"
  read -r answer || cancelled
  case "${answer:-Y}" in [yY]|[yY][eE][sS]|'') ;; *) printf 'Skipped.\n'; exit 0 ;; esac
}

install_claude() {
  local t="$1" p="$REPO_ROOT/claude-plugin"
  [[ -f "$p/skills/guild/SKILL.md" ]] || die "claude-plugin/ payload missing — run scripts/sync-plugin.sh first"
  mkdir -p "$t/skills" "$t/commands"
  # skills/guild carries SKILL.md + references/ + scripts/ (score-guild.sh, gates/) — the gates
  # ARE the mechanical checks; an install without them degrades every gate to self-report.
  sync_dir "$p/skills/guild" "$t/skills/guild"
  sync_dir "$p/commands/guild" "$t/commands/guild"
  sync_file "$p/commands/guild.md" "$t/commands/guild.md"
}

install_opencode() {
  local t="$1" src
  [[ -f "$REPO_ROOT/.opencode/skills/guild/SKILL.md" ]] || die ".opencode/ payload missing — run scripts/transform.sh first"
  mkdir -p "$t/skills" "$t/commands"
  sync_dir "$REPO_ROOT/.opencode/skills/guild" "$t/skills/guild"
  for src in "$REPO_ROOT"/.opencode/commands/guild*.md; do
    [[ -f "$src" ]] && sync_file "$src" "$t/commands/$(basename "$src")"
  done
}

install_codex() {
  local t="$1"
  [[ -f "$REPO_ROOT/.agents/skills/guild/SKILL.md" ]] || die ".agents/ payload missing — run scripts/transform.sh first"
  mkdir -p "$t/skills"
  sync_dir "$REPO_ROOT/.agents/skills/guild" "$t/skills/guild"
}

main() {
  parse_args "$@"
  ensure_context
  local target_root; target_root="$(get_target_dir "$TOOL" "$LOCATION")"
  confirm_overwrite "$target_root"
  local label
  case "$TOOL" in claude) label="Claude Code" ;; opencode) label="OpenCode" ;; codex) label="OpenAI Codex" ;; esac
  printf 'Installing Guild for %s (%s)\nTarget: %s\n' "$label" "$LOCATION" "$target_root"
  case "$TOOL" in
    claude) install_claude "$target_root" ;;
    opencode) install_opencode "$target_root" ;;
    codex) install_codex "$target_root" ;;
  esac
  case "$TOOL" in
    codex) printf 'Done. Use $guild in Codex to start ($guild discover, $guild build, $guild board).\n' ;;
    opencode) printf 'Done. Run /guild (or /guild_discover, /guild_build, /guild_board) to start.\n' ;;
    *) printf 'Done. Run /guild (or /guild:discover, /guild:build, /guild:board) to start.\n' ;;
  esac
}

main "$@"
