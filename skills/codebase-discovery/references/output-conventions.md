# Output conventions

Rules for the `docs/` set so every run produces consistent, lean, linkable onboarding
documents.

---

## Golden rule: onboarding, not encyclopedia

Every document exists to get a new team member (human or AI) productive. If a section doesn't
serve that, cut it. These docs are linked from `CLAUDE.md` / `AGENTS.md`, so length is a cost
paid in context tokens on every session. Be ruthless about signal.

---

## Folder layout

The onboarding entry point is the **project-root `README.md`** (created if missing, or merged
into conservatively; see the synthesis playbook). It's the only file the agent file links, and
there is **no `docs/README.md`**. The detail docs live under `docs/`:

```
README.md                         # project-root: onboarding index / entry point — the only file the agent file links
docs/
├── business/                     # cross-cutting only
│   ├── business-requirements.md
│   ├── user-personas.md
│   └── workflow-<concept>.md     #   cross-area flows only
├── domain/                       # system-wide domain
│   ├── domain-glossary.md        #   single file, always
│   ├── domain-model.md           #   aggregates + cross-area relationships
│   └── rules-<concept>.md        #   system-wide rules only
├── tech/
│   ├── current-architecture.md   #   the system map; names the areas
│   └── integrations.md
├── areas/<area>/                 # anything area-specific (see below)
│   ├── model-<concept>.md
│   ├── rules-<concept>.md
│   └── workflow-<concept>.md
└── _discovery/                   # NOT onboarding docs — see discovery-disposition.md
    ├── assumptions-register.md   #   audit trail — commit
    ├── traceability-index.md     #   audit trail — commit
    ├── discovery-state.md        #   local process state — recommend git-ignore
    └── recon-manifest.md         #   local process state — recommend git-ignore
```

Only create a doc if the system gives it real content. Do not create empty placeholders.

**Index only what exists.** Because some documents get skipped, the project-root `README.md` and the
agent onboarding file must link only the ones actually written; delete the rest of the rows. A dead
link in the front door misleads the reader it was written for, and costs an agent a wasted turn.

---

## Area docs vs system docs

A single file per artefact stops working as soon as a system has more than one area: a combined
business-rules document grows without limit, and a reader after billing's rules has to load
everything to find them. So **area-specific material is filed by area** and the rest stays at the top
level.

> **Why "area", and not "domain" or "context".** Settled deliberately — don't rename it. `domains/`
> would sit one letter from the existing `domain/` directory, and both words are already taken: in
> DDD a *domain* is the whole problem space and a *bounded context* is a modelling conclusion.
> Recon can only observe that some modules group together and the business calls it billing. "Area"
> claims exactly that and nothing more, which keeps the skill out of design work.

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

### The grouping is a finding, not filing

How rules and workflows cluster ("these five belong together and it's called authorization") is a
judgement about the business, and **the code can't settle it.** Code shows you files, classes,
namespaces and where conditionals sit; it does not tell you that scattered conditionals constitute a
concept the business would recognise. Invent a carve-up and it becomes the doc structure, which is
stickier than any sentence in it: every later reader inherits it.

So the grouping comes from one of two places, never from invention:

1. **An observed code unit.** The policy class, module or namespace the rules already live in, so
   `rules-invoice-policy.md` from `Billing/Policies/InvoicePolicy.cs`. Traceable, and honest even when
   the name is technical rather than business language.
2. **A stakeholder.** Grouping is a *meaning* question, so a person is the only thing that can settle
   it. It's a grounded interview question, not a guess: *"the code keeps these five rules together in
   `InvoicePolicy`. Is that how the business thinks about them?"*

Until someone confirms it, **the grouping itself carries `[unverified]`**; say so in the file's scope
line. In `code-only` mode it stays that way: group strictly by code location and don't reach for
business-sounding cluster names nobody has agreed.

**Requirements are the exception: keep them in one file.** They're mostly cross-cutting and there's no
observable code unit to group them by, so `business-requirements.md` stays whole.

**When a stakeholder regroups, rename.** That's the expected outcome of confirming a carve-up rather
than churn, so it overrides the stable-names rule below: rename or merge the files to match the agreed
grouping, update the file references in the traceability index, and don't leave the superseded file
behind beside the new one.

**The concept-file convention applies at both levels.** `rules-` and `workflow-` files live at the top
level when the material is cross-cutting or the system has only one area, and inside
`areas/<area>/` when an area owns it. So a single-area system still gets its rules and workflows;
they simply sit under `domain/` and `business/` rather than in an area directory.

One consequence: **`business-rules.md` and `workflows.md` are template names, not output names.** The
templates keep those filenames, but what they produce is always `rules-<concept>.md` /
`workflow-<concept>.md`. A file called `business-rules.md` in the output is a sign the split was
skipped.

The area files use the same `templates/` as their unsplit equivalents, written per concept rather
than per repo. **No per-area index files:** logical names make a directory listing self-describing,
and every index is another thing to drift. The root `README.md` lists the areas, and
`current-architecture.md` names them as it describes the system.

---

Where you may write at all, and whether you may replace what's already there, is the **write
contract** in [`write-contract.md`](write-contract.md). Every `docs/…` path in this file means
`<output root>/…` per rule 1 there.

---

## Naming

Hyphenated, lower-case throughout. The system-level files keep the fixed names in the layout above;
don't invent variants of those. Area directories and area files are named for what's **in** them,
because a name is the cheapest signal a reader or an agent has about whether to open a file.

- **Area directory** — the agreed **glossary term** for that area: `areas/order-fulfilment/`. Not the
  namespace, not the `src/` folder name, not an internal service codename.
- **Area file** — a fixed type prefix plus a glossary-derived noun phrase:
  `rules-refund-eligibility.md`, `workflow-invoice-run.md`, `model-invoice.md`. The prefix stays
  generic on purpose; it's the discriminator that makes a directory scannable without opening
  anything. Only `model-`, `rules-`, `workflow-`.
- **If the concept isn't in the glossary, add it there first.** A filename is a use of the ubiquitous
  language, so it should be an agreed one, and it keeps names consistent between runs and between
  areas.
- **No catch-alls.** No `misc`, `other`, `general`, `common`, `shared-rules`. A file you can't name
  specifically is a sign the split is wrong, and catch-alls are exactly where bloat accumulates.
- **No dates, no versions, no `v2`.** The header block carries `Last updated`.
- **Stable across runs.** If a file already covers a concept, update it rather than creating a
  near-duplicate name beside it. The write contract's never-overwrite rule then applies per file. The
  one exception is a stakeholder correcting the grouping: then you rename, as set out above.
- **Name from the code unit until someone agrees otherwise.** A cluster's name starts as the code's
  (`rules-invoice-policy.md`) and becomes the glossary's once confirmed
  (`rules-refund-eligibility.md`). Don't skip the first form to get to the second.

---

## Required header block (every onboarding doc)

Start every file with:

```markdown
# <Document title>

> **Last updated:** YYYY-MM-DD (use the real current date)
> **Scope:** <one line — what this covers>
> **Mode:** full | code-only
> **Status:** <pick per mode — see below> — see ../_discovery/assumptions-register.md
```

**The register link is relative to the file's own depth.** `../_discovery/…` from `business/`,
`domain/` and `tech/`; `../../_discovery/…` from `areas/<area>/`. A template that can be written at
either depth leaves that segment as a placeholder rather than shipping a path that's wrong half the
time, so resolve it against where the file actually lands. Phase 4 checks it resolves.

The `Last updated` date is mandatory. It's how staleness is judged at a glance, alongside the
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

This is what lets `code-only` runs stop stamping `[unverified]` on every sentence: the caveat is
stated once, up front, and inline flags are reserved for uncertainty that carries weight. See
[`provenance-and-status.md`](provenance-and-status.md).

Two files are the exception, because neither is a `docs/` file: the project-root `README.md` (the
project's own front door) and the agent onboarding file. They carry **no** discovery header block
and no inline flags. Keep that metadata out of both; provenance lives in the traceability index. A
verifier that finds no `Last updated` in either has found the intended state, not a defect.

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
| business/user-personas.md | a table of personas + a table of stakeholders |
| tech/integrations.md | a table of systems + purpose + direction |
| model-*.md | one concept: its entities, attributes and lifecycle |
| rules-*.md | one rule cluster, each rule with condition, exceptions and rationale |
| workflow-*.md | one flow + its diagram |

**If a doc wants to grow past this, split it; don't hide it.** Area-shaped material becomes another
area file with its own logical name; anything else fails the onboarding test and gets cut. Pushing the
overflow into an appendix in the same file doesn't help: the file is still loaded whole, so the reader
pays for it either way.

---

## Strip the template scaffolding

Every file in `templates/` carries `<!-- … -->` guidance comments and `<placeholder>` markers.
**Delete both when you write the real file.** They're instructions to you, not content for the
target repo. A leftover `<!-- Keep to ~1–2 pages -->` or an unfilled `<name>` in a committed doc
tells the reader the docs were generated and abandoned, which costs more trust than the doc earns.

---

## Formatting

- Prefer prose and small tables over deep bullet nesting.
- Use Mermaid for the domain model, key workflows and the architecture context diagram. A
  diagram often replaces paragraphs.
- Terminology must match the glossary across every doc.
- Flags and citations follow `provenance-and-status.md`: flags inline and sparing, citations in the
  traceability index rather than the prose.

---

## Progressive disclosure

The project-root `README.md` is the summary and the map. Everything else is reached from it.
Never duplicate content between the README and a detail doc; link instead.
