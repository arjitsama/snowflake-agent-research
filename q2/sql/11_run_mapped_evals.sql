-- 11_run_mapped_evals.sql
-- Degradation test: Run V4-answerable questions against V4 and V12 agents
-- If accuracy DROPS from V4 to V12, extra views cause routing confusion
-- If accuracy STAYS FLAT, extra views are harmless

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- Upload mapped YAMLs first (run from q2/ directory):
-- snow stage copy "yaml/q2_*_v4only.yaml" @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE --overwrite -c SPCS

-- Sonnet
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-mapped-v4-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_sonnet_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-mapped-v12-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_sonnet_v4only.yaml');

-- Haiku
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-mapped-v4-haiku'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_haiku_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-mapped-v12-haiku'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_haiku_v4only.yaml');

-- GPT-mini
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-mapped-v4-gptmini'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_gptmini_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-mapped-v12-gptmini'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_gptmini_v4only.yaml');
