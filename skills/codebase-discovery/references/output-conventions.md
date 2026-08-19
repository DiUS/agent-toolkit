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
├── business/
│   ├── business-requirements.md
│   ├── user-personas.md
│   └── workflows.md
├── domain/
│   ├── domain-model.md
│   ├── domain-glossary.md
│   └── business-rules.md
├── tech/
│   ├── current-architecture.md
│   └── integrations.md
└── _discovery/                   # NOT onboarding docs — see disposition below
    ├── assumptions-register.md   #   audit trail — commit
    ├── traceability-index.md     #   audit trail — commit
    ├── discovery-state.md        #   local process state — recommend git-ignore
    └── recon-manifest.md         #   local process state — recommend git-ignore
```

Only create a doc if the system gives it real content. Do not create empty placeholders.

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

- Hyphenated, lower-case filenames: `current-architecture.md`, `business-rules.md`.
- Keep the names above; don't invent variants.

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

The `Last updated` date is mandatory — it's how staleness is judged at a glance, alongside
the recon manifest.

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
| current-architecture.md | ~1–2 pages + 1 diagram |
| domain-model.md | ~1–2 pages + 1 diagram |
| business-rules.md | the load-bearing rules, grouped; not every conditional in the code |
| workflows.md | the key flows only, each with a diagram |
| domain-glossary.md | one line per term |
| business-requirements.md | ~1–2 pages, functional + NFR |
| integrations.md | a table of systems + purpose + direction |

If a doc wants to grow past this, push the detail into a clearly-marked appendix section that
isn't loaded by default — don't bloat the linked doc.

---

## Strip the template scaffolding

Every file in `templates/` carries `<!-- … -->` guidance comments and `<placeholder>` markers.
**Delete both when you write the real file** — they're instructions to you, not content for the
target repo. A leftover `<!-- Keep to ~1–2 pages -->` or an unfilled `<name>` in a committed doc
tells the reader the docs were generated and abandoned, which costs more trust than the doc earns.

---

## Formatting

- Prefer prose and small tables over deep bullet nesting.
- Use Mermaid for the domain model, key workflows and the architecture context diagram.
- Keep exception flags (`[unverified]` etc.) inline and sparing; keep citations in the
  traceability index, not the prose.
- Terminology must match the glossary across every doc.

---

## Progressive disclosure

The project-root `README.md` is the summary and the map. Everything else is reached from it.
Never duplicate content between the README and a detail doc — link instead.
