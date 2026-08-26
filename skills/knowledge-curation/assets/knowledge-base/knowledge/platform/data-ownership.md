---
id: data-ownership
status: draft
updated: "2026-08-25 aamer"
---

# Table ownership registry

> **Sole authority on who writes what.** No other file may restate this — each
> domain's `tech/data/data-owned.md` and `tech/data/data-consumed.md` point here.
> For a table's columns/types/descriptions, see `platform/data-schema/<table>.md`
> instead — this registry is ownership only, not schema.
>
> **Append-only.** You will not know all readers until every domain is curated, so
> new documents add rows and columns of detail rather than replacing them.
>
> **"Known readers" means known, not all.** Never infer that an unlisted domain is
> not reading a table (`ba-principles.md` rule 4).

Last updated: 2026-08-25

| table | owner (writer) | known readers | PII | source | confidence |
|-------|----------------|---------------|-----|--------|-----------|
| _none yet_ | | | | | |

**Owner** = the single domain permitted to INSERT / UPDATE / DELETE, per the
platform's write-ownership constraint, if one is curated (see `platform/constraints/`).

**`unknown` owner is a valid and important entry.** A table we know exists but whose
owner we cannot establish must appear here, not be omitted.

## Conflicts

<Any case where two sources disagree on ownership, or a documented write appears to
come from a non-owner. Do not resolve silently — record and raise an OQ.>

| table | conflict | OQ |
|-------|----------|----|

## Verification status

Mechanical verification (grep repos for writes, diff against this table) is
**not available** without code access. Entries are `documented`, `stated`, or
`inferred` until confirmed against implementation.
