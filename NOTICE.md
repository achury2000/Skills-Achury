# NOTICE — Source Attributions

Skills-Achury is a curated, unified pack of agent skills, commands, rules, and
prompts. The curated integration, installer, manifests, and documentation in
this repository are licensed under the MIT License (see `LICENSE`).

The following third-party works were incorporated, in whole or in part, and
remain under their original licenses. Full license texts are preserved where
required.

## Included works

| Source | Author | License | What was taken |
|---|---|---|---|
| [ECC (Everything Claude Code)](https://github.com/affaan-m/ECC) | Affaan Mustafa | MIT | Skills, agents, commands, rules, hook concepts |
| [Ruflo (formerly Claude Flow)](https://github.com/ruvnet/claude-flow) | RuvNet / Cognitum.One | MIT | Curated skills, agents, commands |
| [security-audit-skill](https://github.com/cloudflare/security-audit-skill) | Cloudflare, Inc. | MIT | The complete `security-audit` skill (prompts, schema, validators) |
| [shadcn/ui](https://github.com/shadcn-ui/ui) | shadcn | MIT | `shadcn` and `migrate-radix-to-base` skills |
| [Floci](https://github.com/hectorvent/floci) | Hector Ventura | MIT | Agent rules (`AGENTS.md`) as reference material |
| [system-prompts-and-models-of-ai-tools](https://github.com/x1xhlol/system-prompts-and-models-of-ai-tools) | x1xhlol | GPLv3 | Reference collection of system prompts (`reference/prompts/`) |

## Special notices

### GPLv3 content (`reference/prompts/`)

The files under `reference/prompts/` are verbatim copies of the
`system-prompts-and-models-of-ai-tools` collection and are distributed under
the **GNU General Public License v3**. The full GPLv3 text is preserved at
`reference/prompts/LICENSE.md`.

This GPLv3 material is kept **separate** from the MIT-licensed skills,
agents, commands, and installer code. If you redistribute this repository,
you must keep `reference/prompts/` (and its license) intact, or remove that
directory entirely. Removing `reference/prompts/` does not affect the
functionality of the pack.

### Excluded works

- **TaskView** (`taskview-community-main`): excluded from this pack. Its
  source-available license restricts redistribution and derivative use. See
  `reference/PROJECTS.md` for a link to the original project.

## Attribution in skills

Skills imported from third-party sources retain a `source` tag in their
frontmatter (e.g., `source: ecc`, `source: cloudflare`, `source: shadcn`,
`source: ruflo`). Skills without a `source` tag were authored for
Skills-Achury or are original integrations.

## Trademarks

All trademarks and product names belong to their respective owners. Inclusion
in this pack does not imply endorsement by the original authors or projects.
