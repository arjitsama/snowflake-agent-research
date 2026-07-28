-- 12_run_mapped_evals.sql
-- Degradation test: Run T5-answerable questions against T5, T10, T20 agents
-- If accuracy DROPS from T5 to T20, extra tables cause confusion
-- If accuracy STAYS FLAT, extra tables are harmless distractors

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- Upload mapped YAMLs first (run from q1/ directory):
-- snow stage copy "yaml/q1_*_t5only.yaml" @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE --overwrite -c SPCS

-- Sonnet: T5-only questions at each tier
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1-mapped-t5-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t5_sonnet_t5only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1-mapped-t10-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t10_sonnet_t5only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1-mapped-t20-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t20_sonnet_t5only.yaml');

-- Haiku: T5-only questions at each tier
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1-mapped-t5-haiku'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t5_haiku_t5only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1-mapped-t10-haiku'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t10_haiku_t5only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1-mapped-t20-haiku'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t20_haiku_t5only.yaml');

-- GPT-mini: T5-only questions at each tier
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1-mapped-t5-gptmini'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t5_gptmini_t5only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1-mapped-t10-gptmini'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t10_gptmini_t5only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q1-mapped-t20-gptmini'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q1_t20_gptmini_t5only.yaml');
