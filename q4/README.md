# Q4 - Architecture Comparison

Tests whether splitting 20 tables into 4 topic views performs better than keeping one big view.

## Results

Same 50 questions, same 20 tables, two architectures:

| Question Type | One Big View | Four Topic Views + Guide | Winner |
|---|---|---|---|
| Single-topic (27 questions) | 67.8% | 77.8% | Topic views +10pts |
| Multi-topic (23 questions) | 72.5% | 60.9% | Big view +12pts |
| Overall | ~72% | ~71% | Tie |

### Conclusions

- Splitting views helps focused single-topic questions (less clutter per view)
- Splitting views hurts cross-domain questions (agent struggles to combine multiple views)
- Overall accuracy is the same either way
- Choose based on your question mix: mostly single-domain = split, mostly cross-domain = keep one view

## Setup

Four topic views grouping the 20 RetailCorp tables:
- `RETAILCORP_CORE_SALES` (customers, products, stores, dates)
- `RETAILCORP_LOGISTICS` (suppliers, shipments, returns)
- `RETAILCORP_PROMOTIONS` (promotions, channels, segments, categories)
- `RETAILCORP_GEO_ORG` (regions, brands, currencies, loyalty, sales reps)

## Run Order

```
1. sql/01_topic_views.sql - creates 4 topic semantic views
2. sql/02_agents.sql      - creates topic-view agents (Sonnet + Haiku)
3. Upload YAMLs to stage
4. Run evals (5x each for big view and topic views)
```

## Dependencies

- Reuses Q1's data (nothing in q1/ is modified)
- Big view baseline uses existing `Q3_T20_SONNET` / `Q1_T20_HAIKU` agents
- Uses `Q1_EVAL_DATASET_V3` (50 questions with executed ground truth from Step 1)
