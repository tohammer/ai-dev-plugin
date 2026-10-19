---
name: init
description: Set up the devflow documentation layout and record check commands in a project - scaffold missing files, or map and migrate existing docs after user approval. Use when a project lacks docs/specs, docs/decisions, docs/backlog.md, docs/next-steps.md or a `## Checks` section in CLAUDE.md or its imported AGENTS.md.
---

# Init

Target layout:

```
README.md
docs/user/            (created by devflow:userdocs when needed)
docs/architecture.md
docs/specs/  docs/decisions/
docs/backlog.md  docs/next-steps.md
```

## Steps

1. **Survey.** List `README.md`, `CLAUDE.md`, `AGENTS.md`, all of
   `docs/`. Classify each doc by what it is, not its name: decision,
   spec or design, open tasks, handover or status note, architecture.
2. **Route.** New project: step 5. Only `## Checks` missing: the
   `AGENTS.md` rules of step 6, then step 7.
3. **Existing project: propose.** Show a table of current → canonical
   path, e.g.:
   - `docs/decision-log.md` → one ADR per decision in `docs/decisions/`
   - `docs/design/*`, `docs/superpowers/specs/*` → `docs/specs/`
   - `docs/handoff.md`, `docs/implementation-status.md` →
     `docs/next-steps.md` (forward part), `docs/backlog.md` (open tasks)
   - `docs/tasks/*` → `docs/backlog/`

   Old plans and docs fitting no slot (runbooks, guides) stay. When two
   files compete for a canonical path, show both and ask, with pros,
   cons and a recommendation; never merge on your own.
4. **Wait for approval.** Move, split or rewrite nothing before the
   user approves the table. Then `git mv`, add `Status: implemented` to
   moved finished specs, and fix links to old paths.
5. **Scaffold.** Create each missing canonical file from the starting
   content below, filled with what you know; never overwrite one. If
   `README.md` is absent, load `devflow:userdocs` and write it.
6. **CLAUDE.md.** Add this block (create the file if absent, skip if
   present); remove rules it duplicates only with the user's approval:

   ```markdown
   ## Development workflow

   This project uses the devflow plugin. Docs live in `docs/`:
   architecture.md, specs/, decisions/, backlog.md, next-steps.md.
   Start a session by reading `docs/next-steps.md`.
   ```

   Claude reads `AGENTS.md` only without `CLAUDE.md`. `AGENTS.md` alone:
   create `CLAUDE.md` with `@AGENTS.md` first, then the block. Both
   files, no import: say Claude ignores `AGENTS.md`, propose the import;
   the user decides.
7. **Checks.** Write one `## Checks` section, never overwriting one
   (propose changes): in `AGENTS.md` if `CLAUDE.md` imports it, else in
   `CLAUDE.md`. Candidates: CI configuration (authoritative), then
   `justfile`, `Makefile`, manifest scripts, language defaults.
   `devflow:verifier` runs each once; the user confirms or corrects the
   list with results. Failing because the code is broken is still
   right; not existing is not. One that cannot run is listed as not
   run, with the reason, and recorded if confirmed. Format:

   ```markdown
   ## Checks

   Run from the repository root.

   - build: `cargo build`
   - test: `cargo test`
   - test one: `cargo test <name>`
   - lint: `cargo clippy -- -D warnings`
   - format: `cargo fmt --check`
   - typecheck: none
   ```

   Keep the kind order, `none` for absent kinds, `<name>` as placeholder
   in `test one`; extra kinds (`e2e`, `coverage`) may follow. Format is the checking variant. A line after
   the heading may name prerequisites (service, env file); nothing else.
8. **Report.** List what was created, moved, left alone. Do not commit
   unless asked.

## Starting content

- `docs/architecture.md`: title `# Architecture`, a line saying it
  describes the system as it is now, then sections Overview, Components
  (table: Component | Responsibility | Depends on), How it fits
  together, Lessons.
- `docs/backlog.md`: title `# Backlog`, then: "Open points only. Delete
  an item when it is done; git keeps the history. Deferred review
  findings name their origin, the reason and when to revisit." Items:
  `##` headings, short what and why.
- `docs/next-steps.md`: title `# Next steps`, then: "Forward-looking
  only. Remove an item when it is done; move its lessons to
  architecture.md or an ADR." Sections: Next (numbered, each pointing
  to a spec or backlog item), Watch out for.
- `docs/specs/`, `docs/decisions/`: empty, with a `.gitkeep`.
- `README.md`: what the project is, how to install and use it.
