-- 09_run_evals_v2.sql
-- Q1 Phase 2: Run evaluations with harder questions (V2 dataset)
-- Compares haiku (cheapest) vs sonnet across T5/T10/T20

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

CREATE STAGE IF NOT EXISTS CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE;

-- Upload V2 YAML files (run from q1/ directory):
-- snow stage copy "yaml/q1_*_v2.yaml" @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE --overwrite -c SPCS

-- Haiku runs
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1v2-t5-haiku'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t5_haiku_v2.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1v2-t10-haiku'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t10_haiku_v2.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1v2-t20-haiku'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t20_haiku_v2.yaml');

-- Sonnet runs (reuses Q3 sonnet agents since they're identical)
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1v2-t5-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t5_sonnet_v2.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1v2-t10-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t10_sonnet_v2.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1v2-t20-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t20_sonnet_v2.yaml');
