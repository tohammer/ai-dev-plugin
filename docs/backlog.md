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
and `fast-forward` with a moved default branch; shipping the ship
branch covered `keep` + `merge commit` + pull request, with the PR
merged on GitHub. Untested: `regroup`, merging through `gh pr merge`,
no `gh`, no remote, a colleague's push to the branch (lease with the
noted SHA), and a rejected plan. Origin: task 4 and review of the ship
spec. Revisit after the first real ships.

## Diff view for spec revision rounds

`spec` step 7 revises with targeted edits and reports per note, but for
a long spec with many changes the user needs to see the actual diff on
their own, outside the reply: a diff in the reply works for small
rounds only, not for a 600-line spec with many changes. Origin: user
request 2026-10-26; viewer decision deferred. Revisit when choosing a
viewer.

Baseline: on "recheck", stage the spec as it is (`git add <spec>`,
notes included) before revising, so unstaged changes are exactly the
agent's; stage again next round. No commits, no scratch files, every
git tool understands it. Caveat: a commit in between takes the staged
spec along. Without git: scratch copy plus `git diff --no-index`.

Viewers (findings 2026-10-26):
- `git diff --word-diff`: a rewrapped paragraph gets no markers but is
  still listed as a hunk.
- pandoc normalization removes reflow completely (tested), ad hoc via
  process substitution with `--no-index`, or once per machine as a
  `textconv` driver that every `git diff` based viewer then uses
  (terminal, `less`, `git difftool`; magit untested):
  `.gitattributes`: `docs/specs/*.md diff=prose`;
  `git config diff.prose.textconv "pandoc -f gfm -t gfm --wrap=none"`.
  The diff shows pandoc's rendering (uniform list markers, one line per
  paragraph), not the text byte for byte.
- pandiff diffs the pandoc AST and writes a standalone HTML page or
  CriticMarkup; needs node; untested.
- delta, difftastic, diff-so-fancy, meld: line-based, reflow shows.
- Semantic line breaks (one sentence per line) in specs would keep
  plain line diffs and GitHub clean.

Reply variants mocked up
(https://claude.ai/artifact/5G8XiZR313WUg1WHuV1tjg): word diff in the
reply plus a colour command; change list plus command only; change
list only.

Other options from the same research, not chosen: a reply line under
each note, deleted by the user once satisfied; a `## Revisions` log in
the spec (Spec Kit `/clarify`); requirements, design and tasks approved
as separate phases, approved ones frozen (Kiro); the spec reviewed as a
draft PR, one commit and reply per comment thread (needs GitHub).

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

## Update an open PR's description when the branch changes

`ship` writes the PR body once, at creation; later commits leave it
stale. Google's guide asks to check that the description still matches
before submitting. Origin: spec 2026-10-28 PR and merge messages, Scope,
Out. Revisit when a PR gets commits after it was opened.

## Claude-only assumptions in plugin text

devflow also runs on GitHub Copilot. Model names were the first break
(ADR 0016). Check the rest for Claude Code specifics: the SessionStart
hook that prints `core.md`, the Artifact tool in `spec` Mockups,
`claude plugin validate` and `claude -p` smoke tests, the scratchpad,
`AGENTS.md` versus `CLAUDE.md`. Origin: user report 2026-10-28. Revisit
before the next skill change that touches these.

## Migration and rollback section in the spec template

Changes to data formats, schemas or config count as non-trivial, but
the spec template does not ask how existing data is handled. Add an
optional section: compatibility with existing data, migration path,
rollback. Origin: workflow gap analysis 2026-10-18.
