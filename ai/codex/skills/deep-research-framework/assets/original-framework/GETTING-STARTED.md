# Getting Started with Claude Deep Research

## Understanding the Concept

This template supports two complementary workflows:

- **Research mode** (`/initiate-research`) — Systematic, iterative research with structured context, prompts, and synthesis
- **Brainstorm mode** (`/initiate-brainstorm`) — Structured creative ideation with literature-anchored evaluation
- **Critique mode** (`/critique-ideas`) — Interactive idea filtering and ranking with configurable evaluation frameworks

For background on the original research concept:
- **Planning Notes**: [Claude-Deep-Research-Model Repository](https://github.com/danielrosehill/Claude-Deep-Research-Model) — Original concept by Daniel Rosehill
- **Original Template**: [danielrosehill/Claude-Deep-Research-Template](https://github.com/danielrosehill/Claude-Deep-Research-Template)

---

## First Time Setup

### Prerequisites

- Claude Code CLI installed (`claude --version` to verify)
- Git configured
- Basic familiarity with markdown

### Initial Setup

1. **Clone this repository:**

   ```bash
   git clone https://github.com/Physis-AI/Claude-Deep-Research-Framework.git my-research
   cd my-research
   ```

   Or use GitHub's "Use this template" feature to create your own copy, then:

   ```bash
   git clone <your-copy-url> my-research
   cd my-research
   ```

2. **Open in Claude Code:**

   ```bash
   claude .
   ```

3. **Choose a starting command:**

   For research:
   ```
   /initiate-research
   ```

   For brainstorming:
   ```
   /initiate-brainstorm
   ```

   For idea critique (after brainstorming):
   ```
   /critique-ideas
   ```

---

## Your First Research Session

### Step 0: Choose Input Mode

Both commands begin by asking how you want to provide context:

**Option A — Free-form description**: Paste a natural language description of your research needs. Claude will extract the key details, present a structured summary for your confirmation, and then proceed. You can correct anything before moving on.

**Option B — Guided interview**: Claude asks questions one by one. Useful if you want to think through each dimension carefully.

If you've already included a description with the command (e.g., `/initiate-research I want to research X focusing on Y`), Claude automatically uses Option A.

### Step 1: Answer Claude's Questions

Whether you use free-form or guided mode, Claude needs:

- Your research topic
- Your objectives
- How deep you want to go
- What output formats you need
- Any specific constraints or source preferences

**Example free-form input:**

```
I'm researching the current state of AI coding assistants for a technical report.
I want to understand the main tools available, their strengths and weaknesses, and
best practices for integrating them into engineering workflows. The report is for
a technical audience. No specific timeline. Prefer recent sources (2023+).
```

### Step 2: Review the Research Plan

Claude will generate:
- A project context file in `context/from-human/project-context.md`
- A research plan in `prompts/queue/research-plan.md`
- Initial research prompts in `prompts/run/initial/`
- A research log template in `notes/research-log.md`

Review these and provide feedback. You can modify, add, or remove prompts before execution begins.

### Step 3: Begin Research

When you're ready, tell Claude to proceed. Claude will:
1. Execute the first research prompt
2. Document findings in `outputs/individual/`
3. Generate follow-up questions
4. Continue systematically through the research plan

### Step 4: Monitor Progress

During research, Claude will:
- Update the research log in `notes/research-log.md`
- Highlight interesting findings
- Ask for your input at decision points
- Suggest when to synthesize

---

## Your First Brainstorm Session

### Step 0: Choose Input Mode

Same as research — free-form description or guided interview.

**Example free-form brainstorm input:**

```
I want to brainstorm new approaches for reducing latency in real-time video
streaming for robotic teleoperation. Hard constraints: must work under 100ms
round-trip, standard 5G network. We've already tried bandwidth compression and
edge caching. I need 3-5 concept proposals with moderate literature support.
Cross-domain thinking is welcome.
```

### Step 1: Problem Framing

Claude will extract or ask for:
- Core challenge
- Hard vs. soft constraints
- Degrees of freedom (what's open for exploration)
- Success criteria
- Domain boundaries
- Known solutions to avoid duplicating
- How many concepts and how much literature depth

This is saved to `context/from-human/brainstorm-context.md`.

### Step 2: Divergent Ideation

Claude selects 3-5 ideation techniques and runs them sequentially. You'll see each round's output saved to `outputs/brainstorm/ideation-rounds/`. Claude reports idea count and new directions after each round, then asks: continue or move to clustering?

Available techniques:
- **SCAMPER** — Transform existing solutions
- **Analogy Transfer** — Import solutions from other domains
- **Constraint Removal** — Explore what's possible without assumed limitations
- **Reverse Thinking** — Work backwards from failure
- **Random Stimulus** — Force unexpected connections

### Step 3: Clustering

Once divergence is complete, Claude clusters all ideas semantically, merges duplicates, and generates an idea board in `outputs/brainstorm/idea-board/`. You confirm or adjust the clusters before moving on.

### Step 4: Literature Anchoring

For each cluster, Claude runs:
- Prior art check (novelty rating ★ to ★★★★)
- Feasibility evidence search
- Risk and failure case discovery

Anchor cards are saved to `outputs/brainstorm/anchor-cards/`. Literature findings also go to `outputs/individual/` for reuse in future research sessions.

### Step 5: Evaluation

Claude builds a scoring matrix across: novelty, feasibility, impact, alignment, urgency. Top-ranked clusters get a Devil's Advocate analysis. Results saved to `outputs/brainstorm/evaluation/`.

### Step 6: Concept Development

You select the top N clusters. Claude generates detailed concept briefs for each — implementation path, literature support, risk inventory — saved to `outputs/brainstorm/concept-briefs/`.

### Step 7: Synthesis Report

Claude aggregates everything into a final synthesis report saved to `outputs/aggregated/mk-combined/[date]-[topic]-brainstorm-synthesis.md`.

---

## Understanding the Directory Structure

### Where Things Go

**Context** (`context/`):
- `from-human/` — Your requirements, domain knowledge, brainstorm context
- `from-internet/` — Research materials Claude gathers during research and anchoring
- `from-history/` — Archived conversation histories

**Prompts** (`prompts/`):
- `drafting/` — Claude's prompt experiments
- `queue/` — Ready-to-run research plans
- `run/initial/` — Broad exploratory prompts
- `run/subsequent/` — Focused follow-up prompts
- `brainstorm/techniques/` — Ideation technique templates
- `brainstorm/evaluation/` — Evaluation prompt templates
- `brainstorm/concept/` — Concept brief and synthesis templates

**Outputs** (`outputs/`):
- `individual/` — Single research topics (also reused for literature findings from brainstorm)
- `aggregated/mk-combined/` — Final combined reports (research and brainstorm synthesis)
- `aggregated/pdf/` — PDF versions
- `reformatted/` — TTS and SSML formats
- `brainstorm/ideation-rounds/` — Per-round raw ideas
- `brainstorm/idea-board/` — Clustered idea board
- `brainstorm/anchor-cards/` — Literature anchor cards per cluster
- `brainstorm/evaluation/` — Scoring matrix and devil's advocate outputs
- `brainstorm/concept-briefs/` — Detailed concept documents
- `brainstorm/critique/` — Critique reports and user annotations

**Notes** (`notes/`):
- `research-log.md` — Updated after each research session
- `brainstorm-log.md` — Updated after each brainstorm phase transition

**Scratchpad** (`scratchpad/`):
- Working area, experiments, temporary notes

---

## Common Workflows

### Quick Investigation

```
/initiate-research
[Free-form description of topic]
[Research for 30-60 minutes]
[Request synthesis]
[Done]
```

### Deep Research Project

```
/initiate-research
[Provide comprehensive context]
[Review and refine research plan]

Session 1: Exploratory research
→ Review findings, adjust direction

Session 2-3: Deep dives on key areas
→ Periodic synthesis

Session 4: Gap filling
→ Final synthesis and report
```

### Iterative Research

```
Session 1:
  /initiate-research → conduct initial research → archive conversation

Session 2:
  Review context/from-history/ → define new questions → continue

[Repeat as needed]
```

### Full Brainstorm Cycle

```
/initiate-brainstorm
[Describe challenge or use guided interview]
[2-3 divergent ideation rounds — aim for 30+ raw ideas]
[Review and confirm idea clusters]
[Literature anchoring per cluster]
[Scoring + Devil's Advocate analysis]
[Select top 3-5 ideas for concept development]
[Generate synthesis report]
```

### Research → Brainstorm Hybrid

```
/initiate-research [topic]
→ Identify problem areas or knowledge gaps

/initiate-brainstorm [specific sub-problem]
→ Brainstorm draws on outputs/individual/ from prior research session
→ Faster anchoring because literature is already available
```

### Research → Brainstorm → Critique Pipeline

```
/initiate-research [topic]
→ Build knowledge base

/initiate-brainstorm [specific sub-problem]
→ Generate and cluster ideas using research findings

/critique-ideas
→ Configure annotation depth and evaluation framework
→ Triage ideas (Star/Maybe/Kill)
→ Filter to target survival rate
→ Rank using Six Hats, Pre-Mortem, Criteria Scoring, or Red Team/Steel Man
→ Get validation experiment schedule
```

---

## Tips for Success

### Providing Good Context

✅ **Do:**
- Be specific about goals and constraints
- Share domain knowledge upfront
- Mention what you already know or have tried
- Specify output format requirements

❌ **Don't:**
- Give vague objectives like "learn about AI"
- Assume Claude knows your specific context
- Skip the initialization step

### Working with Claude

✅ **Do:**
- Review and refine the generated plan before execution
- Provide feedback during research
- Let divergent ideation run fully before clustering
- Use Devil's Advocate results to stress-test ideas

❌ **Don't:**
- Filter ideas during brainstorm divergence
- Rush to synthesis before all phases complete
- Ignore the brainstorm log updates

### Organizing Research

✅ **Do:**
- Use descriptive filenames with dates: `2026-03-06-topic.md`
- Maintain the directory structure
- Archive conversation histories in `context/from-history/`

❌ **Don't:**
- Create ad-hoc directories outside the structure
- Mix research and brainstorm outputs in unrelated folders
- Delete intermediate outputs

---

## Troubleshooting

### "Claude isn't following the workflow"

Make sure `CLAUDE.md` is present and Claude has read it:
```
Please read CLAUDE.md and follow the deep research workflow
```

### "Brainstorm is getting too narrow too fast"

Remind Claude of the divergence rule:
```
We need at least 30 raw ideas and 3 complete rounds before clustering
```

### "I want to skip the literature anchoring"

You can tell Claude to skip or abbreviate:
```
Skip prior art checks, go straight to scoring based on what we have
```

### "I want to customize the workflow"

Edit `CLAUDE.md` to modify how Claude operates:
- Change required minimums for ideation rounds
- Adjust evaluation dimensions and weights
- Add project-specific behavioral rules

### "Research is too broad/narrow"

At any point:
```
Let's refocus on [specific aspect]
```
or:
```
Let's broaden this to also cover [related area]
```

---

## Example Research Projects

**Technical Investigation:**
```
Topic: "Evaluating vector databases for RAG applications"
Depth: Comprehensive
Focus: Performance, cost, ease of use, scalability
Output: Technical comparison report + decision matrix
```

**Market Research:**
```
Topic: "AI-assisted coding tools market landscape"
Depth: Moderate
Focus: Key players, pricing, features, trends
Output: Market overview report
```

**Academic Research:**
```
Topic: "Literature review on transformer architectures"
Depth: Exhaustive
Focus: Evolution, variants, applications, future directions
Output: Academic-style literature review + bibliography
```

## Example Brainstorm Projects

**R&D Ideation:**
```
Challenge: "New mechanisms for real-time video compression in robotic teleoperation"
Constraints: 100ms latency, 5G network
Techniques: Analogy Transfer, Constraint Removal, SCAMPER
Output: 3 concept briefs with literature support + synthesis report
```

**Product Innovation:**
```
Challenge: "Novel interaction paradigms for AR-based remote collaboration"
Constraints: No specialized hardware required
Techniques: All five techniques
Literature depth: Moderate
Output: 5 concept briefs + evaluation matrix
```

---

Ready to start? Run `/initiate-research` or `/initiate-brainstorm` and let Claude guide you through the process.
