# 0009 — Check commands recorded in CLAUDE.md

Date: 2026-10-19
Status: accepted

## Context

`verifier`, `implementer`, `implement`, `review`, `debug`, `wrapup` and
`audit` each need the project's build, test, lint, format and typecheck
commands. Each guessed them from `justfile`, `Makefile` or the package
manifest, so two agents could run different commands, and a guess could
miss a step CI runs. Alternatives: a `## Checks` section in the
project's `CLAUDE.md`; a separate `docs/checks.md`; a section in
`docs/architecture.md`.

## Decision

`init` records the commands in a `## Checks` section of the project's
`CLAUDE.md`, one bullet per kind (`- test: \`cargo test\``). Every skill
and agent that runs checks uses this section. Without one, it determines
the commands as before, says which it chose, and the orchestrator offers
to record them.

## Consequences

- Claude Code loads `CLAUDE.md` into every session and every custom
  subagent without `omitClaudeMd`, which covers all devflow agents. No
  skill or agent has to be told to read a file, and `core.md` needs no
  new line. The built-in Explore and Plan agents start without it; a
  brief to them must name the commands.
- Every session pays for a few more lines of context.
- The commands are project rules the user can edit by hand; a stale
  section is fixed there, not in the plugin.
- Projects set up before this change get the section by running `init`
  again.
- Claude Code reads `AGENTS.md` only when there is no `CLAUDE.md`. In a
  project that uses `AGENTS.md`, `init` creates a `CLAUDE.md` that
  imports it (`@AGENTS.md`) and writes `## Checks` into `AGENTS.md`, so
  other coding agents get the commands too. Readers accept the section
  in either file; there is only ever one.
