# 0017 — Effort named at dispatch, with the model

Date: 2026-11-09
Status: accepted

## Context

ADR 0016 has every dispatch name a model, but not a reasoning effort.
The host default then applies. On Claude Code that is medium for opus
and haiku and high for sonnet: too little for security work, too much
for routine coding. Several dispatches named no model at all. "Stronger
model" and "critical" were never defined. "Cross-module interfaces" and
"subtle logic" as reasons for opus matched almost every task.

Prices per million output tokens: haiku $0.50, sonnet $10, opus $20.
Cached input costs $0.20 on sonnet and opus alike.

## Decision

Agent files set neither model nor effort. Every dispatch names both,
written `model/effort`, for example `opus/high`. Effort is `low`,
`medium`, `high` or `xhigh`, never `max`. It is passed only where the
host's dispatch tool takes one: Claude Code does, Copilot is unknown.
Otherwise only the model is passed.

One ladder, weakest first: haiku/low, haiku/medium, sonnet/low,
sonnet/medium, sonnet/high (about opus/low), opus/medium, opus/high,
opus/xhigh. Skills name a 1st choice and, where useful, a 2nd that is
never weaker. After two failures a task is re-run at its 2nd choice, or
one step up the ladder where there is none; nothing goes above
opus/xhigh.

A task gets opus only if one of four criteria holds: shared state
under concurrency; a security boundary; a breaking change to what
existing code or stored data relies on; errors that example tests
rarely catch. With a spec, its task list marks each opus task
`(opus: <criterion>)`, so the user sees the marks at review. Without a
spec the orchestrator applies the criteria and names the criterion in
the brief.

This extends ADR 0016, which stays accepted for the host spelling of
model names. 0016's tiers (haiku mechanical, sonnet ordinary, opus
complex) and its escalation rule are replaced by the choices per task,
the four criteria and the ladder.

## Consequences

- Cost follows the task, not the agent.
- The choice per task is written out in each skill, because skills
  cannot read plugin files. `core.md` keeps only the one-line rule and
  the host spelling; the ladder and the criteria are in the skills that
  use them. An explicit choice at each dispatch costs fewer tokens than
  the orchestrator deriving one from general rules.
- The order of the ladder is an estimate until the cost comparison in
  the spec is done.
- On a host without an effort parameter the host default still
  applies.
- A new model version means updating the spelling map, the ladder and
  the README.
