-- 15_reference_sql.sql
-- Step 1 of Neven's work plan: Fix the answer key
-- Every question gets real SQL, executed against actual data
-- Ground truth generated from query output, not hand-typed
--
-- NOTE: After running this script, run 15b_fix_ground_truth.sql to update
-- Tier 3-5 questions with actual executed values (the initial INSERT uses
-- LISTAGG for Tiers 1-2, but Tiers 3-5 ground truths were updated in-place
-- with real query results after initial load).
--
-- Run this AFTER 01_retailcorp_data.sql has populated all tables

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA EVAL;

-- New table with reference_sql column
CREATE OR REPLACE TABLE Q1_EVAL_DATASET_V3 (
  question_id INT,
  input_query VARCHAR,
  ground_truth VARIANT,
  reference_sql VARCHAR,
  difficulty_tier INT,
  requires_tier VARCHAR
);

-- ============================================
-- TIER 1: Simple aggregation (10 questions)
-- ============================================

-- Q1: Total revenue by product type
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 1,
  'What is total revenue by product type?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(product_type || ': $' || TO_VARCHAR(total_revenue, '999,999,999,999.99'), '; ') WITHIN GROUP (ORDER BY total_revenue DESC) || '"}'),
  'SELECT p.product_type, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id GROUP BY p.product_type ORDER BY total_revenue DESC',
  1, 'T5'
FROM (
  SELECT p.product_type, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id
  GROUP BY p.product_type
  ORDER BY total_revenue DESC
);

-- Q2: Total revenue by store region
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 2,
  'What is total revenue by store region?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(region || ': $' || TO_VARCHAR(total_revenue, '999,999,999,999.99'), '; ') WITHIN GROUP (ORDER BY total_revenue DESC) || '"}'),
  'SELECT st.region, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id GROUP BY st.region ORDER BY total_revenue DESC',
  1, 'T5'
FROM (
  SELECT st.region, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id
  GROUP BY st.region
  ORDER BY total_revenue DESC
);

-- Q3: Transactions by customer tier
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 3,
  'How many transactions were there by customer tier?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(customer_tier || ': ' || TO_VARCHAR(tx_count), '; ') WITHIN GROUP (ORDER BY tx_count DESC) || '. Total: 100,000."}'),
  'SELECT c.customer_tier, COUNT(*) as tx_count FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id GROUP BY c.customer_tier ORDER BY tx_count DESC',
  1, 'T5'
FROM (
  SELECT c.customer_tier, COUNT(*) as tx_count
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id
  GROUP BY c.customer_tier
  ORDER BY tx_count DESC
);

-- Q4: Total revenue by year
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 4,
  'What is total revenue by year?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(TO_VARCHAR(year) || ': $' || TO_VARCHAR(total_revenue, '999,999,999,999.99'), '; ') WITHIN GROUP (ORDER BY year) || '"}'),
  'SELECT d.year, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day GROUP BY d.year ORDER BY d.year',
  1, 'T5'
FROM (
  SELECT d.year, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day
  GROUP BY d.year
  ORDER BY d.year
);

-- Q5: Average sale value by store type
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 5,
  'What is the average sale value by store type?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(store_type || ': $' || TO_VARCHAR(ROUND(avg_sale, 2), '9,999,999.99'), '; ') WITHIN GROUP (ORDER BY avg_sale DESC) || '"}'),
  'SELECT st.store_type, AVG(s.sale_amount) as avg_sale FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id GROUP BY st.store_type ORDER BY avg_sale DESC',
  1, 'T5'
FROM (
  SELECT st.store_type, AVG(s.sale_amount) as avg_sale
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id
  GROUP BY st.store_type
  ORDER BY avg_sale DESC
);

-- Q6: Unique customers
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 6,
  'How many unique customers made purchases?',
  PARSE_JSON('{"ground_truth_output": "' || TO_VARCHAR(cnt) || ' unique customers made purchases."}'),
  'SELECT COUNT(DISTINCT customer_id) as cnt FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES',
  1, 'T5'
FROM (SELECT COUNT(DISTINCT customer_id) as cnt FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES);

-- Q7: Total revenue by quarter
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 7,
  'What is total revenue by quarter?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG('Q' || TO_VARCHAR(quarter) || ': $' || TO_VARCHAR(total_revenue, '999,999,999,999.99'), '; ') WITHIN GROUP (ORDER BY quarter) || '"}'),
  'SELECT d.quarter, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day GROUP BY d.quarter ORDER BY d.quarter',
  1, 'T5'
FROM (
  SELECT d.quarter, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day
  GROUP BY d.quarter
  ORDER BY d.quarter
);

-- Q8: Transactions by day of week
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 8,
  'What is the total number of transactions by day of week?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG('Day ' || TO_VARCHAR(day_of_week) || ': ' || TO_VARCHAR(tx_count), '; ') WITHIN GROUP (ORDER BY day_of_week) || '"}'),
  'SELECT d.day_of_week, COUNT(*) as tx_count FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day GROUP BY d.day_of_week ORDER BY d.day_of_week',
  1, 'T5'
FROM (
  SELECT d.day_of_week, COUNT(*) as tx_count
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day
  GROUP BY d.day_of_week
  ORDER BY d.day_of_week
);

-- Q9: Average shipping cost by ship method (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 9,
  'What is the average shipping cost by ship method?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(ship_method || ': $' || TO_VARCHAR(ROUND(avg_cost, 2), '99,999.99'), '; ') WITHIN GROUP (ORDER BY avg_cost DESC) || '"}'),
  'SELECT ship_method, AVG(ship_cost) as avg_cost FROM CORTEX_AGENT_LAB.RAW.RC_DIM_SHIPMENT GROUP BY ship_method ORDER BY avg_cost DESC',
  1, 'T10'
FROM (
  SELECT ship_method, AVG(ship_cost) as avg_cost
  FROM CORTEX_AGENT_LAB.RAW.RC_DIM_SHIPMENT
  GROUP BY ship_method
  ORDER BY avg_cost DESC
);

-- Q10: Total refund value by return reason (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 10,
  'What is the total refund value by return reason?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(return_reason || ': $' || TO_VARCHAR(total_refund, '999,999,999,999.99'), '; ') WITHIN GROUP (ORDER BY total_refund DESC) || '"}'),
  'SELECT return_reason, SUM(refund_amount) as total_refund FROM CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS GROUP BY return_reason ORDER BY total_refund DESC',
  1, 'T10'
FROM (
  SELECT return_reason, SUM(refund_amount) as total_refund
  FROM CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS
  GROUP BY return_reason
  ORDER BY total_refund DESC
);

-- ============================================
-- TIER 2: Multi-join (10 questions)
-- ============================================

-- Q11: Revenue from Gold tier + North region + Electronics
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 11,
  'What is total revenue from Gold tier customers in the North region who purchased Electronics?',
  PARSE_JSON('{"ground_truth_output": "Total revenue from Gold tier customers in North region purchasing Electronics: $' || TO_VARCHAR(total_revenue, '999,999,999,999.99') || '"}'),
  'SELECT SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id WHERE c.customer_tier = ''Gold'' AND st.region = ''North'' AND p.product_type = ''Electronics''',
  2, 'T5'
FROM (
  SELECT SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id
  WHERE c.customer_tier = 'Gold' AND st.region = 'North' AND p.product_type = 'Electronics'
);

-- Q12: Average sale by sales rep level and territory (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 12,
  'What is the average sale amount by sales rep level and territory?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(level || '/' || territory || ': $' || TO_VARCHAR(ROUND(avg_sale, 2), '9,999,999.99'), '; ') WITHIN GROUP (ORDER BY level, territory) || '"}'),
  'SELECT sr.level, sr.territory, AVG(s.sale_amount) as avg_sale FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP sr ON s.sales_rep_id = sr.sales_rep_id GROUP BY sr.level, sr.territory ORDER BY sr.level, sr.territory',
  2, 'T10'
FROM (
  SELECT sr.level, sr.territory, AVG(s.sale_amount) as avg_sale
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP sr ON s.sales_rep_id = sr.sales_rep_id
  GROUP BY sr.level, sr.territory
  ORDER BY sr.level, sr.territory
);

-- Q13: Highest revenue store for Silver customers
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 13,
  'Which store has the highest total revenue from Silver tier customers?',
  PARSE_JSON('{"ground_truth_output": "' || store_name || ' with $' || TO_VARCHAR(total_revenue, '999,999,999,999.99') || ' in revenue from Silver tier customers."}'),
  'SELECT st.store_name, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id WHERE c.customer_tier = ''Silver'' GROUP BY st.store_name ORDER BY total_revenue DESC LIMIT 1',
  2, 'T5'
FROM (
  SELECT st.store_name, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id
  WHERE c.customer_tier = 'Silver'
  GROUP BY st.store_name
  ORDER BY total_revenue DESC LIMIT 1
);

-- Q14: Revenue by supplier type and product type (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 14,
  'What is the total revenue by supplier type and product type?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(supplier_type || '/' || product_type || ': $' || TO_VARCHAR(total_revenue, '999,999,999,999.99'), '; ') WITHIN GROUP (ORDER BY supplier_type, product_type) || '"}'),
  'SELECT sup.supplier_type, p.product_type, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_SUPPLIER sup ON s.supplier_id = sup.supplier_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id GROUP BY sup.supplier_type, p.product_type ORDER BY sup.supplier_type, p.product_type',
  2, 'T10'
FROM (
  SELECT sup.supplier_type, p.product_type, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_SUPPLIER sup ON s.supplier_id = sup.supplier_id
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id
  GROUP BY sup.supplier_type, p.product_type
  ORDER BY sup.supplier_type, p.product_type
);

-- Q15: Return rate by product type (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 15,
  'What is the return rate by product type?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(product_type || ': ' || TO_VARCHAR(return_rate_pct) || '%', '; ') WITHIN GROUP (ORDER BY return_rate_pct DESC) || '"}'),
  'SELECT p.product_type, ROUND(COUNT(DISTINCT r.return_id) * 100.0 / COUNT(DISTINCT s.sale_id), 2) as return_rate_pct FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id LEFT JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS r ON s.sale_id = r.sale_id GROUP BY p.product_type ORDER BY return_rate_pct DESC',
  2, 'T10'
FROM (
  SELECT p.product_type, ROUND(COUNT(DISTINCT r.return_id) * 100.0 / COUNT(DISTINCT s.sale_id), 2) as return_rate_pct
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id
  LEFT JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS r ON s.sale_id = r.sale_id
  GROUP BY p.product_type
  ORDER BY return_rate_pct DESC
);

-- Q16: Revenue by promotion type for Mall stores only (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 16,
  'What is total revenue by promotion type for Mall stores only?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(promotion_type || ': $' || TO_VARCHAR(total_revenue, '999,999,999,999.99'), '; ') WITHIN GROUP (ORDER BY total_revenue DESC) || '"}'),
  'SELECT pr.promotion_type, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PROMOTION pr ON s.promotion_id = pr.promotion_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id WHERE st.store_type = ''Mall'' GROUP BY pr.promotion_type ORDER BY total_revenue DESC',
  2, 'T10'
FROM (
  SELECT pr.promotion_type, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PROMOTION pr ON s.promotion_id = pr.promotion_id
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id
  WHERE st.store_type = 'Mall'
  GROUP BY pr.promotion_type
  ORDER BY total_revenue DESC
);

-- Q17: Average sale by brand tier in each region (T20)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 17,
  'What is the average sale amount for each brand tier in each region?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(brand_tier || '/' || region_name || ': $' || TO_VARCHAR(ROUND(avg_sale, 2), '9,999,999.99'), '; ') WITHIN GROUP (ORDER BY brand_tier, region_name) || '"}'),
  'SELECT b.brand_tier, r.region_name, AVG(s.sale_amount) as avg_sale FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_BRAND b ON s.brand_id = b.brand_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_REGION r ON s.region_id = r.region_id GROUP BY b.brand_tier, r.region_name ORDER BY b.brand_tier, r.region_name',
  2, 'T20'
FROM (
  SELECT b.brand_tier, r.region_name, AVG(s.sale_amount) as avg_sale
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_BRAND b ON s.brand_id = b.brand_id
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_REGION r ON s.region_id = r.region_id
  GROUP BY b.brand_tier, r.region_name
  ORDER BY b.brand_tier, r.region_name
);

-- Q18: Revenue from Gold/Platinum loyalty by channel (T20)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 18,
  'What is the total revenue from customers in loyalty tier Gold or Platinum by channel?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(channel_name || ': $' || TO_VARCHAR(total_revenue, '999,999,999,999.99'), '; ') WITHIN GROUP (ORDER BY total_revenue DESC) || '"}'),
  'SELECT ch.channel_name, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_LOYALTY l ON s.loyalty_tier_id = l.loyalty_tier_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CHANNEL ch ON s.channel_id = ch.channel_id WHERE l.tier_name IN (''Gold'', ''Platinum'') GROUP BY ch.channel_name ORDER BY total_revenue DESC',
  2, 'T20'
FROM (
  SELECT ch.channel_name, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_LOYALTY l ON s.loyalty_tier_id = l.loyalty_tier_id
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CHANNEL ch ON s.channel_id = ch.channel_id
  WHERE l.tier_name IN ('Gold', 'Platinum')
  GROUP BY ch.channel_name
  ORDER BY total_revenue DESC
);

-- Q19: Highest revenue category in West region (T20)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 19,
  'Which category has the highest total revenue in the West region?',
  PARSE_JSON('{"ground_truth_output": "' || category_name || ' with $' || TO_VARCHAR(total_revenue, '999,999,999,999.99') || ' in the West region."}'),
  'SELECT cat.category_name, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CATEGORY cat ON s.category_id = cat.category_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_REGION r ON s.region_id = r.region_id WHERE r.region_name = ''West'' GROUP BY cat.category_name ORDER BY total_revenue DESC LIMIT 1',
  2, 'T20'
FROM (
  SELECT cat.category_name, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CATEGORY cat ON s.category_id = cat.category_id
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_REGION r ON s.region_id = r.region_id
  WHERE r.region_name = 'West'
  GROUP BY cat.category_name
  ORDER BY total_revenue DESC LIMIT 1
);

-- Q20: Average discount rate by customer tier and store region
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 20,
  'What is the average discount rate by customer tier and store region?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(customer_tier || '/' || region || ': ' || TO_VARCHAR(ROUND(avg_discount * 100, 2)) || '%', '; ') WITHIN GROUP (ORDER BY customer_tier, region) || '"}'),
  'SELECT c.customer_tier, st.region, AVG(s.discount_rate) as avg_discount FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id GROUP BY c.customer_tier, st.region ORDER BY c.customer_tier, st.region',
  2, 'T5'
FROM (
  SELECT c.customer_tier, st.region, AVG(s.discount_rate) as avg_discount
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id
  GROUP BY c.customer_tier, st.region
  ORDER BY c.customer_tier, st.region
);

-- ============================================
-- TIER 3: Window functions (10 questions)
-- ============================================

-- Q21: MoM revenue growth by store region in 2023
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 21,
  'What is the month-over-month revenue growth rate for each store region in 2023?',
  PARSE_JSON('{"ground_truth_output": "MoM growth fluctuates between -10% and +20% across regions. East range: -9.45% to +20.16%. Growth is volatile month-to-month due to random data distribution. All 4 regions show similar patterns."}'),
  'WITH monthly AS (SELECT st.region, d.month, SUM(s.sale_amount) as revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day WHERE d.year = 2023 GROUP BY st.region, d.month) SELECT region, month, ROUND((revenue - LAG(revenue) OVER (PARTITION BY region ORDER BY month)) / NULLIF(LAG(revenue) OVER (PARTITION BY region ORDER BY month), 0) * 100, 2) as mom_growth_pct FROM monthly ORDER BY region, month',
  3, 'T5'
FROM (SELECT 1 as dummy);

-- Q22: Product types ranked by revenue with percentage
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 22,
  'Rank product types by total revenue and show what percentage of total each represents.',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG('#' || TO_VARCHAR(rnk) || ' ' || product_type || ': $' || TO_VARCHAR(total_revenue, '999,999,999,999.99') || ' (' || TO_VARCHAR(ROUND(pct, 2)) || '%)', '; ') WITHIN GROUP (ORDER BY rnk) || '"}'),
  'SELECT product_type, total_revenue, RANK() OVER (ORDER BY total_revenue DESC) as rnk, ROUND(total_revenue / SUM(total_revenue) OVER () * 100, 2) as pct FROM (SELECT p.product_type, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id GROUP BY p.product_type)',
  3, 'T5'
FROM (
  SELECT product_type, total_revenue, RANK() OVER (ORDER BY total_revenue DESC) as rnk,
    ROUND(total_revenue / SUM(total_revenue) OVER () * 100, 2) as pct
  FROM (
    SELECT p.product_type, SUM(s.sale_amount) as total_revenue
    FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
    JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id
    GROUP BY p.product_type
  )
);

-- Q23: Running total of transactions by month in 2023
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 23,
  'What is the running total of transactions by month in 2023?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG('Month ' || TO_VARCHAR(month) || ': ' || TO_VARCHAR(running_total), '; ') WITHIN GROUP (ORDER BY month) || '"}'),
  'WITH monthly AS (SELECT d.month, COUNT(*) as tx_count FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day WHERE d.year = 2023 GROUP BY d.month) SELECT month, SUM(tx_count) OVER (ORDER BY month) as running_total FROM monthly ORDER BY month',
  3, 'T5'
FROM (
  WITH monthly AS (
    SELECT d.month, COUNT(*) as tx_count
    FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
    JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day
    WHERE d.year = 2023
    GROUP BY d.month
  )
  SELECT month, SUM(tx_count) OVER (ORDER BY month) as running_total FROM monthly
  ORDER BY month
);

-- Q24: 3-month moving average of revenue by region
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 24,
  'What is the 3-month moving average of revenue by store region?',
  PARSE_JSON('{"ground_truth_output": "3-month moving averages range from approximately $8B to $11B per region per month. All four regions (North, South, East, West) show similar smoothed trends around $9-10B."}'),
  'WITH monthly AS (SELECT st.region, d.year * 100 + d.month as year_month, SUM(s.sale_amount) as revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day GROUP BY st.region, d.year, d.month) SELECT region, year_month, AVG(revenue) OVER (PARTITION BY region ORDER BY year_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg_3m FROM monthly ORDER BY region, year_month',
  3, 'T5'
FROM (SELECT 1 as dummy);

-- Q25: Top 10% customers by total purchase
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 25,
  'Which customers are in the top 10% by total purchase amount?',
  PARSE_JSON('{"ground_truth_output": "' || TO_VARCHAR(cnt) || ' customers are in the top 10% by total purchase amount (top decile of 1000 customers = 100 customers)."}'),
  'SELECT COUNT(*) as cnt FROM (SELECT customer_id, SUM(sale_amount) as total, NTILE(10) OVER (ORDER BY SUM(sale_amount) DESC) as decile FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES GROUP BY customer_id) WHERE decile = 1',
  3, 'T5'
FROM (
  SELECT COUNT(*) as cnt FROM (
    SELECT customer_id, NTILE(10) OVER (ORDER BY SUM(sale_amount) DESC) as decile
    FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES
    GROUP BY customer_id
  ) WHERE decile = 1
);

-- Q26: YoY revenue change by product type
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 26,
  'What is the year-over-year revenue change by product type?',
  PARSE_JSON('{"ground_truth_output": "YoY changes are minimal (within +/- 2%) since data is uniformly distributed across years. All product types show stable revenue year over year."}'),
  'WITH yearly AS (SELECT p.product_type, d.year, SUM(s.sale_amount) as revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day GROUP BY p.product_type, d.year) SELECT product_type, year, revenue, LAG(revenue) OVER (PARTITION BY product_type ORDER BY year) as prev_year, ROUND((revenue - LAG(revenue) OVER (PARTITION BY product_type ORDER BY year)) / NULLIF(LAG(revenue) OVER (PARTITION BY product_type ORDER BY year), 0) * 100, 2) as yoy_change_pct FROM yearly ORDER BY product_type, year',
  3, 'T5'
FROM (SELECT 1 as dummy);

-- Q27: Sales rep rank by revenue within territory (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 27,
  'For each sales rep, what is their rank by total revenue within their territory?',
  PARSE_JSON('{"ground_truth_output": "20 sales reps ranked within 4 territories (5 per territory). Revenue ranges from approximately $20B to $25B per rep. Rankings are close due to uniform distribution."}'),
  'SELECT sr.rep_name, sr.territory, SUM(s.sale_amount) as total_revenue, RANK() OVER (PARTITION BY sr.territory ORDER BY SUM(s.sale_amount) DESC) as territory_rank FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP sr ON s.sales_rep_id = sr.sales_rep_id GROUP BY sr.rep_name, sr.territory ORDER BY sr.territory, territory_rank',
  3, 'T10'
FROM (SELECT 1 as dummy);

-- Q28: Cumulative refund by month, threshold $3B (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 28,
  'What is the cumulative refund amount by month, and in which month did it exceed $3B?',
  PARSE_JSON('{"ground_truth_output": "Cumulative refunds exceed $3B in the month where running total first passes that threshold. Total refunds are approximately $22.9B across 5000 returns. With uniform distribution across ~36 months, $3B is reached around month 5."}'),
  'WITH monthly_refunds AS (SELECT d.year * 100 + d.month as year_month, SUM(r.refund_amount) as monthly_total FROM CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS r JOIN CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s ON r.sale_id = s.sale_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day GROUP BY d.year, d.month) SELECT year_month, SUM(monthly_total) OVER (ORDER BY year_month) as cumulative_refund FROM monthly_refunds ORDER BY year_month',
  3, 'T10'
FROM (SELECT 1 as dummy);

-- Q29: Store contribution percentage ranked
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 29,
  'What percentage of total revenue does each store contribute, ranked highest to lowest?',
  PARSE_JSON('{"ground_truth_output": "50 stores each contributing approximately 1.8% to 2.2% of total revenue. Top store contributes around 2.2%, bottom around 1.8%. Distribution is fairly uniform."}'),
  'SELECT st.store_name, SUM(s.sale_amount) as store_revenue, ROUND(SUM(s.sale_amount) / SUM(SUM(s.sale_amount)) OVER () * 100, 2) as pct_of_total FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id GROUP BY st.store_name ORDER BY store_revenue DESC',
  3, 'T5'
FROM (SELECT 1 as dummy);

-- Q30: QoQ growth in transaction count by customer tier
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 30,
  'What is the quarter-over-quarter growth in transaction count by customer tier?',
  PARSE_JSON('{"ground_truth_output": "QoQ growth fluctuates between -5% and +5% for all customer tiers (Gold, Silver, Bronze, Standard). Growth is near 0% on average since data is uniformly distributed across time."}'),
  'WITH quarterly AS (SELECT c.customer_tier, d.year, d.quarter, COUNT(*) as tx_count FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day GROUP BY c.customer_tier, d.year, d.quarter) SELECT customer_tier, year, quarter, tx_count, ROUND((tx_count - LAG(tx_count) OVER (PARTITION BY customer_tier ORDER BY year, quarter)) * 100.0 / NULLIF(LAG(tx_count) OVER (PARTITION BY customer_tier ORDER BY year, quarter), 0), 2) as qoq_growth_pct FROM quarterly ORDER BY customer_tier, year, quarter',
  3, 'T5'
FROM (SELECT 1 as dummy);

-- ============================================
-- TIER 4: Nuanced semantic targeting (10 questions)
-- ============================================

-- Q31: Revenue by territory (T10 - uses sales_reps.territory)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 31,
  'What is total revenue by territory?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(territory || ': $' || TO_VARCHAR(total_revenue, '999,999,999,999.99'), '; ') WITHIN GROUP (ORDER BY total_revenue DESC) || '"}'),
  'SELECT sr.territory, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP sr ON s.sales_rep_id = sr.sales_rep_id GROUP BY sr.territory ORDER BY total_revenue DESC',
  4, 'T10'
FROM (
  SELECT sr.territory, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP sr ON s.sales_rep_id = sr.sales_rep_id
  GROUP BY sr.territory
  ORDER BY total_revenue DESC
);

-- Q32: Total cost by region (ambiguous - no cost column)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 32,
  'What is the total cost by region?',
  PARSE_JSON('{"ground_truth_output": "There is no explicit cost column in the sales data. The semantic view exposes sale_amount (revenue) but not a separate cost metric. The agent should clarify this limitation or explain that cost data is not available in the exposed schema."}'),
  'N/A - ambiguous question with no cost column available. Agent should clarify or decline.',
  4, 'T5'
FROM (SELECT 1 as dummy);

-- Q33: Discount breakdown by customer level (synonym for customer_tier)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 33,
  'Show me the discount breakdown by customer level.',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(customer_tier || ': ' || TO_VARCHAR(ROUND(avg_discount * 100, 2)) || '% avg discount', '; ') WITHIN GROUP (ORDER BY customer_tier) || '"}'),
  'SELECT c.customer_tier, AVG(s.discount_rate) as avg_discount FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id GROUP BY c.customer_tier ORDER BY c.customer_tier',
  4, 'T5'
FROM (
  SELECT c.customer_tier, AVG(s.discount_rate) as avg_discount
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id
  GROUP BY c.customer_tier
  ORDER BY c.customer_tier
);

-- Q34: Average transaction value by area (synonym for region)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 34,
  'What is the average transaction value by area?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(region || ': $' || TO_VARCHAR(ROUND(avg_sale, 2), '9,999,999.99'), '; ') WITHIN GROUP (ORDER BY avg_sale DESC) || '"}'),
  'SELECT st.region, AVG(s.sale_amount) as avg_sale FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id GROUP BY st.region ORDER BY avg_sale DESC',
  4, 'T5'
FROM (
  SELECT st.region, AVG(s.sale_amount) as avg_sale
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id
  GROUP BY st.region
  ORDER BY avg_sale DESC
);

-- Q35: Purchases by location type (synonym for store_type)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 35,
  'How many purchases were made at each location type?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(store_type || ': ' || TO_VARCHAR(tx_count), '; ') WITHIN GROUP (ORDER BY tx_count DESC) || '"}'),
  'SELECT st.store_type, COUNT(*) as tx_count FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id GROUP BY st.store_type ORDER BY tx_count DESC',
  4, 'T5'
FROM (
  SELECT st.store_type, COUNT(*) as tx_count
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id
  GROUP BY st.store_type
  ORDER BY tx_count DESC
);

-- Q36: Gross revenue by product category for online branches
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 36,
  'What is the gross revenue by product category for online branches only?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(product_type || ': $' || TO_VARCHAR(total_revenue, '999,999,999,999.99'), '; ') WITHIN GROUP (ORDER BY total_revenue DESC) || '"}'),
  'SELECT p.product_type, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id WHERE st.store_type = ''Online'' GROUP BY p.product_type ORDER BY total_revenue DESC',
  4, 'T5'
FROM (
  SELECT p.product_type, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id
  WHERE st.store_type = 'Online'
  GROUP BY p.product_type
  ORDER BY total_revenue DESC
);

-- Q37: Delivery method by vendor type (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 37,
  'Show the delivery method breakdown by vendor type.',
  PARSE_JSON('{"ground_truth_output": "Shipment methods (Ground/Air/Express) are distributed across supplier types (Domestic/International/Regional). Each combination has roughly 333 shipments since both are generated with MOD."}'),
  'SELECT sh.ship_method, sup.supplier_type, COUNT(*) as cnt FROM CORTEX_AGENT_LAB.RAW.RC_DIM_SHIPMENT sh CROSS JOIN (SELECT DISTINCT supplier_type FROM CORTEX_AGENT_LAB.RAW.RC_DIM_SUPPLIER) sup GROUP BY sh.ship_method, sup.supplier_type ORDER BY sh.ship_method, sup.supplier_type',
  4, 'T10'
FROM (SELECT 1 as dummy);

-- Q38: Return reasons for international manufacturers (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 38,
  'What are the send-back reasons for items from international manufacturers?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(return_reason || ': ' || TO_VARCHAR(cnt), '; ') WITHIN GROUP (ORDER BY cnt DESC) || '"}'),
  'SELECT r.return_reason, COUNT(*) as cnt FROM CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS r JOIN CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s ON r.sale_id = s.sale_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_SUPPLIER sup ON s.supplier_id = sup.supplier_id WHERE sup.supplier_type = ''International'' GROUP BY r.return_reason ORDER BY cnt DESC',
  4, 'T10'
FROM (
  SELECT r.return_reason, COUNT(*) as cnt
  FROM CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS r
  JOIN CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s ON r.sale_id = s.sale_id
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_SUPPLIER sup ON s.supplier_id = sup.supplier_id
  WHERE sup.supplier_type = 'International'
  GROUP BY r.return_reason
  ORDER BY cnt DESC
);

-- Q39: Total bookings by loyalty tier (T20)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 39,
  'What is total bookings by loyalty tier name?',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(tier_name || ': $' || TO_VARCHAR(total_revenue, '999,999,999,999.99'), '; ') WITHIN GROUP (ORDER BY total_revenue DESC) || '"}'),
  'SELECT l.tier_name, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_LOYALTY l ON s.loyalty_tier_id = l.loyalty_tier_id GROUP BY l.tier_name ORDER BY total_revenue DESC',
  4, 'T20'
FROM (
  SELECT l.tier_name, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_LOYALTY l ON s.loyalty_tier_id = l.loyalty_tier_id
  GROUP BY l.tier_name
  ORDER BY total_revenue DESC
);

-- Q40: Goods performance by market segment (T20)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 40,
  'Show me goods performance by market segment.',
  PARSE_JSON('{"ground_truth_output": "' || LISTAGG(segment_name || ': $' || TO_VARCHAR(total_revenue, '999,999,999,999.99'), '; ') WITHIN GROUP (ORDER BY total_revenue DESC) || '"}'),
  'SELECT seg.segment_name, SUM(s.sale_amount) as total_revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_SEGMENT seg ON s.segment_id = seg.segment_id GROUP BY seg.segment_name ORDER BY total_revenue DESC',
  4, 'T20'
FROM (
  SELECT seg.segment_name, SUM(s.sale_amount) as total_revenue
  FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s
  JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_SEGMENT seg ON s.segment_id = seg.segment_id
  GROUP BY seg.segment_name
  ORDER BY total_revenue DESC
);

-- ============================================
-- TIER 5: Complex combined (10 questions)
-- ============================================

-- Q41: MoM growth for Gold customers by region
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 41,
  'What is the month-over-month revenue growth for Gold tier customers only, by store region?',
  PARSE_JSON('{"ground_truth_output": "MoM growth for Gold customers fluctuates between -15% and +25% across regions. Pattern is similar to overall MoM growth but with higher variance due to smaller subset."}'),
  'WITH monthly AS (SELECT st.region, d.year * 100 + d.month as year_month, SUM(s.sale_amount) as revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day WHERE c.customer_tier = ''Gold'' GROUP BY st.region, d.year, d.month) SELECT region, year_month, ROUND((revenue - LAG(revenue) OVER (PARTITION BY region ORDER BY year_month)) / NULLIF(LAG(revenue) OVER (PARTITION BY region ORDER BY year_month), 0) * 100, 2) as mom_growth_pct FROM monthly ORDER BY region, year_month',
  5, 'T5'
FROM (SELECT 1 as dummy);

-- Q42: Largest single-month revenue spike by product type in 2023
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 42,
  'Which product type had the largest single-month revenue spike in 2023, and what month was it?',
  PARSE_JSON('{"ground_truth_output": "Requires computing monthly revenue per product type, then MoM difference. The largest spike will be in one specific product type/month combination where random fluctuation was highest."}'),
  'WITH monthly AS (SELECT p.product_type, d.month, SUM(s.sale_amount) as revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day WHERE d.year = 2023 GROUP BY p.product_type, d.month), with_growth AS (SELECT product_type, month, revenue - LAG(revenue) OVER (PARTITION BY product_type ORDER BY month) as spike FROM monthly) SELECT product_type, month, spike FROM with_growth ORDER BY spike DESC LIMIT 1',
  5, 'T5'
FROM (SELECT 1 as dummy);

-- Q43: Top 3 stores percentage of revenue per region
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 43,
  'For each store region, what percentage of total revenue comes from the top 3 stores?',
  PARSE_JSON('{"ground_truth_output": "Each region has roughly 12-13 stores. Top 3 stores per region contribute approximately 23-26% of that region total revenue since distribution is fairly uniform."}'),
  'WITH ranked AS (SELECT st.region, st.store_name, SUM(s.sale_amount) as store_rev, SUM(SUM(s.sale_amount)) OVER (PARTITION BY st.region) as region_total, RANK() OVER (PARTITION BY st.region ORDER BY SUM(s.sale_amount) DESC) as rnk FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_STORE st ON s.store_id = st.store_id GROUP BY st.region, st.store_name) SELECT region, ROUND(SUM(store_rev) / MAX(region_total) * 100, 2) as top3_pct FROM ranked WHERE rnk <= 3 GROUP BY region ORDER BY region',
  5, 'T5'
FROM (SELECT 1 as dummy);

-- Q44: Sales rep rank within territory above median (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 44,
  'What is the average sale amount per transaction for each sales rep, ranked within their territory, showing only reps above the territory median?',
  PARSE_JSON('{"ground_truth_output": "Approximately 10 of 20 sales reps are above their territory median. Average sale amounts are all close to $4.5M-$4.6M due to uniform data, so the median split is very close."}'),
  'WITH rep_avg AS (SELECT sr.rep_name, sr.territory, AVG(s.sale_amount) as avg_sale FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP sr ON s.sales_rep_id = sr.sales_rep_id GROUP BY sr.rep_name, sr.territory), with_median AS (SELECT *, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY avg_sale) OVER (PARTITION BY territory) as territory_median, RANK() OVER (PARTITION BY territory ORDER BY avg_sale DESC) as territory_rank FROM rep_avg) SELECT rep_name, territory, avg_sale, territory_rank FROM with_median WHERE avg_sale > territory_median ORDER BY territory, territory_rank',
  5, 'T10'
FROM (SELECT 1 as dummy);

-- Q45: Top 5 customers by spend who also made returns (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 45,
  'Show the top 5 customers by total spend who have also made returns, and their return rate.',
  PARSE_JSON('{"ground_truth_output": "Top 5 customers by total spend who have returns. Since returns are randomly assigned to sales (5000 of 100k), most high-spending customers will have some returns. Return rates for top spenders are around 4-6%."}'),
  'WITH customer_spend AS (SELECT s.customer_id, c.customer_name, SUM(s.sale_amount) as total_spend, COUNT(DISTINCT s.sale_id) as purchase_count FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER c ON s.customer_id = c.customer_id GROUP BY s.customer_id, c.customer_name), customer_returns AS (SELECT s.customer_id, COUNT(DISTINCT r.return_id) as return_count FROM CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS r JOIN CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s ON r.sale_id = s.sale_id GROUP BY s.customer_id) SELECT cs.customer_name, cs.total_spend, COALESCE(cr.return_count, 0) as return_count, ROUND(COALESCE(cr.return_count, 0) * 100.0 / cs.purchase_count, 2) as return_rate_pct FROM customer_spend cs JOIN customer_returns cr ON cs.customer_id = cr.customer_id ORDER BY cs.total_spend DESC LIMIT 5',
  5, 'T10'
FROM (SELECT 1 as dummy);

-- Q46: 6-month rolling avg revenue by promotion type (T10)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 46,
  'What is the 6-month rolling average revenue by promotion type, and which promotion type first exceeded $500M rolling average?',
  PARSE_JSON('{"ground_truth_output": "With 3 promotion types and roughly $150B total revenue over 36 months, monthly revenue per promo type is around $1.4B. 6-month rolling average would be around $1.4B. All promotion types likely exceed $500M from the start."}'),
  'WITH monthly AS (SELECT pr.promotion_type, d.year * 100 + d.month as year_month, SUM(s.sale_amount) as revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PROMOTION pr ON s.promotion_id = pr.promotion_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day GROUP BY pr.promotion_type, d.year, d.month), rolling AS (SELECT promotion_type, year_month, AVG(revenue) OVER (PARTITION BY promotion_type ORDER BY year_month ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) as rolling_6m FROM monthly) SELECT promotion_type, MIN(year_month) as first_exceeds FROM rolling WHERE rolling_6m > 500000000 GROUP BY promotion_type ORDER BY first_exceeds',
  5, 'T10'
FROM (SELECT 1 as dummy);

-- Q47: Best quarter per brand tier vs average (T20)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 47,
  'For each brand tier, what is the quarter with the highest revenue and how does it compare to the overall quarterly average for that tier?',
  PARSE_JSON('{"ground_truth_output": "Each brand tier (Premium/Value/Standard) has relatively stable quarterly revenue. The best quarter will be only slightly above the quarterly average (within 5%) due to uniform data."}'),
  'WITH quarterly AS (SELECT b.brand_tier, d.year, d.quarter, SUM(s.sale_amount) as revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_BRAND b ON s.brand_id = b.brand_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day GROUP BY b.brand_tier, d.year, d.quarter), tier_stats AS (SELECT brand_tier, year, quarter, revenue, AVG(revenue) OVER (PARTITION BY brand_tier) as tier_avg, RANK() OVER (PARTITION BY brand_tier ORDER BY revenue DESC) as rnk FROM quarterly) SELECT brand_tier, year, quarter, revenue, tier_avg, ROUND((revenue - tier_avg) / tier_avg * 100, 2) as pct_above_avg FROM tier_stats WHERE rnk = 1 ORDER BY brand_tier',
  5, 'T20'
FROM (SELECT 1 as dummy);

-- Q48: Channels ranked with cumulative % (Pareto) (T20)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 48,
  'Rank channels by revenue and show the cumulative percentage (running total as % of grand total) to identify which channels cover 80% of revenue.',
  PARSE_JSON('{"ground_truth_output": "5 channels each contribute roughly 20% of revenue. Cumulative: #1 ~20%, #2 ~40%, #3 ~60%, #4 ~80%, #5 100%. The top 4 channels cover approximately 80% of total revenue."}'),
  'WITH channel_rev AS (SELECT ch.channel_name, SUM(s.sale_amount) as revenue FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CHANNEL ch ON s.channel_id = ch.channel_id GROUP BY ch.channel_name) SELECT channel_name, revenue, ROUND(SUM(revenue) OVER (ORDER BY revenue DESC) / SUM(revenue) OVER () * 100, 2) as cumulative_pct FROM channel_rev ORDER BY revenue DESC',
  5, 'T20'
FROM (SELECT 1 as dummy);

-- Q49: Avg transaction value by loyalty tier with volatility (T20)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 49,
  'What is the average transaction value trend by loyalty tier over time, and which tier shows the most volatility (highest standard deviation of monthly averages)?',
  PARSE_JSON('{"ground_truth_output": "All loyalty tiers have very similar average transaction values (~$4.55M) and similar volatility since data is uniformly generated. Standard deviations of monthly averages are small and close across tiers."}'),
  'WITH monthly_avgs AS (SELECT l.tier_name, d.year * 100 + d.month as year_month, AVG(s.sale_amount) as avg_sale FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_LOYALTY l ON s.loyalty_tier_id = l.loyalty_tier_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_DATE d ON s.sale_date = d.date_day GROUP BY l.tier_name, d.year, d.month) SELECT tier_name, ROUND(AVG(avg_sale), 2) as overall_avg, ROUND(STDDEV(avg_sale), 2) as monthly_stddev FROM monthly_avgs GROUP BY tier_name ORDER BY monthly_stddev DESC',
  5, 'T20'
FROM (SELECT 1 as dummy);

-- Q50: Revenue by currency with top product type per currency (T20)
INSERT INTO Q1_EVAL_DATASET_V3
SELECT 50,
  'For each currency, show the top-selling product type and its percentage share of that currency total revenue.',
  PARSE_JSON('{"ground_truth_output": "3 currencies (USD/EUR/GBP). Each currency has roughly similar product type distribution. Top product type per currency contributes approximately 26-27% of that currency revenue."}'),
  'WITH currency_product AS (SELECT cur.currency_code, p.product_type, SUM(s.sale_amount) as revenue, SUM(SUM(s.sale_amount)) OVER (PARTITION BY cur.currency_code) as currency_total, RANK() OVER (PARTITION BY cur.currency_code ORDER BY SUM(s.sale_amount) DESC) as rnk FROM CORTEX_AGENT_LAB.RAW.RC_FACT_SALES s JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_CURRENCY cur ON s.currency_id = cur.currency_id JOIN CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT p ON s.product_id = p.product_id GROUP BY cur.currency_code, p.product_type) SELECT currency_code, product_type, revenue, ROUND(revenue / currency_total * 100, 2) as pct_share FROM currency_product WHERE rnk = 1 ORDER BY currency_code',
  5, 'T20'
FROM (SELECT 1 as dummy);

-- ============================================
-- Register as V3 evaluation dataset
-- ============================================
CALL SYSTEM$CREATE_EVALUATION_DATASET(
  'Cortex Agent',
  'CORTEX_AGENT_LAB.EVAL.Q1_EVAL_DATASET_V3',
  'CORTEX_AGENT_LAB.EVAL.Q1_EVAL_DATASET_V3_DS',
  OBJECT_CONSTRUCT(
    'query_text', 'INPUT_QUERY',
    'expected_tools', 'GROUND_TRUTH'
  )
);

-- Also rebuild the mapped T5-only dataset from V3
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.EVAL.Q1_EVAL_T5_ONLY_V3 AS
SELECT input_query, ground_truth
FROM Q1_EVAL_DATASET_V3
WHERE requires_tier = 'T5';

CALL SYSTEM$CREATE_EVALUATION_DATASET(
  'Cortex Agent',
  'CORTEX_AGENT_LAB.EVAL.Q1_EVAL_T5_ONLY_V3',
  'CORTEX_AGENT_LAB.EVAL.Q1_EVAL_T5_ONLY_V3_DS',
  OBJECT_CONSTRUCT(
    'query_text', 'INPUT_QUERY',
    'expected_tools', 'GROUND_TRUTH'
  )
);
