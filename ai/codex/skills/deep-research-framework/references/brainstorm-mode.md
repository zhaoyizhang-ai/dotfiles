# Brainstorm Mode

Use this file for `/initiate-brainstorm`, literature-anchored ideation, and concept proposal generation.

Original source to inspect for exact wording:

- `assets/original-framework/.claude/commands/initiate-brainstorm.md`
- `assets/original-framework/.claude/agents/context-parser.md`
- `assets/original-framework/.claude/agents/brainstorm-coordinator.md`
- `assets/original-framework/.claude/agents/idea-generator.md`
- `assets/original-framework/.claude/agents/idea-evaluator.md`
- `assets/original-framework/prompts/brainstorm/`

## Seven-Phase Workflow

1. Problem framing
2. Divergent ideation
3. Clustering and organization
4. Literature anchoring
5. Multi-criteria evaluation
6. Concept development
7. Synthesis report

## Context To Gather

- Core challenge
- Hard and soft constraints
- Degrees of freedom
- Success criteria and weights
- Domain boundaries
- Known solutions to avoid duplicating
- Expected output count and detail level
- Literature depth: quick scan, moderate, systematic

Save as `context/from-human/brainstorm-context.md`.

## Ideation

Select 3-5 techniques from the preserved prompt library:

- `prompts/brainstorm/techniques/scamper.md`
- `prompts/brainstorm/techniques/analogy-transfer.md`
- `prompts/brainstorm/techniques/constraint-removal.md`
- `prompts/brainstorm/techniques/reverse-thinking.md`
- `prompts/brainstorm/techniques/random-stimulus.md`

Rules:

- Generate at least 8 ideas per round.
- Do not filter during divergence.
- Save each round to `outputs/brainstorm/ideation-rounds/round-XX-[technique].md`.
- Track idea count, new directions, overlap, and technique effectiveness.
- Aim for at least 30 raw ideas before clustering unless the user requests a lighter pass.

## Clustering

Merge duplicates, group ideas semantically, and tag themes. Save:

`outputs/brainstorm/idea-board/idea-board.md`

Ask the user to confirm clusters before literature anchoring unless they asked for autonomous execution.

## Literature Anchoring

For each confirmed cluster:

1. Generate search queries.
2. Check prior art.
3. Gather feasibility evidence.
4. Identify risks and failure cases.
5. Save an anchor card:
   `outputs/brainstorm/anchor-cards/cluster-XX-anchor.md`
6. Save reusable literature notes under `outputs/individual/`.

Use current search for recent literature and include source links.

## Evaluation

Build `outputs/brainstorm/evaluation/scoring-matrix.md` with weighted scores for novelty, feasibility, impact, alignment, urgency, or user-defined criteria. Run Devil's Advocate analysis for top-ranked clusters and save:

`outputs/brainstorm/evaluation/devils-advocate.md`

## Concept Development And Synthesis

For selected clusters, generate concept briefs in:

`outputs/brainstorm/concept-briefs/`

Then synthesize into:

`outputs/aggregated/mk-combined/[date]-[topic]-brainstorm-synthesis.md`

Use the preserved templates in `assets/original-framework/prompts/brainstorm/concept/` when useful.
