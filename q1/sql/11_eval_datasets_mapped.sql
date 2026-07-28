-- 11_eval_datasets_mapped.sql
-- Creates filtered eval datasets that only include questions answerable at each tier
-- This isolates the degradation signal: does adding extra tables HURT accuracy
-- on questions the agent could already answer?

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA EVAL;

-- ============================================
-- T5-ONLY: 27 questions answerable with just 5 tables
-- Run this against T5, T10, T20 agents to see if extra tables cause confusion
-- ============================================

CREATE OR REPLACE TABLE Q1_EVAL_T5_ONLY (
  input_query VARCHAR,
  ground_truth VARIANT
);

INSERT INTO Q1_EVAL_T5_ONLY
SELECT input_query, ground_truth
FROM Q1_TABLE_SCALING_DATASET_V2
WHERE requires_tier = 'T5';

CALL SYSTEM$CREATE_EVALUATION_DATASET(
  'Cortex Agent',
  'CORTEX_AGENT_LAB.EVAL.Q1_EVAL_T5_ONLY',
  'CORTEX_AGENT_LAB.EVAL.Q1_EVAL_T5_ONLY_DS',
  OBJECT_CONSTRUCT(
    'query_text', 'INPUT_QUERY',
    'expected_tools', 'GROUND_TRUTH'
  )
);

-- ============================================
-- T10-ONLY: 14 questions that require T10 tables
-- Run against T10 and T20 agents to see if T20 distractors hurt
-- ============================================

CREATE OR REPLACE TABLE Q1_EVAL_T10_ONLY (
  input_query VARCHAR,
  ground_truth VARIANT
);

INSERT INTO Q1_EVAL_T10_ONLY
SELECT input_query, ground_truth
FROM Q1_TABLE_SCALING_DATASET_V2
WHERE requires_tier = 'T10';

CALL SYSTEM$CREATE_EVALUATION_DATASET(
  'Cortex Agent',
  'CORTEX_AGENT_LAB.EVAL.Q1_EVAL_T10_ONLY',
  'CORTEX_AGENT_LAB.EVAL.Q1_EVAL_T10_ONLY_DS',
  OBJECT_CONSTRUCT(
    'query_text', 'INPUT_QUERY',
    'expected_tools', 'GROUND_TRUTH'
  )
);

-- ============================================
-- T20-ONLY: 9 questions that require T20 tables
-- Run against T20 agent only (baseline for hardest questions)
-- ============================================

CREATE OR REPLACE TABLE Q1_EVAL_T20_ONLY (
  input_query VARCHAR,
  ground_truth VARIANT
);

INSERT INTO Q1_EVAL_T20_ONLY
SELECT input_query, ground_truth
FROM Q1_TABLE_SCALING_DATASET_V2
WHERE requires_tier = 'T20';

CALL SYSTEM$CREATE_EVALUATION_DATASET(
  'Cortex Agent',
  'CORTEX_AGENT_LAB.EVAL.Q1_EVAL_T20_ONLY',
  'CORTEX_AGENT_LAB.EVAL.Q1_EVAL_T20_ONLY_DS',
  OBJECT_CONSTRUCT(
    'query_text', 'INPUT_QUERY',
    'expected_tools', 'GROUND_TRUTH'
  )
);
