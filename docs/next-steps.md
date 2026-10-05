# Next steps

Forward-looking only. Remove an item when it is done; move its lessons
to `docs/architecture.md` or an ADR.

## Next

1. Install the plugin through the local marketplace and disable
   superpowers (see README, Install).
2. Run `/devflow:init` on one existing project to exercise the adopt
   path (backlog: "Try `init` on the existing projects").
3. Use the plugin on a real feature and collect what needs tuning in the
   backlog.
4. Run `/devflow:audit` on a real project to exercise the reviewer
   dispatch (backlog: "`audit` dispatch path is untested").

## Watch out for

- With superpowers still enabled, both plugins inject a workflow at
  session start and superpowers' wording wins.
- Skills cannot read files from the plugin directory; keep them
  self-contained.
