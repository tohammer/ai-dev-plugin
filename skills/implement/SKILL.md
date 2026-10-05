---
name: implement
description: Execute the task list of an approved spec by briefing implementer subagents task by task and checking their results. Use when a spec in docs/specs/ is approved and its tasks are to be built.
---

# Implement

You orchestrate; subagents write the code.

## Before starting

- Find the spec (argument, or the approved spec with unticked tasks). If
  its status is not `approved`, stop and tell the user the approval is
  missing.
- Read the spec and the ADRs it links. Continue from the first unticked
  task.
- Work on a feature branch. On the default branch, create one named
  after the spec topic and switch to it; no worktree. If a feature
  branch for this spec exists, switch to it.

## Per task

1. **Brief.** Write a self-contained brief for `devflow:implementer`:
   the goal, the files and interfaces involved, the acceptance criteria
   from the spec, the constraints that apply (ADRs, project rules, the
   check commands), the mockup if the spec links one, and what not to
   touch. The subagent sees nothing else, so include the paths and facts
   it needs.
2. **Pick the model.** Default is sonnet. Pass `model: "opus"` for tasks
   involving concurrency, security, cross-module interfaces or subtle
   logic; `model: "haiku"` for mechanical ones (renames, fixtures,
   boilerplate from an explicit pattern).
3. **Dispatch.** Tasks the spec marks as independent may run in
   parallel, provided they do not edit the same files.
4. **Check.** Read the diff yourself against the acceptance criteria.
   Have `devflow:verifier` run the project's checks. A task is done when
   the criteria hold and the checks pass, not when the subagent says so.
5. **Record.** Tick the checkbox in the spec. Commit if the user has
   asked for commits, with the checkbox in the same commit.

## When it goes wrong

- A task that fails twice in a subagent: do it yourself or re-run it on
  a stronger model with a brief that names what went wrong.
- A task that shows the spec is wrong or incomplete: stop and take the
  question to the user. Update the spec before continuing.
- Work discovered that is outside the spec: add it to `docs/backlog.md`,
  do not build it.

## After the last task

Run `/devflow:review` on the whole change, then `/devflow:wrapup`.
