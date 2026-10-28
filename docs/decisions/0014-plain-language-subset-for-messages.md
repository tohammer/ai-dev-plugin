# 0014 — Plain language with an STE subset for PR and commit text

Date: 2026-10-28
Status: accepted

## Context

PR and commit text is read by reviewers and maintainers, many of them
not native English speakers. AI-written descriptions tend to be long,
repetitive and full of unverified claims. ASD-STE100 Simplified
Technical English limits sentence length, voice and vocabulary (about
900 approved words). Its dictionary does not fit text dominated by
identifiers and domain terms, its verb list conflicts with common
commit wording, compliance cannot be checked without a dedicated tool,
and ASD itself says it is not to be used alone. Alternatives: full STE;
no rules; plain-language rules with the checkable parts of STE.

## Decision

`describe` applies plain language with a subset of STE: at most 25
words per sentence, one topic per sentence and paragraph, active voice
and present tense, one term per concept, abbreviations spelled out on
first use, unambiguous pronouns, no idioms, filler or inflated words,
and no claim without a command run that shows it. The STE dictionary
is not used.

## Consequences

- Rules a reviewer can check by reading; close to Google's developer
  style guide for a global audience.
- Text is shorter and easier to translate, without the cost of a
  controlled vocabulary.
- The rules apply to PR and commit text only for now; extending them
  to specs and docs is a separate decision.
