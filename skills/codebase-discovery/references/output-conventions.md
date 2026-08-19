# Output conventions

Rules for the `docs/` set so every run produces consistent, lean, linkable onboarding
documents.

---

## Golden rule: onboarding, not encyclopedia

Every document exists to get a new team member (human or AI) productive. If a section doesn't
serve that, cut it. These docs are linked from `CLAUDE.md` / `AGENTS.md`, so length is a cost
paid in context tokens on every session — be ruthless about signal.

---

## Folder layout

The onboarding entry point is the **project-root `README.md`** (created if missing, or merged
into conservatively — see the synthesis playbook). It's the only file the agent file links, and
there is **no `docs/README.md`**. The detail docs live under `docs/`:

```
README.md                         # project-root: onboarding index / entry point — the only file the agent file links
docs/
├── business/                     # cross-cutting only
│   ├── business-requirements.md
│   └── user-personas.md
├── domain/                       # system-wide domain
│   ├── domain-glossary.md        #   single file, always
│   └── domain-model.md           #   aggregates + cross-area relationships
├── tech/
│   ├── current-architecture.md   #   the system map; names the areas
│   └── integrations.md
├── areas/<area>/                 # anything area-specific (see below)
│   ├── model-<concept>.md
│   ├── rules-<concept>.md
│   └── workflow-<concept>.md
└── _discovery/                   # NOT onboarding docs — see disposition below
    ├── assumptions-register.md   #   audit trail — commit
    ├── traceability-index.md     #   audit trail — commit
    ├── discovery-state.md        #   local process state — recommend git-ignore
    └── recon-manifest.md         #   local process state — recommend git-ignore
```

Only create a doc if the system gives it real content. Do not create empty placeholders.

**Index only what exists.** Because some documents get skipped, the project-root `README.md` and the
agent onboarding file must link only the ones actually written — delete the rest of the rows. A dead
link in the front door misleads the reader it was written for, and costs an agent a wasted turn.

---

## Area docs vs system docs

A single file per artefact stops working as soon as a system has more than one area: a combined
business-rules document grows without limit, and a reader after billing's rules has to load
everything to find them. So **area-specific material is filed by area** and the rest stays at the top
level.

**Placement rule: a fact lives with the area that owns it. If no single area owns it, it's
cross-cutting and lives at the top level.** A system-wide authorization policy is a top-level rule; a
workflow spanning three areas is a top-level workflow.

Which artefacts split, and which must not:

| Artefact | Splits by area? | Why |
|---|---|---|
| domain model | **yes**, as `model-<concept>.md` | entities cluster by area; `domain/domain-model.md` keeps the aggregates and cross-area relationships |
| business rules | **yes**, as `rules-<concept>.md` | the clearest case — rules cluster by area and grow with the codebase |
| workflows | **yes**, as `workflow-<concept>.md` | one flow per file; you rarely need all of them at once |
| **domain glossary** | **never** | it's the shared vocabulary. Splitting it defeats the point that a term means one thing system-wide |
| current architecture | no | it *is* the system view; the per-area detail is the area docs |
| integrations | no | a table of external systems, inherently system-level |
| user personas | no | global, and small |
| business requirements | no | mostly cross-area; splitting scatters them along an axis they don't have |

**When to split: content shape, not repo size.** One area's worth of material → keep the flat layout
and no `areas/` directory at all. Material for more than one area → areas appear. There's no size
threshold to judge, because the trigger is whether the content has an area dimension.

The area files use the same `templates/` as their unsplit equivalents — written per concept rather
than per repo. **No per-area index files:** logical names make a directory listing self-describing,
and every index is another thing to drift. The root `README.md` lists the areas, and
`current-architecture.md` names them as it describes the system.

---

## The write contract (the rule — stated only here)

The output lands in a repository this skill doesn't own, so the destination is **agreed, not
assumed**. Phase 0 surveys the write target and records the outcome in `discovery-state.md`;
every later phase is bound by it.

1. **`docs/` means the agreed output root.** It defaults to `docs/`, and becomes something else —
   usually `docs/discovery/` — when the repo's `docs/` is a published documentation site or is
   already occupied. Read every `docs/…` path in this skill as `<output root>/…`. The layout
   *underneath* the root never changes, so the templates' relative links hold either way.
2. **Write nothing outside that root.** The one exception is the project-root `README.md`, which
   has its own rules in the synthesis playbook.
3. **Never overwrite a file you didn't write.** If something already occupies a target path, read
   it, show the user what would change, and get sign-off first. A generated doc must not silently
   replace a human-authored one, however stale that one looks.
4. **A previous run's own output may be refreshed in place** — recognisable by this skill's header
   block.
5. **Respect the published-site decision.** Where the root belongs to a docs generator, Phase 0
   recorded whether these pages go in its nav/sidebar. Never add pages to a public site's
   navigation without that decision.

---

## `docs/_discovery/` disposition (the rule — stated only here)

Nothing in `_discovery/` is an onboarding document, but the four files split into two kinds with
different fates:

| File | Kind | Disposition |
|---|---|---|
| `assumptions-register.md` | Audit trail for the committed docs | **Commit.** It's the open-items list the whole team resolves from. |
| `traceability-index.md` | Audit trail for the committed docs | **Commit.** Without it nobody else can check a claim's provenance, and Phase 4 can't re-verify on a fresh clone. |
| `discovery-state.md` | This run's working memory | Recommend git-ignoring. |
| `recon-manifest.md` | Resume + staleness memory | Recommend git-ignoring. |

- The two audit files are committed because the docs they back are committed — provenance that
  only exists on the machine that ran the skill isn't provenance. The root `README.md` may link
  `assumptions-register.md` from its open-risks section, and that link stays valid for every
  clone.
- The two state files are this run's scratch memory. **Recommend** adding them to `.gitignore` —
  never do it automatically:

  ```gitignore
  docs/_discovery/discovery-state.md
  docs/_discovery/recon-manifest.md
  ```

- Deleting the state files is safe but makes the next run **start cold**: no resume, no staleness
  detection.
- Neither kind is ever linked from `CLAUDE.md` / `AGENTS.md` — the agent file links onboarding
  material only.

---

## Naming

Hyphenated, lower-case throughout. The system-level files keep the fixed names in the layout above —
don't invent variants of those. Area directories and area files are named for what's **in** them,
because a name is the cheapest signal a reader or an agent has about whether to open a file.

- **Area directory** — the agreed **glossary term** for that area: `areas/order-fulfilment/`. Not the
  namespace, not the `src/` folder name, not an internal service codename.
- **Area file** — a fixed type prefix plus a glossary-derived noun phrase:
  `rules-refund-eligibility.md`, `workflow-invoice-run.md`, `model-invoice.md`. The prefix stays
  generic on purpose; it's the discriminator that makes a directory scannable without opening
  anything. Only `model-`, `rules-`, `workflow-`.
- **If the concept isn't in the glossary, add it there first.** A filename is a use of the ubiquitous
  language, so it should be an agreed one — and it keeps names consistent between runs and between
  areas.
- **No catch-alls.** No `misc`, `other`, `general`, `common`, `shared-rules`. A file you can't name
  specifically is a sign the split is wrong, and catch-alls are exactly where bloat accumulates.
- **No dates, no versions, no `v2`.** The header block carries `Last updated`.
- **Stable across runs.** If a file already covers a concept, update it — never create a
  near-duplicate name beside it. The write contract's never-overwrite rule then applies per file.

---

## Required header block (every doc)

Start every file with:

```markdown
# <Document title>

> **Last updated:** YYYY-MM-DD (use the real current date)
> **Scope:** <one line — what this covers>
> **Mode:** full | code-only
> **Status:** <pick per mode — see below> — see docs/_discovery/assumptions-register.md
```

The `Last updated` date is mandatory — it's how staleness is judged at a glance, alongside the
recon manifest.

**Get the date from the environment; never write one from memory.** Run `date +%F` (or read it
from whatever the host provides) once at the start of the run and reuse that value for every file
you stamp, including the working-state files. A guessed date is worse than none: the freshness
check and every reader treat this field as fact, and a wrong one makes fresh docs look stale or
stale docs look current.

The `Status` line carries the document-wide provenance caveat, so it has to match the mode:

| Mode | Status line reads |
|---|---|
| `full` | `accepted knowledge unless flagged` |
| `code-only` | `code-derived, not validated by a person` |

This is what lets `code-only` runs stop stamping `[unverified]` on every sentence — the caveat is
stated once, up front, and inline flags are reserved for load-bearing uncertainty. See the skill's
`references/provenance-and-status.md`.

The project-root `README.md` is the exception: it's the project's own front door, not a
`docs/` file, so it carries **no** discovery header block and no inline flags. Keep that
metadata out of it — provenance lives in the traceability index.

---

## Soft length ceilings (guidance, not law)

Aim for onboarding density, not completeness:

| Doc | Target |
|---|---|
| project-root README.md (onboarding index) | ~1 page |
| tech/current-architecture.md | ~1–2 pages + 1 diagram |
| domain/domain-model.md | ~1–2 pages + 1 diagram — aggregates and cross-area relationships only |
| domain/domain-glossary.md | one line per term |
| business/business-requirements.md | ~1–2 pages, functional + NFR |
| tech/integrations.md | a table of systems + purpose + direction |
| areas/…/model-*.md | one concept: its entities, attributes and lifecycle |
| areas/…/rules-*.md | one rule cluster, each rule with condition, exceptions and rationale |
| areas/…/workflow-*.md | one flow + its diagram |

**If a doc wants to grow past this, split it — don't hide it.** Area-shaped material becomes another
area file with its own logical name; anything else fails the onboarding test and gets cut. Pushing the
overflow into an appendix in the same file doesn't help: the file is still loaded whole, so the reader
pays for it either way.

---

## Strip the template scaffolding

Every file in `templates/` carries `<!-- … -->` guidance comments and `<placeholder>` markers.
**Delete both when you write the real file** — they're instructions to you, not content for the
target repo. A leftover `<!-- Keep to ~1–2 pages -->` or an unfilled `<name>` in a committed doc
tells the reader the docs were generated and abandoned, which costs more trust than the doc earns.

---

## Formatting

- Prefer prose and small tables over deep bullet nesting.
- Use Mermaid for the domain model, key workflows and the architecture context diagram — a
  diagram often replaces paragraphs.
- Terminology must match the glossary across every doc.
- Flags and citations follow `provenance-and-status.md`: flags inline and sparing, citations in the
  traceability index rather than the prose.

---

## Progressive disclosure

The project-root `README.md` is the summary and the map. Everything else is reached from it.
Never duplicate content between the README and a detail doc — link instead.
