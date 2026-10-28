---
name: ship
description: Integrate a finished branch - final checks, commit tidying, PR or local merge per the project's shipping policy, branch cleanup. Use when a feature or fix is reviewed and wrapped up, or when asked to merge, ship, finish or open a PR for a branch. Not for releases or version tags.
---

# Ship

Pushes, force pushes, merges into the default branch and branch
deletions happen only as listed in a plan the user confirmed. Integrate
only with checks green in this session. Questions to the user: brief
explanation, pros and cons per option, recommendation with reason.

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

## Messages

Load `devflow:describe` (with check results and review findings) for
the PR text, the squash message and a local merge message (a PR's
merge commit takes its message from the PR via the forge). Other commits
(policy, uncommitted changes, regroup) follow CLAUDE.md's convention,
else the last ~20 commits on the default branch; regroup bodies say
what changed and why. Harness attribution lines come last.

## Steps

1. **State.** Current and default branch, upstream, working tree.
   Note the branch tip SHA; a rejected plan resets the branch to it.
   - On the default branch: nothing to ship; say so, stop.
   - Uncommitted changes: show them, propose a commit; declined: stop.
   - Branch spec not `Status: implemented`: offer `/devflow:wrapup`.
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
5. **Tidy.** Apply `history`; the squash message comes from describe.
   Then `git diff <pre-tidy SHA>` must be empty: the checked tree lands.
6. **Plan.** Show the commits that land (a squash message in full),
   merge method, target, every push, branches to delete. PR target:
   the PR title and body. Local merge: the merge message, and the open
   points (risks, untested paths, deferred findings) no PR shows. Pushed
   commits rewritten in step 3 or 5 need a force push only if pushed
   again (PR target): `--force-with-lease=<branch>:<upstream SHA>`. One
   confirmation covers the listed steps only; the user may keep the
   branch or switch target (rerun describe).
7. **Integrate.**
   - Pull request: push, `gh pr create --title <title> --body-file
     <file>`, report the URL, stop. Without `gh`: push, give the text.
   - Local merge per `merge`; `merge commit`: `git merge --no-ff -F
     <message file>`. Push the default branch if it has an upstream.
   - Keep: report the branch state, stop.
   No remote: only local merge or keep. Push or `gh` fails, or the
   lease is rejected: report the error and the state left, skip
   cleanup, stop; never retry with `--force`.
8. **Open PR** (later run). Local commits the PR head lacks: stop,
   offer to push. Report `gh pr view`: checks, reviews, mergeable;
   green means its required checks passed, else run `## Checks`.
   `fast-forward`: the PR head must contain the base tip, else stop.
   Plan merge and cleanup, one confirmation: `gh pr merge --rebase`
   for `fast-forward` and `rebase`, `--merge` for `merge commit`; the
   forge writes the message from the PR. Merged elsewhere: plan
   cleanup only.
9. **Clean up** after a merge. Verify: `git merge-base --is-ancestor
   <branch> <default>` (local merge) or PR state `MERGED`. Switch to
   the default branch, pull, delete the remote branch if `git ls-remote
   --heads` lists it (else `git fetch --prune`), `git branch -d`. After
   a GitHub rebase or squash merge `-d` refuses: ask before `-D` if the
   PR is merged and its head has all local commits, never otherwise.
   After a local merge `devflow:verifier` checks the default branch.
10. **Report.** What landed where (commits, PR URL), check results, what
    was deleted, what was not done and why.
