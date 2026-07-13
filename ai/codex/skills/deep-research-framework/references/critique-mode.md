# Critique Mode

Use this file for `/critique-ideas`, idea filtering, prioritization, and selection after brainstorming or research.

Original source to inspect for exact wording:

- `assets/original-framework/.claude/commands/critique-ideas.md`
- `assets/original-framework/prompts/critique/evaluation/scoring-criteria.md`
- `assets/original-framework/prompts/critique/templates/`

## Workflow

1. Locate ideas.
2. Configure critique session.
3. Collect user annotations.
4. Scan context.
5. Filter.
6. Re-rank.
7. Validate and frame next steps.

## Locate Ideas

Search in this order:

1. `outputs/brainstorm/idea-board/`
2. `outputs/brainstorm/scoring-matrix.md`
3. `outputs/brainstorm/synthesis-report.md`
4. `outputs/brainstorm/concept-briefs/`
5. User-provided pasted ideas

If multiple sources exist, summarize idea IDs, titles, clusters, and prior scores.

## Session Configuration

Ask only what is necessary. Defaults:

- Annotation depth: selective comments
- Filtering aggressiveness: moderate, about 40-50% survive
- Framework: criteria-weighted scoring
- Criteria set: research papers if the project is academic; engineering-heavy if it is implementation-focused; standard otherwise

Available lenses:

- Six Thinking Hats
- Pre-Mortem
- Criteria-Weighted Scoring
- Red Team / Steel Man

## User Annotation

Collect Star/Maybe/Kill decisions and optional comments. Save:

`outputs/brainstorm/critique/user-annotations.md`

Use this structure:

```markdown
# User Idea Annotations
**Date:** [date]
**Session:** [topic]

## Session Configuration

## Individual Idea Notes
| Idea ID | Title | User Verdict | User Notes |
|---|---|---|---|

## Strategic Preferences

## Section-Level Comments
```

## Context Scan

Read executive summaries only unless deeper evidence is needed:

- first 30 lines of each `outputs/individual/` report
- prior critique reports in `outputs/brainstorm/critique/`
- scoring matrices or anchor cards if available

Extract 5-8 game-changing insights with source and implication.

## Filtering Rules

Apply user verdicts first:

- Kill: eliminate unless new context strongly suggests asking for reconsideration.
- Star: advance.
- Maybe: apply adaptive filtering.

Hard rejects:

- Exceeds stated timeline by more than 2x.
- Conflicts with technical constraints.
- Matches the user's avoid list.
- Is redundant with strong prior art without clear differentiation.

Promote when:

- It has cheap validation.
- It combines well with a Star idea.
- New evidence improves feasibility or novelty.

Report survival rate against target and allow overrides.

## Outputs

Save final critique artifacts under `outputs/brainstorm/critique/`, commonly:

- `user-annotations.md`
- `context-scan.md`
- `filtering-results.md`
- `reranking.md`
- `validation-plan.md`
- `strategic-framing.md`
