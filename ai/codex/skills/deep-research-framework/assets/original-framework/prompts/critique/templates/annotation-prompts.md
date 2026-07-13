# Annotation Collection Prompts

Use these prompts to structure the interactive annotation collection in Phase 0.

## Prompt: Idea Group Annotation

When presenting a group of 3-5 ideas for annotation, use this format:

```
Here are ideas from [Cluster Name]:

1. **[Idea Title]** — [one-line summary]
2. **[Idea Title]** — [one-line summary]
3. **[Idea Title]** — [one-line summary]

For each, give your quick reaction:
⭐ Star = "I want to explore this"
🤔 Maybe = "Interesting but concerns"
❌ Kill = "Not worth pursuing"

Plus any specific notes on individual ideas.
```

## Prompt: Strategic Preferences

```
Before I evaluate the ideas, I need to understand your priorities:

1. What kind of work excites you most?
   a) Clever algorithmic insight (elegant, minimal code)
   b) Strong empirical results (thorough experiments)
   c) Novel formulation (new way to frame the problem)
   d) Practical impact (immediately useful)

2. What do you want to avoid?
   a) Cumbersome engineering / reward engineering
   b) Training instability risks
   c) Heavy compute requirements
   d) Incremental improvements
   e) Hard-to-reproduce setups

3. Timeline?
   a) 2-4 weeks (quick validation)
   b) 1-2 months (single paper)
   c) 3+ months (ambitious project)
```

## Prompt: Existing Notes Detection

When the user has already left notes/comments in idea documents (e.g., lines starting with "Note:", "Comment:", or "- Note:"), extract them and present:

```
I found your existing notes on these ideas:

- **[Idea X]:** "[extracted note]"
- **[Idea Y]:** "[extracted note]"

Are these still current? Any updates or additional thoughts?
```

## Prompt: Section-Level Comments

For cluster/theme-level feedback:

```
Looking at the broader themes:

- **Cluster A ([theme]):** [N ideas, top score X.XX]
- **Cluster B ([theme]):** [N ideas, top score X.XX]
- ...

Any clusters you want to prioritize or deprioritize as a whole?
Any strategic comments about the direction?
```
