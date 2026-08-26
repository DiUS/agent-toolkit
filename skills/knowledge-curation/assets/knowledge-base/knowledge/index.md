# Knowledge base

Entry point. **Pointers only** — this file never summarises its children.

## Start here

| | |
|---|---|
| **What is actually known** | `platform/coverage.md` — read before any analysis |
| The domain map | `platform/service-domains.md` |
| Who writes which table | `platform/data-ownership.md` |
| Rules binding every domain | `platform/constraints/` |
| End-to-end journeys | `platform/journeys/` (create when a cross-domain sequence is curated) |
| User personas / stakeholders | `platform/user-personas.md` (create when curated) |
| Table schemas (by table name) | `platform/data-schema/` |

## Domains

_None curated yet._ Each domain gets a folder under `domains/<domain>/` with an
`index.md`, created by the `knowledge-curation` skill as content is processed.

## Also here

- `AGENTS.md` — on-ramp for any agent entering this corpus (read order + ground rules)
- `questions/` — cross-cutting open questions
- `sources/` — original documents received (staging), tracked in `sources/manifest.md`
- `decisions/` — ADRs for contested structural calls

Templates, conventions, and hygiene scripts live in the knowledge-curation skill
(`.claude/skills/knowledge-curation/`), not in the corpus.

## Health

- Source documents curated: 0
- Domains with any curated content: 0
