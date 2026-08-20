# agent-skills

Personal library of portable agent skills and output styles. One author, no external contributors. Content is markdown. A skill may ship a supporting script, but there is no build and there are no tests.

## Add or change a skill

1. Create `skills/<name>/SKILL.md`. Lowercase kebab-case name, one skill per folder.
2. Frontmatter requires `name` and `description`. Other Agent Skills fields (`argument-hint`, `disable-model-invocation`, `allowed-tools`) are allowed when needed. Write the description in third person, state what the skill does and when to use it, and include the `/name` trigger. No XML tags, under 1024 characters.
3. Keep the body a lean instruction set: rules and steps, not essays.
4. Keep it portable. No absolute paths, no home directory layout, no host-specific tools. A skill that only runs on one machine belongs in that machine's own config, not here. Refer to `<skill-dir>` when a skill must point at its own folder.
5. Add a row to the skills table in `README.md`. Keep the table alphabetical.
6. Install locally: `cp -r skills/<name> ~/.claude/skills/`.

## Skill scripts

A skill may ship helpers under `skills/<name>/scripts/`. Rules:

- Bash only, `#!/usr/bin/env bash`, `set -euo pipefail`, executable bit committed.
- No dependencies beyond coreutils. Probe for optional tools with `command -v` and skip when absent.
- Exit codes are the contract: 0 pass, 1 fail, 2 usage error.
- The skill body invokes it as `bash <skill-dir>/scripts/<file>.sh`.

## Writing rules

- Never use em dashes. Use a comma, a colon, parentheses, or a new sentence.
- Short sentences, active voice, imperative mood for steps.
- Commit subjects: imperative, ~50 chars, no trailing period, no attribution trailers. Example: `feat: add lazy skill`.

## Do not

- Do not add build tooling, dependencies, or scaffolding to this repo. A skill
  may still require an external tool of its host: `greenfield` requires the
  OpenSpec CLI. State the requirement in the skill and in `README.md`.
- Do not edit installed copies under `~/.claude/skills/`. Edit here, then re-copy. The one exception is `greenfield`: the deployed copy carries this machine's scaffold rules on purpose, so the repo copy is the portable subset and the two are not identical.
