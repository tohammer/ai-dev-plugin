# devflow — a lightweight development-workflow plugin for Claude Code

Status: implemented
Date: 2026-10-03

## Purpose

A Claude Code plugin used for all local development. It guides work from
concept to spec, implementation and review, and it fixes one documentation
layout across projects.

It replaces superpowers. It is written for capable models: it states what
to do and why, and does not spend text guarding against rationalisation.
A strong model orchestrates; subagents on cheaper models do the work
wherever they can do it well.

Success means:

- A new session in any project knows the workflow, the docs layout and
  the model-tiering rule without per-project `CLAUDE.md` text.
- A non-trivial feature produces one reviewed spec, no separate plan file.
- Every project using the plugin has the same docs layout.
- The always-on context cost stays near 40 lines.

## Scope

In scope: Claude Code only. Skills, agents, one SessionStart hook,
document templates, and the plugin's own README and docs.

Out of scope: other harnesses (Codex, Gemini, Cursor), git-worktree
management, branch/PR finishing flows, a visual brainstorming companion,
and tooling for writing skills. Claude Code's built-in features cover
worktrees and code review commands; the plugin does not duplicate them.

## Plugin layout

```
.claude-plugin/plugin.json        manifest, name "devflow"
.claude-plugin/marketplace.json   single-plugin marketplace for local install
hooks/hooks.json                  SessionStart, matcher startup|clear|compact
hooks/session-start               prints core.md to stdout
core.md                           the always-on general instructions
skills/<name>/SKILL.md            init, spec, implement, review, debug, wrapup
agents/<name>.md                  explorer, verifier, doc-checker, implementer, reviewer
templates/                        spec.md, adr.md, architecture.md, backlog.md, next-steps.md
tests/                            hook and structure checks
README.md                         install and usage
docs/                             this plugin follows its own layout
```

The hook script prints `core.md` unchanged. SessionStart stdout becomes
session context, so no JSON encoding or runtime dependency is needed.

## Core instructions (`core.md`)

About 40 lines, in four parts:

1. **Workflow.** A trivial change is done directly. A non-trivial feature
   goes through `spec` → manual review → `implement` → `review` →
   `wrapup`. A change is non-trivial when it adds a component, changes an
   interface or data format other code depends on, or cannot be described
   completely in two sentences. When unsure, treat it as non-trivial.
2. **Docs layout.** The canonical paths (see below) and the rule that
   docs change in the same commit as the code they describe.
3. **Subagents and models.** Use a subagent when only the conclusion is
   needed or the work is separable; do not spawn one for a small lookup.
   Pick the cheapest model that can do the task well: haiku for
   mechanical work, sonnet for ordinary implementation and review, opus
   for complex tasks. Design, spec writing, task briefing and triage of
   findings stay with the orchestrator.
4. **Verification.** State that something works only after running the
   command that shows it, in this session.

Project-specific rules stay in the project's `CLAUDE.md` and take
precedence over the core.

## Documentation layout

```
README.md                          user-side instructions
docs/architecture.md               current structure of the system
docs/specs/YYYY-MM-DD-<topic>.md   one per non-trivial feature
docs/decisions/NNNN-<title>.md     ADRs
docs/backlog.md                    open points
docs/next-steps.md                 what to do next, nothing else
```

Rules:

- **README** matches reality on install, commands, flags and features.
  A change that alters any of these is not done until the README says so.
- **Architecture** describes the system as it is now: components, their
  responsibilities, how they connect, and durable lessons. It splits into
  `docs/architecture/<area>.md` with `docs/architecture.md` as the index
  when it passes about 300 lines.
- **Specs** carry `Status: draft | approved | implemented`. Only the user
  moves a spec from draft to approved. A spec ends with an ordered task
  list of checkboxes, each with acceptance criteria.
- **ADRs** are numbered with the next free four-digit number and use
  Context / Decision / Consequences. One is written for every non-obvious
  technical decision. Accepted ADRs are not relitigated; a changed
  decision gets a new ADR that supersedes the old one.
- **Backlog** holds open work only: ideas, deferred tasks, and review
  findings that were deliberately not fixed (with origin, reason and when
  to revisit). Finished items are deleted; git keeps the history. It
  splits into `docs/backlog/<area>.md` when it passes about 150 lines or
  the areas are clearly distinct. Skills accept either form.
- **Next steps** is forward-looking only: the next few things to do and
  what to watch out for while doing them. Completed work is removed, and
  its lessons move to architecture or an ADR.

## Skills

Each skill is invocable as `/devflow:<name>` and is loaded by the model
when its description matches. Target length is under 80 lines each.

### init

Sets up the docs layout in a project.

- New project: creates the missing canonical files from `templates/` and
  adds a short pointer block to `CLAUDE.md` (creating it if absent).
- Existing project: lists the docs already there, maps them to canonical
  paths (for example `decision-log.md` → `docs/decisions/`,
  `handoff.md` → `docs/next-steps.md`, `docs/superpowers/specs/` →
  `docs/specs/`), and presents the proposed moves. Nothing is moved,
  split or rewritten before the user approves. Moves use `git mv`.
  Old plan files are left where they are.
- Running it again is safe: existing canonical files are not overwritten.

### spec

Turns an idea into a reviewed spec.

1. Explore the project (via `explorer` when the search is broad).
2. Ask the questions that matter, one topic at a time; state assumptions.
3. Offer two or three approaches with a recommendation when a real
   choice exists.
4. Write `docs/specs/YYYY-MM-DD-<topic>.md` from the template with
   `Status: draft`: purpose, scope, design, error handling, testing, and
   the task list.
5. Stop and ask the user to review the file. Set `Status: implemented` only
   when the user says so.

Decisions made along the way are recorded as ADRs.

### implement

Executes an approved spec.

- Refuses to start when the spec's status is not `approved`.
- Takes tasks in order. For each one the orchestrator writes a brief
  (goal, files, acceptance criteria, relevant constraints) and hands it
  to an `implementer`, choosing the model by the task's difficulty.
  Independent tasks may run in parallel.
- Logic is written test-first where the code is testable.
- After each task the orchestrator reads the diff, has `verifier` run
  the project's checks, ticks the checkbox and commits if the user has
  asked for commits.
- A task that fails twice in a subagent is done by the orchestrator or
  re-run on a stronger model. A task that shows the spec is wrong stops
  the run, and the question goes to the user.

### review

Reviews a change against its spec and for defects.

- Dispatches `reviewer` on the diff, with the spec as reference. Large
  or critical changes get more than one reviewer with different focuses
  (spec conformance, correctness, security).
- The orchestrator verifies each finding before acting on it and drops
  those that do not hold.
- Confirmed findings are fixed, or entered in the backlog with origin
  and reason when the user decides to defer them.
- Usable standalone on any diff, with or without a spec.

### debug

Reproduce, isolate, fix. Get a reliable reproduction first; narrow the
cause with evidence, not guesses; fix the cause and add a regression
test. `explorer` and `verifier` handle log reading and test runs.
Usable standalone.

### wrapup

Brings the docs in line with the finished change.

- `doc-checker` compares the change with README, architecture, ADRs,
  backlog and next-steps and reports what is stale or missing.
- The orchestrator applies the updates, sets the spec to `implemented`,
  removes finished items from backlog and next-steps, and writes what
  comes next into next-steps.

## Agents

Each agent file sets a default model. The orchestrator overrides it per
task through the Agent tool's `model` parameter.

| Agent | Default | Tools | Job | Escalate when |
|---|---|---|---|---|
| explorer | haiku | read-only | Locate code and answer where/what questions; distil large docs and logs into a short brief | Tangled codebase question → sonnet |
| verifier | haiku | read-only + Bash | Run build, test and lint; return pass/fail and only the failing output | Rarely |
| doc-checker | haiku | read-only | Compare a change with the docs; list stale or missing items with paths | Rarely |
| implementer | sonnet | all | Implement one briefed task with tests; report what changed and what was verified | Concurrency, security, cross-module interfaces, subtle algorithms → opus |
| reviewer | sonnet | read-only + Bash | Review a diff; report findings with file, line, evidence and a failure scenario | Security- or correctness-critical, or large diff → opus |

Every agent returns a short report, not file dumps. Implementer and
reviewer state plainly what they did not verify.

## Error handling

- `implement` on a draft spec: stop and name the missing approval.
- `init` on a project with conflicting docs (two candidates for one
  canonical path): show both and ask, do not merge.
- Missing canonical files outside `init`: skills create the one they
  need from its template and say so.
- Hook failure (missing `core.md`): the script exits non-zero with a
  one-line message on stderr; the session continues without the core.

## Testing

- `claude plugin validate` passes on the manifest.
- `tests/run.sh` checks: the hook script prints `core.md` and exits 0;
  every skill has `name` and `description` frontmatter; every agent has
  `name`, `description` and `model`; `core.md` is at most 60 lines;
  every template referenced by a skill exists.
- Smoke test, run by hand with `claude --plugin-dir`: `init` in an empty
  scratch repo, then one small feature through spec, implement, review
  and wrapup. The result is recorded in the plugin's README checklist.

## Tasks

- [x] 1. Manifest and marketplace files. *Done when* `claude plugin
      validate` passes and the plugin installs from the local path.
- [x] 2. `core.md`, hook config and hook script, with `tests/run.sh`
      covering the hook. *Done when* a new session shows the core text
      and the test passes.
- [x] 3. Templates for spec, ADR, architecture, backlog and next-steps.
      *Done when* each matches the rules in "Documentation layout".
- [x] 4. Agents: explorer, verifier, doc-checker, implementer, reviewer.
      *Done when* the frontmatter test passes and each is dispatchable
      as `devflow:<name>`.
- [x] 5. Skills `spec`, `implement`, `review`. *Done when* each is under
      80 lines and the structure test passes.
- [x] 6. Skills `init`, `debug`, `wrapup`. *Done when* the same holds,
      and `init` scaffolds an empty repo correctly.
- [x] 7. Plugin README (install, the workflow, each command, the docs
      layout) plus this repo's own `docs/architecture.md`, `backlog.md`
      and `next-steps.md`. *Done when* the README matches the plugin.
- [x] 8. Smoke test in a scratch repo. *Done when* the full cycle runs
      and any defects found are fixed or entered in the backlog.
- [x] 9. ADRs for the decisions taken in this spec: spec with task list
      instead of a plan file; hook-injected core; per-task model
      override; backlog split rule. *Done when* the four ADRs exist.

## Deviations from this spec

Found during the smoke test and applied:

- **No `templates/` directory.** A session cannot read files in the
  plugin directory (neither with Read nor through load-time `cat`
  injection), so starting content is embedded in the skills: the spec
  template in `spec`, the scaffold content in `init`. See
  `docs/architecture.md`, Lessons.
- **Skill size limit is 100 lines, not 80,** to make room for the
  embedded spec template.
- **Read-only agents use `disallowedTools`** (Edit, Write, NotebookEdit)
  instead of a tool allow-list, so explorer and doc-checker also keep
  Bash for searching.
- **Task 1:** verified with `claude plugin validate` and by loading the
  plugin with `--plugin-dir`. Installing through the marketplace was not
  run, since it changes the user's Claude Code configuration.
