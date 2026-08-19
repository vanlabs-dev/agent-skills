---
name: status
description: Project status audit for the repo in the current directory. Reviews the project's own docs, git state, and quality gates, then reports what the project does, where it stands, and the single most critical pending next action. Use when asked "status", "where is this project at", "audit this project", or when starting work in an unfamiliar repo.
---

Audit the project in the current working directory. Report standing and the next action. Work in four steps.

## 1. Read the project's own story

Read in this order. Stop when the picture is clear:

1. `AGENTS.md` or `CLAUDE.md` at the repo root.
2. `README.md`.
3. Planning artifacts that exist: `docs/plan.md`, `docs/spec.md`, `ROADMAP.md`, `TODO.md`, `CHANGELOG.md`, or similar. Check GitHub issues if `gh` is available.
4. Any other high-level docs that describe current direction.

Do not read source code at this stage.

## 2. Check git state

```bash
git status --short --branch
git log --oneline -10
git log origin/main..HEAD --oneline 2>/dev/null || git log origin/master..HEAD --oneline 2>/dev/null || true
```

Note uncommitted files, how far the branch is ahead of the main deploy branch, whether recent commits are code or docs, and any secret-looking untracked files that are not gitignored.

## 3. Run the cheap gates

Detect gates from CI config, package.json, pyproject.toml, Makefile, or equivalent. Run lint and unit tests only if they run locally without credentials and finish in under ~2 minutes. Skip live or integration suites. Say when you skip them. If no gates exist, say so.

## 4. Report

Use this fixed format. Keep it compressed. No filler.

**What it is**: 2-3 sentences covering purpose, stack, and how it runs or ships.

**Standing**: bullets, most important first:

- Shipped or deployed state and what the last commits delivered
- Gates result (tests passed/skipped, lint verdict)
- Branch drift from the deploy branch
- Active planned work and its completeness
- Hygiene flags, if any

**Next action**: one bullet. The single most critical pending action. Make it concrete enough to start immediately. Prefer the repo's own planning artifacts. Only infer from gaps if no plan exists. If nothing is pending, say so.
