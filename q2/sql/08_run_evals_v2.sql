-- 08_run_evals_v2.sql
-- Q2 Phase 2: Run evaluations with harder questions + cross-view
-- Compares haiku vs sonnet at V4 and V12

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

CREATE STAGE IF NOT EXISTS CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE;

-- Upload V2 YAML files (run from q2/ directory):
-- snow stage copy "yaml/q2_*_v2.yaml" @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE --overwrite -c SPCS

-- Haiku runs
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2v2-v4-haiku'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_haiku_v2.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2v2-v12-haiku'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_haiku_v2.yaml');

-- Sonnet runs (reuses Q3 sonnet agents)
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2v2-v4-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_sonnet_v2.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2v2-v12-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_sonnet_v2.yaml');
