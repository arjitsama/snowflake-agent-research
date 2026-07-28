-- 01_generate_data.sql
-- Generate synthetic data: 5 shared dimensions + 12 fact tables
-- All tables in CORTEX_AGENT_LAB.RAW, fixed seeds for reproducibility

USE WAREHOUSE LAB_WH;
USE SCHEMA CORTEX_AGENT_LAB.RAW;

----------------------------------------------------------------------
-- SHARED DIMENSIONS
----------------------------------------------------------------------

-- DIM_CUSTOMER (1000 rows)
CREATE OR REPLACE TABLE DIM_CUSTOMER AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS customer_id,
    'CUST-' || LPAD(ROW_NUMBER() OVER (ORDER BY SEQ4()), 6, '0') AS customer_code,
    ARRAY_CONSTRUCT('Alice','Bob','Carol','David','Eve','Frank','Grace','Heidi','Ivan','Judy')
        [MOD(SEQ4(), 10)]::STRING AS first_name,
    ARRAY_CONSTRUCT('Smith','Johnson','Williams','Brown','Jones','Garcia','Miller','Davis','Rodriguez','Martinez')
        [MOD(SEQ4(), 10)]::STRING AS last_name,
    ARRAY_CONSTRUCT('Enterprise','Mid-Market','SMB','Startup','Government')
        [MOD(SEQ4(), 5)]::STRING AS segment,
    ARRAY_CONSTRUCT('Technology','Healthcare','Finance','Retail','Manufacturing','Education','Media','Energy')
        [MOD(SEQ4(), 8)]::STRING AS industry,
    ARRAY_CONSTRUCT('North','South','East','West')
        [MOD(SEQ4(), 4)]::STRING AS region,
    DATEADD(DAY, -MOD(SEQ4(), 1095), '2024-12-01'::DATE) AS created_date,
    ROUND(UNIFORM(1000, 500000, RANDOM(42))::NUMBER, 2) AS annual_revenue
FROM TABLE(GENERATOR(ROWCOUNT => 1000));

-- DIM_PRODUCT (500 rows)
CREATE OR REPLACE TABLE DIM_PRODUCT AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS product_id,
    'PROD-' || LPAD(ROW_NUMBER() OVER (ORDER BY SEQ4()), 5, '0') AS sku,
    ARRAY_CONSTRUCT('Widget','Gadget','Module','Platform','Service','License','Add-on','Suite')
        [MOD(SEQ4(), 8)]::STRING || ' ' ||
    ARRAY_CONSTRUCT('Pro','Basic','Enterprise','Standard','Premium','Lite','Ultra','Max')
        [MOD(FLOOR(SEQ4()/8), 8)]::STRING AS product_name,
    ARRAY_CONSTRUCT('Software','Hardware','Services','Subscriptions','Support')
        [MOD(SEQ4(), 5)]::STRING AS category,
    ROUND(UNIFORM(10, 5000, RANDOM(43))::NUMBER, 2) AS unit_price,
    ROUND(UNIFORM(2, 2500, RANDOM(44))::NUMBER, 2) AS unit_cost
FROM TABLE(GENERATOR(ROWCOUNT => 500));

-- DIM_DATE (1096 rows = 3 years)
CREATE OR REPLACE TABLE DIM_DATE AS
SELECT
    DATEADD(DAY, SEQ4(), '2022-01-01'::DATE) AS date_key,
    YEAR(DATEADD(DAY, SEQ4(), '2022-01-01'::DATE)) AS year,
    QUARTER(DATEADD(DAY, SEQ4(), '2022-01-01'::DATE)) AS quarter,
    MONTH(DATEADD(DAY, SEQ4(), '2022-01-01'::DATE)) AS month,
    MONTHNAME(DATEADD(DAY, SEQ4(), '2022-01-01'::DATE)) AS month_name,
    DAYOFWEEK(DATEADD(DAY, SEQ4(), '2022-01-01'::DATE)) AS day_of_week,
    DAYNAME(DATEADD(DAY, SEQ4(), '2022-01-01'::DATE)) AS day_name,
    IFF(DAYOFWEEK(DATEADD(DAY, SEQ4(), '2022-01-01'::DATE)) IN (0, 6), TRUE, FALSE) AS is_weekend,
    IFF(MONTH(DATEADD(DAY, SEQ4(), '2022-01-01'::DATE)) IN (1,7,12)
        AND DAY(DATEADD(DAY, SEQ4(), '2022-01-01'::DATE)) = 1, TRUE, FALSE) AS is_holiday
FROM TABLE(GENERATOR(ROWCOUNT => 1096));

-- DIM_EMPLOYEE (500 rows)
CREATE OR REPLACE TABLE DIM_EMPLOYEE AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS employee_id,
    'EMP-' || LPAD(ROW_NUMBER() OVER (ORDER BY SEQ4()), 5, '0') AS employee_code,
    ARRAY_CONSTRUCT('Engineering','Sales','Marketing','Finance','HR','Operations','Support','Product','Legal','Data')
        [MOD(SEQ4(), 10)]::STRING AS department,
    ARRAY_CONSTRUCT('Manager','Senior','Junior','Lead','Director','VP','IC','Staff','Principal','Intern')
        [MOD(SEQ4(), 10)]::STRING AS level,
    ARRAY_CONSTRUCT('North','South','East','West')
        [MOD(SEQ4(), 4)]::STRING AS region,
    DATEADD(DAY, -MOD(SEQ4(), 1825), '2024-12-01'::DATE) AS hire_date,
    ROUND(UNIFORM(45000, 250000, RANDOM(45))::NUMBER, 0) AS base_salary,
    IFF(MOD(SEQ4(), 20) = 0, TRUE, FALSE) AS is_terminated
FROM TABLE(GENERATOR(ROWCOUNT => 500));

-- DIM_REGION (4 rows)
CREATE OR REPLACE TABLE DIM_REGION AS
SELECT column1 AS region_id, column2 AS region_name, column3 AS region_head
FROM VALUES
    (1, 'North', 'N. Territory'),
    (2, 'South', 'S. Territory'),
    (3, 'East', 'E. Territory'),
    (4, 'West', 'W. Territory');

----------------------------------------------------------------------
-- FACT TABLES (100k rows each)
----------------------------------------------------------------------

-- FACT_ORDERS (Sales domain)
CREATE OR REPLACE TABLE FACT_ORDERS AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS order_id,
    MOD(SEQ4(), 1000) + 1 AS customer_id,
    MOD(SEQ4(), 500) + 1 AS product_id,
    DATEADD(DAY, MOD(SEQ4(), 1096), '2022-01-01'::DATE) AS order_date,
    MOD(SEQ4(), 50) + 1 AS quantity,
    ROUND(UNIFORM(10, 10000, RANDOM(100))::NUMBER, 2) AS revenue,
    ROUND(UNIFORM(5, 5000, RANDOM(101))::NUMBER, 2) AS cost,
    ARRAY_CONSTRUCT('Completed','Pending','Cancelled','Refunded','Shipped')
        [MOD(SEQ4(), 5)]::STRING AS status,
    ARRAY_CONSTRUCT('Online','In-Store','Partner','Reseller')
        [MOD(SEQ4(), 4)]::STRING AS channel
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- FACT_CAMPAIGN_EVENTS (Marketing domain)
CREATE OR REPLACE TABLE FACT_CAMPAIGN_EVENTS AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS event_id,
    'CAMP-' || LPAD(MOD(SEQ4(), 200) + 1, 4, '0') AS campaign_id,
    MOD(SEQ4(), 1000) + 1 AS customer_id,
    DATEADD(DAY, MOD(SEQ4(), 1096), '2022-01-01'::DATE) AS event_date,
    ARRAY_CONSTRUCT('Email Open','Click','Conversion','Impression','Unsubscribe','Bounce')
        [MOD(SEQ4(), 6)]::STRING AS event_type,
    ARRAY_CONSTRUCT('Email','Social','PPC','Display','Organic','Referral')
        [MOD(SEQ4(), 6)]::STRING AS channel,
    ROUND(UNIFORM(0.01, 50.00, RANDOM(102))::NUMBER, 2) AS cost_per_event,
    ROUND(UNIFORM(0, 500, RANDOM(103))::NUMBER, 2) AS attributed_revenue
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- FACT_OPPORTUNITIES (CRM domain)
CREATE OR REPLACE TABLE FACT_OPPORTUNITIES AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS opportunity_id,
    MOD(SEQ4(), 1000) + 1 AS customer_id,
    MOD(SEQ4(), 500) + 1 AS owner_employee_id,
    DATEADD(DAY, MOD(SEQ4(), 1096), '2022-01-01'::DATE) AS created_date,
    DATEADD(DAY, MOD(SEQ4(), 1096) + MOD(SEQ4(), 90), '2022-01-01'::DATE) AS close_date,
    ARRAY_CONSTRUCT('Prospecting','Qualification','Proposal','Negotiation','Closed Won','Closed Lost')
        [MOD(SEQ4(), 6)]::STRING AS stage,
    ROUND(UNIFORM(1000, 500000, RANDOM(104))::NUMBER, 2) AS deal_amount,
    ROUND(UNIFORM(0.1, 1.0, RANDOM(105))::NUMBER, 2) AS probability
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- FACT_GL_ENTRIES (Finance domain)
CREATE OR REPLACE TABLE FACT_GL_ENTRIES AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS entry_id,
    ARRAY_CONSTRUCT('4000-Revenue','5000-COGS','6000-OpEx','7000-SGA','8000-RnD','9000-Other')
        [MOD(SEQ4(), 6)]::STRING AS account_code,
    ARRAY_CONSTRUCT('Revenue','Cost of Goods Sold','Operating Expense','Selling & Admin','Research','Depreciation')
        [MOD(SEQ4(), 6)]::STRING AS account_name,
    DATEADD(DAY, MOD(SEQ4(), 1096), '2022-01-01'::DATE) AS posting_date,
    ROUND(UNIFORM(-100000, 500000, RANDOM(106))::NUMBER, 2) AS debit_amount,
    ROUND(UNIFORM(-100000, 500000, RANDOM(107))::NUMBER, 2) AS credit_amount,
    ARRAY_CONSTRUCT('Engineering','Sales','Marketing','Finance','HR','Operations','Support','Product')
        [MOD(SEQ4(), 8)]::STRING AS cost_center,
    ARRAY_CONSTRUCT('North','South','East','West')
        [MOD(SEQ4(), 4)]::STRING AS region
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- FACT_HEADCOUNT (HR domain)
CREATE OR REPLACE TABLE FACT_HEADCOUNT AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS snapshot_id,
    MOD(SEQ4(), 500) + 1 AS employee_id,
    DATEADD(DAY, MOD(SEQ4(), 1096), '2022-01-01'::DATE) AS snapshot_date,
    ARRAY_CONSTRUCT('Engineering','Sales','Marketing','Finance','HR','Operations','Support','Product','Legal','Data')
        [MOD(SEQ4(), 10)]::STRING AS department,
    ARRAY_CONSTRUCT('Manager','Senior','Junior','Lead','Director','VP','IC','Staff','Principal','Intern')
        [MOD(SEQ4(), 10)]::STRING AS level,
    ARRAY_CONSTRUCT('North','South','East','West')
        [MOD(SEQ4(), 4)]::STRING AS region,
    ROUND(UNIFORM(45000, 250000, RANDOM(108))::NUMBER, 0) AS salary,
    IFF(MOD(SEQ4(), 15) = 0, 'Terminated', 'Active') AS status
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- FACT_PAYROLL (Payroll domain)
CREATE OR REPLACE TABLE FACT_PAYROLL AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS payroll_id,
    MOD(SEQ4(), 500) + 1 AS employee_id,
    DATEADD(DAY, MOD(SEQ4(), 1096), '2022-01-01'::DATE) AS pay_date,
    ROUND(UNIFORM(2000, 12000, RANDOM(109))::NUMBER, 2) AS gross_pay,
    ROUND(UNIFORM(500, 4000, RANDOM(110))::NUMBER, 2) AS tax_withholding,
    ROUND(UNIFORM(100, 1500, RANDOM(111))::NUMBER, 2) AS benefits_deduction,
    ROUND(UNIFORM(1500, 8000, RANDOM(112))::NUMBER, 2) AS net_pay,
    ARRAY_CONSTRUCT('Bi-Weekly','Monthly','Semi-Monthly')
        [MOD(SEQ4(), 3)]::STRING AS pay_frequency,
    ARRAY_CONSTRUCT('Engineering','Sales','Marketing','Finance','HR','Operations','Support','Product')
        [MOD(SEQ4(), 8)]::STRING AS department
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- FACT_APPLICATIONS (Recruiting domain)
CREATE OR REPLACE TABLE FACT_APPLICATIONS AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS application_id,
    'REQ-' || LPAD(MOD(SEQ4(), 300) + 1, 5, '0') AS requisition_id,
    DATEADD(DAY, MOD(SEQ4(), 1096), '2022-01-01'::DATE) AS apply_date,
    ARRAY_CONSTRUCT('Engineering','Sales','Marketing','Finance','HR','Operations','Support','Product','Legal','Data')
        [MOD(SEQ4(), 10)]::STRING AS department,
    ARRAY_CONSTRUCT('Senior','Mid','Junior','Staff','Lead','Principal')
        [MOD(SEQ4(), 6)]::STRING AS level,
    ARRAY_CONSTRUCT('Applied','Phone Screen','Onsite','Offer','Hired','Rejected','Withdrawn')
        [MOD(SEQ4(), 7)]::STRING AS status,
    ARRAY_CONSTRUCT('LinkedIn','Referral','Careers Page','Indeed','Recruiter','University')
        [MOD(SEQ4(), 6)]::STRING AS source,
    MOD(SEQ4(), 60) + 1 AS days_in_pipeline
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- FACT_SHIPMENTS (Supply Chain domain)
CREATE OR REPLACE TABLE FACT_SHIPMENTS AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS shipment_id,
    MOD(SEQ4(), 1000) + 1 AS customer_id,
    MOD(SEQ4(), 500) + 1 AS product_id,
    DATEADD(DAY, MOD(SEQ4(), 1096), '2022-01-01'::DATE) AS ship_date,
    DATEADD(DAY, MOD(SEQ4(), 1096) + MOD(SEQ4(), 14) + 1, '2022-01-01'::DATE) AS delivery_date,
    ARRAY_CONSTRUCT('Ground','Express','Overnight','Freight','International')
        [MOD(SEQ4(), 5)]::STRING AS shipping_method,
    ARRAY_CONSTRUCT('Delivered','In Transit','Delayed','Returned','Lost')
        [MOD(SEQ4(), 5)]::STRING AS status,
    ROUND(UNIFORM(5, 500, RANDOM(113))::NUMBER, 2) AS shipping_cost,
    ROUND(UNIFORM(0.5, 200, RANDOM(114))::NUMBER, 2) AS weight_kg
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- FACT_INVENTORY (Inventory domain)
CREATE OR REPLACE TABLE FACT_INVENTORY AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS snapshot_id,
    MOD(SEQ4(), 500) + 1 AS product_id,
    DATEADD(DAY, MOD(SEQ4(), 1096), '2022-01-01'::DATE) AS snapshot_date,
    ARRAY_CONSTRUCT('Warehouse-A','Warehouse-B','Warehouse-C','Warehouse-D','Warehouse-E')
        [MOD(SEQ4(), 5)]::STRING AS warehouse,
    MOD(SEQ4(), 5000) + 1 AS quantity_on_hand,
    MOD(SEQ4(), 1000) + 1 AS quantity_reserved,
    MOD(SEQ4(), 500) AS quantity_backordered,
    ROUND(UNIFORM(10, 5000, RANDOM(115))::NUMBER, 2) AS unit_cost,
    MOD(SEQ4(), 200) + 10 AS reorder_point
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- FACT_PURCHASE_ORDERS (Procurement domain)
CREATE OR REPLACE TABLE FACT_PURCHASE_ORDERS AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS po_id,
    'VENDOR-' || LPAD(MOD(SEQ4(), 100) + 1, 4, '0') AS vendor_id,
    MOD(SEQ4(), 500) + 1 AS product_id,
    DATEADD(DAY, MOD(SEQ4(), 1096), '2022-01-01'::DATE) AS order_date,
    DATEADD(DAY, MOD(SEQ4(), 1096) + MOD(SEQ4(), 30) + 5, '2022-01-01'::DATE) AS expected_delivery,
    MOD(SEQ4(), 2000) + 1 AS quantity,
    ROUND(UNIFORM(5, 3000, RANDOM(116))::NUMBER, 2) AS unit_cost,
    ROUND(UNIFORM(100, 500000, RANDOM(117))::NUMBER, 2) AS total_cost,
    ARRAY_CONSTRUCT('Draft','Submitted','Approved','Received','Partial','Cancelled')
        [MOD(SEQ4(), 6)]::STRING AS status
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- FACT_TICKETS (Support domain)
CREATE OR REPLACE TABLE FACT_TICKETS AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS ticket_id,
    MOD(SEQ4(), 1000) + 1 AS customer_id,
    MOD(SEQ4(), 500) + 1 AS assigned_employee_id,
    DATEADD(DAY, MOD(SEQ4(), 1096), '2022-01-01'::DATE) AS created_date,
    DATEADD(DAY, MOD(SEQ4(), 1096) + MOD(SEQ4(), 7), '2022-01-01'::DATE) AS resolved_date,
    ARRAY_CONSTRUCT('Bug','Feature Request','Question','Incident','Task','Change Request')
        [MOD(SEQ4(), 6)]::STRING AS ticket_type,
    ARRAY_CONSTRUCT('Critical','High','Medium','Low')
        [MOD(SEQ4(), 4)]::STRING AS priority,
    ARRAY_CONSTRUCT('Open','In Progress','Waiting','Resolved','Closed','Escalated')
        [MOD(SEQ4(), 6)]::STRING AS status,
    MOD(SEQ4(), 168) + 1 AS resolution_hours,
    ROUND(UNIFORM(1, 10, RANDOM(118))::NUMBER, 1) AS csat_score
FROM TABLE(GENERATOR(ROWCOUNT => 100000));

-- FACT_WEB_EVENTS (Web Analytics domain)
CREATE OR REPLACE TABLE FACT_WEB_EVENTS AS
SELECT
    ROW_NUMBER() OVER (ORDER BY SEQ4()) AS event_id,
    MOD(SEQ4(), 1000) + 1 AS customer_id,
    DATEADD(DAY, MOD(SEQ4(), 1096), '2022-01-01'::DATE) AS event_date,
    ARRAY_CONSTRUCT('Page View','Click','Form Submit','Download','Video Play','Scroll','Search')
        [MOD(SEQ4(), 7)]::STRING AS event_type,
    ARRAY_CONSTRUCT('/home','/pricing','/product','/blog','/docs','/signup','/demo','/contact')
        [MOD(SEQ4(), 8)]::STRING AS page_path,
    ARRAY_CONSTRUCT('Google','Direct','Social','Email','Referral','Paid Search')
        [MOD(SEQ4(), 6)]::STRING AS traffic_source,
    ARRAY_CONSTRUCT('Desktop','Mobile','Tablet')
        [MOD(SEQ4(), 3)]::STRING AS device_type,
    MOD(SEQ4(), 300) + 1 AS session_duration_seconds,
    IFF(MOD(SEQ4(), 20) = 0, TRUE, FALSE) AS converted
FROM TABLE(GENERATOR(ROWCOUNT => 100000));
