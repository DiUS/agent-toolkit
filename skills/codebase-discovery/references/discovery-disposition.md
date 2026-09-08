# `docs/_discovery/` disposition (the rule, stated only here)

Nothing in `_discovery/` is an onboarding document, but the four files split into two kinds with
different fates:

| File | Kind | Disposition |
|---|---|---|
| `assumptions-register.md` | Audit trail for the committed docs | **Commit.** It's the open-items list the whole team resolves from. |
| `traceability-index.md` | Audit trail for the committed docs | **Commit.** Without it nobody else can check a claim's provenance, and Phase 4 can't re-verify on a fresh clone. |
| `discovery-state.md` | This run's working memory | Recommend git-ignoring. |
| `recon-manifest.md` | Resume + staleness memory | Recommend git-ignoring. |

- The two audit files are committed because the docs they back are committed, and provenance that
  only exists on the machine that ran the skill isn't provenance. The root `README.md` may link
  `assumptions-register.md` from its open-risks section, and that link stays valid for every
  clone.
- The two state files are this run's scratch memory. **Recommend** adding them to `.gitignore`, and
  never do it automatically. Substitute the root Phase 0 agreed, per rule 1 of the
  [write contract](write-contract.md): a snippet naming `docs/` in a repo whose root is
  `docs/discovery/` ignores nothing.

  ```gitignore
  <output root>/_discovery/discovery-state.md
  <output root>/_discovery/recon-manifest.md
  ```

- Deleting the state files is safe but makes the next run **start cold**: no resume, no staleness
  detection.
- Neither kind is ever linked from `CLAUDE.md` / `AGENTS.md`; the agent file links onboarding
  material only.

> **Why the docs link the register, when nothing here is an onboarding doc.** Settled deliberately.
> Every file under the output root carries `see ../_discovery/assumptions-register.md` in its header
> block, and the root `README.md` links it from open risks. That reads as a contradiction and isn't.
> The register is committed, so the link resolves on every clone, and a reader who meets an
> `[assumption]` needs one hop to reach what explains it. The ban above is the narrower one and the
> one worth keeping: `CLAUDE.md` and `AGENTS.md` link onboarding material only, so the two state
> files never load into an agent's session.

---

What each onboarding file is *for*, meaning layout, naming, header block and length, is
[`output-conventions.md`](output-conventions.md). Nothing here is an onboarding document, so none
of that applies.
