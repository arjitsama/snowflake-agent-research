-- 03_t40_view.sql
-- T40 semantic view: T20 tables + 20 distractor dimensions (disconnected from fact)
-- Exported from live account with GET_DDL

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA SEMANTIC;

create or replace semantic view RETAILCORP_T40
	tables (
		SALES as CORTEX_AGENT_LAB.RAW.RC_FACT_SALES primary key (SALE_ID) comment='Core sales',
		CUSTOMERS as CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER primary key (CUSTOMER_ID) comment='Customers',
		PRODUCTS as CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT primary key (PRODUCT_ID) comment='Products',
		DATES as CORTEX_AGENT_LAB.RAW.RC_DIM_DATE primary key (DATE_DAY) comment='Dates',
		STORES as CORTEX_AGENT_LAB.RAW.RC_DIM_STORE primary key (STORE_ID) comment='Stores',
		PROMOTIONS as CORTEX_AGENT_LAB.RAW.RC_DIM_PROMOTION primary key (PROMOTION_ID) comment='Promotions',
		SALES_REPS as CORTEX_AGENT_LAB.RAW.RC_DIM_SALES_REP primary key (SALES_REP_ID) comment='Sales reps',
		SUPPLIERS as CORTEX_AGENT_LAB.RAW.RC_DIM_SUPPLIER primary key (SUPPLIER_ID) comment='Suppliers',
		SHIPMENTS as CORTEX_AGENT_LAB.RAW.RC_DIM_SHIPMENT primary key (SHIPMENT_ID) comment='Shipments',
		RETURNS as CORTEX_AGENT_LAB.RAW.RC_DIM_RETURNS primary key (RETURN_ID) comment='Returns',
		INVENTORY as CORTEX_AGENT_LAB.RAW.RC_DIM_INVENTORY primary key (INVENTORY_ID) comment='Inventory',
		CHANNELS as CORTEX_AGENT_LAB.RAW.RC_DIM_CHANNEL primary key (CHANNEL_ID) comment='Channels',
		SEGMENTS as CORTEX_AGENT_LAB.RAW.RC_DIM_SEGMENT primary key (SEGMENT_ID) comment='Segments',
		CATEGORIES as CORTEX_AGENT_LAB.RAW.RC_DIM_CATEGORY primary key (CATEGORY_ID) comment='Categories',
		BRANDS as CORTEX_AGENT_LAB.RAW.RC_DIM_BRAND primary key (BRAND_ID) comment='Brands',
		REGIONS as CORTEX_AGENT_LAB.RAW.RC_DIM_REGION primary key (REGION_ID) comment='Regions',
		CURRENCIES as CORTEX_AGENT_LAB.RAW.RC_DIM_CURRENCY primary key (CURRENCY_ID) comment='Currencies',
		TAX as CORTEX_AGENT_LAB.RAW.RC_DIM_TAX primary key (TAX_ID) comment='Tax',
		LOYALTY as CORTEX_AGENT_LAB.RAW.RC_DIM_LOYALTY primary key (LOYALTY_TIER_ID) comment='Loyalty',
		EMPLOYEES as CORTEX_AGENT_LAB.RAW.RC_DIM_EMPLOYEE primary key (EMPLOYEE_ID) comment='Employees',
		WARRANTY as CORTEX_AGENT_LAB.RAW.RC_DIM_WARRANTY primary key (WARRANTY_ID) comment='Warranties',
		GIFT_CARDS as CORTEX_AGENT_LAB.RAW.RC_DIM_GIFT_CARD primary key (GIFT_CARD_ID) comment='Gift cards',
		PAYMENT_METHODS as CORTEX_AGENT_LAB.RAW.RC_DIM_PAYMENT_METHOD primary key (PAYMENT_METHOD_ID) comment='Payment methods',
		DELIVERY_ZONES as CORTEX_AGENT_LAB.RAW.RC_DIM_DELIVERY_ZONE primary key (ZONE_ID) comment='Delivery zones',
		SEASONS as CORTEX_AGENT_LAB.RAW.RC_DIM_SEASON primary key (SEASON_ID) comment='Seasons',
		MKT_CHANNELS as CORTEX_AGENT_LAB.RAW.RC_DIM_MARKETING_CHANNEL primary key (MKT_CHANNEL_ID) comment='Marketing channels',
		CUSTOMER_SOURCES as CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER_SOURCE primary key (SOURCE_ID) comment='Customer sources',
		RETURN_POLICIES as CORTEX_AGENT_LAB.RAW.RC_DIM_RETURN_POLICY primary key (POLICY_ID) comment='Return policies',
		PACKAGING as CORTEX_AGENT_LAB.RAW.RC_DIM_PACKAGING primary key (PACKAGING_ID) comment='Packaging',
		WEATHER as CORTEX_AGENT_LAB.RAW.RC_DIM_WEATHER primary key (WEATHER_ID) comment='Weather',
		COMPETITORS as CORTEX_AGENT_LAB.RAW.RC_DIM_COMPETITOR primary key (COMPETITOR_ID) comment='Competitors',
		COLORS as CORTEX_AGENT_LAB.RAW.RC_DIM_PRODUCT_COLOR primary key (COLOR_ID) comment='Colors',
		SIZES as CORTEX_AGENT_LAB.RAW.RC_DIM_SIZE primary key (SIZE_ID) comment='Sizes',
		VENDOR_RATINGS as CORTEX_AGENT_LAB.RAW.RC_DIM_VENDOR_RATING primary key (RATING_ID) comment='Vendor ratings',
		STORE_HOURS as CORTEX_AGENT_LAB.RAW.RC_DIM_STORE_HOURS primary key (HOURS_ID) comment='Store hours',
		MEMBERSHIPS as CORTEX_AGENT_LAB.RAW.RC_DIM_MEMBERSHIP primary key (MEMBERSHIP_ID) comment='Memberships',
		CAMPAIGNS as CORTEX_AGENT_LAB.RAW.RC_DIM_CAMPAIGN primary key (CAMPAIGN_ID) comment='Campaigns',
		COUPONS as CORTEX_AGENT_LAB.RAW.RC_DIM_COUPON primary key (COUPON_ID) comment='Coupons',
		SHELF_LOCATIONS as CORTEX_AGENT_LAB.RAW.RC_DIM_SHELF_LOCATION primary key (SHELF_ID) comment='Shelf locations',
		FEEDBACK as CORTEX_AGENT_LAB.RAW.RC_DIM_CUSTOMER_FEEDBACK primary key (FEEDBACK_ID) comment='Customer feedback'
	)
	relationships (
		SALES_TO_BRANDS as SALES(BRAND_ID) references BRANDS(BRAND_ID),
		SALES_TO_CATEGORIES as SALES(CATEGORY_ID) references CATEGORIES(CATEGORY_ID),
		SALES_TO_CHANNELS as SALES(CHANNEL_ID) references CHANNELS(CHANNEL_ID),
		SALES_TO_CURRENCIES as SALES(CURRENCY_ID) references CURRENCIES(CURRENCY_ID),
		SALES_TO_CUSTOMERS as SALES(CUSTOMER_ID) references CUSTOMERS(CUSTOMER_ID),
		SALES_TO_EMPLOYEES as SALES(EMPLOYEE_ID) references EMPLOYEES(EMPLOYEE_ID),
		SALES_TO_LOYALTY as SALES(LOYALTY_TIER_ID) references LOYALTY(LOYALTY_TIER_ID),
		SALES_TO_PRODUCTS as SALES(PRODUCT_ID) references PRODUCTS(PRODUCT_ID),
		SALES_TO_PROMOTIONS as SALES(PROMOTION_ID) references PROMOTIONS(PROMOTION_ID),
		SALES_TO_REGIONS as SALES(REGION_ID) references REGIONS(REGION_ID),
		SALES_TO_REPS as SALES(SALES_REP_ID) references SALES_REPS(SALES_REP_ID),
		SALES_TO_SEGMENTS as SALES(SEGMENT_ID) references SEGMENTS(SEGMENT_ID),
		SALES_TO_STORES as SALES(STORE_ID) references STORES(STORE_ID),
		SALES_TO_SUPPLIERS as SALES(SUPPLIER_ID) references SUPPLIERS(SUPPLIER_ID),
		RETURNS_TO_SALES as RETURNS(SALE_ID) references SALES(SALE_ID)
	)
	dimensions (
		SALES.SALE_DATE as sale_date,
		SALES.DISCOUNT_RATE as discount_rate,
		CUSTOMERS.CUSTOMER_NAME as customer_name,
		CUSTOMERS.CUSTOMER_TIER as customer_tier,
		PRODUCTS.PRODUCT_NAME as product_name,
		PRODUCTS.PRODUCT_TYPE as product_type,
		STORES.STORE_NAME as store_name,
		STORES.REGION as region,
		STORES.STORE_TYPE as store_type,
		SALES_REPS.REP_NAME as rep_name,
		SALES_REPS.TERRITORY as territory,
		SALES_REPS.LEVEL as level,
		SUPPLIERS.SUPPLIER_NAME as supplier_name,
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
		LOYALTY.TIER_NAME as tier_name,
		WARRANTY.WARRANTY_TYPE as warranty_type,
		GIFT_CARDS.CARD_TYPE as card_type,
		PAYMENT_METHODS.METHOD_NAME as method_name,
		DELIVERY_ZONES.ZONE_TYPE as zone_type,
		SEASONS.SEASON_NAME as season_name,
		COMPETITORS.COMPETITOR_NAME as competitor_name,
		COLORS.COLOR_NAME as color_name,
		SIZES.SIZE_CODE as size_code
	)
	metrics (
		SALES.TOTAL_REVENUE as SUM(sale_amount) with synonyms=('revenue','total sales') comment='Total revenue',
		SALES.AVG_SALE as AVG(sale_amount) comment='Average sale',
		SALES.TOTAL_SALES as COUNT(sale_id) comment='Transaction count',
		SHIPMENTS.AVG_SHIP_COST as AVG(ship_cost) comment='Shipping cost',
		RETURNS.TOTAL_REFUNDS as SUM(refund_amount) comment='Total refunds'
	)
	comment='RetailCorp T40 — 40 tables total (T20 + 20 distractor dimensions).';

-- NOTE: The 20 distractor tables (WARRANTY through FEEDBACK) have NO relationships
-- to the fact table. They are "disconnected islands" that bloat the agent's context
-- but cannot be joined to sales data. This is a known limitation noted in Fix 6.
