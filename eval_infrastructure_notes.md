# Evaluation Infrastructure Notes

## Judge Configuration
- Judge model: Snowflake default (likely llama3.1-70b per docs, not configurable via YAML)
- Scoring: 3-point scale normalized to 0.0-1.0
- Avg judge tokens per question: ~1,923 (prompt + completion)
- Agent models tested: claude-sonnet-4-6, claude-haiku-4-5, openai-gpt-5-mini

## Model Versions (as of July 2026)
- Snowflake does not expose specific model version/checkpoint in eval traces
- Model drift cannot be detected without re-running baselines periodically
- Recommendation: re-run T5 baseline monthly to catch drift

## Known Limitations
- GET_AI_RECORD_TRACE requires additional privileges (MONITOR on agent + observability access)
- Generated SQL is NOT exposed in GET_AI_EVALUATION_DATA output field
- Cannot do execution-based scoring (compare agent SQL output vs reference SQL) without trace access
- logical_consistency metric fails on current platform - removed from all configs, using answer_correctness only

## Failed Runs (documented)
- q1-v3-t20-haiku-run1: 0 scored records (agent completed but metrics returned nothing)
- q1-v3-t20-gptmini-run5: 0 scored records (same issue)
- Root cause: unknown (transient platform issue, not reproducible)

## Schema Context Bug
- EXECUTE_AI_EVALUATION must be called with USE SCHEMA set to where the agent lives
- If called from EVAL schema, metric computation fails with "agent does not exist" 
- Fix: always run `USE SCHEMA AGENTS` before launching evals
