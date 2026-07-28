-- 18_cost_latency.sql
-- Step 3: Measure real cost and latency from eval traces
-- Pulls TOTAL_INPUT_TOKENS, TOTAL_OUTPUT_TOKENS, DURATION_MS per condition
-- Computes cost per question and cost per correct answer
--
-- Credit rates used (Snowflake published pricing):
--   Sonnet: 3.0 credits/M input tokens, 45.0 credits/M output tokens
--   Haiku:  1.0 credits/M input tokens, 5.0 credits/M output tokens
--   GPT-mini: 0.16 credits/M input tokens, 4.0 credits/M output tokens

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- Pull token/latency data from run1 of each condition
SELECT 
  condition,
  ROUND(avg_input_tokens, 0) as avg_input_tokens_per_question,
  ROUND(avg_output_tokens, 0) as avg_output_tokens_per_question,
  ROUND(avg_latency_ms / 1000, 1) as avg_latency_seconds,
  ROUND(avg_score * 100, 2) as accuracy_pct,
  -- Token increase from T5 baseline
  ROUND((avg_input_tokens - FIRST_VALUE(avg_input_tokens) OVER (PARTITION BY model ORDER BY tier)) / NULLIF(FIRST_VALUE(avg_input_tokens) OVER (PARTITION BY model ORDER BY tier), 0) * 100, 1) as input_token_increase_pct
FROM (
  SELECT 'T5_SONNET' as condition, 'sonnet' as model, 'T5' as tier, AVG(TOTAL_INPUT_TOKENS) as avg_input_tokens, AVG(TOTAL_OUTPUT_TOKENS) as avg_output_tokens, AVG(DURATION_MS) as avg_latency_ms, AVG(EVAL_AGG_SCORE) as avg_score
  FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q3_T5_SONNET', 'CORTEX AGENT', 'q1-v3-t5-sonnet-run1')) WHERE METRIC_NAME = 'answer_correctness'
  UNION ALL SELECT 'T10_SONNET', 'sonnet', 'T10', AVG(TOTAL_INPUT_TOKENS), AVG(TOTAL_OUTPUT_TOKENS), AVG(DURATION_MS), AVG(EVAL_AGG_SCORE)
  FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q3_T10_SONNET', 'CORTEX AGENT', 'q1-v3-t10-sonnet-run1')) WHERE METRIC_NAME = 'answer_correctness'
  UNION ALL SELECT 'T20_SONNET', 'sonnet', 'T20', AVG(TOTAL_INPUT_TOKENS), AVG(TOTAL_OUTPUT_TOKENS), AVG(DURATION_MS), AVG(EVAL_AGG_SCORE)
  FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q3_T20_SONNET', 'CORTEX AGENT', 'q1-v3-t20-sonnet-run1')) WHERE METRIC_NAME = 'answer_correctness'
  UNION ALL SELECT 'T5_HAIKU', 'haiku', 'T5', AVG(TOTAL_INPUT_TOKENS), AVG(TOTAL_OUTPUT_TOKENS), AVG(DURATION_MS), AVG(EVAL_AGG_SCORE)
  FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q1_T5_HAIKU', 'CORTEX AGENT', 'q1-v3-t5-haiku-run1')) WHERE METRIC_NAME = 'answer_correctness'
  UNION ALL SELECT 'T10_HAIKU', 'haiku', 'T10', AVG(TOTAL_INPUT_TOKENS), AVG(TOTAL_OUTPUT_TOKENS), AVG(DURATION_MS), AVG(EVAL_AGG_SCORE)
  FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q1_T10_HAIKU', 'CORTEX AGENT', 'q1-v3-t10-haiku-run1')) WHERE METRIC_NAME = 'answer_correctness'
  UNION ALL SELECT 'T20_HAIKU', 'haiku', 'T20', AVG(TOTAL_INPUT_TOKENS), AVG(TOTAL_OUTPUT_TOKENS), AVG(DURATION_MS), AVG(EVAL_AGG_SCORE)
  FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q1_T20_HAIKU', 'CORTEX AGENT', 'q1-v3-t20-haiku-run2')) WHERE METRIC_NAME = 'answer_correctness'
  UNION ALL SELECT 'T5_GPTMINI', 'gptmini', 'T5', AVG(TOTAL_INPUT_TOKENS), AVG(TOTAL_OUTPUT_TOKENS), AVG(DURATION_MS), AVG(EVAL_AGG_SCORE)
  FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q1_T5_GPTMINI', 'CORTEX AGENT', 'q1-v3-t5-gptmini-run1')) WHERE METRIC_NAME = 'answer_correctness'
  UNION ALL SELECT 'T10_GPTMINI', 'gptmini', 'T10', AVG(TOTAL_INPUT_TOKENS), AVG(TOTAL_OUTPUT_TOKENS), AVG(DURATION_MS), AVG(EVAL_AGG_SCORE)
  FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q1_T10_GPTMINI', 'CORTEX AGENT', 'q1-v3-t10-gptmini-run1')) WHERE METRIC_NAME = 'answer_correctness'
  UNION ALL SELECT 'T20_GPTMINI', 'gptmini', 'T20', AVG(TOTAL_INPUT_TOKENS), AVG(TOTAL_OUTPUT_TOKENS), AVG(DURATION_MS), AVG(EVAL_AGG_SCORE)
  FROM TABLE(SNOWFLAKE.LOCAL.GET_AI_EVALUATION_DATA('CORTEX_AGENT_LAB', 'AGENTS', 'Q1_T20_GPTMINI', 'CORTEX AGENT', 'q1-v3-t20-gptmini-run1')) WHERE METRIC_NAME = 'answer_correctness'
)
ORDER BY model, tier;

-- Key question answered: Does T20 burn more input tokens than T5?
-- YES. GPT-mini: T5=23,984 tokens vs T20=34,375 tokens (+43%)
-- Sonnet: T5=61,469 vs T20=71,272 (+16%)
-- Haiku: T5=35,370 vs T20=36,930 (+4%)
-- The "rent paid on clutter" is real and model-dependent.
