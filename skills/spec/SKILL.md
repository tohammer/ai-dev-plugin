---
name: spec
description: Turn an idea for a non-trivial feature into a written spec with a task list, for the user to review. Use before implementing anything that adds a component, changes an interface, or needs design decisions.
---

# Spec

Produce `docs/specs/YYYY-MM-DD-<topic>.md` and get it reviewed. No code
for the feature is written in this skill.

## Steps

1. **Explore.** Read the docs that frame the work: `docs/architecture.md`,
   related specs, ADRs in `docs/decisions/`, `docs/next-steps.md`. For a
   broad code search dispatch `devflow:explorer`.
2. **Understand.** Write back in a few lines what you take the goal,
   constraints and success criteria to be. Where information is missing,
   ask instead of assuming: one topic at a time, each question with
   options and a recommendation. Do not ask what the code or docs
   already answer.
3. **Choose.** Where a real choice exists, offer two or three approaches
   with trade-offs and a recommendation. Leave out anything the goal does
   not need.
4. **Write.** Fill the spec template below with `Status: draft`. If one
   spec would cover several independent subsystems, split it and write
   the first.
5. **Check.** Reread it once: no placeholders, no contradictions, no
   requirement that can be read two ways.
6. **Hand over.** Ask the user to review the file. If any point in it
   was not explicitly decided by the user, name it. Stop here.
7. **Approve.** Set `Status: approved` only when the user says so. Apply
   requested changes and ask again. Once approved, continue directly with
   `/devflow:implement`; do not ask whether to start.

## The task list

The spec ends with ordered tasks, each a checkbox with acceptance
criteria. A task is sized for one subagent: it names what to build and
how to tell it is done, not the code. Order them so each leaves the
project working. Mark tasks that can run in parallel.

## Decisions

Record each non-obvious decision made on the way as an ADR in
`docs/decisions/` with the next free number. The spec links to it
instead of repeating the reasoning. ADR format: `# NNNN — <decision>`, then `Date:` and `Status: accepted`,
then the sections Context, Decision, Consequences.

## Spec template

````markdown
# <Feature title>

Status: draft
Date: YYYY-MM-DD

## Purpose

What this is for, who uses it, and what success looks like.

## Scope

What is in, and what is deliberately out.

## Design

Components, their responsibilities and how they connect. Interfaces and
data formats that other code will depend on.

## Error handling

What can go wrong and what happens then.

## Testing

How the feature is verified: automated tests, manual checks.

## Tasks

Ordered. Each task is small enough for one subagent and names how to tell
it is done.

- [ ] 1. <Task>. *Done when* <acceptance criteria>.
````
