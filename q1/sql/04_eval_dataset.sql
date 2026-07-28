-- Q1 Table Scaling Experiment: Evaluation Dataset + Registration
-- Ground truth answers for 10 test questions (5 core + 5 scope)
-- Core questions are answerable at T5 — extra tables are distractors
-- Scope questions require tables added at T10 or T20

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA EVAL;

CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.EVAL.Q1_TABLE_SCALING_DATASET (
  input_query VARCHAR,
  ground_truth VARIANT
);

INSERT INTO CORTEX_AGENT_LAB.EVAL.Q1_TABLE_SCALING_DATASET
SELECT input_query, PARSE_JSON(ground_truth) FROM (VALUES

-- CORE questions (answerable at T5 — should work identically at all tiers)
('What is total revenue by product type?',
'{"ground_truth_output": "Total revenue by product type: Sports ~$115.2B, Apparel ~$114.3B, Electronics ~$114.0B, Home ~$112.4B. Values should be within 5% of these figures."}'),

('What is total revenue by store region?',
'{"ground_truth_output": "Total revenue by store region: South ~$120.2B, North ~$117.2B, West ~$109.2B, East ~$109.1B. Values should be within 5% of these figures."}'),

('How many transactions were there by customer tier?',
'{"ground_truth_output": "Transactions by customer tier: Standard ~25,248, Silver ~24,944, Gold ~24,914, Bronze ~24,894. Approximately 100,000 total transactions evenly distributed."}'),

('What is the average sale value by store type?',
'{"ground_truth_output": "Average sale value by store type: Mall ~$4.57M, Online ~$4.55M, Standalone ~$4.55M. All three store types are very similar in average sale value."}'),

('What is total revenue by year?',
'{"ground_truth_output": "Total revenue by year: 2022 ~$152.3B, 2023 ~$151.4B, 2024 ~$152.1B. Revenue is stable across all three years around $151-152B per year."}'),

-- SCOPE questions (require tables added at T10)
('What is total revenue by sales rep territory?',
'{"ground_truth_output": "Total revenue by sales rep territory: West ~$115.2B, South ~$114.3B, North ~$114.0B, East ~$112.4B. Should use the sales_reps table territory field, not store region."}'),

('What is the average shipping cost by ship method?',
'{"ground_truth_output": "Average shipping cost by ship method: Air ~$21,138, Express ~$20,772, Ground ~$20,671. Should use shipments table. Air is slightly more expensive than Ground."}'),

('What is the total refund value by return reason?',
'{"ground_truth_output": "Total refund value by return reason: Changed mind ~$5.85B, Defective ~$5.78B, Wrong item ~$5.65B, Other ~$5.64B. Should use returns table."}'),

-- SCOPE questions (require tables added at T20)
('What is total revenue by sales channel?',
'{"ground_truth_output": "Total revenue by sales channel: Phone ~$92.4B, In-Store ~$91.3B, Mobile ~$91.2B, Online ~$90.9B, Partner ~$89.9B. Should use channels table with 5 channels."}'),

('What is total revenue by brand tier?',
'{"ground_truth_output": "Total revenue by brand tier: Standard ~$153.2B, Premium ~$152.4B, Value ~$150.2B. Should use brands table with 3 tiers."}')

) AS t(input_query, ground_truth);

-- Register as formal Snowflake evaluation dataset
CALL SYSTEM$CREATE_EVALUATION_DATASET(
  'Cortex Agent',
  'CORTEX_AGENT_LAB.EVAL.Q1_TABLE_SCALING_DATASET',
  'CORTEX_AGENT_LAB.EVAL.Q1_TABLE_SCALING_DATASET_V1',
  OBJECT_CONSTRUCT(
    'query_text', 'INPUT_QUERY',
    'expected_tools', 'GROUND_TRUTH'
  )
);
