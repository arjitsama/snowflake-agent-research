-- 03_run_evals.sql
-- Q3 Model Sensitivity: Execute evaluations for all 24 agent/model combos
-- Must run from AGENTS schema context

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

CREATE STAGE IF NOT EXISTS CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE;

-- Upload YAML files (run from q3/ directory):
-- snow stage put yaml/q3_t5_opus.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_t10_opus.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_t20_opus.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_t5_sonnet.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_t10_sonnet.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_t20_sonnet.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_t5_llama.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_t10_llama.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_t20_llama.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_t5_deepseek.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_t10_deepseek.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_t20_deepseek.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_v4_opus.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_v8_opus.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_v12_opus.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_v4_sonnet.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_v8_sonnet.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_v12_sonnet.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_v4_llama.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_v8_llama.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_v12_llama.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_v4_deepseek.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_v8_deepseek.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE
-- snow stage put yaml/q3_v12_deepseek.yaml @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE

----------------------------------------------------------------------
-- TABLE SCALING EVALS (4 models x 3 tiers = 12 runs)
----------------------------------------------------------------------

-- Opus
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-t5-opus'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_t5_opus.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-t10-opus'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_t10_opus.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-t20-opus'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_t20_opus.yaml');

-- Sonnet
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-t5-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_t5_sonnet.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-t10-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_t10_sonnet.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-t20-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_t20_sonnet.yaml');

-- Llama
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-t5-llama'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_t5_llama.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-t10-llama'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_t10_llama.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-t20-llama'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_t20_llama.yaml');

-- DeepSeek
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-t5-deepseek'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_t5_deepseek.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-t10-deepseek'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_t10_deepseek.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-t20-deepseek'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_t20_deepseek.yaml');

----------------------------------------------------------------------
-- VIEW ROUTING EVALS (4 models x 3 view counts = 12 runs)
----------------------------------------------------------------------

-- Opus
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-v4-opus'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_v4_opus.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-v8-opus'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_v8_opus.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-v12-opus'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_v12_opus.yaml');

-- Sonnet
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-v4-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_v4_sonnet.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-v8-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_v8_sonnet.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-v12-sonnet'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_v12_sonnet.yaml');

-- Llama
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-v4-llama'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_v4_llama.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-v8-llama'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_v8_llama.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-v12-llama'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_v12_llama.yaml');

-- DeepSeek
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-v4-deepseek'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_v4_deepseek.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-v8-deepseek'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_v8_deepseek.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q3-v12-deepseek'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q3_v12_deepseek.yaml');
