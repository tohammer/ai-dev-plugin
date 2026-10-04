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
- Bugs and unexpected behaviour: `/devflow:debug`.
- A project without the docs layout below: offer `/devflow:init`.

## Docs layout

```
README.md                          user-side instructions
docs/architecture.md               the system as it is now
docs/specs/YYYY-MM-DD-<topic>.md   Status: draft | approved | implemented
docs/decisions/NNNN-<title>.md     ADRs: Context / Decision / Consequences
docs/backlog.md                    open points only
docs/next-steps.md                 what to do next, nothing else
```

- Docs change in the same commit as the code they describe. A change that
  alters install steps, commands, flags or features is not done until the
  README says so.
- Every non-obvious technical decision gets an ADR with the next free
  number. Accepted ADRs are not relitigated; supersede them with a new one.
- Only the user approves a spec. Code for a non-trivial feature starts
  from an approved spec.
- Finished items are deleted from backlog and next-steps; git keeps the
  history. Review findings that are deliberately not fixed go into the
  backlog with origin, reason and when to revisit.
- `architecture.md` and `backlog.md` may be split into a directory of the
  same name (`docs/backlog/<area>.md`) when they grow; accept either form.

## Subagents and models

- Use a subagent when only the conclusion is needed or the work is
  separable. Do not spawn one for a small lookup.
- Agents: `devflow:explorer`, `devflow:verifier`, `devflow:doc-checker`
  (default haiku), `devflow:implementer`, `devflow:reviewer` (default
  sonnet).
- Pick the cheapest model that can do the task well, and override the
  default with the Agent tool's `model` parameter: haiku for mechanical
  work, sonnet for ordinary implementation and review, opus for complex
  tasks (concurrency, security, cross-module interfaces, subtle logic).
- Design, spec writing, task briefing and triage of findings stay with
  you. Brief subagents fully: they see nothing of this conversation.

## Verification

State that something works only after running the command that shows it,
in this session. Report what you did not verify.
