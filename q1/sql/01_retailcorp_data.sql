-- Q1 Table Scaling Experiment: RetailCorp Synthetic Data (20 tables)
-- A single "RetailCorp" domain with nested supersets: T5 ⊂ T10 ⊂ T20
-- Per design doc §5 (Exp A wide schema)

USE WAREHOUSE LAB_WH;

-- ============================================
-- T5 CORE TABLES (5 tables)
-- These are the foundation — all questions at every tier use these
-- ============================================

-- FACT: Sales transactions (core fact table at every tier)
-- FIX: Use UNIFORM with distinct seeds per column to ensure independence.
-- Old code used RANDOM(100) for every column — same seed in same row = same value,
-- so all FKs were correlated (each customer always mapped to 1 product, 1 store, etc.)
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_FACT_SALES AS
SELECT
  SEQ4() + 1 AS sale_id,
  UNIFORM(1, 1000, RANDOM(101))::INT AS customer_id,
  UNIFORM(1, 500, RANDOM(102))::INT AS product_id,
  DATEADD(DAY, UNIFORM(0, 1095, RANDOM(103))::INT, '2022-01-01') AS sale_date,
  UNIFORM(1, 50, RANDOM(104))::INT AS store_id,
  ROUND(UNIFORM(10.00, 500.00, RANDOM(105))::NUMBER(10,2), 2) AS sale_amount,
  UNIFORM(1, 20, RANDOM(106))::INT AS sales_rep_id,
  ROUND(UNIFORM(0.00, 0.30, RANDOM(107))::NUMBER(5,2), 2) AS discount_rate,
  UNIFORM(1, 10, RANDOM(108))::INT AS promotion_id,
  UNIFORM(1, 100, RANDOM(109))::INT AS supplier_id,
  UNIFORM(1, 5, RANDOM(110))::INT AS channel_id,
  UNIFORM(1, 8, RANDOM(111))::INT AS segment_id,
  UNIFORM(1, 20, RANDOM(112))::INT AS category_id,
  UNIFORM(1, 30, RANDOM(113))::INT AS brand_id,
  UNIFORM(1, 4, RANDOM(114))::INT AS region_id,
  UNIFORM(1, 3, RANDOM(115))::INT AS currency_id,
  UNIFORM(1, 5, RANDOM(116))::INT AS loyalty_tier_id,
  UNIFORM(1, 50, RANDOM(117))::INT AS employee_id
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- DIM: Customers
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER AS
SELECT
  SEQ4() + 1 AS customer_id,
  'Customer_' || (SEQ4() + 1) AS customer_name,
  CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Gold' WHEN 1 THEN 'Silver' WHEN 2 THEN 'Bronze' ELSE 'Standard' END AS customer_tier,
  CASE MOD(SEQ4(), 3) WHEN 0 THEN 'New York' WHEN 1 THEN 'LA' ELSE 'Chicago' END AS city
FROM TABLE(GENERATOR(ROWCOUNT => 1000));

-- DIM: Products
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT AS
SELECT
  SEQ4() + 1 AS product_id,
  'Product_' || (SEQ4() + 1) AS product_name,
  CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Electronics' WHEN 1 THEN 'Apparel' WHEN 2 THEN 'Home' ELSE 'Sports' END AS product_type,
  ROUND(UNIFORM(10.00, 500.00, RANDOM(201))::NUMBER(10,2), 2) AS unit_price
FROM TABLE(GENERATOR(ROWCOUNT => 500));

-- DIM: Date (2022-2024)
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_DATE AS
SELECT
  DATEADD(DAY, SEQ4(), '2022-01-01') AS date_day,
  YEAR(DATEADD(DAY, SEQ4(), '2022-01-01'))    AS year,
  MONTH(DATEADD(DAY, SEQ4(), '2022-01-01'))   AS month,
  QUARTER(DATEADD(DAY, SEQ4(), '2022-01-01')) AS quarter,
  DAYOFWEEK(DATEADD(DAY, SEQ4(), '2022-01-01')) AS day_of_week
FROM TABLE(GENERATOR(ROWCOUNT => 1096));

-- DIM: Stores
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_STORE AS
SELECT
  SEQ4() + 1 AS store_id,
  'Store_' || (SEQ4() + 1) AS store_name,
  CASE MOD(SEQ4(), 4) WHEN 0 THEN 'North' WHEN 1 THEN 'South' WHEN 2 THEN 'East' ELSE 'West' END AS region,
  CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Mall' WHEN 1 THEN 'Standalone' ELSE 'Online' END AS store_type
FROM TABLE(GENERATOR(ROWCOUNT => 50));

-- ============================================
-- T10 ADDITIONAL TABLES (adds 5 more)
-- ============================================

-- DIM: Promotions
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_PROMOTION AS
SELECT
  SEQ4() + 1 AS promotion_id,
  'Promo_' || (SEQ4() + 1) AS promotion_name,
  CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Discount' WHEN 1 THEN 'BOGO' ELSE 'Clearance' END AS promotion_type,
  ROUND(UNIFORM(0.05, 0.45, RANDOM(202))::NUMBER(5,2), 2) AS discount_pct
FROM TABLE(GENERATOR(ROWCOUNT => 10));

-- DIM: Sales Reps
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP AS
SELECT
  SEQ4() + 1 AS sales_rep_id,
  'Rep_' || (SEQ4() + 1) AS rep_name,
  CASE MOD(SEQ4(), 4) WHEN 0 THEN 'North' WHEN 1 THEN 'South' WHEN 2 THEN 'East' ELSE 'West' END AS territory,
  CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Senior' WHEN 1 THEN 'Mid' ELSE 'Junior' END AS level
FROM TABLE(GENERATOR(ROWCOUNT => 20));

-- DIM: Suppliers
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_SUPPLIER AS
SELECT
  SEQ4() + 1 AS supplier_id,
  'Supplier_' || (SEQ4() + 1) AS supplier_name,
  CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Domestic' WHEN 1 THEN 'International' ELSE 'Regional' END AS supplier_type,
  CASE MOD(SEQ4(), 4) WHEN 0 THEN 'North' WHEN 1 THEN 'South' WHEN 2 THEN 'East' ELSE 'West' END AS region
FROM TABLE(GENERATOR(ROWCOUNT => 100));

-- DIM: Shipments
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_SHIPMENT AS
SELECT
  SEQ4() + 1 AS shipment_id,
  CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Ground' WHEN 1 THEN 'Air' ELSE 'Express' END AS ship_method,
  MOD(SEQ4(), 7) + 1 AS transit_days,
  ROUND(UNIFORM(5.00, 50.00, RANDOM(203))::NUMBER(10,2), 2) AS ship_cost
FROM TABLE(GENERATOR(ROWCOUNT => 1000));

-- DIM: Returns
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS AS
SELECT
  SEQ4() + 1 AS return_id,
  UNIFORM(1, 100000, RANDOM(204))::INT AS sale_id,
  CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Defective' WHEN 1 THEN 'Wrong item' WHEN 2 THEN 'Changed mind' ELSE 'Other' END AS return_reason,
  ROUND(UNIFORM(10.00, 500.00, RANDOM(205))::NUMBER(10,2), 2) AS refund_amount
FROM TABLE(GENERATOR(ROWCOUNT => 5000));

-- ============================================
-- T20 ADDITIONAL TABLES (adds 10 more)
-- ============================================

-- DIM: Inventory
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_INVENTORY AS
SELECT
  SEQ4() + 1 AS inventory_id,
  UNIFORM(1, 500, RANDOM(206))::INT AS product_id,
  UNIFORM(1, 50, RANDOM(207))::INT AS store_id,
  UNIFORM(1, 500, RANDOM(208))::INT AS units_on_hand,
  ROUND(UNIFORM(10.00, 500.00, RANDOM(209))::NUMBER(10,2), 2) AS reorder_cost
FROM TABLE(GENERATOR(ROWCOUNT => 5000));

-- DIM: Channels
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_CHANNEL AS
SELECT
  SEQ4() + 1 AS channel_id,
  CASE SEQ4() WHEN 0 THEN 'In-Store' WHEN 1 THEN 'Online' WHEN 2 THEN 'Mobile' WHEN 3 THEN 'Phone' ELSE 'Partner' END AS channel_name
FROM TABLE(GENERATOR(ROWCOUNT => 5));

-- DIM: Segments
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_SEGMENT AS
SELECT
  SEQ4() + 1 AS segment_id,
  CASE SEQ4() WHEN 0 THEN 'Budget' WHEN 1 THEN 'Mid-Range' WHEN 2 THEN 'Premium' WHEN 3 THEN 'Luxury' WHEN 4 THEN 'Wholesale' WHEN 5 THEN 'B2B' WHEN 6 THEN 'Government' ELSE 'Non-Profit' END AS segment_name
FROM TABLE(GENERATOR(ROWCOUNT => 8));

-- DIM: Categories
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_CATEGORY AS
SELECT
  SEQ4() + 1 AS category_id,
  'Category_' || (SEQ4() + 1) AS category_name,
  CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Electronics' WHEN 1 THEN 'Apparel' WHEN 2 THEN 'Home' ELSE 'Sports' END AS department
FROM TABLE(GENERATOR(ROWCOUNT => 20));

-- DIM: Brands
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_BRAND AS
SELECT
  SEQ4() + 1 AS brand_id,
  'Brand_' || (SEQ4() + 1) AS brand_name,
  CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Premium' WHEN 1 THEN 'Value' ELSE 'Standard' END AS brand_tier
FROM TABLE(GENERATOR(ROWCOUNT => 30));

-- DIM: Regions
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_REGION AS
SELECT
  SEQ4() + 1 AS region_id,
  CASE SEQ4() WHEN 0 THEN 'North' WHEN 1 THEN 'South' WHEN 2 THEN 'East' ELSE 'West' END AS region_name
FROM TABLE(GENERATOR(ROWCOUNT => 4));

-- DIM: Currencies
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_CURRENCY AS
SELECT
  SEQ4() + 1 AS currency_id,
  CASE SEQ4() WHEN 0 THEN 'USD' WHEN 1 THEN 'EUR' ELSE 'GBP' END AS currency_code,
  CASE SEQ4() WHEN 0 THEN 1.0 WHEN 1 THEN 0.92 ELSE 0.79 END AS exchange_rate
FROM TABLE(GENERATOR(ROWCOUNT => 3));

-- DIM: Tax
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_TAX AS
SELECT
  SEQ4() + 1 AS tax_id,
  CASE MOD(SEQ4(), 4) WHEN 0 THEN 'North' WHEN 1 THEN 'South' WHEN 2 THEN 'East' ELSE 'West' END AS region,
  ROUND(MOD(SEQ4(), 10) * 0.01 + 0.05, 2) AS tax_rate
FROM TABLE(GENERATOR(ROWCOUNT => 4));

-- DIM: Loyalty Tiers
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_LOYALTY AS
SELECT
  SEQ4() + 1 AS loyalty_tier_id,
  CASE SEQ4() WHEN 0 THEN 'Bronze' WHEN 1 THEN 'Silver' WHEN 2 THEN 'Gold' WHEN 3 THEN 'Platinum' ELSE 'Diamond' END AS tier_name,
  MOD(SEQ4(), 5) * 500 AS points_required
FROM TABLE(GENERATOR(ROWCOUNT => 5));

-- DIM: Employees
CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.RAW.RC_DIM_EMPLOYEE AS
SELECT
  SEQ4() + 1 AS employee_id,
  'Employee_' || (SEQ4() + 1) AS employee_name,
  CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Full-Time' WHEN 1 THEN 'Part-Time' ELSE 'Contractor' END AS employment_type,
  MOD(SEQ4(), 50) + 1 AS store_id
FROM TABLE(GENERATOR(ROWCOUNT => 50));
