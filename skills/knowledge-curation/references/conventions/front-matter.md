# Curation conventions

_Purpose: the metadata schema every curated file obeys — the six frontmatter fields,
the `basis`/`status` vocabularies, and the ID conventions. The authority the per-type
templates conform to._

## Front matter — the whole thing

Six lines. Copy them, fill them in, done.

```yaml
---
id: BR-BILLING-REFUNDS-001
status: draft
basis: documented
source: "functional-spec.docx §3.2.1 p.24"
updated: "2026-07-30 A. Analyst"
related: [WF-BILLING-REFUNDS-003]
---
```

| field | what to put | if unsure |
|-------|-------------|-----------|
| `id` | namespaced, never changes | see ID conventions below |
| `status` | `draft` until a human who knows confirms it, then `verified` | `draft` |
| `basis` | how solid is this — four options below | pick the more cautious one |
| `source` | free text. Anything a person could go and check. | `"—"` |
| `updated` | date and who | today, you |
| `related` | IDs of connected files | leave empty |

That is the entire schema. `title` lives in the `#` heading; `type` is implied by
the folder. Neither is repeated here.

**Rules, workflows, glossary and user-personas group multiple facts into one
file** (by topic for rules/workflows, by domain for glossary, platform-wide for
user-personas) — see each template. The frontmatter `id` on those files is either
a shared base that each entry appends `-NNN` to (rules/workflows), or a plain
descriptive slug with no citable meaning of its own (glossary/user-personas,
referenced by name, not by ID). `status`/`basis`/`source` still apply to the whole
file by default; a single entry can override them inline if its provenance
genuinely differs.

**Tech content follows the same non-citable, name-looked-up pattern, but not
always the same file granularity.** `tech/data/` groups everything into one file
for all consumed tables and one for all owned tables; `tech/configurations/`
groups by topic. `tech/ui/` and `platform/data-schema/` are one file per item
instead (one screen, one table) — each is independently substantial enough to
warrant its own file even though, like the grouped ones, it carries no citable ID
and is looked up by name.

## `basis` — four values

The one field that needs a moment's thought. It answers: *how do we know this?*

| value | means | example |
|-------|-------|---------|
| `documented` | it is written down somewhere | a functional spec, an email, a policy |
| `stated` | a person said it | architect interview, workshop, a call |
| `inferred` | we worked it out from other things we know | deduced from two rules |
| `assumed` | we guessed to keep moving | nobody has confirmed this at all |

The order is a risk gradient. **When torn between two, pick the lower one** — an
overstated basis is far more damaging than an understated one, because it stops
anyone asking the question.

`stated` catches out careful people. One person's recollection is `stated`, not
`documented`, however senior they are and however confident they sounded.

## `status` — two values

`draft` — extracted or written, nobody has confirmed it.
`verified` — a human who actually knows has confirmed it is correct.

Everything starts `draft`. Most things stay `draft` for a while, and that is fine —
`draft` is honest, not embarrassing.

**You cannot verify an assumption.** If `basis: assumed` and someone confirms it,
the basis changes to `stated` or `documented` at the same time. The checker enforces
this.

## Curating by hand

There is nothing special about hand-written files. Same six lines. If you learn
something from a conversation and want to record it:

```yaml
---
id: BR-BILLING-REFUNDS-004
status: draft
basis: stated
source: "Architect walkthrough, 2026-07-30"
updated: "2026-07-30 A. Analyst"
---
```

Then write the content. Run the skill's `scripts/check-frontmatter.sh` (from the
workspace root: `bash .claude/skills/knowledge-curation/scripts/check-frontmatter.sh`) and it
will tell you if something is off.

## Editing curated content

Expected and encouraged. The knowledge base is the living artefact, not a
transcription of a document — hand-correct it as understanding improves.

One rule: **once a file is `verified`, never regenerate it from its original
source.** It has deliberately diverged, and re-deriving silently discards the
correction. Edit in place.

## What happened to source documents

Tracked in `knowledge/sources/manifest.md`, one row per source — not repeated on
every file derived from it. That register records where the original lives and
whether it is still in the workspace.

## Domain index files

One extra field, because "how much do we know about this domain" is a different
question from "is this file trustworthy":

```yaml
coverage: name-only        # curated | partial | name-only | unknown
```

## Writing rules that apply to every file

**Self-contained.** Assume the reader arrives here directly. No "as described above."

**One fact, one home.** Reference an ID rather than restating what another file
says. Duplicated knowledge drifts, and two answers cannot be adjudicated.

**Separate the rule from the rationale.** What must hold, versus why. Agents need
the first to reason and the second to know when it is safe to challenge.

**State ignorance explicitly.** `_Not documented in source._` rather than an empty
section. Empty reads as nothing-to-say; stated absence prompts a question.

## ID conventions

Namespaced from day one. IDs propagate into engagement docs and client deliverables,
so they are expensive to change. Directory depth is not — reorganise folders freely,
never rename an ID.

| prefix   | pattern                          | example                     |
|----------|----------------------------------|-----------------------------|
| rule     | `BR-<DOMAIN>-<TOPIC>-<NNN>`      | `BR-BILLING-REFUNDS-001` |
| workflow | `WF-<DOMAIN>-<TOPIC>-<NNN>`      | `WF-BILLING-REFUNDS-003` |
| journey  | `JR-<NNN>`                       | `JR-001`                    |
| constraint | `CN-<NNN>` (platform) or `CN-<DOMAIN>-<NNN>` (domain) | `CN-001` · `CN-BILLING-002` |
| integration | `IN-<FROM>-<TO>-<NNN>`        | `IN-ORDERS-BILLING-001`     |
| question | `OQ-<NNN>`                       | `OQ-007`                    |
| decision | `ADR-{NNN}`                      | `ADR-001`                   |
| requirement | `REQ-<ENGAGEMENT>-<NNN>`      | `REQ-BILLING-012`           |
| assumption | `AS-<ENGAGEMENT>-<NNN>`        | `AS-BILLING-003`            |

Integrations are filed under the producing domain's `tech/integrations/` —
domain-level, not per-feature, since a single integration can back more than one
feature.

**Glossary terms and user-personas carry no ID at all** — they're referenced by
name/heading, not by ID. Both are single grouped files (`glossary.md` per domain
or platform, `user-personas.md` platform-wide), not one file per entry. The same
is true of everything under a domain's `tech/` folder (`data/data-owned.md`,
`data/data-consumed.md`, `configurations/`, `ui/`) and of `platform/data-schema/*.md`
— technical reference content, looked up by table/config/screen name, not by ID.
`tech/integrations/` is the exception: it keeps the `IN-` ID below, since
integrations are actively cross-referenced from rules and workflows.

**`platform/data-schema/` and `tech/ui/` are one file per item** (table, or
screen), not grouped like the rest of the paragraph above — a table's schema
isn't scoped to whichever domain happens to read or write it (a table's shape is
platform-level regardless of the platform's write-ownership rule), and a screen is
independently substantial enough to warrant its own file.

Rules and workflows are domain-scoped, and now grouped by `<TOPIC>` (the grouping
file's own subject, e.g. `ELIGIBILITY`) rather than by `<FEATURE>` — the containing
folder already encodes domain and feature, so the ID doesn't need to repeat it.
`TOPIC` only needs to be unique within its own file's folder; the existing
duplicate-ID check (`check-placement.sh`) catches an accidental clash.

Journeys are platform-scoped and personas (`user-personas.md`) are platform-only,
so neither carries a domain segment. Constraints carry a domain segment only when
domain-scoped — its absence is itself the signal that a constraint is
platform-wide.

## Writing rules that apply to every template

**Self-contained.** Assume the reader arrives at this file directly with no
surrounding context. Never write "as described above" or "the process outlined
earlier" — there is no above.

**One fact, one home.** If a statement belongs to another file, reference its ID
rather than restating it. Duplicated knowledge drifts, and the agent finds two
answers with no way to choose.

**Separate the rule from the rationale.** The rule is what must hold. The rationale
is why. Agents need the first to reason and the second to know when it is safe to
challenge.

**State ignorance explicitly.** An empty section reads as "nothing to say here."
`_Not documented in source._` reads as a gap. Only the second one prompts a question.

## Where the templates live

All templates live inside the knowledge-curation skill, so the workspace root holds only the
`knowledge/` corpus:

- **Per-curated-file-type templates** (`rule.md`, `workflow.md`, `glossary.md`, and
  the rest) — `references/knowledge/`.
- **Registry templates** (`coverage.md`, `data-ownership.md`, `sources-manifest.md`,
  `adr.md`) — `references/registry-templates/`. The scaffold in
  `assets/knowledge-base/` seeds empty live registries from these; `adr.md` is the
  template for any contested decision recorded in `knowledge/decisions/`.
- **This file** (the front-matter schema, `basis`/`status` vocabulary, and ID
  conventions below) — `references/conventions/front-matter.md`, pointed to directly
  by `conventions/structure.md`.

Placeholder IDs are quoted with `{}` slots so that grepping `^id: BR-` across the
corpus does not match a template. If you edit these, preserve that.

## Checks

The hygiene scripts live in the skill (`scripts/`). Run them from the workspace root,
e.g. `bash .claude/skills/knowledge-curation/scripts/check-frontmatter.sh`:

| script | enforces |
|--------|----------|
| `check-frontmatter.sh` | front matter parses; enum values are valid |
| `check-placement.sh` | ID definitions live only in `/knowledge` |
| `check-examples.sh` | no shipped example content remains |
| `check-structure.sh` | every domain/feature folder has an `index.md`; rules/workflows under a feature |
