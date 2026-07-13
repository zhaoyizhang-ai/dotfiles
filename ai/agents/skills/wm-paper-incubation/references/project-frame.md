# Project Frame

Use this reference when paper reading needs to feed the user's topic incubation or early experiment design. Do not let this reference replace paper explanation: first explain the paper's problem, method, experiments, and limits; then use this frame to judge relevance.

## Research Direction

The user's potential first-author line is not a fixed topic yet. It is a direction:

```text
Start from pretrained video models.
Train or adapt them into action-conditioned world models.
Find a model-training contribution that is worth a top-tier submission.
```

This is a model/method direction, not only a benchmark, survey, or application. It may connect to the existing WM Judge / VLA + WM benchmark project, but it should not collapse into "just evaluate models."

## Advisor Signal

- The group already has a clearer WM Judge submission line.
- The user may develop a separate first-author line focused on world-model model training.
- The work could target ICLR if it matures quickly, otherwise CVPR/ICML later.
- Starting a large world model from scratch during the summer is too risky.
- Prefer adapting, post-training, probing, or modularly extending existing video/world models.
- The scope is broader than action-conditioned video generation: latent WM, 3D/4D WM, interactive simulators, policy-conditioned dynamics, and embodied utility are all possible if grounded.
- The user must actively form the research question by reading papers and iterating early experiments.

## Existing Project Language

Current benchmark context:

```text
fixed VLA probe + WM-generated observations -> measure decision utility
```

Important terms:

- decision utility over perceptual quality
- fixed VLA probe
- action divergence
- Trust Horizon
- semantic checkpoint
- VLM judge as calibrated measurement instrument, not ground truth
- VLA x WM matrix
- simulator observation vs WM-generated observation
- WM-induced policy error

When relevant, express paper implications in this vocabulary.

## What To Look For In Papers

Look for mechanisms that may become a model-training contribution:

- How a pretrained video model is given action control.
- Whether action conditioning enters as tokens, adapters, cross-attention, latent dynamics, camera/control embeddings, proprioception, or external planner traces.
- Whether the model predicts pixels, latents, states, rewards, affordances, contact, geometry, or policy-relevant features.
- Whether long-horizon rollout stability is trained directly, distilled, reset, corrected, or only demonstrated visually.
- Whether the method separates controllability, physical consistency, and decision usefulness.
- Whether data requirements are realistic for single-GPU prototyping.
- Whether released code/checkpoints make early experiments possible.

## Useful Paper Categories

- Action-conditioned robot video/world models: likely closest to the target.
- General video diffusion or autoregressive video models: useful if adaptation path is plausible.
- Interactive world simulators: useful for rollout interfaces and controllability.
- VLA/policy evaluation in generated worlds: useful for decision-utility metrics and failure modes.
- Latent world models and model-based RL: useful for state abstraction and rollout training, but must be mapped carefully to modern video backbones.
- 3D/4D scene or dynamics models: useful if they offer better action/state factorization than pure pixels.

## Early Experiment Bias

Prefer experiments that answer one decision:

- Can an existing video model accept an action signal without destroying visual quality?
- Does action conditioning change action-relevant state, not just superficial motion?
- Does a small adapter outperform prompt-only or frame-history baselines?
- Does latent-space conditioning preserve VLA decision variables better than pixel-space conditioning?
- Can a generated next observation keep a fixed VLA's next action close to the simulator-grounded action?
- Does rollout error become action divergence before it becomes obvious visual failure?

Avoid experiments that require:

- training a large video model from scratch;
- unreleased datasets/checkpoints;
- multi-GPU assumptions without confirmation;
- metrics that only show nicer videos;
- broad "new benchmark" work unless it directly supports model training.

## Reading Output Bias

Every project-oriented paper answer should prioritize the paper itself:

0. One-sentence content summary: what method solves what problem.
1. What problem the paper solves.
2. What method it uses, with section-level mapping.
3. Whether it actually trains/adapts a video model into an action-conditioned WM.
4. What experiments support the claims.
5. What remains unsolved.

Only after that, end with:

1. A one-sentence verdict.
2. A graded idea: A / B / C / D.
3. One minimal next experiment if the grade is A or B.
4. One kill test.
5. One related-work distinction sentence.
6. One question to ask the advisor if the direction remains ambiguous.
