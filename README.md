# agent-skills

Personal library of portable skills and response styles for AI agents.

This repo holds what I have found to work. Built for Claude Code first, portable to Pi and other agent runtimes.

## Structure

```
agent-skills/
├── AGENTS.md   # Agent-facing conventions for working on this repo
├── CLAUDE.md   # Claude Code shim, imports AGENTS.md
├── styles/     # Response / output styles (e.g. DIRECT)
├── skills/     # Skills in the Agent Skills format (skill-name/SKILL.md,
│            #   plus optional skill-name/scripts/)
├── prompts/    # Reusable prompts (empty until needed)
└── configs/    # Tool-specific overrides (empty until needed)
```

## Styles

| Style    | Purpose                                          |
|----------|--------------------------------------------------|
| `direct` | Direct, concise, low-clutter technical responses |

**Claude Code**

```bash
cp styles/direct.md ~/.claude/output-styles/
```

Then select it with `/output-style`. Other agents can use the markdown content directly as a system or instruction prompt.

## Skills

| Skill        | Trigger       | Purpose                                                                  |
|--------------|---------------|--------------------------------------------------------------------------|
| `bro`        | `/bro`        | Re-explain the previous response more simply                             |
| `greenfield` | `/greenfield` | Enforce the build lifecycle: brainstorm, OpenSpec, verify, archive       |
| `handover`   | `/handover`   | Write a disposable handover document for a fresh agent                   |
| `lazy`       | `/lazy`       | Force the minimum correct solution via a decision ladder                 |
| `lock-in`    | `/lock-in`    | Validate and update project docs to match current state                  |
| `show-me`    | `/show-me`    | Render a visual answer as self-contained HTML and open it in the browser |
| `status`     | `/status`     | Audit repo docs, git state, and gates; report standing and next action   |

`greenfield` requires the [OpenSpec](https://github.com/Fission-AI/OpenSpec) CLI
and its `opsx` commands (`explore`, `propose`, `update`, `apply`, `sync`,
`archive`). Install the
CLI with `npm i -g @fission-ai/openspec`, then run `openspec init` in the
project, or install the opsx commands and skills once for the agent and run
`openspec init --tools none` per project.

### Install

**Claude Code**

```bash
cp -r skills/<skill> ~/.claude/skills/
# or project-level: .claude/skills/
```

**Pi / other agents**

Copy the `SKILL.md` content into the agent's skill/instruction system, or place the folder where the agent loads skills from.

## License

[MIT](LICENSE)
