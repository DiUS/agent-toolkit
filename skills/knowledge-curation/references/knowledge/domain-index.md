---
id: {domain-key}
status: draft              # draft | verified
coverage: name-only        # curated | partial | name-only | unknown
basis: documented          # documented | stated | inferred | assumed
source: "{where it came from}"
updated: "{YYYY-MM-DD} {your name}"
related: []                # IDs only
---

# <Domain name>

> **Written to `domains/<domain>/index.md`** — this template is named
> `domain-index.md` only to stay distinct among its siblings in this shared
> template folder; the curated file itself is always `index.md`, never
> `domain-index.md`.
>
> **This file is a pointer, not a summary.** It is read on nearly every task, so it
> must stay cheap. The moment it starts summarising its children you have created a
> second source of truth that goes stale silently — and made every task cost more.
>
> **Every domain gets this file, including undocumented ones.** An empty folder
> tree reads as coverage. A stated status reads as absence. Only the second one
> makes the agent ask a question.

## Purpose

<A short narrative — a paragraph, not a table cell. Why this domain exists and
what business value it delivers, not just what it's accountable for.>

## Boundaries

- **In scope:**
- **Out of scope:** <explicitly, including things a reader might reasonably assume>

## Curation status

| feature | purpose | scope | status | source |
|---------|---------|-------|--------|--------|
|         | <one line: why this feature exists> | <one line: what it covers, and what it explicitly doesn't> | | |

**Not yet curated:** <list what we know exists but have not processed.>

<Purpose and scope live here, one line per feature — the domain-tier orientation.
Each feature folder additionally carries its own `index.md` (the `feature-index.md`
template) as the feature-tier pointer to its `rules/`, `workflows/`, `questions/` and
dependencies. Keep both as pointers — never restate a rule's text.>

## Assumptions

<Per feature, the facts in this domain that rest on `basis: assumed` — not every
assumption in the corpus, just the ones filed under this domain. This is a
dedicated list, not a table column, because an assumption usually needs a sentence
of "why it was necessary" to be useful, not just a flag.>

- **<feature>:** `BR-...` — <the assumption and what breaks if it's wrong>

## Data

- Owns (writes): see `tech/data/data-owned.md`
- Reads: see `tech/data/data-consumed.md`
- Authority for both: `platform/data-ownership.md`

## Contents

- Domain glossary → `glossary.md`
- Domain-wide constraints → `constraints/`
- Domain-scoped open questions → `questions/`
- Per feature (`features/<feature>/`): `rules/`, `workflows/`, `questions/`
- Technology layer (`tech/`, domain-level — not per-feature, since tables/APIs are
  often shared): `data/data-owned.md`, `data/data-consumed.md`, `integrations/`,
  `configurations/`, `ui/`
