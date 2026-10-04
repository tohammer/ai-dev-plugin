---
name: init
description: Set up the devflow documentation layout in a project - scaffold missing files in a new project, or map and migrate existing docs in an established one after user approval. Use when a project lacks docs/specs, docs/decisions, docs/backlog.md or docs/next-steps.md.
---

# Init

Target layout:

```
README.md
docs/architecture.md
docs/specs/
docs/decisions/
docs/backlog.md
docs/next-steps.md
```

## Steps

1. **Survey.** List what exists: `README.md`, `CLAUDE.md`, everything
   under `docs/`. Classify each existing doc by what it is, not by its
   name: a decision record, a spec or design, open tasks, a handover or
   status note, architecture, or something else.
2. **New project** (no docs to map): go to step 5.
3. **Existing project: propose.** Show a table of current path →
   canonical path, for example:
   - `docs/decision-log.md` → one ADR per decision in `docs/decisions/`
   - `docs/design/*`, `docs/superpowers/specs/*` → `docs/specs/`
   - `docs/handoff.md`, `docs/implementation-status.md` →
     `docs/next-steps.md` (forward-looking part) and
     `docs/backlog.md` (open tasks)
   - `docs/tasks/*` → `docs/backlog/`

   Old plan files and docs that fit no canonical slot (runbooks,
   analysis, guides) stay where they are. When two files compete for one
   canonical path, show both and ask; do not merge on your own.
4. **Wait for approval.** Move, split or rewrite nothing before the user
   approves the table. Then use `git mv` for moves, add `Status:
   implemented` to moved specs whose work is finished, and fix links
   that pointed at the old paths.
5. **Scaffold.** Create each missing canonical file with the starting
   content below, filled with what you know about the project. Never overwrite an
   existing file. Create `README.md` if absent.
6. **CLAUDE.md.** Add this block (create the file if absent, skip if the
   block is already there), and remove rules it now duplicates only with
   the user's approval:

   ```markdown
   ## Development workflow

   This project uses the devflow plugin. Docs live in `docs/`:
   architecture.md, specs/, decisions/, backlog.md, next-steps.md.
   Start a session by reading `docs/next-steps.md`.
   ```
7. **Report.** List what was created, moved and left alone. Do not
   commit unless asked.

## Starting content

- `docs/architecture.md`: title `# Architecture`, one line saying it
  describes the system as it is now, then the sections Overview,
  Components (table: Component | Responsibility | Depends on), How it
  fits together, Lessons.
- `docs/backlog.md`: title `# Backlog`, then: "Open points only. Delete
  an item when it is done; git keeps the history. Deferred review
  findings name their origin, the reason and when to revisit." Items are
  `##` headings with a short what and why.
- `docs/next-steps.md`: title `# Next steps`, then: "Forward-looking
  only. Remove an item when it is done; move its lessons to
  architecture.md or an ADR." Sections: Next (numbered, each pointing to
  a spec or backlog item), Watch out for.
- `docs/specs/` and `docs/decisions/`: empty directories with a
  `.gitkeep`.
- `README.md`: what the project is, how to install and how to use it.
