# 0008 — User docs beyond the README in docs/user/

Date: 2026-10-17
Status: accepted

## Context

The devflow layout under `docs/` is developer-side: architecture,
specs, ADRs, backlog. A project with a large configuration reference or
several usage guides outgrows a README, and without a fixed place that
content ends up wherever the session puts it. Alternatives: keep all
user docs in the README; let the skill choose a place per project; a
fixed `docs/user/` directory.

## Decision

User docs that do not fit the README go to `docs/user/<topic>.md`, for
example `docs/user/configuration.md`, and the README links to each.
A project with an existing user-doc site (mkdocs, Sphinx, a `docs/guide/`
tree) keeps it; the project's convention wins over this path.

## Consequences

- One known place for `doc-checker` and `audit` to check.
- `docs/user/` is added to the layout in `core.md`, `init` and the
  README.
- User and developer docs stay apart; explanation of design stays in
  `architecture.md` and the ADRs, not in user docs.
