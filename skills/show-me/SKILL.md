---
name: show-me
description: Render a visual answer as a self-contained HTML page and open it in the browser instead of describing it in prose. Use when the user types /show-me, says "show me", "let me see it", "what does it look like", "give me options", or when the next response would be a plan, layout, comparison, dashboard, or set of choices. Optional gate inside /greenfield Brainstorm and Design.
---

A render the human has not seen does not exist. Show, then speak.

## Fire when

The response would otherwise be:

- a set of directions the human must choose between
- a layout, wireframe, screen, or visual design
- a structure, roadmap, or phase plan
- a comparison of two or more things across shared criteria
- a status, review, or report the human will scan, not read

Rule of thumb: if they would read it twice, draw it once.

## Do not fire when

- The answer is code, config, a command, or anything they will paste elsewhere.
- The answer is short and factual.
- The render would restate a list that is already clear in three lines.
- The output is a chart or graph. Use `/dataviz` for that.
- The page is a deliverable someone else will read. Publish an Artifact instead.

## Offer, do not ambush

Rendering costs the human a context switch. Ask first when the work is mid-flow:

> Three directions are ready. Render them side by side, or take them as text?

Fire without asking when the human said "show me", asked what something looks
like, or asked for options.

Skip on request and continue in prose. Do not re-offer in the same phase.

## Modes

### SHOW: one thing, or versions of one thing

1. Write a complete self-contained HTML file.
2. Open it and bring the browser forward.
3. Then give one verdict line and one next step.

### PICK: choose between directions

- Three options minimum. Two is a disguised yes/no.
- All options on one page, side by side, same scale.
- Each card carries a short name for the device (not the decoration) and one
  line stating the argument it makes.
- Apply the one-sentence test: if the same sentence fits two cards, that is one
  idea in two coats of paint. Redesign before rendering.
- Label the cards A, B, C. The human replies with a letter. No buttons.
- Never ask the human to choose between visual options that exist only as prose.

## HTML rules

- Self-contained: inline CSS, no CDN, no external fonts, no network calls. It
  must render with the network off.
- Include `<meta charset="utf-8">` and a `<title>`.
- Plain structure, high contrast, generous whitespace. No textures or grids
  behind text.
- Inline SVG or base64 for images. Local file paths break.
- JavaScript only when the judgment needs interaction. Static is the default.
- Greyscale when the judgment is about structure, and say so in the lede.
- Never use em dashes.

## Where the file goes

Throwaway render, this session only:

```
$SCRATCHPAD/show-me-<slug>.html
```

Render that a decision will rest on, inside a `/greenfield` lifecycle:

```
docs/greenfield/<slug>/renders/<phase>-<name>.html
```

Reference that path in the phase artifact next to the decision it produced. A
decision that came from a picture should point at the picture.

Never write renders to the repo root or to `/tmp`.

## Opening it

```bash
xdg-open /absolute/path/to/file.html
```

Focus handling is weak on Linux. Prefer a browser that is already running. A
zero exit code proves the command ran, not that they saw it. Say the path in
your reply so they can open it themselves.

## What you say

- Lead with the verdict, not the process.
- Never narrate how you built the page.
- End with one next step on its own line, doable now.

```
Three directions for the settings panel.

Next: reply A, B, or C and I lock the design.
```

## Integration

- `/greenfield` Brainstorm: offer PICK once the directions and their trade-offs
  are settled, before asking for approval of the chosen direction. Record the
  choice in `01-brainstorm.md` as usual.
- `/greenfield` Design: offer SHOW for structure or layout before the human
  approval line. The render supports the approval, it does not replace it.
- `/lazy` still applies. Choose the minimum correct visual. Decoration is code
  that was never asked for.
- `/status` and `/lock-in` output stays text. Neither is a rendering job.
