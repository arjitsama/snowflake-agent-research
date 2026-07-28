-- 07_eval_dataset_v2.sql
-- Q1 Phase 2: 50 harder questions across 5 difficulty tiers
-- Tier 1: Simple aggregation (baseline)
-- Tier 2: Multi-join (3+ tables required)
-- Tier 3: Window functions (ranking, growth, running totals)
-- Tier 4: Nuanced semantic targeting (synonym traps, filter precision)
-- Tier 5: Complex combined (multi-join + window + filters, hardest)

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA EVAL;

CREATE OR REPLACE TABLE CORTEX_AGENT_LAB.EVAL.Q1_TABLE_SCALING_DATASET_V2 (
  input_query VARCHAR,
  ground_truth VARIANT,
  difficulty_tier INT,
  requires_tier VARCHAR
);

INSERT INTO CORTEX_AGENT_LAB.EVAL.Q1_TABLE_SCALING_DATASET_V2
SELECT input_query, PARSE_JSON(ground_truth), difficulty_tier, requires_tier FROM (VALUES

-- ============================================
-- TIER 1: Simple aggregation (10 questions)
-- Single GROUP BY, 1-2 tables max
-- ============================================

('What is total revenue by product type?', '{"ground_truth_output": "Total revenue by product type: Sports ~$115.2B, Apparel ~$114.3B, Electronics ~$114.0B, Home ~$112.4B."}', 1, 'T5'),

('What is total revenue by store region?', '{"ground_truth_output": "Total revenue by store region: South ~$120.2B, North ~$117.2B, West ~$109.2B, East ~$109.1B."}', 1, 'T5'),

('How many transactions were there by customer tier?', '{"ground_truth_output": "Transactions by customer tier: Standard ~25,248, Silver ~24,944, Gold ~24,914, Bronze ~24,894. Approximately 100,000 total evenly distributed."}', 1, 'T5'),

('What is total revenue by year?', '{"ground_truth_output": "Total revenue by year: 2022 ~$152.3B, 2023 ~$151.4B, 2024 ~$152.1B. Revenue is stable across all three years."}', 1, 'T5'),

('What is the average sale value by store type?', '{"ground_truth_output": "Average sale value by store type: Mall ~$4.57M, Online ~$4.55M, Standalone ~$4.55M. All very similar."}', 1, 'T5'),

('How many unique customers made purchases?', '{"ground_truth_output": "1000 unique customers (all customers in dim_customer have at least one transaction given the MOD distribution)."}', 1, 'T5'),

('What is total revenue by quarter?', '{"ground_truth_output": "Revenue by quarter is roughly evenly distributed across Q1-Q4 each year, approximately $38B per quarter."}', 1, 'T5'),

('What is the total number of transactions by day of week?', '{"ground_truth_output": "Transactions are roughly evenly distributed across days of the week since sale_date is generated with MOD over 1096 days."}', 1, 'T5'),

('What is the average shipping cost by ship method?', '{"ground_truth_output": "Average shipping cost by ship method: Air ~$27.50, Express ~$27.50, Ground ~$27.50. Generated uniformly so all roughly equal around $25-30."}', 1, 'T10'),

('What is the total refund value by return reason?', '{"ground_truth_output": "Total refund value by return reason: roughly equal across Defective, Wrong item, Changed mind, Other at ~$1.2B-$1.3B each."}', 1, 'T10'),

-- ============================================
-- TIER 2: Multi-join (10 questions)
-- Requires 3+ table joins, compound filters
-- ============================================

('What is total revenue from Gold tier customers in the North region who purchased Electronics?', '{"ground_truth_output": "Requires joining sales + customers (filter tier=Gold, filter region from stores=North) + products (filter type=Electronics). Should be a subset of total revenue, roughly $7-8B range."}', 2, 'T5'),

('What is the average sale amount by sales rep level and territory?', '{"ground_truth_output": "Requires joining sales + sales_reps. Cross-tabulate level (Senior/Mid/Junior) by territory (North/South/East/West). Average should be roughly similar across all combos since data is uniformly generated."}', 2, 'T10'),

('Which store has the highest total revenue from Silver tier customers?', '{"ground_truth_output": "Requires joining sales + customers (filter tier=Silver) + stores. GROUP BY store_name, ORDER BY SUM(sale_amount) DESC LIMIT 1. One of the 50 stores will be the top performer."}', 2, 'T5'),

('What is the total revenue by supplier type and product type?', '{"ground_truth_output": "Requires joining sales + suppliers + products. Cross-tabulate supplier_type (Domestic/International/Regional) by product_type (Electronics/Apparel/Home/Sports). 12 combinations total."}', 2, 'T10'),

('What is the return rate by product type?', '{"ground_truth_output": "Requires joining returns (via sale_id to sales) then sales to products. Calculate COUNT(returns)/COUNT(sales) per product_type. Returns table has 5000 rows vs 100k sales, so overall ~5% return rate."}', 2, 'T10'),

('What is total revenue by promotion type for Mall stores only?', '{"ground_truth_output": "Requires joining sales + promotions + stores (filter store_type=Mall). GROUP BY promotion_type (Discount/BOGO/Clearance). Should show revenue split across 3 promo types for Mall stores."}', 2, 'T10'),

('What is the average sale amount for each brand tier in each region?', '{"ground_truth_output": "Requires joining sales + brands + regions (via region_id). Cross-tab brand_tier (Premium/Value/Standard) by region_name (North/South/East/West). 12 combinations."}', 2, 'T20'),

('What is the total revenue from customers in loyalty tier Gold or Platinum by channel?', '{"ground_truth_output": "Requires joining sales + loyalty (filter tier_name IN Gold, Platinum) + channels. GROUP BY channel_name. Should show revenue across 5 channels for high-loyalty customers."}', 2, 'T20'),

('Which category has the highest total revenue in the West region?', '{"ground_truth_output": "Requires joining sales + categories + regions (filter region_name=West). GROUP BY category_name ORDER BY revenue DESC LIMIT 1."}', 2, 'T20'),

('What is the average discount rate by customer tier and store region?', '{"ground_truth_output": "Requires joining sales + customers + stores. Cross-tab customer_tier (Gold/Silver/Bronze/Standard) by region (North/South/East/West). 16 combinations, averages should be similar due to uniform generation."}', 2, 'T5'),

-- ============================================
-- TIER 3: Window functions (10 questions)
-- Requires ranking, running totals, YoY growth, percentiles, LAG/LEAD
-- ============================================

('What is the month-over-month revenue growth rate for each store region in 2023?', '{"ground_truth_output": "Requires a window function: SUM(sale_amount) per region per month, then LAG to compute (current - previous)/previous * 100. Should show 12 months x 4 regions with growth rates fluctuating around 0% since data is uniformly generated."}', 3, 'T5'),

('Rank product types by total revenue and show what percentage of total each represents.', '{"ground_truth_output": "Requires RANK() or ROW_NUMBER() plus SUM() OVER() for total. 4 product types each contributing roughly 25% of total revenue. Sports slightly highest, Home slightly lowest."}', 3, 'T5'),

('What is the running total of transactions by month in 2023?', '{"ground_truth_output": "Requires SUM(COUNT(*)) OVER (ORDER BY month). Should show cumulative transaction count growing from ~8,300 in Jan to ~100,000 by Dec 2023 (roughly 8,333/month for 100k/12)."}', 3, 'T5'),

('What is the 3-month moving average of revenue by store region?', '{"ground_truth_output": "Requires AVG(monthly_revenue) OVER (PARTITION BY region ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW). Should show smoothed revenue trends per region."}', 3, 'T5'),

('Which customers are in the top 10% by total purchase amount?', '{"ground_truth_output": "Requires NTILE(10) or PERCENT_RANK() over customer total spend. Top 10% would be roughly 100 customers out of 1000."}', 3, 'T5'),

('What is the year-over-year revenue change by product type?', '{"ground_truth_output": "Requires LAG with partition by product_type and year. Compare 2023 vs 2022 and 2024 vs 2023. Changes should be near 0% since data is uniformly distributed across years."}', 3, 'T5'),

('For each sales rep, what is their rank by total revenue within their territory?', '{"ground_truth_output": "Requires RANK() OVER (PARTITION BY territory ORDER BY SUM(sale_amount) DESC). Joins sales + sales_reps. 20 reps across 4 territories = 5 reps ranked per territory."}', 3, 'T10'),

('What is the cumulative refund amount by month, and in which month did it exceed $3B?', '{"ground_truth_output": "Requires SUM(refund_amount) OVER (ORDER BY month) from returns joined to dates. With ~$5B total refunds over 36 months, $3B threshold should be crossed around month 20-22."}', 3, 'T10'),

('What percentage of total revenue does each store contribute, ranked highest to lowest?', '{"ground_truth_output": "Requires SUM(sale_amount)/SUM(sale_amount) OVER() * 100 per store, ordered DESC. 50 stores each contributing roughly 2% of total."}', 3, 'T5'),

('What is the quarter-over-quarter growth in transaction count by customer tier?', '{"ground_truth_output": "Requires COUNT per tier per quarter, then LAG by 1 quarter partitioned by tier. Growth should be near 0% since data is uniform across time."}', 3, 'T5'),

-- ============================================
-- TIER 4: Nuanced semantic targeting (10 questions)
-- Tests synonym traps, ambiguous filters, correct column selection
-- ============================================

('What is total revenue by territory?', '{"ground_truth_output": "Ambiguous: territory exists on sales_reps table (T10), but region exists on stores (T5). At T5, agent should use stores.region. At T10+, agent should use sales_reps.territory since the question says territory specifically. Results differ based on which is used."}', 4, 'T10'),

('What is the total cost by region?', '{"ground_truth_output": "Ambiguous: no explicit cost column in semantic views. Could interpret as looking for a cost metric if one exists, or decline. The sales fact has sale_amount but not a separate cost. Agent should clarify or explain there is no cost metric exposed."}', 4, 'T5'),

('Show me the discount breakdown by customer level.', '{"ground_truth_output": "Tests synonym resolution: customer level is a synonym for customer_tier. Agent should compute AVG(discount_rate) grouped by customer_tier. Should show ~similar discount rates across Gold/Silver/Bronze/Standard."}', 4, 'T5'),

('What is the average transaction value by area?', '{"ground_truth_output": "Tests synonym resolution: area is a synonym for region (on stores). Agent should compute AVG(sale_amount) grouped by stores.region. Should show ~similar values across North/South/East/West."}', 4, 'T5'),

('How many purchases were made at each location type?', '{"ground_truth_output": "Tests synonym resolution: purchases = transactions/sales, location type = store_type. Agent should COUNT(sale_id) GROUP BY store_type. Results: Mall ~33k, Online ~33k, Standalone ~33k."}', 4, 'T5'),

('What is the gross revenue by product category for online branches only?', '{"ground_truth_output": "Tests multiple synonym resolution: gross revenue = total sales/revenue, product category = product_type, branches = stores (synonym), online = store_type filter. Requires sales + products + stores WHERE store_type = Online GROUP BY product_type."}', 4, 'T5'),

('Show the delivery method breakdown by vendor type.', '{"ground_truth_output": "Tests synonym resolution: delivery method = ship_method (on shipments), vendor type = supplier_type (on suppliers). Requires joining shipments + suppliers. COUNT or SUM by ship_method and supplier_type cross-tab."}', 4, 'T10'),

('What are the send-back reasons for items from international manufacturers?', '{"ground_truth_output": "Tests synonym resolution: send-backs = returns, manufacturers = suppliers (synonym). Requires returns joined to sales joined to suppliers WHERE supplier_type = International, GROUP BY return_reason."}', 4, 'T10'),

('What is total bookings by loyalty tier name?', '{"ground_truth_output": "Tests synonym resolution: bookings = revenue/sales (synonym on sales metric). loyalty tier = tier_name from RC_DIM_LOYALTY table. Requires sales + loyalty table join. GROUP BY tier_name (Bronze/Silver/Gold/Platinum/Diamond)."}', 4, 'T20'),

('Show me goods performance by market segment.', '{"ground_truth_output": "Tests synonym resolution: goods = products (synonym), market segment = segment_name from RC_DIM_SEGMENT. Requires sales + segments join. GROUP BY segment_name showing revenue per segment (Budget/Mid-Range/Premium/Luxury/Wholesale/B2B/Government/Non-Profit)."}', 4, 'T20'),

-- ============================================
-- TIER 5: Complex combined (10 questions)
-- Combines multi-join + window functions + filters
-- The hardest questions in the set
-- ============================================

('What is the month-over-month revenue growth for Gold tier customers only, by store region?', '{"ground_truth_output": "Requires sales + customers (filter Gold) + stores + dates. Compute monthly revenue per region for Gold only, then LAG to get MoM growth. Multi-join + window function combined."}', 5, 'T5'),

('Which product type had the largest single-month revenue spike in 2023, and what month was it?', '{"ground_truth_output": "Requires sales + products + dates. Compute monthly revenue per product_type in 2023, then find MAX month-over-previous difference. Needs LAG + MAX combo."}', 5, 'T5'),

('For each store region, what percentage of total revenue comes from the top 3 stores?', '{"ground_truth_output": "Requires sales + stores. RANK stores within each region by revenue, filter top 3, then compute their sum / region total * 100. Nested window functions."}', 5, 'T5'),

('What is the average sale amount per transaction for each sales rep, ranked within their territory, showing only reps above the territory median?', '{"ground_truth_output": "Requires sales + sales_reps. AVG(sale_amount) per rep, RANK within territory, compute MEDIAN per territory using PERCENTILE_CONT, filter reps above median. Complex window + filter."}', 5, 'T10'),

('Show the top 5 customers by total spend who have also made returns, and their return rate.', '{"ground_truth_output": "Requires sales + customers + returns. Top 5 customers by SUM(sale_amount), then LEFT JOIN returns to compute return_count/purchase_count. Combines ranking with multi-join."}', 5, 'T10'),

('What is the 6-month rolling average revenue by promotion type, and which promotion type first exceeded $500M rolling average?', '{"ground_truth_output": "Requires sales + promotions + dates. Monthly revenue per promo_type, then AVG OVER (ROWS 5 PRECEDING), find MIN month where rolling_avg > 500M per type. Complex window + threshold."}', 5, 'T10'),

('For each brand tier, what is the quarter with the highest revenue and how does it compare to the overall quarterly average for that tier?', '{"ground_truth_output": "Requires sales + brands + dates. SUM per brand_tier per quarter, find MAX quarter per tier, compare to AVG across all quarters for that tier. Needs subquery or window."}', 5, 'T20'),

('Rank channels by revenue and show the cumulative percentage (running total as % of grand total) to identify which channels cover 80% of revenue.', '{"ground_truth_output": "Requires sales + channels. SUM per channel, RANK, then SUM() OVER (ORDER BY revenue DESC) / grand_total * 100 as cumulative_pct. Filter WHERE cumulative_pct <= 80. Pareto analysis."}', 5, 'T20'),

('What is the average transaction value trend by loyalty tier over time, and which tier shows the most volatility (highest standard deviation of monthly averages)?', '{"ground_truth_output": "Requires sales + loyalty + dates. AVG(sale_amount) per tier per month, then STDDEV over monthly averages per tier. Tier with highest STDDEV is most volatile."}', 5, 'T20'),

('For each currency, show the top-selling product type and its percentage share of that currency total revenue.', '{"ground_truth_output": "Requires sales + currencies + products. Revenue per currency per product_type, RANK within currency, filter rank=1, compute share as type_revenue/currency_total * 100."}', 5, 'T20')

) AS t(input_query, ground_truth, difficulty_tier, requires_tier);

-- Register as V2 evaluation dataset
CALL SYSTEM$CREATE_EVALUATION_DATASET(
  'Cortex Agent',
  'CORTEX_AGENT_LAB.EVAL.Q1_TABLE_SCALING_DATASET_V2',
  'CORTEX_AGENT_LAB.EVAL.Q1_TABLE_SCALING_DATASET_V2_DS',
  OBJECT_CONSTRUCT(
    'query_text', 'INPUT_QUERY',
    'expected_tools', 'GROUND_TRUTH'
  )
);
