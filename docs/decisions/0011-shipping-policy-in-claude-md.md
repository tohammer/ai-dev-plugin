# 0011 — Shipping policy recorded in CLAUDE.md by ship

Date: 2026-10-21
Status: accepted

## Context

`/devflow:ship` needs three project-wide choices before it can integrate
a branch: how to tidy the branch's commits (squash, keep, regroup), how
to bring them onto the default branch (fast-forward, rebase, merge
commit) and where (pull request or local merge). Asking all three on
every ship repeats the same questions; guessing them from the history
is unreliable. Alternatives: ask every time; let `init` ask alongside
`## Checks`; let `ship` ask once and record the answers.

## Decision

`ship` asks on its first run in a project without the section and
writes a `## Shipping` section into `CLAUDE.md`, placed by the same
rules as `## Checks` (into `AGENTS.md` when `CLAUDE.md` imports it).
Three bullets: `history`, `merge`, `target`. `init` is not changed.
`target` is a default; the user can override it per run, and keeping
the branch is always offered.

## Consequences

- No repeated questions; the policy is visible and editable by hand.
- Setup is split: `init` records checks, `ship` records the shipping
  policy when it first matters. `init` stays within its 100-line cap.
- Like `## Checks`, the section is in every session's context, so
  `ship` reads it without a file read.
- A later `release` skill can add its own settings to the same section.
