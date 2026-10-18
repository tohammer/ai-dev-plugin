---
name: userdocs
description: Write or rework user-facing docs (README, install, usage, CLI and configuration reference) to be concise and accurate. Use when asked to write, rework, restructure or shorten a README or user docs, or when init or wrapup write user doc sections. Not for architecture, ADRs or specs.
---

# User docs

Arguments, optional: `readme`, a path under `docs/user/`, or a topic
(e.g. `configuration`); without, the README and all of `docs/user/`.
Write in the docs' existing language. Every question to the user gets a
brief explanation, each option's pros and cons, and a recommendation
with the reason.

## Steps

1. **Facts.** From the code, not the existing docs: install method and
   requirements, commands and `--help` output, flags, config file
   locations and keys, environment variables, defaults, precedence. For
   a broad search dispatch `devflow:explorer` briefed with this list.
2. **Readers.** Name the audience and the three to five tasks they come
   for. Ask the user when code and docs do not show it.
3. **Sort.** Classify existing content as how-to, reference,
   explanation or other. Design explanation moves to
   `docs/architecture.md` or an ADR, or is deleted. Delete marketing,
   FAQ dumps, changelogs (to `CHANGELOG.md` if kept) and future plans.
4. **Place.** A long, well-structured README is fine, but at any length
   its first screen says what it is, whether it runs on the reader's
   platform and how to try it. Past about 500 lines check every section
   against the reasons below, and tell the user why what stays is kept.
   An existing user-doc site wins over `docs/user/`. Content leaves the
   README only when it is:
   - for another reader (building beyond one command, releasing, testing,
     design) → `CONTRIBUTING.md`, `docs/` developer docs or Development;
   - a feature area with its own tasks, options and limits, longer than
     the rest → `docs/user/<topic>.md`, leaving a few lines and the link;
   - for users who get a binary and never see the repository → one guide,
     `docs/user/guide.md`, shipped with the release; the README says so
     in its first lines and serves people building the project.
5. **Write.** Follow the structure, rules and entry format below. Then
   cut every sentence the reader does not need for a task.
6. **Verify.** Run every command in a scratch directory and compare its
   output with the docs; do not run commands that install system-wide,
   need credentials or change external state, and list them as not run.
   Compare options with step 1's facts both ways. Check relative links.
7. **Hand over.** Show the user what moved, what was cut, what was not
   run and why, and open questions. Commit only if asked.

## README structure

In this order; leave out what does not apply:

1. Title and one sentence: what it does, for whom.
2. Optional: a short paragraph on the problem or typical uses; key
   features, one line each; one image or recording if the tool is visual.
3. Status: maturity in one or two lines; a support table (platform or
   variant | supported, tested, untested), not a log of manual checks.
4. Quick start: requirements, shortest install, smallest example, output.
5. Installation: one subsection per method or package manager, untested
   ones marked; how to check it worked.
6. Usage: common tasks as short how-tos; a table of commands or keys
   (Key | Command | Action), grouped by purpose.
7. Configuration: where config is read from, precedence (defaults <
   file < environment < flags), a minimal example, the options tables or
   a link to `docs/user/configuration.md`.
8. Limitations: what it does not do, each with workaround or alternative.
9. Troubleshooting: known errors and their fix.
10. Development: build and test commands or a link to `CONTRIBUTING.md`;
    the only place for design, ADR, spec and test references.
11. License, then credits or disclaimers: last.

## Writing rules

- Keep how-to, reference and explanation apart; link between them.
- Any user doc over about eight sections read where no heading outline
  is shown (a release file, a package registry page): contents list
  after the intro.
- How-to: title names the task; prerequisites first; numbered steps,
  one imperative action each; condition before instruction ("If you use
  X, run …"); optional steps start with "Optional:"; one method, the
  shortest; no background, no obvious steps.
- Reference: neutral and complete, one entry format, ordered like the
  product (or alphabetically), no instructions.
- Commands copy-pastable in code blocks (no prompt characters),
  placeholders in `<angle-brackets>` explained once, output where it helps.
- "You", active voice, present tense, short sentences; sentence-case
  headings; code font for anything typed; descriptive link text.
- Never: "simply", "just", "easy", "please", "the following command",
  "above"/"below", marketing, announced future features.
- For users, not maintainers: outside Development no design rationale,
  ADR, spec, backlog or test-file references, no developer warnings
  ("don't reintroduce …").
- Document what the user can observe and act on, not how it is built.
  Spell out edge cases in full only for operations that change or
  delete data; others go to Limitations, one line each.
- Show results as text: output and rendered text UIs (buffer, TUI
  screen) in code blocks, not images; return values inline (`; => "hi"`).
- Performance claims state the conditions (machine, data size, cache)
  and link to how they were measured.

## Visuals

- Only for what text cannot show: GUI layout, colours and themes, an
  interaction over time; never commands, output, configuration or code.
- At most one image or short recording near the top; others sit in the
  section they illustrate.
- Screenshots: cropped to the relevant part; one window size, theme and
  platform across the docs; no personal data (opaque overlay, not blur).
- Recordings: one task, under about 30 seconds, no sound needed,
  readable font. Terminal tools: record from a committed VHS tape or
  asciinema cast. Check the host renders the format inline (GitHub
  READMEs: GIF, PNG, SVG, WebP from the repository).
- Alt text says what it shows (at most about 155 characters, not
  "Screenshot of"); the text around it carries the information too.
- Files in `docs/user/images/`, descriptive names, small (a recording of
  a few MB at most), made by a committed script or tape where possible;
  otherwise the docs note the version shown.
- Propose visuals; make them if you can run the tool (VHS, asciinema,
  scriptable GUI capture), else list them. Never commit a placeholder.

## Reference entry format

Options, flags and environment variables: one table per area (Option |
Default | Description, plus Type or Allowed values where the default
does not make them obvious); a column per variant where one setting
maps onto several backends. An entry that does not fit one row gets its
own section; leave out lines that do not apply, edge-case notes follow:

```markdown
### `<name>`

<One sentence: what it controls.>

- Type: <type>; allowed: <values or range>
- Default: <value, or "none (required)">
- Also: `--<flag>`, `<ENV_VAR>`
- Example: `<name> = <value>`
- Since <version> | Deprecated in <version>, use `<other>`
```

## Failures

- Code cannot run (no toolchain, needs a service): verify by reading;
  list every command not run in the hand-over.
- A documented command fails: wrong docs, fix them; wrong code, report a
  bug and document actual behaviour until the user decides otherwise.
- Docs and code disagree on an option, intent unclear: ask; do not pick.
- Existing user-doc site: write there in its structure, with these rules.
- Audience or tasks unclear and no answer: write for a developer
  installing and running the tool for the first time, and say so.
