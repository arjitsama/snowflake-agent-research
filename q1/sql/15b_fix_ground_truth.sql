-- 15b_fix_ground_truth.sql
-- Updates Tier 3-5 ground truths with actual executed query results
-- Run AFTER 15_reference_sql.sql

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA EVAL;

-- Q21: MoM growth by region 2023 (actual North values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "North region 2023 MoM growth: Jan-Feb -9.70%, Feb-Mar +21.09%, Mar-Apr -16.43%, Apr-May +16.42%, May-Jun -8.76%, Jun-Jul +20.76%, Jul-Aug -13.13%, Aug-Sep +4.77%, Sep-Oct +7.23%, Oct-Nov -10.97%, Nov-Dec -1.04%. Other regions show similar volatile patterns ranging from -16% to +21%."}')
WHERE question_id = 21;

-- Q24: 3-month moving average (actual North values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "3-month moving averages for North region: 202201 $3.55B, 202202 $3.38B, 202203 $3.28B, 202204 $3.15B, 202205 $3.22B, 202206 $3.21B. All regions follow similar patterns with values between $2.8B and $3.6B per month."}')
WHERE question_id = 24;

-- Q25: Top 10% customers (actual threshold)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "100 customers are in the top 10% by total purchase amount. Top 10% range: $524,360,122.70 (min) to $617,766,462.92 (max), average $550,017,886.32."}')
WHERE question_id = 25;

-- Q26: YoY revenue change (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "YoY revenue change by product type: Apparel 2022-2023 -0.43%, 2023-2024 -0.32%; Electronics 2022-2023 -1.99%, 2023-2024 +0.57%; Home 2022-2023 +1.05%, 2023-2024 +0.66%; Sports 2022-2023 -0.85%, 2023-2024 +1.00%. All changes within +/- 2%."}')
WHERE question_id = 26;

-- Q27: Sales rep rank (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "20 reps across 4 territories (5 per territory). East: Rep_3 $22.6B (#1), Rep_19 $22.6B (#2), Rep_11 $22.5B (#3), Rep_7 $22.3B (#4), Rep_15 $22.3B (#5). North: Rep_9 $23.3B (#1), Rep_1 $23.0B (#2). South: Rep_2 $23.2B (#1), Rep_14 $23.0B (#2). West: Rep_4 $23.5B (#1), Rep_8 $23.1B (#2). Revenue per rep ranges $22.3B to $23.5B."}')
WHERE question_id = 27;

-- Q28: Cumulative refund threshold (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "Cumulative refunds by month: 202201 $617.5M, 202202 $1.16B, 202203 $1.76B, 202204 $2.45B, 202205 $3.08B, 202206 $3.71B. Cumulative refund first exceeds $3B in May 2022 (202205) at $3,076,054,744.51. Total refunds across all months: ~$22.9B."}')
WHERE question_id = 28;

-- Q29: Store contribution range (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "50 stores contributing between 1.84% and 2.10% of total revenue. Top store: Store_2 at 2.10%. Bottom store at 1.84%. Distribution is fairly uniform with only 0.26 percentage points separating top from bottom."}')
WHERE question_id = 29;

-- Q30: QoQ growth (actual Gold tier values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "QoQ growth for Gold tier: 2022 Q1-Q2 +1.53%, Q2-Q3 -2.21%, Q3-Q4 +2.21%; 2023 Q4-Q1 -7.58%, Q1-Q2 +3.92%, Q2-Q3 +2.94%, Q3-Q4 +0.38%; 2024 Q4-Q1 -2.23%, Q1-Q2 +3.30%, Q2-Q3 -1.22%, Q3-Q4 -4.80%. All tiers show similar fluctuation between -8% and +4%."}')
WHERE question_id = 30;

-- Q33: Discount by tier (actual values - note data artifact)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "Average discount rate by customer tier: Bronze: 136.77, Gold: 138.62, Silver: 138.80, Standard: 138.24. Note: discount_rate values range from 0.01 to 276.69 (data generation artifact). All tiers have nearly identical average discount rates."}')
WHERE question_id = 33;

-- Q38: Return reasons for international (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "Return reasons for International suppliers: Wrong item: 406, Other: 406, Defective: 404, Changed mind: 401. Roughly evenly distributed across all 4 reasons."}')
WHERE question_id = 38;

-- Q41: MoM Gold North (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "MoM growth for Gold tier in North region 2023: Jan-Feb -0.69%, Feb-Mar +20.89%, Mar-Apr -6.33%, Apr-May -1.61%, May-Jun -1.65%. Growth ranges from -6% to +21% for Gold customers. Other regions show similar patterns with higher variance than the overall dataset due to smaller subset."}')
WHERE question_id = 41;

-- Q42: Largest spike (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "Sports had the largest single-month revenue spike in December 2023, increasing by $0.81B from November. Runner-up: Home in May 2023 (+$0.69B) and Home in July 2023 (+$0.69B)."}')
WHERE question_id = 42;

-- Q43: Top 3 stores per region (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "Top 3 stores percentage of region revenue: East 25.77%, North 23.76%, South 23.77%, West 25.74%. East and West have slightly more concentrated revenue in their top 3 stores."}')
WHERE question_id = 43;

-- Q44: Reps above median (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "8 of 20 sales reps are above their territory median (2 per territory). Average sale amounts range from $4.50M to $4.63M across reps. The median split is close since data is uniformly distributed."}')
WHERE question_id = 44;

-- Q45: Top 5 customers with returns (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "Top 5 customers by spend with returns: Customer_381 $0.62B (8 returns, 6.30% rate), Customer_821 $0.61B (8 returns, 6.06%), Customer_984 $0.60B (6 returns, 5.36%), Customer_769 $0.60B (2 returns, 1.74%), Customer_639 $0.60B (6 returns, 4.80%)."}')
WHERE question_id = 45;

-- Q46: 6-month rolling by promo (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "All 3 promotion types exceed $500M rolling average from the very first month (202201). Discount: first rolling avg $4.88B, BOGO: $3.51B, Clearance: $3.69B. Monthly revenue per promotion type is already well above $500M threshold."}')
WHERE question_id = 46;

-- Q47: Best quarter per brand tier (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "Best quarter per brand tier: Premium - 2023 Q3 $13.33B (4.96% above tier avg of $12.70B); Standard - 2022 Q4 $13.47B (5.49% above tier avg of $12.77B); Value - 2023 Q3 $13.12B (4.81% above tier avg of $12.51B). Best quarters are 4-6% above average."}')
WHERE question_id = 47;

-- Q48: Channel Pareto (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "Channel revenue ranked with cumulative %: Phone $92.42B (20.28%), In-Store $91.32B (40.32%), Mobile $91.21B (60.33%), Online $90.94B (80.28%), Partner $89.88B (100%). Top 4 channels (Phone, In-Store, Mobile, Online) cover 80.28% of total revenue."}')
WHERE question_id = 48;

-- Q49: Volatility by loyalty tier (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "Most volatile loyalty tier: Diamond (stddev $128,806, avg $4,527,426), then Bronze ($119,843 stddev, avg $4,552,456), Gold ($109,638 stddev, avg $4,586,478), Silver ($105,116 stddev, avg $4,548,201), Platinum ($96,272 stddev, avg $4,577,500). Diamond shows highest monthly volatility."}')
WHERE question_id = 49;

-- Q50: Top product per currency (actual values)
UPDATE Q1_EVAL_DATASET_V3
SET ground_truth = PARSE_JSON('{"ground_truth_output": "Top product type per currency: EUR - Sports $38.10B (25.37%), GBP - Electronics $38.72B (25.27%), USD - Sports $38.53B (25.29%). Each top product contributes approximately 25% of its currency total revenue."}')
WHERE question_id = 50;
