# 0006 — UI mockups as static HTML kept with the spec

Date: 2026-10-05
Status: accepted

## Context

For larger UI topics a layout question is easier to answer from a
picture than from prose. Superpowers solves this with a visual companion:
a bundled Node server that pushes HTML screens to a browser tab and
records the user's clicks. devflow skills cannot reach files inside the
plugin, so a bundled server has no reliable path, and the original
devflow spec left a visual companion out of scope. Alternatives: such a
server; a static HTML mockup thrown away after the decision; a static
mockup kept with the spec.

## Decision

`spec` offers a mockup once, when a large UI topic raises a question
that is clearer shown than described. The mockup is one self-contained
static HTML file with two or three variants, published as a private
Artifact page where the session supports it and otherwise opened from
disk. The user answers in the terminal. The chosen version is kept as
`docs/specs/YYYY-MM-DD-<topic>-mockup.html`, linked from the spec, and
passed to implementers in their brief.

## Consequences

- No server, script or dependency in the plugin.
- No click-to-select feedback; choices are made in the terminal.
- Implementers and reviewers build against a concrete picture.
- Spec directories may hold `-mockup.html` files next to the specs.
