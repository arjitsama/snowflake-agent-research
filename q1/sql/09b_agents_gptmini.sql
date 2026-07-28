-- 09b_agents_gptmini.sql
-- Creates GPT-5-mini agents at T5/T10/T20 for Phase 2 model comparison
-- These were created ad-hoc but never committed to repo

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

CREATE OR REPLACE AGENT Q1_T5_GPTMINI FROM SPECIFICATION $$
models:
  orchestration: openai-gpt-5-mini
instructions:
  response: "Answer concisely using the available data tool."
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: RetailCorpAnalyst
      description: "Use for all questions about RetailCorp sales, revenue, customers, products, stores, transactions, and performance."
tool_resources:
  RetailCorpAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_T5
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
$$;

CREATE OR REPLACE AGENT Q1_T10_GPTMINI FROM SPECIFICATION $$
models:
  orchestration: openai-gpt-5-mini
instructions:
  response: "Answer concisely using the available data tool."
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: RetailCorpAnalyst
      description: "Use for all questions about RetailCorp sales, revenue, customers, products, stores, promotions, sales reps, suppliers, shipments, returns, and performance."
tool_resources:
  RetailCorpAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_T10
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
$$;

CREATE OR REPLACE AGENT Q1_T20_GPTMINI FROM SPECIFICATION $$
models:
  orchestration: openai-gpt-5-mini
instructions:
  response: "Answer concisely using the available data tool."
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: RetailCorpAnalyst
      description: "Use for all questions about RetailCorp sales, revenue, customers, products, stores, channels, brands, regions, loyalty, employees, inventory, and performance."
tool_resources:
  RetailCorpAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_T20
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
$$;
