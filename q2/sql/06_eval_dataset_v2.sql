-- 06_eval_dataset_v2.sql
-- Q2 Phase 2: 30 harder questions across 3 categories
-- Category A: Single-domain hard (window functions, complex aggregation within one domain)
-- Category B: Ambiguous routing hard (tricky phrasing, 2-3 views could answer)
-- Category C: Cross-view (genuinely needs data from 2 semantic views combined)

USE WAREHOUSE LAB_WH;
USE SCHEMA CORTEX_AGENT_LAB.EVAL;

CREATE OR REPLACE TABLE Q2_EVAL_DATASET_V2 (
    question_id INT,
    question STRING,
    ground_truth STRING,
    category STRING,
    target_domain STRING
);

INSERT INTO Q2_EVAL_DATASET_V2 VALUES

-- ============================================
-- CATEGORY A: Single-domain hard (10 questions)
-- Requires window functions or complex logic within one domain
-- ============================================

(1,
 'What is the month-over-month growth in total revenue for each region in 2023?',
 'Requires SALES_VIEW. Use LAG window function over monthly revenue partitioned by region. Should show 4 regions x 12 months with growth percentages near 0% due to uniform data.',
 'single_hard',
 'Sales'),

(2,
 'Rank the top 5 campaigns by attributed revenue and show their conversion rate.',
 'Requires MARKETING_VIEW. RANK() by SUM(attributed_revenue), also compute COUNT(event_type=Conversion)/COUNT(*) per campaign. Top 5 campaigns out of 200.',
 'single_hard',
 'Marketing'),

(3,
 'What is the win rate trend by quarter for each pipeline stage?',
 'Requires CRM_VIEW. AVG(probability) per stage per quarter, potentially with LAG to show trend. 6 stages x 12 quarters.',
 'single_hard',
 'CRM'),

(4,
 'Which cost centers have expenses growing faster than 10% quarter over quarter?',
 'Requires FINANCE_VIEW. SUM(debit_amount) per cost_center per quarter, then compute QoQ growth with LAG, filter WHERE growth > 10%. Due to uniform data, most will be near 0%.',
 'single_hard',
 'Finance'),

(5,
 'What percentage of total headcount does each department represent, and how has it changed over the last 4 quarters?',
 'Requires HR_VIEW. COUNT per department / COUNT total as percentage, computed per quarter. PERCENT change using LAG. 10 departments.',
 'single_hard',
 'HR'),

(6,
 'What is the running total of gross pay by department through 2023, and which department crossed $50M first?',
 'Requires PAYROLL_VIEW. SUM(gross_pay) OVER (PARTITION BY department ORDER BY pay_date) then find MIN date where running_total > 50M per department.',
 'single_hard',
 'Payroll'),

(7,
 'Rank recruiting sources by their hire conversion rate and average days in pipeline.',
 'Requires RECRUITING_VIEW. For each source: COUNT(status=Hired)/COUNT(*) as conversion_rate, AVG(days_in_pipeline). RANK by conversion_rate DESC.',
 'single_hard',
 'Recruiting'),

(8,
 'What is the 3-month moving average of shipping cost by shipping method?',
 'Requires SUPPLY_CHAIN_VIEW. AVG(shipping_cost) OVER (PARTITION BY shipping_method ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW).',
 'single_hard',
 'Supply Chain'),

(9,
 'Which products have inventory below their reorder point in more than 2 warehouses?',
 'Requires INVENTORY_VIEW. Filter WHERE quantity_on_hand < reorder_point, GROUP BY product, HAVING COUNT(DISTINCT warehouse) > 2.',
 'single_hard',
 'Inventory'),

(10,
 'What is the average resolution time percentile for each ticket priority level?',
 'Requires SUPPORT_VIEW. PERCENT_RANK() or NTILE on resolution_hours partitioned by priority. Show P25, P50, P75 per priority.',
 'single_hard',
 'Support'),

-- ============================================
-- CATEGORY B: Ambiguous routing hard (10 questions)
-- Tricky phrasing where 2-3 views could plausibly answer
-- ============================================

(11,
 'What is our customer acquisition cost by channel?',
 'Ambiguous: could be MARKETING_VIEW (cost_per_event by channel) or SALES_VIEW (no cost metric). Best answer uses MARKETING_VIEW since it has spend data. Sales has revenue but not acquisition cost.',
 'ambiguous_hard',
 'Marketing'),

(12,
 'Show me the revenue per employee by department.',
 'Ambiguous: could be SALES_VIEW revenue / HR_VIEW headcount, or FINANCE_VIEW debits by cost_center, or PAYROLL_VIEW gross_pay. Best answer should acknowledge it needs to combine sources or use Finance.',
 'ambiguous_hard',
 'Finance/HR'),

(13,
 'What is our cost efficiency by region?',
 'Ambiguous: cost could be FINANCE_VIEW (GL debits), SALES_VIEW (order cost), SUPPLY_CHAIN_VIEW (shipping_cost), PAYROLL_VIEW (gross_pay). Efficiency implies ratio. Agent should clarify or pick Finance.',
 'ambiguous_hard',
 'Finance'),

(14,
 'How are our products performing this quarter?',
 'Ambiguous: performance could mean SALES_VIEW (revenue), INVENTORY_VIEW (stock levels), SUPPLY_CHAIN_VIEW (delivery times), PROCUREMENT_VIEW (purchase costs). Best answer uses Sales.',
 'ambiguous_hard',
 'Sales/Inventory'),

(15,
 'What is the trend in customer satisfaction?',
 'Ambiguous: could be SUPPORT_VIEW (csat_score over time) or CRM_VIEW (probability/win rates as proxy). Best answer uses SUPPORT_VIEW since it has explicit CSAT scores.',
 'ambiguous_hard',
 'Support'),

(16,
 'Show me headcount costs broken down by region.',
 'Ambiguous: could be HR_VIEW (salary by region), PAYROLL_VIEW (gross_pay by region via department), or FINANCE_VIEW (cost_center by region). Best answer uses HR or Payroll.',
 'ambiguous_hard',
 'HR/Payroll'),

(17,
 'What is our vendor spend trending over time?',
 'Ambiguous: could be PROCUREMENT_VIEW (total_cost over time) or SUPPLY_CHAIN_VIEW (shipping_cost). Best answer uses PROCUREMENT_VIEW since it tracks actual purchase spend.',
 'ambiguous_hard',
 'Procurement'),

(18,
 'How effective is our online presence?',
 'Ambiguous: could be WEB_ANALYTICS_VIEW (conversions, session duration) or MARKETING_VIEW (online channel attributed revenue). Best answer uses WEB_ANALYTICS_VIEW.',
 'ambiguous_hard',
 'Web Analytics'),

(19,
 'What is the pipeline value by territory?',
 'Ambiguous: pipeline is CRM_VIEW (deal_amount by rep), but territory could be CRM (rep department) or SALES_VIEW (region). Best answer uses CRM since pipeline is CRM-specific.',
 'ambiguous_hard',
 'CRM'),

(20,
 'Show me the return on investment by department.',
 'Ambiguous: ROI could be FINANCE_VIEW (revenue vs expense by cost_center), MARKETING_VIEW (attributed_revenue vs spend), or HR_VIEW (salary vs headcount). Agent should clarify or pick Finance.',
 'ambiguous_hard',
 'Finance'),

-- ============================================
-- CATEGORY C: Cross-view (10 questions)
-- Genuinely needs data from 2+ semantic views to answer fully
-- ============================================

(21,
 'Compare total marketing spend to total sales revenue by region for 2023.',
 'Requires MARKETING_VIEW (SUM cost_per_event by region WHERE year=2023) AND SALES_VIEW (SUM revenue by region WHERE year=2023). Agent must call both tools and present side by side.',
 'cross_view',
 'Marketing + Sales'),

(22,
 'For customers who filed support tickets with Critical priority, what is their total order revenue?',
 'Requires SUPPORT_VIEW (get customer_codes with priority=Critical) AND SALES_VIEW (SUM revenue for those customers). Agent must query both and join on customer.',
 'cross_view',
 'Support + Sales'),

(23,
 'Which departments have the highest payroll cost relative to their headcount?',
 'Requires PAYROLL_VIEW (SUM gross_pay by department) AND HR_VIEW (COUNT employees by department). Divide payroll/headcount. Agent must call both.',
 'cross_view',
 'Payroll + HR'),

(24,
 'Compare the top 5 products by sales revenue versus their current inventory levels.',
 'Requires SALES_VIEW (top 5 products by revenue) AND INVENTORY_VIEW (quantity_on_hand for those products). Agent must query both and correlate.',
 'cross_view',
 'Sales + Inventory'),

(25,
 'What is the correlation between marketing spend and deal pipeline value by region?',
 'Requires MARKETING_VIEW (spend by region) AND CRM_VIEW (deal_amount by region). Agent must pull both and compare or show side by side.',
 'cross_view',
 'Marketing + CRM'),

(26,
 'For each shipping method, what is the associated procurement cost of items shipped?',
 'Requires SUPPLY_CHAIN_VIEW (shipments by method) AND PROCUREMENT_VIEW (total_cost for related products). Agent must cross-reference both.',
 'cross_view',
 'Supply Chain + Procurement'),

(27,
 'Compare web conversion rates to actual closed deal rates by customer segment.',
 'Requires WEB_ANALYTICS_VIEW (conversion rate by segment) AND CRM_VIEW (Closed Won rate by segment). Agent must call both and compare.',
 'cross_view',
 'Web Analytics + CRM'),

(28,
 'What is the average time-to-hire for departments that have the highest payroll expenses?',
 'Requires PAYROLL_VIEW (identify top departments by gross_pay) AND RECRUITING_VIEW (avg days_in_pipeline for those departments). Agent must combine both.',
 'cross_view',
 'Payroll + Recruiting'),

(29,
 'Show total revenue and total support tickets by customer segment side by side.',
 'Requires SALES_VIEW (revenue by segment) AND SUPPORT_VIEW (ticket count by segment). Agent must call both tools and present together.',
 'cross_view',
 'Sales + Support'),

(30,
 'Compare the GL expense trend to the headcount trend by department over the last year.',
 'Requires FINANCE_VIEW (debits by cost_center over time) AND HR_VIEW (headcount by department over time). Agent must pull both and show the comparison.',
 'cross_view',
 'Finance + HR'),

-- ============================================
-- CATEGORY D: Cross-view hard (10 questions)
-- More complex cross-view queries requiring aggregation + comparison
-- ============================================

(31,
 'Which customer segments generate the most revenue but also have the highest support ticket volume?',
 'Requires SALES_VIEW (revenue by segment) AND SUPPORT_VIEW (ticket count by segment). Agent must query both, combine, and identify segments that are high on both dimensions.',
 'cross_view_hard',
 'Sales + Support'),

(32,
 'Compare the average deal size in CRM to the average order value in Sales by region. Are they correlated?',
 'Requires CRM_VIEW (AVG deal_amount by region) AND SALES_VIEW (AVG revenue by region). Agent must call both and compare the two averages per region.',
 'cross_view_hard',
 'CRM + Sales'),

(33,
 'For regions where marketing spend is highest, what is the corresponding pipeline value and close rate?',
 'Requires MARKETING_VIEW (spend by region, identify top regions) AND CRM_VIEW (deal_amount and probability for those regions). Three-way insight across two views.',
 'cross_view_hard',
 'Marketing + CRM'),

(34,
 'What is the ratio of procurement cost to sales revenue for each product category?',
 'Requires PROCUREMENT_VIEW (total_cost by product category) AND SALES_VIEW (revenue by product category). Agent must call both and compute the ratio.',
 'cross_view_hard',
 'Procurement + Sales'),

(35,
 'Compare employee turnover rate from HR to the recruiting pipeline fill rate by department.',
 'Requires HR_VIEW (terminated headcount / total headcount by department) AND RECRUITING_VIEW (hired / total applications by department). Agent must compute rates from both and compare.',
 'cross_view_hard',
 'HR + Recruiting'),

(36,
 'Which shipping methods have the highest cost but the lowest on-time delivery rate?',
 'Requires SUPPLY_CHAIN_VIEW (shipping_cost by method AND delivery status by method). Single view but requires complex aggregation: AVG cost + percentage of status=Delivered per method.',
 'cross_view_hard',
 'Supply Chain'),

(37,
 'For the top 10 customers by web engagement (session duration), what is their total order revenue and average deal size?',
 'Requires WEB_ANALYTICS_VIEW (top 10 by session_duration) AND SALES_VIEW (revenue for those customers) AND CRM_VIEW (deal size for those customers). Three views needed.',
 'cross_view_hard',
 'Web Analytics + Sales + CRM'),

(38,
 'Compare the month-over-month trend in marketing spend to the month-over-month trend in sales revenue. Do they move together?',
 'Requires MARKETING_VIEW (monthly spend with LAG) AND SALES_VIEW (monthly revenue with LAG). Agent must compute MoM growth for both and compare trends.',
 'cross_view_hard',
 'Marketing + Sales'),

(39,
 'What is the total inventory value for products that have the highest return rates?',
 'Requires SALES_VIEW or SUPPORT_VIEW to identify high-return products AND INVENTORY_VIEW (quantity_on_hand * unit_cost for those products). Cross-reference needed.',
 'cross_view_hard',
 'Inventory + Sales'),

(40,
 'For each department, show the total payroll cost, total GL expense, and headcount side by side.',
 'Requires PAYROLL_VIEW (gross_pay by department) AND FINANCE_VIEW (debits by cost_center) AND HR_VIEW (count by department). Agent must call three tools and combine.',
 'cross_view_hard',
 'Payroll + Finance + HR'),

-- ============================================
-- CATEGORY E: Stress test (10 questions)
-- Deliberately tricky, edge cases, multi-step reasoning
-- ============================================

(41,
 'What would be the projected annual revenue if Q1 2024 growth rate continued for all 4 quarters?',
 'Requires SALES_VIEW. Agent must compute Q1 2024 vs Q1 2023 growth rate, then extrapolate. Tests multi-step reasoning, not just data retrieval.',
 'stress_test',
 'Sales'),

(42,
 'Which domain has the most expensive operations: Sales (by COGS), HR (by salary), or Supply Chain (by shipping)?',
 'Requires SALES_VIEW (cost), HR_VIEW (salary), SUPPLY_CHAIN_VIEW (shipping_cost). Agent must query all three and compare totals. Tests ability to synthesize across 3 views.',
 'stress_test',
 'Sales + HR + Supply Chain'),

(43,
 'If we eliminated the bottom 10% of products by revenue, how much total revenue would we lose?',
 'Requires SALES_VIEW. Agent must rank products, identify bottom 10% (50 products), sum their revenue, and express as total and percentage. Multi-step logic.',
 'stress_test',
 'Sales'),

(44,
 'What is the customer lifetime value distribution? Show the 25th, 50th, 75th, and 90th percentile.',
 'Requires SALES_VIEW. SUM(revenue) per customer, then PERCENTILE_CONT at 0.25, 0.5, 0.75, 0.9. Tests percentile window functions.',
 'stress_test',
 'Sales'),

(45,
 'Are there any departments where payroll cost per employee is more than 2x the company average?',
 'Requires PAYROLL_VIEW. Compute avg gross_pay per employee per department, compare to overall average, filter WHERE dept_avg > 2 * overall_avg. Conditional logic.',
 'stress_test',
 'Payroll'),

(46,
 'What is the net financial position by region (revenue minus all expenses)?',
 'Requires SALES_VIEW (revenue by region) AND FINANCE_VIEW (debits by region). Agent must subtract expenses from revenue per region. Cross-view arithmetic.',
 'stress_test',
 'Sales + Finance'),

(47,
 'For campaigns that had above-average conversion rates, what was their total attributed revenue compared to their total spend? What was the ROI?',
 'Requires MARKETING_VIEW. Identify campaigns with conversion rate > avg, sum their attributed_revenue and cost_per_event, compute ROI = (revenue - spend)/spend. Multi-step within one view.',
 'stress_test',
 'Marketing'),

(48,
 'Rank all 12 business domains by the total dollar value they represent and show the percentage each contributes to the overall business.',
 'Requires ALL views. Agent must query revenue/value from each domain and create a unified ranking. Tests if agent can call multiple tools and synthesize. Likely partial answer.',
 'stress_test',
 'All domains'),

(49,
 'What is the average time between a customer first purchase and their first support ticket?',
 'Requires SALES_VIEW (MIN order_date per customer) AND SUPPORT_VIEW (MIN created_date per customer). Agent must get earliest dates from both and compute the difference.',
 'stress_test',
 'Sales + Support'),

(50,
 'If marketing spend was cut by 50%, based on the current spend-to-revenue ratio, how much revenue would we estimate losing?',
 'Requires MARKETING_VIEW. Compute total spend and attributed_revenue, derive ratio, apply 50% cut and estimate impact. Tests reasoning beyond pure data retrieval.',
 'stress_test',
 'Marketing');

-- Register as V2 evaluation dataset
CALL SYSTEM$CREATE_EVALUATION_DATASET(
  'Q2_EVAL_DATASET_V2',
  'CORTEX_AGENT_LAB.EVAL.Q2_EVAL_DATASET_V2',
  'question',
  'ground_truth'
);
