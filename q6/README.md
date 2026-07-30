# Q6: Metadata Quality Experiment

## Research Question

Is the T20 accuracy cliff a table-count problem or a metadata curation problem? Can better descriptions, synonyms, and documentation recover the lost accuracy?

## Design

Same 20 tables, same 27 questions, same model (Haiku). Only the semantic view metadata varies:

| Variant | Description |
|---------|-------------|
| BARE | Column names only. No descriptions, no synonyms, no comments. |
| CURRENT | What we already have (moderate descriptions + some synonyms). |
| RICH | Detailed descriptions on every element, extensive synonyms, sample values in comments. |

## Results

(Pending full completion - partial results below)

| Variant | Accuracy | vs T5 baseline (85%) |
|---------|----------|---------------------|
| BARE | TBD | |
| CURRENT | ~74% | -11 pts (the known cliff) |
| RICH | TBD | |

## File Structure

```
q6/
├── README.md
├── sql/
│   └── 01_metadata_variants.sql  (BARE + RICH view definitions)
├── yaml/                          (3 eval configs)
└── results/
```
