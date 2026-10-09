# Skills-Achury

Interactive skills selector for Claude Code and OpenCode.

---

## Available Skills (244 total)

### Security & Audit
- `security-audit` - Full adversarial security audit workflow (Cloudflare) with validators
- `security-review` - Multi-dimensional code review with severity classification

### TDD & Quality
- `tdd-workflow` - Strict RED → GREEN → REFACTOR cycle with evidence
- `code-review` - Multi-dimensional code review with severity classification

### UI & Design
- `shadcn` - Hard rules for building UIs with shadcn/ui components
- `frontend-patterns` / `backend-patterns` - Framework-agnostic design patterns
- `react-patterns`, `python-patterns`, `golang-patterns`, `rust-patterns` - Language-specific best practices

### Language-Specific
- `python-patterns` - Python coding patterns and best practices
- `golang-patterns` - Go programming patterns
- `rust-patterns` - Rust language patterns and idioms

### Tools & Integration
- `code-simplifier` - Simplify complex code blocks while preserving functionality
- `prompt-optimizer` - Improve your agent prompts for better results
- `context-budget` - Manage context budget and token usage
- `repo-scan` - Scan repository structure and identify key components
- `codebase-onboarding` - New team member onboarding with key concepts

### Architecture & Planning
- `plan` - Restate requirements, assess risks, create step-by-step implementation plan
- `architecture-decision-records` - Document architecture decisions and rationale
- `delivery-gate` - Quality gate before delivery

---

### Agents Categories
- Reviewers per language (TS, Python, Go, Rust, Java...)
- Build-error resolvers
- Planners and workflow architects

---

## How to Use

### Option 1: Interactive Menu
Simply run `/skills` and you'll see the list above with categories. Select a number or type the skill name directly.

### Option 2: Direct Execution
Run any skill directly by name:
```
/security-audit
/tdd-workflow
/shadcn
/code-review
/plan
```

### Option 3: Browse All
Check the full list:
```
./install.ps1 -List
```

---

**Skills-Achury Pack** - 244 skills, 67 agents, 63 commands for AI coding agents.
Generated from: ECC, Ruflo, Cloudflare security-audit, shadcn/ui, and more.