-- 02_semantic_views.sql
-- 12 Semantic Views in CORTEX_AGENT_LAB.SEMANTIC
-- One per business domain, with dimensions, metrics, relationships, and synonyms

USE WAREHOUSE LAB_WH;
USE SCHEMA CORTEX_AGENT_LAB.SEMANTIC;

----------------------------------------------------------------------
-- SALES_VIEW
----------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW SALES_VIEW
  AS SELECT * FROM CORTEX_AGENT_LAB.RAW.FACT_ORDERS o
  JOIN CORTEX_AGENT_LAB.RAW.DIM_CUSTOMER c ON o.customer_id = c.customer_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_PRODUCT p ON o.product_id = p.product_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_DATE d ON o.order_date = d.date_key
  COLUMNS (
    c.customer_code DIMENSION synonyms ['account number', 'client ID'],
    c.segment DIMENSION synonyms ['customer tier', 'account type'],
    c.industry DIMENSION,
    c.region DIMENSION synonyms ['territory', 'geo'],
    p.product_name DIMENSION synonyms ['item', 'SKU name'],
    p.category DIMENSION synonyms ['product line', 'product type'],
    d.date_key DIMENSION synonyms ['order date', 'transaction date'],
    d.year DIMENSION,
    d.quarter DIMENSION,
    d.month_name DIMENSION,
    o.channel DIMENSION synonyms ['sales channel', 'source'],
    o.status DIMENSION synonyms ['order status'],
    o.revenue MEASURE TYPE SUM synonyms ['sales', 'bookings', 'order value'],
    o.cost MEASURE TYPE SUM synonyms ['COGS', 'cost of goods'],
    o.quantity MEASURE TYPE SUM synonyms ['units sold', 'volume']
  )
  COMMENT = 'Sales orders, revenue, and product performance. Use for questions about bookings, order volume, revenue by region/product/channel.';

----------------------------------------------------------------------
-- MARKETING_VIEW
----------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW MARKETING_VIEW
  AS SELECT * FROM CORTEX_AGENT_LAB.RAW.FACT_CAMPAIGN_EVENTS ce
  JOIN CORTEX_AGENT_LAB.RAW.DIM_CUSTOMER c ON ce.customer_id = c.customer_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_DATE d ON ce.event_date = d.date_key
  COLUMNS (
    ce.campaign_id DIMENSION synonyms ['campaign code'],
    ce.event_type DIMENSION synonyms ['interaction type', 'engagement type'],
    ce.channel DIMENSION synonyms ['marketing channel', 'medium'],
    c.customer_code DIMENSION,
    c.segment DIMENSION,
    c.region DIMENSION,
    d.date_key DIMENSION synonyms ['event date'],
    d.year DIMENSION,
    d.quarter DIMENSION,
    d.month_name DIMENSION,
    ce.cost_per_event MEASURE TYPE SUM synonyms ['spend', 'ad cost'],
    ce.attributed_revenue MEASURE TYPE SUM synonyms ['marketing revenue', 'attributed sales']
  )
  COMMENT = 'Marketing campaign events and attribution. Use for questions about campaign performance, marketing spend, channel effectiveness, and conversion attribution.';

----------------------------------------------------------------------
-- CRM_VIEW
----------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW CRM_VIEW
  AS SELECT * FROM CORTEX_AGENT_LAB.RAW.FACT_OPPORTUNITIES opp
  JOIN CORTEX_AGENT_LAB.RAW.DIM_CUSTOMER c ON opp.customer_id = c.customer_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_EMPLOYEE e ON opp.owner_employee_id = e.employee_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_DATE d ON opp.created_date = d.date_key
  COLUMNS (
    opp.stage DIMENSION synonyms ['pipeline stage', 'deal stage', 'opportunity status'],
    c.customer_code DIMENSION synonyms ['account'],
    c.segment DIMENSION,
    c.industry DIMENSION,
    c.region DIMENSION,
    e.employee_code DIMENSION synonyms ['rep', 'sales rep', 'account executive'],
    e.department DIMENSION,
    d.date_key DIMENSION synonyms ['created date'],
    d.year DIMENSION,
    d.quarter DIMENSION,
    opp.deal_amount MEASURE TYPE SUM synonyms ['pipeline value', 'opportunity value', 'deal size'],
    opp.probability MEASURE TYPE AVG synonyms ['win rate', 'close probability']
  )
  COMMENT = 'CRM pipeline and opportunity management. Use for questions about deal pipeline, win rates, rep performance, and forecast.';

----------------------------------------------------------------------
-- FINANCE_VIEW
----------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW FINANCE_VIEW
  AS SELECT * FROM CORTEX_AGENT_LAB.RAW.FACT_GL_ENTRIES gl
  JOIN CORTEX_AGENT_LAB.RAW.DIM_DATE d ON gl.posting_date = d.date_key
  COLUMNS (
    gl.account_code DIMENSION synonyms ['GL account', 'chart of accounts'],
    gl.account_name DIMENSION synonyms ['account description'],
    gl.cost_center DIMENSION synonyms ['department', 'business unit'],
    gl.region DIMENSION,
    d.date_key DIMENSION synonyms ['posting date', 'fiscal date'],
    d.year DIMENSION synonyms ['fiscal year'],
    d.quarter DIMENSION synonyms ['fiscal quarter'],
    d.month_name DIMENSION,
    gl.debit_amount MEASURE TYPE SUM synonyms ['debits'],
    gl.credit_amount MEASURE TYPE SUM synonyms ['credits']
  )
  COMMENT = 'General ledger entries and financial reporting. Use for questions about expenses, revenue recognition, cost center budgets, and P&L.';

----------------------------------------------------------------------
-- HR_VIEW
----------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW HR_VIEW
  AS SELECT * FROM CORTEX_AGENT_LAB.RAW.FACT_HEADCOUNT hc
  JOIN CORTEX_AGENT_LAB.RAW.DIM_EMPLOYEE e ON hc.employee_id = e.employee_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_DATE d ON hc.snapshot_date = d.date_key
  COLUMNS (
    e.employee_code DIMENSION synonyms ['employee ID', 'staff ID'],
    hc.department DIMENSION synonyms ['team', 'org', 'business unit'],
    hc.level DIMENSION synonyms ['job level', 'seniority', 'title'],
    hc.region DIMENSION synonyms ['location', 'office'],
    hc.status DIMENSION synonyms ['employment status'],
    d.date_key DIMENSION synonyms ['snapshot date', 'as of date'],
    d.year DIMENSION,
    d.quarter DIMENSION,
    hc.salary MEASURE TYPE AVG synonyms ['compensation', 'base pay', 'annual salary']
  )
  COMMENT = 'Headcount snapshots and workforce analytics. Use for questions about employee count, turnover, department size, and compensation benchmarks.';

----------------------------------------------------------------------
-- PAYROLL_VIEW
----------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW PAYROLL_VIEW
  AS SELECT * FROM CORTEX_AGENT_LAB.RAW.FACT_PAYROLL pr
  JOIN CORTEX_AGENT_LAB.RAW.DIM_EMPLOYEE e ON pr.employee_id = e.employee_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_DATE d ON pr.pay_date = d.date_key
  COLUMNS (
    e.employee_code DIMENSION,
    pr.department DIMENSION synonyms ['cost center'],
    pr.pay_frequency DIMENSION,
    d.date_key DIMENSION synonyms ['pay date', 'payroll date'],
    d.year DIMENSION,
    d.quarter DIMENSION,
    d.month_name DIMENSION,
    pr.gross_pay MEASURE TYPE SUM synonyms ['gross compensation', 'total pay'],
    pr.tax_withholding MEASURE TYPE SUM synonyms ['taxes', 'withholdings'],
    pr.benefits_deduction MEASURE TYPE SUM synonyms ['benefits cost', 'deductions'],
    pr.net_pay MEASURE TYPE SUM synonyms ['take-home pay', 'net compensation']
  )
  COMMENT = 'Payroll processing and compensation disbursements. Use for questions about payroll expenses, tax withholdings, benefits costs, and net pay by department.';

----------------------------------------------------------------------
-- RECRUITING_VIEW
----------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW RECRUITING_VIEW
  AS SELECT * FROM CORTEX_AGENT_LAB.RAW.FACT_APPLICATIONS app
  JOIN CORTEX_AGENT_LAB.RAW.DIM_DATE d ON app.apply_date = d.date_key
  COLUMNS (
    app.requisition_id DIMENSION synonyms ['job req', 'opening'],
    app.department DIMENSION synonyms ['hiring team'],
    app.level DIMENSION synonyms ['seniority', 'job level'],
    app.status DIMENSION synonyms ['application status', 'stage'],
    app.source DIMENSION synonyms ['recruiting source', 'channel'],
    d.date_key DIMENSION synonyms ['application date'],
    d.year DIMENSION,
    d.quarter DIMENSION,
    d.month_name DIMENSION,
    app.days_in_pipeline MEASURE TYPE AVG synonyms ['time to hire', 'cycle time', 'days to fill']
  )
  COMMENT = 'Recruiting pipeline and candidate tracking. Use for questions about hiring velocity, source effectiveness, pipeline by department, and time-to-fill.';

----------------------------------------------------------------------
-- SUPPLY_CHAIN_VIEW
----------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW SUPPLY_CHAIN_VIEW
  AS SELECT * FROM CORTEX_AGENT_LAB.RAW.FACT_SHIPMENTS s
  JOIN CORTEX_AGENT_LAB.RAW.DIM_CUSTOMER c ON s.customer_id = c.customer_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_PRODUCT p ON s.product_id = p.product_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_DATE d ON s.ship_date = d.date_key
  COLUMNS (
    s.shipping_method DIMENSION synonyms ['carrier', 'delivery method'],
    s.status DIMENSION synonyms ['shipment status', 'delivery status'],
    c.customer_code DIMENSION,
    c.region DIMENSION synonyms ['destination region'],
    p.product_name DIMENSION,
    p.category DIMENSION,
    d.date_key DIMENSION synonyms ['ship date'],
    d.year DIMENSION,
    d.quarter DIMENSION,
    s.shipping_cost MEASURE TYPE SUM synonyms ['freight cost', 'logistics cost'],
    s.weight_kg MEASURE TYPE SUM synonyms ['total weight', 'shipment weight']
  )
  COMMENT = 'Shipment tracking and logistics. Use for questions about delivery performance, shipping costs, carrier efficiency, and fulfillment status.';

----------------------------------------------------------------------
-- INVENTORY_VIEW
----------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW INVENTORY_VIEW
  AS SELECT * FROM CORTEX_AGENT_LAB.RAW.FACT_INVENTORY inv
  JOIN CORTEX_AGENT_LAB.RAW.DIM_PRODUCT p ON inv.product_id = p.product_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_DATE d ON inv.snapshot_date = d.date_key
  COLUMNS (
    inv.warehouse DIMENSION synonyms ['location', 'facility', 'DC'],
    p.product_name DIMENSION synonyms ['item', 'SKU'],
    p.category DIMENSION synonyms ['product line'],
    d.date_key DIMENSION synonyms ['snapshot date', 'as of date'],
    d.year DIMENSION,
    d.quarter DIMENSION,
    inv.quantity_on_hand MEASURE TYPE SUM synonyms ['stock', 'available inventory', 'on hand'],
    inv.quantity_reserved MEASURE TYPE SUM synonyms ['allocated', 'committed'],
    inv.quantity_backordered MEASURE TYPE SUM synonyms ['backorders', 'unfulfilled'],
    inv.unit_cost MEASURE TYPE AVG synonyms ['inventory cost', 'carrying cost'],
    inv.reorder_point MEASURE TYPE AVG synonyms ['reorder level', 'min stock']
  )
  COMMENT = 'Inventory levels and warehouse stock. Use for questions about stock availability, backorders, warehouse utilization, and reorder points.';

----------------------------------------------------------------------
-- PROCUREMENT_VIEW
----------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW PROCUREMENT_VIEW
  AS SELECT * FROM CORTEX_AGENT_LAB.RAW.FACT_PURCHASE_ORDERS po
  JOIN CORTEX_AGENT_LAB.RAW.DIM_PRODUCT p ON po.product_id = p.product_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_DATE d ON po.order_date = d.date_key
  COLUMNS (
    po.vendor_id DIMENSION synonyms ['supplier', 'vendor code'],
    po.status DIMENSION synonyms ['PO status', 'order status'],
    p.product_name DIMENSION,
    p.category DIMENSION,
    d.date_key DIMENSION synonyms ['PO date', 'order date'],
    d.year DIMENSION,
    d.quarter DIMENSION,
    po.quantity MEASURE TYPE SUM synonyms ['ordered quantity', 'units ordered'],
    po.unit_cost MEASURE TYPE AVG synonyms ['purchase price', 'vendor price'],
    po.total_cost MEASURE TYPE SUM synonyms ['PO value', 'purchase spend', 'procurement cost']
  )
  COMMENT = 'Purchase orders and vendor management. Use for questions about procurement spend, vendor performance, purchase volumes, and supplier costs.';

----------------------------------------------------------------------
-- SUPPORT_VIEW
----------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW SUPPORT_VIEW
  AS SELECT * FROM CORTEX_AGENT_LAB.RAW.FACT_TICKETS t
  JOIN CORTEX_AGENT_LAB.RAW.DIM_CUSTOMER c ON t.customer_id = c.customer_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_EMPLOYEE e ON t.assigned_employee_id = e.employee_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_DATE d ON t.created_date = d.date_key
  COLUMNS (
    t.ticket_type DIMENSION synonyms ['issue type', 'case type'],
    t.priority DIMENSION synonyms ['severity', 'urgency'],
    t.status DIMENSION synonyms ['ticket status', 'case status'],
    c.customer_code DIMENSION synonyms ['account'],
    c.segment DIMENSION,
    c.region DIMENSION,
    e.employee_code DIMENSION synonyms ['agent', 'support rep'],
    d.date_key DIMENSION synonyms ['created date', 'opened date'],
    d.year DIMENSION,
    d.quarter DIMENSION,
    t.resolution_hours MEASURE TYPE AVG synonyms ['time to resolve', 'resolution time', 'MTTR'],
    t.csat_score MEASURE TYPE AVG synonyms ['satisfaction', 'customer satisfaction', 'NPS']
  )
  COMMENT = 'Customer support tickets and resolution. Use for questions about ticket volume, resolution times, CSAT scores, and support agent performance.';

----------------------------------------------------------------------
-- WEB_ANALYTICS_VIEW
----------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW WEB_ANALYTICS_VIEW
  AS SELECT * FROM CORTEX_AGENT_LAB.RAW.FACT_WEB_EVENTS w
  JOIN CORTEX_AGENT_LAB.RAW.DIM_CUSTOMER c ON w.customer_id = c.customer_id
  JOIN CORTEX_AGENT_LAB.RAW.DIM_DATE d ON w.event_date = d.date_key
  COLUMNS (
    w.event_type DIMENSION synonyms ['interaction', 'action type'],
    w.page_path DIMENSION synonyms ['URL', 'page', 'landing page'],
    w.traffic_source DIMENSION synonyms ['referrer', 'acquisition source', 'utm source'],
    w.device_type DIMENSION synonyms ['platform', 'device'],
    c.customer_code DIMENSION,
    c.segment DIMENSION,
    c.region DIMENSION,
    d.date_key DIMENSION synonyms ['event date', 'visit date'],
    d.year DIMENSION,
    d.quarter DIMENSION,
    w.session_duration_seconds MEASURE TYPE AVG synonyms ['time on site', 'session length', 'engagement time'],
    w.converted MEASURE TYPE SUM synonyms ['conversions', 'goal completions']
  )
  COMMENT = 'Website behavior and digital analytics. Use for questions about traffic, page views, conversion rates, session duration, and traffic sources.';
