# 0004 — Backlog as one file, split by area when large

Date: 2026-10-03
Status: accepted

## Context

A single `docs/backlog.md` does not scale for large projects: it grows
long and parallel branches conflict on it. One file per item avoids
conflicts but adds ticket-tracker overhead that a solo local workflow
does not need.

## Decision

The backlog holds open work only; finished items are deleted and git
keeps the history. It starts as `docs/backlog.md` and is split into
`docs/backlog/<area>.md` when it passes about 150 lines or the areas are
clearly distinct. `docs/architecture.md` follows the same pattern at
about 300 lines. Skills accept either form.

## Consequences

- Small projects keep a single file.
- Skills and agents must look for both the file and the directory.
- The thresholds are guidance, applied at wrap-up, not enforced.
