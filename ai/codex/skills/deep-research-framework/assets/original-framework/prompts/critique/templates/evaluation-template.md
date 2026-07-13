# Critique Evaluation Template

Use this template for the per-idea evaluation in Phase 3.

## Per-Idea Evaluation Card

```markdown
### [Idea ID]: [Title]

**User Verdict:** Star / Maybe / Kill
**User Notes:** "[verbatim user comment]"

#### Scores
| Criterion | Score (1-5) | Justification |
|-----------|-------------|---------------|
| Novelty | | [Does this exist? Cite closest prior work] |
| Impact | | [If published, what changes?] |
| Speed-to-test | | [Days/weeks to validate core hypothesis] |
| Implementation simplicity | | [Lines of code, moving parts] |
| Anti-fragility | | [What if it fails? Is partial success useful?] |
| **Weighted Total** | **X.XX** | |

#### Prior Art Check
- Closest work: [paper/method name]
- Key difference: [what makes ours novel]
- Verdict: NOVEL / MOSTLY NOVEL / INCREMENTAL / EXISTS

#### Validation Experiment
- Experiment: [cheapest test]
- Time: [days]
- Go signal: [specific metric threshold]
- No-go signal: [what failure looks like]

#### Strategic Notes
- Best benchmark: [which benchmark to demonstrate on]
- Best base model: [which foundation model]
- Combines with: [other ideas that synergize]
```

## Filtering Decision Template

```markdown
### Filtering Summary

| Idea | User | Phase 1 Insight | Filter | Final |
|------|------|----------------|--------|-------|
| [ID] | Star | [relevant insight or "—"] | ADVANCE | ✅ Proceed |
| [ID] | Maybe | [insight] | PROMOTE / SOFT REJECT | ✅/⚠️ |
| [ID] | Kill | — | ELIMINATE | ❌ |

**Ideas entering:** N
**After user filter:** N (Star: X, Maybe: Y, Kill: Z)
**After automated filter:** N (Promoted: X, Soft rejected: Y)
**Final shortlist:** N ideas
**Elimination rate:** XX%
```

## Pilot Testing Schedule Template

```markdown
### Pilot Testing Schedule

**Parallel Track A (fastest ideas):**
Day 1-2: [Idea X validation] → Go/No-Go by Day 3
Day 3-5: [Idea Y validation] → Go/No-Go by Day 6

**Parallel Track B (medium ideas):**
Week 1-2: [Idea Z validation] → Go/No-Go by Week 2

**Sequential (depends on Track A results):**
Week 2-3: [Combine winners from A] → Full experiment
Week 3-4: [Scale to full setup]
```
