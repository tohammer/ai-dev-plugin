---
name: debug
description: Find and fix the cause of a bug, test failure or unexpected behaviour by reproducing it, isolating the cause with evidence and adding a regression test. Use before proposing a fix for any defect whose cause is not already known. Not for flaky tests; use devflow:test.
---

# Debug

## Steps

1. **Reproduce.** Get a command or test that shows the failure reliably,
   ideally as a script that exits 0 when good and non-zero when bad.
   Establish whether it ever worked: a regression points to bisecting,
   never-worked to the spec or a wrong assumption. Without a
   reproduction, see No local reproduction.
2. **Isolate.** Narrow down where it goes wrong with evidence:
   - Read the error fully; compare with a working case, including
     versions, configuration and environment; check recent changes.
   - A regression with a known good commit: keep the script outside
     the repository and run `git bisect run` on it (exit 125 skips a
     commit that cannot be tested).
   - A large failing input or test set: shrink it until removing
     anything more makes the failure go away.
   - A wrong value: trace it back caller by caller to where it was
     first produced; that is where the fix goes.
   - Add targeted logging, marked (e.g. `DEBUG-TMP`) for removal. When
     logging does not settle a question about runtime state, use the
     language's debugger in batch mode (`gdb -batch -ex run -ex bt`,
     `lldb -b -o`, pdb with scripted commands).
3. **Explain.** State the cause and how the evidence shows it. If you
   cannot explain why the failure happens, you have not found the cause.
4. **Fix.** Write a test for this cause and run it to see it fail, then
   fix the cause, not the symptom. Keep the fix to the defect. Once the reproduction
   passes, save that state (`git stash store $(git stash create)` or a
   patch in the scratchpad) before any further edit.
5. **Clean up.** Remove the marked logging and scratch scripts; the
   diff holds only the fix and its test. Search for the same mistake
   elsewhere and fix it or list it for the user.
6. **Verify.** Run the reproduction and the checks from `## Checks`
   (brief agents with them). Without that section, determine the
   commands, tell the user which were used and offer to record them
   with `/devflow:init`. A stale or duplicate
   section: propose the fix to the user.

## Hypothesis log

Keep a short log in your replies, one line per hypothesis: the
prediction, the experiment run, the actual result, confirmed or ruled
out. Each new hypothesis must fit all earlier results. Never conclude
from an experiment you did not run or output you did not see.

## No local reproduction

Build a timeline from logs, crash reports and the deployed version and
configuration; list what differs from a working setup and try to
recreate those conditions as a test. If that fails, say so, and propose
logging at component boundaries that would confirm or rule out each
open hypothesis next time.

## Subagents

- `devflow:explorer` for reading long logs or locating code paths.
- `devflow:verifier` for running test suites and extracting failures.
- Keep the reasoning about the cause with yourself.

## If stuck

Signs: a fix you cannot explain, a symptom that moves elsewhere, an
experiment you already ran. Then list five to seven possible causes
ranked by likelihood before the next experiment.

After two fixes that did not hold, stop patching. The model of the
problem is wrong: go back to step 2, or question the design with the
user: what the failed fixes show, the options with their pros and cons,
and your recommendation with the reason it is better.

## Afterwards

A cause that reveals a design problem or a durable lesson is recorded:
an ADR for a decision, `docs/architecture.md` for a lesson, the backlog
for follow-up work.
