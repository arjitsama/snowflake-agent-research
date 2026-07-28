-- Q1 Table Scaling Experiment: Evaluation Results
-- Pull and format results from EXECUTE_AI_EVALUATION runs

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;

-- Raw results
SELECT *
FROM TABLE(SYSTEM$GET_AI_EVALUATION_DATA())
WHERE label LIKE 'Q1 Table Scaling%'
ORDER BY label, metric_name;

-- Summary pivot
SELECT
    label,
    MAX(CASE WHEN metric_name = 'answer_correctness' THEN metric_value END) AS answer_correctness,
    MAX(CASE WHEN metric_name = 'logical_consistency' THEN metric_value END) AS logical_consistency
FROM TABLE(SYSTEM$GET_AI_EVALUATION_DATA())
WHERE label LIKE 'Q1 Table Scaling%'
GROUP BY label
ORDER BY label;

-- Per-question detail (for debugging which questions failed)
SELECT
    label,
    input_query,
    metric_name,
    metric_value,
    output
FROM TABLE(SYSTEM$GET_AI_EVALUATION_DATA())
WHERE label LIKE 'Q1 Table Scaling%'
ORDER BY label, input_query, metric_name;
