# Skills Menu Command

**Description:** Interactive menu to select and run Skills-Achury skills, agents, and commands.

**Aliases:** `/skills`, `/skill`

**Arguments:** None (displays interactive menu)

# Menu

## Skills Categories

### Security & Audit
- `security-audit` - Full adversarial security audit workflow (Cloudflare) with validators
- `security-review` - Multi-dimensional code review with severity classification

### TDD & Quality
- `tdd-workflow` - Strict RED → GREEN → REFACTOR cycle with evidence
- `code-review` - Multi-dimensional code review with severity classification
- `performance-optimizer` - Bottleneck detection, bundle size, memory leaks

### UI & Design
- `shadcn` - Hard rules for building UIs with shadcn/ui components
- `frontend-patterns` / `backend-patterns` - Framework-agnostic design patterns
- `react-patterns`, `python-patterns`, `golang-patterns`, `rust-patterns` - Language-specific best practices

### Language-Specific
- `python-patterns` - Python coding patterns and best practices
- `golang-patterns` - Go programming patterns
- `rust-patterns` - Rust language patterns and idioms
- `golang-patterns` - Go development patterns

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

## Agents Categories

### Reviewers
- Language-specific reviewers (TS, Python, Go, Rust, Java, etc.)
- Build-error resolvers
- Security auditors

### Planners
- Project planners and workflow architects

## How to Use

### Option 1: Interactive Menu
Simply run `/skills` and you'll see a numbered list of categories. Select a number or type the skill name directly.

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
Use `--list` flag (if supported) or check the full list with:
```
./install.ps1 -List
```

## Available Skills (244 total)

The full list includes skills for:
- Web development (React, Python, Go, Rust, etc.)
- Security audits and vulnerability scanning
- TDD and quality workflows
- Code review and analysis
- UI/UX patterns (shadcn/ui)
- Performance optimization
- And more...

## Technical Details

This command was generated as part of the Skills-Achury unified pack. It serves as a gateway to the 244 curated skills available in the pack.

**Package:** Skills-Achury  
**Version:** 1.0.0  
**Skills Count:** 244  
**Last Updated:** 2026

---

**To see the complete list of all available skills, agents, and commands, run:**
```
./install.ps1 -List
```