-- 02_agents_view_routing.sql
-- Q3 Model Sensitivity: Agents for view-routing dimension
-- 4 models x 3 view counts (4, 8, 12) = 12 agents
-- Reuses domain semantic views created by Q2

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

-- ============================================
-- CLAUDE-OPUS-4-7 (frontier)
-- ============================================

-- 4 views (Sales + Marketing + CRM + Finance)
CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_V4_OPUS
FROM SPECIFICATION $$
models:
  orchestration: claude-opus-4-7
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

-- 8 views
CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_V8_OPUS
FROM SPECIFICATION $$
models:
  orchestration: claude-opus-4-7
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
$$;

-- 12 views (all)
CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_V12_OPUS
FROM SPECIFICATION $$
models:
  orchestration: claude-opus-4-7
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

-- ============================================
-- CLAUDE-SONNET-4-6 (mid-high)
-- ============================================

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_V4_SONNET
FROM SPECIFICATION $$
models:
  orchestration: claude-sonnet-4-6
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

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_V8_SONNET
FROM SPECIFICATION $$
models:
  orchestration: claude-sonnet-4-6
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
$$;

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_V12_SONNET
FROM SPECIFICATION $$
models:
  orchestration: claude-sonnet-4-6
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

-- ============================================
-- LLAMA3.1-70B (mid-cheap)
-- ============================================

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_V4_LLAMA
FROM SPECIFICATION $$
models:
  orchestration: llama3.1-70b
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

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_V8_LLAMA
FROM SPECIFICATION $$
models:
  orchestration: llama3.1-70b
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
$$;

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_V12_LLAMA
FROM SPECIFICATION $$
models:
  orchestration: llama3.1-70b
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

-- ============================================
-- DEEPSEEK-R1 (cheap)
-- ============================================

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_V4_DEEPSEEK
FROM SPECIFICATION $$
models:
  orchestration: deepseek-r1
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

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_V8_DEEPSEEK
FROM SPECIFICATION $$
models:
  orchestration: deepseek-r1
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
$$;

CREATE OR REPLACE AGENT CORTEX_AGENT_LAB.AGENTS.Q3_V12_DEEPSEEK
FROM SPECIFICATION $$
models:
  orchestration: deepseek-r1
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
