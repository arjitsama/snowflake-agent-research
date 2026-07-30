-- 01_metadata_variants.sql
-- Q6 Metadata Quality Experiment
-- Hold T20 fixed, vary the quality of metadata in the semantic view
-- Tests whether good metadata can recover the T20 accuracy cliff
--
-- 5 variants:
-- (A) BARE: column names only, no descriptions/synonyms/comments
-- (B) CURRENT: what we already have (the existing RETAILCORP_T20)
-- (C) RICH: detailed descriptions + synonyms + sample values on every column
-- (D) RICH + VERIFIED QUERIES: adds pre-written SQL examples
-- (E) ADVERSARIAL: stale/misleading synonyms and wrong descriptions

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA SEMANTIC;

-- (A) BARE: minimal metadata - just table/column names and PKs, no help
CREATE OR REPLACE SEMANTIC VIEW RETAILCORP_T20_BARE
  tables (
    SALES as CORTEX_AGENT_LAB.RAW.RC_FACT_SALES primary key (SALE_ID),
    CUSTOMERS as CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER primary key (CUSTOMER_ID),
    PRODUCTS as CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT primary key (PRODUCT_ID),
    DATES as CORTEX_AGENT_LAB.RAW.RC_DIM_DATE primary key (DATE_DAY),
    STORES as CORTEX_AGENT_LAB.RAW.RC_DIM_STORE primary key (STORE_ID),
    PROMOTIONS as CORTEX_AGENT_LAB.RAW.RC_DIM_PROMOTION primary key (PROMOTION_ID),
    SALES_REPS as CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP primary key (SALES_REP_ID),
    SUPPLIERS as CORTEX_AGENT_LAB.RAW.RC_DIM_SUPPLIER primary key (SUPPLIER_ID),
    SHIPMENTS as CORTEX_AGENT_LAB.RAW.RC_DIM_SHIPMENT primary key (SHIPMENT_ID),
    RETURNS as CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS primary key (RETURN_ID),
    INVENTORY as CORTEX_AGENT_LAB.RAW.RC_DIM_INVENTORY primary key (INVENTORY_ID),
    CHANNELS as CORTEX_AGENT_LAB.RAW.RC_DIM_CHANNEL primary key (CHANNEL_ID),
    SEGMENTS as CORTEX_AGENT_LAB.RAW.RC_DIM_SEGMENT primary key (SEGMENT_ID),
    CATEGORIES as CORTEX_AGENT_LAB.RAW.RC_DIM_CATEGORY primary key (CATEGORY_ID),
    BRANDS as CORTEX_AGENT_LAB.RAW.RC_DIM_BRAND primary key (BRAND_ID),
    REGIONS as CORTEX_AGENT_LAB.RAW.RC_DIM_REGION primary key (REGION_ID),
    CURRENCIES as CORTEX_AGENT_LAB.RAW.RC_DIM_CURRENCY primary key (CURRENCY_ID),
    TAX as CORTEX_AGENT_LAB.RAW.RC_DIM_TAX primary key (TAX_ID),
    LOYALTY as CORTEX_AGENT_LAB.RAW.RC_DIM_LOYALTY primary key (LOYALTY_TIER_ID),
    EMPLOYEES as CORTEX_AGENT_LAB.RAW.RC_DIM_EMPLOYEE primary key (EMPLOYEE_ID)
  )
  relationships (
    SALES_TO_CUSTOMERS as SALES(CUSTOMER_ID) references CUSTOMERS(CUSTOMER_ID),
    SALES_TO_PRODUCTS as SALES(PRODUCT_ID) references PRODUCTS(PRODUCT_ID),
    SALES_TO_STORES as SALES(STORE_ID) references STORES(STORE_ID),
    SALES_TO_PROMOTIONS as SALES(PROMOTION_ID) references PROMOTIONS(PROMOTION_ID),
    SALES_TO_REPS as SALES(SALES_REP_ID) references SALES_REPS(SALES_REP_ID),
    SALES_TO_SUPPLIERS as SALES(SUPPLIER_ID) references SUPPLIERS(SUPPLIER_ID),
    SALES_TO_CHANNELS as SALES(CHANNEL_ID) references CHANNELS(CHANNEL_ID),
    SALES_TO_SEGMENTS as SALES(SEGMENT_ID) references SEGMENTS(SEGMENT_ID),
    SALES_TO_CATEGORIES as SALES(CATEGORY_ID) references CATEGORIES(CATEGORY_ID),
    SALES_TO_BRANDS as SALES(BRAND_ID) references BRANDS(BRAND_ID),
    SALES_TO_REGIONS as SALES(REGION_ID) references REGIONS(REGION_ID),
    SALES_TO_CURRENCIES as SALES(CURRENCY_ID) references CURRENCIES(CURRENCY_ID),
    SALES_TO_LOYALTY as SALES(LOYALTY_TIER_ID) references LOYALTY(LOYALTY_TIER_ID),
    SALES_TO_EMPLOYEES as SALES(EMPLOYEE_ID) references EMPLOYEES(EMPLOYEE_ID),
    RETURNS_TO_SALES as RETURNS(SALE_ID) references SALES(SALE_ID)
  )
  dimensions (
    SALES.SALE_DATE as sale_date,
    SALES.DISCOUNT_RATE as discount_rate,
    CUSTOMERS.CUSTOMER_TIER as customer_tier,
    PRODUCTS.PRODUCT_TYPE as product_type,
    STORES.REGION as region,
    STORES.STORE_TYPE as store_type,
    SALES_REPS.TERRITORY as territory,
    SALES_REPS.LEVEL as level,
    SUPPLIERS.SUPPLIER_TYPE as supplier_type,
    SHIPMENTS.SHIP_METHOD as ship_method,
    RETURNS.RETURN_REASON as return_reason,
    CHANNELS.CHANNEL_NAME as channel_name,
    SEGMENTS.SEGMENT_NAME as segment_name,
    CATEGORIES.CATEGORY_NAME as category_name,
    BRANDS.BRAND_NAME as brand_name,
    BRANDS.BRAND_TIER as brand_tier,
    REGIONS.REGION_NAME as region_name,
    CURRENCIES.CURRENCY_CODE as currency_code,
    LOYALTY.TIER_NAME as tier_name
  )
  metrics (
    SALES.TOTAL_REVENUE as SUM(sale_amount),
    SALES.AVG_SALE as AVG(sale_amount),
    SALES.TOTAL_SALES as COUNT(sale_id)
  )
  comment='RetailCorp T20 BARE — no descriptions, no synonyms, just structure.';

-- (C) RICH: detailed descriptions + synonyms on everything
CREATE OR REPLACE SEMANTIC VIEW RETAILCORP_T20_RICH
  tables (
    SALES as CORTEX_AGENT_LAB.RAW.RC_FACT_SALES primary key (SALE_ID) with synonyms=('transactions','orders','purchases','bookings') comment='Core sales fact table. Each row is one retail transaction with amount $10-$500. Contains FK references to all dimension tables.',
    CUSTOMERS as CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER primary key (CUSTOMER_ID) with synonyms=('clients','buyers','accounts','shoppers') comment='Customer master data. 1000 customers with tiers (Gold/Silver/Bronze/Standard) and city.',
    PRODUCTS as CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT primary key (PRODUCT_ID) with synonyms=('items','goods','merchandise','SKUs') comment='Product catalog. 500 products across 4 types: Electronics, Apparel, Home, Sports. Unit price $10-$500.',
    DATES as CORTEX_AGENT_LAB.RAW.RC_DIM_DATE primary key (DATE_DAY) comment='Calendar dimension 2022-2024. Use for time-based analysis. Join on sale_date = date_day.',
    STORES as CORTEX_AGENT_LAB.RAW.RC_DIM_STORE primary key (STORE_ID) with synonyms=('locations','branches','outlets','shops') comment='50 store locations across 4 regions (North/South/East/West) and 3 types (Mall/Standalone/Online).',
    PROMOTIONS as CORTEX_AGENT_LAB.RAW.RC_DIM_PROMOTION primary key (PROMOTION_ID) with synonyms=('promos','deals','offers','campaigns') comment='10 promotions with types (Discount/BOGO/Clearance) and discount percentages 5-45%.',
    SALES_REPS as CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP primary key (SALES_REP_ID) with synonyms=('reps','salespeople','agents') comment='20 sales representatives across 4 territories with 3 levels (Senior/Mid/Junior).',
    SUPPLIERS as CORTEX_AGENT_LAB.RAW.RC_DIM_SUPPLIER primary key (SUPPLIER_ID) with synonyms=('vendors','manufacturers','providers') comment='100 suppliers: Domestic, International, or Regional.',
    SHIPMENTS as CORTEX_AGENT_LAB.RAW.RC_DIM_SHIPMENT primary key (SHIPMENT_ID) with synonyms=('deliveries','shipping') comment='1000 shipment records. Methods: Ground/Air/Express. Transit 1-7 days. Cost $5-$50.',
    RETURNS as CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS primary key (RETURN_ID) with synonyms=('refunds','send-backs','RMAs') comment='5000 product returns. Reasons: Defective/Wrong item/Changed mind/Other. Refund $10-$500.',
    INVENTORY as CORTEX_AGENT_LAB.RAW.RC_DIM_INVENTORY primary key (INVENTORY_ID) comment='5000 inventory records linking products to stores with units on hand and reorder cost.',
    CHANNELS as CORTEX_AGENT_LAB.RAW.RC_DIM_CHANNEL primary key (CHANNEL_ID) with synonyms=('sales channels','distribution') comment='5 sales channels: In-Store, Online, Mobile, Phone, Partner.',
    SEGMENTS as CORTEX_AGENT_LAB.RAW.RC_DIM_SEGMENT primary key (SEGMENT_ID) with synonyms=('market segments','customer segments') comment='8 market segments: Budget, Mid-Range, Premium, Luxury, Wholesale, B2B, Government, Non-Profit.',
    CATEGORIES as CORTEX_AGENT_LAB.RAW.RC_DIM_CATEGORY primary key (CATEGORY_ID) comment='20 product categories mapped to 4 departments (Electronics/Apparel/Home/Sports).',
    BRANDS as CORTEX_AGENT_LAB.RAW.RC_DIM_BRAND primary key (BRAND_ID) with synonyms=('labels','makes') comment='30 brands in 3 tiers: Premium, Value, Standard.',
    REGIONS as CORTEX_AGENT_LAB.RAW.RC_DIM_REGION primary key (REGION_ID) with synonyms=('territories','areas','geographies') comment='4 geographic regions: North, South, East, West.',
    CURRENCIES as CORTEX_AGENT_LAB.RAW.RC_DIM_CURRENCY primary key (CURRENCY_ID) comment='3 currencies: USD (1.0), EUR (0.92), GBP (0.79).',
    TAX as CORTEX_AGENT_LAB.RAW.RC_DIM_TAX primary key (TAX_ID) comment='Tax rates by region, 5-14%.',
    LOYALTY as CORTEX_AGENT_LAB.RAW.RC_DIM_LOYALTY primary key (LOYALTY_TIER_ID) with synonyms=('loyalty program','rewards tier') comment='5 loyalty tiers: Bronze/Silver/Gold/Platinum/Diamond with points thresholds.',
    EMPLOYEES as CORTEX_AGENT_LAB.RAW.RC_DIM_EMPLOYEE primary key (EMPLOYEE_ID) with synonyms=('staff','workers') comment='50 employees: Full-Time/Part-Time/Contractor, assigned to stores.'
  )
  relationships (
    SALES_TO_CUSTOMERS as SALES(CUSTOMER_ID) references CUSTOMERS(CUSTOMER_ID),
    SALES_TO_PRODUCTS as SALES(PRODUCT_ID) references PRODUCTS(PRODUCT_ID),
    SALES_TO_STORES as SALES(STORE_ID) references STORES(STORE_ID),
    SALES_TO_PROMOTIONS as SALES(PROMOTION_ID) references PROMOTIONS(PROMOTION_ID),
    SALES_TO_REPS as SALES(SALES_REP_ID) references SALES_REPS(SALES_REP_ID),
    SALES_TO_SUPPLIERS as SALES(SUPPLIER_ID) references SUPPLIERS(SUPPLIER_ID),
    SALES_TO_CHANNELS as SALES(CHANNEL_ID) references CHANNELS(CHANNEL_ID),
    SALES_TO_SEGMENTS as SALES(SEGMENT_ID) references SEGMENTS(SEGMENT_ID),
    SALES_TO_CATEGORIES as SALES(CATEGORY_ID) references CATEGORIES(CATEGORY_ID),
    SALES_TO_BRANDS as SALES(BRAND_ID) references BRANDS(BRAND_ID),
    SALES_TO_REGIONS as SALES(REGION_ID) references REGIONS(REGION_ID),
    SALES_TO_CURRENCIES as SALES(CURRENCY_ID) references CURRENCIES(CURRENCY_ID),
    SALES_TO_LOYALTY as SALES(LOYALTY_TIER_ID) references LOYALTY(LOYALTY_TIER_ID),
    SALES_TO_EMPLOYEES as SALES(EMPLOYEE_ID) references EMPLOYEES(EMPLOYEE_ID),
    RETURNS_TO_SALES as RETURNS(SALE_ID) references SALES(SALE_ID)
  )
  dimensions (
    SALES.SALE_DATE as sale_date with synonyms=('transaction date','purchase date','order date') comment='Date of the sale transaction (2022-01-01 to 2024-12-31)',
    SALES.DISCOUNT_RATE as discount_rate with synonyms=('discount','markdown','price reduction') comment='Discount applied to the transaction (0.00 to 0.30, i.e. 0-30%)',
    CUSTOMERS.CUSTOMER_NAME as customer_name comment='Customer name in format Customer_N (N=1 to 1000)',
    CUSTOMERS.CUSTOMER_TIER as customer_tier with synonyms=('loyalty tier','customer level','VIP status','membership level') comment='Customer classification: Gold, Silver, Bronze, or Standard',
    CUSTOMERS.CITY as city with synonyms=('location','metro') comment='Customer city: New York, LA, or Chicago',
    PRODUCTS.PRODUCT_NAME as product_name comment='Product name in format Product_N (N=1 to 500)',
    PRODUCTS.PRODUCT_TYPE as product_type with synonyms=('category','product category','department','product line') comment='Product classification: Electronics, Apparel, Home, or Sports',
    PRODUCTS.UNIT_PRICE as unit_price with synonyms=('price','list price') comment='Product unit price ($10 to $500)',
    STORES.STORE_NAME as store_name comment='Store name in format Store_N (N=1 to 50)',
    STORES.REGION as region with synonyms=('area','territory','geography','zone') comment='Store geographic region: North, South, East, or West',
    STORES.STORE_TYPE as store_type with synonyms=('location type','format','channel type') comment='Store format: Mall, Standalone, or Online',
    SALES_REPS.REP_NAME as rep_name with synonyms=('sales rep','salesperson','agent name') comment='Sales representative name (Rep_1 to Rep_20)',
    SALES_REPS.TERRITORY as territory with synonyms=('rep territory','assigned region') comment='Territory assignment: North, South, East, or West',
    SALES_REPS.LEVEL as level with synonyms=('seniority','experience level','rank') comment='Rep seniority: Senior, Mid, or Junior',
    SUPPLIERS.SUPPLIER_NAME as supplier_name with synonyms=('vendor name','manufacturer name'),
    SUPPLIERS.SUPPLIER_TYPE as supplier_type with synonyms=('vendor type','source type') comment='Domestic, International, or Regional',
    SHIPMENTS.SHIP_METHOD as ship_method with synonyms=('delivery method','shipping type','carrier') comment='Ground, Air, or Express',
    SHIPMENTS.SHIP_COST as ship_cost with synonyms=('shipping cost','delivery cost','freight') comment='Shipping cost per shipment ($5-$50)',
    RETURNS.RETURN_REASON as return_reason with synonyms=('send-back reason','refund reason') comment='Defective, Wrong item, Changed mind, or Other',
    CHANNELS.CHANNEL_NAME as channel_name with synonyms=('sales channel','distribution channel'),
    SEGMENTS.SEGMENT_NAME as segment_name with synonyms=('market segment','customer segment'),
    CATEGORIES.CATEGORY_NAME as category_name,
    BRANDS.BRAND_NAME as brand_name,
    BRANDS.BRAND_TIER as brand_tier with synonyms=('brand level','brand class') comment='Premium, Value, or Standard',
    REGIONS.REGION_NAME as region_name with synonyms=('geographic region'),
    CURRENCIES.CURRENCY_CODE as currency_code with synonyms=('currency'),
    LOYALTY.TIER_NAME as tier_name with synonyms=('loyalty tier','loyalty level','rewards level')
  )
  metrics (
    SALES.TOTAL_REVENUE as SUM(sale_amount) with synonyms=('revenue','total sales','gross revenue','bookings','income') comment='Sum of all sale amounts. Total across all 100k transactions is ~$25.5M.',
    SALES.AVG_SALE_VALUE as AVG(sale_amount) with synonyms=('average sale','avg transaction','average order value','AOV') comment='Average transaction amount (~$255)',
    SALES.TOTAL_SALES as COUNT(sale_id) with synonyms=('transaction count','number of sales','order count','volume') comment='Count of transactions (100,000 total)',
    SHIPMENTS.AVG_SHIP_COST as AVG(ship_cost) with synonyms=('average shipping','avg delivery cost') comment='Average shipping cost per shipment (~$27)',
    RETURNS.TOTAL_REFUNDS as SUM(refund_amount) with synonyms=('refund total','return value') comment='Total refund value across all returns (~$1.27M)'
  )
  comment='RetailCorp T20 RICH — extensive descriptions, synonyms, and sample values on every element. Tests if rich metadata helps accuracy.'