# Platform coverage

> **The honesty artefact.** The agent consults this before any analysis. Its job is
> to make ignorance visible — a domain absent from this table is worse than a domain
> marked `unknown`, because absence is indistinguishable from irrelevance.
>
> Rule enforced in steering: if a request touches anything not `curated`, flag it as
> out-of-knowledge rather than reasoning about it.

Last updated: <YYYY-MM-DD>

| domain | status | curated areas | not curated | source | updated |
|--------|--------|---------------|-------------|--------|---------|
| customer | partial | onboarding-eligibility | pricing, closure | functional-spec-v2.docx | |
| billing | name-only | — | all | inferred from customer spec | |
| notifications | unknown | — | unknown | — | |

**Status values**

| value | meaning |
|-------|---------|
| `curated` | processed into structured knowledge and reviewed |
| `partial` | some functional areas curated, others known to exist and not covered |
| `name-only` | we know the domain exists; nothing else |
| `unknown` | referenced somewhere but existence and scope unconfirmed |

## Non-domain coverage

| artefact | status | notes |
|----------|--------|-------|
| platform architecture diagram | not obtained | |
| database schema / DDL | not obtained | **highest-value outstanding artefact** |
| API contracts | not obtained | |
| source code | no access | |
