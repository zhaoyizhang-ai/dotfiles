# Research Mode

Use this file for `/initiate-research` and systematic research sessions.

Original source to inspect for exact wording:

- `assets/original-framework/.claude/commands/initiate-research.md`
- `assets/original-framework/.claude/agents/context-parser.md`
- `assets/original-framework/.claude/agents/research-coordinator.md`
- `assets/original-framework/.claude/agents/prompt-generator.md`
- `assets/original-framework/.claude/agents/research-synthesizer.md`

## Workflow

1. Choose input mode.
   - If the user already gave a topic/brief, parse it as free-form context.
   - Otherwise ask for the minimum missing context rather than running a long interview by default.
2. Extract or gather:
   - Research topic
   - Objectives
   - Existing knowledge
   - Scope and exclusions
   - Desired depth: exploratory, comprehensive, exhaustive
   - Output format
   - Timeline
   - Source preferences
3. Save `context/from-human/project-context.md`.
4. Create `prompts/queue/research-plan.md`.
5. Create 3-5 initial prompts in `prompts/run/initial/`, commonly:
   - `01-exploratory-research.md`
   - `02-key-concepts.md`
   - `03-current-state.md`
6. Initialize `notes/research-log.md` and `scratchpad/working-notes.md`.
7. Ask whether to begin executing prompts or review the plan first, unless the user clearly asked to proceed autonomously.
8. Execute prompts one by one:
   - Browse/search for current or uncertain information.
   - Save focused findings in `outputs/individual/`.
   - Update `notes/research-log.md`.
   - Generate follow-up prompts in `prompts/run/subsequent/`.
9. Synthesize at natural breakpoints or when requested:
   - Save Markdown report to `outputs/aggregated/mk-combined/`.
   - Generate PDF/TTS/SSML only if requested or useful.

## Context File Template

```markdown
# Project Context

## Research Topic

## Objectives

## Existing Knowledge

## Scope And Boundaries

## Depth

## Timeline

## Source Preferences

## Expected Deliverables
```

## Research Plan Template

```markdown
# Research Plan

## Main Questions

## Sub-Questions

## Research Sequence

## Phases

## Sources To Prioritize

## Initial Prompts
```

## Research Log Template

```markdown
# Research Log - [Topic]

## Project Start Date

## Research Objectives

## Sessions

### Session 1 - [Date]
**Focus:**
**Key Findings:**
**Questions Raised:**
**Next Steps:**
```

## Quality Rules

- Include citations and source links for research claims.
- Distinguish facts, interpretations, and open uncertainties.
- Document dead ends to avoid repeated work.
- Preserve individual findings before synthesis.
