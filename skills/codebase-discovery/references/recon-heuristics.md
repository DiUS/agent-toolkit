# Recon heuristics: where knowledge hides in code

A field guide for Phase 1. The point is to reach the high-signal parts of a codebase fast (a small
fraction of the files, wherever they turn out to be) and extract domain, rules, workflows and
language from them, without reading everything.

---

## Where each output comes from

| Output | Primary code sources |
|---|---|
| Domain model | ORM entities/models, DB migrations, schema/DDL, DTOs, aggregate roots |
| Domain glossary | Entity/field names, enums, constants, validation & error messages, event names |
| Business rules | Validation logic, conditionals on domain fields, state transitions, permission checks, calculations, scheduled jobs, test assertions |
| Workflows | Controllers/routes, event producers/consumers, orchestration/service layer, sagas, job schedules, state machines |
| Architecture | Module/package layout, dependency manifests, entry points, config, deployment/IaC, external clients |
| Integrations | HTTP/gRPC clients, SDKs, queue/topic config, webhooks, DB connections, credentials/config keys |
| Requirements (reconstructed) | Feature modules, tests as behaviour spec, config/feature flags, NFRs implied by caching/retry/rate-limit/auth code |

---

## High-signal patterns to grep for

- **State & lifecycle:** `status`, `state`, `*_at` timestamps, enums like `PENDING|ACTIVE|CLOSED`,
  state-machine libraries, `transition`, `can_*`, guard clauses.
- **Business rules:** `if`/`case` on domain fields, `validate`, `assert`, `raise`/`throw` with
  business messages, `threshold`, `limit`, `min`/`max`, fee/tax/rate/discount calculations.
- **Authorization / policy:** `authorize`, `can?`, `permission`, `role`, `policy`, `guard`,
  `@PreAuthorize`, middleware.
- **Workflows / edges:** route definitions, `@app.route`/controllers, `subscribe`/`publish`,
  `@EventListener`, queue consumers, `cron`, scheduler registrations.
- **Integrations:** `http`, `client`, `sdk`, base URLs, `webhook`, `apiKey`, connection strings,
  env var names, all subject to the secrets rule (see below).
- **Domain language:** enum values, constant names, error/validation message strings, event
  and command names. These are literally the ubiquitous language.

> These are *what* to look for; how to find it is the ladder in
> [`navigation.md`](navigation.md). Text search owns the literals: enum values, messages, config
> keys. The structural ones (what implements this, conditionals on a domain field, annotated
> handlers) are found more reliably by AST search or symbol resolution when either is available, and
> approximated by scoped multiline patterns when not.

---

## Secrets and credentials

Several of the patterns above (`apiKey`, connection strings, config keys, env var names)
deliberately lead towards credential-shaped code, and recon findings end up in documents that
get committed permanently, with a git history. Before recording anything from config, clients
or environment handling, apply **the secrets rule in [`../SKILL.md`](../SKILL.md)**. It is
normative and stated only there; nothing in this file relaxes or extends it.

---

## Reading order, cheap to expensive

1. Declared module graph (manifests, or the repo's own toolchain) → stack and real boundaries.
2. Entry points → how the system is driven (web, jobs, CLI, events).
3. Data model (entities + migrations) → the domain skeleton.
4. Contracts (routes/events/clients) → use cases and integration edges.
5. Service/domain layer + validation → the business rules.
6. Tests → confirmation of expected behaviour and rules.
7. Config / feature flags → variability and NFRs.

Stop when you have enough to seed good questions; depth beyond that is the interview's job.

---

## What to skip

Generated code, vendored dependencies, lockfiles, build output, boilerplate scaffolding, and
UI styling, unless a specific question sends you there. Don't read the whole test suite;
sample the tests around the business-logic hotspots.

**Exclusions layer, highest priority last:**

1. **`.gitignore`** — honoured implicitly. It already encodes generated and vendored paths, so respect
   it rather than re-deriving the same list.
2. **The defaults above.**
3. **`--exclude` from the user** — gitignore syntax, `!` negation included. No new format to learn.

**An excluded path stays on the Tier 0 map, marked excluded; it just gets no deep dive.** The
declared graph is a fact about the repo, so dropping a module from the map would misrepresent what
the system is, while nothing may be claimed about code nobody read. That's what lets
`current-architecture.md` honestly say "five services; this run covered one", and it's how you narrow
a monorepo to a single service without the result reading as the whole system.

Record the exclusions in the recon manifest's run info, because they outlive the run: a resumed
session applies them without being told again, and **the freshness check ignores drift in excluded
paths**; otherwise a churning generated directory reports the docs as stale forever. A team wanting
permanent exclusions edits that line.

---

## Confidence

Record confidence with every hypothesis. Low/Medium items are prime interview material, and the
interview queue sorts on it. Both how clearly the code states a thing and how the finding was
obtained set it; the calibration is in
[`provenance-and-status.md`](provenance-and-status.md).

---

## Reconstructing the "why" the code can't show

Code shows *what* and *how*, rarely *why*. When you hit a rule with no evident rationale (a magic
threshold, a special-case branch, a hard-coded exception), that's interview material: log it as an
`[assumption]` with the evidence and the question. Guessing the rationale is the failure mode the
no-invention rule in [`provenance-and-status.md`](provenance-and-status.md) exists to prevent.
