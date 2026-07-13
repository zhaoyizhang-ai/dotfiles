---
name: progress-update
description: Update a compact project progress.md handoff after a work session. Use when the user asks to record what happened, prepare the next AI/session/window, maintain project progress, summarize this round's research or experiments, capture pitfalls, or compress completed goals so future agents can continue efficiently.
---

# Progress Update

Use this skill to maintain `progress.md` as an AI handoff document, not a chronological diary.

## Workflow

1. Locate `progress.md` in the current workspace. If it does not exist, create it from the template below.
2. Read the whole file before editing.
3. Review the current turn's actual work:
   - files changed
   - commands, jobs, runs, or experiments launched
   - observed results and validation evidence
   - blockers, failed attempts, and important user corrections
   - the user's intended next task, if stated
4. Update the document with the smallest useful diff.
5. Compress aggressively:
   - Keep active, unfinished work explicit.
   - Move completed small goals into one-line milestones.
   - Delete stale todos that no longer affect the next task.
   - Merge repeated pitfalls into a single durable warning.
   - Preserve exact paths, checkpoint names, job ids, config names, and commands when they are needed to continue.
6. After editing, briefly report what changed and where.

## Document Contract

`progress.md` should stay under about 250 lines. If it grows beyond that, compress before adding more.

Use these sections in this order:

```markdown
# Progress

Last updated: YYYY-MM-DD HH:MM TZ

## Current State
- One to five bullets describing the live state of the project.

## Active Goal
- Goal:
- Next likely step:
- Success signal:
- Owner notes:

## Next AI Should Know
- Task-specific context, commands, paths, and assumptions.

## Do Not Repeat
- Durable pitfalls, failed commands, bad configs, or invalid assumptions.

## Open Questions
- Only unresolved questions that affect the next action.

## Compressed Milestones
- YYYY-MM-DD: Completed result in one line, with key artifact/path if needed.
```

## Writing Rules

- Write for the next AI, not for a human progress report.
- Prefer exact evidence over vibes: include `rc=0`, checkpoint path, output file, metric, or observed failure.
- Preserve the user's scripts/configs by default: do not overwrite existing scripts or modify them in place unless the user explicitly asked for that exact operation. Prefer a clearly named derived file, a small reviewable patch, or a backup before replacing anything.
- Do not duplicate facts already easy to grep from the repo unless they are needed for handoff.
- Do not store secrets.
- Do not add a temporary todo unless the next AI can act on it.
- If a goal is fully complete, remove it from `Active Goal` and summarize it under `Compressed Milestones`.
- If the user says what the next AI will do, make `Next AI Should Know` and `Active Goal` revolve around that next task.
