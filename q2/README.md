# Q2 - Multi-View Routing Experiment

Tests whether attaching more semantic views to a single Cortex Agent degrades routing accuracy. Also tests whether a written routing guide improves performance on ambiguous and cross-view questions.

## Results

### Phase 1 (10 simple questions)

| Round | Views | Routing (1-10) | Logical Consistency | Answer Correctness |
|-------|-------|----------------|--------------------|--------------------|
| R1 | 1 | 3.5 | 0.93 | 0.07 |
| R2 | 2 | 4.2 | 0.93 | 0.20 |
| R3 | 4 | 5.1 | 0.87 | 0.37 |
| R4 | 8 | 6.3 | 0.97 | 0.50 |

### Phase 2 (50 harder questions)

| Model | V4 (4 views) | V12 (12 views) | Cost (output/M) |
|-------|--------------|----------------|-----------------|
| Sonnet | 0.59 | 0.77 | $9.76 |
| Haiku | 0.50 | 0.70 | $3.25 |
| GPT-5-mini | 0.43 | 0.47 | $1.30 |

### Phase 3 - Controlled Degradation Test (19 V4-answerable questions, 5 runs each)

| Model | V4 Agent | V12 Agent | Drop |
|-------|----------|-----------|------|
| Sonnet | 84.9% +/-2.0 | 85.3% +/-2.4 | 0 pts |
| Haiku | 81.4% +/-2.7 | 82.1% +/-1.5 | 0 pts |

No degradation from extra views on any model.

### Phase 3 - Routing Guide Experiment (50 questions, 5 runs each)

| Agent | Haiku | Sonnet |
|-------|-------|--------|
| Baseline V12 | 71.7% +/-2.8 | 80.7% +/-1.7 |
| Guided V12 | 75.2% +/-2.6 | 81.2% +/-2.8 |

Per-category (Haiku):
| Category | Baseline | Guided | Improvement |
|----------|----------|--------|-------------|
| ambiguous_hard | 56.7% | 80.0% | +23.3 pts |
| cross_view | 73.3% | 73.3% | 0 pts |
| cross_view_hard | 80.0% | 90.0% | +10 pts |

### Conclusions

- Extra views do NOT hurt routing accuracy (V4 and V12 score the same)
- A routing guide significantly helps ambiguous questions (+23pts)
- Cross-view questions are NOT harmed by the routing guide
- Haiku benefits more from guidance than Sonnet

## Run Order

### Phase 1
```
1. sql/00_provision.sql - creates database, schemas, warehouse
2. sql/01_generate_data.sql - generates 5 dims + 12 fact tables
3. sql/02_semantic_views.sql - creates 12 semantic views
4. sql/03_agents.sql - creates 5 agents (1/2/4/8/12 views)
5. sql/04_eval_dataset.sql + Upload YAMLs + sql/05_run_evals.sql
```

### Phase 2
```
1. sql/06_eval_dataset_v2.sql - 50 harder questions
2. sql/07_agents_v2.sql - haiku/gptmini agents
3. Upload YAMLs then sql/08_run_evals_v2.sql
```

### Phase 3
```
1. sql/14_reference_sql.sql - fix answer key
2. sql/15_rerun_mapped_evals_5x.sql - 5x reruns
3. sql/16_guided_agent.sql - create guided routing agent
```

## Dependencies

- Sonnet evals use `Q3_V*_SONNET` agents (from `q3/sql/02_agents_view_routing.sql`)
- Haiku/GPT-mini agents: `q2/sql/07_agents_v2.sql`
