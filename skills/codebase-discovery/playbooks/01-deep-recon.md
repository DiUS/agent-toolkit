# Phase 1 — Deep recon

**Role:** Senior Software Engineer + Solution Architect (reading the system **as-is**;
not designing changes).
**Goal:** Build an evidence-backed understanding of the codebase — structure, data model,
contracts, and where the business logic lives — and validate the Phase 0 claims against it.

"Deep" means **thorough coverage of the high-signal areas, reached selectively** — not
reading every file. See [`../references/recon-heuristics.md`](../references/recon-heuristics.md)
for what to look for and where.

---

## Token discipline (read this first)

On large repos, keep the main context lean:

- **Locate, don't read.** Use search (grep, or LSP symbol lookup — see Navigation mode) to find the
  small, high-signal subset of files that carry meaning before opening anything.
- **Delegate reading to sub-agents where available.** Dispatch isolated workers to read
  excerpts and return only distilled, cited findings — the raw file dumps stay out of the
  main context. On Claude Code, dispatch the **`codebase-recon-scout`** subagent (one per
  scoped area, in parallel where possible). On other hosts use any generic sub-agent; if none
  is available, read sequentially and excerpt-only.
- **Give sub-agents everything they need in the prompt.** A sub-agent doesn't know where this
  skill is installed, so skill-relative paths mean nothing to it. Put the scoped area and the
  report format in the prompt, and pass an **absolute** path if you want it to read
  `references/recon-heuristics.md` itself. The bundled `codebase-recon-scout` already carries the
  secrets rule; when using a generic sub-agent instead, paste that rule from `SKILL.md` into the
  prompt verbatim.
- **Tiered, not exhaustive.** Do the cheap structural map first and get approval before
  spending budget on deep dives.
- **Cite as you go.** Every finding records `path:line` (or symbol) so it can be verified
  later without re-reading.

---

## How to navigate

Work the source ladder in [`../references/navigation.md`](../references/navigation.md): read what the
repo **declares**, ask its own **toolchain**, then **search** — and record which tier answered what.
Text search is the floor and always works; everything above it is used when present and skipped
cleanly when not.

Two things need saying to the user rather than deciding silently:

- **The LSP tier is untested.** If you offer it, say so — nobody has run a discovery end-to-end
  through a bridge, and text search is what this skill is exercised with. An informed choice, not a
  warning buried in a reference file. If the symbol tools turn out to be absent, say so and carry on
  down the ladder rather than stalling.
- **Never ask the user to install anything**, and never run a command that would restore, fetch or
  build without asking first.

---

## Tier 0 — Structural map (cheap, get approval)

Produce a quick orientation, then pause for the user to approve deeper spend.

**Start from the declared structure, not the directory tree.** The manifests and the repo's own
toolchain state the module graph outright — read that first (Tier A/B of the ladder), and only use
folder layout and import patterns where nothing is declared. Then add:

- Language(s), frameworks, and what the build produces.
- Entry points (main/app bootstrap, HTTP servers, CLI, workers, scheduled jobs).
- Runtime topology where it's declared — compose services, k8s workloads, IaC modules. It often
  differs from the code layout, and where it does, that's a finding.
- Rough size (module count, file/line counts) so the cost of deep dives is visible.

Record the map in `discovery-state.md`, and note in `recon-manifest.md` which tier produced it — a
graph from a manifest is fact; one inferred from imports is not. Ask the user to confirm the scope of
deep dives before continuing (especially on large repos).

---

## Tier 1 — Targeted deep dives

Dive only where knowledge concentrates. For each, capture findings with citations.

### a. Data model — the domain falls out here
ORM entities/models, DB migrations, schema files, DTOs. Extract entities, key attributes,
relationships/cardinality, and any state/status fields (candidate lifecycles).

### b. Contracts & edges — workflows and boundaries
API routes/controllers, GraphQL schema, event/queue producers & consumers, external service
clients, scheduled jobs. These reveal use cases, actors, triggers and integration points.

### c. Business-logic hotspots — the rules live here
Service/domain layer, validation, conditionals on domain fields, state transitions,
permission/authorization checks, calculations, and **enums / constants / error & validation
messages** (these often carry the literal business language and rules). See recon-heuristics
for detection patterns.

### d. Tests as behavioural spec
Read the test suite as an encoding of expected business behaviour — test names and
assertions frequently state rules the code doesn't comment. Treat confirmed test behaviour
as strong (but still code-level) evidence.

---

## Validate the Phase 0 claims

For every `[unchecked]` claim harvested in Phase 0, check it against what recon found and
set its status:

- **Accepted** — matches the code → remove the flag (accepted knowledge is unmarked). Record
  the supporting evidence in `traceability-index.md`.
- **`[outdated]`** — the code shows it is no longer true → record the claim, the code
  evidence, and a **suggested corrected statement derived from the code**.
- **`[contradicted]`** — sources disagree and it's unresolved → record both sides.
- **`[unverified]`** — the code can't settle it (intent, rationale, policy, ownership) → carries
  into the interview, where a person is the only thing that can resolve it.
- **stays `[unchecked]`** — the claim's area was **outside this run's recon scope**, so it wasn't
  assessed at all. Don't dress that up as a verdict: leave the flag, and record it in
  `assumptions-register.md` as *unresolved — outside recon scope*, naming the area. It goes in
  the completion report as a coverage gap, and prefer keeping the statement out of the onboarding
  docs rather than publishing an unexamined claim.

Log outdated/contradicted items in `assumptions-register.md`; they become interview
questions and feed the doc-drift summary. See
[`../references/provenance-and-status.md`](../references/provenance-and-status.md) for the full
flag model.

---

## Produce recon hypotheses

Output a structured, cited set of hypotheses that seeds the interview — organised by the
target doc areas: architecture, domain model, business rules, workflows, glossary terms,
requirements. Each hypothesis carries evidence (`path:line`) and a confidence (High/Med/Low).

**Log every hypothesis that needs a human to settle it into `assumptions-register.md`**, with its
confidence and its impact if wrong — not just the outdated/contradicted ones. The interview works
from that register, ranked by impact and confidence, so a hypothesis left out of it is a question
that never gets asked.

Update `recon-manifest.md` so future runs can detect staleness: the commit recon ran against and
whether the tree was clean, the areas covered, and the files actually read. See
[`../references/freshness.md`](../references/freshness.md) — record the commit, not timestamps.

---

## Exit criteria

- Tier 0 map approved; targeted dives complete for data model, contracts, hotspots, tests.
- Every Phase 0 claim re-statused (accepted / `[outdated]` / `[contradicted]` / `[unverified]`),
  or left `[unchecked]` and logged as outside recon scope.
- Cited hypotheses produced for each doc area.
- Assumptions register and traceability index updated; recon manifest records sources.
- Ready for the interview (full mode) or synthesis (code-only mode).
