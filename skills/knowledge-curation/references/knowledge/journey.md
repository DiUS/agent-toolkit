---
id: "JR-{NNN}"
status: draft              # draft | verified
basis: documented          # documented | stated | inferred | assumed
source: "{where it came from}"
updated: "{YYYY-MM-DD} {your name}"
related: []                # IDs only
---

# <Title>

> **Journeys are the BA entry point.** A requester can usually name the journey
> their request affects even when they cannot name the domains. This file is what
> turns that answer into a list of domains — and therefore into a coverage
> assessment.

## Outcome

<What the customer or user ends up with.>

## Domains involved

| # | domain | responsibility in this journey | coverage |
|---|--------|-------------------------------|----------|
| 1 |        |                               | curated / partial / name-only / unknown |

<Copy coverage from `platform/coverage.md`. Listing an unknown domain here is the
point — it is how the agent knows to flag a blind spot rather than skip it.>

## Stages

| # | stage | domain | workflow | handoff to next |
|---|-------|--------|----------|-----------------|
| 1 |       |        | `WF-...` |                 |

## Cross-domain handoffs

<For each handoff: what is passed, by what mechanism (event / API / shared table),
and which domain owns the write. Handoffs are where write-ownership matters (e.g. on
a shared database) — see the relevant platform constraint, if one is curated.>

| from | to | mechanism | table written | writer owns it? |
|------|-----|-----------|---------------|-----------------|

## Known gaps in this journey

<Stages we know exist but have not curated. State them; do not omit them.>
