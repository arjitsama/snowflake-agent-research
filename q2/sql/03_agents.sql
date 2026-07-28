-- 03_agents.sql
-- Create evaluation agents with increasing semantic view counts
-- Account: <YOUR_ACCOUNT> | Warehouse: LAB_WH

USE WAREHOUSE LAB_WH;
USE SCHEMA CORTEX_AGENT_LAB.AGENTS;

----------------------------------------------------------------------
-- R1: 1 view (Sales only)
----------------------------------------------------------------------
CREATE OR REPLACE CORTEX AGENT EVAL_AGENT_R1
  COMMENT = 'Round 1 - Single domain agent with 1 semantic view (Sales)'
  TOOLS = (
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.SALES_VIEW'
  )
  EXECUTION_ENVIRONMENT = (
    WAREHOUSE = 'LAB_WH'
  );

----------------------------------------------------------------------
-- R2: 2 views (Sales + Marketing)
----------------------------------------------------------------------
CREATE OR REPLACE CORTEX AGENT EVAL_AGENT_R2
  COMMENT = 'Round 2 - Agent with 2 semantic views (Sales, Marketing)'
  TOOLS = (
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.SALES_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.MARKETING_VIEW'
  )
  EXECUTION_ENVIRONMENT = (
    WAREHOUSE = 'LAB_WH'
  );

----------------------------------------------------------------------
-- R3: 4 views (Sales + Marketing + CRM + Finance)
----------------------------------------------------------------------
CREATE OR REPLACE CORTEX AGENT EVAL_AGENT_R3
  COMMENT = 'Round 3 - Agent with 4 semantic views (Sales, Marketing, CRM, Finance)'
  TOOLS = (
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.SALES_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.MARKETING_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.CRM_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.FINANCE_VIEW'
  )
  EXECUTION_ENVIRONMENT = (
    WAREHOUSE = 'LAB_WH'
  );

----------------------------------------------------------------------
-- R4: 8 views (Commercial + People + partial Operations)
----------------------------------------------------------------------
CREATE OR REPLACE CORTEX AGENT EVAL_AGENT_R4
  COMMENT = 'Round 4 - Agent with 8 semantic views (Sales, Marketing, CRM, Finance, HR, Payroll, Recruiting, Supply Chain)'
  TOOLS = (
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.SALES_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.MARKETING_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.CRM_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.FINANCE_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.HR_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.PAYROLL_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.RECRUITING_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.SUPPLY_CHAIN_VIEW'
  )
  EXECUTION_ENVIRONMENT = (
    WAREHOUSE = 'LAB_WH'
  );

----------------------------------------------------------------------
-- R5 / Full: 12 views (all domains)
----------------------------------------------------------------------
CREATE OR REPLACE CORTEX AGENT ROUTING_EXPERIMENT_AGENT
  COMMENT = 'Round 5 - Full agent with all 12 semantic views across all domains'
  TOOLS = (
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.SALES_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.MARKETING_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.CRM_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.FINANCE_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.HR_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.PAYROLL_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.RECRUITING_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.SUPPLY_CHAIN_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.INVENTORY_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.PROCUREMENT_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.SUPPORT_VIEW',
    SEMANTIC_VIEW = 'CORTEX_AGENT_LAB.SEMANTIC.WEB_ANALYTICS_VIEW'
  )
  EXECUTION_ENVIRONMENT = (
    WAREHOUSE = 'LAB_WH'
  );
