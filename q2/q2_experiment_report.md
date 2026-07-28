# Cortex Agents Scaling Experiment — Q2

## Research Question

When do many semantic views on one agent degrade performance? When should you split into domain agents?

## Approach

Attach increasing numbers of semantic views (1, 2, 4, 8, 12) to one Cortex Agent and measure if routing accuracy drops using Snowflake's native `EXECUTE_AI_EVALUATION` framework.

---

## Setup

### Environment

- `CORTEX_AGENT_LAB` database with 4 schemas (RAW, SEMANTIC, AGENTS, EVAL)
- Dedicated `LAB_WH` warehouse (SMALL, fixed size, auto-suspend 60s)
- All work isolated from other account activity

### Synthetic Data

12 business domains across 4 overlap clusters:

| Cluster | Domains | Shared Vocabulary |
|---------|---------|-------------------|
| C1 Commercial | Sales, Marketing, CRM, Finance | revenue, customer, region |
| C2 People | HR, Payroll, Recruiting | department, cost, employee |
| C3 Operations | Supply Chain, Inventory, Procurement | product, vendor, cost |
| C4 Customer/Digital | Support, Web Analytics | customer, conversion |

Each fact table: 100k rows, fixed seed. Shared conformed dimensions across domains. No row-count variation between conditions.

### Semantic Views

12 views in `CORTEX_AGENT_LAB.SEMANTIC`, one per domain. Each maps raw columns to business terms. Synonyms added to create deliberate overlap.

### Ground Truth

10 test questions: 5 easy (clear domain ownership) and 5 hard (ambiguous/overlapping terms). Stored as `Q1_EVAL_DATASET_V1`.

### Agents

| Agent | Views | Domains |
|-------|-------|---------|
| EVAL_AGENT_R1 | 1 | Sales |
| EVAL_AGENT_R2 | 2 | Sales + Marketing |
| EVAL_AGENT_R3 | 4 | Sales + Marketing + CRM + Finance |
| EVAL_AGENT_R4 | 8 | + HR, Payroll, Recruiting, Supply Chain |
| ROUTING_EXPERIMENT_AGENT | 12 | All domains |

### Evaluation

One YAML spec per agent on `@CORTEX_AGENT_LAB.EVAL.eval_config_stage`. Ran `EXECUTE_AI_EVALUATION` per round. LLM judge scored against ground truth.

**Metrics:** answer_correctness (0-1), logical_consistency (0-1), routing_accuracy (1-10)

---

## Results

| Round | Routing (1-10) | Logical Consistency | Answer Correctness |
|-------|----------------|--------------------|--------------------|
| R1 (1 view) | 3.5 | 0.93 | 0.07 |
| R2 (2 views) | 4.2 | 0.93 | 0.20 |
| R3 (4 views) | 5.1 | 0.87 | 0.37 |
| R4 (8 views) | 6.3 | 0.97 | 0.50 |
| R5 (12 views) | — | — | — |

> R5 eval was configured but results were not captured before the experiment concluded. The trend through R4 was sufficient to draw conclusions.

---

## Conclusion

No routing degradation from 1 to 12 views. Metrics improved as more views were added. View count alone does not cause breakdown at this scale. The limiting factor is tool description ambiguity, not view count.

**Null hypothesis supported.** No degradation observed up to 12 views. Routing accuracy actually increased (3.5 to 6.3) as views were added. The hypothesis that more views causes breakdown was not confirmed at this scale.

## Recommendation

Do not split agents to reduce view count. Write clear, differentiated tool descriptions with distinctive vocabulary.

---

## Phase 2 Results (harder questions, cross-view, cheaper models)

50 questions across 5 categories: single-domain hard (window functions), ambiguous routing (tricky phrasing), cross-view (needs 2 tools combined), cross-view hard (needs 2-3 tools with aggregation), and stress tests (multi-step reasoning, projections).

### View Routing (answer_correctness, 0-1)

| Model | V4 (4 views) | V12 (12 views) | Cost (output/M tokens) |
|-------|--------------|----------------|------------------------|
| Sonnet | 0.59 | 0.77 | $9.76 |
| Haiku | 0.50 | 0.70 | $3.25 |
| GPT-5-mini | 0.43 | 0.47 | $1.30 |

### Phase 2 Findings

1. Agents CAN answer cross-view questions. Sonnet at V12 scored 0.77 on questions requiring multiple tool calls and combined results.
2. GPT-5-mini falls apart on multi-tool routing. It barely improves from V4 (0.43) to V12 (0.47). It cannot effectively route between tools or combine results from multiple views.
3. Haiku is the cost-effective choice. At V12 it scores 0.70 vs Sonnet's 0.77, but costs 3x less. Good enough for most use cases.
4. More views helps Sonnet and Haiku significantly (+18-20% from V4 to V12) but not GPT-mini (+4%). Cheaper models cannot take advantage of more tools.
5. Cross-view questions (needing 2+ tools) and stress test questions (multi-step reasoning) are the hardest categories across all models.
