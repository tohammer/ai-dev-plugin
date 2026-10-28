# 0015 — A PR's merge commit takes its message from the forge

Date: 2026-10-28
Status: accepted

## Context

ADR 0013 had `ship` write the merge commit message for a pull request
and pass it with `gh pr merge --subject --body-file`. In practice PRs
are merged on GitHub, by Zuul or by another forge mechanism, which
builds the merge commit from the PR title and description according to
the repository's settings. A message drafted by `ship` would apply only
when `ship` itself merges, and would differ from merges done any other
way. Supersedes the part of ADR 0013 on PR merge messages.

## Decision

`ship` drafts merge commit messages only for local merges. A PR's
merge commit takes its message from the PR through the forge;
`gh pr merge` gets no subject or body. `describe` still writes the PR
title and description, the squash commit message and the local merge
message.

## Consequences

- Merges by hand, by `ship` and by a gating system give the same
  history for the same PR.
- What lands in history for a PR depends on the repository's merge
  message setting; with "PR title and description" the whole PR body,
  including Verification and diagrams, becomes the commit body.
- `ship` step 8 is shorter and has no failure path for rejected flags.
