# 0012 — Commit message convention detected, not imposed

Date: 2026-10-21
Status: accepted

## Context

`ship` writes commit messages when it squashes or regroups a branch,
and a later `release` skill will build a changelog from what was
merged. Conventional Commits (`feat:`, `fix:`) would let `release`
derive changelog sections and version bumps mechanically, but would
impose a style on projects that do not use it, this one included.
Alternatives: impose Conventional Commits; detect the project's
convention; detect and record it in `CLAUDE.md`.

## Decision

`ship` follows the convention stated in `CLAUDE.md` if there is one,
otherwise the style of the recent commits on the default branch. It
uses Conventional Commits only where the project already does. Nothing
is recorded.

## Consequences

- History stays consistent in every project; no `init` change.
- `release` cannot rely on commit prefixes. It builds the changelog
  from the merges, pull requests or specs since the last tag, and uses
  prefixes only where the project has them.
- If detection proves unreliable, recording the convention in
  `## Shipping` (ADR 0011) is the next step; that would supersede this
  ADR.
