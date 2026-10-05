# Backlog

Open points only. Delete an item when it is done; git keeps the history.
Deferred review findings name their origin, the reason and when to
revisit.

## Install through the marketplace is unverified

`claude plugin marketplace add` + `claude plugin install
devflow@devflow-local` has not been run; only `claude plugin validate`
and `--plugin-dir` loading were. Origin: task 1 of the devflow spec.

## Try `init` on the existing projects

The adopt path (mapping existing docs, proposing moves) has only been
exercised on an empty repo. Run it on a few existing projects
and adjust the mapping examples in `skills/init`.

## Orchestrator skips the cheap agents on small changes

In the smoke test the orchestrator ran the checks and the doc check
itself instead of dispatching `verifier` and `doc-checker`. Acceptable
for a tiny change; watch whether it also happens on real features, and
if so make the skills firmer.

## `wrapup` left next-steps without a real next item

After the smoke feature, "Next" still read "No items yet". Consider
having `wrapup` ask the user what comes next when it cannot tell.

## `audit` dispatch path is untested

In the smoke test (a 30-line seeded project) the orchestrator reviewed
everything itself and dispatched no reviewers, verifier or explorer; the
report was complete and found every seeded problem. Run `/devflow:audit`
on a real project to see whether the per-area and
per-aspect dispatch and the ~15-dispatch limit work. Origin: task 4 of
the audit spec.

## `review` description does not exclude whole-project requests

`audit` says it is not for diffs; `review` has no matching "not for a
whole project". Competition looks unlikely since `review`'s triggers are
all about changes. Origin: review of the audit spec. Revisit if a
whole-project request ever loads `review`.
