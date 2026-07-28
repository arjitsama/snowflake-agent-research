-- 19_extended_data.sql
-- Step 6: Generate additional dimension tables for T40 and T80
-- These are distractor tables - the 27 T5-only test questions don't need them
-- T40 = T20 + 20 new tables
-- T80 = T40 + 40 more tables (60 new total beyond T20)
--
-- All tables follow the same pattern: small dimension tables with 10-100 rows
-- connected to RC_FACT_SALES via MOD-based FK columns

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA RAW;

-- ============================================
-- T40 ADDITIONAL TABLES (adds 20 beyond T20)
-- ============================================

CREATE OR REPLACE TABLE RC_DIM_WARRANTY AS
SELECT SEQ4()+1 AS warranty_id, 'Warranty_'||(SEQ4()+1) AS warranty_name, 
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Basic' WHEN 1 THEN 'Extended' ELSE 'Premium' END AS warranty_type,
  MOD(SEQ4(),5)+1 AS duration_years
FROM TABLE(GENERATOR(ROWCOUNT => 10));

CREATE OR REPLACE TABLE RC_DIM_GIFT_CARD AS
SELECT SEQ4()+1 AS gift_card_id, 'GC_'||(SEQ4()+1) AS card_code,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'Physical' WHEN 1 THEN 'Digital' WHEN 2 THEN 'Corporate' ELSE 'Promo' END AS card_type,
  (MOD(SEQ4(),10)+1)*25 AS face_value
FROM TABLE(GENERATOR(ROWCOUNT => 20));

CREATE OR REPLACE TABLE RC_DIM_PAYMENT_METHOD AS
SELECT SEQ4()+1 AS payment_method_id, 
  CASE SEQ4() WHEN 0 THEN 'Credit Card' WHEN 1 THEN 'Debit Card' WHEN 2 THEN 'Cash' WHEN 3 THEN 'Wire Transfer' WHEN 4 THEN 'PayPal' ELSE 'Crypto' END AS method_name,
  CASE MOD(SEQ4(),2) WHEN 0 THEN 'Digital' ELSE 'Physical' END AS method_category
FROM TABLE(GENERATOR(ROWCOUNT => 6));

CREATE OR REPLACE TABLE RC_DIM_DELIVERY_ZONE AS
SELECT SEQ4()+1 AS zone_id, 'Zone_'||(SEQ4()+1) AS zone_name,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Urban' WHEN 1 THEN 'Suburban' ELSE 'Rural' END AS zone_type,
  MOD(SEQ4(),5)+1 AS delivery_days_estimate
FROM TABLE(GENERATOR(ROWCOUNT => 15));

CREATE OR REPLACE TABLE RC_DIM_SEASON AS
SELECT SEQ4()+1 AS season_id,
  CASE SEQ4() WHEN 0 THEN 'Spring' WHEN 1 THEN 'Summer' WHEN 2 THEN 'Fall' ELSE 'Winter' END AS season_name,
  CASE MOD(SEQ4(),2) WHEN 0 THEN 'Peak' ELSE 'Off-Peak' END AS demand_level
FROM TABLE(GENERATOR(ROWCOUNT => 4));

CREATE OR REPLACE TABLE RC_DIM_MARKETING_CHANNEL AS
SELECT SEQ4()+1 AS mkt_channel_id,
  CASE SEQ4() WHEN 0 THEN 'TV' WHEN 1 THEN 'Radio' WHEN 2 THEN 'Social Media' WHEN 3 THEN 'Print' WHEN 4 THEN 'Email' WHEN 5 THEN 'Billboard' WHEN 6 THEN 'Podcast' ELSE 'Influencer' END AS channel_name,
  ROUND(ABS(RANDOM(200))/1e16*1000+100, 2) AS cost_per_impression
FROM TABLE(GENERATOR(ROWCOUNT => 8));

CREATE OR REPLACE TABLE RC_DIM_CUSTOMER_SOURCE AS
SELECT SEQ4()+1 AS source_id,
  CASE MOD(SEQ4(),6) WHEN 0 THEN 'Organic' WHEN 1 THEN 'Referral' WHEN 2 THEN 'Paid Search' WHEN 3 THEN 'Social' WHEN 4 THEN 'Direct' ELSE 'Affiliate' END AS source_name,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'High' WHEN 1 THEN 'Medium' ELSE 'Low' END AS quality_tier
FROM TABLE(GENERATOR(ROWCOUNT => 12));

CREATE OR REPLACE TABLE RC_DIM_RETURN_POLICY AS
SELECT SEQ4()+1 AS policy_id, 'Policy_'||(SEQ4()+1) AS policy_name,
  MOD(SEQ4(),4)*7+7 AS return_window_days,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Full Refund' WHEN 1 THEN 'Store Credit' ELSE 'Exchange Only' END AS refund_type
FROM TABLE(GENERATOR(ROWCOUNT => 8));

CREATE OR REPLACE TABLE RC_DIM_PACKAGING AS
SELECT SEQ4()+1 AS packaging_id,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'Standard Box' WHEN 1 THEN 'Padded Envelope' WHEN 2 THEN 'Custom Box' ELSE 'Eco-Friendly' END AS packaging_type,
  ROUND(ABS(RANDOM(201))/1e16*5+0.5, 2) AS packaging_cost
FROM TABLE(GENERATOR(ROWCOUNT => 10));

CREATE OR REPLACE TABLE RC_DIM_WEATHER AS
SELECT SEQ4()+1 AS weather_id,
  CASE MOD(SEQ4(),5) WHEN 0 THEN 'Sunny' WHEN 1 THEN 'Rainy' WHEN 2 THEN 'Snowy' WHEN 3 THEN 'Cloudy' ELSE 'Windy' END AS condition,
  MOD(SEQ4(),40)+40 AS temperature_f
FROM TABLE(GENERATOR(ROWCOUNT => 20));

CREATE OR REPLACE TABLE RC_DIM_COMPETITOR AS
SELECT SEQ4()+1 AS competitor_id, 'Competitor_'||(SEQ4()+1) AS competitor_name,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Direct' WHEN 1 THEN 'Indirect' ELSE 'Substitute' END AS competitor_type,
  ROUND(ABS(RANDOM(202))/1e16*100, 2) AS market_share_pct
FROM TABLE(GENERATOR(ROWCOUNT => 15));

CREATE OR REPLACE TABLE RC_DIM_PRODUCT_COLOR AS
SELECT SEQ4()+1 AS color_id,
  CASE MOD(SEQ4(),10) WHEN 0 THEN 'Red' WHEN 1 THEN 'Blue' WHEN 2 THEN 'Green' WHEN 3 THEN 'Black' WHEN 4 THEN 'White' WHEN 5 THEN 'Silver' WHEN 6 THEN 'Gold' WHEN 7 THEN 'Pink' WHEN 8 THEN 'Purple' ELSE 'Orange' END AS color_name,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Neutral' WHEN 1 THEN 'Warm' ELSE 'Cool' END AS color_family
FROM TABLE(GENERATOR(ROWCOUNT => 10));

CREATE OR REPLACE TABLE RC_DIM_SIZE AS
SELECT SEQ4()+1 AS size_id,
  CASE MOD(SEQ4(),6) WHEN 0 THEN 'XS' WHEN 1 THEN 'S' WHEN 2 THEN 'M' WHEN 3 THEN 'L' WHEN 4 THEN 'XL' ELSE 'XXL' END AS size_code,
  SEQ4()+1 AS size_order
FROM TABLE(GENERATOR(ROWCOUNT => 6));

CREATE OR REPLACE TABLE RC_DIM_VENDOR_RATING AS
SELECT SEQ4()+1 AS rating_id, MOD(SEQ4(),100)+1 AS supplier_id,
  ROUND(ABS(RANDOM(203))/1e16*4+1, 1) AS rating_score,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'Q1' WHEN 1 THEN 'Q2' WHEN 2 THEN 'Q3' ELSE 'Q4' END AS review_quarter
FROM TABLE(GENERATOR(ROWCOUNT => 50));

CREATE OR REPLACE TABLE RC_DIM_STORE_HOURS AS
SELECT SEQ4()+1 AS hours_id, MOD(SEQ4(),50)+1 AS store_id,
  CASE MOD(SEQ4(),2) WHEN 0 THEN 'Weekday' ELSE 'Weekend' END AS day_type,
  8+MOD(SEQ4(),3) AS open_hour, 18+MOD(SEQ4(),4) AS close_hour
FROM TABLE(GENERATOR(ROWCOUNT => 50));

CREATE OR REPLACE TABLE RC_DIM_MEMBERSHIP AS
SELECT SEQ4()+1 AS membership_id,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'Free' WHEN 1 THEN 'Basic' WHEN 2 THEN 'Premium' ELSE 'VIP' END AS tier,
  (MOD(SEQ4(),4))*29.99 AS monthly_fee,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Monthly' WHEN 1 THEN 'Annual' ELSE 'Lifetime' END AS billing_cycle
FROM TABLE(GENERATOR(ROWCOUNT => 8));

CREATE OR REPLACE TABLE RC_DIM_CAMPAIGN AS
SELECT SEQ4()+1 AS campaign_id, 'Campaign_'||(SEQ4()+1) AS campaign_name,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'Email' WHEN 1 THEN 'SMS' WHEN 2 THEN 'Push' ELSE 'Retargeting' END AS campaign_type,
  DATEADD(DAY, MOD(SEQ4(),365), '2023-01-01') AS start_date,
  ROUND(ABS(RANDOM(204))/1e16*50000+1000, 2) AS budget
FROM TABLE(GENERATOR(ROWCOUNT => 25));

CREATE OR REPLACE TABLE RC_DIM_COUPON AS
SELECT SEQ4()+1 AS coupon_id, 'COUPON'||LPAD(SEQ4()+1,4,'0') AS coupon_code,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Percentage' WHEN 1 THEN 'Fixed Amount' ELSE 'Free Shipping' END AS discount_type,
  MOD(SEQ4(),50)+5 AS discount_value
FROM TABLE(GENERATOR(ROWCOUNT => 30));

CREATE OR REPLACE TABLE RC_DIM_SHELF_LOCATION AS
SELECT SEQ4()+1 AS shelf_id, 'Aisle_'||MOD(SEQ4(),10) AS aisle,
  'Shelf_'||MOD(SEQ4(),5) AS shelf_position,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Eye Level' WHEN 1 THEN 'Top' ELSE 'Bottom' END AS placement
FROM TABLE(GENERATOR(ROWCOUNT => 40));

CREATE OR REPLACE TABLE RC_DIM_CUSTOMER_FEEDBACK AS
SELECT SEQ4()+1 AS feedback_id, MOD(SEQ4(),1000)+1 AS customer_id,
  MOD(SEQ4(),5)+1 AS rating,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'Product Quality' WHEN 1 THEN 'Shipping Speed' WHEN 2 THEN 'Customer Service' ELSE 'Value for Money' END AS category
FROM TABLE(GENERATOR(ROWCOUNT => 100));

-- ============================================
-- T80 ADDITIONAL TABLES (adds 40 more beyond T40, 60 total beyond T20)
-- ============================================

CREATE OR REPLACE TABLE RC_DIM_SUPPLIER_CONTRACT AS
SELECT SEQ4()+1 AS contract_id, MOD(SEQ4(),100)+1 AS supplier_id,
  DATEADD(DAY, MOD(SEQ4(),730), '2022-01-01') AS contract_start,
  MOD(SEQ4(),3)+1 AS contract_years,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Fixed' WHEN 1 THEN 'Variable' ELSE 'Tiered' END AS pricing_model
FROM TABLE(GENERATOR(ROWCOUNT => 50));

CREATE OR REPLACE TABLE RC_DIM_INSURANCE AS
SELECT SEQ4()+1 AS insurance_id,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'Shipping' WHEN 1 THEN 'Product' WHEN 2 THEN 'Liability' ELSE 'Theft' END AS insurance_type,
  ROUND(ABS(RANDOM(205))/1e16*100+10, 2) AS premium_amount
FROM TABLE(GENERATOR(ROWCOUNT => 8));

CREATE OR REPLACE TABLE RC_DIM_PRODUCT_MATERIAL AS
SELECT SEQ4()+1 AS material_id,
  CASE MOD(SEQ4(),8) WHEN 0 THEN 'Cotton' WHEN 1 THEN 'Polyester' WHEN 2 THEN 'Metal' WHEN 3 THEN 'Plastic' WHEN 4 THEN 'Wood' WHEN 5 THEN 'Glass' WHEN 6 THEN 'Leather' ELSE 'Silicone' END AS material_name,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Recycled' WHEN 1 THEN 'Organic' ELSE 'Standard' END AS sustainability
FROM TABLE(GENERATOR(ROWCOUNT => 12));

CREATE OR REPLACE TABLE RC_DIM_PRODUCT_WEIGHT AS
SELECT SEQ4()+1 AS weight_class_id,
  CASE MOD(SEQ4(),5) WHEN 0 THEN 'Featherweight' WHEN 1 THEN 'Light' WHEN 2 THEN 'Medium' WHEN 3 THEN 'Heavy' ELSE 'Oversized' END AS weight_class,
  MOD(SEQ4(),50)+1 AS max_lbs
FROM TABLE(GENERATOR(ROWCOUNT => 5));

CREATE OR REPLACE TABLE RC_DIM_AGE_GROUP AS
SELECT SEQ4()+1 AS age_group_id,
  CASE MOD(SEQ4(),6) WHEN 0 THEN '18-24' WHEN 1 THEN '25-34' WHEN 2 THEN '35-44' WHEN 3 THEN '45-54' WHEN 4 THEN '55-64' ELSE '65+' END AS age_range,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Young' WHEN 1 THEN 'Middle' ELSE 'Senior' END AS generation
FROM TABLE(GENERATOR(ROWCOUNT => 6));

CREATE OR REPLACE TABLE RC_DIM_INCOME_BRACKET AS
SELECT SEQ4()+1 AS bracket_id,
  CASE MOD(SEQ4(),5) WHEN 0 THEN 'Under 30K' WHEN 1 THEN '30K-60K' WHEN 2 THEN '60K-100K' WHEN 3 THEN '100K-200K' ELSE 'Over 200K' END AS bracket_name,
  (MOD(SEQ4(),5)+1)*30000 AS bracket_midpoint
FROM TABLE(GENERATOR(ROWCOUNT => 5));

CREATE OR REPLACE TABLE RC_DIM_EDUCATION AS
SELECT SEQ4()+1 AS education_id,
  CASE MOD(SEQ4(),5) WHEN 0 THEN 'High School' WHEN 1 THEN 'Associates' WHEN 2 THEN 'Bachelors' WHEN 3 THEN 'Masters' ELSE 'Doctorate' END AS level,
  SEQ4()+1 AS sort_order
FROM TABLE(GENERATOR(ROWCOUNT => 5));

CREATE OR REPLACE TABLE RC_DIM_DEVICE_TYPE AS
SELECT SEQ4()+1 AS device_id,
  CASE MOD(SEQ4(),5) WHEN 0 THEN 'Desktop' WHEN 1 THEN 'Mobile' WHEN 2 THEN 'Tablet' WHEN 3 THEN 'Smart TV' ELSE 'Kiosk' END AS device_type,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'iOS' WHEN 1 THEN 'Android' ELSE 'Windows' END AS os
FROM TABLE(GENERATOR(ROWCOUNT => 10));

CREATE OR REPLACE TABLE RC_DIM_BROWSER AS
SELECT SEQ4()+1 AS browser_id,
  CASE MOD(SEQ4(),5) WHEN 0 THEN 'Chrome' WHEN 1 THEN 'Safari' WHEN 2 THEN 'Firefox' WHEN 3 THEN 'Edge' ELSE 'Other' END AS browser_name,
  'v'||TO_VARCHAR(MOD(SEQ4(),20)+100) AS version
FROM TABLE(GENERATOR(ROWCOUNT => 10));

CREATE OR REPLACE TABLE RC_DIM_REFERRAL_SOURCE AS
SELECT SEQ4()+1 AS referral_id,
  CASE MOD(SEQ4(),6) WHEN 0 THEN 'Google' WHEN 1 THEN 'Facebook' WHEN 2 THEN 'Instagram' WHEN 3 THEN 'TikTok' WHEN 4 THEN 'Twitter' ELSE 'LinkedIn' END AS platform,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Organic' WHEN 1 THEN 'Paid' ELSE 'Referral' END AS traffic_type
FROM TABLE(GENERATOR(ROWCOUNT => 12));

CREATE OR REPLACE TABLE RC_DIM_STORE_DEPARTMENT AS
SELECT SEQ4()+1 AS dept_id, MOD(SEQ4(),50)+1 AS store_id,
  CASE MOD(SEQ4(),5) WHEN 0 THEN 'Electronics' WHEN 1 THEN 'Clothing' WHEN 2 THEN 'Home' WHEN 3 THEN 'Sports' ELSE 'Food' END AS department_name,
  MOD(SEQ4(),20)+5 AS staff_count
FROM TABLE(GENERATOR(ROWCOUNT => 100));

CREATE OR REPLACE TABLE RC_DIM_HOLIDAY AS
SELECT SEQ4()+1 AS holiday_id,
  CASE MOD(SEQ4(),8) WHEN 0 THEN 'Christmas' WHEN 1 THEN 'Black Friday' WHEN 2 THEN 'Cyber Monday' WHEN 3 THEN 'Valentines' WHEN 4 THEN 'Easter' WHEN 5 THEN 'July 4th' WHEN 6 THEN 'Labor Day' ELSE 'Thanksgiving' END AS holiday_name,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'High' WHEN 1 THEN 'Medium' ELSE 'Low' END AS sales_impact
FROM TABLE(GENERATOR(ROWCOUNT => 8));

CREATE OR REPLACE TABLE RC_DIM_SHIPPING_CARRIER AS
SELECT SEQ4()+1 AS carrier_id,
  CASE MOD(SEQ4(),6) WHEN 0 THEN 'FedEx' WHEN 1 THEN 'UPS' WHEN 2 THEN 'USPS' WHEN 3 THEN 'DHL' WHEN 4 THEN 'Amazon' ELSE 'OnTrac' END AS carrier_name,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Premium' WHEN 1 THEN 'Standard' ELSE 'Economy' END AS service_level
FROM TABLE(GENERATOR(ROWCOUNT => 12));

CREATE OR REPLACE TABLE RC_DIM_COMPLAINT_TYPE AS
SELECT SEQ4()+1 AS complaint_id,
  CASE MOD(SEQ4(),6) WHEN 0 THEN 'Product Defect' WHEN 1 THEN 'Late Delivery' WHEN 2 THEN 'Wrong Item' WHEN 3 THEN 'Poor Service' WHEN 4 THEN 'Billing Error' ELSE 'Website Issue' END AS complaint_type,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Critical' WHEN 1 THEN 'High' ELSE 'Low' END AS severity
FROM TABLE(GENERATOR(ROWCOUNT => 10));

CREATE OR REPLACE TABLE RC_DIM_SUBSCRIPTION AS
SELECT SEQ4()+1 AS subscription_id,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'Monthly Box' WHEN 1 THEN 'Quarterly Box' WHEN 2 THEN 'Annual Plan' ELSE 'Trial' END AS plan_type,
  ROUND(ABS(RANDOM(206))/1e16*100+9.99, 2) AS price,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Active' WHEN 1 THEN 'Paused' ELSE 'Cancelled' END AS status
FROM TABLE(GENERATOR(ROWCOUNT => 20));

CREATE OR REPLACE TABLE RC_DIM_SOCIAL_PLATFORM AS
SELECT SEQ4()+1 AS platform_id,
  CASE MOD(SEQ4(),7) WHEN 0 THEN 'Instagram' WHEN 1 THEN 'TikTok' WHEN 2 THEN 'Facebook' WHEN 3 THEN 'Twitter' WHEN 4 THEN 'YouTube' WHEN 5 THEN 'Pinterest' ELSE 'Reddit' END AS platform_name,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Visual' WHEN 1 THEN 'Video' ELSE 'Text' END AS content_type
FROM TABLE(GENERATOR(ROWCOUNT => 7));

CREATE OR REPLACE TABLE RC_DIM_INFLUENCER AS
SELECT SEQ4()+1 AS influencer_id, 'Influencer_'||(SEQ4()+1) AS name,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'Mega' WHEN 1 THEN 'Macro' WHEN 2 THEN 'Micro' ELSE 'Nano' END AS tier,
  MOD(SEQ4(),500)*1000+1000 AS follower_count
FROM TABLE(GENERATOR(ROWCOUNT => 30));

CREATE OR REPLACE TABLE RC_DIM_EVENT AS
SELECT SEQ4()+1 AS event_id, 'Event_'||(SEQ4()+1) AS event_name,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'Sale' WHEN 1 THEN 'Launch' WHEN 2 THEN 'Clearance' ELSE 'Flash Deal' END AS event_type,
  DATEADD(DAY, MOD(SEQ4(),365), '2023-01-01') AS event_date
FROM TABLE(GENERATOR(ROWCOUNT => 20));

CREATE OR REPLACE TABLE RC_DIM_LANGUAGE AS
SELECT SEQ4()+1 AS language_id,
  CASE MOD(SEQ4(),6) WHEN 0 THEN 'English' WHEN 1 THEN 'Spanish' WHEN 2 THEN 'French' WHEN 3 THEN 'German' WHEN 4 THEN 'Japanese' ELSE 'Mandarin' END AS language_name,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Primary' WHEN 1 THEN 'Secondary' ELSE 'Tertiary' END AS market_priority
FROM TABLE(GENERATOR(ROWCOUNT => 6));

CREATE OR REPLACE TABLE RC_DIM_COUNTRY AS
SELECT SEQ4()+1 AS country_id,
  CASE MOD(SEQ4(),8) WHEN 0 THEN 'USA' WHEN 1 THEN 'Canada' WHEN 2 THEN 'UK' WHEN 3 THEN 'Germany' WHEN 4 THEN 'France' WHEN 5 THEN 'Japan' WHEN 6 THEN 'Australia' ELSE 'Brazil' END AS country_name,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'North America' WHEN 1 THEN 'Europe' WHEN 2 THEN 'Asia' ELSE 'South America' END AS continent
FROM TABLE(GENERATOR(ROWCOUNT => 8));

CREATE OR REPLACE TABLE RC_DIM_TAX_CATEGORY AS
SELECT SEQ4()+1 AS tax_cat_id,
  CASE MOD(SEQ4(),5) WHEN 0 THEN 'Standard' WHEN 1 THEN 'Reduced' WHEN 2 THEN 'Zero-rated' WHEN 3 THEN 'Exempt' ELSE 'Luxury' END AS tax_category,
  ROUND(MOD(SEQ4(),25)*0.01, 2) AS rate
FROM TABLE(GENERATOR(ROWCOUNT => 5));

CREATE OR REPLACE TABLE RC_DIM_PRODUCT_LIFECYCLE AS
SELECT SEQ4()+1 AS lifecycle_id,
  CASE MOD(SEQ4(),5) WHEN 0 THEN 'Introduction' WHEN 1 THEN 'Growth' WHEN 2 THEN 'Maturity' WHEN 3 THEN 'Decline' ELSE 'Discontinued' END AS stage,
  SEQ4()+1 AS stage_order
FROM TABLE(GENERATOR(ROWCOUNT => 5));

CREATE OR REPLACE TABLE RC_DIM_FULFILLMENT_CENTER AS
SELECT SEQ4()+1 AS center_id, 'FC_'||(SEQ4()+1) AS center_name,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'North' WHEN 1 THEN 'South' WHEN 2 THEN 'East' ELSE 'West' END AS region,
  MOD(SEQ4(),500)+100 AS capacity_units
FROM TABLE(GENERATOR(ROWCOUNT => 12));

CREATE OR REPLACE TABLE RC_DIM_PRICE_TIER AS
SELECT SEQ4()+1 AS tier_id,
  CASE MOD(SEQ4(),5) WHEN 0 THEN 'Budget' WHEN 1 THEN 'Value' WHEN 2 THEN 'Mid-Range' WHEN 3 THEN 'Premium' ELSE 'Luxury' END AS tier_name,
  MOD(SEQ4(),5)*100 AS min_price, (MOD(SEQ4(),5)+1)*100 AS max_price
FROM TABLE(GENERATOR(ROWCOUNT => 5));

CREATE OR REPLACE TABLE RC_DIM_CUSTOMER_LIFECYCLE AS
SELECT SEQ4()+1 AS lifecycle_id,
  CASE MOD(SEQ4(),5) WHEN 0 THEN 'New' WHEN 1 THEN 'Active' WHEN 2 THEN 'At Risk' WHEN 3 THEN 'Lapsed' ELSE 'Churned' END AS stage,
  SEQ4()+1 AS stage_order
FROM TABLE(GENERATOR(ROWCOUNT => 5));

CREATE OR REPLACE TABLE RC_DIM_SALES_TERRITORY AS
SELECT SEQ4()+1 AS territory_id, 'Territory_'||(SEQ4()+1) AS territory_name,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'North' WHEN 1 THEN 'South' WHEN 2 THEN 'East' ELSE 'West' END AS region,
  MOD(SEQ4(),20)+1 AS rep_count
FROM TABLE(GENERATOR(ROWCOUNT => 16));

CREATE OR REPLACE TABLE RC_DIM_COMMISSION_PLAN AS
SELECT SEQ4()+1 AS plan_id, 'Plan_'||(SEQ4()+1) AS plan_name,
  ROUND(MOD(SEQ4(),15)*0.01+0.03, 2) AS commission_rate,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Flat' WHEN 1 THEN 'Tiered' ELSE 'Accelerated' END AS structure
FROM TABLE(GENERATOR(ROWCOUNT => 10));

CREATE OR REPLACE TABLE RC_DIM_REVIEW_SENTIMENT AS
SELECT SEQ4()+1 AS sentiment_id,
  CASE MOD(SEQ4(),5) WHEN 0 THEN 'Very Positive' WHEN 1 THEN 'Positive' WHEN 2 THEN 'Neutral' WHEN 3 THEN 'Negative' ELSE 'Very Negative' END AS sentiment,
  MOD(SEQ4(),5)+1 AS star_rating
FROM TABLE(GENERATOR(ROWCOUNT => 5));

CREATE OR REPLACE TABLE RC_DIM_BUNDLE AS
SELECT SEQ4()+1 AS bundle_id, 'Bundle_'||(SEQ4()+1) AS bundle_name,
  MOD(SEQ4(),5)+2 AS items_in_bundle,
  ROUND(MOD(SEQ4(),30)*0.01+0.05, 2) AS bundle_discount_pct
FROM TABLE(GENERATOR(ROWCOUNT => 15));

CREATE OR REPLACE TABLE RC_DIM_CROSS_SELL AS
SELECT SEQ4()+1 AS cross_sell_id, MOD(SEQ4(),500)+1 AS primary_product_id, MOD(SEQ4()+250,500)+1 AS recommended_product_id,
  ROUND(ABS(RANDOM(207))/1e16*0.3+0.01, 2) AS conversion_rate
FROM TABLE(GENERATOR(ROWCOUNT => 100));

CREATE OR REPLACE TABLE RC_DIM_FORECAST AS
SELECT SEQ4()+1 AS forecast_id, MOD(SEQ4(),4)+1 AS region_id,
  DATEADD(MONTH, MOD(SEQ4(),12), '2024-01-01') AS forecast_month,
  ROUND(ABS(RANDOM(208))/1e16*1000000+100000, 2) AS projected_revenue
FROM TABLE(GENERATOR(ROWCOUNT => 48));

CREATE OR REPLACE TABLE RC_DIM_SAFETY_STOCK AS
SELECT SEQ4()+1 AS safety_id, MOD(SEQ4(),500)+1 AS product_id,
  MOD(SEQ4(),100)+10 AS minimum_units,
  MOD(SEQ4(),500)+50 AS maximum_units
FROM TABLE(GENERATOR(ROWCOUNT => 100));

CREATE OR REPLACE TABLE RC_DIM_LEAD_TIME AS
SELECT SEQ4()+1 AS lead_time_id, MOD(SEQ4(),100)+1 AS supplier_id,
  MOD(SEQ4(),30)+1 AS days_to_deliver,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Standard' WHEN 1 THEN 'Express' ELSE 'Economy' END AS shipping_speed
FROM TABLE(GENERATOR(ROWCOUNT => 50));

CREATE OR REPLACE TABLE RC_DIM_QUALITY_SCORE AS
SELECT SEQ4()+1 AS quality_id, MOD(SEQ4(),500)+1 AS product_id,
  ROUND(ABS(RANDOM(209))/1e16*4+1, 1) AS quality_score,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Pass' WHEN 1 THEN 'Conditional' ELSE 'Fail' END AS qa_status
FROM TABLE(GENERATOR(ROWCOUNT => 100));

CREATE OR REPLACE TABLE RC_DIM_CUSTOMER_PREFERENCE AS
SELECT SEQ4()+1 AS pref_id, MOD(SEQ4(),1000)+1 AS customer_id,
  CASE MOD(SEQ4(),4) WHEN 0 THEN 'Email' WHEN 1 THEN 'SMS' WHEN 2 THEN 'Push' ELSE 'None' END AS contact_preference,
  CASE MOD(SEQ4(),3) WHEN 0 THEN 'Morning' WHEN 1 THEN 'Afternoon' ELSE 'Evening' END AS preferred_time
FROM TABLE(GENERATOR(ROWCOUNT => 200));
