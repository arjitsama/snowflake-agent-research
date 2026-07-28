-- 14_reference_sql.sql
-- Step 1 of Neven's work plan: Fix the answer key for Q2
-- Every question gets real SQL, executed against actual data
-- Ground truth generated from query output, not hand-typed
--
-- Table: Q2_EVAL_DATASET_V3 (question_id, input_query, ground_truth, reference_sql, category, target_domain)
-- Registered as: CORTEX_AGENT_LAB.EVAL.Q2_EVAL_DATASET_V3_DS
--
-- Tables used:
--   FACT_ORDERS (order_id, customer_id, product_id, order_date, order_amount, order_status, sales_rep)
--   FACT_CAMPAIGN_EVENTS (event_id, campaign_name, channel, customer_id, event_date, spend, revenue_attributed, converted)
--   FACT_OPPORTUNITIES (opportunity_id, customer_id, stage, sales_rep, created_date, deal_value)
--   FACT_GL_ENTRIES (entry_id, account_type, cost_center, entry_date, vendor, region, amount)
--   FACT_HEADCOUNT (snapshot_id, employee_id, snapshot_date, department, ...)
--   FACT_PAYROLL (payroll_id, employee_id, department, pay_date, gross_pay, ...)
--   FACT_APPLICATIONS (app_id, department, source, status, days_in_pipeline, ...)
--   FACT_SHIPMENTS (shipment_id, product_id, warehouse, supplier, ship_date, region, shipment_cost, quantity)
--   FACT_INVENTORY (inventory_id, product_id, warehouse, snapshot_date, units_on_hand, unit_cost, inventory_value)
--   FACT_TICKETS (ticket_id, customer_id, agent, product_id, created_date, status, resolution_days, priority)
--   FACT_WEB_EVENTS (event_id, session_id, customer_id, page, event_date, converted, time_on_page_seconds)
--   FACT_PURCHASE_ORDERS (po_id, vendor, product_id, cost_center, po_date, po_amount, status)
--   DIM_CUSTOMER (customer_id, customer_code, first_name, last_name, segment, industry, region, created_date, annual_revenue)
--   DIM_PRODUCT (product_id, sku, product_name, category, unit_price, unit_cost)
--   DIM_DATE (date_day, year, month, quarter)
--   DIM_EMPLOYEE (employee_id, employee_code, department, level, region, hire_date, base_salary, is_terminated)
--   DIM_REGION (region_id, region_name, region_head)
--
-- Run this AFTER q2/sql/01_generate_data.sql has populated all tables

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA EVAL;

CREATE OR REPLACE TABLE Q2_EVAL_DATASET_V3 (
  question_id INT,
  input_query VARCHAR,
  ground_truth VARIANT,
  reference_sql VARCHAR,
  category VARCHAR,
  target_domain VARCHAR
);

-- All 50 questions are inserted via batch VALUES + PARSE_JSON
-- See the live table in Snowflake for the full dataset
-- Each question has: reference_sql (executable), ground_truth (from execution), category, target_domain

-- Example Q1 (single_hard, Sales):
-- INSERT INTO Q2_EVAL_DATASET_V3
-- SELECT 1, 'What is the month-over-month growth in total revenue for each region in 2023?',
--   PARSE_JSON('{"ground_truth_output": "East region 2023 MoM growth: Jan-Feb -16.17%, ..."}'),
--   'SELECT c.region, d.month, SUM(o.order_amount) ... FROM FACT_ORDERS o JOIN DIM_CUSTOMER c ...',
--   'single_hard', 'Sales';

-- Full dataset is loaded via the execution session that populated Q2_EVAL_DATASET_V3
-- with 50 questions across categories: single_hard, ambiguous_hard, cross_view, cross_view_hard, stress_test

-- Register dataset
CALL SYSTEM$CREATE_EVALUATION_DATASET(
  'Cortex Agent',
  'CORTEX_AGENT_LAB.EVAL.Q2_EVAL_DATASET_V3',
  'CORTEX_AGENT_LAB.EVAL.Q2_EVAL_DATASET_V3_DS',
  OBJECT_CONSTRUCT(
    'query_text', 'INPUT_QUERY',
    'expected_tools', 'GROUND_TRUTH'
  )
);
