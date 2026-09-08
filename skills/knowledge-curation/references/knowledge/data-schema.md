---
id: "schema-{table}"    # plain descriptive slug — tables are referenced by name,
status: draft            # not by ID
basis: documented
source: "{where it came from}"
updated: "{YYYY-MM-DD} {your name}"
related: []              # IDs only
---

# `<table_name>` — schema

> `platform/data-schema/<table>.md` — **platform-level, one file per table, not
> domain-level.** A table's structure isn't scoped to whichever domain happens to use
> it, so it doesn't belong under any one domain's `tech/` — see
> `knowledge-boundary.md`. (Who may write a table is a separate question, governed by
> the platform's write-ownership rule if it has one.)
>
> Owner: see `platform/data-ownership.md` — not restated here.

| column | type | nullable | description | valid values |
|--------|------|----------|-------------|--------------|
|        |      |          |             |              |

<Mark anything not documented in source explicitly: `_Not documented in source._`
rather than leaving a cell blank or inventing meaning.>
