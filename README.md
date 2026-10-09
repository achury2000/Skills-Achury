# Skills-Achury

**English** | [Español](./README.es.md)

A unified, portable pack of **244 agent skills**, **67 specialized agents**, **63 slash commands**, rules for AI coding agents — curated from the best of the open-source agent ecosystem and ready to install into **Claude Code** and **OpenCode**.

```
clone → run installer → restart your agent → start working
```

## What's inside

| Component | Count | Description |
|---|---|---|
| **Skills** | 244 | Reusable workflows: TDD, security audits, code review, frontend/backend patterns, and more |
| **Agents** | 67 | Specialized subagents: reviewers per language (TS, Python, Go, Rust, Java...), build-error resolvers, planners, security auditors |
| **Commands** | 63 | Slash commands: `/plan`, `/code-review`, `/security-scan`, and many more |
| **Rules** | 22 dirs | Always-follow coding guidelines (common + per-language: TypeScript, Python, React, Go, Rust, Java, PHP...) |
| **Hooks** | — | — |
| **Reference** | Prompts + docs | System-prompt collection (GPLv3), Floci agent rules, shadcn CLI docs |

## Quick start

### Option A — Clone and install (recommended)

```bash
git clone <your-repo-url> skills-achury
cd skills-achury
```

**Linux / macOS:**
```bash
./install.sh                        # standard profile, auto-detects harness
./install.sh --profile full         # everything including reference prompts
./install.sh --profile minimal      # only ~30 essential skills
./install.sh --dry-run              # preview without writing
```

**Windows (PowerShell):**
```powershell
.\install.ps1                       # standard profile
.\install.ps1 -Profile full         # everything
.\install.ps1 -DryRun               # preview
.\install.ps1 -List                 # list all skills/agents/commands
.\install.ps1 -Uninstall            # remove installed files
```

### Option B — Claude Code plugin

Add this repo as a marketplace and install as a plugin:

```
/plugin marketplace add <your-github-user>/skills-achury
/plugin install skills-achury@skills-achury
```

### Option C — OpenCode (manual)

Clone the repo and point OpenCode at it:

```bash
git clone <your-repo-url> ~/.opencode/skills-achury
```

Then in your `opencode.json`:

```json
{
  "skills": {
    "paths": ["~/.opencode/skills-achury/skills"]
  }
}
```

## Install profiles

| Profile | What you get | Best for |
|---|---|---|
| `minimal` | ~30 core skills (security-audit, shadcn, tdd, review, patterns...) | Trying it out, lightweight setups |
| `standard` *(default)* | All skills + agents + commands + rules | Daily development |
| `full` | Everything + reference prompts | Power users, full automation |

## Installer options

```
--profile minimal|standard|full   Install profile (default: standard)
--target claude|opencode|both     Where to install (default: auto-detect)
--dry-run                         Preview what would be installed
--uninstall                       Remove previously installed files
--list                            List all available components
```

The installer detects existing `~/.claude` and `~/.opencode` directories and installs to the right place. It saves a manifest to `~/.skills-achury/` so `--uninstall` is safe and complete.

## Popular skills

| Skill | What it does |
|---|---|
| `security-audit` | Full adversarial security audit workflow (Cloudflare) with validators |
| `shadcn` | Hard rules for building UIs with shadcn/ui components |
| `tdd-workflow` | Strict RED → GREEN → REFACTOR cycle with evidence |
| `code-review` | Multi-dimensional code review with severity classification |
| `frontend-patterns` / `backend-patterns` | Framework-agnostic design patterns |
| `react-patterns`, `python-patterns`, `golang-patterns`, `rust-patterns` | Language-specific best practices |
| `performance-optimizer` | Bottleneck detection, bundle size, memory leaks |
| `prompt-optimizer` | Improve your agent prompts |

Run `.\install.ps1 -List` (or `./install.sh --list`) to see all 244.

## Project structure

```
skills-achury/
├── skills/           # 244 skills (each: name/SKILL.md + optional assets)
├── agents/           # 67 agent definitions (.md)
├── commands/         # 63 slash commands (.md)
├── rules/            # coding rules (common/ + per-language/)
├── reference/        # prompts (GPLv3), docs, related projects
├── .claude-plugin/   # Claude Code plugin manifests
├── opencode.json     # OpenCode adapter
├── install.sh        # Unix/macOS installer
├── install.ps1       # Windows installer
├── manifest.json     # catalog + profiles
└── tests/            # installer smoke tests
```

## Adding your own skills

Drop a folder into `skills/` with a `SKILL.md`:

```markdown
---
name: my-skill
description: When to use this skill. Include trigger keywords.
---

# My Skill

Instructions for the agent...
```

The installer will pick it up automatically on the next run.

## Credits & licensing

This pack curates material from several open-source projects. See [NOTICE.md](./NOTICE.md) for full attributions and [reference/PROJECTS.md](./reference/PROJECTS.md) for links to the original projects.

**Summary:** the pack integration, installer, and MIT-licensed content (ECC, Ruflo, Cloudflare security-audit, shadcn/ui, Floci) are MIT. The `reference/prompts/` collection is GPLv3 and kept separate — remove that folder if you don't need it.

## Uninstall

```bash
./install.sh --uninstall          # Unix
.\install.ps1 -Uninstall          # Windows
```

---

Built with ❤️ for the agent community. MIT licensed.
