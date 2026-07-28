-- 10_eval_datasets_mapped.sql
-- Creates filtered eval dataset: only questions answerable with V4 views (Sales, Marketing, CRM, Finance)
-- This isolates the degradation signal: does adding 8 more views HURT accuracy
-- on questions already answerable with just 4 views?

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA EVAL;

-- ============================================
-- V4-ANSWERABLE: Questions that ONLY need Sales, Marketing, CRM, and/or Finance
-- Run against V4 and V12 agents. If V12 scores lower, extra views cause confusion.
-- ============================================

CREATE OR REPLACE TABLE Q2_EVAL_V4_ANSWERABLE (
  input_query VARCHAR,
  ground_truth VARIANT
);

-- Only include questions where target_domain is exclusively within V4 views
INSERT INTO Q2_EVAL_V4_ANSWERABLE
SELECT QUESTION, PARSE_JSON(OBJECT_CONSTRUCT('ground_truth_output', GROUND_TRUTH)::VARCHAR)
FROM Q2_EVAL_DATASET_V2
WHERE target_domain IN (
  'Sales', 'Marketing', 'CRM', 'Finance',
  'Marketing + Sales', 'Marketing + CRM', 'CRM + Sales',
  'Sales + Finance'
);

CALL SYSTEM$CREATE_EVALUATION_DATASET(
  'Cortex Agent',
  'CORTEX_AGENT_LAB.EVAL.Q2_EVAL_V4_ANSWERABLE',
  'CORTEX_AGENT_LAB.EVAL.Q2_EVAL_V4_ANSWERABLE_DS',
  OBJECT_CONSTRUCT(
    'query_text', 'INPUT_QUERY',
    'expected_tools', 'GROUND_TRUTH'
  )
);
