---
name: spec
description: Turn an idea for a non-trivial feature into a written spec with a task list, for the user to review. Use before implementing anything that adds a component, changes an interface, or needs design decisions.
---

# Spec

Produce `docs/specs/YYYY-MM-DD-<topic>.md` and get it reviewed. No code
for the feature is written in this skill. Every question or choice put
to the user gets a brief explanation, each option's pros and cons where
they apply, and a recommendation with the reason it is better.

## Steps

1. **Explore.** Read the docs that frame the work: `docs/architecture.md`,
   related specs, ADRs in `docs/decisions/`, `docs/next-steps.md`. For a
   broad code search dispatch `devflow:explorer`.
2. **Understand.** Write back in a few lines what you take the goal,
   constraints and success criteria to be. Ask for what is missing, one
   topic at a time; never assume it, never ask what code or docs answer.
3. **Choose.** Where a real choice exists, offer two or three approaches.
   Leave out anything the goal does not need. For a larger UI topic,
   offer a mockup (see Mockups).
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

## Mockups

Offer a mockup once, as its own question, when the topic is a new
screen or flow or a significant layout change and a question would be
clearer shown than described. A UI topic alone is not reason enough;
small questions can be answered with an ASCII sketch in the terminal.

On a yes, write one self-contained static HTML file: two or three
variants side by side, placeholder data, no backend, no external
requests. Publish it as a private page if the session has an Artifact
tool; otherwise give the user the file path to open in a browser. The
user answers in the terminal; iterate until a direction is chosen. Keep
the chosen version as `docs/specs/YYYY-MM-DD-<topic>-mockup.html` and
link it from the spec's Design section.

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
data formats that other code will depend on. The mockup, if there is one.

## Error handling

What can go wrong and what happens then.

## Testing

How the feature is verified: automated tests, manual checks (including
UI paths the automated tests do not cover).

## Tasks

Ordered. Each task is small enough for one subagent and names how to tell
it is done.

- [ ] 1. <Task>. *Done when* <acceptance criteria>.
````
