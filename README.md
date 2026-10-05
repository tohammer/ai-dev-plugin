# devflow

A lightweight development-workflow plugin for Claude Code. It guides work
from idea to spec, implementation, review and wrap-up, runs the bulk of
the work in subagents on cheaper models, and keeps one documentation
layout across projects.

## Install

From a local checkout:

```
claude plugin marketplace add /path/to/ai-dev-plugin
claude plugin install devflow@devflow-local
```

To try it for one session without installing:

```
claude --plugin-dir /path/to/ai-dev-plugin
```

devflow replaces superpowers; disable that plugin to avoid two competing
workflows (`claude plugin disable superpowers`).

## How it works

Every session starts with a short set of general instructions
(`core.md`, injected by a SessionStart hook): the workflow, the docs
layout, how to use subagents and models, and the verification rule. The
phases themselves are skills that load on demand.

Trivial changes are done directly. A non-trivial feature goes through:

| Step | Command | What happens |
|---|---|---|
| 1 | `/devflow:spec` | Claude explores, asks questions and writes `docs/specs/YYYY-MM-DD-<topic>.md` with a task list. You review it; only your approval sets `Status: approved`, and implementation then starts without further prompting. |
| 2 | `/devflow:implement` | Each task is briefed to an implementer subagent, checked and ticked off. Refuses a spec that is not approved. |
| 3 | `/devflow:review` | Reviewer subagents examine the change. Findings are verified, then fixed or deferred to the backlog. |
| 4 | `/devflow:wrapup` | README, architecture, ADRs, backlog and next-steps are brought in line with the change. |

Also available at any time:

- `/devflow:init` sets up the docs layout. In an existing project it
  proposes how to map the current docs and moves nothing without your
  approval.
- `/devflow:debug` finds and fixes the cause of a bug.
- `/devflow:audit` reviews a whole existing project across code, security,
  tests, build and CI, dependencies, documentation, configuration and
  operations, and repository hygiene. It fixes nothing: it writes a report
  to `docs/audits/YYYY-MM-DD.md` and adds the findings you confirm to the
  backlog (proposed: severity medium and above).

Two rules apply throughout: when information needed for a decision is
missing, Claude asks with options and a recommendation instead of
assuming; and feature work happens on a feature branch (no worktrees),
while documentation-only changes may go directly on the default branch.

Each command can be used on its own; you can review or wrap up work that
did not start from a spec.

## Docs layout

```
README.md                          user-side instructions
docs/architecture.md               the system as it is now
docs/specs/YYYY-MM-DD-<topic>.md   Status: draft | approved | implemented
docs/decisions/NNNN-<title>.md     ADRs: Context / Decision / Consequences
docs/audits/YYYY-MM-DD.md          audit reports, snapshots
docs/backlog.md                    open points only
docs/next-steps.md                 what to do next, nothing else
```

`architecture.md` and `backlog.md` become directories
(`docs/backlog/<area>.md`) when they grow large.

## Agents and models

| Agent | Default model | Job |
|---|---|---|
| `devflow:explorer` | haiku | locate code, distil docs and logs |
| `devflow:verifier` | haiku | run build, test and lint; report failures |
| `devflow:doc-checker` | haiku | find stale or missing docs for a change |
| `devflow:implementer` | sonnet | implement one briefed task with tests |
| `devflow:reviewer` | sonnet | review a diff or, for an audit, an area and aspect; report findings with evidence |

The defaults are a starting point. The orchestrator picks the cheapest
model that can do each task well and uses opus for complex ones.

Project-specific rules belong in the project's `CLAUDE.md` and take
precedence over the plugin's general instructions.

## Developing the plugin

```
tests/run.sh               structure checks
claude plugin validate .   manifest check
```

Design and reasoning: `docs/architecture.md`, `docs/decisions/`.
