# 0002 — Core instructions injected by a SessionStart hook

Date: 2026-10-03
Status: accepted

## Context

The general rules (workflow, docs layout, model tiering) must apply to
ad-hoc work too, not only when a command is run. Alternatives: slash
commands only, which leave ad-hoc work uncovered; or writing the rules
into each project's `CLAUDE.md`, where copies drift when the plugin
changes.

## Decision

A SessionStart hook prints a short `core.md` into every session. The
phases are skills loaded on demand. `init` adds only a pointer block to
`CLAUDE.md`.

## Consequences

- Every session pays the context cost of `core.md`; a test caps its
  length.
- A rule change in the plugin reaches all projects at once.
- Project-specific rules stay in `CLAUDE.md` and override the core.
