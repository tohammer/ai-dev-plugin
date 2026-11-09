# Model and reasoning effort per subagent task

Status: implemented
Date: 2026-11-09

## Purpose

Skills name a model for each dispatch, but no reasoning effort. Each
host then applies its own default effort, which is often a poor fit:
Claude Code runs opus at medium, so security work gets less reasoning
than it needs, and sonnet at high, so routine coding spends more
tokens than it needs. Some dispatches name no model at all: fixing a
flaky test, fixing review findings, and the explorer and verifier
calls in several skills. "Stronger model" for escalation is not
defined, and "critical" decides whether review gets opus without a
definition.

This feature names a model and an effort for every dispatch, chosen
for the task rather than the agent, and defines one ladder for
escalation.

Prices per million output tokens: haiku $0.50, sonnet $10, opus $20.
Opus costs twice as much per token as sonnet. At low effort it uses
fewer tokens, so opus/low can be the better buy than sonnet/high where
the task needs judgment but little searching.

Success means:

- Every dispatch in the skills names a model and an effort, so the
  orchestrator does not have to look anything up.
- Every task in the table under Design has a first choice, and a
  second choice to escalate to where one makes sense.
- "Stronger model" means one step up the ladder everywhere.
- Copilot still dispatches, whether or not its dispatch tool takes an
  effort.

## Scope

In:

- `core.md`: one short rule (see Where the text goes); the detail
  lives in the skills.
- Skills that dispatch subagents: implement, test, review, audit,
  debug, spec, userdocs, wrapup, init, ship.
- The four opus criteria (see When a task gets opus), replacing
  "concurrency, security, cross-module interfaces and subtle logic"
  and "security- or correctness-critical".
- `spec` skill: the task list marks each opus task with its
  criterion. Its line cap rises above 100 as needed (see the Line caps bullet under Where the text goes).
- ADR 0017, which extends ADR 0016 with effort.
- README section "Agents and models", `docs/architecture.md`,
  `tests/run.sh`.

Out:

- Effort in agent frontmatter. It would apply on one host only, the
  same problem ADR 0016 solved for model names.
- `max` effort. Its cost does not pay off for any task here.
- Measuring the ladder. The order is an estimate from the published
  model guidance. Smoke tests may move a task's choice later.
- The orchestrator's own model and effort. The user sets those.

## Design

### Notation

Skills write a choice as `model/effort`, for example `opus/high`. The
model is the short name (haiku, sonnet, opus). `core.md` maps it to
the host's spelling, as it does now. Effort is one of `low`, `medium`,
`high`, `xhigh`.

### Hosts

- Claude Code: the dispatch tool takes `model` (`haiku`, `sonnet`,
  `opus`) and `effort` (`low` … `max`). Pass both.
- Copilot: the model is `claude-haiku-5.5`, `claude-sonnet-5.5` or
  `claude-opus-5.5`. Whether its dispatch tool takes an effort is not
  known. Rule for every host: pass the effort where the dispatch tool
  has a parameter for it, otherwise pass only the model. Never leave
  the model out.

### Ladder

Weakest first. A step up is the next entry. Effort scales the number
of tokens used, so cost depends on both model and effort.

1. haiku/low
2. haiku/medium
3. sonnet/low
4. sonnet/medium
5. sonnet/high, about the same as opus/low
6. opus/medium
7. opus/high
8. opus/xhigh

Escalation, which replaces "stronger model": after two failures of a
task, re-run it at its 2nd choice, or one step up where there is no
2nd (or after it), with a brief that names what went wrong, or do it
yourself. A reviewer that fails or returns nothing usable is
re-dispatched once the same way. Nothing goes above opus/xhigh. A 2nd
choice is never below its 1st (fixed in review).

### Dispatches outside a skill

haiku/low for lookups, sonnet/medium for everything else. This is the
only default; every skill names its own choices.

### When a task gets opus

A task gets opus only if at least one criterion holds:

1. **Shared state under concurrency.** Threads, async tasks,
   processes or concurrent requests read and write the same state:
   locks, queues, caches, retries where order matters.
2. **Security boundary.** Authentication, authorization, secrets,
   cryptography, or input from outside the program (users, network,
   files from others) that reaches a shell, SQL, a template, a file
   path or a deserializer.
3. **Breaking change.** The task changes a signature, behaviour, file
   format or schema that existing code or stored data relies on, and
   must keep those callers or data working. Adding a new interface or
   calling another module does not count.
4. **Errors example tests rarely catch.** Floating-point precision,
   dates and time zones, cache invalidation, state machines, parsers.

Otherwise the task gets sonnet. When unsure, sonnet, except for
criterion 2: when unsure there, opus.

Who decides:

- With a spec: the spec's task list marks each opus task with its
  criterion, e.g. `- [ ] 3. … (opus: security boundary)`. The user
  sees and corrects the marks at spec review. `implement` dispatches
  marked tasks at opus/high and unmarked ones per the table; it does
  not add or drop marks on its own. A mark it thinks wrong is raised
  with the user.
- Without a spec (review, audit, test, ad-hoc dispatches): the
  orchestrator applies the criteria and names the criterion in the
  dispatch brief.

### Choice per task

The 1st choice is what the skill names. The 2nd is the escalation
target, or the choice when a task is harder than usual (the
condition is in the Why column). "Avoid" lists choices the skill must
not suggest.

| # | Task | Skill, agent | Now | 1st | 2nd | Avoid | Why |
|---|---|---|---|---|---|---|---|
| 1 | Find code or symbols | spec, audit, debug, userdocs; explorer | haiku | haiku/low | — | sonnet | A lookup needs no reasoning. |
| 2 | Condense large docs, logs or sources | spec, debug; explorer | haiku | haiku/medium | sonnet/low | haiku/low | At low effort haiku drops details. Use the 2nd when the summary feeds a design decision (spec). |
| 3 | Run checks, pull out failures | all; verifier | haiku | haiku/low | — | — | Mechanical. |
| 4 | Repeated runs of a flaky test | test; verifier | haiku | haiku/low | — | — | Mechanical. |
| 5 | Find stale or missing docs | wrapup; doc-checker | haiku | haiku/medium | sonnet/low | haiku/low | Comparing code with text needs judgment. Use the 2nd when the change touches many docs. |
| 6 | Mechanical implementation: renames, fixtures, boilerplate | implement; implementer | haiku | haiku/medium | sonnet/low | — | Follows a given pattern. |
| 7 | Ordinary implementation task | implement; implementer | sonnet | sonnet/medium | sonnet/high | opus | Recommended level for agentic coding; high adds tokens without gain on routine work. |
| 8 | Task marked with an opus criterion | implement; implementer | opus | opus/high | opus/xhigh | opus/medium | Where effort pays off; opus/medium is today's host default. |
| 9 | Tests following an existing pattern | test; implementer | haiku | haiku/medium | sonnet/medium | — | |
| 10 | New tests or characterization tests | test; implementer | sonnet | sonnet/medium | sonnet/high | — | |
| 11 | Fix a flaky test | test; implementer | none | opus/medium | opus/high | sonnet | Causes are timing, order or concurrency. |
| 12 | Fix review findings | review; implementer | none | sonnet/medium | opus/high | — | opus/high for a finding that meets an opus criterion. |
| 13 | Review a small, ordinary change | review; reviewer | sonnet | sonnet/high | opus/low | haiku | Defect finding needs thoroughness; the output is short. opus/medium when any part meets an opus criterion (found in the smoke test). |
| 14 | Review for spec conformance, large change | review; reviewer | sonnet or opus | sonnet/medium | opus/low | — | Checking against a list. |
| 15 | Review for correctness, large change | review; reviewer | sonnet, opus if critical | opus/medium | opus/high | sonnet/medium | 2nd when the change meets an opus criterion. |
| 16 | Review for security | review; reviewer | opus if critical | opus/high | opus/xhigh | sonnet | Always, not only when "critical". |
| 17 | Audit one code area, ordinary | audit; reviewer | sonnet | sonnet/high | opus/medium | — | |
| 18 | Audit a code area that meets an opus criterion | audit; reviewer | opus | opus/high | opus/xhigh | — | |
| 19 | Audit the security aspect | audit; reviewer | opus | opus/xhigh | — | — | One dispatch with the highest stakes; the only xhigh default. |
| 20 | Audit tests, build and CI, dependencies (aspects 3–5) | audit; reviewer | sonnet | sonnet/medium | sonnet/high | — | |
| 21 | Audit docs, configuration, hygiene (aspects 6–8) | audit; reviewer | sonnet | sonnet/low | sonnet/medium | — | Mostly comparing and listing. |

The orchestrator may pick the 2nd choice up front when the brief
shows the task is harder than usual. It says why in the dispatch
brief.

### Where the text goes

- `core.md`: replaces the current model bullet with one short rule:
  agent files set no model or effort; every dispatch passes
  `model/effort` as the skill names it; the host spelling map; effort
  only where the dispatch tool takes one, never `max`; outside a
  skill haiku/low for lookups, sonnet/medium otherwise. No ladder, no
  criteria. `core.md` stays at most 70 lines.
- The ladder and escalation rule: in each skill that escalates
  (implement, test, review, audit).
- The four opus criteria with their examples: in each skill that
  chooses opus (spec, implement, test, review, audit).
- `spec`: the task list format gains the `(opus: <criterion>)` mark
  and the instruction to mark tasks by the criteria.
- Each skill names `model/effort` for each of its own dispatches, rows
  from the table, so the orchestrator looks nothing up. Skills cannot
  read plugin files, so the choices are written out in each skill,
  not referenced.
- Line caps: a skill that cannot fit its additions within its cap
  gets the cap raised to the smallest number that fits, at most 115,
  in `tests/run.sh`.
- README "Agents and models": the notation, the host rule, and the
  table cut down to Task, 1st and 2nd.
- `docs/architecture.md`: the Copilot effort finding, once known.

### ADR 0017

`0017-effort-named-at-dispatch-with-the-model.md`, extending ADR 0016
(which stays accepted): agents set neither model nor effort; every
dispatch names both, effort only where the host takes it; one ladder
defines escalation; `max` is not used; opus only by the four criteria,
marked per task in the spec.

## Error handling

- Host without an effort parameter: the dispatch passes only the
  model, so the host's default effort applies. Not an error.
- Host rejects an effort value: re-dispatch without the effort and
  tell the user. Record the finding in `docs/architecture.md`.
- A first choice that turns out too weak in use: escalate per the
  ladder; repeated cases go to the backlog with the task row number.

## Testing

- `tests/run.sh`, new check: in `core.md` and `skills/*/SKILL.md`,
  every mention of haiku, sonnet or opus is written `model/effort`,
  except the host spelling map in `core.md`.
- `tests/run.sh`, new check: implement, test, review and audit each
  list all eight ladder steps.
- Existing checks: `core.md` at most 70 lines, skill line caps (raised
  to at most 115 where needed), agents set no model.
- `tests/run.sh`, new check: no skill and not `core.md` contains
  "cross-module interfaces" or "correctness-critical".
- `claude plugin validate .`
- Manual, Claude Code: headless `/devflow:implement` on a small spec
  in a scratch repo; the transcript shows each Agent call with both
  `model` and `effort` as the table says.
- Manual, Claude Code, cost comparison: deferred to the backlog item
  "Cost comparison of model and effort choices" (task 11).
- Manual, Copilot: one dispatch; note whether effort is accepted. Not
  part of this feature's completion; tracked in next-steps item 1.

## Tasks

- [x] 1. Write ADR 0017, covering effort at dispatch, the ladder, the
  four opus criteria and the spec mark. *Done when* it states the
  decision in ADR format and ADR 0016 links to it, *shown by* reading both files.
- [x] 2. Rewrite the model bullet in `core.md` as in Where the text
  goes. *Done when* the text matches Design and `core.md` is at most
  70 lines, *shown by* `tests/run.sh`.
- [x] 3. implement and test skills: rows 6–11, the ladder, the
  escalation rule and the opus criteria.
  *Done when* every dispatch names `model/effort`, *shown by* reading
  the diff and `tests/run.sh`. Parallel with 4–6.
- [x] 4. review skill: rows 12–16 and the reviewer re-dispatch rule.
  *Done when* "critical" no longer decides the security reviewer's
  model, *shown by* reading the diff and `tests/run.sh`. Parallel
  with 3, 5, 6.
- [x] 5. audit skill: rows 1, 3, 17–21, the ladder, the re-dispatch
  rule and the opus criteria, within its cap (see the Line caps bullet under Where the text goes). *Done when* every dispatch names `model/effort`,
  *shown by* reading the diff and `tests/run.sh`. Parallel with 3, 4,
  6.
- [x] 6. debug, userdocs, wrapup, init, ship: rows 1–5. *Done when*
  every dispatch names `model/effort` and no skill exceeds its line
  cap, *shown by* reading the diff and `tests/run.sh`. Parallel with
  3–5 and 7.
- [x] 7. spec skill: rows 1–2, the `(opus: <criterion>)` mark in the
  task list format, the instruction to mark tasks by the four
  criteria; raise its cap as needed in `tests/run.sh`. *Done when* the
  skill is at most 113 lines and states the criteria and the mark,
  *shown by* reading the diff and `tests/run.sh`. Parallel with 3–6.
- [x] 8. Add the new checks from Testing to `tests/run.sh`. *Done
  when* they pass on the changed files and fail on a skill with a bare
  `sonnet` or the phrase "cross-module interfaces", *shown by* running
  `tests/run.sh` before and after a temporary bad line.
- [x] 9. README "Agents and models" (with the opus criteria and the
  spec mark) and next-steps item 1 (check Copilot effort). *Done when*
  they match Design, *shown by* the doc-checker run at wrapup.
- [x] 10. Smoke test on Claude Code as in Testing. *Done when* every
  Agent call in the transcript carries the model and effort the table
  names, *shown by* the transcript excerpt in the review.
- Task 11, the cost comparison, was moved to the backlog by the user
  ("Cost comparison of model and effort choices").

## Deviations

Found while building, smoke-testing and reviewing:

- Escalation goes to the 2nd choice first, then one step up the
  ladder; a 2nd choice is never weaker than its 1st. Rows 19 and 21
  changed accordingly; rows 1 and 3 have no 2nd choice.
- Review: a small change with a part that meets an opus criterion gets
  a reviewer at opus/medium (from the smoke test). A 2nd choice is used
  up front only with a reason in the brief.
- Test: new or characterization tests for code that meets an opus
  criterion run at opus/high (2nd opus/xhigh), which row 10 does not
  list.
- Audit: on a small project aspects 4–8 may share one reviewer at
  sonnet/medium.
- Implement applies the opus criteria itself only to specs dated before
  2026-11-09; newer specs are authoritative, with or without marks.
- `core.md` also says: if the host rejects an effort value, drop it and
  tell the user.
- Line caps: audit 110, spec 113.
