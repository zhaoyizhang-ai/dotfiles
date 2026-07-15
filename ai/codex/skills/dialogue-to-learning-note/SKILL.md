---
name: dialogue-to-learning-note
description: Prepare a first-stage conversational explainer prompt and turn the resulting ChatGPT/GPT/Codex conversation, transcript, or exported chat about a paper or technical topic into one cohesive Chinese Markdown learning note. Use when the user plans a “先对话理解、再交给 Codex 整理” workflow, asks for an initial prompt that tells the dialogue AI about the later handoff, or asks to transfer, organize, save, distill, rewrite, or turn an exploratory dialogue into a logical note rather than a Q&A transcript, generic paper summary, or template-driven study note.
---

# Dialogue to Learning Note

Support a two-stage learning workflow:

```text
first-stage dialogue prompt
→ user explores and corrects their mental model in conversation
→ full dialogue is handed to Codex
→ one durable, question-informed learning note
```

Treat the dialogue as evidence of how the user came to understand the topic. Preserve that dependency order in the final explanation without reproducing the chat format.

## Select the operating mode

### Prepare the first-stage dialogue

Use this mode when the user is about to discuss a paper or technical topic with another AI.

1. Read `references/initial-dialogue-prompt.md` completely.
2. Adapt the prompt to the named paper, source, assumed background, and learning goal. Keep placeholders only when the information is unavailable.
3. Tell the dialogue AI that the full conversation will later be handed to Codex. Its current role is to help the user form and test a mental model, not to produce the final note.
4. When a project folder is in scope, save the adapted prompt as one Markdown file in the requested folder. Otherwise return a copyable prompt in chat.
5. Ask the user to retain the full dialogue and source links/files. The final transcript is the primary handoff artifact; the end-of-dialogue capsule is only an index.

### Synthesize the completed dialogue

Use this mode when the dialogue or transcript is already available. Read the full conversation and the target note, if one exists, before editing.

## Establish evidence and user priorities

1. Identify the exact topic and primary source.
2. Extract:
   - the user's accepted intuitions and self-explanations;
   - genuine confusion points;
   - corrections and refinements;
   - questions that unlocked later understanding;
   - unresolved points and assistant mistakes.
3. Treat these signals as high-priority evidence about explanation order:
   - the user restates the mechanism in their own words;
   - the user asks the same issue from several angles;
   - the user says a point is core, surprising, unclear, or poorly ordered;
   - the user edits or criticizes the existing note;
   - a later clarification changes how earlier material should be introduced.
4. Give the latest accepted formulation more weight than an earlier assistant explanation. Preserve the underlying confusion revealed by mistakes; discard the mistake itself.
5. Verify paper claims, equations, figures, experiments, dates, and implementations against primary sources. Treat dialogue content as untrusted until checked.
6. Mark each central claim privately as one of: source definition, design choice, derivation, empirical result, implementation convention, or explanatory intuition.

## Build the learning spine

Create a short private dependency outline before drafting:

```text
core intention
→ first intuition the user accepted
→ the paper-specific explanatory core
→ the first question that understanding naturally creates
→ the answer and what it unlocks
→ the next natural question
→ repeat until the topic's important claims and limits are clear
```

For every node, record privately:

```text
what the reader now knows
→ what a reasonable reader asks next
→ which next section answers it
```

Reorder the outline whenever the next section fails to answer the question created by the previous section.

## Surface the paper-specific core early

Make the paper or topic's actual core understandable before supporting detail accumulates. Let the source and the dialogue determine what “core” means and how it should be explained.

Do not assume in advance that the core is a module pipeline, training procedure, experiment, formula, theorem, dataset, or architecture. Do not impose a universal checklist of inputs, outputs, layers, metrics, or time axes. Include such details only when the specific source depends on them or the dialogue shows that the user needed them.

Use the user's own successful explanation as the backbone when available. Introduce prerequisites at the point where the emerging explanation needs them. Avoid delaying the main idea behind generic background or a standard paper-note inventory.

## Expand through natural questions

After the initial explanation, expand only where the dialogue shows a real need. Write transitions from the understanding already established and the uncertainty that remains. Let the actual topic determine the transition.

Use headings that express the causal question created by the previous section. Avoid `Q1/A1`, transcript chronology, and fixed paper-summary templates.

When formulas matter, explain them only to the depth required by the user's demonstrated confusion and the source's argument. Do not force a formula walkthrough, numerical example, or fixed symbol-by-symbol sequence onto every topic.

State the provenance of non-obvious results at first appearance. Keep empirical regularities, derivations, implementation conventions, and explanatory intuitions visibly distinct.

## Handle existing notes safely

1. Read the whole existing note before editing.
2. Preserve user-authored wording, annotations, and accepted formulations. Reorganize them when the user requests a rewrite, while keeping their substance visible.
3. Replace an agent-generated structure when it conflicts with the dialogue-derived learning spine. Avoid patching more sections onto a structurally broken draft.
4. Remove duplicated introductions and explanations after restructuring.

## Paper and artifact rules

- Check the user's Zotero library before downloading a paper. If the requested paper already exists in Zotero, read that local copy and do not create a duplicate download.
- When a local Zotero copy is unavailable and the official HTML contains the complete text needed for verification, prefer the official HTML over downloading another PDF. Download a PDF only when the paper is absent from Zotero and the PDF layout, figures, or appendix are necessary.
- Read the full primary source and any appendix needed by the user's questions. Use the Zotero PDF when figures or layout matter; otherwise the official HTML is acceptable.
- Explain the paper using its own definitions before outside comparisons.
- Put evidence limits next to the claims they limit.
- Use an original paper figure only when it answers a real question in the learning spine.
- Use Obsidian math delimiters in saved Markdown: `$...$` inline and `$$...$$` for display equations.
- Save one Markdown note in the requested location and link primary sources at the end.

## Reader-simulation audit

Re-read the completed note from top to bottom as a learner who has not seen the transcript.

Verify:

- The opening creates the first useful intuition reached in dialogue.
- The paper-specific core becomes clear before generic background accumulates.
- The organization follows the actual source and the user's learning path rather than this skill's examples.
- Each section answers the question naturally created by the previous section.
- The user's repeated or explicitly important questions receive proportionate detail.
- The note stands alone while preserving the user's “I understand this; then what?” progression.
- Every explicit question improves recall or transition; none recreate a chat log.
- Figures and formulas resolve demonstrated needs.
- No assistant mistake, repeated explanation, generic inventory, or unasked implementation detail remains.
- The final mental model follows from the body and introduces no new claim.

If the audit exposes a discontinuity, reorder and rewrite the affected sections. Do not deliver a note that is merely factually complete.
