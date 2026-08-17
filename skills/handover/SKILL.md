---
name: handover
description: Create a clean structured handoff document for a fresh agent to continue the work. Use when the user types /handover or asks to hand over the current session. Saves only to the global ~/data/handovers directory and never touches project files.
argument-hint: Optional focus for the next session
disable-model-invocation: true
---

Create a one-time handoff document so a fresh agent can continue the work cleanly.

## Hard rules

- Save the file **only** to the global directory `~/data/handovers/`. Never write into the current project, workspace, or any project-related folder.
- Create `~/data/handovers/` if it does not exist.
- Do not create, update, or leave any pointer, reference, or mention of this handoff file inside the project (no README notes, no links, no comments, no git commits about it).
- This is a disposable transfer document. It must never be treated as living project documentation.
- Do not update or expand any previous handoff files. Always create a brand-new file.
- Redact all secrets, API keys, passwords, tokens, and personal identifiers.
- Do not duplicate content that already lives in durable artifacts (specs, plans, ADRs, issues, commits, PRs, diffs). Reference them by path or URL instead.
- Write the entire document in DIRECT style: short clean sentences, active voice, no fluff, one idea per sentence where practical.

## File naming

Use this exact pattern:

`YYYY-MM-DD_HHMM_<short-slug>.md`

Example: `2026-08-17_2015_auth-refactor.md`

The short-slug should be 2-5 words that capture the focus of the next session.

## Document structure

Use this exact structure every time:

```markdown
# Handover: <short title>

> DISPOSABLE TRANSFER DOCUMENT
> Created: <timestamp>
> This file is a one-time handoff. Do not treat it as project documentation. Do not keep it updated. Do not reference it from the codebase.

## Goal of next session
<1-3 sentences. What the next agent should achieve.>

## Current state
- Branch / commit (if relevant)
- What is already done
- What is in progress
- Key decisions already made

## Open questions
- ...

## Blockers
- ...

## Next actions
1. ...
2. ...
3. ...

## References
- path/or/url : short note
- ...

## Suggested skills
- `skill-name` : why it is useful for the next session
- ...

## Notes for the next agent
<Any critical context, constraints, or working-style notes that are not already covered above.>
```

## Behaviour when arguments are given

If the user provided an argument (the focus of the next session), use it to tightly scope the Goal, Next actions, and Suggested skills sections.

## After writing the file

Reply with only:

- The full path of the file you created
- A one-sentence confirmation that the handoff is ready

Nothing else.
