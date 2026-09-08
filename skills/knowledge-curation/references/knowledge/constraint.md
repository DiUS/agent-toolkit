---
id: "CN-{NNN}"              # or CN-{DOMAIN}-{NNN} at domain tier — the presence or
status: draft                # absence of a domain segment IS the scope signal,
basis: documented            # same pattern as BR-/WF-
source: "{where it came from}"
updated: "{YYYY-MM-DD} {your name}"
related: []                 # IDs only
---

# <Title>

> **Placement test:** platform tier (`platform/constraints/`) — true even if any
> single domain were deleted. Domain tier (`domains/<domain>/constraints/`) — true
> even if any single feature in this domain were deleted. If it's a single testable
> proposition scoped to one feature, it's a rule, not a constraint — people promote
> rules upward because they feel important; importance is not scope.

## Constraint

<State it as an invariant — present tense, absolute — and why it exists, in the
same paragraph or two.>

## Implications for agent reasoning

<The important section. Spell out what the agent must therefore do or refuse to do.
This is what turns a stated constraint into changed behaviour.>

- <e.g. "Never propose that a domain write to a table it does not own. If a
  requirement appears to need this, surface it as a conflict, not a design.">

## Derived questions

<Optional — omit this section entirely if none apply. Questions the agent should
ask whenever a request touches this constraint. Deriving questions from constraints
beats a hardcoded question bank — curate a new constraint and the questioning
improves without editing a skill.>

- <e.g. "Which domain owns the write path for this data?">
