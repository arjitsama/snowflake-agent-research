# Q3 - Model Sensitivity Experiment

Tests whether different orchestration models (cheap vs. frontier) trade off cost vs. accuracy differently as schema complexity and view count scale up.

## Prerequisites

- Snowflake account with ACCOUNTADMIN (tested on <YOUR_ACCOUNT>)
- Snowflake CLI (`snow`) installed for staging YAML files
- Q1 must be run first (creates RetailCorp data + semantic views)
- Q2 must be run first (creates domain data + 12 semantic views)

## Run Order

Run all SQL from the repo root or adjust paths accordingly.

```
1. sql/00_provision.sql               - creates database/schemas/warehouse (skip if already done by q1/q2)
2. sql/01_agents_table_scaling.sql    - creates 12 agents (4 models x T5/T10/T20)
3. sql/02_agents_view_routing.sql     - creates 12 agents (4 models x 4/8/12 views)
4. Upload YAML configs to stage (run from q3/ directory):
     snow stage put yaml/q3_t5_opus.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_t10_opus.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_t20_opus.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_t5_sonnet.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_t10_sonnet.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_t20_sonnet.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_t5_llama.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_t10_llama.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_t20_llama.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_t5_deepseek.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_t10_deepseek.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_t20_deepseek.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_v4_opus.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_v8_opus.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_v12_opus.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_v4_sonnet.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_v8_sonnet.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_v12_sonnet.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_v4_llama.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_v8_llama.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_v12_llama.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_v4_deepseek.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_v8_deepseek.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
     snow stage put yaml/q3_v12_deepseek.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
5. sql/03_run_evals.sql               - executes all 24 evaluations
6. sql/04_results.sql                 - queries and pivots results by model x condition
```

## Structure

```
q3/
├── README.md
├── q3_experiment_report.md
├── sql/
│   ├── 00_provision.sql
│   ├── 01_agents_table_scaling.sql
│   ├── 02_agents_view_routing.sql
│   ├── 03_run_evals.sql
│   └── 04_results.sql
└── yaml/
    ├── q3_t5_opus.yaml ... q3_t20_deepseek.yaml (12 table-scaling configs)
    └── q3_v4_opus.yaml ... q3_v12_deepseek.yaml (12 view-routing configs)
```

## File Descriptions

**SQL:**
- `00_provision.sql` - shared infrastructure (skip if already provisioned by q1/q2)
- `01_agents_table_scaling.sql` - creates 12 agents for the table-scaling dimension (4 models x T5/T10/T20)
- `02_agents_view_routing.sql` - creates 12 agents for the view-routing dimension (4 models x 4/8/12 views)
- `03_run_evals.sql` - runs EXECUTE_AI_EVALUATION for all 24 agents
- `04_results.sql` - queries results pivoted by model and condition for comparison

**YAML (24 files):**
- `q3_t{N}_{model}.yaml` - eval config for table-scaling (uses Q1's dataset)
- `q3_v{N}_{model}.yaml` - eval config for view-routing (uses Q2's dataset)

## Models

| Model | Role | Notes |
|-------|------|-------|
| claude-opus-4-7 | Frontier | Most expensive, highest capability |
| claude-sonnet-4-6 | Mid-high | Good balance of cost and performance |
| llama3.1-70b | Mid-cheap | Open source, lower cost |
| deepseek-r1 | Cheap | Lowest cost option |

Confirm model availability with `SHOW CORTEX MODELS` before running.

## Notes

- This experiment does NOT create new data or semantic views
- It depends entirely on Q1 (RetailCorp data + views) and Q2 (domain data + views)
- Run Q1 and Q2 fully before starting Q3
- The 24 eval runs may take significant time and token budget
- Results are filtered with `WHERE label LIKE 'Q3%'` so they won't collide with Q1/Q2
