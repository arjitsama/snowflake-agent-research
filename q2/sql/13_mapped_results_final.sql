-- 13_mapped_results_final.sql
-- Final degradation test results for Q2 (Phase 2.5)
-- Controlled test: same V4-answerable questions asked to V4 and V12 agents

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- ============================================
-- Q2: VIEW ROUTING DEGRADATION
-- 19 V4-answerable questions asked to V4 and V12 agents
-- ============================================

-- Results:
-- | Model    | V4 Agent (4 views) | V12 Agent (12 views) | Drop        |
-- |----------|--------------------|--------------------|-------------|
-- | Sonnet   | 78.9%              | 78.9%              | 0 pts       |
-- | Haiku    | 73.7%              | 78.9%              | +5.2 pts    |
-- | GPT-mini | 47.3%              | 57.9%              | +10.6 pts   |

SELECT 'V4_SONNET' AS agent, AVG(EVAL_AGG_SCORE) AS avg_correctness FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q3_V4_SONNET', 'CORTEX AGENT', 'q2-mapped-v4-sonnet')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'V12_SONNET', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q3_V12_SONNET', 'CORTEX AGENT', 'q2-mapped-v12-sonnet')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'V4_HAIKU', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q2_V4_HAIKU', 'CORTEX AGENT', 'q2-mapped-v4-haiku')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'V12_HAIKU', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q2_V12_HAIKU', 'CORTEX AGENT', 'q2-mapped-v12-haiku')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'V4_GPTMINI', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q2_V4_GPTMINI', 'CORTEX AGENT', 'q2-mapped-v4-gptmini')) WHERE METRIC_NAME = 'answer_correctness'
UNION ALL
SELECT 'V12_GPTMINI', AVG(EVAL_AGG_SCORE) FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q2_V12_GPTMINI', 'CORTEX AGENT', 'q2-mapped-v12-gptmini')) WHERE METRIC_NAME = 'answer_correctness'
ORDER BY agent;
