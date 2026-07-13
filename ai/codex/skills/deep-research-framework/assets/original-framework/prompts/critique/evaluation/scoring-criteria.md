# Critique Scoring Criteria

Default evaluation criteria for idea ranking. These can be customized per session.

## Critical Thinking Frameworks

The `/critique-ideas` command supports multiple evaluation frameworks. The criteria sets below are used when **Criteria-Weighted Scoring** is selected.

For other frameworks:
- **Six Thinking Hats**: No numeric criteria — uses 6-perspective qualitative analysis
- **Pre-Mortem**: Ranks by survivability (# of mitigatable failure modes)
- **Red Team / Steel Man**: Ranks by Steel Man verdict strength

## Standard Criteria Set

| Criterion | Default Weight | Scale | Description |
|-----------|---------------|-------|-------------|
| **Novelty** | 0.20 | 1-5 | 5 = no prior work exists; 1 = well-known technique |
| **Impact** | 0.25 | 1-5 | 5 = changes how the field works; 1 = marginal improvement |
| **Speed-to-test** | 0.20 | 1-5 | 5 = validate in 1-2 days; 1 = needs months |
| **Implementation simplicity** | 0.20 | 1-5 | 5 = < 50 lines of code; 1 = complete system rewrite |
| **Anti-fragility** | 0.15 | 1-5 | 5 = partial success is still useful; 1 = all-or-nothing |

## Alternative Criteria Sets

### For Engineering-Heavy Projects
| Criterion | Weight |
|-----------|--------|
| Feasibility | 0.30 |
| Impact | 0.25 |
| Implementation complexity | 0.20 |
| Scalability | 0.15 |
| Maintainability | 0.10 |

### For Research Papers
| Criterion | Weight |
|-----------|--------|
| Novelty | 0.25 |
| Physics/Quality improvement | 0.25 |
| Feasibility (within timeline) | 0.20 |
| Generality | 0.15 |
| Elegance | 0.15 |

### For Startup/Product Ideas
| Criterion | Weight |
|-----------|--------|
| Market impact | 0.30 |
| Speed-to-market | 0.25 |
| Technical moat | 0.20 |
| Resource requirements | 0.15 |
| Risk profile | 0.10 |

### Custom Criteria Template

Users can define their own criteria. Provide in this format:

| Criterion | Weight | Description |
|-----------|--------|-------------|
| [Name] | [0.XX] | [What score 5 vs 1 means] |
| ... | ... | ... |

Weights must sum to 1.00. Use 3-7 criteria (fewer = faster, more = thorough).

## Scoring Guidelines

**Score 5:** Exceptional. Top 5% of ideas in this criterion.
**Score 4:** Strong. Clear advantage over alternatives.
**Score 3:** Average. Comparable to typical approaches.
**Score 2:** Below average. Notable weaknesses.
**Score 1:** Poor. Significant concerns that may be disqualifying.

## Prior Art Verdicts

| Verdict | Definition |
|---------|-----------|
| **NOVEL** | No prior work addresses this specific combination/approach |
| **MOSTLY NOVEL** | Core technique is known, but application to this domain is new |
| **INCREMENTAL** | Adaptation of known technique to new setting |
| **EXISTS** | Prior work already does essentially this |

## Filtering Calibration Guide

The user sets a target survival rate. Use these guidelines:

| Target | Typical Filter Behavior |
|--------|------------------------|
| 20-30% | Only Star + strongest Maybes. Soft reject threshold ≥ 3.5 |
| 40-50% | All Stars + Maybes with validation path. Soft reject threshold ≥ 3.0 |
| 60-70% | All Stars + most Maybes. Only hard reject criteria apply. |
| 80%+ | Minimal filtering. Only eliminate clear duplicates and hard rejects. |
