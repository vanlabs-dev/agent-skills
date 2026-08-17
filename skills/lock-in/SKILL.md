---
name: lock-in
description: Validate and update all project documentation so it accurately reflects the current code and state. Use when the user types /lock-in or needs docs ready for a fresh session.
---

Validate and update project documentation so it is accurate and ready for a fresh session.

## Goal

Make documentation the reliable source of truth. A new session must be able to trust the docs without re-discovering the current state. Keep documentation lean.

## Hard rules

- Check documentation against the actual current code and project state.
- Update any documentation that is outdated, incomplete, or incorrect.
- Prefer updating existing docs over creating new ones.
- Do not invent features, decisions, or status that do not exist in the code or conversation.
- Keep changes minimal and precise.
- Write all documentation updates in clear, direct language.
- Prefer current truth over history. Rewrite sections so they describe the present state.
- Do not scatter old explanations throughout the documentation.
- When a project has intentionally pivoted away from a previous direction, keep a short, clearly scoped section such as "Previous direction" or "Intentional pivot". This exists only to prevent the project from being pulled back toward an abandoned approach. Keep it brief and separated from current-state documentation.
- Do not turn ordinary documentation into a changelog. Leave dedicated changelog files alone unless they themselves are inaccurate.
- Detect duplicate or conflicting information across docs. Surface these to the user and wait for approval before changing them.
- Favour lean documentation. Remove or rewrite sections that add length without adding current value.

## Process

1. Identify the key documentation files in the project (README, AGENTS.md, CLAUDE.md, docs/, architecture notes, ADRs, status files, etc.).
2. Compare each relevant document against the current code, file structure, and known decisions.
3. Update any section that is no longer accurate. Rewrite for current truth instead of appending history.
4. Add missing critical information only when it is required for a new session to continue correctly.
5. If an intentional pivot exists, ensure there is a short, clearly scoped section that records the old direction so it is not accidentally revived. Do not let this information bleed into current-state sections.
6. Check for duplicate or conflicting statements across documents. List them clearly and ask the user how to resolve them before making changes.
7. Make only the approved updates.

## Response format

After completing the work, reply with:

- A short list of files that were updated (or confirm none needed changes)
- Any duplicate or conflicting information that needs a decision
- One sentence confirming the documentation is now accurate and ready for a fresh session

Do not add extra commentary.
