# Knowledge base — agent on-ramp

This directory is a **curated knowledge base**, not source code. It is data an agent
*reads*, not a place to edit freely. If you are working anywhere under `knowledge/`,
start here.

## Read order (before reasoning about anything here)

1. `index.md` — what exists and where (pointers only, never a summary).
2. `platform/coverage.md` — what is actually known. **Always read before analysis.**
   If a request touches anything not `curated`, say so rather than reasoning about it.
3. Navigate to the domain, then the feature, you need — each has its own `index.md`
   pointer. Load **only** that. Reference facts by ID (`BR-…`, `WF-…`, `IN-…`), don't
   inline another file's content.

## Ground rules

- Every fact carries a `basis` (`documented` / `stated` / `inferred` / `assumed`) and
  a `status` (`draft` / `verified`). Trust an unlabelled statement only if it cites a
  source. **Never cite `example: true` content as fact.**
- **Curation and structural edits go through the `knowledge-curation` skill.** Do not
  hand-edit provenance, invent IDs, or add a rule/constraint no source states.
- The full conventions — tiers, ID scheme, front-matter schema, placement rules — live
  in the skill at `.claude/skills/knowledge-curation/references/conventions/`
  (`structure.md`, `front-matter.md`, `ba-principles.md`, `knowledge-boundary.md`).
