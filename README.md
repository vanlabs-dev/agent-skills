# agent-skills

Portable skills and response styles for AI agents.

Designed to work across Claude Code, Pi, and other agent runtimes.

## Structure

```
agent-skills/
├── styles/     # Response / output styles (e.g. DIRECT)
├── skills/     # Portable skills (Agent Skills format: skill-name/SKILL.md)
├── prompts/    # Optional reusable prompts
└── configs/    # Optional tool-specific overrides
    ├── claude/
    └── pi/
```

- `skills/` follows the emerging Agent Skills standard (`skill-name/SKILL.md`), already used by Claude Code and easily adapted by other agents.
- `styles/` stays separate because response styles are conceptually different from skills. Most agents can use the markdown content directly as a system/instruction prompt.
- `configs/` is optional and only for cases where a tool needs its own format.

## Styles

| Style    | Purpose                                          |
|----------|--------------------------------------------------|
| `direct` | Direct, concise, low-clutter technical responses |

Copy the content into your agent's system prompt, style settings, or instructions.

**Claude Code**

```bash
cp styles/direct.md ~/.claude/output-styles/
```

Then select it with `/output-style`.

## Skills

| Skill | Trigger | Purpose                                      |
|-------|---------|----------------------------------------------|
| `bro` | `/bro`  | Re-explain the previous response more simply |

### Installation

**Claude Code**

```bash
cp -r skills/bro ~/.claude/skills/
# or project-level: .claude/skills/
```

**Pi / other agents**

Copy the `SKILL.md` content into the agent's skill/instruction system, or place the folder where your agent loads skills from.

## License

[MIT](LICENSE)
