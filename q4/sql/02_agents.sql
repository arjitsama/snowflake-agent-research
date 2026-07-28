-- 02_agents.sql
-- Step 5: Three agent architectures for head-to-head comparison
-- All use the same 20 RetailCorp tables, same 50 questions
--
-- (a) One big view: existing Q3_T20_SONNET / Q1_T20_HAIKU (RETAILCORP_T20)
-- (b) Four topic views: Q4_TOPIC_VIEWS_SONNET / Q4_TOPIC_VIEWS_HAIKU
--     Views: RETAILCORP_CORE_SALES, RETAILCORP_LOGISTICS, RETAILCORP_PROMOTIONS, RETAILCORP_GEO_ORG
-- (c) Supervisor over specialists: NOT POSSIBLE with current platform
--     Snowflake agents cannot call other agents as tools via SQL functions.
--     SNOWFLAKE.CORTEX.AGENT() function does not exist.
--     This architecture requires REST API-based orchestration outside SQL.

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- Architecture (b): Topic Views with routing guide
-- (See 01_topic_views.sql for the 4 semantic views)

CREATE OR REPLACE AGENT Q4_TOPIC_VIEWS_SONNET FROM SPECIFICATION $$
models:
  orchestration: claude-sonnet-4-6
instructions:
  response: |
    Answer concisely using the available data tools. Follow the routing guide below.

    ROUTING GUIDE:
    - CoreSalesAnalyst: revenue, customers, products, stores, dates, transactions, discounts.
    - LogisticsAnalyst: suppliers, shipments, shipping costs, returns, refunds.
    - PromotionsAnalyst: promotions, channels, segments, categories.
    - GeoOrgAnalyst: regions, brands, currencies, loyalty tiers, sales reps, territories.

    MULTI-VIEW CLAUSE (IMPORTANT):
    Some questions require combining data from two or more views. When a question spans topics, query every view needed and merge the results.
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: CoreSalesAnalyst
      description: "Revenue, customers, products, stores, dates."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: LogisticsAnalyst
      description: "Suppliers, shipments, returns."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: PromotionsAnalyst
      description: "Promotions, channels, segments, categories."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: GeoOrgAnalyst
      description: "Regions, brands, currencies, loyalty, sales reps."
tool_resources:
  CoreSalesAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_CORE_SALES
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  LogisticsAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_LOGISTICS
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  PromotionsAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_PROMOTIONS
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  GeoOrgAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_GEO_ORG
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
$$;

CREATE OR REPLACE AGENT Q4_TOPIC_VIEWS_HAIKU FROM SPECIFICATION $$
models:
  orchestration: claude-haiku-4-5
instructions:
  response: |
    Answer concisely using the available data tools. Follow the routing guide below.

    ROUTING GUIDE:
    - CoreSalesAnalyst: revenue, customers, products, stores, dates, transactions, discounts.
    - LogisticsAnalyst: suppliers, shipments, shipping costs, returns, refunds.
    - PromotionsAnalyst: promotions, channels, segments, categories.
    - GeoOrgAnalyst: regions, brands, currencies, loyalty tiers, sales reps, territories.

    MULTI-VIEW CLAUSE (IMPORTANT):
    Some questions require combining data from two or more views. When a question spans topics, query every view needed and merge the results.
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: CoreSalesAnalyst
      description: "Revenue, customers, products, stores, dates."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: LogisticsAnalyst
      description: "Suppliers, shipments, returns."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: PromotionsAnalyst
      description: "Promotions, channels, segments, categories."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: GeoOrgAnalyst
      description: "Regions, brands, currencies, loyalty, sales reps."
tool_resources:
  CoreSalesAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_CORE_SALES
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  LogisticsAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_LOGISTICS
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  PromotionsAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_PROMOTIONS
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  GeoOrgAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RETAILCORP_GEO_ORG
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
$$;
