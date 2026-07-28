-- 02_agents.sql
-- Q5 Trust Experiment: Abstention-instructed agent variants
-- Same as baseline agents but with explicit instruction to refuse when data is unavailable

USE WAREHOUSE LAB_WH;
USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- T5 with abstention instruction
CREATE OR REPLACE AGENT Q5_T5_ABSTAIN_HAIKU
FROM SPECIFICATION $$
models:
  orchestration: "claude-haiku-4-5"
instructions:
  response: "Answer concisely using the available data tool. IMPORTANT: If the data needed to answer a question is not available in your tools, say so clearly. Do not guess or fabricate numbers. It is better to decline than to give a wrong answer. If a specific entity (like a store type, region, or product category) does not exist in the data, state that explicitly."
tools:
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "RetailCorpAnalyst"
      description: "Use for all questions about RetailCorp sales, revenue, customers, products, stores, transactions, and performance."
tool_resources:
  RetailCorpAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_T5"
    execution_environment:
      type: "warehouse"
      warehouse: "LAB_WH"
$$;

-- T10 with abstention instruction
CREATE OR REPLACE AGENT Q5_T10_ABSTAIN_HAIKU
FROM SPECIFICATION $$
models:
  orchestration: "claude-haiku-4-5"
instructions:
  response: "Answer concisely using the available data tool. IMPORTANT: If the data needed to answer a question is not available in your tools, say so clearly. Do not guess or fabricate numbers. It is better to decline than to give a wrong answer. If a specific entity (like a store type, region, or product category) does not exist in the data, state that explicitly."
tools:
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "RetailCorpAnalyst"
      description: "Use for all questions about RetailCorp sales, revenue, customers, products, stores, transactions, and performance."
tool_resources:
  RetailCorpAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_T10"
    execution_environment:
      type: "warehouse"
      warehouse: "LAB_WH"
$$;

-- T20 with abstention instruction
CREATE OR REPLACE AGENT Q5_T20_ABSTAIN_HAIKU
FROM SPECIFICATION $$
models:
  orchestration: "claude-haiku-4-5"
instructions:
  response: "Answer concisely using the available data tool. IMPORTANT: If the data needed to answer a question is not available in your tools, say so clearly. Do not guess or fabricate numbers. It is better to decline than to give a wrong answer. If a specific entity (like a store type, region, or product category) does not exist in the data, state that explicitly."
tools:
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "RetailCorpAnalyst"
      description: "Use for all questions about RetailCorp sales, revenue, customers, products, stores, transactions, and performance."
tool_resources:
  RetailCorpAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_T20"
    execution_environment:
      type: "warehouse"
      warehouse: "LAB_WH"
$$;
