# Q1 - Table Scaling Experiment

Tests whether adding more tables to a single semantic view degrades answer quality. Uses a single RetailCorp dataset with nested table tiers (T5, T10, T20, T40) where each tier is a superset of the previous.

## Results

### Phase 1 (10 simple questions)

| Tier | Tables | Core Accuracy | Scope Accuracy |
|------|--------|---------------|----------------|
| T5 | 5 | 100% | 0% (tables unavailable) |
| T10 | 10 | 100% | 60% |
| T20 | 20 | 100% | 100% |

### Phase 2 (50 harder questions)

| Model | T5 | T10 | T20 | Cost (output/M) |
|-------|-----|------|------|-----------------|
| Sonnet | 0.67 | 0.79 | 0.83 | $9.76 |
| Haiku | 0.58 | 0.80 | 0.81 | $3.25 |
| GPT-5-mini | 0.65 | 0.73 | 0.77 | $1.30 |

### Phase 3 - Controlled Degradation Test (27 T5-answerable questions, 5 runs each)

| Model | T5 | T10 | T20 | T40 | Drop (T5 to T20) |
|-------|-----|------|------|------|-------------------|
| Sonnet | 84.4% +/-2.1 | 85.4% +/-3.1 | 70.0% +/-3.1 | 76.8% +/-7.5 | -14.4 pts |
| Haiku | 78.7% +/-2.8 | 79.5% +/-2.7 | 69.1% +/-3.9 | 71.3% +/-4.2 | -9.7 pts |
| GPT-mini | 76.8% +/-4.4 | 74.1% +/-3.5 | 65.7% +/-1.5 | 66.0% +/-2.9 | -11.1 pts |

### Token Cost (avg input tokens per question)

| Tier | Sonnet | Haiku | GPT-mini |
|------|--------|-------|----------|
| T5 | 61,469 | 35,370 | 23,984 |
| T20 | 71,272 | 36,930 | 34,375 |
| T40 | 65,996 | 47,262 | 29,093 |

### Conclusions

- Accuracy cliff happens between T10 and T20 (10-14 pts drop for all models)
- T20 to T40 is flat (degradation plateaus, no further cliff)
- T20 agents burn 16-43% more tokens than T5 on identical questions
- Guidance: split semantic views before ~20 tables

## Run Order

### Phase 1
```
1. sql/00_provision.sql       - creates database, schemas, warehouse
2. sql/01_retailcorp_data.sql - generates all 20 RetailCorp tables
3. sql/02_semantic_views.sql  - creates T5, T10, T20 semantic views
4. sql/03_agents.sql          - creates 3 agents (one per tier)
5. sql/04_eval_dataset.sql    - inserts ground truth + registers dataset
6. Upload YAMLs then sql/05_run_evals.sql
```

### Phase 2
```
1. sql/07_eval_dataset_v2.sql - 50 harder questions
2. sql/08_agents_haiku.sql + sql/09b_agents_gptmini.sql
3. Upload YAMLs then sql/09_run_evals_v2.sql
```

### Phase 3
```
1. sql/15_reference_sql.sql    - fix answer key with real SQL
2. sql/15b_fix_ground_truth.sql - update ground truths with executed values
3. sql/16_rerun_mapped_evals_5x.sql - 5x reruns for error bars
4. sql/18_cost_latency.sql     - token/latency analysis
5. sql/19_extended_data.sql    - generate T40 tables
```

## Dependencies

- Sonnet evals use `Q3_T*_SONNET` agents (from `q3/sql/01_agents_table_scaling.sql`)
- GPT-mini agents: `q1/sql/09b_agents_gptmini.sql`
- Haiku agents: `q1/sql/08_agents_haiku.sql`
