# IWS Quality Example

Use the Interactive World Simulator dossier as the target quality bar.

Local source package:

```text
__HOME__/Desktop/ResearchNotes/papers/<paper-slug>/
```

Optional published docs paths, only if the user later builds a docs site:

```text
docs/papers/<paper-slug>/
site/papers/<paper-slug>/
```

Reference document map:

- `00_index.md`: concise entrypoint, research boundary, reading order, completion status.
- `01_model_training_mechanism.md`: deep technical mechanism report; for IWS this explained Eq.(1)-(5), CTM/consistency training, encoder/decoder/dynamics, and long-horizon stability.
- `02_data_reproduction.md`: data and reproduction report; for IWS this covered MuJoCo, real ALOHA, HDF5, zarr, action primitives, released HF data/checkpoints, and commands.
- `03_experiments_evidence_limits.md`: evidence review; for IWS this covered Table I, Figure 3-7, baseline fairness, ablation gaps, and statistical limits.
- `04_architecture_product_implications.md`: route-level thinking; for IWS this extracted world state/action/physics/evaluation philosophy, product wedge, and kill tests.
- `05_master_report.md`: integrated synthesis; first file to recommend reading.
- `06_reproduction_checklist.md`: executable staged checklist.
- `07_source_notes.md`: URLs, code files inspected, local verification notes, known gaps.

The expected tone is a technical partner memo: concrete, skeptical, source-grounded, and useful for deciding what to reproduce or build next. Avoid newsletter-style summaries.
