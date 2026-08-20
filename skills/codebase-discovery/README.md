# codebase-discovery

Extract **domain, architecture, business rules, workflows and a business glossary** out of
an existing, often poorly documented, codebase, and turn them into lean **onboarding
documents** a new team member (human or AI) can use to get productive. Designed to give an
AI harness (e.g. Spec Kit) enough grounded context before any specification or change work.

## Why this exists

Most real codebases are under-documented, and documentation tends to drift from the code over
time. Before you can apply harness engineering or spec-driven development, the agent needs real
context: what the system does, the domain and its language, the architecture, and the business
rules that live in the code. This skill reconstructs that context and writes it down.

## The core idea

> The code is ground truth for **what** the system does. Only people hold the **why**.

So it mines the code first to form evidence-backed hypotheses, then validates intent with a
senior BA / Product Owner **one question at a time**, spending their time on explanation and
judgement, not on re-deriving mechanics the code already states. Existing docs feed that, and
everything drawn from them is **verified against the code** (the source of truth) before it's
relied on.

## How it works: six phases

0. **Pre-check** — read any existing `README` / `CLAUDE.md` / `AGENTS.md` / `docs`, and
   capture what they state, to verify against the code.
1. **Deep recon** — tiered, evidence-cited code analysis (structure → data model →
   contracts/edges → business-logic hotspots), token-efficient via sub-agents where
   available. Reads the structure the repo **declares** (build manifests, workspace files, runtime
   topology) before inferring anything from patterns. Validates the Phase 0 claims and records drift.
2. **Interview** — one-question-at-a-time conversation with the BA/PO, each question seeded
   by a recon hypothesis; contradictions raised with a code-based suggested fix. *(Skipped
   in code-only mode.)*
3. **Synthesis** — write the lean onboarding docs, each dated and provenance-flagged.
4. **Verify** — adversarial check that every claim traces to code evidence or a named
   stakeholder.
5. **Finish** — a **doc-drift summary**, contradictions reconciled with the user one at a time,
   and an optional **CLAUDE.md / AGENTS.md** generated or added to (detect-and-match; offer both
   if neither exists).

## Modes

- **full** — with a stakeholder to validate findings.
- **code-only** — no interview; everything needing confirmation is flagged
  `[assumption]` / `[unverified]` for later. For when no SME is available yet.

## Host-agnostic by design

No hooks, MCP servers or plugin format are required. Working memory and staleness detection
use plain files (`docs/_discovery/`), so the skill resumes across sessions and runs on any
capable agent. Optional inputs (the repo's own toolchain, AST/LSP tooling, sub-agents, a live SME)
are used when present and skipped cleanly when not. Text search is the floor that always works.

## Output

The project-root `README.md` is the onboarding entry point (created if missing, or merged into
conservatively); the detail docs are written under `docs/`, grouped and kept onboarding-lean.
There is no `docs/README.md`.

The destination is agreed rather than assumed. Because the output lands in a repo the skill
doesn't own, Phase 0 surveys the write target (is `docs/` a published site, is anything already
there?) and settles the **output root** with the user before a byte is written.

**Material is filed one concept per file, under names drawn from the domain language**, so an agent
working on billing loads `areas/billing/`, not every rule in the system. Area-specific material lives
in its area; what no single area owns stays at the top level; and the glossary is always one file,
because it's the shared vocabulary and splitting it would defeat the point. A single-area system keeps
the flat layout with no `areas/` at all, because the trigger is whether the content has an area
dimension, not how big the repo is.

```
README.md                         # project-root: onboarding index / entry point — the file CLAUDE.md/AGENTS.md links
docs/
├── business/                     # cross-cutting only
│   ├── business-requirements.md  # functional + non-functional
│   ├── user-personas.md          # users & stakeholders
│   └── workflow-<concept>.md     # flows that cross areas
├── domain/                       # system-wide domain
│   ├── domain-glossary.md        # business language — always a single file
│   ├── domain-model.md           # aggregates + cross-area relationships (+ Mermaid)
│   └── rules-<concept>.md        # rules that apply system-wide
├── tech/
│   ├── current-architecture.md   # as-is architecture (+ Mermaid), names the areas
│   └── integrations.md           # external systems, dependencies, data feeds
├── areas/<area>/                 # area-specific, named from the domain language
│   ├── model-<concept>.md        # e.g. model-invoice.md
│   ├── rules-<concept>.md        # e.g. rules-refund-eligibility.md
│   └── workflow-<concept>.md     # e.g. workflow-invoice-run.md
└── _discovery/                   # provenance & working state — NOT onboarding docs
    ├── assumptions-register.md   #   audit trail — committed
    ├── traceability-index.md     #   audit trail — committed
    ├── discovery-state.md        #   local state — git-ignore recommended
    └── recon-manifest.md         #   local state — git-ignore recommended
```

`_discovery/` is deliberately kept out of the onboarding set and is never linked from
`CLAUDE.md` / `AGENTS.md`. Its two audit files are committed and its two state files are not.

The tree above is illustrative. [`references/output-conventions.md`](references/output-conventions.md)
defines the layout and is the file to trust if this README ever falls behind it;
[`references/discovery-disposition.md`](references/discovery-disposition.md) settles what happens to
`_discovery/`.

## Status model (exception-only)

Accepted knowledge is unmarked. Only exceptions are flagged (`[unchecked]`, `[unverified]`,
`[assumption]`, `[outdated]`, `[contradicted]`), so the reader's attention goes straight to what
still needs resolving, and in `code-only` mode the caveat is stated once per document rather than
stamped on every line.
[`references/provenance-and-status.md`](references/provenance-and-status.md) defines the model.

## Layout of this skill

```
codebase-discovery/               # (this skill, under skills/ in the repo)
├── SKILL.md                      # orchestrator — start here
├── playbooks/
│   ├── 00-pre-check.md
│   ├── 01-deep-recon.md
│   ├── 02-interview.md
│   ├── 03-synthesis.md
│   ├── 04-verification.md
│   └── 05-finish.md
├── references/
│   ├── question-bank.md
│   ├── recon-heuristics.md
│   ├── provenance-and-status.md
│   ├── output-conventions.md
│   ├── discovery-disposition.md  # what's committed, what's git-ignored
│   ├── navigation.md             # the source ladder recon works
│   ├── write-contract.md         # where it may write, and what it may replace
│   ├── freshness.md              # staleness detection + drift options
│   └── code-intelligence.md      # optional LSP navigation setup
└── templates/
    ├── project-readme.md
    ├── business-requirements.md
    ├── user-personas.md
    ├── workflows.md
    ├── domain-model.md
    ├── domain-glossary.md
    ├── business-rules.md
    ├── current-architecture.md
    ├── integrations.md
    ├── assumptions-register.md
    ├── traceability-index.md
    ├── discovery-state.md
    ├── recon-manifest.md
    └── agent-onboarding-file.md
```

## Using it

Point your agent at this folder and follow `SKILL.md`. In Claude Code, drop the folder in
`.claude/skills/`. In any other tool, `SKILL.md` and the playbooks read as plain instructions.
