---
id: "data-consumed-{domain}"
status: draft
basis: documented
source: "{where it came from}"
updated: "{YYYY-MM-DD} {your name}"
related: []
---

# <Domain> — consumed tables

> `domains/<domain>/tech/data/data-consumed.md` — one file per domain, not grouped
> by feature (several features commonly read the same table). This is technology
> we don't have code access to verify yet (see `knowledge-boundary.md`): curate
> what the source states, label `basis` honestly, expect re-verification once
> repos land.

Tables this domain reads. Owner per `platform/data-ownership.md` — if a table
isn't in that registry yet, record its owner here as `unknown` rather than
guessing; do not infer ownership from which domain seems to use a table most.

| table | owner | columns relied on | source |
|-------|-------|--------------------|--------|
|       |       |                    |        |

<Optional closing note: anything that explains an `unknown` owner — e.g. "another
domain owns and writes to these tables, but which one hasn't been identified yet."
Say that plainly rather than leaving the reader to guess why it's unknown.>

Column types and descriptions: see `platform/data-schema/<table>.md` — not
restated here. This file's own column list stays name-only; it exists to answer
"which columns does *this* domain rely on", not "what does this column mean".
