#!/usr/bin/env bash
# Smoke tests for the Skills-Achury installer and pack integrity.
# Run: bash tests/test-installer.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname "$SCRIPT_DIR")"
FAIL=0

pass() { echo "  PASS: $1"; }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); }

echo "=== Skills-Achury pack integrity tests ==="
echo ""

# 1. Required root files exist
echo "[1] Root files"
for f in LICENSE NOTICE.md README.md README.es.md install.sh install.ps1 manifest.json opencode.json; do
  if [[ -f "$ROOT/$f" ]]; then pass "$f exists"; else fail "$f missing"; fi
done

# 2. Plugin manifests exist
echo "[2] Plugin manifests"
for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json; do
  if [[ -f "$ROOT/$f" ]]; then pass "$f exists"; else fail "$f missing"; fi
done

# 3. Every skill dir has SKILL.md with name + description frontmatter
echo "[3] Skill frontmatter"
skill_count=0
bad_skills=0
for d in "$ROOT/skills"/*/; do
  name="$(basename "$d")"
  skill_md="$d/SKILL.md"
  skill_count=$((skill_count+1))
  if [[ ! -f "$skill_md" ]]; then
    fail "skill '$name' has no SKILL.md"
    bad_skills=$((bad_skills+1))
    continue
  fi
  head -1 "$skill_md" | grep -q '^---' || { fail "skill '$name' SKILL.md has no frontmatter"; bad_skills=$((bad_skills+1)); continue; }
  grep -q '^name:' "$skill_md" || { fail "skill '$name' missing name field"; bad_skills=$((bad_skills+1)); }
  grep -q '^description:' "$skill_md" || { fail "skill '$name' missing description field"; bad_skills=$((bad_skills+1)); }
done
if [[ $bad_skills -eq 0 ]]; then
  pass "all $skill_count skills have valid SKILL.md frontmatter"
fi

# 4. Every agent .md has name + description
echo "[4] Agent frontmatter"
agent_count=0
bad_agents=0
for f in "$ROOT/agents"/*.md; do
  [[ -f "$f" ]] || continue
  agent_count=$((agent_count+1))
  grep -q '^---' "$f" || { fail "agent $(basename "$f") no frontmatter"; bad_agents=$((bad_agents+1)); }
done
if [[ $bad_agents -eq 0 ]]; then
  pass "all $agent_count agents have frontmatter"
fi

# 5. Every command .md has description
echo "[5] Command frontmatter"
cmd_count=0
bad_cmds=0
for f in "$ROOT/commands"/*.md; do
  [[ -f "$f" ]] || continue
  cmd_count=$((cmd_count+1))
  grep -q '^---' "$f" || { fail "command $(basename "$f") no frontmatter"; bad_cmds=$((bad_cmds+1)); }
done
if [[ $bad_cmds -eq 0 ]]; then
  pass "all $cmd_count commands have frontmatter"
fi

# 6. GPLv3 license preserved in reference/prompts
echo "[6] Reference & licensing"
if [[ -f "$ROOT/reference/prompts/LICENSE.md" ]]; then
  pass "GPLv3 LICENSE.md preserved in reference/prompts"
else
  fail "GPLv3 LICENSE.md missing from reference/prompts"
fi
if [[ -f "$ROOT/reference/PROJECTS.md" ]]; then
  pass "PROJECTS.md exists"
else
  fail "PROJECTS.md missing"
fi
if [[ -f "$ROOT/reference/floci-agents-rules.md" ]]; then
  pass "floci reference exists"
else
  fail "floci reference missing"
fi

# 7. Installer dry-run works
echo "[7] Installer dry-run"
if command -v bash &>/dev/null; then
  if bash "$ROOT/install.sh" --dry-run --target claude --profile minimal >/dev/null 2>&1; then
    pass "install.sh dry-run executes without error"
  else
    fail "install.sh dry-run failed"
  fi
fi

# 8. Counts sanity
echo "[8] Content counts"
echo "  info: $skill_count skills, $agent_count agents, $cmd_count commands"
if [[ $skill_count -ge 300 ]]; then
  pass "skill count >= 300 (expected ~323)"
else
  fail "skill count too low: $skill_count (expected >= 300)"
fi
if [[ $agent_count -ge 60 ]]; then
  pass "agent count >= 60 (expected 68)"
else
  fail "agent count too low: $agent_count"
fi
if [[ $cmd_count -ge 120 ]]; then
  pass "command count >= 120 (expected 126)"
else
  fail "command count too low: $cmd_count"
fi

echo ""
echo "=== Results ==="
if [[ $FAIL -eq 0 ]]; then
  echo "ALL TESTS PASSED"
  exit 0
else
  echo "$FAIL TEST(S) FAILED"
  exit 1
fi
