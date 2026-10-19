---
name: wrapup
description: Bring the documentation in line with a finished change - README, architecture, ADRs, backlog, next-steps and spec status. Use when a feature or fix is complete and reviewed, before the final commit or merge.
---

# Wrap up

## Steps

1. **Check.** Dispatch `devflow:doc-checker` with the diff range and the
   spec path. For a small change, check the docs yourself.
2. **Update.** Apply what is needed:
   - `README.md` and `docs/user/`: install steps, commands, flags,
     features. For a new section or a restructuring, load
     `devflow:userdocs` and follow it; a one-line update is done
     directly.
   - `docs/architecture.md`: changed components and connections, and
     lessons worth keeping.
   - `docs/decisions/`: an ADR for each non-obvious decision that has
     none yet, in the format of the existing ones (Context / Decision /
     Consequences, next free number).
   - The spec: all tasks ticked, `Status: implemented`. If the result
     deviates from the spec, note the deviation in the spec.
   - `docs/backlog.md`: delete finished items; add what was deferred.
   - `docs/next-steps.md`: delete what is done; write what comes next
     and what to watch out for. Nothing about completed work stays.
3. **Split if grown.** `docs/architecture.md` past about 300 lines
   becomes `docs/architecture/<area>.md` with the original as index.
   `docs/backlog.md` past about 150 lines, or with clearly distinct
   areas, becomes `docs/backlog/<area>.md`.
4. **Verify.** Run the checks from `## Checks` one last time
   (`devflow:verifier`). Without that section, determine the commands,
   tell the user which were used and offer to record them with
   `/devflow:init`. A stale or duplicate
   section: propose the fix to the user.
5. **Report.** Tell the user what changed in the docs, the state of the
   checks, and what is next. Commit only if the user has asked for it;
   docs go in the same commit as the code they describe.
