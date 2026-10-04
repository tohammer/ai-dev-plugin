---
name: review
description: Review a change against its spec and for defects using reviewer subagents, verify the findings, then fix or defer them. Use after implementing a feature, before merging, or when asked to review a diff or branch.
---

# Review

## Steps

1. **Scope.** Determine the diff: the argument if given, otherwise the
   branch against its base, or the uncommitted changes. Find the spec it
   implements, if any.
2. **Dispatch.** Send `devflow:reviewer` the diff range, the spec path
   and the project's check commands.
   - Small, ordinary change: one reviewer, default model.
   - Large or critical change: several reviewers in parallel, one focus
     each (spec conformance, correctness, security), on `model: "opus"`
     where the code is security- or correctness-critical.
3. **Verify.** Check every finding against the code before acting on
   it. Drop those that do not hold, and say so. A reviewer's finding is
   a lead, not a fact.
4. **Decide.** Present the confirmed findings ordered by severity.
   Fix the clear defects. Where fixing is a judgment call (cost, scope,
   taste), the user decides between fixing and deferring.
5. **Fix.** Small fixes yourself; larger ones through
   `devflow:implementer` with a brief. Re-run the checks with
   `devflow:verifier`.
6. **Defer.** Every confirmed finding that is not fixed goes into
   `docs/backlog.md` with its origin (which review, which spec), the
   reason it was deferred and when to revisit it.

## Reporting

Tell the user what was found, what was fixed, what was deferred, and
what the review did not cover.
