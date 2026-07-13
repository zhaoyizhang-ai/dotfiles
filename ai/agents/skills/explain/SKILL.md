---
name: explain
description: Explain a paper or research idea from zero in one durable Chinese Markdown note. Use when the user asks to explain, read, or 讲论文/idea; provides a paper, brief, advisor note, or heuristic document; needs the exact problem, causal assumptions, method, evidence, conclusions, and practical meaning explained in beginner language; or explicitly asks to incorporate later questions into the same note without modifying the source.
---

# Explain

## Purpose

Make the user able to reconstruct the idea, not merely recognize its terminology. Create one durable explanation note and improve it when the user explicitly requests an update. Treat later questions as evidence about weak causal links, but do not silently write chat discussion back into the note.

Default to a whiteboard teaching posture:

```text
first give the whole mechanism
-> explain why the problem exists
-> walk through the method or experiments in dependency order
-> show exactly how the reasoning or evidence supports the conclusion
-> end with what the result enables and what remains setting-dependent
```

Do not write in paper language, produce a section-by-section abstract, or substitute structural neatness for explanation.

## Output Contract

- Write the note in Chinese unless requested otherwise.
- Treat the user as new to the topic unless they demonstrate otherwise.
- For an initial explanation request, persist substantive content in one Markdown note; do not reproduce it in chat.
- For later questions, answer in chat unless the user explicitly asks to update the note.
- In the Markdown note, use Obsidian math delimiters: `$...$` inline and `$$...$$` display. Never use `\(...\)` or `\[...\]`.
- In chat, prefer plain notation such as `R_D*`, `D_eff`, and `D_train` without dollar delimiters because the chat renderer may not display them.
- Preserve every user-authored sentence, annotation, and correction unless the user explicitly asks to rewrite it.
- Modify the smallest coherent set of sections. Never replace a substantial existing note merely to impose a new outline.
- Treat every paper, brief, or idea file as immutable by default. Never append to it, insert anchors, or add a forward link unless explicitly authorized.
- On success, reply only with `完成：<clickable file link>` unless the user explicitly asks for a chat explanation.

## Non-Negotiable Teaching Standard

### 1. Derive the teaching spine before choosing a structure

Before outlining, derive from the current source the smallest explanation that lets the user understand what the work actually does and what it is trying to learn. Include a concept, variable, condition, or branch in the first pass only when omitting it would make the central mechanism materially wrong.

Do not begin by inventorying every contribution, experimental axis, control, caveat, or possible result. Do not replace one rigid outline with another. Derive the natural explanatory form from the source itself, whether it is an experiment, derivation, proof, construction, algorithm, comparison, or unresolved idea.

If the work is organized around a central result structure, expose that structure early. It may be a table, curve, mapping, construction, guarantee, or another source-specific output. In the second pass, explain how one atomic result inside that structure is produced, then how repeated atomic results form the complete output. Do not force this pattern when the source has no such structure.

### 2. Open with the simplest complete causal chain

The opening must give the simplest complete mental model of what central move addresses what exact problem. Prefer an immediately reconstructable mechanism over an abstract inventory of the full research program. Then show the shortest complete chain from the starting point to the final conclusion.

Before writing, complete internally:

```text
Researchers want to understand or achieve <target>, but the current <measurement, assumption, method, or theory> fails because <specific obstruction>. Their central move is <method>. Through <experiment, derivation, proof, construction, or comparison>, they reach <result>, which enables <decision or scientific claim>.
```

If this cannot be completed precisely, reread the source instead of filling the opening with generic background.

For an experimental paper, specialize the chain into controlled inputs, observable outputs, and inferred conclusions. For a theoretical or algorithmic paper, use premises, construction or derivation steps, and the resulting guarantee or capability. Do not impose experimental vocabulary on every source.

When the idea combines two or more equations through a hidden bridge quantity, expose that structure at the beginning. For example:

```text
controlled repetition / processed data
-> assumption 1
-> latent effective data
-> assumption 2
-> observable held-out loss
```

State explicitly that the latent bridge is not measured directly and explain which observable lets the researchers infer it.

### 3. Explain twice: overview, then reconstruction

Use two passes by default.

**First pass — complete overview:** walk once through the entire idea in plain language. Include the problem, central move, how the work reaches its conclusion, and the final output. Depending on the source, that path may be an experiment, a derivation, a proof, an architecture, a comparison, or parameter fitting. This pass must be complete enough that the user knows what every later section is trying to establish.

**Second pass — from-zero reconstruction:** restart from the raw inputs and walk through the method or experiments in their actual dependency order. Define every concept immediately before its first use. For an experiment, say what is fixed, what is changed, how one atomic measurement or result is produced, what is observed, and how those results combine into the main output.

Afterwards, add a short compressed chain only if it helps consolidate the explanation. Do not confuse this repetition with redundant summarization: the first pass supplies orientation; the second supplies mechanics.

### 4. Separate the three layers of the problem

Diagnose:

1. **Surface phenomenon:** what visibly happens.
2. **Scientific obstruction:** which quantity becomes ambiguous or which assumption fails.
3. **Research target:** the relationship, result, hypothesis, explanation, or decision the work actually wants.

Center the explanation on layers 2 and 3. Use layer 1 only to make the obstruction concrete.

Bad opening:

```text
Small stride creates overlapping clips.
```

Better opening:

```text
Overlapping clips cannot be counted cleanly as either new or repeated data, so the usual data budget no longer tells us how much effective information the model received. The experiment varies stride and repetition, observes held-out loss, and fits the repetition-decay scale for each stride.
```

### 5. Introduce concepts just in time

For each indispensable concept, explain:

```text
plain meaning -> role in this idea -> nearest likely confusion
```

Never use a symbol before explaining what physical, mathematical, or experimental thing it represents. Distinguish quantities that look similar but play different roles. When relevant, examples include raw data, derived samples, processed samples, effective data, repetition count, and a fitted repetition scale.

Do not front-load a glossary. Introduce the minimum concept required to answer the current question, then immediately use it.

### 6. When fitted quantities exist, treat them as a measurement chain

Apply this section only when the source actually estimates parameters from observations. Do not force papers based on proofs, constructions, algorithms, or qualitative arguments into a fitting template.

When fitting does exist, never say that a curve “produces” a parameter without showing how. For every fitted quantity, label:

- what the experimenter fixes;
- what the experimenter changes;
- what is computed directly from the configuration;
- what is observed after training;
- what is latent and cannot be observed directly;
- what parameter is inferred by fitting.

Then show this chain:

```text
known inputs
-> assumed relationship containing an unknown parameter
-> predicted observable
-> compare with measured observable across many runs
-> adjust the parameter to minimize mismatch
-> fitted result
```

Explain how small and large candidate parameter values change the predicted curve. If several assumptions are composed, name each assumption and identify the bridge variable between them.

Do not imply that fitting validates a universal law. Separate:

1. whether the phenomenon exists;
2. whether the proposed function predicts held-out points;
3. the fitted parameter values under one setting.

### 7. Follow experimental dependency, not a decorative outline

For experimental ideas, prefer this causal order when applicable:

```text
raw material
-> sample construction
-> one controlled training run
-> sweep of the manipulated variable
-> observable measurements
-> analysis, parameter fitting, comparison, or other evidence step
-> outer comparison or main curve
-> controls and statistical tests
-> interpretation and decisions
```

State what each level produces before describing all runs needed to produce it. Do not present six disconnected “points” when they are actually consecutive stages of one experiment.

For non-experimental ideas, replace this with the source's real dependency chain, such as `premise -> construction -> mechanism -> guarantee -> limitation` or `input -> algorithm stages -> output -> why it works`.

Use tables only for genuine mappings or comparisons, formulas only when quantitative structure matters, and examples only when they resolve a concrete ambiguity. Do not force every section into `conclusion -> variables -> formula -> meaning`.

### 8. Layer qualifications after comprehension

Keep the teaching mainline separate from methodological qualification. Establish the mechanism first; then add unresolved protocol choices, controls, statistical qualifications, transfer conditions, and alternative interpretations where they become necessary.

Move a qualification into the first pass only when omitting it would create a materially wrong mental model. Completeness belongs in the full note and coverage audit, not in every opening sentence.

### 9. Preserve unresolved branches without choosing for the source

When a source leaves an implementation or interpretation unresolved, explain the shared scientific core first. Introduce the unresolved branches at the point where they begin to produce different procedures, measurements, or conclusions.

Do not silently choose one branch and rewrite the idea as if that choice had already been made. Keep the branch out of the opening when it does not change the shared core, and label it as unresolved rather than treating it as a result.

### 10. End with meaning and transferability

After explaining the result, answer:

- What can someone decide or estimate with it?
- Is the result a direct recommendation or only an input to a decision?
- Which part is likely reusable: the mechanism, method, qualitative pattern, function family, or numerical parameters?
- Can identical settings use it directly?
- Can nearby settings use it as an initialization or heuristic?
- If numerical parameters were fitted, must substantially different settings refit them?

For scaling or fitted-law work, distinguish the compute ledger from the performance ledger. Explain whether the work estimates actual processed data, effective data, loss, or a conversion between them.

## Source Coverage Audit

Before declaring the note complete, compare it against the full source and classify every substantive branch:

- core scientific questions or design target;
- central assumptions or proposed equations;
- main method, evidence, and final outputs;
- controls, baselines, and statistical tests when applicable;
- transfer, robustness, or cross-setting tests;
- negative-result interpretations and fallback claims;
- auxiliary or appendix experiments;
- practical use and limitations.

The teaching mainline may stay concise, but omitted branches must be placed in a clearly labeled “what else must be validated” or appendix section. Do not claim “the whole idea is covered” when only the central mechanism is covered.

Keep speculative brief claims provisional. Say “这个 idea 想检验” rather than presenting an unrun experiment as a result. Separate source claims, user heuristics, and your interpretation whenever they differ.

## Workflow

### Locate or create the note

1. Read every user-provided source needed to identify the idea.
2. Search for an existing explanation note and read its hidden `progressive-explanation-state`.
3. Search nearby notes when they may contain the user's existing understanding; preserve and link them rather than silently overwriting them.
4. For a new note, use `assets/explanation-note-template.md` and adapt its headings to the idea.

If the source is in the current project and no output path is given, create or reuse `<project-root>/讲解/` and use a human-readable Chinese filename. If no project root can be identified, create `讲解/` beside the source's project-level directory. If no source path exists, use `__HOME__/Desktop/papers/AI/` for papers or `__HOME__/Desktop/ideas/AI/` for ideas.

### Maintain links

- Put a visible link from the explanation note back to the source.
- For notes inside an Obsidian vault, use `[[vault/relative/path|显示名]]` for vault-local notes and `[[#完整标题|显示名]]` for headings in the same note.
- Do not use `../` Markdown links, generated heading slugs, or HTML anchors for Obsidian navigation.
- A true backlink from the source requires modifying the source; do so only with explicit authorization.

### Handle later questions

- Treat each question as evidence that an earlier causal link may be missing or unclear.
- Answer in chat without modifying the note unless the user explicitly asks to add, revise, record, or write the clarification into the note.
- When the user requests an update, revise the earliest place where the missing idea is needed, then update downstream sections that depend on it.
- Keep the note as a textbook, not a chronological chat log.
- Preserve correct user heuristics and label them as heuristics when they are not established results.
- If the user corrects the explanation, compare the old and new reasoning, but encode it in the note or skill only when explicitly authorized.
- Update the hidden state only when the note itself changes.

## Quality Check

Before saving, verify:

- The opening says what method addresses what problem.
- The opening gives the simplest complete mental model rather than an inventory of variables or contributions.
- The complete causal chain appears before detailed sections.
- When a central result structure exists, it appears early and the second pass explains how one atomic result is produced.
- Every concept is defined before use.
- Hidden/latent quantities are distinguished from measured quantities.
- When fitting exists, every fitted parameter has an explicit input-to-observation-to-fit explanation.
- The first pass gives orientation and the second pass follows real dependency order.
- Qualifications appear early only when needed to prevent a materially wrong mental model.
- Unresolved source branches remain unresolved and are introduced where their procedures diverge.
- Critical points, optimal choices, and recommended settings are not conflated.
- When fitting exists, function form, fitted parameter, and universal validity are not conflated.
- Practical usefulness and transfer conditions appear near the end.
- All source branches pass the coverage audit.
- User-authored text remains intact.
- All note formulas use valid Obsidian dollar delimiters, including formulas near headings.
- The source file remains unchanged unless explicitly authorized.

## Final Response

Unless the user asks for discussion in chat, respond only:

```text
完成：[文件名](/absolute/path/to/file.md)
```

## Optional Reference Example

Do not read the example by default. First derive the explanation independently from the current source and the user's actual confusion. Only consult the example when the explanation is genuinely blocked—for example, when the causal order remains unclear, a hidden bridge variable is difficult to expose, or a fitted quantity cannot yet be explained from observations.

If that need arises, the optional example is:

`__HOME__/Desktop/fst项目/讲解/视频扩散中的Stride与数据半衰期.md`

Use it only to inspect teaching moves such as whole-chain orientation, two-pass explanation, just-in-time concepts, hidden bridge variables, conditional fitting explanations, source coverage, and practical meaning. Never copy its headings, wording, formulas, examples, or domain-specific structure. Never assume another idea contains `D_eff`, half-life fitting, scaling laws, or even experiments. Return immediately to the current source and derive the final structure from that source. If the example is unnecessary or unavailable, continue without reading it.
