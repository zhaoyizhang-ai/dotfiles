---
name: progress-read
description: Read a compact project progress.md handoff before starting work. Use when the user asks an AI to continue a project, open a new window/session, understand current research progress, inspect what the previous AI did, identify next steps, or avoid repeated pitfalls from prior attempts.
---

# Progress Read

Use this skill to turn `progress.md` into an actionable handoff for the current task.

## Workflow

1. Locate `progress.md`.
   - Prefer `./progress.md` in the current workspace.
   - If it is missing, say so briefly and fall back to `.memory/MEMORY.md`, repo docs, and local inspection as needed.
2. Read the entire file before acting.
3. Extract only task-relevant context:
   - current project state
   - active goal and next command/experiment
   - required files, checkpoints, hosts, or paths
   - pitfalls, failed attempts, and "do not repeat" notes
   - validation evidence already collected
4. If the user already described the next task, tailor the handoff to that task.
5. Before changing files or launching jobs, call out any high-risk mismatch between the requested next task and the recorded project state.

## Response Shape

Keep the readout compact. Prefer this structure:

```markdown
Current state:
- ...

For this task:
- ...

Do not repeat:
- ...

Suggested first move:
- ...
```

Do not recite old completed stages unless they directly constrain the current task.

## Compression Rule

Treat completed goals in `progress.md` as background, not as active work. If a completed goal appears verbose or stale, mention that the next `$progress-update` should compress it rather than carrying it forward.
