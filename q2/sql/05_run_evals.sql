-- 05_run_evals.sql
-- Execute AI evaluations for each round and retrieve results
-- Account: <YOUR_ACCOUNT>

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;

----------------------------------------------------------------------
-- Upload eval YAML specs to stage
----------------------------------------------------------------------
CREATE STAGE IF NOT EXISTS CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE;

-- PUT the YAML files (run from CLI):
-- snow stage put q1_r1_eval.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE;
-- snow stage put q1_r2_eval.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE;
-- snow stage put q1_r3_eval.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE;
-- snow stage put q1_r4_eval.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE;
-- snow stage put q1_r5_eval.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE;

----------------------------------------------------------------------
-- Run evaluations per round
----------------------------------------------------------------------

-- Round 1: 1 view
CALL SYSTEM$EXECUTE_AI_EVALUATION(
  '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_r1_eval.yaml'
);

-- Round 2: 2 views
CALL SYSTEM$EXECUTE_AI_EVALUATION(
  '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_r2_eval.yaml'
);

-- Round 3: 4 views
CALL SYSTEM$EXECUTE_AI_EVALUATION(
  '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_r3_eval.yaml'
);

-- Round 4: 8 views
CALL SYSTEM$EXECUTE_AI_EVALUATION(
  '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_r4_eval.yaml'
);

-- Round 5: 12 views
CALL SYSTEM$EXECUTE_AI_EVALUATION(
  '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_r5_eval.yaml'
);

----------------------------------------------------------------------
-- Retrieve evaluation results
----------------------------------------------------------------------
SELECT *
FROM TABLE(SYSTEM$GET_AI_EVALUATION_DATA())
WHERE label LIKE 'Q1%'
ORDER BY label, metric_name;

-- Pivot results for comparison
SELECT
    label,
    MAX(CASE WHEN metric_name = 'routing_accuracy' THEN metric_value END) AS routing_accuracy,
    MAX(CASE WHEN metric_name = 'logical_consistency' THEN metric_value END) AS logical_consistency,
    MAX(CASE WHEN metric_name = 'answer_correctness' THEN metric_value END) AS answer_correctness
FROM TABLE(SYSTEM$GET_AI_EVALUATION_DATA())
WHERE label LIKE 'Q1%'
GROUP BY label
ORDER BY label;
