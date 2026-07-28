-- 01_topic_views.sql
-- Step 5: Create 4 topic semantic views from the 20 RetailCorp tables
-- Exported from live account with GET_DDL (canonical syntax)

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA SEMANTIC;

-- VIEW 1: Core Sales
create or replace semantic view RETAILCORP_CORE_SALES
	tables (
		SALES as CORTEX_AGENT_LAB.RAW.RC_FACT_SALES primary key (SALE_ID) with synonyms=('transactions','orders','purchases') comment='Core sales transactions',
		CUSTOMERS as CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER primary key (CUSTOMER_ID) with synonyms=('clients','buyers') comment='Customer reference data',
		PRODUCTS as CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT primary key (PRODUCT_ID) with synonyms=('items','goods') comment='Product reference data',
		DATES as CORTEX_AGENT_LAB.RAW.RC_DIM_DATE primary key (DATE_DAY) comment='Date dimension',
		STORES as CORTEX_AGENT_LAB.RAW.RC_DIM_STORE primary key (STORE_ID) with synonyms=('locations','branches') comment='Store locations'
	)
	relationships (
		SALES_TO_CUSTOMERS as SALES(CUSTOMER_ID) references CUSTOMERS(CUSTOMER_ID),
		SALES_TO_PRODUCTS as SALES(PRODUCT_ID) references PRODUCTS(PRODUCT_ID),
		SALES_TO_STORES as SALES(STORE_ID) references STORES(STORE_ID)
	)
	dimensions (
		SALES.SALE_DATE as sale_date with synonyms=('transaction date','purchase date'),
		SALES.DISCOUNT_RATE as discount_rate with synonyms=('discount','markdown'),
		CUSTOMERS.CUSTOMER_NAME as customer_name,
		CUSTOMERS.CUSTOMER_TIER as customer_tier with synonyms=('loyalty tier','customer level'),
		CUSTOMERS.CITY as city,
		PRODUCTS.PRODUCT_NAME as product_name,
		PRODUCTS.PRODUCT_TYPE as product_type with synonyms=('category','product category'),
		STORES.STORE_NAME as store_name,
		STORES.REGION as region with synonyms=('area','territory'),
		STORES.STORE_TYPE as store_type with synonyms=('location type')
	)
	metrics (
		SALES.TOTAL_REVENUE as SUM(sale_amount) with synonyms=('total sales','gross revenue','revenue') comment='Total revenue',
		SALES.AVG_SALE_VALUE as AVG(sale_amount) with synonyms=('average sale','avg transaction') comment='Average sale value',
		SALES.TOTAL_SALES as COUNT(sale_id) with synonyms=('number of sales','transaction count') comment='Total transactions'
	)
	comment='RetailCorp Core Sales — customers, products, stores, dates. Use for revenue/product/customer/store questions.';

-- VIEW 2: Logistics
create or replace semantic view RETAILCORP_LOGISTICS
	tables (
		SALES as CORTEX_AGENT_LAB.RAW.RC_FACT_SALES primary key (SALE_ID) comment='Sales fact for revenue context',
		SUPPLIERS as CORTEX_AGENT_LAB.RAW.RC_DIM_SUPPLIER primary key (SUPPLIER_ID) with synonyms=('vendors','manufacturers') comment='Supplier reference data',
		SHIPMENTS as CORTEX_AGENT_LAB.RAW.RC_DIM_SHIPMENT primary key (SHIPMENT_ID) comment='Shipment details',
		RETURNS as CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS primary key (RETURN_ID) with synonyms=('refunds','send-backs') comment='Product returns'
	)
	relationships (
		SALES_TO_SUPPLIERS as SALES(SUPPLIER_ID) references SUPPLIERS(SUPPLIER_ID),
		RETURNS_TO_SALES as RETURNS(SALE_ID) references SALES(SALE_ID)
	)
	dimensions (
		SALES.SALE_DATE as sale_date,
		SUPPLIERS.SUPPLIER_NAME as supplier_name with synonyms=('vendor name'),
		SUPPLIERS.SUPPLIER_TYPE as supplier_type with synonyms=('vendor type'),
		SUPPLIERS.REGION as region,
		SHIPMENTS.SHIP_METHOD as ship_method with synonyms=('delivery method','shipping method'),
		SHIPMENTS.TRANSIT_DAYS as transit_days,
		RETURNS.RETURN_REASON as return_reason with synonyms=('send-back reason')
	)
	metrics (
		SALES.TOTAL_REVENUE as SUM(sale_amount) with synonyms=('revenue') comment='Revenue for context',
		SHIPMENTS.AVG_SHIP_COST as AVG(ship_cost) with synonyms=('shipping cost','delivery cost') comment='Average shipping cost',
		RETURNS.TOTAL_REFUNDS as SUM(refund_amount) with synonyms=('refund total') comment='Total refund value',
		RETURNS.RETURN_COUNT as COUNT(return_id) comment='Number of returns'
	)
	comment='RetailCorp Logistics — suppliers, shipments, returns. Use for shipping/supplier/return questions.';

-- VIEW 3: Promotions & Channels
create or replace semantic view RETAILCORP_PROMOTIONS
	tables (
		SALES as CORTEX_AGENT_LAB.RAW.RC_FACT_SALES primary key (SALE_ID) comment='Sales fact',
		PROMOTIONS as CORTEX_AGENT_LAB.RAW.RC_DIM_PROMOTION primary key (PROMOTION_ID) comment='Promotion details',
		CHANNELS as CORTEX_AGENT_LAB.RAW.RC_DIM_CHANNEL primary key (CHANNEL_ID) comment='Sales channels',
		SEGMENTS as CORTEX_AGENT_LAB.RAW.RC_DIM_SEGMENT primary key (SEGMENT_ID) with synonyms=('market segments') comment='Customer segments',
		CATEGORIES as CORTEX_AGENT_LAB.RAW.RC_DIM_CATEGORY primary key (CATEGORY_ID) comment='Product categories',
		DATES as CORTEX_AGENT_LAB.RAW.RC_DIM_DATE primary key (DATE_DAY) comment='Date dimension'
	)
	relationships (
		SALES_TO_CATEGORIES as SALES(CATEGORY_ID) references CATEGORIES(CATEGORY_ID),
		SALES_TO_CHANNELS as SALES(CHANNEL_ID) references CHANNELS(CHANNEL_ID),
		SALES_TO_PROMOTIONS as SALES(PROMOTION_ID) references PROMOTIONS(PROMOTION_ID),
		SALES_TO_SEGMENTS as SALES(SEGMENT_ID) references SEGMENTS(SEGMENT_ID)
	)
	dimensions (
		SALES.SALE_DATE as sale_date,
		PROMOTIONS.PROMOTION_NAME as promotion_name with synonyms=('promo'),
		PROMOTIONS.PROMOTION_TYPE as promotion_type with synonyms=('promo type'),
		PROMOTIONS.DISCOUNT_PCT as discount_pct,
		CHANNELS.CHANNEL_NAME as channel_name with synonyms=('sales channel'),
		SEGMENTS.SEGMENT_NAME as segment_name with synonyms=('market segment'),
		CATEGORIES.CATEGORY_NAME as category_name,
		CATEGORIES.DEPARTMENT as department,
		DATES.YEAR as year,
		DATES.MONTH as month,
		DATES.QUARTER as quarter
	)
	metrics (
		SALES.TOTAL_REVENUE as SUM(sale_amount) with synonyms=('revenue','bookings') comment='Total revenue',
		SALES.TOTAL_SALES as COUNT(sale_id) comment='Transaction count',
		SALES.AVG_DISCOUNT as AVG(discount_rate) comment='Average discount rate'
	)
	comment='RetailCorp Promotions & Channels — promotions, channels, segments, categories.';

-- VIEW 4: Geography & Organization
create or replace semantic view RETAILCORP_GEO_ORG
	tables (
		SALES as CORTEX_AGENT_LAB.RAW.RC_FACT_SALES primary key (SALE_ID) comment='Sales fact',
		REGIONS as CORTEX_AGENT_LAB.RAW.RC_DIM_REGION primary key (REGION_ID) comment='Regions',
		BRANDS as CORTEX_AGENT_LAB.RAW.RC_DIM_BRAND primary key (BRAND_ID) comment='Brands',
		CURRENCIES as CORTEX_AGENT_LAB.RAW.RC_DIM_CURRENCY primary key (CURRENCY_ID) comment='Currencies',
		LOYALTY as CORTEX_AGENT_LAB.RAW.RC_DIM_LOYALTY primary key (LOYALTY_TIER_ID) comment='Loyalty tiers',
		SALES_REPS as CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP primary key (SALES_REP_ID) with synonyms=('reps') comment='Sales representatives',
		DATES as CORTEX_AGENT_LAB.RAW.RC_DIM_DATE primary key (DATE_DAY) comment='Date dimension'
	)
	relationships (
		SALES_TO_BRANDS as SALES(BRAND_ID) references BRANDS(BRAND_ID),
		SALES_TO_CURRENCIES as SALES(CURRENCY_ID) references CURRENCIES(CURRENCY_ID),
		SALES_TO_LOYALTY as SALES(LOYALTY_TIER_ID) references LOYALTY(LOYALTY_TIER_ID),
		SALES_TO_REGIONS as SALES(REGION_ID) references REGIONS(REGION_ID),
		SALES_TO_REPS as SALES(SALES_REP_ID) references SALES_REPS(SALES_REP_ID)
	)
	dimensions (
		SALES.SALE_DATE as sale_date,
		REGIONS.REGION_NAME as region_name with synonyms=('region','geo','area'),
		BRANDS.BRAND_NAME as brand_name,
		BRANDS.BRAND_TIER as brand_tier,
		CURRENCIES.CURRENCY_CODE as currency_code with synonyms=('currency'),
		CURRENCIES.EXCHANGE_RATE as exchange_rate,
		LOYALTY.TIER_NAME as tier_name with synonyms=('loyalty tier','loyalty level'),
		LOYALTY.POINTS_REQUIRED as points_required,
		SALES_REPS.REP_NAME as rep_name with synonyms=('sales rep'),
		SALES_REPS.TERRITORY as territory,
		SALES_REPS.LEVEL as level with synonyms=('seniority','rep level'),
		DATES.YEAR as year,
		DATES.MONTH as month,
		DATES.QUARTER as quarter
	)
	metrics (
		SALES.TOTAL_REVENUE as SUM(sale_amount) with synonyms=('revenue','bookings') comment='Total revenue',
		SALES.TOTAL_SALES as COUNT(sale_id) comment='Transaction count'
	)
	comment='RetailCorp Geography & Org — regions, brands, currencies, loyalty, sales reps.';
