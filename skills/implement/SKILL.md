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
   commands from `## Checks`), the mockup if the spec links one, and
   what not to touch. The subagent sees nothing else, so include the
   paths and facts it needs.
2. **Pick the model** (host spelling per `core.md`). The spec's task
   list marks tasks that meet an opus criterion with
   `(opus: <criterion>)`.
   - Marked: opus/high (2nd: opus/xhigh).
   - Unmarked, ordinary: sonnet/medium (2nd: sonnet/high).
   - Unmarked, mechanical (renames, fixtures, boilerplate from an
     explicit pattern): haiku/medium (2nd: sonnet/low).

   Do not add or drop marks; a mark that looks wrong goes to the user.
   Specs dated before 2026-11-09 have no marks: for those only, apply
   the opus criteria below and name the criterion in the brief. Use the
   2nd choice up front when
   the brief shows the task is harder than usual, and say why in the
   brief.
   The opus criteria:
   1. Shared state under concurrency: threads, async tasks, processes
      or concurrent requests read and write the same state.
   2. Security boundary: authentication, authorization, secrets,
      cryptography, or outside input reaching a shell, SQL, a template,
      a file path or a deserializer.
   3. Breaking change to a signature, behaviour, file format or schema
      that existing code or stored data relies on (a new interface or
      calling another module does not count).
   4. Errors example tests rarely catch: floating-point precision,
      dates and time zones, cache invalidation, state machines, parsers.

   Unsure (older specs only): sonnet/medium, except criterion 2:
   unsure there means opus/high.
3. **Dispatch.** Tasks the spec marks as independent may run in
   parallel, provided they do not edit the same files.
4. **Check.** Read the diff yourself against the acceptance criteria.
   Have `devflow:verifier` (haiku/low) run the checks from `## Checks`. Without
   that section, determine the commands, tell the user which were used
   and offer to record them with `/devflow:init`. A stale or duplicate section:
   propose the fix to the user. Confirm that the tests the task names
   exist and the report says they were seen failing first. A task is
   done when the criteria hold and the checks pass, not when the
   subagent says so.
5. **Record.** Tick the checkbox in the spec. Commit if the user has
   asked for commits, with the checkbox in the same commit.

## When it goes wrong

- A task that fails twice in a subagent: do it yourself or re-run it at
  its 2nd choice (without one, or after it, one step up the ladder)
  with a brief that names what went wrong.
  Ladder, weakest first: haiku/low, haiku/medium, sonnet/low,
  sonnet/medium, sonnet/high (about opus/low), opus/medium, opus/high,
  opus/xhigh.
- A task that shows the spec is wrong or incomplete: stop and take the
  question to the user: what is wrong, the options with their pros and
  cons, and your recommendation with the reason it is better. Update
  the spec before continuing.
- Work discovered that is outside the spec: add it to `docs/backlog.md`,
  do not build it.

## After the last task

Run `/devflow:review` on the whole change, then `/devflow:wrapup`.
