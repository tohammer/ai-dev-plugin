# devflow

You work in a project that uses the devflow plugin. These rules apply to
all development work. The project's `CLAUDE.md` takes precedence.

## Workflow

- **Trivial change:** do it directly.
- **Non-trivial feature:** `/devflow:spec` → the user reviews the spec →
  `/devflow:implement` → `/devflow:review` → `/devflow:wrapup`.
- A change is non-trivial when it adds a component, changes an interface
  or data format other code depends on, or cannot be described completely
  in two sentences. When unsure, treat it as non-trivial.
- Bugs and unexpected behaviour: `/devflow:debug`. Whole-project review:
  `/devflow:audit`. Without the docs layout below: offer `/devflow:init`.

## Questions to the user

- When something needed for a decision is not in the request, the code
  or the docs, ask; do not assume. What they can answer is looked up.
- Every question or choice for the user: a brief explanation, pros and
  cons per option if applicable, a recommendation and why it is better.

## Branches

- Feature work happens on a feature branch created from the default
  branch. Do not use worktrees.
- Documentation-only changes may go directly on the default branch.

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

- Docs go in the same commit as their code. A change to install steps,
  commands, flags or features is not done until the README says so.
- Every non-obvious technical decision gets an ADR with the next free
  number. Accepted ADRs are not relitigated; supersede them with a new one.
- Only the user approves a spec. Code for a non-trivial feature starts
  from an approved spec; do not ask whether to start implementing it.
- Finished items are deleted from backlog and next-steps; git keeps the
  history. Review findings that are deliberately not fixed go into the
  backlog with origin, reason and when to revisit.
- `architecture.md` and `backlog.md` may be split into a directory of the
  same name (`docs/backlog/<area>.md`) when they grow; accept either form.

## Subagents and models

- Use a subagent when only the conclusion is needed or the work is
  separable. Do not spawn one for a small lookup.
- Agents (default model): haiku `devflow:explorer`, `devflow:verifier`,
  `devflow:doc-checker`; sonnet `devflow:implementer`, `devflow:reviewer`.
- Pick the cheapest model that can do the task well, and override the
  default with the Agent tool's `model` parameter: haiku for mechanical
  work, sonnet for ordinary implementation and review, opus for complex
  tasks (concurrency, security, cross-module interfaces, subtle logic).
- Design, spec writing, task briefing and triage of findings stay with
  you. Brief subagents fully: they see nothing of this conversation.

## Verification

State that something works only after running the command that shows it,
in this session. Report what you did not verify.
