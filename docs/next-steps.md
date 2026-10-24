# Next steps

Forward-looking only. Remove an item when it is done; move its lessons
to `docs/architecture.md` or an ADR.

## Next

1. Use the plugin on a real feature and collect what needs tuning in the
   backlog.
2. Run `/devflow:audit` on a real project to exercise the reviewer
   dispatch (backlog: "`audit` dispatch path is untested").
3. Run `/devflow:userdocs` on a long README (emacs-quarry,
   ai-dev-environment) to exercise the move to `docs/user/`
   (backlog: "`userdocs` move paths are untested").
4. Run `/devflow:init` on the projects set up earlier to add their
   `## Checks` section.

## Watch out for

- Skills cannot read files from the plugin directory; keep them
  self-contained.
