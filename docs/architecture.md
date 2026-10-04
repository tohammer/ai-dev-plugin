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
| `skills/` | One skill per phase: init, spec, implement, review, debug, wrapup. Loaded on demand. `spec` and `init` embed the document starting content | agents |
| `agents/` | Subagent definitions with a default model each: explorer, verifier, doc-checker, implementer, reviewer | — |
| `tests/run.sh` | Structure checks: hook output, frontmatter, size limits, references | all of the above |

## How it fits together

- At session start the hook prints `core.md`. That is the only always-on
  context cost, so `core.md` is capped at 60 lines by a test.
- `core.md` names the skills and agents. A skill is loaded when the user
  runs `/devflow:<name>` or the model matches its description.
- Skills tell the orchestrator which agent to dispatch and when to
  override its default model. Agents never dispatch further agents.
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
- Headless smoke test of one phase:
  `claude --plugin-dir . -p "/devflow:init" --permission-mode acceptEdits </dev/null`
  in a scratch repo; continue the same session with `-c -p "…"`.
