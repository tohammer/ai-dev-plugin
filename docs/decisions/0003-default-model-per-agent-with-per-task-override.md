# 0003 — Default model per agent, overridden per task

Date: 2026-10-03
Status: superseded by [0016](0016-model-named-at-dispatch-per-host.md)

## Context

Subagents should be cheap where possible, but a fixed model per agent
either wastes money on simple tasks or underpowers complex ones. Opus is
acceptable for complex work.

## Decision

Each agent file sets a default model (haiku for explorer, verifier and
doc-checker; sonnet for implementer and reviewer). The orchestrator
overrides it per dispatch with the Agent tool's `model` parameter,
following the rule "cheapest model that can do the task well". Opus is
used for concurrency, security, cross-module interfaces and subtle
logic. Design, spec writing, briefing and triage stay with the
orchestrator.

## Consequences

- Cost follows task difficulty instead of agent type.
- The choice relies on the orchestrator's judgment; the skills give it
  criteria, not a table to look up.
- A task that fails twice on a cheaper model is escalated or taken over
  by the orchestrator.
