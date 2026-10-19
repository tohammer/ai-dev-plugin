# 0010 — Testing rules in implementer and reviewer

Date: 2026-10-19
Status: accepted

## Context

Testing was one line in `implementer` ("test-first where testable").
Common failures (tests of implementation details, tests that never
failed, mock-only assertions, snapshots in place of assertions, tests
weakened to get green, retried flaky tests) went unchecked. The rules
need a home. Alternatives: `core.md`, which is at its 70-line cap and
costs every session; only a `test` skill, which a subagent does not see
and normal feature work does not load; the agents that write and judge
tests.

## Decision

The rules live in `agents/implementer.md`, which writes almost all
tests, and as a check in `agents/reviewer.md`. The `test` skill repeats
them, because skills cannot read plugin files, and adds what only
deliberate test work needs: choosing a test level, characterization
tests, flaky-test repair.

## Consequences

- No always-on cost; the rules apply where tests are written and judged.
- The rules exist in three places. `tests/run.sh` checks that a shared
  key phrase is present in all three, so an edit to one is a reminder to
  edit the others.
- When the orchestrator writes tests itself, it follows the rules only
  through `review`, which judges them.
