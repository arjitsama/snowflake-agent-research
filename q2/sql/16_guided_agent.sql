-- 16_guided_agent.sql
-- Step 4: Routing-guidance experiment
-- Creates Q2_V12_GUIDED_HAIKU and Q2_V12_GUIDED_SONNET
-- Identical to V12 agents but with routing instructions added
-- Design rule: agent keeps access to all 12 views (soft routing, not gating)

USE DATABASE CORTEX_AGENT_LAB;
USE SCHEMA AGENTS;

CREATE OR REPLACE AGENT Q2_V12_GUIDED_HAIKU FROM SPECIFICATION $$
models:
  orchestration: claude-haiku-4-5
instructions:
  response: |
    Answer concisely using the available data tools. Follow the routing guide below.

    ROUTING GUIDE:
    - SalesAnalyst: orders, revenue, bookings, order volume, product sales. Does NOT cover marketing spend, deals/pipeline, or expenses.
    - MarketingAnalyst: campaigns, ad spend, channel attribution, conversion events. Does NOT cover actual sales revenue or deal pipeline.
    - CRMAnalyst: deal pipeline, opportunities, win rates, probability, forecasting. Does NOT cover actual completed orders or marketing campaigns.
    - FinanceAnalyst: GL entries, expenses, cost centers, budgets, P&L. Does NOT cover individual sales transactions or marketing campaigns.
    - HRAnalyst: headcount, employee data, departments, turnover, compensation. Does NOT cover payroll processing or recruiting pipeline.
    - PayrollAnalyst: gross pay, tax withholdings, benefits, net pay. Does NOT cover headcount snapshots or recruiting.
    - RecruitingAnalyst: job applications, hiring pipeline, sources, time-to-hire. Does NOT cover current headcount or payroll.
    - SupplyChainAnalyst: shipments, shipping cost, delivery, carriers. Does NOT cover purchase orders or inventory levels.
    - InventoryAnalyst: stock levels, warehouse inventory, units on hand. Does NOT cover shipments in transit or procurement orders.
    - ProcurementAnalyst: purchase orders, vendor spend, procurement cost. Does NOT cover shipping or inventory counts.
    - SupportAnalyst: support tickets, resolution time, priority, agents. Does NOT cover sales or CRM deals.
    - WebAnalyticsAnalyst: web sessions, page views, conversion rates, session duration. Does NOT cover marketing campaign spend or CRM deals.

    TIE-BREAKERS:
    - "total cost by region" -> FinanceAnalyst (unless shipping is mentioned, then SupplyChainAnalyst)
    - "customer acquisition cost" -> MarketingAnalyst (has spend data)
    - "product performance" -> SalesAnalyst (revenue-based)
    - "pipeline" or "deals" -> CRMAnalyst
    - "headcount cost" or "salary" -> PayrollAnalyst or HRAnalyst
    - "vendor spend" -> ProcurementAnalyst
    - "online presence" or "web traffic" -> WebAnalyticsAnalyst

    MULTI-VIEW CLAUSE (IMPORTANT):
    Some questions require combining data from two or more views. When a question spans domains, query every view needed and merge the results. Never force a spanning question into a single view. If a question mentions both revenue AND marketing spend, call both SalesAnalyst and MarketingAnalyst. If it mentions both headcount AND payroll, call both HRAnalyst and PayrollAnalyst.
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: SalesAnalyst
      description: "Use for questions about sales orders, revenue, bookings, order volume, and product performance by region/channel."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: MarketingAnalyst
      description: "Use for questions about marketing campaigns, ad spend, channel effectiveness, and conversion attribution."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: CRMAnalyst
      description: "Use for questions about deal pipeline, opportunities, win rates, rep performance, and sales forecasting."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: FinanceAnalyst
      description: "Use for questions about general ledger, expenses, revenue recognition, cost center budgets, and P&L."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: HRAnalyst
      description: "Use for questions about headcount, employee turnover, department size, and compensation benchmarks."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: PayrollAnalyst
      description: "Use for questions about payroll expenses, tax withholdings, benefits costs, and net pay by department."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: RecruitingAnalyst
      description: "Use for questions about hiring velocity, candidate pipeline, source effectiveness, and time-to-fill."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: SupplyChainAnalyst
      description: "Use for questions about shipments, delivery performance, shipping costs, and carrier efficiency."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: InventoryAnalyst
      description: "Use for questions about stock levels, backorders, warehouse utilization, and reorder points."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: ProcurementAnalyst
      description: "Use for questions about purchase orders, vendor performance, procurement spend, and supplier costs."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: SupportAnalyst
      description: "Use for questions about support tickets, resolution times, CSAT scores, and agent performance."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: WebAnalyticsAnalyst
      description: "Use for questions about website traffic, page views, conversion rates, session duration, and traffic sources."
tool_resources:
  SalesAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.SALES_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  MarketingAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.MARKETING_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  CRMAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.CRM_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  FinanceAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.FINANCE_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  HRAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.HR_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  PayrollAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.PAYROLL_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  RecruitingAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RECRUITING_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  SupplyChainAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.SUPPLY_CHAIN_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  InventoryAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.INVENTORY_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  ProcurementAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.PROCUREMENT_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  SupportAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.SUPPORT_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  WebAnalyticsAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.WEB_ANALYTICS_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
$$;

-- Sonnet version (same routing guide, different model)
CREATE OR REPLACE AGENT Q2_V12_GUIDED_SONNET FROM SPECIFICATION $$
models:
  orchestration: claude-sonnet-4-6
instructions:
  response: |
    Answer concisely using the available data tools. Follow the routing guide below.

    ROUTING GUIDE:
    - SalesAnalyst: orders, revenue, bookings, order volume, product sales. Does NOT cover marketing spend, deals/pipeline, or expenses.
    - MarketingAnalyst: campaigns, ad spend, channel attribution, conversion events. Does NOT cover actual sales revenue or deal pipeline.
    - CRMAnalyst: deal pipeline, opportunities, win rates, probability, forecasting. Does NOT cover actual completed orders or marketing campaigns.
    - FinanceAnalyst: GL entries, expenses, cost centers, budgets, P&L. Does NOT cover individual sales transactions or marketing campaigns.
    - HRAnalyst: headcount, employee data, departments, turnover, compensation. Does NOT cover payroll processing or recruiting pipeline.
    - PayrollAnalyst: gross pay, tax withholdings, benefits, net pay. Does NOT cover headcount snapshots or recruiting.
    - RecruitingAnalyst: job applications, hiring pipeline, sources, time-to-hire. Does NOT cover current headcount or payroll.
    - SupplyChainAnalyst: shipments, shipping cost, delivery, carriers. Does NOT cover purchase orders or inventory levels.
    - InventoryAnalyst: stock levels, warehouse inventory, units on hand. Does NOT cover shipments in transit or procurement orders.
    - ProcurementAnalyst: purchase orders, vendor spend, procurement cost. Does NOT cover shipping or inventory counts.
    - SupportAnalyst: support tickets, resolution time, priority, agents. Does NOT cover sales or CRM deals.
    - WebAnalyticsAnalyst: web sessions, page views, conversion rates, session duration. Does NOT cover marketing campaign spend or CRM deals.

    TIE-BREAKERS:
    - "total cost by region" -> FinanceAnalyst (unless shipping is mentioned, then SupplyChainAnalyst)
    - "customer acquisition cost" -> MarketingAnalyst (has spend data)
    - "product performance" -> SalesAnalyst (revenue-based)
    - "pipeline" or "deals" -> CRMAnalyst
    - "headcount cost" or "salary" -> PayrollAnalyst or HRAnalyst
    - "vendor spend" -> ProcurementAnalyst
    - "online presence" or "web traffic" -> WebAnalyticsAnalyst

    MULTI-VIEW CLAUSE (IMPORTANT):
    Some questions require combining data from two or more views. When a question spans domains, query every view needed and merge the results. Never force a spanning question into a single view. If a question mentions both revenue AND marketing spend, call both SalesAnalyst and MarketingAnalyst. If it mentions both headcount AND payroll, call both HRAnalyst and PayrollAnalyst.
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: SalesAnalyst
      description: "Use for questions about sales orders, revenue, bookings, order volume, and product performance by region/channel."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: MarketingAnalyst
      description: "Use for questions about marketing campaigns, ad spend, channel effectiveness, and conversion attribution."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: CRMAnalyst
      description: "Use for questions about deal pipeline, opportunities, win rates, rep performance, and sales forecasting."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: FinanceAnalyst
      description: "Use for questions about general ledger, expenses, revenue recognition, cost center budgets, and P&L."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: HRAnalyst
      description: "Use for questions about headcount, employee turnover, department size, and compensation benchmarks."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: PayrollAnalyst
      description: "Use for questions about payroll expenses, tax withholdings, benefits costs, and net pay by department."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: RecruitingAnalyst
      description: "Use for questions about hiring velocity, candidate pipeline, source effectiveness, and time-to-fill."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: SupplyChainAnalyst
      description: "Use for questions about shipments, delivery performance, shipping costs, and carrier efficiency."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: InventoryAnalyst
      description: "Use for questions about stock levels, backorders, warehouse utilization, and reorder points."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: ProcurementAnalyst
      description: "Use for questions about purchase orders, vendor performance, procurement spend, and supplier costs."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: SupportAnalyst
      description: "Use for questions about support tickets, resolution times, CSAT scores, and agent performance."
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: WebAnalyticsAnalyst
      description: "Use for questions about website traffic, page views, conversion rates, session duration, and traffic sources."
tool_resources:
  SalesAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.SALES_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  MarketingAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.MARKETING_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  CRMAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.CRM_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  FinanceAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.FINANCE_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  HRAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.HR_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  PayrollAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.PAYROLL_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  RecruitingAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.RECRUITING_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  SupplyChainAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.SUPPLY_CHAIN_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  InventoryAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.INVENTORY_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  ProcurementAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.PROCUREMENT_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  SupportAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.SUPPORT_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
  WebAnalyticsAnalyst:
    semantic_view: CORTEX_AGENT_LAB.SEMANTIC.WEB_ANALYTICS_VIEW
    execution_environment:
      type: warehouse
      warehouse: LAB_WH
$$;
