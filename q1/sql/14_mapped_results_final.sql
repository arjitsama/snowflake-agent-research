-- 14_mapped_results_final.sql
-- Final degradation test results (Phase 2.5)
-- Controlled test: same questions asked to agents with different amounts of distractor tables/views

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- ============================================
-- Q1: TABLE SCALING DEGRADATION
-- 27 T5-answerable questions asked to T5, T10, T20 agents
-- ============================================

-- Results:
-- | Model    | T5 Agent | T10 Agent | T20 Agent | Drop (T5->T20) |
-- |----------|----------|-----------|-----------|----------------|
-- | Sonnet   | 93.8%    | 90.1%     | 88.9%     | -4.9 pts       |
-- | Haiku    | 82.7%    | 82.7%     | 86.4%     | +3.7 pts       |
-- | GPT-mini | 86.4%    | 83.9%     | 70.3%     | -16.1 pts      |

SELECT 'T5_SONNET' AS agent, AVG(EVAL_AGG_SCORE) AS avg_correctness FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q3_T5_SONNET', 'CORTEX AGENT', 'q1-mapped-t5-sonnet')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'T10_SONNET', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q3_T10_SONNET', 'CORTEX AGENT', 'q1-mapped-t10-sonnet')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'T20_SONNET', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q3_T20_SONNET', 'CORTEX AGENT', 'q1-mapped-t20-sonnet')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'T5_HAIKU', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q1_T5_HAIKU', 'CORTEX AGENT', 'q1-mapped-t5-haiku')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'T10_HAIKU', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q1_T10_HAIKU', 'CORTEX AGENT', 'q1-mapped-t10-haiku')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'T20_HAIKU', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q1_T20_HAIKU', 'CORTEX AGENT', 'q1-mapped-t20-haiku')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'T5_GPTMINI', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q1_T5_GPTMINI', 'CORTEX AGENT', 'q1-mapped-t5-gptmini')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'T10_GPTMINI', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q1_T10_GPTMINI', 'CORTEX AGENT', 'q1-mapped-t10-gptmini')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'T20_GPTMINI', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q1_T20_GPTMINI', 'CORTEX AGENT', 'q1-mapped-t20-gptmini')) WHERE METRIC_NAME = 'answer_correctness'
ORDER BY agent;
