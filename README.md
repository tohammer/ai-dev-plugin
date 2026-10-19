# devflow

A development-workflow plugin for Claude Code: it takes a feature from
spec to implementation, review and wrap-up, runs most of the work in
subagents on cheaper models, and keeps one documentation layout across
projects.

## Status

Version 0.1.0, used on its own development.

| Install method | Status |
|---|---|
| `--plugin-dir` for one session | tested |
| Local marketplace | tested |

## Quick start

Start Claude Code with the plugin, in the project you want to work on:

```
claude --plugin-dir <path-to-ai-dev-plugin>
```

Then, in the session:

```
/devflow:init
/devflow:spec <what you want to build>
```

`init` sets up the docs layout and records the check commands; `spec`
writes a spec for you to review.

## Installation

### Local marketplace

```
claude plugin marketplace add <path-to-ai-dev-plugin>
claude plugin install devflow@devflow-local
```

### Alongside superpowers

devflow replaces superpowers. With both enabled, both inject a workflow
at session start and superpowers' wording wins. Disable it:

```
claude plugin disable superpowers
```

## Usage

Trivial changes are done directly. A non-trivial feature (a new
component, a changed interface, or anything not describable in two
sentences) goes through four commands:

| Step | Command | What happens |
|---|---|---|
| 1 | `/devflow:spec` | Claude explores, asks questions and writes `docs/specs/YYYY-MM-DD-<topic>.md` with a task list. For a larger UI topic it offers a static HTML mockup first. Only your approval sets `Status: approved`; implementation then starts without further prompting. |
| 2 | `/devflow:implement` | Each task is briefed to an implementer subagent, checked and ticked off. Refuses a spec that is not approved. |
| 3 | `/devflow:review` | Reviewer subagents examine the change; findings are verified, then fixed or deferred to the backlog. UI changes without automated tests are tested by hand, by Claude where it can, otherwise by you with the steps it gives. |
| 4 | `/devflow:wrapup` | README, user docs, architecture, ADRs, backlog and next-steps are brought in line with the change. |

Commands for any time, also on work that did not start from a spec:

| Command | What happens |
|---|---|
| `/devflow:init` | Sets up the docs layout and records the project's check commands. In an existing project it proposes how to map the current docs and moves nothing without your approval. |
| `/devflow:debug` | Finds the cause of a bug with evidence, fixes it and adds a regression test. |
| `/devflow:test` | Adds or repairs tests for existing code: picks the test level, pins current behaviour before a change, fixes flaky tests at the cause. |
| `/devflow:audit` | Reviews a whole project: code, security, tests, build and CI, dependencies, docs, configuration, repository hygiene. Writes `docs/audits/YYYY-MM-DD.md`, fixes nothing, and adds the findings you confirm to the backlog. |
| `/devflow:userdocs` | Writes or reworks the README and user docs in `docs/user/` to a fixed structure, and checks their commands and options against the code. |

Throughout, Claude:

- asks when information for a decision is missing, and gives each
  question a brief explanation, the pros and cons of each option and a
  recommendation with its reason;
- does feature work on a feature branch (no worktrees); documentation-only
  changes may go on the default branch.

### Docs layout

```
README.md                          user-side instructions
docs/user/<topic>.md               user docs beyond the README
docs/architecture.md               the system as it is now
docs/specs/YYYY-MM-DD-<topic>.md   Status: draft | approved | implemented
                                   (plus -mockup.html for UI topics)
docs/decisions/NNNN-<title>.md     ADRs: Context / Decision / Consequences
docs/audits/YYYY-MM-DD.md          audit reports, snapshots
docs/backlog.md                    open points only
docs/next-steps.md                 what to do next, nothing else
```

Images for user docs go in `docs/user/images/`. `architecture.md` and
`backlog.md` become directories (`docs/backlog/<area>.md`) when they
grow large.

## Configuration

Rules in the project's `CLAUDE.md` take precedence over the plugin's.

### Check commands

`/devflow:init` records the commands every skill and agent runs, in a
`## Checks` section of `CLAUDE.md`. Edit it by hand when they change:

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

Kinds stay in this order; `none` marks a kind the project lacks; more
kinds (`e2e`, `coverage`) may follow. In a project with an `AGENTS.md`,
`init` makes `CLAUDE.md` import it (`@AGENTS.md`) and writes the
section into `AGENTS.md`, so other coding agents get the commands too.
Without the section, skills determine the commands from the project's
files, say which they used and offer to record them with `/devflow:init`.

### Agents and models

Each agent has a default model; the orchestrator overrides it per task,
with opus for complex work:

| Agent | Default model | Job |
|---|---|---|
| `devflow:explorer` | haiku | Locate code, distil docs and logs. |
| `devflow:verifier` | haiku | Run build, test and lint; report failures. |
| `devflow:doc-checker` | haiku | Find stale or missing docs for a change. |
| `devflow:implementer` | sonnet | Implement one briefed task with tests. |
| `devflow:reviewer` | sonnet | Review a diff, or an area and aspect for an audit; report findings with evidence. |

## Development

```
tests/run.sh
claude plugin validate .
```

`tests/run.sh` checks structure (hook output, frontmatter, size limits,
references, the testing rules' key phrase in all three copies);
`validate` checks the manifests. Every session starts with
`core.md`, printed by a SessionStart hook; the commands are skills that
load on demand. Design: `docs/architecture.md`, `docs/decisions/`.

## License

MIT, see `LICENSE`.
