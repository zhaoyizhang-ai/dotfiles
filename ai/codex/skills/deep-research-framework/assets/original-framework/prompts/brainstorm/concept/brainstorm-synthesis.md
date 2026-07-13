# Brainstorm Synthesis Report

## Objective
Generate a comprehensive final report that aggregates all brainstorm outputs into a single, coherent document.

## Input Sources
Read and synthesize the following files:
- `context/from-human/brainstorm-context.md` — Problem definition
- `outputs/brainstorm/ideation-rounds/round-*.md` — All divergence rounds
- `outputs/brainstorm/idea-board/idea-board.md` — Clustered ideas
- `outputs/brainstorm/anchor-cards/cluster-*-anchor.md` — Literature anchoring results
- `outputs/brainstorm/evaluation/scoring-matrix.md` — Multi-criteria evaluation
- `outputs/brainstorm/evaluation/devils-advocate.md` — Stress-test results (if exists)
- `outputs/brainstorm/concept-briefs/concept-*.md` — Developed concepts
- `notes/brainstorm-log.md` — Session history

## Report Structure

```markdown
# Brainstorm Synthesis Report: [Topic]

## Date
[Date]

## 1. Executive Summary
- Problem statement (one paragraph)
- Number of ideas generated → clusters formed → concepts developed
- Top recommended concept(s) with one-line rationale

## 2. Problem Definition
[Reproduced from brainstorm-context.md with any refinements made during the process]

## 3. Ideation Journey
### 3.1 Divergence Statistics
| Round | Technique | Ideas | New Directions | Duplication % |
|-------|-----------|-------|----------------|---------------|

### 3.2 Technique Effectiveness
- Most productive technique: ...
- Most novel ideas came from: ...
- Observations on technique sequencing: ...

## 4. Idea Landscape
### 4.1 Cluster Overview
[Summary table of all clusters with theme, size, and one-line description]

### 4.2 Cross-Cluster Synergies
[Reproduced from idea board, with additional analysis]

## 5. Literature Anchoring Summary
### 5.1 Novelty Assessment
| Cluster | Novelty Rating | Closest Prior Art | Key Differentiator |
|---------|---------------|-------------------|-------------------|

### 5.2 Feasibility Overview
| Cluster | Feasibility | Key Dependencies | Implementation Complexity |
|---------|-------------|------------------|--------------------------|

### 5.3 Key Literature Findings
[Top 3-5 most important literature discoveries across all clusters]

## 6. Evaluation Results
### 6.1 Scoring Matrix
[Reproduced from scoring-matrix.md]

### 6.2 Ranking and Rationale
[Ordered list with brief justification for each position]

## 7. Recommended Concepts
[For each developed concept brief, provide a condensed summary:]

### 7.1 [Concept Name]
- **Core mechanism**: ...
- **Novelty**: ★★★☆
- **Feasibility**: ...
- **Key risk**: ...
- **Literature support**: [top 1-2 references]
- **Next step**: ...

### 7.2 [Concept Name]
...

## 8. Key Insights
- [Insight 1]: [What was learned that wasn't obvious at the start]
- [Insight 2]: ...
- [Insight 3]: ...

## 9. Recommendations
### Immediate Actions
- ...

### Further Investigation Needed
- ...

### Ideas Parked for Future Exploration
- [Promising ideas not developed in this session]

## 10. Appendix
- Links to all individual outputs
- Full cluster list with all ideas
- Complete literature references
```

## Output Location
Save to `outputs/aggregated/mk-combined/[date]-[topic]-brainstorm-synthesis.md`

## Quality Requirements
- All claims traced back to specific outputs or literature
- No new ideas introduced — this is purely synthesis
- Maintain consistent evaluation criteria throughout
- Ensure concept summaries faithfully represent the full concept briefs
