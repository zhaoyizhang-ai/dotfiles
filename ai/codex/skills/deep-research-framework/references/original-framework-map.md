# Original Framework Map

Use this file when explaining the migration or locating preserved behavior.

## Preserved Sources

The original Claude Deep Research Framework is copied at:

`assets/original-framework/`

Important preserved files:

- `README.md`: overview, quick start, workflow descriptions, directory structure.
- `GETTING-STARTED.md`: first-session walkthroughs.
- `CLAUDE.md`: original repository behavior instructions.
- `new-research.sh`: original Claude-oriented project scaffold script.
- `.claude/commands/initiate-research.md`: deep research entry workflow.
- `.claude/commands/initiate-brainstorm.md`: brainstorm entry workflow.
- `.claude/commands/critique-ideas.md`: idea critique/filter workflow.
- `.claude/agents/*.md`: specialized agent role prompts.
- `prompts/brainstorm/`: brainstorm technique/evaluation/concept templates.
- `prompts/critique/`: critique rubrics and templates.
- `Inquiro/`: preserved Swift/macOS project shipped with the source; it is not required for the Codex skill workflow.

## Claude-To-Codex Mapping

Claude slash command files become Codex workflow references:

| Claude entry | Codex behavior |
| --- | --- |
| `/initiate-research` | Read `references/research-mode.md`, then execute the workflow directly. |
| `/initiate-brainstorm` | Read `references/brainstorm-mode.md`, then execute the workflow directly. |
| `/critique-ideas` | Read `references/critique-mode.md`, then execute the workflow directly. |

Claude agents become role guidance that Codex can inspect as needed:

| Original agent | Use in Codex |
| --- | --- |
| `context-parser.md` | Parse free-form user input into structured research/brainstorm fields. |
| `research-coordinator.md` | Manage research phases, logs, session boundaries, and deliverables. |
| `prompt-generator.md` | Create initial/follow-up prompts and research plans. |
| `research-synthesizer.md` | Aggregate individual findings into reports and alternative formats. |
| `brainstorm-coordinator.md` | Enforce diverge-anchor-converge phase gates. |
| `idea-generator.md` | Run structured ideation techniques. |
| `idea-evaluator.md` | Anchor clusters in literature and produce scoring matrices. |

## Migration Notes

- The original script launches `claude`; the Codex adapter script does not. It creates the same project structure and writes a Codex `AGENTS.md`.
- Keep original files untouched when possible. Add Codex improvements beside them.
- If a user asks whether the migration is "lossless", verify the copied asset tree still contains `.claude`, `prompts`, `CLAUDE.md`, `README.md`, `GETTING-STARTED.md`, `new-research.sh`, and `Inquiro/`.
