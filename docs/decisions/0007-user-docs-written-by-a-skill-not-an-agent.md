# 0007 — User docs written by a skill, not an agent

Date: 2026-10-17
Status: accepted

## Context

`init`, `wrapup`, `doc-checker` and `audit` all touch the README, but
only for completeness: is every command and flag there. None says how
user docs should be written or structured, and `wrapup` only appends,
so READMEs grow and are never reworked. The rules for good technical
docs (Diátaxis, the Google developer style guide, Standard Readme) need
a home. Alternatives: a skill loaded on demand; a `doc-writer` agent on
sonnet; a few lines added to `wrapup` and `init`.

## Decision

A skill, `devflow:userdocs`, holds the writing rules, the README
structure and the reference entry format. The user runs it for a write
or rework; `init` loads it to write a new README, and `wrapup` loads it
when a change adds a section or restructures user docs, not for
one-line updates. Collecting facts from code may be dispatched to
`devflow:explorer`; no new agent.

## Consequences

- Writing happens in the main conversation, which knows what a feature
  is for and can ask the user about audience and scope.
- No always-on cost; the rules load only when user docs are written.
- The name avoids competing with the generic `docs` skills a session
  may also have.
- The skill must be self-contained, so the rules are a condensed form
  of the sources, not a style guide. It may use up to 150 lines instead
  of the 100 other skills get: it is mostly reference material and
  loads only when user docs are written.
