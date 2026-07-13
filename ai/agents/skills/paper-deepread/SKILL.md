---
name: paper-deepread
description: Deep-read research papers into durable Chinese Markdown dossiers for the local ResearchNotes vault. Use when the user says "【精读】", "精读论文", "深度解读这篇论文", "专题分析论文", asks to analyze a paper's technical details/training/data/reproduction, or wants the result saved as a structured paper reading note.
---

# Paper Deepread

## Output Standard

Treat “【精读】论文” as a request for a durable research dossier, not a chat summary. The default output is a multi-file Chinese Markdown package saved under:

```text
__HOME__/Desktop/ResearchNotes/papers/<paper-slug>/
```

Use `references/iws-quality-example.md` for the quality bar and document map. This reference is a local quality rubric plus a pointer to the first completed dossier; it is not a substitute for reading the current target paper and must not be treated as source evidence for other papers. If the paper is about world models, robotics, action following, video generation, physical consistency, or policy training/evaluation, relate the reading to the current VLA + WM closed-loop benchmark project when useful.

Default depth should be high. Do not write a short paper summary unless the user explicitly asks for a quick summary. A normal deep-read package should be detailed enough that the user can later reconstruct the paper's method, data assumptions, experimental claims, reproduction blockers, and relevance to the current project without reopening the PDF immediately.

When explaining papers, answer the user's technical question first before editing or polishing saved reports. Do not spend the first response on whether the dossier wording is precise; first explain the mechanism in plain language, with module boundaries and dataflow.

For model papers, architecture comes first. Before results or broad motivation, identify the actual model components, inputs and outputs, where actions/conditions enter, what is trained or frozen, the backbone blocks, latent/state representations, prediction heads, losses, and inference rollout. A model paper note that does not explain the architecture is incomplete.

For experiment and benchmark papers, prioritize operational decomposition before results: for every major method or experiment, spell out where the data comes from, what is fed into which model or environment, what intermediate artifact is produced, which modules are trained or frozen, and where evaluation happens. Results tables and leaderboards are secondary. After the procedural flow is clear, add substantial insight rather than generic takeaways: explain what design choice this changes for the VLA + WM benchmark, what confounder it exposes, what failure mode it suggests, what ablation/checkpoint/metric should be added, how to adapt it into fixed-VLA-probe evaluation, and how to distinguish the project from this paper in related work.

## Workflow

1. Resolve sources.
   - Use the paper PDF/arXiv/OpenReview/project page/GitHub/Hugging Face/dataset pages when available.
   - Prefer primary sources. Search the web when links, code, datasets, releases, dates, or claims may have changed.
   - Save or inspect PDF/text/source locally when useful; cite public URLs in final docs.

2. Read across four angles.
   - Method and training: problem formulation, architecture, objectives, losses, schedules, hyperparameters, inference.
   - Data and reproduction: datasets, collection, preprocessing, action/state representation, released artifacts, commands, hardware.
   - Experiments and evidence: metrics, baselines, ablations, statistical trust, missing controls, failure boundaries.
   - Architecture/product implications: core philosophy, relation to other routes, minimal reproducible unit, product wedge, kill tests.

3. Use subagents only when allowed by current instructions and the user explicitly asks for multi-agent/delegation/parallel work.
   - Assign disjoint files to workers.
   - Tell workers they are not alone in the codebase and must not edit others' files.
   - If subagents are unavailable or not authorized, complete the same roles sequentially.

4. Write the dossier.
   - Always write in Chinese unless the user asks otherwise.
   - Use YAML frontmatter for vault files when useful.
   - Use Obsidian `[[双向链接]]` for links to existing ResearchNotes notes when useful.
   - Avoid local absolute-path links inside saved Markdown; external references should be `https://` URLs.
   - Keep local absolute paths only in final chat responses, not in saved docs.
   - Write one paper per folder. Never mix multiple papers into a single Markdown file when the user asked for deep reading.
   - Use concrete headings, tables, formulas, numbered mechanisms, and explicit "known / inferred / missing" labels.
   - Prefer paper-grounded details over generic explanation. If an item is not in the paper or released repo, say it is missing instead of filling it in.

5. Integrate into the local ResearchNotes vault by default.
   - Put the dossier under `__HOME__/Desktop/ResearchNotes/papers/<paper-slug>/`.
   - If the paper directly affects the VLA + WM benchmark, append a concise Q&A/decision note to the most relevant `ideas/QA记录*.md` file.
   - For important additions, update `__HOME__/Desktop/ResearchNotes/logs/CHANGELOG.md`.
   - Rebuild the local Read-the-Docs-style site after each completed dossier so the new paper is mounted in `docs_site/`.
   - Use `__HOME__/Desktop/ResearchNotes/tools/build_local_docs.py --root __HOME__/Desktop/ResearchNotes --out __HOME__/Desktop/ResearchNotes/docs_site` from the repository root.
   - Verify the new `<paper-slug>` appears in `__HOME__/Desktop/ResearchNotes/docs_site/search_index.json` and that the generated HTML pages exist.
   - Do not start a long-running docs server unless the user explicitly asks to browse the site locally.

## Required Document Set

Create these files under the paper slug directory:

```text
00_index.md
01_model_training_mechanism.md
02_data_reproduction.md
03_experiments_evidence_limits.md
04_architecture_product_implications.md
05_master_report.md
06_reproduction_checklist.md
07_source_notes.md
```

If the paper domain needs different names, keep the same roles and preserve numeric order.

## Content Requirements

- `00_index.md`: paper links, research boundary, document map, reading order, current judgment.
- `01_model_training_mechanism.md`: method, equations, architecture, objectives, training schedule, inference, code/config mapping, pitfalls.
- `02_data_reproduction.md`: data sources, schemas, preprocessing, released artifacts, exact commands, storage/compute/hardware, missing information.
- `03_experiments_evidence_limits.md`: experiment questions, tables/figures, metrics, baselines, ablations, statistical confidence, failure modes.
- `04_architecture_product_implications.md`: philosophy of state/action/physics/evaluation, comparison to neighboring routes, minimal 20% reproduction, product wedge, kill tests, backlog.
- `05_master_report.md`: integrated narrative and final technical judgment; this is the first serious reading target.
- `06_reproduction_checklist.md`: stepwise executable checklist with smoke tests, diagnostics, acceptance gates, common traps.
- `07_source_notes.md`: source URLs, local verification notes, code files inspected, released datasets/checkpoints, information gaps.

## Detail Floor

Use this as the minimum normal depth unless the target paper is unusually short or sources are unavailable:

- `00_index.md`: 60+ lines. Include metadata, source links, one-paragraph thesis, research boundary, reading order, file map, and a concise verdict.
- `01_model_training_mechanism.md`: 220+ lines. Include problem formulation, notation table, architecture blocks, training objectives/losses, inference procedure, hyperparameters if available, implementation mapping, assumptions, and pitfalls.
- `02_data_reproduction.md`: 180+ lines. Include dataset inventory, schema/action/state representation, preprocessing, artifact availability, expected directory layout, commands if available, hardware/storage estimates, and missing reproducibility details.
- `03_experiments_evidence_limits.md`: 180+ lines. Include claim-by-claim evidence, metrics, baselines, ablations, tables/figures, fairness checks, statistical confidence, failure cases, and what evidence would change the verdict.
- `04_architecture_product_implications.md`: 160+ lines. Include design philosophy, comparison to neighboring methods, implications for VLA + WM benchmark design, minimal reproduction slice, product/research wedge, kill tests, and backlog.
- `05_master_report.md`: 180+ lines. Integrate the paper into a coherent technical judgment, not just a summary. Include "what the paper proves", "what it does not prove", and "what to do next".
- `06_reproduction_checklist.md`: 140+ lines. Include staged setup, smoke tests, diagnostics, acceptance gates, failure symptoms, and fallback plans.
- `07_source_notes.md`: 80+ lines. Include all consulted URLs, local files inspected, extraction notes, repo/dataset/checkpoint status, and unresolved gaps.

If the available evidence cannot support this depth, keep the same sections but explicitly mark missing evidence. Do not pad with invented details.

## Evidence Discipline

- Never invent "high-quality reference articles", benchmark results, code files, commands, or released assets.
- Separate direct paper claims from assistant interpretation.
- When using a previous dossier as a quality example, use only its structure and bar for detail; do not copy its facts into the new paper.
- Cite public URLs in `07_source_notes.md` and include enough source context for the user to audit the dossier later.

## Quality Gates

Before finishing:

- Check every required file exists.
- Run `wc -l` and `rg -n "^#"` on the package to verify shape.
- Check for accidental `/Users/`, `/tmp/`, `file://`, or `app://` links in saved Markdown files.
- Rebuild `docs_site/` and verify the new dossier is present in the docs search index/navigation.
- Final response must include the local package path and a short summary of what was created.
