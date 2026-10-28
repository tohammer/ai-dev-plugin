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
   - Small, ordinary change: one reviewer on sonnet.
   - Large or critical change: several reviewers in parallel, one focus
     each (spec conformance, correctness, security), on opus
     where the code is security- or correctness-critical.
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
   `devflow:implementer` with a brief. Re-run the checks with
   `devflow:verifier`.
7. **Defer.** Every confirmed finding that is not fixed goes into
   `docs/backlog.md` with its origin (which review, which spec), the
   reason it was deferred and when to revisit it.

## Reporting

Tell the user what was found, what was fixed, what was deferred, which
UI paths were tested manually and how, and what the review did not
cover.
