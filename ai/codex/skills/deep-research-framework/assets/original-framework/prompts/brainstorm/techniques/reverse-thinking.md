# Ideation Technique: Reverse Thinking

## Objective
Generate ideas by first exploring how to make the problem worse, then systematically inverting those approaches into potential solutions.

## Seed Problem
[Populate from `context/from-human/brainstorm-context.md`]

## Process

### Step 1: Problem Inversion
Reframe the problem as its opposite:
- "How could we make [problem] as bad as possible?"
- "What would guarantee failure?"
- "How could we ensure the worst possible outcome?"

### Step 2: Generate Worsening Approaches
List at least 8 ways to worsen the situation:
1. [Method to make it worse]
2. [Another method]
3. ...

For each, briefly explain the mechanism of harm.

### Step 3: Inversion
For each worsening approach, invert it:
- If "removing feedback loops" worsens it → "adding rich feedback mechanisms" might improve it
- If "ignoring edge cases" worsens it → "proactively identifying edge cases" might help
- Generate a concrete positive idea from each inversion

### Step 4: Second-Order Inversion
Look at the inverted ideas and ask:
- "What if we partially applied the worsening approach on purpose?"
- Sometimes controlled application of a "bad" approach reveals unexpected benefits
- Example: "Adding deliberate noise" can improve robustness

## Expected Output
- A table with columns: #, Worsening Approach, Inverted Solution, Second-Order Insight, Direction Tag
- Minimum 8 ideas from direct inversion plus 2-3 second-order insights
- Round statistics: idea count, new directions, duplication rate
