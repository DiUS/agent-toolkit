# Business vs. tech content — route, don't drop

Sources mix durable business content with technical detail that's often stale
by the time it's written. Both get curated, into different places. "Technical"
never means "skip" — it means "route to `tech/`".

## Before skipping anything

| Signal | Action |
|--------|--------|
| Legal boilerplate, disclaimers | Skip, note in `index.md` why |
| Duplicate of content already extracted | Skip, cross-reference the earlier extraction |
| External document not yet available | Coverage gap in `coverage.md` |
| Anything else | Route it |

## Where content goes

**Business content:**
- Feature: `rules/`, `workflows/`
- Domain: `glossary.md`, `constraints/`
- Platform: `journeys/`, `user-personas.md`

Stated as "what must hold" or "what depends on what", never "how it's built".

**Technical content — `domains/<domain>/tech/`, domain-level, not per-feature**
(tables and APIs are usually shared across features):

| Content | Location |
|---------|----------|
| Tables this domain reads | `tech/data/data-consumed.md` |
| Tables this domain writes | `tech/data/data-owned.md` |
| Data dependency between domains (table / event / API / batch) | `tech/integrations/` |
| API or service contract (endpoints, operations, request/response) | `tech/integrations/`, one file per service |
| Configuration values (thresholds, flags, environment settings) | `tech/configurations/<topic>.md` |
| UI screens (fields, validations, navigation) | `tech/ui/<screen>.md` |
| Purely technical diagram (infrastructure, deployment, no business logic) | `tech/integrations/` or `tech/configurations/` |

**Table schema is the platform-tier exception**, not under any domain's
`tech/`. Columns, types and descriptions → `platform/data-schema/<table>.md`,
one file per table. A table's columns aren't scoped to whichever domain reads
or writes it — any domain may read, and (where the platform has such a rule) only
the owner writes.

## Rules and workflows still cite tech

Full detail lives in `tech/`, but the rule/workflow carries a name-only pointer:
- `touches: <table> (read|write)`
- `calls: <API/system name>`

Nothing gets lost; the rule stays business-language.

## Business language, always

Phrase business content in business terms even when the source is exact:
- ✓ "Products must be configured to allow refunds"
- ✗ "Set `refund_allowed_yn = 'Y'`"

The literal field/value binding goes in `tech/data-owned.md` or
`tech/data-consumed.md`.

## Provisional by construction

`tech/` represents technology without code access (see `knowledge-boundary.md`).
Label `basis` honestly. Expect re-verification when repos land.

## UI specifications

Curate them even though code will supersede them. The spec states *intended*
behavior — curating both catches drift. UI validation rules are business rules
in disguise; extract them.

Mark `status: draft`, note "provisional pending UI code access".
