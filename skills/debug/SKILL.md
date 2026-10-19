---
name: debug
description: Find and fix the cause of a bug, test failure or unexpected behaviour by reproducing it, isolating the cause with evidence and adding a regression test. Use before proposing a fix for any defect whose cause is not already known. Not for flaky tests; use devflow:test.
---

# Debug

## Steps

1. **Reproduce.** Get a command or test that shows the failure reliably.
   If it cannot be reproduced, gather what is known (logs, reports,
   recent changes) and say so before going further.
2. **Isolate.** Narrow down where it goes wrong with evidence: read the
   error fully, compare with a working case, check recent changes, add
   targeted logging, bisect. Form one hypothesis at a time and test it.
3. **Explain.** State the cause and how the evidence shows it. If you
   cannot explain why the failure happens, you have not found the cause.
4. **Fix.** Write a test that fails for this cause, then fix the cause,
   not the symptom. Keep the fix to the defect.
5. **Verify.** Run the reproduction and the checks from `## Checks`
   (brief agents with them). Without that section, determine the
   commands, tell the user which were used and offer to record them
   with `/devflow:init`. A stale or duplicate
   section: propose the fix to the user.

## Subagents

- `devflow:explorer` for reading long logs or locating code paths.
- `devflow:verifier` for running test suites and extracting failures.
- Keep the reasoning about the cause with yourself.

## If fixes keep failing

After two fixes that did not hold, stop patching. The model of the
problem is wrong: go back to step 2, or question the design with the
user: what the failed fixes show, the options with their pros and cons,
and your recommendation with the reason it is better.

## Afterwards

A cause that reveals a design problem or a durable lesson is recorded:
an ADR for a decision, `docs/architecture.md` for a lesson, the backlog
for follow-up work.
