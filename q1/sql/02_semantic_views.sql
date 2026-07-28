-- Q1 Table Scaling Experiment: Semantic Views at T5, T10, T20
-- Tests if adding more tables to a single semantic view degrades answer quality
-- Per design doc §6 (Exp A tiers)

USE WAREHOUSE LAB_WH;

-- ============================================
-- T5: 5 tables (sales, customers, products, dates, stores)
-- Simplest view — core schema only
-- ============================================

CREATE OR REPLACE SEMANTIC VIEW CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_T5
  TABLES (
    sales AS CORTEX_AGENT_LAB.RAW.RC_FACT_SALES
      PRIMARY KEY (sale_id)
      WITH SYNONYMS ('transactions', 'orders', 'purchases')
      COMMENT = 'Core sales transactions',
    customers AS CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER
      PRIMARY KEY (customer_id)
      WITH SYNONYMS ('clients', 'buyers')
      COMMENT = 'Customer reference data',
    products AS CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT
      PRIMARY KEY (product_id)
      WITH SYNONYMS ('items', 'goods')
      COMMENT = 'Product reference data',
    dates AS CORTEX_AGENT_LAB.RAW.RC_DIM_DATE
      PRIMARY KEY (date_day)
      COMMENT = 'Date dimension',
    stores AS CORTEX_AGENT_LAB.RAW.RC_DIM_STORE
      PRIMARY KEY (store_id)
      WITH SYNONYMS ('locations', 'branches')
      COMMENT = 'Store locations'
  )
  RELATIONSHIPS (
    sales_to_customers AS sales (customer_id) REFERENCES customers,
    sales_to_products  AS sales (product_id)  REFERENCES products,
    sales_to_stores    AS sales (store_id)    REFERENCES stores
  )
  DIMENSIONS (
    customers.customer_name AS customer_name,
    customers.customer_tier AS customer_tier  WITH SYNONYMS = ('loyalty tier', 'customer level'),
    customers.city          AS city,
    products.product_name   AS product_name,
    products.product_type   AS product_type   WITH SYNONYMS = ('category', 'product category'),
    stores.store_name       AS store_name,
    stores.region           AS region         WITH SYNONYMS = ('area', 'territory'),
    stores.store_type       AS store_type,
    sales.sale_date         AS sale_date      WITH SYNONYMS = ('transaction date', 'purchase date'),
    sales.discount_rate     AS discount_rate  WITH SYNONYMS = ('discount', 'markdown')
  )
  METRICS (
    sales.total_revenue    AS SUM(sale_amount)     WITH SYNONYMS = ('total sales', 'gross revenue', 'revenue')  COMMENT = 'Total revenue',
    sales.avg_sale_value   AS AVG(sale_amount)     WITH SYNONYMS = ('average sale', 'avg transaction')          COMMENT = 'Average sale value',
    sales.total_sales      AS COUNT(sale_id)       WITH SYNONYMS = ('number of sales', 'transaction count')     COMMENT = 'Total transactions',
    customers.customer_count AS COUNT(customer_id) WITH SYNONYMS = ('number of customers')                      COMMENT = 'Total customers'
  )
  COMMENT = 'RetailCorp T5 — 5 tables: sales, customers, products, dates, stores';

-- ============================================
-- T10: 10 tables (T5 + promotions, sales reps, suppliers, shipments, returns)
-- Medium complexity — more join paths, more columns
-- ============================================

CREATE OR REPLACE SEMANTIC VIEW CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_T10
  TABLES (
    sales AS CORTEX_AGENT_LAB.RAW.RC_FACT_SALES
      PRIMARY KEY (sale_id)
      WITH SYNONYMS ('transactions', 'orders', 'purchases')
      COMMENT = 'Core sales transactions',
    customers AS CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER
      PRIMARY KEY (customer_id)
      WITH SYNONYMS ('clients', 'buyers')
      COMMENT = 'Customer reference data',
    products AS CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT
      PRIMARY KEY (product_id)
      WITH SYNONYMS ('items', 'goods')
      COMMENT = 'Product reference data',
    dates AS CORTEX_AGENT_LAB.RAW.RC_DIM_DATE
      PRIMARY KEY (date_day)
      COMMENT = 'Date dimension',
    stores AS CORTEX_AGENT_LAB.RAW.RC_DIM_STORE
      PRIMARY KEY (store_id)
      WITH SYNONYMS ('locations', 'branches')
      COMMENT = 'Store locations',
    promotions AS CORTEX_AGENT_LAB.RAW.RC_DIM_PROMOTION
      PRIMARY KEY (promotion_id)
      WITH SYNONYMS ('deals', 'offers')
      COMMENT = 'Promotional campaigns',
    sales_reps AS CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP
      PRIMARY KEY (sales_rep_id)
      WITH SYNONYMS ('reps', 'salespeople')
      COMMENT = 'Sales representatives',
    suppliers AS CORTEX_AGENT_LAB.RAW.RC_DIM_SUPPLIER
      PRIMARY KEY (supplier_id)
      WITH SYNONYMS ('vendors', 'manufacturers')
      COMMENT = 'Product suppliers',
    shipments AS CORTEX_AGENT_LAB.RAW.RC_DIM_SHIPMENT
      PRIMARY KEY (shipment_id)
      WITH SYNONYMS ('deliveries', 'logistics')
      COMMENT = 'Shipment methods and costs',
    returns AS CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS
      PRIMARY KEY (return_id)
      WITH SYNONYMS ('refunds', 'send-backs')
      COMMENT = 'Product returns and refunds'
  )
  RELATIONSHIPS (
    sales_to_customers  AS sales (customer_id)   REFERENCES customers,
    sales_to_products   AS sales (product_id)    REFERENCES products,
    sales_to_stores     AS sales (store_id)      REFERENCES stores,
    sales_to_promotions AS sales (promotion_id)  REFERENCES promotions,
    sales_to_reps       AS sales (sales_rep_id)  REFERENCES sales_reps,
    sales_to_suppliers  AS sales (supplier_id)   REFERENCES suppliers
  )
  DIMENSIONS (
    customers.customer_name   AS customer_name,
    customers.customer_tier   AS customer_tier    WITH SYNONYMS = ('loyalty tier', 'customer level'),
    customers.city            AS city,
    products.product_name     AS product_name,
    products.product_type     AS product_type     WITH SYNONYMS = ('category', 'product category'),
    stores.store_name         AS store_name,
    stores.region             AS region           WITH SYNONYMS = ('area', 'territory'),
    stores.store_type         AS store_type,
    sales.sale_date           AS sale_date        WITH SYNONYMS = ('transaction date', 'purchase date'),
    sales.discount_rate       AS discount_rate    WITH SYNONYMS = ('discount', 'markdown'),
    promotions.promotion_name AS promotion_name,
    promotions.promotion_type AS promotion_type,
    sales_reps.rep_name       AS rep_name         WITH SYNONYMS = ('salesperson', 'sales rep'),
    sales_reps.territory      AS territory,
    sales_reps.level          AS level,
    suppliers.supplier_name   AS supplier_name,
    suppliers.supplier_type   AS supplier_type,
    shipments.ship_method     AS ship_method      WITH SYNONYMS = ('delivery method', 'shipping type'),
    shipments.transit_days    AS transit_days,
    returns.return_reason     AS return_reason
  )
  METRICS (
    sales.total_revenue      AS SUM(sale_amount)    WITH SYNONYMS = ('total sales', 'gross revenue', 'revenue')  COMMENT = 'Total revenue',
    sales.avg_sale_value     AS AVG(sale_amount)    WITH SYNONYMS = ('average sale', 'avg transaction')          COMMENT = 'Average sale value',
    sales.total_sales        AS COUNT(sale_id)      WITH SYNONYMS = ('number of sales', 'transaction count')     COMMENT = 'Total transactions',
    customers.customer_count AS COUNT(customer_id)  WITH SYNONYMS = ('number of customers')                      COMMENT = 'Total customers',
    returns.total_returns    AS COUNT(return_id)    WITH SYNONYMS = ('number of returns', 'return count')        COMMENT = 'Total returns',
    returns.total_refunds    AS SUM(refund_amount)  WITH SYNONYMS = ('refund value', 'return value')             COMMENT = 'Total refund amount',
    shipments.avg_ship_cost  AS AVG(ship_cost)      WITH SYNONYMS = ('average shipping cost')                    COMMENT = 'Average shipping cost'
  )
  COMMENT = 'RetailCorp T10 — 10 tables: adds promotions, reps, suppliers, shipments, returns';

-- ============================================
-- T20: All 20 tables (maximum complexity)
-- Tests if 15 extra distractor tables degrade core question accuracy
-- ============================================

CREATE OR REPLACE SEMANTIC VIEW CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_T20
  TABLES (
    sales AS CORTEX_AGENT_LAB.RAW.RC_FACT_SALES
      PRIMARY KEY (sale_id) WITH SYNONYMS ('transactions', 'orders') COMMENT = 'Core sales transactions',
    customers AS CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER
      PRIMARY KEY (customer_id) WITH SYNONYMS ('clients', 'buyers') COMMENT = 'Customer reference data',
    products AS CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT
      PRIMARY KEY (product_id) WITH SYNONYMS ('items', 'goods') COMMENT = 'Product reference data',
    dates AS CORTEX_AGENT_LAB.RAW.RC_DIM_DATE
      PRIMARY KEY (date_day) COMMENT = 'Date dimension',
    stores AS CORTEX_AGENT_LAB.RAW.RC_DIM_STORE
      PRIMARY KEY (store_id) WITH SYNONYMS ('locations', 'branches') COMMENT = 'Store locations',
    promotions AS CORTEX_AGENT_LAB.RAW.RC_DIM_PROMOTION
      PRIMARY KEY (promotion_id) WITH SYNONYMS ('deals', 'offers') COMMENT = 'Promotional campaigns',
    sales_reps AS CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP
      PRIMARY KEY (sales_rep_id) WITH SYNONYMS ('reps', 'salespeople') COMMENT = 'Sales reps',
    suppliers AS CORTEX_AGENT_LAB.RAW.RC_DIM_SUPPLIER
      PRIMARY KEY (supplier_id) WITH SYNONYMS ('vendors', 'manufacturers') COMMENT = 'Suppliers',
    shipments AS CORTEX_AGENT_LAB.RAW.RC_DIM_SHIPMENT
      PRIMARY KEY (shipment_id) WITH SYNONYMS ('deliveries', 'logistics') COMMENT = 'Shipment methods',
    returns AS CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS
      PRIMARY KEY (return_id) WITH SYNONYMS ('refunds') COMMENT = 'Product returns',
    inventory AS CORTEX_AGENT_LAB.RAW.RC_DIM_INVENTORY
      PRIMARY KEY (inventory_id) COMMENT = 'Inventory levels',
    channels AS CORTEX_AGENT_LAB.RAW.RC_DIM_CHANNEL
      PRIMARY KEY (channel_id) WITH SYNONYMS ('sales channels') COMMENT = 'Sales channels',
    segments AS CORTEX_AGENT_LAB.RAW.RC_DIM_SEGMENT
      PRIMARY KEY (segment_id) WITH SYNONYMS ('market segments') COMMENT = 'Market segments',
    categories AS CORTEX_AGENT_LAB.RAW.RC_DIM_CATEGORY
      PRIMARY KEY (category_id) WITH SYNONYMS ('product categories') COMMENT = 'Product categories',
    brands AS CORTEX_AGENT_LAB.RAW.RC_DIM_BRAND
      PRIMARY KEY (brand_id) WITH SYNONYMS ('brand names') COMMENT = 'Product brands',
    regions AS CORTEX_AGENT_LAB.RAW.RC_DIM_REGION
      PRIMARY KEY (region_id) WITH SYNONYMS ('territories', 'areas') COMMENT = 'Geographic regions',
    currencies AS CORTEX_AGENT_LAB.RAW.RC_DIM_CURRENCY
      PRIMARY KEY (currency_id) COMMENT = 'Currency reference',
    taxes AS CORTEX_AGENT_LAB.RAW.RC_DIM_TAX
      PRIMARY KEY (tax_id) COMMENT = 'Tax rates',
    loyalty AS CORTEX_AGENT_LAB.RAW.RC_DIM_LOYALTY
      PRIMARY KEY (loyalty_tier_id) WITH SYNONYMS ('rewards tiers') COMMENT = 'Loyalty tiers',
    employees AS CORTEX_AGENT_LAB.RAW.RC_DIM_EMPLOYEE
      PRIMARY KEY (employee_id) WITH SYNONYMS ('staff', 'workers') COMMENT = 'Store employees'
  )
  RELATIONSHIPS (
    sales_to_customers    AS sales (customer_id)      REFERENCES customers,
    sales_to_products     AS sales (product_id)       REFERENCES products,
    sales_to_stores       AS sales (store_id)         REFERENCES stores,
    sales_to_promotions   AS sales (promotion_id)     REFERENCES promotions,
    sales_to_reps         AS sales (sales_rep_id)     REFERENCES sales_reps,
    sales_to_suppliers    AS sales (supplier_id)      REFERENCES suppliers,
    sales_to_channels     AS sales (channel_id)       REFERENCES channels,
    sales_to_segments     AS sales (segment_id)       REFERENCES segments,
    sales_to_categories   AS sales (category_id)      REFERENCES categories,
    sales_to_brands       AS sales (brand_id)         REFERENCES brands,
    sales_to_regions      AS sales (region_id)        REFERENCES regions,
    sales_to_currencies   AS sales (currency_id)      REFERENCES currencies,
    sales_to_loyalty      AS sales (loyalty_tier_id)  REFERENCES loyalty,
    sales_to_employees    AS sales (employee_id)      REFERENCES employees,
    inventory_to_stores   AS inventory (store_id)     REFERENCES stores,
    inventory_to_products AS inventory (product_id)   REFERENCES products,
    employees_to_stores   AS employees (store_id)     REFERENCES stores
  )
  DIMENSIONS (
    customers.customer_name   AS customer_name,
    customers.customer_tier   AS customer_tier     WITH SYNONYMS = ('customer level'),
    customers.city            AS city,
    products.product_name     AS product_name,
    products.product_type     AS product_type      WITH SYNONYMS = ('category', 'product category'),
    products.unit_price       AS unit_price,
    stores.store_name         AS store_name,
    stores.region             AS region            WITH SYNONYMS = ('area', 'territory'),
    stores.store_type         AS store_type,
    sales.sale_date           AS sale_date         WITH SYNONYMS = ('transaction date', 'purchase date'),
    sales.discount_rate       AS discount_rate     WITH SYNONYMS = ('discount', 'markdown'),
    promotions.promotion_name AS promotion_name,
    promotions.promotion_type AS promotion_type,
    sales_reps.rep_name       AS rep_name          WITH SYNONYMS = ('salesperson', 'sales rep'),
    sales_reps.territory      AS territory,
    suppliers.supplier_name   AS supplier_name,
    suppliers.supplier_type   AS supplier_type,
    shipments.ship_method     AS ship_method       WITH SYNONYMS = ('delivery method', 'shipping type'),
    returns.return_reason     AS return_reason,
    channels.channel_name     AS channel_name      WITH SYNONYMS = ('sales channel', 'medium'),
    segments.segment_name     AS segment_name      WITH SYNONYMS = ('market segment'),
    categories.category_name  AS category_name,
    categories.department     AS department,
    brands.brand_name         AS brand_name,
    brands.brand_tier         AS brand_tier,
    regions.region_name       AS region_name,
    currencies.currency_code  AS currency_code,
    taxes.tax_rate            AS tax_rate,
    loyalty.tier_name         AS tier_name         WITH SYNONYMS = ('rewards tier', 'loyalty level'),
    employees.employment_type AS employment_type
  )
  METRICS (
    sales.total_revenue      AS SUM(sale_amount)    WITH SYNONYMS = ('total sales', 'gross revenue', 'revenue')  COMMENT = 'Total revenue',
    sales.avg_sale_value     AS AVG(sale_amount)    WITH SYNONYMS = ('average sale', 'avg transaction')          COMMENT = 'Average sale value',
    sales.total_sales        AS COUNT(sale_id)      WITH SYNONYMS = ('number of sales', 'transaction count')     COMMENT = 'Total transactions',
    customers.customer_count AS COUNT(customer_id)  WITH SYNONYMS = ('number of customers')                      COMMENT = 'Total customers',
    returns.total_returns    AS COUNT(return_id)    WITH SYNONYMS = ('number of returns', 'return count')        COMMENT = 'Total returns',
    returns.total_refunds    AS SUM(refund_amount)  WITH SYNONYMS = ('refund value', 'return value')             COMMENT = 'Total refund amount',
    shipments.avg_ship_cost  AS AVG(ship_cost)      WITH SYNONYMS = ('average shipping cost')                    COMMENT = 'Average shipping cost',
    inventory.total_units    AS SUM(units_on_hand)  WITH SYNONYMS = ('stock level', 'units in stock')            COMMENT = 'Total inventory units'
  )
  COMMENT = 'RetailCorp T20 — all 20 tables: maximum schema complexity';
