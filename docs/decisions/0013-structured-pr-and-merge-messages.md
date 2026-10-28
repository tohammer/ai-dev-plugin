# 0013 — PR and merge messages have a defined structure

Date: 2026-10-28
Status: accepted; merge messages for pull requests superseded by
[0015](0015-pr-merge-message-from-the-forge.md)

## Context

`ship` wrote PR descriptions with overlapping sections and left merge
commit messages to git and GitHub defaults, which carry no reason for
the change. Sources (Google's CL description guide, the git and Linux
kernel patch guidelines, an empirical study of 80,000 PRs) agree that a
description is a permanent record of what changed and why, and that
reviewer-only material such as test logs and review notes does not
belong in history. ADR 0012 keeps the commit subject convention
detected, not imposed. Alternatives: keep the loose Messages rules in
`ship`; impose one format everywhere; define a structure the project
can override.

## Decision

A new skill, `describe`, writes the PR title and body and the message
of the commit that lands, in a defined structure: PR sections Summary,
Why, Approach, Impact, Verification, Review focus and Links, each with
one reader. A squash commit keeps Why, Approach and Impact, a merge
commit Summary and Why; both drop Verification, Review focus and
diagrams. `ship` loads it and passes merge messages explicitly instead
of relying on defaults. A format stated in `CLAUDE.md` or a repository
PR template takes precedence; the subject still follows ADR 0012.

## Consequences

- PR text and history read the same way in every project that has no
  format of its own.
- `ship` stays under its line cap; the format lives in one place and
  can be used without shipping.
- One more skill to keep in sync with `ship`.
- Repository settings for merge commit messages no longer apply to
  merges `ship` makes.
