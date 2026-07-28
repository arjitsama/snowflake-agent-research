-- 08_agents_haiku.sql
-- Q1 Phase 2: Cheapest Claude model (haiku-4-5) at each tier
-- Tests if the cheapest supported model breaks on harder questions
-- haiku costs 0.65/3.25 credits vs sonnet 1.95/9.76 vs opus 3.25/16.26

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- T5 Haiku
CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q1_T5_HAIKU
FROM SPECIFICATION $$
models:
  orchestration: claude-haiku-4-5
instructions:
  response: "Answer concisely using the available data tool."
tools:
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "RetailCorpAnalyst"
      description: "Use for all questions about RetailCorp sales, revenue, customers, products, stores, transactions, and performance."
tool_resources:
  RetailCorpAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_T5"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
$$;

-- T10 Haiku
CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q1_T10_HAIKU
FROM SPECIFICATION $$
models:
  orchestration: claude-haiku-4-5
instructions:
  response: "Answer concisely using the available data tool."
tools:
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "RetailCorpAnalyst"
      description: "Use for all questions about RetailCorp sales, revenue, customers, products, stores, promotions, sales reps, suppliers, shipments, returns, and performance."
tool_resources:
  RetailCorpAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_T10"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
$$;

-- T20 Haiku
CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q1_T20_HAIKU
FROM SPECIFICATION $$
models:
  orchestration: claude-haiku-4-5
instructions:
  response: "Answer concisely using the available data tool."
tools:
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "RetailCorpAnalyst"
      description: "Use for all questions about RetailCorp sales, revenue, customers, products, stores, channels, brands, regions, loyalty, employees, inventory, and performance."
tool_resources:
  RetailCorpAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_T20"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
$$;
