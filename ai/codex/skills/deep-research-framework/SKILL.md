---
name: deep-research-framework
description: Structured deep research, literature-anchored brainstorming, and idea critique workflow adapted losslessly from a Claude Deep Research Framework repository. Use when the user asks to run or migrate Claude-Deep-Research-Framework, initiate deep research, initiate brainstorm, critique/filter ideas, preserve .claude slash-command workflows in Codex, create an isolated research project, or synthesize research outputs into reports.
---

# Deep Research Framework

Use this skill as the Codex adapter for the bundled Claude Deep Research Framework. The original framework is preserved under `assets/original-framework/`; do not rewrite or delete it when using the skill. Prefer adding Codex-facing files around it.

## Resource Map

- Original framework: `assets/original-framework/`
- Original Claude repo instructions: `assets/original-framework/CLAUDE.md`
- Original slash commands: `assets/original-framework/.claude/commands/`
- Original agent prompts: `assets/original-framework/.claude/agents/`
- Original prompt templates: `assets/original-framework/prompts/`
- Codex project scaffold script: `scripts/create-research-project.sh`
- Codex workflow references:
  - `references/research-mode.md`
  - `references/brainstorm-mode.md`
  - `references/critique-mode.md`
  - `references/original-framework-map.md`

Read only the reference file for the requested mode, plus any original command/agent/template files it names.

## Mode Routing

- If the user asks for `/initiate-research`, "deep research", "research session", or a systematic report, read `references/research-mode.md`.
- If the user asks for `/initiate-brainstorm`, ideation, concept generation, or literature-anchored brainstorming, read `references/brainstorm-mode.md`.
- If the user asks for `/critique-ideas`, idea filtering, Star/Maybe/Kill triage, ranking, red-team critique, or selecting a shortlist, read `references/critique-mode.md`.
- If the user asks what is in the framework, how it maps from Claude to Codex, or whether anything was preserved, read `references/original-framework-map.md`.
- If the user wants a new isolated research workspace, run `scripts/create-research-project.sh <project-name>` or inspect it first if customization is needed.

## Operating Rules

1. Preserve the original framework as source-of-truth assets. When behavior is unclear, inspect the corresponding original command or agent file before acting.
2. Work in the current project if it already has `context/`, `prompts/`, `outputs/`, `notes/`, and `scratchpad/`; otherwise offer or create an isolated project with the script.
3. Use Codex tools normally: use web/search tools for current research when available, cite sources, write files with normal Codex editing practices, and keep logs updated.
4. Keep the framework's directory conventions:
   - `context/from-human/` for user requirements
   - `context/from-internet/` for gathered sources and notes
   - `context/from-history/` for session summaries
   - `prompts/queue/` for research plans
   - `prompts/run/initial/` and `prompts/run/subsequent/` for prompts
   - `outputs/individual/` for focused findings
   - `outputs/aggregated/mk-combined/` for synthesized reports
   - `outputs/brainstorm/` for brainstorm artifacts
   - `notes/` for logs
5. Treat Claude slash commands as named workflows, not literal commands. In Codex, execute their instructions directly.
6. For time-sensitive facts, current literature, APIs, product claims, or recent events, browse/search and include source links.
7. For academic or technical literature work, prefer primary sources: papers, official docs, datasets, source repos, standards, and project pages.

## Lossless Migration Contract

This skill intentionally keeps two layers:

- A preserved layer: the original Claude framework under `assets/original-framework/`.
- An adapter layer: `SKILL.md`, `references/`, and `scripts/` for Codex.

When updating the skill, maintain both layers unless the user explicitly asks for a destructive cleanup. If you improve the Codex adapter, document the behavior in references rather than modifying original Claude files. If the user asks to sync a newer upstream framework, replace or add under `assets/original-framework/` and then update the adapter references.
