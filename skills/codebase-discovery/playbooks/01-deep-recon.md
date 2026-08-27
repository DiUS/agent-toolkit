# Phase 1: Deep recon

**Role:** Senior Software Engineer + Solution Architect (reading the system **as-is**;
not designing changes).
**Goal:** Build an evidence-backed understanding of the codebase (structure, data model,
contracts, and where the business logic lives) and validate the Phase 0 claims against it.

"Deep" means **every area covered, but only the high-signal files within each one read**, not
reading every file. See [`../references/recon-heuristics.md`](../references/recon-heuristics.md)
for what to look for and where.

> **Prediction rule** (`SKILL.md`): don't assert structure, size or a boundary without reading what
> declares it. And **never seed a sub-agent with the answer you expect** — give it the scope and the
> question, not your hypothesis, or you get your own framing back instead of what the code says.

---

## Token discipline (read this first)

On large repos, keep the main context lean:

- **Locate, don't read.** Use the source ladder in
  [`../references/navigation.md`](../references/navigation.md) to find the small, high-signal subset
  of files that carry meaning before opening anything.
- **Delegate reading to sub-agents where available.** Dispatch isolated workers to read
  excerpts and return only distilled, cited findings, so the raw file dumps stay out of the
  main context. On Claude Code, dispatch the **`codebase-recon-scout`** subagent (one per
  scoped area, in parallel where possible). On other hosts use any generic sub-agent; if none
  is available, read sequentially and excerpt-only.
- **Give sub-agents everything they need in the prompt.** A sub-agent doesn't know where this
  skill is installed, so skill-relative paths mean nothing to it. Put the scoped area and the
  report format in the prompt, and pass an **absolute** path if you want it to read
  `references/recon-heuristics.md` itself. The bundled `codebase-recon-scout` already carries the
  secrets rule; when using a generic sub-agent instead, paste that rule from `SKILL.md` into the
  prompt verbatim.
- **Reconcile what comes back against the declared graph.** A scout searches text, so it caps its
  structural findings at Medium. Raise them to High where the module graph from Tier A/B confirms the
  relationship; otherwise the declared-graph work never reaches the findings that need it.
- **Work in tiers.** Do the cheap structural map first and get approval before spending budget on
  deep dives.
- **Cite as you go.** Every finding records `path:line` (or symbol) so it can be verified
  later without re-reading.

---

## How to navigate

Work the source ladder in [`../references/navigation.md`](../references/navigation.md) as it's
written there, and **record which tier answered what**. That's this phase's part, and it's what
later confidence calls depend on.

Two things need saying to the user rather than deciding silently:

- **The LSP tier is untested.** If you offer it, say so: nobody has run a discovery end-to-end
  through a bridge, and text search is what this skill is exercised with. The user should hear that
  from you when the choice is in front of them, rather than find it in a reference file. If the
  symbol tools turn out to be absent, say so and carry on down the ladder rather than stalling.
- **Never ask the user to install anything**, and never run a command that would restore, fetch or
  build without asking first.

---

## Tier 0: structural map (cheap, get approval)

Produce a quick orientation, then pause for the user to approve deeper spend.

**Start from the declared structure, not the directory tree.** The manifests and the repo's own
toolchain state the module graph outright, so read that first (Tier A/B of the ladder), and only use
folder layout and import patterns where nothing is declared. Then add:

- Language(s), frameworks, and what the build produces.
- Entry points (main/app bootstrap, HTTP servers, CLI, workers, scheduled jobs).
- Runtime topology where it's declared: compose services, k8s workloads, IaC modules. It often
  differs from the code layout, and where it does, that's a finding.
- Rough size (module count, file/line counts) so the cost of deep dives is visible.

Record the map in `discovery-state.md`, and note in `recon-manifest.md` which tier produced it: a
graph from a manifest is fact; one inferred from imports is not.

**Say so if the map shows the deep dives aren't warranted.** This gate exists to prevent wasted
spend, so recommending against the expensive part is one of the answers it can give. Where the map
shows a handful of files with no domain or service layer, or a repo that is configuration and
infrastructure rather than business logic, Tier 1 will find little the map hasn't already shown.
Say that plainly, and offer to write the architecture note straight from the map instead. Nothing
else changes: the phase sequence runs as normal, the ledger records the depth as **map only**, and
the user decides. They invoked the skill deliberately, so recommend, don't refuse.

### Name the areas, then choose an order

The declared graph gives you modules; **areas** are what the business calls them, and they're what
the docs get filed under (see the area layout in
[`../references/output-conventions.md`](../references/output-conventions.md)). Group the modules into
areas and name each one from the domain language, not the namespace. Each name is a candidate
glossary term, which the interview then confirms.

What's left to decide is the **order** you work through them:

1. **Ask the user, and give them the graph facts to decide with.** Which area matters most is a
   business judgement: the code can't make it, and neither can you. Show the area list, say which
   are the shared kernel everything else depends on and which are leaves, and let them choose.
2. **Fan-in from the declared graph** — the fallback when nobody's answering. The most-depended-upon
   modules are the shared kernel; understanding those wrong colours every dependent area's docs.
   This is a fact from the graph, not an inference.
3. **Entry points.** User-facing areas first when nothing else decides it.

Record every area in the manifest's coverage ledger, including the ones not yet reached. An area
missing from the ledger is an invisible gap; an area listed as pending is a known one.

**On a large repo, work across sessions rather than trimming.** Tier 0 has just priced the job (the
area list and the rough size), so put that in front of the user before spending it, and let them say
where to start. The ledger and the working state carry the uncovered areas to the next session.

---

## Tier 1: targeted deep dives

Go deep only where knowledge concentrates. For each, capture findings with citations.

**The four concerns below run within each area, not across the repo.** One scout per area covers all
four for that area, which is why the ledger records recon depth per area and why findings come back
already shaped for the docs they'll become.

### a. Data model: the domain falls out here
ORM entities/models, DB migrations, schema files, DTOs. Extract entities, key attributes,
relationships/cardinality, and any state/status fields (candidate lifecycles).

### b. Contracts and edges: workflows and boundaries
API routes/controllers, GraphQL schema, event/queue producers & consumers, external service
clients, scheduled jobs. These reveal use cases, actors, triggers and integration points.

### c. Business-logic hotspots: the rules live here

Record **where the code keeps each rule**, not just the rule. That code unit (the policy class,
module or namespace) is the only grouping you can honestly claim, and it becomes the docs' shape in
Phase 3. Don't reach for a business-sounding cluster name nobody has agreed; it's an interview
question, and until it's answered the grouping is `[unverified]`.

Service/domain layer, validation, conditionals on domain fields, state transitions,
permission/authorization checks, calculations, and **enums / constants / error & validation
messages** (these often carry the literal business language and rules). See recon-heuristics
for detection patterns.

### d. Tests as behavioural spec
Read the test suite as an encoding of expected business behaviour: test names and
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
- **stays `[unchecked]`** — recon hasn't reached the claim's area yet, so it wasn't assessed at all.
  Don't dress that up as a verdict: leave the flag, and record it in `assumptions-register.md` as
  *unresolved, area not yet covered*, naming the area. It goes in the completion report as
  outstanding coverage, and prefer keeping the statement out of the onboarding docs rather than
  publishing an unexamined claim.

Log outdated/contradicted items in `assumptions-register.md`; they become interview
questions and feed the doc-drift summary. See
[`../references/provenance-and-status.md`](../references/provenance-and-status.md) for the full
flag model.

---

## Produce recon hypotheses

Output a structured, cited set of hypotheses that seeds the interview, organised by the
target doc areas: architecture, domain model, business rules, workflows, glossary terms,
requirements. Each hypothesis carries evidence (`path:line`) and a confidence (High/Med/Low).

**Log every hypothesis that needs a human to settle it into `assumptions-register.md`**, with its
confidence and its impact if wrong, not just the outdated/contradicted ones. The interview works
from that register, ranked by impact and confidence, so a hypothesis left out of it is a question
that never gets asked.

Update `recon-manifest.md` so future runs can detect staleness: the commit recon ran against and
whether the tree was clean, the areas covered, and the files actually read. **Where git isn't
available, hash those files as you record them**, because that list is the only comparison a later
run will have. See [`../references/freshness.md`](../references/freshness.md); record the commit,
not timestamps.

---

## Exit criteria

- Tier 0 map approved; every area covered this session is worked to the depth the ledger records:
  data model, contracts, hotspots and tests for a full dive, nothing below the map where the user
  took **map only**. Areas not yet reached are recorded as pending.
- Every Phase 0 claim re-statused (accepted / `[outdated]` / `[contradicted]` / `[unverified]`),
  or left `[unchecked]` and logged as belonging to an area not yet covered.
- Cited hypotheses produced for each doc area.
- Assumptions register and traceability index updated; recon manifest records sources.
- Ready for the interview (full mode) or synthesis (code-only mode).
