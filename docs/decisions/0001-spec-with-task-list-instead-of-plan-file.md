# 0001 — Spec with task list instead of a separate plan file

Date: 2026-10-03
Status: accepted

## Context

Superpowers produces two documents per feature: a reviewed spec and a
step-by-step implementation plan with pre-written code. With capable
models the plan mostly restates what the implementer would work out
itself, costs a second review, and goes stale. Alternatives considered:
a lean separate plan file, or no persisted task breakdown at all.

## Decision

The spec is the only reviewed document. It ends with an ordered task
list of checkboxes with acceptance criteria. The orchestrator briefs
each task to a subagent at execution time.

## Consequences

- One document to review and keep current per feature.
- Progress survives a session: the checkboxes show where to continue.
- Task briefs are not persisted; their quality depends on the
  orchestrator at the time.
- Tasks must be stated as outcomes with acceptance criteria, since there
  is no plan to carry the detail.
