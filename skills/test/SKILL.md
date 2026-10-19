---
name: test
description: Add or repair tests for existing code - choose test levels, write characterization tests before changing untested code, fix flaky tests. Use when asked to add tests, raise coverage, cover code before a refactor, or fix a flaky test. Not for tests of a new feature, which implement writes with the code; not for a failing test whose cause is unknown, use devflow:debug.
---

# Test

## Steps

1. **Scope.** Take the code or tests the user named. Take the commands
   from the `## Checks` section of CLAUDE.md (or the AGENTS.md it
   imports). If there is none, determine them, tell the user which you
   used and offer to record them via devflow:init. Baseline:
   `devflow:verifier` runs the tests, and the coverage command if the
   project has one.
2. **Survey.** Find the existing framework, test levels, helpers,
   fixtures and naming. New tests follow them.
3. **Plan.** List the behaviours to cover, each with a level: unit for
   logic, integration for boundaries the project owns (its database,
   files, its own services), end-to-end only for a few main paths.
   For code about to change, write characterization tests: pin the
   current behaviour as it is. Behaviour that looks wrong is pinned
   with a comment and added to the backlog, not fixed. Show the plan
   to the user when it has more than about five tests or needs a new
   framework or tool (a dependency decision, with an ADR).
4. **Write.** Brief `devflow:implementer` with the plan and the testing
   rules below. Default model; haiku for mechanical additions to an
   existing pattern.
5. **Flaky.** Reproduce by repeated runs (e.g. 50) and in random or
   reverse order where the runner allows. Look for the cause: timing
   and sleeps, order dependence and shared state, time and time zones,
   randomness without a seed, network or external services,
   concurrency. `devflow:verifier` runs the repetitions;
   `devflow:implementer` fixes the cause, briefed with the evidence. No
   retries, longer sleeps or skips.
   Not reproducible or cause not found: report the runs made and add a
   backlog item. Quarantine the test (skipped, with a marker naming
   the backlog item) only with the user's approval.
6. **Verify.** `devflow:verifier` runs all checks. Every new test was
   seen failing: in the implementer report, or have the implementer
   break the code briefly and restore it.
7. **Report.** Tests added per behaviour and level, coverage before and
   after if measured, suspected bugs found with their backlog items,
   what was not covered and why.

## Testing rules

Include these in every brief to the implementer.

- Test behaviour through the public interface, not internals.
- Watch each new test fail before the code makes it pass, and report
  the failure seen. A test that already passes (characterization) is
  checked by breaking the code briefly.
- Assert on results and effects. Prefer real objects, then fakes; mock
  only what is slow or not deterministic (network, clock, external
  services). A test that only checks that mocks were called tests
  nothing.
- No snapshot in place of an assertion on the value that matters.
- Never skip, delete or loosen a test, or change its expected value, to
  get green. A test you believe is wrong goes in the report. The one
  exception is a quarantine the user approved (step 5).
- A flaky test is a defect: report it; never retry it until it passes.

## Error handling

- No test framework in the project: stop and propose one with pros,
  cons and a recommendation. Install nothing without approval.
- A check command cannot run (missing tool, service down): report it as
  not run, never as passed.
- A test that cannot be seen failing (code cannot be broken in
  isolation): say so in the report for each such test.

## Asking the user

A question gets a brief explanation, the options with pros and cons,
and your recommendation with the reason it is better.
