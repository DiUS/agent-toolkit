---
id: "{domain}-{feature}"          # plain descriptive slug — referenced by name, not cited by ID
status: draft                      # draft | verified
updated: "{YYYY-MM-DD} {your name}"
related: []                        # IDs only — e.g. journeys this feature appears in
---

# <Feature> — feature index

> **Every feature folder carries one**, written to `features/<feature>/index.md`, so
> feature folders stay uniform and every feature has a predictable entry point — the
> reader always knows there is an `index.md` to open first (see `structure.md`).
>
> **Pointer, not a summary.** Name what's here and what it depends on; **never restate
> a rule's text** — that lives in the rule file and would drift if copied here. The
> one-line scopes below are labels, not the rule. A feature with a single rule and no
> dependencies still gets an index — it is just very short.

## Purpose

<One or two sentences: what this feature does. Not a restatement of its rules.>

## Rules  (in `rules/`)

| topic | id base | one-line scope | file |
|-------|---------|----------------|------|
|       | `BR-{DOMAIN}-{TOPIC}` |  | `rules/<topic>.md` |

## Workflows  (in `workflows/`)

<Table of `WF-...` ids + one-line scope + file, or `_None in this feature._`>

## Open questions  (in `questions/`)

<Feature-scoped `OQ-...` ids with their one-line question, or `_None feature-scoped._`>

## Depends on  (load only if the task needs it)

- Domain glossary → `../../glossary.md`
- Tech referenced by these rules (from their `calls:`/`touches:` pointers): <list the
  specific `tech/` files, or "none">
- Journeys this feature appears in: `JR-...` (which stages)

## Seams  (where this feature hands off)

<Each handoff to/from another feature or domain, cited by ID. This is the
blast-radius list — what a change here might touch. Omit the section only if the
feature genuinely stands alone.>
