# PR descriptions and merge commit messages

Status: implemented
Date: 2026-10-28

## Purpose

`ship` writes PR descriptions with sections that overlap and restate
the diff (Purpose, Changes, Testing, Review). Merge commit messages are
not defined at all: they come from git's or GitHub's defaults, such as
"Merge branch 'x'" or "Merge pull request #N from …", which carry no
reason for the change.

This feature gives both a defined structure. Each PR section has one
reader and answers one question. The commit that lands keeps what
history needs and drops what only matters during review. The text
follows plain-language rules that a reviewer can check.

Readers: the reviewer of the PR now; the maintainer who reads
`git log` or `git blame` later; users, operators and the writer of
release notes, who need to know what changes for them.

Success means:

- Every PR that `ship` opens has the sections in Design, each answering
  only its own question, sized to the change.
- Every merge commit and squash commit that `ship` creates has a
  message written by devflow, not a git or GitHub default.
- No commit message contains test results, review notes or diagrams.
- A project's own PR template or stated format takes precedence.
- The subject still follows the project's detected commit convention
  ([ADR 0012](../decisions/0012-commit-convention-detected-not-imposed.md)).

## Scope

In:

- New skill `skills/describe/SKILL.md`, at most 100 lines. It writes the
  PR title and description and the message of the commit that lands.
  `ship` loads it; a user can also run it alone to describe a branch.
- `ship` changes: the Messages section points to `describe`; the plan
  shows the messages; `ship` passes the merge message explicitly for a
  local merge and for `gh pr merge`.
- ADRs 0013 and 0014 (written with this spec).
- README, `architecture.md`, `tests/run.sh` updated.

Out:

- Updating the description of a PR that is already open when the
  branch changes later. Goes to the backlog.
- Messages of ordinary commits during `implement`, and of the commits
  that `regroup` creates. They keep following the detected convention.
- Squash merges done on GitHub. `ship` never squash-merges on GitHub
  (`history: squash` squashes locally before the PR).
- Applying the language rules to specs and other docs. A later step if
  they work here.
- `core.md`: no change. `describe` is reached through `ship` or its
  description, and `core.md` is at its line cap.

## Design

### Components

- **`describe` skill.** Input: the branch and its range against the
  default branch, the spec and ADRs it links, the check results of the
  session, the review findings (fixed and deferred), and the PR number
  if one exists. Output: PR title and body only when the target is a
  pull request, and the landing commit message in the variant that
  fits (squash or merge). Writes each to a
  file in the scratchpad and shows them; it does not commit, push or
  call `gh` itself.
- **`ship` skill.** Loads `describe` in step 5 (squash message) and
  step 6 (PR text, merge message). Step 6 shows all messages in the
  plan. On a local merge, the plan also lists the open points (risks,
  untested paths, deferred findings) before the confirmation, since
  no PR shows them. Step 7 uses `git merge --no-ff -F <file>` for a
  local merge.
  Step 8 uses `gh pr merge --merge --subject <title> --body-file <file>`
  for `merge commit`; `--rebase` takes no message.

### Precedence

1. A message format stated in the project's `CLAUDE.md`.
2. Otherwise `.github/pull_request_template.md` (or the same file in the
   repository root or `docs/`) for the PR body: its sections are filled,
   the language rules below still apply.
3. Otherwise the devflow format below.

The subject follows the detected commit convention in every case.

### Title

Imperative mood; completes "If applied, this commit will …". At most 50
characters, 72 at most in any case. Names what changes, specifically
("Fix bug" is not a title). The reason goes in the body.

### PR body

Sections in this order. Summary, Why, Approach, Impact and Verification
are always present; Review focus and Links only when they have content.

| Section | Reader | Answers | Does not belong here | Taken from |
|---|---|---|---|---|
| Summary (1–2 sentences) | anyone skimming | What does this do? | details, file lists | spec Purpose |
| Why | reviewer, later maintainer | What was wrong or missing? | how it was built | spec Purpose, bug report |
| Approach | reviewer, later maintainer | Why this design, what was ruled out, which limits? | a walk through the files, ADR text | spec Design, ADRs |
| Impact | users, operators, release notes | What changes outside the code: behaviour, interface, config, migration, breaking changes? | internal details; "None" when nothing changes | README and user-docs changes |
| Verification | reviewer, QA | How is it shown to work, how is it reproduced? | raw logs, anything not run in this session, checks CI runs on the PR | checks CI does not run, manual checks run |
| Review focus | reviewer now | Where to look hard, which feedback is wanted, what is open? | anything history needs, fixed findings | deferred findings, risks, untested paths |
| Links | tooling, maintainer | Where is the full context? | prose that repeats the links | spec, ADRs, `Fixes #N` |

Only Summary may repeat content of another section. Length follows the
change: a one-line fix gets one line per section. The attribution lines
the harness asks for come last.

### Diagrams

A Mermaid diagram goes in the PR body only when the change alters a
flow, a state machine or the component structure and the prose would
need more than one paragraph: a sequence diagram for changed
interactions, a state diagram for states, a flowchart for structure or
flow. At most about 12 nodes. The text must be complete without it,
because email, `gh pr view` and `git log` show the source. Never in a
commit message.

### Landing commit message

- Subject: the PR title, plus ` (#N)` when the change went through a PR.
- Squash commit (the only record): Why, Approach and Impact (if not
  "None") as plain paragraphs, without headings.
- Merge commit (the branch commits carry the detail): Summary and Why.
- Rebase or fast-forward: no message is written.
- Trailers last, one block: `Fixes #N` if an issue is linked,
  `Refs: <spec path>` if there is a spec, then the attribution lines.
- Body wrapped at 72 columns, readable without the links.
- Never in it: Verification, Review focus, diagrams, checklists, review
  notes.

### Language

Plain language with a subset of ASD-STE100
([ADR 0014](../decisions/0014-plain-language-subset-for-messages.md)):

- At most 25 words per sentence; one topic per sentence and paragraph.
- Active voice, present tense; the problem is described as it is, not
  as "Currently …".
- One term per concept; abbreviations spelled out on first use; a noun
  instead of a pronoun where the pronoun could be ambiguous.
- No idioms, no filler ("simply", "please note"), no inflated words
  ("robust", "comprehensive", "seamless").
- No claim without a command run in this session that shows it.

The structure decision is [ADR 0013](../decisions/0013-structured-pr-and-merge-messages.md).

## Error handling

- No spec: Why and Approach come from the commit messages and the
  conversation. If the reason for the change is not known, `describe`
  asks; it does not invent one.
- No PR yet (local merge, or the squash before the PR): no ` (#N)`.
- No checks run in this session: Verification says so. `ship` does not
  integrate in that case anyway.
- A PR template whose sections do not match the devflow ones: the
  template wins; content without a matching section is left out, not
  forced in.
- A diagram that would need more than about 12 nodes: no diagram;
  the prose carries it.
- `gh pr merge` rejects `--subject` or `--body-file` (old `gh`): report
  the error and stop, per ship step 7; do not fall back to the default
  message silently.

## Testing

Automated: `tests/run.sh` lists `describe` (frontmatter, line cap,
references resolve).

Headless smoke tests (`claude --plugin-dir … -p`) in scratch repos:

1. Branch with a spec and a small change, `/devflow:describe`: all
   always-present sections there, title at most 72 characters, Approach
   does not list files, Impact is "None" or names a real change, no
   diagram.
2. Branch whose change alters a flow between components: a Mermaid
   diagram of at most about 12 nodes; the prose is complete without it.
3. `ship` with `keep`, `merge commit`, `local merge`: `git log -1` on
   the default branch shows the devflow merge message (Summary, Why,
   trailers), no Verification, no Review focus; the plan listed the
   open points and no PR text was written.
4. `ship` with `squash`: the squashed commit has Why, Approach and
   trailers as paragraphs without headings.
5. Repository with `.github/pull_request_template.md`: the PR body uses
   the template's sections.

Manual: ship this feature as a PR and check the description on GitHub,
including a rendered diagram if there is one, and the merge commit
message `gh pr merge` writes on the later run.

## Deviations

- Diagrams: `describe` uses concrete triggers (a new or removed
  component, a new call path, a new or changed state) instead of "the
  prose would need more than one paragraph". A smoke run with the
  vague wording drew no diagram for a new cache module.
- A merge commit for a PR is written on the later run (ship step 8):
  `describe` runs again with the PR number and the PR body, and the
  plan shows the message before the merge. On the first run the plan
  shows only the PR text for a PR target.
- `describe` writes a commit message as one file (subject, blank line,
  body); ship passes the first line as `--subject` and the rest as
  `--body-file`. The title is written once and reused by every variant.
- Exception: the merge commit created when ship step 3 merges the
  default branch into the branch keeps git's default message; it is a
  sync merge, not the commit that lands.
- Known limit: changing the squash message at the plan needs a
  rejected plan, which resets the branch.
- After shipping (PR #5), the user decided that a PR's merge commit
  takes its message from the PR through the forge (GitHub, Zuul or
  other), and `ship` drafts merge messages for local merges only
  ([ADR 0015](../decisions/0015-pr-merge-message-from-the-forge.md)).
  The step 8 rerun of `describe` and `gh pr merge --subject/--body-file`
  were removed; PR #5 was merged on GitHub with its description.

## Tasks

- [x] 1. Write `skills/describe/SKILL.md` per Design (precedence, title,
  PR body table, diagrams, landing message, language, error handling),
  at most 100 lines; add `describe` to `tests/run.sh`. *Done when*
  `tests/run.sh` passes and smoke tests 1, 2 and 5 pass, *shown by*
  their output.
- [x] 2. Change `skills/ship/SKILL.md`: Messages points to `describe`;
  steps 5–8 use it and pass the messages explicitly; still at most 100
  lines. *Done when* `tests/run.sh` passes and smoke tests 3 and 4
  pass, *shown by* `git log` in the scratch repos.
- [x] 3. Update README (skill table, Shipping policy section) and
  `architecture.md` (components, describe at its cap if so). Add the
  backlog item for updating an open PR's description. *Done when*
  `devflow:doc-checker` finds nothing stale, *shown by* its report.
- [x] 4. Ship this feature as a PR and merge it on a later run. *Done
  when* the PR body and the merge commit follow Design, *shown by*
  `gh pr view` and `git log -1` on the default branch.
