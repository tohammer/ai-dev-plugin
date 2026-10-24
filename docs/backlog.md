# Backlog

Open points only. Delete an item when it is done; git keeps the history.
Deferred review findings name their origin, the reason and when to
revisit.

## Orchestrator skips the cheap agents on small changes

In the smoke test the orchestrator ran the checks and the doc check
itself instead of dispatching `verifier` and `doc-checker`. Acceptable
for a tiny change; watch whether it also happens on real features, and
if so make the skills firmer. Seen again in the `test` smoke test
(2026-10-19): the orchestrator wrote and ran the tests itself instead of
dispatching `implementer` and `verifier`.

## `wrapup` left next-steps without a real next item

After the smoke feature, "Next" still read "No items yet". Consider
having `wrapup` ask the user what comes next when it cannot tell.

## `review` description does not exclude whole-project requests

`audit` says it is not for diffs; `review` has no matching "not for a
whole project". Competition looks unlikely since `review`'s triggers are
all about changes. Origin: review of the audit spec. Revisit if a
whole-project request ever loads `review`.

## `ship` paths are untested

The smoke tests covered squash + rebase + local merge, a failing check
and `fast-forward` with a moved default branch. Untested: `regroup`,
`keep`, `merge commit`, no `gh`, no remote, the open-PR run, a
colleague's push to the branch (lease with the noted SHA), and a
rejected plan. Origin: task 4 and review of the ship spec. Revisit
after the first real ships.

## `refactor` skill for behaviour-preserving changes

Refactors fit neither "trivial" nor the full spec flow. Steps: check
coverage of the touched code and add characterization tests first,
small steps with checks green after each, no behaviour change mixed in,
ADR on structural change. Reuse the characterization step of
`/devflow:test`. Origin: workflow gap analysis 2026-10-18.

## Dependency additions and upgrades

`audit` finds outdated dependencies but nothing fixes them. Adding a
dependency: checklist (maintenance, licence, size, alternatives), ADR
when not obvious. Upgrading: read changelogs for breaking changes, one
package at a time, checks after each, lockfile in the same commit.
Origin: workflow gap analysis 2026-10-18.

## `release` skill

Version bump per the project's scheme, `CHANGELOG.md` from merged
changes, tag, release notes, post-publish check. Only for projects that
publish releases. Origin: workflow gap analysis 2026-10-18. Commit
messages follow the project's convention (ADR 0012), so `release`
builds the changelog from merges, PRs or specs since the last tag,
using prefixes only where the project has them. Settings can go in
`## Shipping` (ADR 0011). Revisit when a devflow project needs a
release.

## Migration and rollback section in the spec template

Changes to data formats, schemas or config count as non-trivial, but
the spec template does not ask how existing data is handled. Add an
optional section: compatibility with existing data, migration path,
rollback. Origin: workflow gap analysis 2026-10-18.
