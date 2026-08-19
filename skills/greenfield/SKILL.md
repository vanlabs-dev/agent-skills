---
name: greenfield
description: Enforce the full greenfield development lifecycle from brainstorm to ship. Use when starting a new project, a new feature, or any non-trivial build. Brainstorm is the mandatory first step unless the human explicitly overrides. Use when the user types /greenfield or says they want to start a proper build lifecycle.
---

# Greenfield

Enforce a complete development lifecycle. Prevent drift. Produce clear
artifacts. Allow human skips after the first gate.

## Hard rules

- Brainstorm is mandatory before any creative or implementation work unless the
  human explicitly says to skip it.
- Do not jump phases. Complete or explicitly skip the current phase before
  starting the next.
- Every phase writes or updates an artifact under `docs/greenfield/<slug>/`.
- Human approval is required at Spec and Design. Approval is a literal line
  `Approved: <date or name>` in the artifact. The same format in both.
- Implementation starts in a fresh session. The session that ran Brainstorm
  stops after Task breakdown. See the session boundary below.
- Verify is deterministic: run the skill's verify script, capture its full
  output, and treat non-zero exit as failure. Claims without script evidence
  are rejected.
- Prefer `/lazy` rules during Implement.
- Keep artifacts short and structured. No essays.
- Never use em dashes in any artifact. Use a comma, a colon, parentheses, or a
  new sentence instead.

## Artifact layout

```
docs/greenfield/<slug>/
├── 01-brainstorm.md
├── 02-explore.md          (optional)
├── 03-spec.md
├── 04-design.md
├── 05-tasks.md
├── 06-implement.md
├── 07-review.md
├── 08-verify.md
└── 09-ship.md
```

Use a short kebab-case slug derived from the goal.

## Phase sequence

### 1. Brainstorm (mandatory gate)

**Goal:** Turn a rough idea into a clear direction.

**Do:**
- Ask focused questions (prefer multiple choice when possible).
- Surface constraints, success signals, non-goals, and open questions.
- Propose 2 or 3 directions with trade-offs.
- Once the directions are settled, offer `/show-me` (PICK mode) to render them
  side by side. Optional. Accept a skip and continue in prose.
- Stop and wait for human approval of the chosen direction.

**Artifact:** `01-brainstorm.md` with sections:
- Goal
- Success signals
- Constraints / non-goals
- Options considered
- Chosen direction
- Open questions

**Exit:** Human has approved the chosen direction. Only then proceed.

### 2. Explore (optional)

**Goal:** Reduce unknowns before writing the spec.

**Do only if useful:** read existing code, compare approaches, check
constraints, answer open questions from brainstorm.

**Artifact:** `02-explore.md`: findings, decisions, remaining unknowns.

**Skip when:** the human already knows the shape, or brainstorm was enough.

### 3. Spec / PRD (human gate)

**Goal:** Define what will be built and what done means.

**Required sections in `03-spec.md`:**
- Problem / outcome
- In scope
- Out of scope
- Acceptance criteria (concrete, testable)
- Non-functional constraints (if any)
- Open questions (must be empty or explicitly deferred)

**Exit:** Human marks the spec approved with a line `Approved: <date or name>`.
Do not proceed without it.

### 4. Design / Plan (human gate)

**Goal:** Decide how it will be built.

**Required sections in `04-design.md`:**
- Approach
- Key decisions and rationale
- Structure / boundaries
- Risks and mitigations
- What is deliberately left flexible

**Optional:** if the design has a visible shape (layout, screen, structure),
offer `/show-me` (SHOW mode) before asking for approval. The render supports the
approval, it does not replace it. Store it under
`docs/greenfield/<slug>/renders/` and reference it from the artifact.

**Exit:** Human marks the design approved with a line
`Approved: <date or name>`. Do not proceed without it.

### 5. Task breakdown

**Goal:** Turn design into an ordered, checkable list.

**Artifact:** `05-tasks.md`: short, ordered tasks. Each task should be
completable in one focused pass. Mark dependencies if needed.

**Exit:** Task list exists and is coherent with the design.

### Session boundary (mandatory pause)

The planning session ends here. Do not begin Implement in the session that ran
Brainstorm. A fresh session reads the artifacts cold, which is the point: if
the artifacts are not enough to build from, they were not done.

**Do:**
- Run `/handover` so the handover notes capture anything the artifacts missed.
- Give the human a kickoff command for the new session, filled in:

  ```
  /greenfield implement <slug>. Read docs/greenfield/<slug>/ first, then
  continue from 05-tasks.md.
  ```

- Stop. Wait for the human to start the new session.

If Implement is requested in the same session anyway, name the risk (context
bleed from planning) and proceed only on explicit confirmation.

### 6. Implement

**Goal:** Build the thing.

**Rules:**
- Confirm this is a fresh session. If this session ran Brainstorm, stop and
  follow the session boundary above instead.
- Read `docs/greenfield/<slug>/` before writing code.
- Follow `/lazy` (minimum correct solution, surgical changes).
- Check off tasks in `05-tasks.md` as they complete.
- Record deviations from the design, surprises, and wrong turns in
  `06-implement.md`. Wrong turns are part of the record, not noise.
- Do not expand scope. New ideas go to open questions or a future change.
- If this is a brand-new directory, repository, or environment, follow the
  operator's own layout and scaffold conventions before writing code. This
  skill does not define them.

### 7. Outside-voice review

**Goal:** Get a second perspective before claiming done.

**Do:**
- Summarize intent, key decisions, and the diff or main changes.
- Ask a fresh session (or different model) to attack the plan and
  implementation: missing edge cases, over-engineering, unclear acceptance
  criteria, hidden assumptions.
- Record findings and responses in `07-review.md`.

**Exit:** Review notes exist. Critical findings are resolved or explicitly
accepted by the human.

### 8. Verify (deterministic gate)

**Goal:** Prove the acceptance criteria are met.

**Do:**
- Run the verify script from the project root:

  ```
  $ bash <skill-dir>/scripts/verify.sh <slug> .
  ```

  `<skill-dir>` is the folder holding this `SKILL.md`, for example
  `~/.claude/skills/greenfield/` or `.claude/skills/greenfield/`.

- Capture the full script output into `08-verify.md`.
- Map each acceptance criterion to evidence (pass/fail plus a pointer to
  output or test name).
- If the script exits non-zero, the phase has failed. Fix issues and re-run.
  Do not claim pass.

**Exit:** `08-verify.md` contains the real script output and a clear PASS
verdict from the script. No script run means no pass.

### 9. Ship + Archive

**Goal:** Close the loop and prevent future drift.

**Do:**
- Update living project docs if behavior changed (`README`, `AGENTS.md`,
  specs, etc.).
- If a new durable directory was created, record it wherever this machine
  tracks its layout.
- Write a short `09-ship.md`: what shipped, where the artifacts live, any
  follow-ups.
- Archive or leave the `docs/greenfield/<slug>/` folder as the record of this
  change.
- Prefer a clean commit message that references the slug or spec.

**Exit:** Living docs are consistent with the shipped state. Artifact set is
complete.

## Skipping phases

- The human may directly request a later phase (e.g. "skip to design" or
  "/greenfield verify").
- When skipping, still read any existing earlier artifacts for context.
- Brainstorm may only be skipped when the human explicitly overrides the gate.
- Record skips briefly in the next artifact you write ("Skipped explore:
  requirements already clear").

## Phase awareness

At the start of every response in this skill, know:
1. Which phase is active
2. What artifact it must produce or update
3. What the exit criteria are
4. What the next phase is

If the human asks to jump ahead, confirm the skip and state what will be
missing.

## Integration with other skills

- Use `/lazy` during Implement.
- Use `/lock-in` when documentation must be made accurate before a session
  boundary.
- Use `/status` to audit standing before or after a change.
- Use `/handover` at the session boundary, and when pausing mid-lifecycle for
  a fresh agent.
- Use `/bro` if any phase output is unclear to the human.
- Offer `/show-me` at Brainstorm and Design when the decision is visual. Always
  optional, never a gate.
