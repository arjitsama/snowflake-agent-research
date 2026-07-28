-- 15_rerun_mapped_evals_5x.sql
-- Step 2: Re-run every mapped degradation eval 5 times for error bars
-- 6 conditions (3 models x 2 view counts) x 5 runs = 30 eval calls
-- Uses V3 dataset (executed ground truth from Step 1)
--
-- Upload updated YAMLs first:
--   PUT 'file:///path/q2/yaml/q2_*_v4only.yaml' @CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- SONNET x V4 (5 runs)
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-sonnet-run1'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_sonnet_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-sonnet-run2'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_sonnet_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-sonnet-run3'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_sonnet_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-sonnet-run4'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_sonnet_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-sonnet-run5'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_sonnet_v4only.yaml');

-- SONNET x V12 (5 runs)
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-sonnet-run1'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_sonnet_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-sonnet-run2'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_sonnet_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-sonnet-run3'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_sonnet_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-sonnet-run4'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_sonnet_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-sonnet-run5'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_sonnet_v4only.yaml');

-- HAIKU x V4 (5 runs)
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-haiku-run1'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_haiku_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-haiku-run2'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_haiku_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-haiku-run3'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_haiku_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-haiku-run4'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_haiku_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-haiku-run5'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_haiku_v4only.yaml');

-- HAIKU x V12 (5 runs)
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-haiku-run1'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_haiku_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-haiku-run2'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_haiku_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-haiku-run3'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_haiku_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-haiku-run4'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_haiku_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-haiku-run5'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_haiku_v4only.yaml');

-- GPTMINI x V4 (5 runs)
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-gptmini-run1'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_gptmini_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-gptmini-run2'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_gptmini_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-gptmini-run3'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_gptmini_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-gptmini-run4'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_gptmini_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v4-gptmini-run5'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v4_gptmini_v4only.yaml');

-- GPTMINI x V12 (5 runs)
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-gptmini-run1'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_gptmini_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-gptmini-run2'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_gptmini_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-gptmini-run3'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_gptmini_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-gptmini-run4'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_gptmini_v4only.yaml');
CALL EXECUTE_AI_EVALUATION('START', OBJECT_CONSTRUCT('run_name', 'q2-v3-v12-gptmini-run5'), '@CORTEX_AGENT_LAB.EVAL.EVAL_CONFIG_STAGE/q2_v12_gptmini_v4only.yaml');
