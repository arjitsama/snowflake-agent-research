-- 01_agents_table_scaling.sql
-- Q3 Model Sensitivity: Agents for table-scaling dimension
-- 4 models x 3 tiers (T5, T10, T20) = 12 agents
-- Reuses RetailCorp semantic views created by Q1

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- ============================================
-- CLAUDE-OPUS-4-7 (frontier)
-- ============================================

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_T5_OPUS
FROM SPECIFICATION $$
models:
  orchestration: claude-opus-4-7
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

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_T10_OPUS
FROM SPECIFICATION $$
models:
  orchestration: claude-opus-4-7
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

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_T20_OPUS
FROM SPECIFICATION $$
models:
  orchestration: claude-opus-4-7
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

-- ============================================
-- CLAUDE-SONNET-4-6 (mid-high)
-- ============================================

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_T5_SONNET
FROM SPECIFICATION $$
models:
  orchestration: claude-sonnet-4-6
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

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_T10_SONNET
FROM SPECIFICATION $$
models:
  orchestration: claude-sonnet-4-6
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

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_T20_SONNET
FROM SPECIFICATION $$
models:
  orchestration: claude-sonnet-4-6
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

-- ============================================
-- LLAMA3.1-70B (mid-cheap)
-- ============================================

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_T5_LLAMA
FROM SPECIFICATION $$
models:
  orchestration: llama3.1-70b
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

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_T10_LLAMA
FROM SPECIFICATION $$
models:
  orchestration: llama3.1-70b
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

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_T20_LLAMA
FROM SPECIFICATION $$
models:
  orchestration: llama3.1-70b
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

-- ============================================
-- DEEPSEEK-R1 (cheap)
-- ============================================

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_T5_DEEPSEEK
FROM SPECIFICATION $$
models:
  orchestration: deepseek-r1
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

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_T10_DEEPSEEK
FROM SPECIFICATION $$
models:
  orchestration: deepseek-r1
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

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_T20_DEEPSEEK
FROM SPECIFICATION $$
models:
  orchestration: deepseek-r1
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
