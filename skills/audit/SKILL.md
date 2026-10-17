---
name: audit
description: Audit a whole existing project - code, security, tests, build and CI, dependencies, docs, configuration, repository hygiene - into a dated report and backlog items. Use when asked to review or audit the whole project, codebase or repo, or after adopting an existing project. Not for reviewing a diff, branch or change; use devflow:review for that.
---

# Audit

The audit changes no code, only docs; it may run on the default branch.
Each aspect below appears in the report.

## Aspects

1. **Code.** Correctness, error handling, structure against
   `docs/architecture.md`, dead or duplicated code, needless complexity,
   obvious performance problems.
2. **Security.** Secrets in the repository or its history, input
   handling, authentication and authorisation, unsafe calls, file and
   network permissions.
3. **Tests.** Pass or fail, coverage of critical paths, skipped,
   disabled or flaky tests, tests that assert nothing useful.
4. **Build and CI.** Builds from the README's instructions; CI exists,
   runs tests and linters, matches local checks; release or deploy.
5. **Dependencies.** Outdated or unmaintained packages, known
   vulnerabilities (run the ecosystem's audit tool if installed),
   lockfile present and used, unused dependencies, licences.
6. **Documentation.** README and `docs/user/` install and usage match reality;
   architecture, ADRs, specs (status, ticked tasks), backlog and
   next-steps match the code; devflow layout present.
7. **Configuration and operations.** Configuration handling, logging,
   error reporting, deployment scripts, where present.
8. **Repository hygiene.** `.gitignore`, committed build artefacts or
   large files, licence file, formatter and linter config.

## Steps

1. **Scope.** Whole project unless arguments name paths or aspects.
   Record commit (`git rev-parse HEAD`) and scope. Without the devflow
   layout, offer `/devflow:init`; if declined, step 7 lists the proposed
   items in the report instead of writing them to a backlog.
2. **Baseline.** `devflow:verifier` runs build, tests and linters.
   `devflow:explorer` inventories code areas (from `docs/architecture.md`
   if current, else the tree), CI files, dependency manifests, tests,
   configuration and deployment files.
3. **Dispatch.** `devflow:reviewer` in parallel, briefed with the aspect,
   area and files, baseline results and the aspect's checklist entry:
   - Code: one reviewer per area; `model: "opus"` for security- or
     correctness-critical areas. Security: one, on `model: "opus"`.
   - Other aspects: one reviewer each, default model; on a small
     project aspects 4-8 may share one.
   - Over about 15 dispatches: propose what to cover first, and why.
4. **Verify.** Check every finding against the code and drop those that
   do not hold. A finding is a lead, not a fact.
5. **Rate.** Severity per confirmed finding:
   - critical: data loss, security hole, project does not build or run;
   - high: wrong behaviour in a main path, missing tests or CI for core
     functionality, docs that make install or use fail;
   - medium: edge-case defects, maintainability problems that slow
     changes, stale docs;
   - low: cosmetic or minor hygiene.
6. **Report.** Write `docs/audits/YYYY-MM-DD.md` (create the directory;
   if the date exists, append `-2`, `-3`) in this format:

   ```markdown
   # Audit YYYY-MM-DD
   Commit: <sha>
   Scope: whole project | <paths, aspects>
   ## Summary
   Overall state; table of finding counts by aspect and severity.
   ## Checks
   Commands run and results.
   ## Findings
   ### <Aspect>
   - **A-<n>** (<severity>) `path:line` - what is wrong. Evidence or
     failing scenario. Verified by: running | reading. Backlog: <item> | no.
   ## Not covered
   What was not examined, and why.
   ```

   An aspect without findings says "No findings", "Not applicable" or
   "Not covered" (the latter two with why). The report is a snapshot;
   afterwards edit it only to record backlog links. Never quote a
   secret's value; give its location and kind.
7. **Backlog.** Group related findings into actionable items. Propose
   those of severity medium and above, each with pros, cons and a
   reasoned recommendation; the user confirms, removes or adds. Write
   the confirmed items to the backlog with origin `audit YYYY-MM-DD,
   findings A-n`, the reason and when to revisit. Mark in the report
   which findings went where. With none confirmed, the report stands.
8. **Hand over.** Summarise state per aspect, counts by severity, what
   went to the backlog and what was not covered. Commit only if asked.

## Failures

- Build, tests or linters cannot run: a finding under Build and CI or
  Tests; aspects that depended on them say so.
- No CI, no tests, no docs: a finding, not a skipped aspect.
- A reviewer fails or returns nothing usable: re-dispatch once, on a
  stronger model if the first was weaker; else list it as not covered.
- Dependency audit tool missing: assess from manifests, note the gap
  under "Not covered"; never install tools without asking.
