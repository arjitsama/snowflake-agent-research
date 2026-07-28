-- Q1 Table Scaling Experiment: Run Evaluations
-- Execute AI evaluations for each tier agent

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;

-- Create stage for eval configs
CREATE STAGE IF NOT EXISTS CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE;

-- PUT yaml files (run from CLI):
-- snow stage put yaml/q1_t5_eval.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q1_t10_eval.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q1_t20_eval.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE

-- Run T5 evaluation
CALL SYSTEM$EXECUTE_AI_EVALUATION(
  '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t5_eval.yaml'
);

-- Run T10 evaluation
CALL SYSTEM$EXECUTE_AI_EVALUATION(
  '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t10_eval.yaml'
);

-- Run T20 evaluation
CALL SYSTEM$EXECUTE_AI_EVALUATION(
  '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t20_eval.yaml'
);

-- Retrieve results
SELECT *
FROM TABLE(SYSTEM$GET_AI_EVALUATION_DATA())
WHERE label LIKE 'Q1 Table Scaling%'
ORDER BY label, metric_name;

-- Pivot for comparison
SELECT
    label,
    MAX(CASE WHEN metric_name = 'answer_correctness' THEN metric_value END) AS answer_correctness
FROM TABLE(SYSTEM$GET_AI_EVALUATION_DATA())
WHERE label LIKE 'Q1 Table Scaling%'
GROUP BY label
ORDER BY label;
