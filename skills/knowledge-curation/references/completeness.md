# Completeness and source lifecycle

_Purpose: the final-pass checklist for confirming a source is fully curated, and the
rules for retiring a source once its content is captured._

## Checklist

Before marking a source curated:

- [ ] Business-language topic grouping was presented to and confirmed by the user before any files were created (Method step 4). The mapping table is agent-internal; the confirmation is about the plain-language grouping.
- [ ] Every section in the source's ToC reviewed
- [ ] Each section produced an artifact OR has a documented reason for omission
- [ ] Rules → `rules/`, grouped by topic
- [ ] Workflows → `workflows/`, correct diagram type
- [ ] Terms → `glossary.md`
- [ ] Config values → `tech/configurations/`
- [ ] Integrations and service contracts → `tech/integrations/`
- [ ] Table reads → `tech/data/data-consumed.md`; writes → `data-owned.md`
- [ ] Tables with columns stated → `platform/data-schema/<table>.md`
- [ ] Every `Column | Value` configuration block in the source has produced a `platform/data-schema/<table>.md` entry for the implied table (columns from the block's left column), as well as its `tech/configurations/` entry
- [ ] UI screens → `tech/ui/`
- [ ] Registries updated: `service-domains.md`, `coverage.md`, `data-ownership.md`
- [ ] Domain `index.md` created with curation status table
- [ ] Every domain and feature folder has its own `index.md` (enforced by `check-structure.sh`)
- [ ] `knowledge/sources/manifest.md` updated to `curated`
- [ ] All `OQ-<NNN>` across all tiers either `answered` or `unresolvable`
- [ ] Every created file follows its template exactly
- [ ] Every mermaid diagram renders without parse errors (preview each one)

Undocumented gaps are failures. Can't check a box → document why, or raise an OQ.

## Retiring a source

`knowledge/sources/` is a staging area, not an archive. Curated files are the living
artefact — but **the agent never deletes a source document.** Deleting an original is
irreversible and it is not the agent's call: at most the agent reports that a source
now looks safe to archive, and the human decides and acts. This is deliberate — the
agent cannot self-promote content to `verified` (only a human can; see the front-matter
conventions), so "all derived files are verified" can never be a state the agent
manufactured on its way to deleting the client's spec.

**A source looks safe to archive when all of these hold** — the agent *reports* this,
it does not act on it:

1. Every derived file is `status: verified` — not merely `curated` — which, per the
   self-verification rule, means a human confirmed each one.
2. `system_of_record` is populated on each derived file.
3. `knowledge/sources/manifest.md` records the intent.

When they hold, tell the user plainly — e.g. "Everything derived from `<source>` is
verified and cites a system of record; the original now looks safe to archive. Want me
to mark it removed in the manifest?" On their explicit yes, set `source_status: removed`
on the derived files and note it in the manifest. Citation stays. **Removing the local
copy is the human's action, never the skill's.**

**Never re-derive from a source after `hand_edited: true`.** Regenerating
silently discards deliberate divergence.
