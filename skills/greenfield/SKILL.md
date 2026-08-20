---
name: greenfield
description: Enforce a greenfield build lifecycle with mandatory brainstorm, OpenSpec for the change core, explicit fresh-session boundaries, and deterministic verify. Use when starting a new project, a new feature, or any non-trivial build. Use when the user types /greenfield or says they want to start a proper build lifecycle.
---

# Greenfield

Run a full build lifecycle without context rot. Brainstorm is mandatory.
OpenSpec owns the change core. Fresh sessions are required at fixed boundaries.
Documentation must be current before every stop so the next session never
drifts.

## Hard rules

- Brainstorm is mandatory unless the human explicitly overrides it.
- Do not cross a session boundary in the same context. Stop, lock docs, and
  tell the human to start a fresh session.
- Before every stop, durable artifacts and project docs must be accurate.
  Prefer `/lock-in` when docs may have drifted.
- OpenSpec owns explore, propose, update, apply, sync, and archive. Do not
  reinvent those phases.
- Human approval is required on the OpenSpec proposal before apply.
- Verify is deterministic: run the skill verify script and capture real output.
  Non-zero exit means fail.
- Prefer `/lazy` during implementation.
- Keep artifacts short. No essays. Never use em dashes.

## Requirements

OpenSpec must be available: the `openspec` CLI on `PATH`, and the `opsx`
commands or the equivalent `openspec-*` skills installed for the agent. Six
workflows are in play: `explore`, `propose`, `update`, `apply`, `sync`,
`archive`.

The project needs an OpenSpec root before Session 2. If `openspec/` does not
exist, create it once:

```
$ openspec init --tools none
```

Use `--tools none` when the opsx commands are already installed for the agent
outside the project. Otherwise run `openspec init` and let it write the tool
files.

## Why session boundaries exist

Long context degrades model quality. This skill assumes the human will clear
context and start a fresh session at each boundary below. Write every handoff
so a cold agent can continue from docs alone.

## Lifecycle

```
Session 1  Brainstorm          -> lock -> STOP
Session 2  OpenSpec propose    -> human approval -> lock -> STOP
Session 3  Outside-voice       -> lock -> STOP          (optional but recommended)
Session 4  OpenSpec apply      -> verify -> archive -> done
```

Explore may run inside Session 2 before propose. It is optional.

### Session 1 - Brainstorm (mandatory gate)

**Goal:** Turn a rough idea into a clear direction.

**Do:**
- Ask focused questions. Prefer multiple choice.
- Surface constraints, success signals, non-goals, open questions.
- Propose 2 or 3 directions with trade-offs.
- Stop and wait for human approval of the chosen direction.

**Write:** `docs/greenfield/<slug>/01-brainstorm.md` with:
- Goal
- Success signals
- Constraints / non-goals
- Options considered
- Chosen direction
- Open questions

Use a short kebab-case slug derived from the goal. Reuse the same slug as the
OpenSpec change name.

**Before stop:**
- Ensure the brainstorm artifact is complete and accurate.
- Run `/lock-in` if project docs need updating.
- Tell the human: session boundary reached. Start a fresh session and run
  `/greenfield continue <slug>` for Session 2.

**Do not** start OpenSpec or write code in this session.

### Session 2 - OpenSpec propose

**Goal:** Produce the change artifacts OpenSpec expects.

**Do:**
- Read `01-brainstorm.md` and current project docs first.
- Ensure an OpenSpec root exists (see Requirements).
- Optionally run `/opsx:explore` if unknowns remain.
- Run `/opsx:propose` for the change.
- Walk the human through the proposal, specs, design, and tasks.
- Run `/opsx:update` to revise the change if the human asks for edits. Do not
  hand-edit the artifacts.
- Require explicit human approval before leaving this session.

**Before stop:**
- OpenSpec change artifacts must exist and reflect the approved direction.
- Record approval as a line `Approved: <date or name>` in the proposal or in a
  short note under `docs/greenfield/<slug>/`.
- `/lock-in` if needed.
- Tell the human: session boundary reached. Fresh session for outside-voice
  (Session 3) or apply (Session 4).

**Do not** run `/opsx:apply` in this session.

### Session 3 - Outside-voice review (recommended)

**Goal:** Attack the plan with a cold perspective.

**Do:**
- Start from docs and OpenSpec artifacts only. No prior chat memory.
- Challenge edge cases, over-engineering, weak acceptance criteria, hidden
  assumptions.
- Record findings in `docs/greenfield/<slug>/07-review.md`.
- Resolve or explicitly accept critical findings with the human. Fold accepted
  changes back in with `/opsx:update`, not by hand.

**Before stop:**
- Review notes are written.
- `/lock-in` if the proposal or docs changed.
- Tell the human: session boundary reached. Fresh session for apply.

### Session 4 - Apply, verify, archive

**Goal:** Build, prove, and close.

**Do:**
1. Read the current OpenSpec change, review notes, and project docs.
2. Run `/opsx:apply`. Follow `/lazy` rules while implementing.
3. Run the verify script from the project root:

   ```
   $ bash <skill-dir>/scripts/verify.sh <slug> .
   ```

   `<skill-dir>` is the folder holding this `SKILL.md`, for example
   `~/.claude/skills/greenfield/` or `.claude/skills/greenfield/`.

   Capture the full output into `docs/greenfield/<slug>/08-verify.md`. Non-zero
   exit is a fail. Fix and re-run. Do not claim pass without a script PASS.
4. On pass, run `/opsx:archive` so delta specs merge into the living OpenSpec
   library and the change is closed. Use `/opsx:sync` instead only when the
   human wants the specs merged while the change stays open.
5. Update living project docs if behaviour changed.
6. Write a short `docs/greenfield/<slug>/09-ship.md`: what shipped, where
   artifacts live, follow-ups.

**Exit:** OpenSpec change archived, verify PASS recorded, living docs
consistent.

## Session boundary protocol

At every STOP:

1. State which session just finished and which comes next.
2. Confirm durable artifacts are written.
3. Confirm docs are not drifting (use `/lock-in` when unsure).
4. Give the human one clear instruction for the fresh session, including the
   slug and next command.

Example stop line:

```
Session 1 complete. Brainstorm approved and locked.
Start a fresh session, then: /greenfield continue <slug>
(or /opsx:propose if you prefer to enter OpenSpec directly)
```

## Skipping

- The human may skip to a later session explicitly (for example "skip to
  apply").
- Brainstorm may only be skipped on explicit override.
- When skipping, still read existing artifacts. Record the skip in the next
  file you write.
- Never skip the verify script before archive.

## Pickup in a fresh session

When the human continues after a boundary:

1. Read `docs/greenfield/<slug>/` and the OpenSpec change status first
   (`openspec status --change <slug>`).
2. Identify the last completed session from artifacts.
3. Announce the session you are starting and the exit criteria.
4. Do not re-brainstorm or re-propose unless the human asks.

## Integration

- `/lazy` during apply
- `/lock-in` before every session stop when docs may have changed
- `/handover` only if the human is pausing mid-session for a different agent.
  Normal boundaries use the protocol above.
- `/status` to audit standing before or after a change
- `/bro` if any step is unclear
- `/show-me` optional at brainstorm or proposal review when the choice is
  visual

## Artifact layout (thin, beside OpenSpec)

```
docs/greenfield/<slug>/
├── 01-brainstorm.md
├── 07-review.md        (optional)
├── 08-verify.md
└── 09-ship.md
```

OpenSpec owns its own change directory (`openspec/changes/<slug>/`). Do not
duplicate proposal, specs, design, or tasks into `docs/greenfield/`.

If this is a brand-new directory, repository, or environment, follow the
operator's own layout and scaffold conventions before writing code. This skill
does not define them.
