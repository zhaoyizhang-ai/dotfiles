---
name: paper-quickread
description: Read a research paper from its primary PDF and explain it in Chinese as a complete, natural Markdown reading note. Use when the user asks to read, explain, quickly understand, summarize, or create notes for a paper from a PDF, arXiv, OpenReview, official project page, or code repository, especially when they need the concrete problem, full method/dataflow, formulas, experiments, evidence, and limitations rather than a title-and-abstract summary. Save one Obsidian-compatible Markdown note when a folder or vault is in scope.
---

# Paper Quickread

## Goal

Read the primary paper in full, then make the reader able to reconstruct the work: what concrete problem it solves, why earlier approaches fail, what data and model enter each stage, what every essential formula means, which experiments establish which claims, and where the conclusions stop. Default to a substantial reading note for a technical paper; produce a short chat overview only when the user explicitly asks for one.

Do not add research ideas, topic-selection advice, reproduction plans, or contribution proposals unless the user explicitly asks. A source-backed advisor insight found through the project-context workflow below may be included as attributed interpretation; keep it separate from the paper's own claims.

## Resolve and read the paper

1. Resolve the exact version and primary artifacts: full PDF, arXiv/OpenReview record, official project page, code, model, and dataset when relevant.
2. Read the entire PDF, including figures, tables, appendices, algorithms, and supplementary implementation details that support a central claim. Do not rely on the abstract, title, snippets, project-page prose, or secondary summaries.
3. Inspect architecture figures visually. For a model paper, identify the main architecture figure and every figure needed to explain an important data path; do not rely on extracted figure captions alone.
4. Check version date, availability, and links against primary sources. Include direct source URLs at the end of the note.

## Integrate project advisor insights when available

For papers read inside `__HOME__/Desktop/fst项目`, check this project context by default:

`__HOME__/Desktop/fst项目/学姐提及的工作、完整评论原话与对应网站.md`

1. Search the file with the paper title, common short name, arXiv ID, model name, and obvious transcription variants. Start with targeted `rg` context, then read the complete matching subsection.
2. Continue without advisor material when the file is absent or has no reliable match. Do not mention the absence in the delivered note.
3. Use only statements actually present in the matching subsection. Preserve timestamps when quoting and link the local source at the end of the note.
4. Attribute every interpretation to the advisor. State clearly which capability the paper demonstrates and which point is an advisor-proposed extension, analogy, evaluation lens, or research direction.
5. Integrate each insight at its natural explanatory location:
   - task positioning beside the problem and setting;
   - an input or control extension beside the relevant architecture/conditioning path;
   - an evaluation lens beside the corresponding experiment or evidence boundary;
   - a contribution judgment beside “What is distinctive”;
   - an unsupported extension beside limitations.
6. Prefer short attributed paragraphs or callouts woven into the main explanation. Use a standalone late “advisor insight” section only when the source contains a coherent argument that has no natural location in the paper's causal flow.
7. Skip weak name matches, generic meeting remarks, and comments whose connection would require speculation. Do not force every advisor quote into the note.

## Decide the depth

Use the paper's actual complexity, not a fixed template.

- For an empirical ML/CV/robotics/world-model paper, explain the task formulation, failure mode, architecture/dataflow, training objective, data construction, evaluation protocol, main comparison, ablations, generalization claims, and limitations.
- For a paper that introduces or substantially changes a model, make the architecture the centre of the note. A reader must be able to trace what enters each module, what operation occurs there, what leaves it, where the module is inserted, and how it is trained or called at inference.
- For a theory or methods paper, explain assumptions, definitions, theorem statements, proof strategy, and the practical implication of each result.
- For a short or simple paper, omit irrelevant sections rather than inventing depth.
- For a paper with unusually important data, benchmark, or evaluation design, explain it as part of the method rather than treating it as an afterthought.

## Write a complete reading note

Write Chinese unless requested otherwise. Begin with a paper-specific takeaway in one or two sentences, then explain in the causal order that makes the work understandable:

1. **Problem and setting** — State inputs, outputs, task assumptions, and why this problem matters in this paper's setting.
2. **Why prior approaches fail** — Name the precise mismatch or bottleneck; do not merely list citations.
3. **Architecture and mechanism** — For a model paper, embed the architecture diagram before explaining it. Give a left-to-right, module-by-module walkthrough: input representation, insertion point in the backbone, tensor reshape or routing, every branch, attention/MLP/normalization operation, residual or skip connection, output representation, repeated layers, and training/inference relationship. Give a plain-language picture before equations and define new terms exactly as the paper uses them.
4. **Mathematical formulation** — Include every formula necessary to understand the architecture, loss, inference rule, or essential metric. Define every symbol immediately before or after its first use; give intuition and, when helpful, a tiny operational example. Explain why each term or operation is needed, not only what it computes.
5. **Training and data** — Record backbone, conditioning signals, supervision, initialization/freezing choices, and only data-processing details that explain why the method should work. Do not fill the note with dataset counts, train/validation/test sizes, raw hyperparameters, or catalogues of games/tasks unless the user asks or the number changes the conclusion.
6. **Experiments and evidence** — State what each important experiment establishes, what is controlled, how large the meaningful relative improvement is, and what the result does *not* establish. Prefer a qualitative conclusion or a relative change such as “about twice the completion rate” over tables of raw scores. Include a raw metric only when its absolute threshold or scale is itself necessary to interpret the claim. Include key ablations and test-time controls.
7. **What is distinctive** — State the real contribution in relation to the identified failure mode, avoiding promotional language.
8. **Limitations and evidence caveats** — Preserve the authors' limits and add clearly labeled evaluation caveats when methodology leaves a material alternative explanation (for example: unequal interfaces, synthetic test distributions, small human study, proxy evaluation, or missing long-horizon tests).
9. **Bottom line** — Give a calibrated conclusion: what a reader should believe after the paper, and what remains unproven.

Use headings only where they make the particular paper easier to scan. Keep the argument cohesive: a note should read as an explanation, not a mechanical section-by-section dump.

## Direct-definition writing rule

Write definitions and architecture explanations as direct affirmative statements. Strictly prohibit the Chinese contrastive constructions “不是……而是……”, “并非……而是……”, “不……而……”, “严格来说”, “准确来说”, and “与其……不如……” in the delivered explanation.

- Open a module description with its input, operation, output, and purpose. For example, write “左侧输入包含连续摇杆轨迹、离散按键和视觉 token” rather than first denying that it is a text instruction.
- State evidence boundaries directly. For example, write “该实验支持短片段视觉迁移；规则理解与长时程状态仍缺少直接验证” rather than framing the boundary as a negation-and-correction.
- State a caveat as the observed interface, scope, or missing measurement. Keep the explanation forward-moving; do not use a denial as the main clause.

## Reader priorities for technical paper notes

- Answer a simple confirmation question in one short sentence. Example: “Input Token 来自上一层。”
- Put explanation length on the mechanism the reader has identified as unclear: branch connections, merge operations, context windows, conditioning injection, or state flow.
- Explain a figure through the computation that connects its blocks. Avoid a label-by-label tour of familiar backbone components.
- For a two-branch diagram, state the shared input, the update produced by each branch, the exact merge equation, and the single downstream output token stream.
- Keep experiment discussion as an evidence summary. Omit raw score tables, dataset-size catalogues, and metric inventories unless the user asks for them.
- Use the original architecture figure when available. Place it beside the focused explanation.

## Mandatory architecture visual for model papers

For every model paper:

1. Extract the paper's main architecture figure at readable resolution when one exists. Crop out surrounding page text, preserve labels, save it beside the note in an assets folder, and embed it directly in the Markdown immediately before the architecture walkthrough. Cite the original figure number in the caption. Do not merely link to the PDF or redraw an existing figure unnecessarily.
2. When the paper has no usable architecture figure, create a structurally faithful diagram from the paper using an appropriate diagram-generation tool: prefer Excalidraw or a rendered Mermaid diagram for labelled dataflow, and use an image-generation tool only when its labels and arrows can be verified. Save the resulting asset beside the note and embed it. Do not use a decorative illustration in place of a dataflow diagram.
3. Explain the embedded diagram in reading order. Name the input and output of every major block, distinguish shared/broadcast conditions from per-token or per-pixel features, and explicitly state where conditioning is injected: concatenation, cross-attention query/key/value roles, adaptive normalization, residual addition, token prepending, or another mechanism.
4. When a paper has several distinct stages, include the main end-to-end architecture figure and create a second focused diagram only if the original figure cannot make a crucial local module understandable.
5. Begin every architecture walkthrough by answering these reader questions in plain language: “What is the input to this block?”, “Where does that input come from?”, “What is the block's one output, and which next block receives it?”, and “Which intermediate branches are updates rather than outputs?” Explain the answer before naming layers.
6. Decode each ambiguous visual symbol explicitly. State whether a plus-shaped node means numerical residual addition or visual concatenation; define a context window by the exact frames/tokens it contains; identify which panels are output visualizations rather than computational nodes. Use the paper's equations to settle any ambiguity in the drawing.
7. Keep the diagram walkthrough focused on the computation. Omit a left-to-right inventory of familiar backbone labels when it does not answer an input, output, routing, or merge question.

## Chat versus Obsidian formula rules

In the chat window, write formulas as ordinary readable text. Do not use dollar signs, double-dollar display blocks, or LaTex math delimiters. Use plain expressions such as r=4, 16×4=64, x_out = x_hat + Δx_c + Δx_d. Use a short indented line or a code block only when a multi-line expression needs alignment.

Apply dollar delimiters only when writing or editing a Markdown note for Obsidian.

## Obsidian formula rules

When saving a Markdown note intended for Obsidian, use dollar delimiters for every mathematical expression. This requirement is mandatory.

- Use `$...$` for inline math and `$$...$$` for display math. Never use `\\(`, `\\)`, `\\[`, or `\\]` as math delimiters.
- Preserve mathematical operators in LaTex inside the dollar delimiters, for example `$x \in \mathbb{R}^{B \times N \times D}$` and `$$\mathcal{L}=\mathbb{E}_{t,z_0,\epsilon}\left[w(t)\lVert v_\theta-(\epsilon-z_0)\rVert_2^2\right].$$`
- Do not place a display formula inside a list item if it can be a normal paragraph. Leave a blank line around `$$...$$` blocks.
- Define symbols in prose, then give the formula, then explain its intuition. Do not paste equations without connecting them to the model's dataflow.
- Embed paper figures with a relative image path that Obsidian renders, for example ![](assets/paper-architecture.png). Keep a one-line caption and source figure number directly below the image.
- Use Markdown tables only for mappings that cannot be read as prose. Do not make result-score tables the default.
- Use Mermaid only for an original replacement diagram. Use standard triple-backtick fences and simple ASCII node labels, then verify the fence and renderability before delivery.

## Evidence discipline

- Treat reported numbers as paper claims unless independently reproduced.
- Call an architecture ablation the strongest architectural evidence only when data, training, and input interface are otherwise held constant.
- Report the useful comparison, not a scoreboard: say what improved, by roughly how much relative to the strongest relevant baseline, and why that supports the mechanism. Omit absolute metric values, dataset totals, and exhaustive metric tables by default.
- Flag comparison asymmetries, such as action-to-text translation for baselines, unavailable training data, differing model sizes, or different test-time inputs.
- Separate zero-shot visual transfer, action following, physics fidelity, state tracking, and long-horizon planning; success on one is not proof of the others.
- Do not overstate a dataset's “first” claim beyond the authors' wording.

## Saving notes

- Create one Markdown file per paper unless the user asks for a dossier.
- Follow the requested folder. For the user's paper vault, prefer an existing `讲解` folder and avoid creating `讲解 2` unless a real conflict requires it.
- If a matching note has substantial user writing, preserve it and append a clearly labelled update rather than overwriting it. Otherwise, replace an inadequate agent-generated draft with the improved complete note.
- Use a clear filename based on the paper title. End with primary-source links and the date checked.

## Quality check

Before finishing, verify that:

- the note is grounded in the full primary paper and visually checked figures when needed;
- every model paper contains a readable embedded architecture visual and a step-by-step explanation of the exact conditioning/injection path;
- the delivered Chinese prose contains none of the prohibited negation-and-redefinition constructions;
- a reader can follow all critical arrows in the method's dataflow;
- every essential formula uses Obsidian-compatible dollar delimiters and all symbols are defined;
- every central result is linked to the claim it supports and at least one material caveat is included where warranted;
- the opening and closing give a clear, calibrated understanding rather than a generic paper recap;
- any matched advisor insight is attributed, placed beside the paper mechanism it illuminates, and separated from the paper's demonstrated claims;
- no unsupported facts, invented details, or unsolicited research advice were added.
