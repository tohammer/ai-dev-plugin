# 0005 — Whole-project review as a separate audit skill

Date: 2026-10-05
Status: accepted

## Context

`review` examines a diff against its spec and is a fixed step of the
feature workflow; `implement` calls it at the end. Reviewing a whole
existing project shares little with that: the scope is areas and
aspects instead of a diff, the questions are different (architecture
drift, test and CI state, dependencies, docs), and findings are mostly
triaged rather than fixed. Alternatives: a project mode inside `review`,
selected by an argument or by an empty diff; or a separate skill.

## Decision

A separate skill, `audit`, reviews a whole project across all aspects.
It fixes nothing. It writes a dated report to
`docs/audits/YYYY-MM-DD.md` and, after the user confirms the selection,
adds findings to the backlog (proposed: severity medium and above). It
reuses the `reviewer` agent with an area and aspect in the brief instead
of a diff.

## Consequences

- `review` stays small and precise; an empty diff can never start an
  expensive audit.
- Each skill's description triggers on one kind of request.
- About six lines (finding verification, backlog entry format) are
  stated in both skills, since skills must be self-contained.
- The docs layout gains `docs/audits/`, which `core.md` and the README
  must list.
- The report is a snapshot and is not updated afterwards; the backlog
  carries the open work.
