---
name: review
description: Review a change against its spec and for defects using reviewer subagents, verify the findings, then fix or defer them. Use after implementing a feature, before merging, or when asked to review a diff or branch.
---

# Review

## Steps

1. **Scope.** Determine the diff: the argument if given, otherwise the
   branch against its base, or the uncommitted changes. Find the spec it
   implements, if any.
2. **Dispatch.** Send `devflow:reviewer` the diff range, the spec path,
   the commands from `## Checks`, and the reasons implementer reports
   gave for changes to existing tests, if known. Without that section, determine
   the commands, tell the user which were used and offer to record them
   with `/devflow:init`. A stale or duplicate
   section: propose the fix to the user.
   - Small, ordinary change: one reviewer at sonnet/high (2nd
     opus/low); opus/medium if any part meets an opus criterion.
   - Large change: several reviewers in parallel, one focus each:
     spec conformance at sonnet/medium (2nd opus/low); correctness at
     opus/medium (opus/high when the change meets an opus criterion);
     security at opus/high, always (2nd opus/xhigh).
   - A 2nd choice is for a re-dispatch, or up front only when the
     change is harder than usual; then say why in the brief.
   - A reviewer that fails or returns nothing usable: re-dispatch once
     at its 2nd choice; without one, one step up the ladder.
   - Ladder, weakest first: haiku/low, haiku/medium, sonnet/low,
     sonnet/medium, sonnet/high (about opus/low), opus/medium,
     opus/high, opus/xhigh.
   - Opus criteria. A change meets one if: (1) shared state under
     concurrency: threads, async tasks, processes or concurrent
     requests read and write the same state; (2) security boundary:
     authentication, authorization, secrets, cryptography, or outside
     input reaching a shell, SQL, a template, a file path or a
     deserializer; (3) breaking change to a signature, behaviour, file
     format or schema that existing code or stored data relies on (a
     new interface or calling another module does not count); (4)
     errors example tests rarely catch: floating-point precision, dates
     and time zones, cache invalidation, state machines, parsers.
     When unsure, treat a criterion as not met, except criterion 2.
3. **Verify.** Check every finding against the code before acting on
   it. Drop those that do not hold, and say so. A reviewer's finding is
   a lead, not a fact.
4. **UI check.** If the change touches the UI and automated tests
   (component, end-to-end, screenshot) do not cover it, test it manually
   before the review is complete. Drive the app yourself where possible
   (browser automation, screenshots, running it) and record what you
   checked. Otherwise give the user exact steps and wait for the result.
   A failed check is a finding.
5. **Decide.** Present the confirmed findings ordered by severity.
   Fix the clear defects. Where fixing is a judgment call (cost, scope,
   taste), the user decides between fixing and deferring: for each,
   explain the finding briefly, give the pros and cons of fixing now
   and of deferring, and recommend one with the reason it is better.
6. **Fix.** Small fixes yourself; larger ones through
   `devflow:implementer` with a brief, at sonnet/medium (opus/high for
   a finding that meets an opus criterion); a fix that fails twice goes
   one step up the ladder, or you do it. Re-run the checks with
   `devflow:verifier` at haiku/low.
7. **Defer.** Every confirmed finding that is not fixed goes into
   `docs/backlog.md` with its origin (which review, which spec), the
   reason it was deferred and when to revisit it.

## Reporting

Tell the user what was found, what was fixed, what was deferred, which
UI paths were tested manually and how, and what the review did not
cover.
