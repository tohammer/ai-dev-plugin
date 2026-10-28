# Next steps

Forward-looking only. Remove an item when it is done; move its lessons
to `docs/architecture.md` or an ADR.

## Next

Goal: 1.0.0, a promise that what projects depend on does not break
without a major version. Items in rough order:

1. Run devflow on Copilot after updating to 0.2.0: model names
   `claude-haiku-5.5` and `claude-opus-5.5`, and whether the
   SessionStart hook brings `core.md` into the session. Then check the
   other Claude Code specifics (backlog: "Claude-only assumptions in
   plugin text").
2. Use every skill on real projects, not only in smoke tests, and
   collect findings in the backlog. Include the untested `ship` paths
   (backlog: "`ship` paths are untested").
3. Fix or deliberately accept the agent behaviour gaps (backlog:
   "Orchestrator skips the cheap agents on small changes", "`wrapup`
   left next-steps without a real next item").
4. Write down what the version covers: skill and agent names, docs
   layout, the formats of `## Checks` and `## Shipping`, the spec
   template. A README section or an ADR; after 1.0 a change to any of
   them needs a major version.
5. Add `CHANGELOG.md` covering 0.1.0 to 1.0.0, then tag `v1.0.0`.

Not needed for 1.0, can come in 1.x: `refactor` and dependency skills,
the spec diff view, the migration section in the spec template,
updating open PR descriptions.

## Watch out for

- Skills cannot read files from the plugin directory; keep them
  self-contained.
