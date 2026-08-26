# Source manifest

> Every original received, whether curated or not. An uncurated document listed here
> is a known backlog item; an uncurated document not listed here is invisible.

| # | file | version | received | from | domain | areas | curated | by | notes |
|---|------|---------|----------|------|--------|-------|---------|----|----|
| 1 | `customer/functional-spec-v2.docx` | v2 | | | customer | onboarding-eligibility | yes | | |

**Curated values:** `yes` / `partial` / `no` / `superseded`

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
| database schema / DDL | | | **chase first** |
| platform architecture diagram | | | |
| domain name list (canonical spellings) | | | cheap, high value |
| API contracts / event schemas | | | |
