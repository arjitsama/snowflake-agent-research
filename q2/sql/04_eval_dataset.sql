-- 04_eval_dataset.sql
-- Create ground truth evaluation dataset with 10 questions (5 easy + 5 hard)
-- Account: <YOUR_ACCOUNT>

USE WAREHOUSE LAB_WH;
USE SCHEMA CORTEX_AGENT_LAB.EVAL;

-- Create evaluation dataset table
CREATE OR REPLACE TABLE Q1_EVAL_DATASET (
    question_id INT,
    question STRING,
    ground_truth STRING,
    difficulty STRING,
    target_domain STRING
);

INSERT INTO Q1_EVAL_DATASET VALUES
-- Easy questions (clear single-domain ownership)
(1,
 'What is the total revenue from Enterprise customers in the North region?',
 'Query FACT_ORDERS joined with DIM_CUSTOMER filtering segment=Enterprise and region=North, summing revenue. Expected: ~$250M range.',
 'easy',
 'Sales'),

(2,
 'How many support tickets were opened with Critical priority in 2023?',
 'Query FACT_TICKETS filtering priority=Critical and year=2023, counting ticket_id. Expected: ~4,000-5,000 tickets.',
 'easy',
 'Support'),

(3,
 'What is the average time to hire by department?',
 'Query FACT_APPLICATIONS grouped by department, averaging days_in_pipeline. Expected: 25-35 days average.',
 'easy',
 'Recruiting'),

(4,
 'Show total inventory on hand by warehouse.',
 'Query FACT_INVENTORY grouped by warehouse, summing quantity_on_hand. Expected: ~50M units per warehouse.',
 'easy',
 'Inventory'),

(5,
 'What is the total gross pay by department for Q1 2023?',
 'Query FACT_PAYROLL joined with DIM_DATE filtering quarter=1 and year=2023, grouped by department, summing gross_pay.',
 'easy',
 'Payroll'),

-- Hard questions (ambiguous / overlapping terminology)
(6,
 'What is the total cost by region?',
 'Ambiguous: could be FACT_ORDERS.cost (Sales), FACT_GL_ENTRIES debits (Finance), or FACT_SHIPMENTS.shipping_cost (Supply Chain). Best answer uses Sales or Finance depending on context.',
 'hard',
 'Sales/Finance'),

(7,
 'Show me customer conversion metrics.',
 'Ambiguous: could be FACT_CAMPAIGN_EVENTS conversions (Marketing), FACT_WEB_EVENTS.converted (Web Analytics), or FACT_OPPORTUNITIES stage=Closed Won (CRM). Best answer combines or clarifies.',
 'hard',
 'Marketing/Web Analytics'),

(8,
 'What are the department costs trending over time?',
 'Ambiguous: could be FACT_GL_ENTRIES by cost_center (Finance), FACT_PAYROLL by department (Payroll), or FACT_HEADCOUNT salary by department (HR). Best answer uses Finance GL data.',
 'hard',
 'Finance/Payroll/HR'),

(9,
 'How are our vendors performing this quarter?',
 'Ambiguous: could be FACT_PURCHASE_ORDERS status/delivery (Procurement) or FACT_SHIPMENTS status (Supply Chain). Best answer uses Procurement PO data.',
 'hard',
 'Procurement/Supply Chain'),

(10,
 'What is our customer engagement by channel?',
 'Ambiguous: could be FACT_CAMPAIGN_EVENTS by channel (Marketing), FACT_WEB_EVENTS by traffic_source (Web Analytics), or FACT_ORDERS by channel (Sales). Best answer uses Marketing.',
 'hard',
 'Marketing/Web Analytics/Sales');

-- Register as evaluation dataset
CALL SYSTEM$CREATE_EVALUATION_DATASET(
  'Q1_EVAL_DATASET_V1',
  'CORTEX_AGENT_LAB.EVAL.Q1_EVAL_DATASET',
  'question',
  'ground_truth'
);

-- Also create a plain dataset reference (used by R5 eval)
CALL SYSTEM$CREATE_EVALUATION_DATASET(
  'Q1_PLAIN_DS',
  'CORTEX_AGENT_LAB.EVAL.Q1_EVAL_DATASET',
  'question',
  'ground_truth'
);
