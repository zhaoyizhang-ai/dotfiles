---
name: wm-paper-incubation
description: Fast project-oriented paper explanation for the user's first-author research direction on adapting pretrained video models into action-conditioned world models. Use when the user asks to explain, read, quickly understand, compare, or judge papers related to world models, video generation, robotics, VLA, action-conditioned video/world models, interactive simulators, embodied policy evaluation, or whether a paper is actually "training video models into action-conditioned WMs."
---

# WM Paper Incubation

## Purpose

Explain papers clearly and cheaply as research fuel for the user's potential first-author line:

```text
pretrained video model -> action-conditioned world model -> embodied decision utility
```

The task is not ordinary paper reading and not reproduction planning. The user is using papers to reverse-engineer the current research frontier and select a plausible first-author contribution. Default to a compact explanation that makes the paper understandable, then extract what it says about the field's converging recipes, unsolved gaps, possible contribution shapes, and what results would be recognized as strong. Keep the paper explanation primary: do not force every paper to yield a concrete idea or contribution if the paper is mainly background, a recipe, or a boundary case. Save the same structured reading as one durable Markdown note under `__HOME__/Desktop/papers/AI`. Do not create a multi-file dossier unless the user asks for one.

Use `references/project-frame.md` when the request involves positioning, novelty, experiment ideas, advisor discussion, or the current VLA + WM benchmark context.

## Default Posture

- Write in Chinese unless the user asks otherwise.
- Answer in chat first, then save a one-file Markdown note by default unless the user explicitly says not to save.
- Optimize for "fastest useful understanding": explain the paper-specific mechanism and delta quickly. Make the target problem concrete only when the paper's setup is non-obvious; do not spend the opening on generic acWM or policy-evaluation motivation.
- Assume the user already understands action-conditioned world models, why acWMs can be used to evaluate policies, and the broad VLA/robotics motivation. Do not explain these basics unless the user explicitly asks, seems confused, or the paper changes that assumption in a non-obvious way.
- In the first substantive sentence, say the paper-specific core move, not a generic statement like "acWM can evaluate policy by rolling out futures." The user already knows that premise.
- Treat each paper as evidence for topic selection, not as a thing to copy. The final value of a reading is how it changes the user's sense of:
  - what people are currently doing;
  - which methods are becoming default/common recipes;
  - what remains poorly solved;
  - what methods could be recombined into a new contribution;
  - what kind of result would be considered impressive by the field.
- Do not over-generate ideas. Prefer a few grounded judgments over a long menu of speculative directions. If the paper's useful role is just "background", "common recipe", or "evidence that a route is crowded", say that plainly.
- Do not over-prioritize novelty or recency. A paper should be read early only if it is representative, influential, technically relevant, or exposes a useful gap for the user's project.
- Start with the paper's concrete intuition, not a paper-structure recap or field primer. The user prefers an example-grounded answer to "what new situation/problem is this paper actually handling?" before sections, formulas, or experiment data.
- Do not include Field-level Problem by default. Only include it when it adds a non-obvious distinction.
- Keep Experiments short by default; omit tables and raw numbers unless the user asks for evidence or comparison detail. Explain what claim the experiment supports instead of listing metrics.
- For recognition/status, report citation count, GitHub stars if an official repo exists, top-tier venue acceptance status if verifiable, and the paper timeline (first arXiv/public date, latest revision date, venue year/date when available). Do not pad this with institution/community-signal prose.
- Use the paper timeline to comment on the timeliness of the core method: whether the idea was early/novel for its publication time, whether it has since become a default/common configuration, whether it now looks outdated, or whether it remains technically fresh. Make this judgment explicit when useful for the user's topic incubation.
- Keep each paper note self-contained. Do not explain a paper by comparing it to another paper from the same conversation unless the user explicitly asks for comparison or the comparison is necessary for disambiguation. Avoid letting previous paper readings contaminate the current paper's framing.
- Keep the numbered structure if useful, but do not make the first substantive section formal. Section 1 should first teach the paper-specific intuition in plain language, using examples and direct comparisons when they add signal. Formal problem statements, module lists, formulas, and exact dataflow belong after that.
- When writing formulas, use LaTeX display blocks (`$$ ... $$`) or inline LaTeX, not fenced `text` code blocks, so subscripts/superscripts render correctly.
- Prefer primary sources: paper PDF, arXiv/OpenReview page, official project page, GitHub, Hugging Face, dataset pages.
- Search or fetch current sources when links, releases, checkpoints, code status, dataset status, or dates may have changed. Include source URLs in notes and final answers.
- Separate paper claims, code/release facts, and your interpretation.
- Do not invent released models, benchmark numbers, commands, datasets, or "obvious" contributions.
- It is acceptable to say "this paper is not really about training video models into acWM"; explain the mismatch.

## Core-First Explanation Style

For mechanisms, put the user's preferred level of summary before the intuitive explanation: one or two sentences that name the base method, the added component, and the actual dataflow. This "core summary" should be blunt and structural, not polished-paper prose. Keep the later intuition/example section; the core summary is an extra layer before it, not a replacement.

Good pattern:

```text
Mem-World = Ctrl-World + 一个 surfel memory 检索器。

它持续把看过的场景表面存成 surfel memory；生成下一段前，用当前 EE pose + future action 推出未来 wrist camera pose，然后从 memory 里找和这个未来视角最相关的历史帧，取 top-K 当条件喂给 Ctrl-World。

关键点：top-K 选的是历史帧，不是 surfel 本身；surfel 只是用来打分和检索历史帧的索引。
```

Then expand with the same granularity:

```text
存：初始化时用多视角建 surfel memory，rollout 时主要用 wrist view 更新已经观察到的表面。
算：current robot state + future action chunk -> future EE poses -> future wrist camera pose。
找：用 future wrist pose 渲染/打分 surfels，score 看可见性、朝向/深度、任务相关性和时间新近性。
喂：取 top-K historical observations 作为 world model context。
```

Avoid overcorrecting the user's concise intuition with many caveats unless a caveat changes the core mechanism. If the user says "是不是就是接近的就关注", answer at the same level first: "是，直觉上就是未来手/腕相机会去哪里就回忆那里；只是实现上用 future wrist pose + surfel score，而不是纯 EE 距离。" Then add details.

## Default Answer Shape

Use this structure unless the user requests a different one:

```text
0. 地位和认可度
   - First public/arXiv date and latest revision date.
   - Venue acceptance and venue year/date if verifiable.
   - Citation count.
   - Official GitHub stars if a repo exists.
   - Brief timeliness judgment of the core method based on the paper date: early/novel then, default/common now, outdated, or still fresh.

0.5 最核心总结
   - Put this before "先把它讲明白".
   - Use 1-3 blunt sentences at the user's preferred granularity.
   - Name the base, the added component, the real dataflow, and the single key correction if needed.
   - Do not restate the generic premise that acWMs can roll out futures to evaluate policies. Start from what this paper adds, changes, or gets wrong/right relative to that already-known premise.
   - Example: "Mem-World = Ctrl-World + 一个 surfel memory 检索器。它持续把看过的场景表面存成 surfel memory；生成下一段前，用当前 EE pose + future action 推出未来 wrist camera pose，然后从 memory 里找和这个未来视角最相关的历史帧，取 top-K 当条件喂给 Ctrl-World。关键点：top-K 选的是历史帧，不是 surfel 本身。"

1. 先把它讲明白
   - This is the most important section.
   - Keep this section even when a core summary is included.
   - First write the paper-specific intuition in natural language, like explaining to the user at a whiteboard.
   - Use a concrete situation/example only if it sharpens the paper's actual contribution. Keep it brief; do not re-teach acWM, policy rollouts, or why policy-in-the-loop evaluation matters.
   - Explain what older or adjacent methods would do, why that is awkward or unreliable, and what this paper wants to change only when those contrasts are necessary for understanding the method.
   - Do not start with formal problem formulation, paper section numbers, or formulas.
   - Do not force a universal failure-chain template; choose the shape that fits the paper.

2. 形式化地说，它想解决什么问题
   - Do not write generic field-level motivation.
   - Do not explain from scratch that world models simulate futures for policy evaluation.
   - State the concrete bottleneck in this paper's own terms: action controllability, robot geometry drift, contact grounding, object-state error, long-horizon collapse, policy-evaluation mismatch, data bottleneck, representation mismatch, evaluation mismatch, etc.
   - Ground the bottleneck in an example scenario only when the bottleneck would otherwise be abstract. Different papers may need different explanation shapes; do not always force a causal chain.

3. 核心方法是什么
   - Explain the idea before the architecture.
   - Then explain dataflow: inputs, action conditioning, model backbone, trained/frozen modules, rollout/inference.
   - Avoid leading with Problem Formulation or formulas unless they clarify the intuition.

4. Experiments 怎么证明有效
   - Omit by default when the user asks for "读一下" unless experiments are essential to the main claim.
   - If included, summarize claim-level evidence only; do not dump tables.

5. 还有什么没解决 / 局限
   - Technical limitations.
   - Evidence gaps.
   - Compute/data/release gaps.
   - Why this still leaves room for the user's project.

6. 对我的方向意味着什么
   - 方法上：它到底怎么做，能不能借。
   - 问题上：它解决的是不是大家都想解决的核心问题。
   - 未来上：它做到什么程度，下一步最小实验是什么。
   - 选题上：它把哪些方向堵死了，留下哪些缺口。
   - 认可上：如果沿这个缺口做成，什么结果会被认为厉害；什么结果只是小修小补。
```

If the paper is not provided or cannot be identified, ask for the title, PDF, arXiv/OpenReview URL, or project page before analyzing.

## Reading Workflow

1. Resolve the paper and artifacts.
   - Identify title, authors, venue/date, paper URL, code URL, project page, model/data artifacts, and license if relevant.
   - If the user provides only a title or vague clue, locate the primary source before making claims.

2. Explain the paper mechanism first.
   - For model papers, start with the paper-specific mechanism and core intuition in plain language. Use a concrete scenario only if it clarifies that mechanism; skip generic acWM/policy-evaluation setup. Then, in later sections, provide architecture and dataflow: inputs, outputs, conditioning, latent/state representation, backbone, prediction heads, training losses, frozen vs trained modules, inference rollout.
   - For benchmark or evaluation papers, start with operational flow: data source, model/environment inputs, intermediate artifacts, evaluator, metric, baseline, and where each score is computed.
   - Use concrete chains such as `o_t, a_t, history -> WM -> o_{t+1} -> fixed policy/VLA -> a_{t+1}`.

3. Extract the action-conditioned WM relevance.
   - Identify whether the work is about video generation, action-conditioned generation, latent dynamics, 3D/4D world modeling, policy-in-the-loop simulation, synthetic data, or evaluation.
   - Map where actions enter: text prompt, action tokens, proprioception, end-effector deltas, camera motion, latent control, planner output, reward-conditioned signal, or post-hoc evaluator.
   - State whether it helps with training the world model itself, evaluating world models, adapting video models, or only related background.

4. Produce a project judgment panel, but keep it shorter than the method explanation unless the user asks for ideation.
   - What this paper proves.
   - What it does not prove.
   - What we can borrow.
   - What we should not copy.
   - What confounder or failure mode it reveals.
   - How it changes the user's possible model-training direction.
   - How to distinguish the user's future work from this paper in related work.
   - Whether the paper's method is already becoming a common recipe.
   - Whether the remaining gap is a real research opening or just an engineering/scale issue.
   - What kind of evidence would make a follow-up contribution feel recognized as strong.
   - Keep this about the current paper unless the user asks for cross-paper synthesis.

5. Propose early experiments only after the reading and only when useful.
   - Give 1-3 small experiments, not a giant training plan.
   - Each experiment must include hypothesis, minimal data/model choice, implementation sketch, expected signal, failure criterion, and what decision it unlocks.
   - Prefer low-risk adaptation or probing over from-scratch large-model training.
   - Flag compute assumptions. For the user's personal/student compute, default to single-GPU or short debug jobs unless the user confirms larger lab resources.

6. Persist notes.
   - Default: write one Markdown file.
   - Save AI-generated paper-reading notes under `__HOME__/Desktop/papers/AI`, not directly under `__HOME__/Desktop/papers`, not under `__HOME__/Desktop/ResearchNotes`, and not under the transient Codex workspace.
   - Follow the user's existing flat Obsidian style inside that AI inbox: prefer `__HOME__/Desktop/papers/AI/<paper-short-name>.md` such as `DWS.md`, `MWM.md`, or `Mem-World.md`.
   - If a matching note already exists and is only a template/stub, fill it. If it already contains substantial user notes, append a clearly titled section instead of deleting user content.
   - If the user explicitly says "只在聊天里讲", "不用保存", or similar, do not write files.
   - If the user asks for a durable dossier, or the paper becomes central enough to cite heavily, create a subfolder inside `__HOME__/Desktop/papers/AI/<paper-short-name>/`.

## Optional Note Format

By default, create one file:

```text
__HOME__/Desktop/papers/AI/<paper-short-name>.md
```

Use the same Default Answer Shape as headings. Add source URLs and date checked at the bottom.

Use a full seven-file dossier only when the user asks for "精读", "深度解读", "完整 dossier", "保存成一套笔记", or similar durable outputs. Save those files under `__HOME__/Desktop/papers/AI/<paper-short-name>/`.

## Suggestion Discipline

When proposing ideas, keep them subordinate to the paper explanation. Use this grading:

- **A: Candidate direction** - plausible novelty, clear experiment, likely related-work distinction.
- **B: Probe first** - interesting but needs a small empirical test before becoming a topic.
- **C: Background only** - useful for framing, not enough as a first-author direction.
- **D: Avoid for now** - too crowded, too compute-heavy, too dependent on unreleased assets, or not aligned with action-conditioned WM training.

For every A or B idea, include one kill test. If no kill test exists, the idea is too vague.

When the user is in topic-selection mode, prefer contribution-shape judgments over raw idea lists:

- **Strong contribution shape**: a clear problem not already solved, a method that is more than a small adapter tweak, and evidence that would change how people evaluate or train acWMs.
- **Weak contribution shape**: a minor variant of action injection, a metric-only change without method consequence, a scale-only claim, or a reproduction of another paper's engineering recipe.
- **Blocked by prior work**: if a candidate idea is already covered by a strong paper, say so directly and name what must be different.
- **Too risky for now**: if a direction requires unavailable assets, very large compute, or unobservable evaluation, mark it as risky even if it sounds novel.

## Project Integration

Use `__HOME__/Desktop/papers` as the reading base for this skill, but use `__HOME__/Desktop/papers/AI` as the AI-generated note inbox. Do not write to `__HOME__/Desktop/ResearchNotes` unless the user explicitly asks to sync there.

When a paper affects the existing VLA + WM benchmark or the user's model-training line, capture the conclusion inside that paper's Markdown note first. If the user later asks for cross-paper synthesis, create a separate synthesis note under `__HOME__/Desktop/papers/AI`, such as:

```text
__HOME__/Desktop/papers/AI/【总结】paper-map.md
__HOME__/Desktop/papers/AI/【总结】idea-seeds.md
```

Do not commit, rebuild docs, or update external changelogs unless the user asks.

## Final Response

Keep the final answer focused:

- Say what was read or created.
- Give the main technical takeaway.
- Give the project judgment and the best next experiment if relevant.
- Link local note files if saved.
- Mention sources checked and any unresolved source gaps.
