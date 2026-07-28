-- 12_mapped_results.sql
-- Pull degradation test results for Q2
-- Key question: does accuracy DROP when we add 8 more views to questions
-- that were already answerable with just 4 views?

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- SONNET degradation
SELECT 'V4_SONNET' AS agent, AVG(EVAL_AGG_SCORE) AS avg_correctness FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q3_V4_SONNET', 'CORTEX AGENT', 'q2-mapped-v4-sonnet')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'V12_SONNET', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q3_V12_SONNET', 'CORTEX AGENT', 'q2-mapped-v12-sonnet')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
-- HAIKU degradation
SELECT 'V4_HAIKU', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q2_V4_HAIKU', 'CORTEX AGENT', 'q2-mapped-v4-haiku')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'V12_HAIKU', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q2_V12_HAIKU', 'CORTEX AGENT', 'q2-mapped-v12-haiku')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
-- GPTMINI degradation
SELECT 'V4_GPTMINI', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q2_V4_GPTMINI', 'CORTEX AGENT', 'q2-mapped-v4-gptmini')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'V12_GPTMINI', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q2_V12_GPTMINI', 'CORTEX AGENT', 'q2-mapped-v12-gptmini')) WHERE METRIC_NAME = 'answer_correctness'
ORDER BY agent;

-- Expected results interpretation:
-- If V4_SONNET = 0.80 and V12_SONNET = 0.80 -> extra views don't hurt routing
-- If V4_SONNET = 0.80 and V12_SONNET = 0.60 -> extra views confuse routing
-- If V4_SONNET = 0.80 and V12_SONNET = 0.85 -> shouldn't happen (same questions, same tables needed)
