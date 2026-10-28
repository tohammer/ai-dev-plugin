# Architecture

The plugin as it is now. Reasoning is in `docs/decisions/`.

## Overview

devflow is a Claude Code plugin made of text: instructions for the
orchestrating model and agent definitions for subagents. The only executable parts are the hook script and the tests.

## Components

| Component | Responsibility | Depends on |
|---|---|---|
| `core.md` | General instructions present in every session: workflow, docs layout, subagent and model rules, verification | — |
| `hooks/` | SessionStart hook that prints `core.md` into the session | `core.md` |
| `skills/` | One skill per phase: init, spec, implement, review, debug, wrapup, ship; `audit` (whole-project review), `userdocs` (user-facing docs), `test` (tests for existing code) and `describe` (writes PR and landing commit messages; loaded by `ship`) are not phases of the feature workflow. Loaded on demand. `spec` and `init` embed the document starting content; `init` also records the project's check commands | agents |
| `agents/` | Subagent definitions, without a model (chosen per dispatch, ADR 0016): explorer, verifier, doc-checker, implementer, reviewer. `implementer` holds the testing rules, `reviewer` checks them | — |
| `tests/run.sh` | Structure checks: hook output, frontmatter, size limits, references, the testing rules' key phrase in all three copies | all of the above |

## How it fits together

- At session start the hook prints `core.md`. That is the only always-on
  context cost, so `core.md` is capped at 70 lines by a test.
- `core.md` names the skills and agents. A skill is loaded when the user
  runs `/devflow:<name>` or the model matches its description.
- Skills tell the orchestrator which agent to dispatch and when to
  override its default model. Agents never dispatch further agents.
- A project's check commands live in a `## Checks` section of its
  `CLAUDE.md`, or of the `AGENTS.md` that `CLAUDE.md` imports. Both are
  in the context of every session and devflow agent, so skills and
  agents use the section without reading a file (ADR 0009).
- A project's shipping policy (history, merge, target) lives in a
  `## Shipping` section beside `## Checks`, written by `ship` on first
  use (ADR 0011).
- `ship` loads `describe` for the PR text, squash messages and local
  merge messages; a PR's merge commit takes its message from the PR via
  the forge. A format in `CLAUDE.md` or a PR template takes precedence;
  subjects follow the detected commit convention (ADRs 0012, 0013,
  0015).
- The testing rules exist in `implementer`, `reviewer` and the `test`
  skill, because skills cannot read plugin files (ADR 0010). Change all
  three together.
- Skills and `core.md` both state the docs layout. `core.md` is the
  authority; a layout change must be made there, in the skills that
  mention the affected path and in the README.

## Lessons

- SessionStart hook stdout is added to the context as is, so the hook
  needs no JSON encoding and no dependencies.
- Read-only agents are restricted with `disallowedTools` (Edit, Write,
  NotebookEdit) instead of a `tools` allow-list, so they keep whatever
  search tools the harness provides.
- A session cannot read files inside the plugin directory: Read is
  denied outside the working directory, and load-time `` !`cat …` ``
  injection is blocked the same way. Skills must therefore be
  self-contained; a test rejects `CLAUDE_PLUGIN_ROOT` in skill text.
- Claude Code reads `AGENTS.md` only when there is no `CLAUDE.md`;
  creating a `CLAUDE.md` silently hides it unless it imports
  `@AGENTS.md`. Custom subagents load `CLAUDE.md` unless they set
  `omitClaudeMd`; the built-in Explore and Plan agents do not.
- `core.md` (70), `init`, `spec`, `audit` and `ship` (100) are at their
  line caps, `describe` (99) is near it; any addition there needs
  tightening elsewhere.
- `git push --force-with-lease` without an expected SHA compares with
  the remote-tracking ref, which a fetch has just updated, so it
  overwrites a push made in between. Pass `<branch>:<sha>` noted before
  the rewrite.
- A vague trigger for the PR diagram ("prose would need more than a
  paragraph") produced no diagram in smoke tests; concrete triggers (new
  component, new call path, changed state) did.
- Model names differ per host for the same model: Claude Code accepts
  `sonnet` and `claude-sonnet-5-5`, Copilot only `claude-sonnet-5.5`.
  Claude Code's dispatch tool takes only the aliases. A `model:` in an
  agent file breaks on one host, so the model is passed at dispatch.
- Headless smoke test of one phase:
  `claude --plugin-dir . -p "/devflow:init" --permission-mode acceptEdits </dev/null`
  in a scratch repo; continue the same session with `-c -p "…"`.
