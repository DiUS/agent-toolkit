# Navigating this workspace

_Purpose: the knowledge-base tree — the platform/domain/feature tiers, where each kind
of fact belongs, and the rule to reference facts by ID rather than by path._

## Tiers

```
knowledge/
  platform/               the map, and the rules binding every domain
    constraints/            platform-wide invariants (e.g. a table write-ownership
                             rule), only if the platform actually has them
    data-schema/            one file per table — the physical schema itself isn't
                             scoped to any one domain, so it lives here, not under
                             a domain's tech/ (see knowledge-boundary.md)
  domains/
    <domain>/              one folder per service domain, identical shape
      index.md               pointer + Curation status table (curated from the
                              `domain-index.md` template — the template's name
                              disambiguates it among its siblings; the curated
                              file itself is always `index.md`)
      glossary.md           single file, whole domain, no per-term IDs
      questions/            domain-scoped open questions
      constraints/          domain-wide invariants
      tech/                 the technology layer — curated, but provisional
                             (see knowledge-boundary.md); domain-level, not
                             per-feature, since tables/APIs are often shared
        data/                data-owned.md, data-consumed.md
        integrations/        data dependencies with other domains, with mechanism
        configurations/      thresholds, limits, flags, environment settings
        ui/                  one file per screen/window — fields, validations,
                              navigation, from functional design
      features/
        <feature>/           one folder per feature within the domain
          index.md             feature pointer (entry point) — every feature carries
                                one. Names its rules/workflows/questions and its
                                dependencies, so a task loads only what it needs.
                                Pointer, not summary. See `feature-index.md`.
          rules/               grouped by topic, not one file per rule
          workflows/           grouped by topic, mermaid-based
          questions/           feature-scoped open questions
sources/        original documents, never edited
decisions/      ADRs
```

Every knowledge type lives at the narrowest tier where it's actually true, rather
than being hardwired to one tier. A constraint true for the whole platform lives in
`platform/constraints/`; one true only within a domain (but every feature of it)
lives in `domains/<domain>/constraints/`. There is no feature-level constraint —
an invariant scoped to a single feature is a rule, not a constraint.

`tech/` is the exception to "narrowest tier" — it's curated business-adjacent
detail the workspace doesn't yet have code access to verify (integration
mechanism, configuration values), kept separate from business content precisely
*because* it's provisional, not because it's out of scope. See
`knowledge-boundary.md`.

**Table schema is platform-level, not domain-level**, and not part of any
domain's `tech/` — a table's columns aren't scoped to whichever domain happens to
read or write it. `platform/data-schema/<table>.md`, one file per table. The
write-ownership rule (if the platform has one — e.g. "any domain may read, only the
owner may write") is what makes a shared table safe, and is curated as a platform
constraint. Do not invent such a rule; curate it only when a source states it.

## Read order

1. `knowledge/index.md` — pointers only
2. `knowledge/platform/coverage.md` — **always, before any analysis**
3. Then navigate to what you need

`knowledge/AGENTS.md` restates this read order as an auto-loaded on-ramp, for an agent
that enters the corpus without going through the skill.

Index files are pointers. They do not summarise their children, and you should not
treat them as a substitute for opening the file you actually need.

## Where facts live

| kind of fact | home | authority |
|--------------|------|-----------|
| who writes a table | `platform/data-ownership.md` | **sole authority — never inferred** |
| a table's columns, types, descriptions | `platform/data-schema/<table>.md` | one file per table, platform-level regardless of who reads/writes it |
| a platform-wide write-ownership rule, if the platform has one | `platform/constraints/` | |
| what domains exist | `platform/service-domains.md` | |
| what is known | `platform/coverage.md` | |
| rules binding all domains | `platform/constraints/` | |
| end-to-end sequences crossing domains | `platform/journeys/` | |
| user personas / stakeholders | `platform/user-personas.md` | single file, platform-only, referenced by name |
| cross-domain glossary | `platform/glossary.md` | single file, referenced by name |
| rules binding every feature in one domain | `domains/<d>/constraints/` | |
| domain glossary | `domains/<d>/glossary.md` | single file, referenced by name |
| tables this domain reads, with columns | `domains/<d>/tech/data/data-consumed.md` | provisional — see `knowledge-boundary.md` |
| tables this domain writes, with columns | `domains/<d>/tech/data/data-owned.md` | provisional |
| data dependency between domains, with mechanism | `domains/<d>/tech/integrations/` | filed under the producing domain, provisional |
| configuration values (thresholds, flags, env settings) | `domains/<d>/tech/configurations/` | provisional |
| UI specification (screen fields, validations, navigation) | `domains/<d>/tech/ui/<screen>.md` | provisional, superseded by UI codebase analysis once accessible |
| durable rules about one feature | `domains/<d>/features/<feature>/rules/` | grouped by topic |
| sequences inside one feature | `domains/<d>/features/<feature>/workflows/` | grouped by topic, mermaid |

**One fact, one home.** If something belongs elsewhere, reference its ID. Do not
restate it. Duplicated knowledge drifts, and when you find two answers you have no
way to choose between them.

## Reference by ID, never by path

`BR-<DOMAIN>-<TOPIC>-<NNN>`, not `../../rules/<file>.md`. Folders get reorganised;
IDs do not. If you need to locate an ID, grep for it. Glossary terms, user
personas, everything under `tech/data/`, `tech/configurations/`, and `tech/ui/`,
and `platform/data-schema/*.md` are the exception — they carry no citable ID and
are referenced by name/table/screen, since each lives in a single grouped file
(or, for schema and UI, is looked up by table/screen name directly), not
scattered across the corpus. `tech/integrations/` keeps its `IN-` ID, since
integrations are actively cross-referenced from rules and workflows.

ID conventions are in `front-matter.md` (this skill's `references/conventions/`).

## Templates

A template exists for every curated file type, in
`.claude/skills/knowledge-curation/references/knowledge/` — use them. The front-matter/ID
conventions reference is `references/conventions/front-matter.md`, and the registry
templates are in `references/registry-templates/`. The front matter schema is not
decorative — closed vocabularies are what let you filter and reason over the corpus.

## Front matter

Six fields on every curated file: `id`, `status`, `basis`, `source`, `updated`,
`related`. Domain indexes add `coverage`. That is the whole schema — do not invent
extra fields, and do not omit `basis`, which is how a reader knows what weight to
put on the content.

Rules, workflows, glossary, user-personas, and most of `tech/` (`data/`,
`configurations/`) group multiple facts into one file (see
`front-matter.md`). `platform/data-schema/` and `tech/ui/` are the
exception — one file per table or per screen respectively, since each is
independently substantial and looked up by table/screen name, not grouped with
others.
`basis`/`status`/`source` at the top of the file are the default for everything in
it; a single entry overrides them inline only when its provenance genuinely
differs — it does not get its own frontmatter block.

`basis` is one of `documented` (written down) · `stated` (a person said it) ·
`inferred` (worked out from other knowledge) · `assumed` (guessed to keep moving).
When torn between two, choose the lower one.

`status` is `draft` or `verified`. Nothing is `verified` until a human who knows has
confirmed it.

**Directories prefixed with `_` are scaffolding, not knowledge.** Skip them when
searching, and never cite them. Template placeholder IDs are quoted
(`id: "BR-{DOMAIN}-{TOPIC}"`) specifically so an ID grep does not match them — if
you find a template in your search results, your pattern is too loose.

## Example content

Files with `example: true` in front matter are illustrative scaffolding, not real
knowledge. **Never cite them as fact.** If a real answer depends on an example file,
say that the real content does not exist yet.
