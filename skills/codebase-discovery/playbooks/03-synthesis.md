# Phase 3 — Synthesis

**Role:** Technical Writer + Solution Architect.
**Goal:** Turn the validated understanding into a small set of **onboarding documents** —
detail docs under `docs/`, indexed by the **project-root `README.md`** — enough to get a new
team member (human or AI) productive, and no more.

---

## Read these first

This phase writes files, so three references govern it. Read them before starting; none is restated
here.

- [`../references/write-contract.md`](../references/write-contract.md) — where you may write, what
  may be overwritten, and the published-site decision.
- [`../references/output-conventions.md`](../references/output-conventions.md) — the folder layout,
  which docs exist and how they're named, the required header block and how to date it, length
  ceilings, formatting, and the `_discovery/` disposition.
- [`../references/provenance-and-status.md`](../references/provenance-and-status.md) — the flag
  vocabulary and when to use it inline, how citations stay out of the prose, and **no invention**.

Phase 0 recorded the output root, the docs-site decision and the pre-existing files in
`discovery-state.md` — read them there. If the output root was never settled, stop and agree it
with the user rather than assuming `docs/`.

---

## What to write

The set of documents, where they go, and how they're named is defined in output-conventions. Three
judgements are this phase's own, plus two rules — one about coverage, one about evidence:

- **Create only what the system warrants.** Skip any document with nothing meaningful to say; an
  empty scaffold costs a reader's trust and gains nothing.
- **Apply the onboarding test to every document, section and paragraph** — *does this help a new
  joiner (or an AI harness) become productive?* If not, cut it. Favour the load-bearing entities,
  rules and workflows over exhaustive catalogues.
- **Place each fact by ownership.** Area-specific material goes in that area's directory under a
  logical name; anything no single area owns is cross-cutting and belongs at the top level. Getting
  this wrong is what turns one document into an unreadable pile — and the glossary in particular
  stays a single file whatever the system's size.
- **Partial recon still publishes, provided the gaps are declared.** Where recon covered some areas
  and left others pending, write what's covered rather than withholding everything — but the entry
  point must say which areas are documented and which aren't (see the README bullet below), and a
  claim about an uncovered area stays `[unchecked]` and unpublished. A partial doc set a reader can
  see the edges of is useful; one that reads as complete is the failure this guards against.
- **Record each claim's evidence as you write it.** A row in
  `docs/_discovery/traceability-index.md` per claim, added while the evidence is in front of you —
  see the traceability rule in provenance-and-status. Phase 4 checks these, and a load-bearing claim
  without one is a blocking finding.

Use the matching file in `../templates/`; the area files use the same templates as their unsplit
equivalents, written per concept rather than per repo.

---

## Project-root README.md — the entry point

The onboarding set has **one entry point: the project-root `README.md`** — the front door for
humans and agents landing on the repo, and the one file the agent onboarding file links. In a page
or so it must:

- Say what the system is and who it's for (2–3 sentences).
- Link out to each `docs/` doc with a one-line description of what's inside (paths relative to
  the root, e.g. `docs/tech/current-architecture.md`).
- List the top open assumptions/risks, linking `docs/_discovery/assumptions-register.md` for
  the full list.
- Where recon left areas pending, name them — which areas are documented and which aren't. A
  reader, human or harness, must be able to see the edge of what's covered without reading the
  ledger.
- Where the code reveals it, a short "how to run / get started".

Produce it from the findings using
[`../templates/project-readme.md`](../templates/project-readme.md):

- **If no root `README.md` exists, create one** from that template — concise,
  onboarding-lean, with depth pushed into `docs/` rather than duplicated.
- **If a root `README.md` already exists, merge into it conservatively** — treat it as a
  human-authored artifact, not a scratch file:
  - Preserve the maintainers' existing content, structure and voice. Add the onboarding index
    (system summary, the `docs/` map, top risks) and fill gaps the discovery genuinely
    improves, rather than rewriting what's already there.
  - Where the existing README **conflicts with the code**, don't silently rewrite the front
    door. Documentation drifts over time — record the discrepancy in
    `docs/_discovery/assumptions-register.md` and raise it, rather than overwriting it with an
    unverified correction.
  - **Confirm before writing.** Because it's an existing, outward-facing file the skill didn't
    author, summarise the proposed changes for the user and get sign-off before applying them.
  - No invention here either — and it bites harder on a front door than anywhere else.

- **Keep discovery metadata off the README.** Unlike the `docs/` set, it carries no header block
  and no inline flags — it's the project's own README, not a `docs/` file.

---

## Exit criteria

- Write contract honoured (root, overwrites, published-site decision).
- Only warranted docs written, each conforming to output-conventions; each passes the onboarding
  test.
- Project-root `README.md` is the entry point: created (if it was missing) or conservatively
  merged with sign-off, indexing the `docs/` set. Conflicts with existing README content are
  logged, not overwritten.
- Every published claim has a row in the traceability index; assumptions register is current.
- Ready for verification.
