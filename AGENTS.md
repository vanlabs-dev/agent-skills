# agent-skills

Personal library of portable agent skills and output styles. One author, no external contributors. Everything here is markdown; there is no build and there are no tests.

## Add or change a skill

1. Create `skills/<name>/SKILL.md`. Lowercase kebab-case name, one skill per folder.
2. Frontmatter requires `name` and `description`. Other Agent Skills fields (`argument-hint`, `disable-model-invocation`, `allowed-tools`) are allowed when needed. Write the description in third person, state what the skill does and when to use it, and include the `/name` trigger. No XML tags, under 1024 characters.
3. Keep the body a lean instruction set: rules and steps, not essays.
4. Add a row to the skills table in `README.md`. Keep the table alphabetical.
5. Install locally: `cp -r skills/<name> ~/.claude/skills/`.

## Writing rules

- Never use em dashes. Use a comma, a colon, parentheses, or a new sentence.
- Short sentences, active voice, imperative mood for steps.
- Commit subjects: imperative, ~50 chars, no trailing period, no attribution trailers. Example: `feat: add lazy skill`.

## Do not

- Do not add build tooling, dependencies, or scaffolding.
- Do not edit installed copies under `~/.claude/skills/`. Edit here, then re-copy.
