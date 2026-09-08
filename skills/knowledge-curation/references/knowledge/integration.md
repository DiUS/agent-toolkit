---
id: "IN-{FROM}-{TO}-{NNN}"
status: draft              # draft | verified
basis: documented          # documented | stated | inferred | assumed
source: "{where it came from}"
updated: "{YYYY-MM-DD} {your name}"
related: []                # IDs only
from_domain: {domain}
to_domain: {domain}
mechanism: unknown         # shared-table | event | api | batch | unknown
---

# <Title>

> Filed under the **producing** domain's `tech/integrations/` — domain-level, not
> per-feature, since one integration commonly backs more than one feature. The
> consuming domain references this ID rather than describing the integration a
> second time. This is technical detail we don't have code access to verify yet
> (see `knowledge-boundary.md`) — curate what the source says, label `basis`
> honestly, and expect it to need re-verification once repos land.

## What is exchanged

<What data/concept moves between domains, in business terms — not just the wire format.>

## Mechanism

<Shared table read, event, synchronous API, batch file. On this platform,
shared-table read is the default and often implicit — record it explicitly, because
an undocumented read coupling is invisible until a schema change breaks it.>

## Data

| table | written by | read by | columns relied on |
|-------|-----------|---------|-------------------|

<Column names only — types and descriptions belong in
`platform/data-schema/<table>.md`, not here. Who may write which table is governed by
the platform's write-ownership constraint in `platform/constraints/`, if one is
curated.>

## Errors

<Every way this integration/service can fail, in one place — not just whatever
appears inline in a workflow's `alt`/`else` branches. Add a `service` column if
this file covers more than one operation. Workflows still show faults inline for
flow context; this is the canonical catalog.>

| fault | trigger condition | rule |
|-------|--------------------|------|
|       |                    |      |

## Coupling risk

<What breaks in the consuming domain if the producer changes shape. This is the
section that makes read-coupling visible — see the relevant platform constraint, if
one is curated.>

## Confirmed or inferred?

<If this integration was deduced rather than documented, say so plainly and raise
an OQ to confirm it. Inferred integrations are a common source of confident error.>
