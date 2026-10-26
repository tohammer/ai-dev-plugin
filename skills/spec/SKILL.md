---
name: spec
description: Turn an idea for a non-trivial feature into a written spec with a task list, for the user to review. Use before implementing anything that adds a component, changes an interface, or needs design decisions.
---

# Spec

Produce `docs/specs/YYYY-MM-DD-<topic>.md` and get it reviewed; no feature
code here. Every question or choice put to the user gets a brief
explanation, pros and cons per option, and a reasoned recommendation.

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
7. **Revise.** For review notes or requested changes, find the user's
   notes in whatever form they wrote them. Change only the text each one
   concerns, with targeted edits; never rewrite the file or rewrap a
   paragraph you did not change. Remove each note once handled. Report
   per note what changed in which section, or why nothing did; ask again.
8. **Approve.** Set `Status: approved` only when the user says so. Once
   approved, continue directly with `/devflow:implement`; do not ask
   whether to start.

## The task list

The spec ends with ordered tasks, each a checkbox with acceptance
criteria. A task is sized for one subagent: it names what to build, how
to tell it is done and the tests or manual check that show it, not the
code. Order them so each leaves the project working; mark parallel ones.

## Mockups

Offer a mockup once, as its own question, for a new screen or flow or
a significant layout change that is clearer shown than described; a UI
topic alone is not enough, small questions get an ASCII sketch. On a
yes, write one self-contained static HTML file: two or three variants
side by side, placeholder data, no backend, no external requests.
Publish it as a private page if the session has an Artifact tool, else
give the file path. The user answers in the terminal; iterate until a
direction is chosen. Keep the chosen version as
`docs/specs/YYYY-MM-DD-<topic>-mockup.html`, linked from Design.

## Decisions

Record each non-obvious decision made on the way as an ADR in
`docs/decisions/` with the next free number; the spec links to it
instead of repeating the reasoning. Format: `# NNNN — <decision>`,
`Date:`, `Status: accepted`, then Context, Decision, Consequences.

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

Ordered, each sized for one subagent (see The task list).

- [ ] 1. <Task>. *Done when* <criteria>, *shown by* <tests or manual check>.
````
