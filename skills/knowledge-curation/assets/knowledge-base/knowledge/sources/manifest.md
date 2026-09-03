# Source manifest

> Every original received, whether curated or not. An uncurated document listed here
> is a known backlog item; an uncurated document not listed here is invisible. The
> `knowledge-curation` skill registers a source here as its first step.

| # | file | version | received | from | domain | areas | curated | by | notes |
|---|------|---------|----------|------|--------|-------|---------|----|----|
| _none yet_ | | | | | | | | | |

**Curated values:** `yes` / `partial` / `no` / `superseded`

`partial` marks a curation still in progress — set it when extraction begins and
record how far you got in `notes` (e.g. `in-progress — done §1–3; remaining §4–9`)
so an interrupted run can be resumed from the manifest. Promote to `yes` only once
every section is extracted and the completeness checks pass.

## Precedence

When two sources disagree, the order of authority is:

1. <e.g. SME confirmation, dated>
2. <e.g. most recent signed functional specification>
3. <e.g. earlier drafts>

Record each actual conflict resolution as an ADR in `/decisions/` — the rule above
handles the general case, the ADR handles the ones that matter.

## Not received

| artefact | requested | from | status |
|----------|-----------|------|--------|
| database schema / DDL | | | chase first |
| domain name list (canonical spellings) | | | cheap, high value |
| API contracts / event schemas | | | |
