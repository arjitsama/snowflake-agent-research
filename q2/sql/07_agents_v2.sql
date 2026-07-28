-- 07_agents_v2.sql
-- Q2 Phase 2: Haiku agents for cheaper model testing on harder questions
-- Tests if haiku breaks on ambiguous routing and cross-view queries

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- V4 Haiku (4 views: Sales + Marketing + CRM + Finance)
CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q2_V4_HAIKU
FROM SPECIFICATION $$
models:
  orchestration: claude-haiku-4-5
instructions:
  response: "Answer concisely using the available data tools."
tools:
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "SalesAnalyst"
      description: "Use for questions about sales orders, revenue, bookings, order volume, and product performance by region/channel."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "MarketingAnalyst"
      description: "Use for questions about marketing campaigns, ad spend, channel effectiveness, and conversion attribution."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "CRMAnalyst"
      description: "Use for questions about deal pipeline, opportunities, win rates, rep performance, and sales forecasting."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "FinanceAnalyst"
      description: "Use for questions about general ledger, expenses, revenue recognition, cost center budgets, and P&L."
tool_resources:
  SalesAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.SALES_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  MarketingAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.MARKETING_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  CRMAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.CRM_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  FinanceAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.FINANCE_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
$$;

-- V12 Haiku (all 12 views)
CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q2_V12_HAIKU
FROM SPECIFICATION $$
models:
  orchestration: claude-haiku-4-5
instructions:
  response: "Answer concisely using the available data tools."
tools:
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "SalesAnalyst"
      description: "Use for questions about sales orders, revenue, bookings, order volume, and product performance by region/channel."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "MarketingAnalyst"
      description: "Use for questions about marketing campaigns, ad spend, channel effectiveness, and conversion attribution."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "CRMAnalyst"
      description: "Use for questions about deal pipeline, opportunities, win rates, rep performance, and sales forecasting."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "FinanceAnalyst"
      description: "Use for questions about general ledger, expenses, revenue recognition, cost center budgets, and P&L."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "HRAnalyst"
      description: "Use for questions about headcount, employee turnover, department size, and compensation benchmarks."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "PayrollAnalyst"
      description: "Use for questions about payroll expenses, tax withholdings, benefits costs, and net pay by department."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "RecruitingAnalyst"
      description: "Use for questions about hiring velocity, candidate pipeline, source effectiveness, and time-to-fill."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "SupplyChainAnalyst"
      description: "Use for questions about shipments, delivery performance, shipping costs, and carrier efficiency."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "InventoryAnalyst"
      description: "Use for questions about stock levels, backorders, warehouse utilization, and reorder points."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "ProcurementAnalyst"
      description: "Use for questions about purchase orders, vendor performance, procurement spend, and supplier costs."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "SupportAnalyst"
      description: "Use for questions about support tickets, resolution times, CSAT scores, and agent performance."
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "WebAnalyticsAnalyst"
      description: "Use for questions about website traffic, page views, conversion rates, session duration, and traffic sources."
tool_resources:
  SalesAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.SALES_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  MarketingAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.MARKETING_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  CRMAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.CRM_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  FinanceAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.FINANCE_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  HRAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.HR_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  PayrollAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.PAYROLL_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  RecruitingAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.RECRUITING_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  SupplyChainAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.SUPPLY_CHAIN_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  InventoryAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.INVENTORY_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  ProcurementAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.PROCUREMENT_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  SupportAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.SUPPORT_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
  WebAnalyticsAnalyst:
    semantic_view: "CORTEX_AGENT_LAB.SEMANTIC.WEB_ANALYTICS_VIEW"
    execution_environment:
      type: warehouse
      warehouse: "LAB_WH"
$$;
