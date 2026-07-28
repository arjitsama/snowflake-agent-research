# Q1 Table Scaling Experiment

## Research Question

Does adding more tables to a semantic view degrade answer quality?

## Result (Phase 3 - fixed data, v4)

**Yes. The cliff is at 10-20 tables.**

| Model | T5 | T10 | T20 | Drop T10→T20 |
|-------|-----|------|------|--------------|
| Sonnet | 89.2% ±0.6 | 90.6% ±2.4 | 76.5% ±2.5 | -14.1 pts |
| Haiku | 85.0% ±1.0 | 84.0% ±1.5 | 73.6% ±2.9 | -10.4 pts |
| GPT-mini | 85.9% ±1.7 | 82.7% ±7.5 | 71.6% ±6.0 | -11.1 pts |

All values are 5-run means ± stddev. T5-answerable questions only (27 questions asked to agents with varying distractor tables).

## Key Findings

1. T5→T10 is flat or slightly up. No degradation at 10 tables.
2. T10→T20 drops 10-14pts across all models. This is the cliff.
3. T20→T40 shows no further drop (but T40 distractors are disconnected - see note below).
4. Bigger views cost 16-43% more tokens per question even on identical queries.
5. T20 Haiku is 3.6x slower at p50 (53s vs 15s) than T5.

## Guidance

Keep semantic views under 10-15 tables. Beyond that, accuracy drops ~12pts and latency increases 3-7x.

## Important Caveats

- T40 distractors are NOT FK-connected to the fact table (unlike T10→T20 tables which are). The "plateau at T40" may reflect that disconnected tables are easy to ignore, not that table count doesn't matter past 20.
- Phase 1-2 results showed "more tables helps" - that was a coverage effect (more tables = more questions answerable), not a quality effect. Phase 3 controls for this by only asking T5-answerable questions.
- The original data generator had correlated FKs (same RANDOM seed). All Phase 3 results use fixed data (v4) with independent columns.

## Setup

- Account: <YOUR_ACCOUNT>
- Database: CORTEX_AGENT_LAB
- 100k sales transactions, dimensions ranging from 3-1000 rows
- Eval: EXECUTE_AI_EVALUATION with answer_correctness metric
- 5 runs per condition for statistical confidence

## File Structure

```
q1/
├── sql/
│   ├── 01_retailcorp_data.sql      (data generation - fixed in v4)
│   ├── 02_semantic_views.sql       (T5/T10/T20 views)
│   ├── 15_reference_sql.sql        (ground truth from executed queries)
│   ├── 19_extended_data.sql        (T40 distractor tables)
│   └── 20_t40_view.sql             (T40 semantic view DDL)
├── yaml/                           (eval configs)
└── results/
    ├── step2_5x_stats_v4.csv       (current results - fixed data)
    ├── step3_latency_proper.csv    (p50/p95 latency)
    └── step2_5x_stats.csv          (old v3 results - broken data, superseded)
```
