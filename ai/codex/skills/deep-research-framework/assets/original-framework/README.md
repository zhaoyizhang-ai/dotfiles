# Claude Deep Research Framework

[![Claude Code](https://img.shields.io/badge/Claude-Code-8A2BE2?logo=anthropic&logoColor=white)](https://claude.ai/claude-code)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Forked from](https://img.shields.io/badge/Forked_from-danielrosehill%2FClaude--Deep--Research--Template-blue?logo=github)](https://github.com/danielrosehill/Claude-Deep-Research-Template)

A production-ready template for conducting systematic, comprehensive research **and structured brainstorming** using Claude Code. This implementation leverages an organized flow of data from previous outputs into persistent context, enabling iterative and cumulative research workflows.

## What is This?

This template provides a complete, structured workflow for using Claude Code as a deep research assistant and a creative brainstorm facilitator. Instead of ad-hoc conversations, this approach:

- **Systematizes research** with clear phases and workflows
- **Documents everything** in organized directories
- **Generates reusable outputs** in multiple formats
- **Builds on previous work** through structured context
- **Scales from quick investigations to comprehensive studies**
- **Supports structured brainstorming** with a literature-anchored diverge-anchor-converge workflow

## Background and Concept

This repository is a fork and enhancement of [danielrosehill/Claude-Deep-Research-Template](https://github.com/danielrosehill/Claude-Deep-Research-Template), with the following major additions:

- **Brainstorm mode** (`/initiate-brainstorm`) — a seven-phase hybrid workflow integrating divergent ideation with literature-anchored evaluation
- **Free-form context input** — both `/initiate-research` and `/initiate-brainstorm` support natural language descriptions in addition to guided interviews
- **Expanded agent suite** — new specialized agents for brainstorm coordination, idea generation, idea evaluation, and context parsing
- **Extended output structure** — brainstorm outputs tracked in dedicated subdirectories under `outputs/brainstorm/`

**Original concept and model notes**: [Claude-Deep-Research-Model Repository](https://github.com/danielrosehill/Claude-Deep-Research-Model)

## Quick Start

### 1. Clone This Repository

```bash
git clone https://github.com/Physis-AI/Claude-Deep-Research-Framework.git my-research-project
cd my-research-project
```

Or use GitHub's "Use this template" feature to create your own copy.

### 2. Open in Claude Code

```bash
claude .
```

### 3. Start a Research Session

```
/initiate-research
```

Claude will offer two input modes: a guided interview or free-form description. It will then set up your project structure, generate a research plan, and guide you through the workflow.

### 4. Or Start a Brainstorm Session

```
/initiate-brainstorm
```

Claude will walk you through problem framing, run multiple divergent ideation rounds, anchor findings in literature, and produce ranked concept briefs.

## Directory Structure

```
├── .claude/
│   ├── commands/                  # Slash commands
│   │   ├── initiate-research.md   # /initiate-research entry point
│   │   └── initiate-brainstorm.md # /initiate-brainstorm entry point
│   │   └── critique-ideas.md     # /critique-ideas entry point
│   └── agents/                    # Specialized agents
│       ├── research-coordinator.md
│       ├── research-synthesizer.md
│       ├── prompt-generator.md
│       ├── context-parser.md      # Shared: free-form input parsing
│       ├── brainstorm-coordinator.md
│       ├── idea-generator.md
│       ├── citation-manager.md
│       ├── session-reviewer.md
│       └── idea-evaluator.md
├── context/                       # Research context and source materials
│   ├── from-human/                # Your context and requirements
│   ├── from-internet/             # Web research, papers, articles
│   └── from-history/              # Previous conversation histories
├── prompts/                       # Research and brainstorm prompts by stage
│   ├── drafting/                  # Draft prompts
│   ├── queue/                     # Prompts ready to execute
│   ├── run/                       # Executed prompts
│   │   ├── initial/               # Starting prompts
│   │   └── subsequent/            # Follow-up prompts
│   ├── critique/                  # Critique & filtering resources
│   │   ├── templates/             # Evaluation and annotation templates
│   │   └── evaluation/            # Scoring criteria and rubrics
│   └── brainstorm/                # Brainstorm-specific prompts
│       ├── techniques/            # Ideation technique templates
│       │   ├── scamper.md
│       │   ├── analogy-transfer.md
│       │   ├── constraint-removal.md
│       │   ├── reverse-thinking.md
│       │   └── random-stimulus.md
│       ├── evaluation/            # Evaluation prompts
│       │   ├── impact-assessment.md
│       │   ├── prior-art-check.md
│       │   ├── devils-advocate.md
│       │   └── feasibility-check.md
│       └── concept/               # Output templates
│           ├── brainstorm-synthesis.md
│           └── concept-brief-template.md
├── outputs/                       # All research and brainstorm outputs
│   ├── individual/                # Single-topic research outputs
│   ├── aggregated/                # Synthesized reports
│   │   ├── mk-combined/           # Combined markdown
│   │   ├── pdf/                   # PDF reports
│   │   └── diagram-enrichments/
│   ├── reformatted/               # Alternative formats (TTS, SSML)
│   │   ├── tts-safe-txt/
│   │   └── ssml/
│   └── brainstorm/                # Brainstorm session outputs
│       ├── ideation-rounds/       # Per-round idea outputs
│       ├── idea-board/            # Clustered idea board
│       ├── anchor-cards/          # Literature anchor cards per cluster
│       ├── evaluation/            # Scoring matrix and devil's advocate
│       ├── concept-briefs/        # Detailed concept documents
│       └── critique/              # Critique & filtering results
├── pipeline/                      # Workflow automation
│   └── audio-dropoff/
│       ├── in-queue/
│       └── processed/
├── notes/                         # Research logs and documentation
│   ├── research-log.md            # Updated per research session
│   └── brainstorm-log.md          # Updated per brainstorm session
└── scratchpad/                    # Working area for experiments
```

## How It Works

### Research Workflow

1. **Context Gathering** — Provide background, objectives, and constraints (guided interview or free-form)
2. **Prompt Planning** — Claude generates a structured research plan and initial prompts
3. **Research Execution** — Execute prompts, document findings, generate follow-ups
4. **Output Synthesis** — Aggregate findings into comprehensive reports
5. **Iteration** — Build on previous research in subsequent sessions

### Brainstorm Workflow

The brainstorm mode follows a seven-phase **diverge-anchor-converge** cycle:

1. **Problem Framing** — Define the challenge, constraints, and evaluation criteria
2. **Divergent Ideation** — Run multiple rounds using structured techniques (≥30 raw ideas required before clustering)
3. **Clustering & Organization** — Semantically cluster ideas, merge duplicates, tag themes
4. **Literature-Anchored Evaluation** — For each cluster: prior art check, feasibility evidence, risk scan
5. **Multi-Criteria Evaluation** — Score clusters across novelty, feasibility, impact, alignment, urgency; run Devil's Advocate analysis
6. **Concept Development** — Generate detailed concept briefs for selected clusters
7. **Synthesis Report** — Aggregate all outputs into a final coherent document

### Critique Workflow

The critique mode (`/critique-ideas`) follows brainstorming to filter and rank ideas:

1. **Session Configuration** — Choose annotation depth, filtering aggressiveness, and evaluation framework
2. **Interactive Annotation** — Star/Maybe/Kill triage with optional comments (configurable depth)
3. **Context Scan** — Automated scan of research outputs for game-changing insights
4. **Adaptive Filtering** — User verdicts applied first, then calibrated filtering to target survival rate
5. **Re-Ranking** — Evaluate using selected framework (Six Thinking Hats, Pre-Mortem, Criteria-Weighted, or Red Team/Steel Man)
6. **Validation Analysis** — Key uncertainties, cheapest experiments, Go/No-Go signals
7. **Strategic Framing** — Benchmark selection, competitive positioning, paper skeleton

### Specialized Agents

| Agent | Role | Used By |
|---|---|---|
| `research-coordinator` | Orchestrates the overall research workflow | Research mode |
| `prompt-generator` | Creates effective research questions | Research + Brainstorm |
| `research-synthesizer` | Aggregates findings into reports | Research + Brainstorm |
| `context-parser` | Parses free-form descriptions into structured answers | Research + Brainstorm |
| `brainstorm-coordinator` | Manages the diverge-anchor-converge cycle | Brainstorm mode |
| `idea-generator` | Runs structured ideation techniques during divergence | Brainstorm mode |
| `idea-evaluator` | Conducts literature anchoring and multi-criteria scoring | Brainstorm mode |
| `citation-manager` | Tracks, deduplicates, and formats citations across outputs | Research mode |
| `session-reviewer` | Reviews session outputs against objectives and flags gaps | Research mode |

## Slash Commands

| Command | Description |
|---|---|
| `/initiate-research` | Start a new deep research project |
| `/initiate-brainstorm` | Start a brainstorm session with literature-anchored evaluation |
| `/critique-ideas` | Critique, filter, and rank ideas using configurable evaluation frameworks |

Add your own custom commands in `.claude/commands/`.

## Key Features

### Dual-Mode Operation
- **Research mode**: Systematic literature and web research with structured outputs
- **Brainstorm mode**: Creative ideation combined with evidence-based evaluation

### Flexible Context Input
Both commands support two input modes:
- **Guided interview**: Step-by-step structured questions
- **Free-form description**: Paste a natural language description; Claude extracts and confirms structured answers before proceeding

### Systematic Research
- Structured phases from exploration to synthesis
- Clear progression through research depth
- Built-in quality checkpoints

### Comprehensive Documentation
- All findings automatically documented
- Research log and brainstorm log track progress
- Conversation histories archived

### Multiple Output Formats
- Markdown reports
- PDF documents
- TTS-safe text
- SSML for voice synthesis

### Literature-Anchored Brainstorming
- Every surviving idea cluster gets prior art, feasibility, and risk checks
- Scoring is based on evidence, not intuition
- Devil's Advocate analysis required for top-ranked ideas

### Evidence-Based Idea Filtering
- Configurable annotation depth — from quick triage to full annotation
- User-set filtering aggressiveness (target survival rate)
- Four critical thinking frameworks: Six Thinking Hats, Pre-Mortem, Criteria-Weighted Scoring, Red Team/Steel Man
- Validation experiment planning with Go/No-Go signals

### Reusable Context
- Build on previous research sessions
- Literature findings from brainstorm anchoring stored in `outputs/individual/` for reuse across sessions
- Continuous knowledge accumulation

## Ideation Techniques

The brainstorm module ships with five structured ideation techniques:

| Technique | Best For |
|---|---|
| SCAMPER | Improving or transforming existing solutions |
| Analogy Transfer | Cross-domain innovation |
| Constraint Removal | Breaking out of assumed limitations |
| Reverse Thinking | Finding non-obvious approaches |
| Random Stimulus | Sparking unexpected connections |

## Use Cases

This template works for:

- **Academic Research** — Literature reviews, topic exploration
- **Market Research** — Industry analysis, competitive intelligence
- **Technical Investigation** — Technology evaluation, architecture research
- **Strategic Planning** — Trend analysis, scenario planning
- **Content Creation** — Research for articles, presentations, reports
- **Learning** — Deep dives into new subjects
- **R&D Ideation** — Structured brainstorming with evidence-based evaluation
- **Innovation Workshops** — Systematic idea generation and validation

## Configuration

### CLAUDE.md

The `CLAUDE.md` file contains instructions for Claude on how to operate in this repository, including behavioral guidelines for both research and brainstorm modes. Customize it for your specific needs.

### Custom Slash Commands

Create new slash commands in `.claude/commands/`:

```bash
.claude/commands/my-command.md
```

### Custom Agents

Define specialized agents in `.claude/agents/`:

```bash
.claude/agents/my-agent.md
```

## Best Practices

### For Research Sessions
1. **Start with `/initiate-research`** — Let Claude set up your project properly
2. **Provide rich context** — The more context, the better the research
3. **Review and refine** — Check Claude's research plan before execution
4. **Synthesize regularly** — Don't wait until the end to aggregate
5. **Archive conversations** — Save conversation histories for future reference

### For Brainstorm Sessions
1. **Define constraints explicitly** — Clear constraints make divergence more productive
2. **Don't filter during divergence** — All ideas are welcome in early rounds
3. **Trust the literature anchoring** — Evidence-based evaluation prevents bias
4. **Run Devil's Advocate** — It catches fatal flaws before concept development
5. **Document technique effectiveness** — Helps select better techniques in future sessions

## Example Workflows

### Quick Research

```
/initiate-research
[Answer questions or paste a description]
[Research for 30-60 minutes]
[Request synthesis]
```

### Deep Research Project

```
/initiate-research
[Provide comprehensive context]
[Review and refine research plan]
[Session 1: Exploratory research]
[Session 2-3: Deep dives on key areas]
[Periodic synthesis of findings]
[Final synthesis and report generation]
```

### Brainstorm Session

```
/initiate-brainstorm
[Describe the problem or use guided interview]
[2-3 rounds of divergent ideation]
[Cluster and confirm idea groups]
[Literature anchoring per cluster]
[Scoring and Devil's Advocate analysis]
[Select top ideas for concept development]
[Generate synthesis report]
```

### Idea Critique Session

```
/critique-ideas
[Configure: annotation depth, filter %, evaluation framework]
[Quick-triage or annotate ideas]
[Review extracted research insights]
[Approve or override filtering decisions]
[Review rankings and adjust]
[Get validation experiment schedule]
```

## Contributing

Suggestions and improvements welcome. This template is designed to evolve based on real-world usage.

## Related Projects

- [Claude Deep Research Model](https://github.com/danielrosehill/Claude-Deep-Research-Model) — Original concept and model notes by Daniel Rosehill
- [Original Template Repository](https://github.com/danielrosehill/Claude-Deep-Research-Template) — Base template this project extends

## License

MIT License — See LICENSE file for details

## Author

This project is a fork and extension of the original [Claude Deep Research Template](https://github.com/danielrosehill/Claude-Deep-Research-Template) by [Daniel Rosehill](https://github.com/danielrosehill). The brainstorm module, context-parser agent, free-form input mode, and extended output structure are original additions.

---

## Acknowledgments

Based on the Claude Deep Research Model concept by Daniel Rosehill. Extended with brainstorm capabilities and additional agents. Special thanks to the Claude Code team at Anthropic for the underlying tooling.
