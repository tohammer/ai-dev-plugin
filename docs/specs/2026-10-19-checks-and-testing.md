# Check commands, testing rules and a test skill

Status: approved
Date: 2026-10-19

## Purpose

Two gaps in the workflow, closed together because the second builds on
the first:

- Each skill and agent guesses the project's check commands. They are
  now recorded once, in `CLAUDE.md`, and read from there
  ([ADR 0009](../decisions/0009-check-commands-in-claude-md.md)).
- Testing is one line in `implementer`. It gets short testing rules that
  `reviewer` enforces
  ([ADR 0010](../decisions/0010-testing-rules-in-implementer-and-reviewer.md)),
  spec tasks name the tests that prove them, and `/devflow:test` adds or
  repairs tests for existing code.

Success means:

- After `init`, the project's `CLAUDE.md` has a `## Checks` section whose
  commands were each run once in that session, or are listed to the user
  as not run, with the reason.
- `verifier`, `implementer`, `implement`, `review`, `debug`, `wrapup` and
  `audit` use that section; without it they say that they guessed.
- An implementer report names the new tests it saw fail before the code
  made them pass.
- A reviewer reports a test that breaks a testing rule as a finding.
- `/devflow:test` on untested code produces behaviour tests at a stated
  level; on a flaky test it reproduces the flakiness and fixes the cause
  without retries, longer sleeps or skipping.

## Scope

In:

- `## Checks` format, written by `init` for new and existing projects,
  including projects that already have the devflow block, and placed
  correctly in projects that use `AGENTS.md`.
- Reading the section in the agents and skills above.
- Testing rules in `implementer`, a matching check in `reviewer`.
- Spec template: each task names its proving tests or manual check;
  `implement` checks that they exist and were seen failing.
- New skill `skills/test/SKILL.md`.
- `core.md`, README and `architecture.md` mention the skill and the
  section; `tests/run.sh` covers the new skill and the rule sync.

Out:

- Coverage targets or gates. The skill measures coverage only where the
  project already has a coverage tool.
- Installing test frameworks or coverage tools. Adding one is a
  dependency decision; the skill proposes it to the user.
- Mutation testing.
- The `ship`, `refactor` and dependency skills (separate backlog items).
  `refactor` will reuse the characterization-test step of `test`.
- Debugging a failing test whose cause is unknown; that stays
  `/devflow:debug`.

## Design

### `## Checks` in CLAUDE.md

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

- Fixed kinds, in this order: build, test, test one, lint, format,
  typecheck. A kind the project lacks reads `none`. `test one` runs a
  single test; `<name>` is the placeholder for the test name or path.
- Further kinds may follow (e.g. `e2e`, `coverage`), same bullet form.
- A line after the heading may state prerequisites (a running service,
  an env file). Nothing else goes in the section.
- The format command is the checking variant (`--check`), so running
  the checks changes no files.

### `init`

New step after the `CLAUDE.md` block, also run when the block exists but
`## Checks` does not; `init`'s description names that case.

1. Find candidates in this order: CI configuration (what CI runs is
   authoritative), `justfile`, `Makefile`, package manifest scripts,
   the language defaults.
2. Have `devflow:verifier` run each candidate once.
3. Show the list with each result; the user confirms or corrects it.
   A command that fails because the code is broken is still the right
   command; one that fails because it does not exist is not.
4. Write the section. Never overwrite an existing `## Checks`; propose
   changes to it instead.

Projects with an `AGENTS.md`: Claude Code reads `AGENTS.md` only when
there is no `CLAUDE.md`, so creating a `CLAUDE.md` would silently hide
it. This also affects `init`'s existing devflow-block step.

- `AGENTS.md` and no `CLAUDE.md`: `init` creates `CLAUDE.md` with
  `@AGENTS.md` as its first line, then the devflow block. `## Checks`
  goes into `AGENTS.md`, so other coding agents get the commands too.
- Both files, and `CLAUDE.md` does not import `AGENTS.md`: `init` says
  that Claude does not read `AGENTS.md` and proposes the import; the
  user decides. `## Checks` goes where the user puts the import, else
  into `CLAUDE.md`.
- Never two `## Checks` sections. Readers take the one in `CLAUDE.md`
  or in the `AGENTS.md` it imports; both are in context.

### Readers

- `verifier`: commands from the brief; else from `## Checks`; else
  guessed as before, and the report says they were guessed and that no
  `## Checks` exists.
- `implementer`: runs `test one` while working and the relevant checks
  before reporting, from `## Checks` or the brief.
- `implement`, `review`, `debug`, `wrapup`, `audit`: brief agents with
  the commands from `## Checks`. If there is none, determine them, tell
  the user which were used, and offer to record them (that is the
  `init` step above, not a free-form edit).

### Testing rules

In `implementer` (replacing the current test-first line), in this
wording or tighter:

- Test behaviour through the public interface, not internals.
- Watch each new test fail before the code makes it pass, and report
  the failure you saw. A test that already passes (characterization)
  is checked by breaking the code briefly.
- Assert on results and effects. Prefer real objects, then fakes; mock
  only what is slow or not deterministic (network, clock, external
  services). A test that only checks that mocks were called tests
  nothing.
- No snapshot in place of an assertion on the value that matters.
- Never skip, delete or loosen a test, or change its expected value, to
  get green. A test you believe is wrong goes in the report.
- A flaky test is a defect: report it; never retry it until it passes.

`reviewer` gets one bullet: new and changed tests are checked against
these rules (listed in short form), and a breach is a finding. Changes
to existing tests get a separate look, because an agent under pressure
to get green edits the test rather than the code: removed or loosened
assertions, changed expected values, added skips or xfails, updated
snapshots or golden files, early exits in the test runner. Each needs a
reason in the spec or the implementer report.

The key phrase `never skip, delete or loosen a test` appears verbatim in
`implementer`, `reviewer` and the `test` skill; `tests/run.sh` checks it.

### Spec template and `implement`

- Task form in the spec template becomes
  `- [ ] 1. <Task>. *Done when* <criteria>, *shown by* <tests or manual check>.`
- The Testing section of the template stays.
- `implement` step 4 (Check) adds: the named tests exist, and the
  implementer report says they were seen failing first.
- `spec` is at its 100-line cap; the change is made within it by
  tightening existing text, without dropping a rule.

### `/devflow:test`

Frontmatter:

- `name: test`
- `description`: Add or repair tests for existing code - choose test
  levels, write characterization tests before changing untested code,
  fix flaky tests. Use when asked to add tests, raise coverage, cover
  code before a refactor, or fix a flaky test. Not for tests of a new
  feature, which implement writes with the code; not for a failing test
  whose cause is unknown, use devflow:debug.

Steps:

1. **Scope.** The code or tests named by the user. Commands from
   `## Checks`. Baseline: `devflow:verifier` runs the tests, and the
   coverage command if one exists.
2. **Survey.** Existing framework, test levels, helpers, fixtures and
   naming; new tests follow them.
3. **Plan.** List the behaviours to cover, each with a level: unit for
   logic, integration for boundaries the project owns (its database,
   files, its own services), end-to-end only for a few main paths.
   Characterization tests for code about to change: pin current
   behaviour as it is; behaviour that looks wrong is pinned with a
   comment and added to the backlog, not fixed. Show the plan to the
   user when it has more than about five tests or needs a new framework
   or tool (a dependency decision, with an ADR).
4. **Write.** Brief `devflow:implementer` with the plan; it applies the
   testing rules. Default model; haiku for mechanical additions to an
   existing pattern.
5. **Flaky.** Reproduce by repeated runs (e.g. 50) and in random or
   reverse order where the runner allows. Look for the cause: timing
   and sleeps, order dependence and shared state, time and time zones,
   randomness without a seed, network or external services,
   concurrency. Fix the cause. No retries, longer sleeps or skips. Not
   reproducible or cause not found: report the runs made and add a
   backlog item. Quarantining the test (skipped, with a marker that
   names the backlog item) only with the user's approval.
6. **Verify.** `devflow:verifier` runs all checks. Every new test was
   seen failing (implementer report, or by breaking the code briefly).
7. **Report.** Tests added per behaviour and level, coverage before and
   after if measured, suspected bugs found and their backlog items,
   what was not covered and why.

The skill states the testing rules itself (see ADR 0010) and stays
within 100 lines.

## Error handling

- No test framework in the project: the skill stops and proposes one,
  with pros, cons and a recommendation; nothing is installed without
  approval.
- A check command cannot run (missing tool, service down): reported as
  not run, never as passed; `init` records it anyway if the user
  confirms it is right.
- Two `## Checks` sections (one in each file): the agent uses the one in
  `CLAUDE.md` and reports the duplicate; the orchestrator proposes
  removing one.
- `## Checks` is stale (a command no longer exists): the agent reports
  it; the orchestrator proposes the fix to `CLAUDE.md`.
- Tests cannot be seen failing (code cannot be broken in isolation):
  the report says so for each such test.

## Testing

- `tests/run.sh`: `test` in the skill list (frontmatter, 100-line cap,
  reference resolution); the key phrase in `implementer`, `reviewer` and
  `skills/test/SKILL.md`; `core.md` still at most 70 lines.
- `claude plugin validate .`
- Headless smoke tests (see Lessons in `docs/architecture.md`), in
  scratch repos:
  - `init` on a small project with a `Makefile` and a CI file whose
    commands differ: `## Checks` follows CI, each command was run.
  - `init` on a project that already has the devflow block but no
    `## Checks`: only the section is added.
  - `init` on a project with only an `AGENTS.md`: `CLAUDE.md` imports
    it, `## Checks` is in `AGENTS.md`, and a fresh session shows both
    files under Memory files in `/context`.
  - `/devflow:test` on a seeded project with an untested function and a
    test that fails one run in a few (shared state): behaviour tests
    added at unit level, the flaky test fixed at the cause, no retry or
    skip added.

## Tasks

- [ ] 1. `init` writes `## Checks`: the new step, the format, the
  existing-project case, the `AGENTS.md` cases, the updated
  description. *Done when* the skill text contains the format and steps
  above and stays within 100 lines, *shown by* `tests/run.sh` and the
  three `init` smoke tests.
  Parallel with 4.
- [ ] 2. Readers use `## Checks`: `verifier`, `implementer`,
  `implement`, `review`, `debug`, `wrapup`, `audit`. *Done when* each
  names `## Checks` as the source and the fallback is as specified,
  *shown by* `tests/run.sh` and reading the diff.
- [ ] 3. Testing rules: `implementer` rules, `reviewer` check, spec
  template `*shown by*`, `implement` step 4. *Done when* the rules
  replace the old test-first line, the key phrase is in both agents,
  and `spec` stays within 100 lines, *shown by* `tests/run.sh`.
- [ ] 4. `skills/test/SKILL.md` as designed, plus `tests/run.sh`: `test`
  in the skill list and the key-phrase check over the three files.
  *Done when* the skill matches the Design section, *shown by*
  `tests/run.sh` (the key-phrase check fails until task 3 is done if
  run first; run it after both). Parallel with 1.
- [ ] 5. Docs: `core.md` names `/devflow:test` within 70 lines; README
  (command table, `CLAUDE.md` `## Checks` under Configuration,
  marketplace install marked tested); `architecture.md` components.
  *Done when* the docs match the change, *shown by* `tests/run.sh` and
  `devflow:doc-checker` on the branch.
- [ ] 6. Smoke tests. *Done when* the three headless runs in Testing
  behave as described, *shown by* their transcripts summarised in the
  task report; deviations become fixes or backlog items.
