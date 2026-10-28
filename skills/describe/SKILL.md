---
name: describe
description: Write the PR title and description and the message of the commit that lands (squash or merge) for a branch. Use when ship needs messages, or when asked to describe a branch or write a PR description. It does not commit, push or call gh.
---

# Describe

Write each text to a file in the scratchpad and show it: a commit
message as one file (subject, blank line, body), the PR title and the
PR body as two files. Never commit, push or call `gh`.

## Inputs

Branch range against the default branch; the spec and the ADRs it
links; check results of this session; review findings (fixed and
deferred); PR number and body if one exists; target (pull request or
local merge) and merge method.

## Outputs

- PR title and body: only when the target is a pull request.
- Landing commit message: squash or merge variant, both when a squash
  commit lands through a merge commit. None for rebase, fast-forward.

## Precedence

1. A format stated in CLAUDE.md.
2. Else `.github/pull_request_template.md` (or the same file in the
   repository root or `docs/`) for the PR body. Fill its sections; the
   language rules still apply. Content without a matching section is
   left out.
3. Else the format below.

The subject follows the commit convention in every case: CLAUDE.md if
stated, else the last ~20 commits on the default branch.

## Title

Imperative; completes "If applied, this commit will ...". At most 50
characters, never over 72. Name what changes; the reason goes in the
body.

## PR body

Sections in this order. Summary, Why, Approach, Impact, Verification
always; Review focus and Links only with content.

| Section | Reader: answers | Not here | From |
|---|---|---|---|
| Summary (1-2 sentences) | skimmer: what does it do? | details, file lists | spec Purpose |
| Why | reviewer, maintainer: what was wrong or missing? | how it was built | spec Purpose, bug report |
| Approach | reviewer, maintainer: why this design, what was ruled out, which limits? | file walk-through, ADR text | spec Design, ADRs |
| Impact | users, operators: what changes in behaviour, interface, config, migration, breaking? | internals; write "None" if nothing | README, user-doc changes |
| Verification | reviewer: how shown to work, how to reproduce? | raw logs, anything not run this session, checks CI runs on the PR | checks CI does not run, manual checks |
| Review focus | reviewer: where to look hard, what is open? | what history needs, fixed findings | deferred findings, risks, untested paths |
| Links | tooling: where is the context? | prose repeating links | spec, ADRs, `Fixes #N` |

Only Summary may repeat another section. Length follows the change: a
one-line fix gets one line per section. Attribution lines last.

## Diagrams

Add a Mermaid diagram to the PR body when the change alters a flow
between components, a state machine or the component structure: a new
or removed component, a new call path, a new or changed state. Skip it
for changes inside one component. Sequence for interactions, state for
states, flowchart for structure. At most about 12 nodes; a larger one
means no diagram. The text must be complete without it. Never in a
commit message.

## Landing commit message

- Subject: the title (see Title), written once and reused by every
  variant, plus ` (#N)` when the change goes through a PR.
- Squash (the only record): Why, Approach and Impact (unless "None") as
  plain paragraphs, no headings.
- Merge (branch commits carry the detail): Summary and Why.
- Trailers last, one block: `Fixes #N` if an issue is linked,
  `Refs: <spec path>` if a spec exists, then attribution lines.
- Wrap at 72 columns; readable without the links.
- Never: Verification, Review focus, diagrams, checklists, review notes.

## Language

- At most 25 words per sentence; one topic per sentence and paragraph.
- Active voice, present tense. Describe the problem as it is, not
  "Currently ...".
- One term per concept; spell out abbreviations on first use; use a noun
  where a pronoun is ambiguous.
- No idioms, filler ("simply", "please note"), or inflated words
  ("robust", "comprehensive", "seamless").
- No claim without a command run this session that shows it.

## Errors

- No spec: take Why and Approach from commits and conversation. Reason
  unknown: ask; never invent one.
- No PR yet: no ` (#N)`.
- No checks run this session: Verification says so.
