# devflow

Rules for all development work; project `CLAUDE.md` takes precedence.

## Workflow

- Trivial change: do it directly. Non-trivial feature: `/devflow:spec`
  → the user reviews the spec → `/devflow:implement` → `/devflow:review`
  → `/devflow:wrapup` → `/devflow:ship`.
- A change is non-trivial when it adds a component, changes an interface
  or data format other code depends on, or cannot be described completely
  in two sentences. When unsure, treat it as non-trivial.
- Bugs: `/devflow:debug`. Tests for existing code, flaky tests:
  `/devflow:test`. Whole-project review: `/devflow:audit`. README and
  user docs: `/devflow:userdocs`. No docs layout below or no
  `## Checks`: offer `/devflow:init`.

## Questions to the user

- When something needed for a decision is not in the request, the code
  or the docs, ask; do not assume. What they can answer is looked up.
- Every question or choice for the user: a brief explanation, pros and
  cons per option if applicable, a recommendation and why it is better.

## Branches

- Feature work: feature branch from the default branch; no worktrees.
- Documentation-only changes may go directly on the default branch.

## Docs layout

```
README.md                          user-side instructions
docs/user/<topic>.md               user docs beyond the README
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
- Delete finished items from backlog and next-steps; git keeps them.
  Unfixed findings go to the backlog with origin, reason, when to revisit.
- `architecture.md` and `backlog.md` may be split into a directory of the
  same name (`docs/backlog/<area>.md`) when they grow; accept either form.

## Subagents and models

- Use a subagent when only the conclusion is needed or the work is
  separable. Do not spawn one for a small lookup.
- Agent files set no model; always pass one at dispatch, in the host's
  spelling (Claude Code `haiku`/`sonnet`/`opus`, Copilot
  `claude-haiku-5.5`/`claude-sonnet-5.5`/`claude-opus-5.5`): haiku for
  explorer, verifier, doc-checker and mechanical tasks; sonnet for
  implementation and review; opus for concurrency, security,
  cross-module interfaces and subtle logic.
- Design, spec writing, task briefing and triage of findings stay with
  you. Brief subagents fully: they see nothing of this conversation.

## Verification

State that something works only after running the command that shows it,
in this session. Report what you did not verify.
