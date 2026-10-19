# Backlog

Open points only. Delete an item when it is done; git keeps the history.
Deferred review findings name their origin, the reason and when to
revisit.

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

## `userdocs` move paths are untested

The smoke test covered a small CLI only: no README past the soft limit
of 500 lines, no feature area moved to `docs/user/<topic>.md`, no
binary-only user guide, and no visuals made with VHS or asciinema.
Origin: task 5 of the userdocs spec. Revisit on the first long README.

## Record the project's check commands in one place

`verifier`, `implementer`, `review` and `wrapup` guess build, test,
lint, format and typecheck commands from `justfile`, `Makefile` or the
manifest. `init` should record them in a fixed place (e.g. a `## Checks`
section in `CLAUDE.md`) that every skill and agent reads. Prerequisite
for the testing and `ship` items. Origin: workflow gap analysis
2026-10-18. Suggested to spec together with the testing item.

## Testing standard and a `test` skill

Testing is one line in `implementer` ("test-first where testable") and
a free-text section in the spec. Add: short testing rules for
`implementer` (behaviour not implementation, observe the failing test
and report it, no mock-only assertions, no snapshots instead of
assertions, never skip or weaken a test to get green, flaky is a
defect); acceptance criteria per spec task that name the proving tests;
a `/devflow:test` skill to add or repair tests for existing code (test
level choice, characterization tests for legacy code, flaky-test
repair). Origin: workflow gap analysis 2026-10-18.

## `ship` skill for finishing a branch

No skill covers integration: final checks, commit tidying and message
convention, PR description from spec and review report, the choice
between merge, PR and keeping the branch, branch cleanup. `wrapup`
would hand over to it. Overlaps with `release` on commits and
changelog; consider speccing both together. Origin: workflow gap
analysis 2026-10-18.

## `refactor` skill for behaviour-preserving changes

Refactors fit neither "trivial" nor the full spec flow. Steps: check
coverage of the touched code and add characterization tests first,
small steps with checks green after each, no behaviour change mixed in,
ADR on structural change. Origin: workflow gap analysis 2026-10-18.

## Dependency additions and upgrades

`audit` finds outdated dependencies but nothing fixes them. Adding a
dependency: checklist (maintenance, licence, size, alternatives), ADR
when not obvious. Upgrading: read changelogs for breaking changes, one
package at a time, checks after each, lockfile in the same commit.
Origin: workflow gap analysis 2026-10-18.

## `release` skill

Version bump per the project's scheme, `CHANGELOG.md` from merged
changes, tag, release notes, post-publish check. Only for projects that
publish releases. Origin: workflow gap analysis 2026-10-18. Revisit
when a devflow project needs a release, or together with `ship`.

## Migration and rollback section in the spec template

Changes to data formats, schemas or config count as non-trivial, but
the spec template does not ask how existing data is handled. Add an
optional section: compatibility with existing data, migration path,
rollback. Origin: workflow gap analysis 2026-10-18.
