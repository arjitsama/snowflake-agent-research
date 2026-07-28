# Q3 Model Sensitivity Experiment

## Research Question

Do different orchestration models perform differently at scale? Does paying more buy headroom?

## Result

**Partially answered. Only Claude and OpenAI models work as orchestrators.**

### What Works
| Model | Works as Orchestrator | Notes |
|-------|----------------------|-------|
| claude-sonnet-4-6 | Yes | Best cost/performance ratio |
| claude-haiku-4-5 | Yes | 3x cheaper, only slight accuracy loss |
| openai-gpt-5-mini | Yes | 7.5x cheaper than Sonnet, 11-14pt more degradation at T20 |
| claude-opus-4-7 | Yes | 5x more expensive than Sonnet, no accuracy benefit (single-run data) |

### What Doesn't Work
| Model | Issue |
|-------|-------|
| deepseek-r1 | Creates as agent but never executes queries |
| llama3.1-70b | Creates as agent but never executes queries |

## Key Findings

1. GPT-mini works (contradicts earlier draft that said "only Claude works").
2. Cheaper models suffer MORE from schema clutter: GPT-mini drops 14pts T5→T20 vs Sonnet's 13pts, but GPT-mini has higher variance (±6-7 stddev vs ±2 for Sonnet).
3. Opus vs Sonnet comparison is based on Phase 1 single-run data (10 questions, old broken dataset). This needs re-running under Phase 3 methodology before making a recommendation.

## Caveats

- The "don't pay for Opus" recommendation was based on a single run with 10 questions on the old (broken) dataset. It may still be true but isn't proven to Phase 3 standards.
- DeepSeek/Llama failure is a platform limitation, not a model capability issue.

## File Structure

```
q3/
├── sql/
│   ├── 01_agents_table_scaling.sql  (12 agents: 4 models × T5/T10/T20)
│   ├── 02_agents_view_routing.sql   (12 agents: 4 models × V4/V8/V12)
│   ├── 03_run_evals.sql             (eval execution)
│   └── 04_results.sql               (results pivot)
└── yaml/                            (24 eval configs)
```
