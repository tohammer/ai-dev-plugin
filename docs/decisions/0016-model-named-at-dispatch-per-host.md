# 0016 — Model named at dispatch, in the host's spelling

Date: 2026-10-28
Status: accepted

## Context

ADR 0003 gave each agent a default model in its frontmatter (`haiku`,
`sonnet`) and named `opus` for complex tasks. devflow also runs on
GitHub Copilot. Both hosts offer the same models under different
names: Claude Code accepts `sonnet` and `claude-sonnet-5-5`, Copilot
only `claude-sonnet-5.5`. Copilot rejected `model: sonnet` and listed
its models. No single name works on both hosts.

## Decision

Agent files set no model. Every dispatch passes one, named at the call
site in the host's spelling: Claude Code `haiku`, `sonnet`, `opus` (its
dispatch tool takes only these aliases); Copilot `claude-haiku-5.5`,
`claude-sonnet-5.5`, `claude-opus-5.5`. `core.md` holds the spelling
map; skills name the model (haiku, sonnet, opus) and refer to it.
Supersedes ADR 0003; its tiers (haiku mechanical, sonnet ordinary,
opus complex), the rule "cheapest model that can do the task well" and
the escalation after two failures stay.

## Consequences

- Agents dispatch on both hosts with the intended model.
- A dispatch without a model would run on the session's model; the
  instructions never leave it out.
- A new model version or another host means updating the spelling map
  in `core.md` and the README.
