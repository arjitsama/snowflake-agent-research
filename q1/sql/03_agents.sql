-- Q1 Table Scaling Experiment: Agent Definitions
-- One agent per tier (T5, T10, T20) to test independently

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- T5 Agent (5 tables)
CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.RETAILCORP_T5_AGENT
FROM SPECIFICATION $$
models:
  orchestration: auto
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

-- T10 Agent (10 tables)
CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.RETAILCORP_T10_AGENT
FROM SPECIFICATION $$
models:
  orchestration: auto
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

-- T20 Agent (20 tables)
CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.RETAILCORP_T20_AGENT
FROM SPECIFICATION $$
models:
  orchestration: auto
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
