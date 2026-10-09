#!/usr/bin/env bash
# Skills-Achury installer for Claude Code and OpenCode.
# Usage: ./install.sh [--profile minimal|standard|full] [--target claude|opencode|both]
#                     [--dry-run] [--uninstall] [--list]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="1.0.0"
MANIFEST_DIR="${HOME}/.skills-achury"
MANIFEST_FILE="${MANIFEST_DIR}/install.json"

# Defaults
PROFILE="standard"
TARGET="auto"
DRY_RUN=false
UNINSTALL=false
LIST=false

# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

usage() {
  cat <<EOF
Skills-Achury installer v${VERSION}

Usage: $0 [OPTIONS]

Options:
  --profile <p>    Install profile: minimal | standard | full (default: standard)
  --target <t>     Target harness: claude | opencode | both | auto (default: auto)
  --dry-run        Preview what would be installed without copying
  --uninstall      Remove previously installed files
  --list           List available skills, agents, and commands
  -h, --help       Show this help

Profiles:
  minimal   Core skills only (~30 essential skills)
  standard  All skills + agents + commands + rules
  full      Everything including reference prompts

Examples:
  $0                          # standard install, auto-detect harness
  $0 --profile full           # install everything
  $0 --target claude --dry-run
  $0 --uninstall
EOF
}

log()  { echo -e "${BLUE}[skills-achury]${NC} $*"; }
ok()   { echo -e "${GREEN}[ok]${NC} $*"; }
warn() { echo -e "${YELLOW}[warn]${NC} $*"; }
err()  { echo -e "${RED}[error]${NC} $*" >&2; }

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)  PROFILE="$2"; shift 2 ;;
    --target)   TARGET="$2"; shift 2 ;;
    --dry-run)  DRY_RUN=true; shift ;;
    --uninstall) UNINSTALL=true; shift ;;
    --list)     LIST=true; shift ;;
    -h|--help)  usage; exit 0 ;;
    *) err "Unknown option: $1"; usage; exit 1 ;;
  esac
done

# Validate profile
case "$PROFILE" in
  minimal|standard|full) ;;
  *) err "Invalid profile: $PROFILE (use minimal, standard, or full)"; exit 1 ;;
esac

# List mode
if $LIST; then
  echo "Skills ($(ls -1 "${SCRIPT_DIR}/skills" 2>/dev/null | wc -l | tr -d ' ')):"
  ls -1 "${SCRIPT_DIR}/skills" 2>/dev/null || true
  echo ""
  echo "Agents ($(ls -1 "${SCRIPT_DIR}/agents" 2>/dev/null | wc -l | tr -d ' ')):"
  ls -1 "${SCRIPT_DIR}/agents" 2>/dev/null || true
  echo ""
  echo "Commands ($(ls -1 "${SCRIPT_DIR}/commands" 2>/dev/null | wc -l | tr -d ' ')):"
  ls -1 "${SCRIPT_DIR}/commands" 2>/dev/null | sed 's/\.md$//' || true
  exit 0
fi

# Detect harnesses
detect_targets() {
  local detected=()
  [[ -d "${HOME}/.claude" ]] && detected+=("claude")
  [[ -d "${HOME}/.opencode" ]] && detected+=("opencode")
  if [[ ${#detected[@]} -eq 0 ]]; then
    # Default: install for both
    detected=("claude" "opencode")
  fi
  echo "${detected[@]}"
}

if [[ "$TARGET" == "auto" ]]; then
  TARGETS=($(detect_targets))
else
  TARGETS=("$TARGET")
fi

log "Profile: ${PROFILE}"
log "Targets: ${TARGETS[*]}"
$DRY_RUN && log "Mode: DRY RUN (no files will be written)"

# Uninstall mode
if $UNINSTALL; then
  if [[ ! -f "$MANIFEST_FILE" ]]; then
    err "No install manifest found at ${MANIFEST_FILE}. Nothing to uninstall."
    exit 1
  fi
  log "Uninstalling from manifest..."
  # Read manifest and remove files
  if command -v jq &>/dev/null; then
    jq -r '.files[]' "$MANIFEST_FILE" | while read -r f; do
      if $DRY_RUN; then
        echo "  would remove: $f"
      else
        rm -f "$f" 2>/dev/null && echo "  removed: $f" || true
      fi
    done
    ok "Uninstall complete"
  else
    warn "jq not found. Manual cleanup: see ${MANIFEST_FILE}"
    cat "$MANIFEST_FILE"
  fi
  exit 0
fi

# Helper: copy with manifest tracking
INSTALLED_FILES=()
copy_file() {
  local src="$1" dest="$2"
  if $DRY_RUN; then
    echo "  would copy: $src -> $dest"
    return
  fi
  mkdir -p "$(dirname "$dest")"
  cp -f "$src" "$dest"
  INSTALLED_FILES+=("$dest")
}

copy_dir() {
  local src="$1" dest="$2"
  if $DRY_RUN; then
    echo "  would copy dir: $src -> $dest"
    return
  fi
  mkdir -p "$dest"
  cp -R "$src/." "$dest/"
  # Track all files
  while IFS= read -r f; do
    INSTALLED_FILES+=("$f")
  done < <(find "$dest" -type f)
}

# Minimal profile: only these skills
MINIMAL_SKILLS=(
  security-audit shadcn migrate-radix-to-base
  tdd-workflow code-review security-review coding-standards
  error-handling api-design frontend-patterns backend-patterns
  react-patterns python-patterns golang-patterns rust-patterns
  e2e-testing search-first git-workflow
  code-simplifier performance-optimizer silent-failure-hunter
  documentation-lookup prompt-optimizer context-budget
  repo-scan codebase-onboarding code-tour
  architecture-decision-records delivery-gate
)

should_install_skill() {
  local name="$1"
  if [[ "$PROFILE" == "minimal" ]]; then
    for s in "${MINIMAL_SKILLS[@]}"; do
      [[ "$s" == "$name" ]] && return 0
    done
    return 1
  fi
  return 0
}

# Install per target
for t in "${TARGETS[@]}"; do
  case "$t" in
    claude)
      CLAUDE_DIR="${HOME}/.claude"
      log "Installing for Claude Code -> ${CLAUDE_DIR}"
      # Skills
      for d in "${SCRIPT_DIR}/skills"/*/; do
        name="$(basename "$d")"
        if should_install_skill "$name"; then
          copy_dir "$d" "${CLAUDE_DIR}/skills/${name}"
        fi
      done
      # Agents
      if [[ "$PROFILE" != "minimal" ]]; then
        for f in "${SCRIPT_DIR}/agents"/*.md; do
          [[ -f "$f" ]] && copy_file "$f" "${CLAUDE_DIR}/agents/$(basename "$f")"
        done
        # Commands
        for f in "${SCRIPT_DIR}/commands"/*.md; do
          [[ -f "$f" ]] && copy_file "$f" "${CLAUDE_DIR}/commands/$(basename "$f")"
        done
        # Rules
        if [[ -d "${SCRIPT_DIR}/rules" ]]; then
          copy_dir "${SCRIPT_DIR}/rules" "${CLAUDE_DIR}/rules/skills-achury"
        fi
      fi
      
      ok "Claude Code install done"
      ;;

    opencode)
      OPENCODE_DIR="${HOME}/.opencode"
      log "Installing for OpenCode -> ${OPENCODE_DIR}"
      # Skills
      for d in "${SCRIPT_DIR}/skills"/*/; do
        name="$(basename "$d")"
        if should_install_skill "$name"; then
          copy_dir "$d" "${OPENCODE_DIR}/skills/${name}"
        fi
      done
      ok "OpenCode install done (skills only; agents/commands via repo opencode.json)"
      ;;

    *)
      err "Unknown target: $t (use claude, opencode, or both)"
      exit 1
      ;;
  esac
done

# Save manifest
if ! $DRY_RUN && [[ ${#INSTALLED_FILES[@]} -gt 0 ]]; then
  mkdir -p "$MANIFEST_DIR"
  printf '%s\n' "${INSTALLED_FILES[@]}" > "${MANIFEST_DIR}/files.txt"
  cat > "$MANIFEST_FILE" <<EOF
{
  "version": "${VERSION}",
  "profile": "${PROFILE}",
  "targets": [$(IFS=,; echo "${TARGETS[*]}" | sed 's/[^,]*/"&"/g')],
  "installed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "file_count": ${#INSTALLED_FILES[@]}
}
EOF
  ok "Install manifest saved to ${MANIFEST_FILE}"
fi

echo ""
ok "Skills-Achury v${VERSION} installed successfully!"
log "Restart your agent session to pick up new skills."
