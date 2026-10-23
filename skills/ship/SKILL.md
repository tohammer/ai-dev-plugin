---
name: ship
description: Integrate a finished branch - final checks, commit tidying, PR or local merge per the project's shipping policy, branch cleanup. Use when a feature or fix is reviewed and wrapped up, or when asked to merge, ship, finish or open a PR for a branch. Not for releases or version tags.
---

# Ship

Pushes, force pushes, merges into the default branch and branch
deletions happen only as listed in a plan the user confirmed. Integrate
only with checks green in this session. Every question to the user
carries a brief explanation, pros and cons per option and a
recommendation with the reason.

## Shipping policy

`## Shipping` in CLAUDE.md, or in the AGENTS.md it imports when
`## Checks` is there. Never two sections. One bullet per key
(`- history: squash`); extra keys are accepted.

- `history`: `squash` (one commit), `keep` (as is), `regroup` (when the
  branch has fixup or WIP commits: new commits by topic, user confirms
  the grouping; else keep).
- `merge`: `fast-forward` (only if the branch is on top of the default
  branch, else stop and offer the other two for this run), `rebase`
  (rebase onto the default branch, then fast-forward), `merge commit`
  (`--no-ff`).
- `target`: `pull request` or `local merge`. A default: say it, the
  user may override per run; keeping the branch is always offered.

Missing: ask the three questions one at a time. Recommend `squash` (one
commit per feature, docs with their code), `rebase` (linear history, no
stop when the default branch moved), `pull request` if the remote is
GitHub and `gh` works, else `local merge`. Write the section and commit
it on the branch as its own commit, kept out of the tidying. An unknown
value: ask for this run, propose the fix.

## Steps

1. **State.** Current and default branch, upstream, working tree.
   Note the branch tip SHA; a rejected plan resets the branch to it.
   - On the default branch: nothing to ship; say so, stop.
   - Uncommitted changes: show them, propose committing them; the
     user decides, and if they decline, stop.
   - Spec for the branch not `Status: implemented`: offer
     `/devflow:wrapup` first.
   - Open PR for the branch (`gh pr view`): step 2, then step 8.
2. **Policy.** Read `## Shipping`; if missing, ask and write it.
3. **Sync.** Fetch. Fast-forward the local default branch to its
   upstream; diverged: stop, ask. Branch upstream has commits the
   local branch lacks: stop, show them, ask. Note the upstream SHA.
   Branch not on top of the default branch: `rebase` rebases,
   `merge commit` merges the default branch in, `fast-forward` stops.
   Conflicts: stop, show the files, resolve only with the user.
4. **Checks.** `devflow:verifier` runs every command in `## Checks`.
   Without it: determine the commands, say which, offer
   `/devflow:init`. Failure stops the ship (offer `/devflow:debug`);
   a check that could not run is not green.
5. **Tidy.** Apply `history`. Afterwards `git diff <pre-tidy SHA>`
   must be empty, so the checked tree is the one that lands.
6. **Plan.** Show the commits that land, merge method, target, every
   push, PR title and description, branches to delete. Pushed commits
   rewritten in step 3 or 5 need a force push only if the branch is
   pushed again (PR target): `--force-with-lease=<branch>:<upstream
   SHA>`. Local merge: no force push. One confirmation covers the
   listed steps only; the user may switch target or keep the branch.
7. **Integrate.**
   - Pull request: push, `gh pr create` with title and description,
     report the URL, stop. Without `gh`: push, give them to paste.
   - Local merge: merge per `merge` into the default branch, push it
     if it has an upstream.
   - Keep: report the branch state, stop.
   No remote: only local merge or keep. Push or `gh` fails, or the
   lease is rejected: report the error and the state left, skip
   cleanup, stop; never retry with `--force`.
8. **Open PR** (later run). Local commits the PR head lacks: stop,
   offer to push. Report `gh pr view`: checks, reviews, mergeable;
   green means its required checks passed, else run `## Checks`.
   `fast-forward`: the PR head must contain the base tip, else stop.
   Plan the merge (`gh pr merge --rebase` for `fast-forward` and
   `rebase`, `--merge` for `merge commit`) and the cleanup; one
   confirmation. Merged elsewhere: plan the cleanup only.
9. **Clean up** after a merge. Verify first: `git merge-base
   --is-ancestor <branch> <default>` after a local merge, PR state
   `MERGED` after a PR. Switch to the default branch, pull, delete the
   remote branch, `git branch -d`. After a GitHub rebase or squash
   merge `-d` refuses; if the PR is merged and the PR head has all
   local commits, ask before `-D`. Never `-D` otherwise. After a local
   merge `devflow:verifier` runs the checks on the default branch.
10. **Report.** What landed where (commits, PR URL), check results, what
    was deleted, what was not done and why.

## Messages

- Commit: convention from CLAUDE.md if stated, else from the last ~20
  commits on the default branch. Squashed or regrouped: body on what
  changed and why, from the spec's Purpose and the replaced commits.
- PR: title as a commit subject. Body: Purpose (1-3 lines from the
  spec), Changes, Testing (checks, manual checks from the spec), Review
  (findings fixed, deferred with backlog items), links to spec and ADRs.
- Attribution lines the harness asks for come last in both.
