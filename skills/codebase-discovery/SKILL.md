---
name: "codebase-discovery"
description: "Extract domain, architecture, business rules, workflows and a business glossary from an existing (often poorly-documented) codebase, then validate the findings with a senior BA/Product Owner one question at a time. Produces onboarding-grade docs under docs/ that give a new team member — human or AI — enough context to be productive, ready for harness engineering / Spec Kit. Use when onboarding onto an unfamiliar codebase, reverse-engineering business knowledge, reconstructing lost documentation, or preparing a repo for spec-driven development."
argument-hint: "Point at the repo (or subsystem) you want to understand; optionally name the mode: full | code-only"
compatibility: "Host-agnostic. Runs as a Claude Code skill, or as plain Markdown any capable coding agent can follow. No hooks/MCP/plugin required."
metadata:
  author: "Bryan Signey"
  purpose: "Reverse-engineer business & domain knowledge from existing code for harness engineering"
user-invocable: true
disable-model-invocation: false
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). It identifies the
codebase (or subsystem) to analyse and, optionally, the mode.

---

## Purpose

Reverse-engineer enough business and domain knowledge out of an **existing codebase** to
onboard a new team member — human or AI — and to give AI harness tooling (e.g. Spec Kit)
the context it needs before any specification or change work begins.

The output is a small, lean set of **onboarding documents** under `docs/`, not a
comprehensive knowledge base. Each document is written so it can be linked from a
`CLAUDE.md` / `AGENTS.md` without consuming an unreasonable amount of context.

This skill is the orchestrator. It runs five phases, each defined in its own playbook
under `playbooks/`. Read and follow the relevant playbook at each phase.

---

## Core principle

> **The code is ground truth for _what_ the system does. Only people hold the _why_.**

So the method is: mine the code first to form **evidence-backed hypotheses**, then spend
the human's time **validating intent and explaining**, not re-deriving mechanics. Existing
docs (README, CLAUDE.md, AGENTS.md, wikis) are a valuable starting point, but because
documentation naturally drifts from code over time, the **source code is the source of
truth** — everything is verified against it before being relied on.

---

## The secrets rule (normative — applies to every phase)

Recon deliberately looks at config, clients and credential keys, and the docs this skill writes
are usually committed. So:

> Record a credential **by name and location, never the value** — not truncated, not partial,
> and never a URL with credentials embedded. Don't open or quote `.env*`, key files, credential
> JSON, keystores or tfstate; the names a config loader expects come from the loader, not the
> secret file. Write `<redacted>` if in doubt. A live-looking secret hard-coded in the source is
> a **security finding to raise with the user for rotation**, not documentation.

**This block is the single source of truth for the rule.** The playbooks, references and
templates point here rather than restating it. The two bundled subagents
(`codebase-recon-scout`, `codebase-doc-verifier`) carry a deliberate standalone copy because a
subagent can't resolve a path into this skill — the repo's verification gate fails the build if
those copies drift from the wording above.

---

## Writing into the target repo

The output lands in a repository this skill doesn't own, so the destination is **agreed, not
assumed** — Phase 0 settles it, and every later phase is bound by the **write contract** in
[`references/output-conventions.md`](./references/output-conventions.md). Follow it; don't
restate it.

---

## Roles

Adopt the role that fits the phase:

- **Recon / synthesis:** act as a Senior Software Engineer + Solution Architect reading
  the system as-is. Understanding existing architecture is in scope; **designing new
  architecture or proposing changes is not**, unless explicitly asked.
- **Interview:** act as a Senior Business Analyst supported by a Product Manager.
  Understand business intent, users, rules and domain language.

---

## Modes

Determine the mode from the user input (default to **full** and confirm):

- **full** — Pre-check → Recon → Interview → Synthesis → Verify. Requires a stakeholder
  (senior BA / Product Owner / SME) to validate findings.
- **code-only** — Pre-check → Recon → Synthesis → Verify, with **no interview**.
  Everything that would need human confirmation is emitted as `[assumption]` /
  `[unverified]` for later validation. Use when no SME is available yet.

State the chosen mode before starting.

---

## Graceful degradation (optional inputs)

At the start of each phase, check what is available and adapt — never hard-fail:

- **Git history** — if a git tool is available, mine it selectively (see recon playbook)
  as a low-weight, low-confidence signal. If not, skip and note it in the recon manifest.
- **Navigation mode (user choice)** — at the start of recon, ask the user whether to
  navigate with grep + sub-agents (default, no setup) or a code-intelligence / LSP server
  (more precise on large repos, needs a configured server). If LSP is chosen but unavailable,
  fall back to grep. The two can be combined. See the recon playbook.
- **Sub-agents** — if the host can run isolated sub-agents, fan out recon reading to keep
  the main context lean. On Claude Code this skill ships two purpose-built subagents —
  **`codebase-recon-scout`** (recon) and **`codebase-doc-verifier`** (verification) — use them
  when available. On other hosts, use whatever generic sub-agent mechanism exists, or run the
  same steps sequentially with disciplined, excerpt-only reading.
- **Stakeholder (SME)** — if none is available, drop from `full` to `code-only` mode.

---

## Working state (resumable, no hooks)

This skill keeps its memory in plain files so it works on any host and resumes across
sessions:

- `docs/_discovery/discovery-state.md` — the evolving memory: facts, assumptions,
  unknowns, decisions, glossary-in-progress. **Read it at the start of every session and
  rewrite it as understanding changes.**
- `docs/_discovery/recon-manifest.md` — the commit recon ran against, which areas and files were
  read, and which existing docs fed it, so later runs can detect staleness (below).

On invocation: if these exist, read them first and resume; do not restart from zero.

`_discovery/` also holds the two audit files (`assumptions-register.md`,
`traceability-index.md`), which are committed alongside the docs they back. What's committed and
what's git-ignored is set out in
[`references/output-conventions.md`](./references/output-conventions.md) — follow it; don't
restate it.

---

## Freshness check (staleness detection — the mechanism, stated only here)

Prior findings are only trustworthy if the code hasn't moved. The check is **commit-based**, not
timestamp-based:

- **Recording (Phase 1).** Put the recon's commit in the manifest: `git rev-parse HEAD`, plus
  whether the working tree was clean (`git status --porcelain`). A dirty tree means the SHA
  doesn't fully describe what was read — say so.
- **Comparing (Phase 0 of a later run).** `git diff --name-only <recorded-sha> HEAD` gives the
  changed files exactly; add `git status --porcelain` for uncommitted work. Intersect that with
  the areas the manifest recorded and re-recon only those.
- **Never compare mtimes.** A fresh clone rewrites every file's timestamp, so a timestamp check
  reports the whole tree as drifted on any machine that didn't run the original recon — which is
  most of them. This is a trap; don't "fix" the check back to timestamps.
- **No git available?** Fall back to hashing just the files the manifest lists as read — a bounded
  set, since recon reads the high-signal subset, not the repo. If hashing isn't possible either,
  record that staleness can't be detected and re-recon the load-bearing areas rather than
  assuming the docs still hold.

### Reporting drift, and what the user can do about it

Report it plainly and usefully — *"12 files changed in the billing area since the last recon at
`a1b2c3d`; `docs/domain/business-rules.md` and `docs/business/workflows.md` draw on that area"* —
naming the **areas** and the **documents that depend on them**, not just a file count. Then offer
the choice, with a recommendation:

- **Re-recon the affected areas** (the default, and what to recommend for most drift) — targeted,
  cheap, and only the affected docs get rewritten.
- **Re-run recon from scratch** — recommend this instead when the drift spans most areas or the
  paths themselves moved, since patching area by area costs more than a clean pass.
- **Proceed as-is** — reasonable when the drift is in areas irrelevant to what the user is doing
  now. Not free: see the flag rule below.
- **Report only** — produce the drift list as a to-do and change nothing. Same flag rule.

If the user declines to re-recon, the affected claims no longer have verified backing: revert them
to `[unchecked]` and log them in the assumptions register, exactly as if they'd come from someone
else's stale documentation — which, as of now, they have. Never leave a claim reading as accepted
when the code beneath it has moved.

Record the decision in the manifest's freshness-check log, so the next session knows this was
chosen rather than missed.

---

## Phases

Run in order. Each has a playbook — read it when you enter the phase.

| Phase | Playbook | Outcome |
|---|---|---|
| 0. Pre-check | [`playbooks/00-pre-check.md`](./playbooks/00-pre-check.md) | Read existing README/CLAUDE.md/AGENTS.md/docs; capture what they state, to verify against the code; set up working state; survey the write target and agree the output root. |
| 1. Deep recon | [`playbooks/01-deep-recon.md`](./playbooks/01-deep-recon.md) | Tiered, evidence-cited analysis of structure, data model, contracts and business-logic hotspots; verify the Phase 0 statements against code. |
| 2. Interview | [`playbooks/02-interview.md`](./playbooks/02-interview.md) | One-question-at-a-time conversation with the BA/PO, seeded by recon hypotheses; reconcile contradictions with code-based suggestions. (Skipped in code-only mode.) |
| 3. Synthesis | [`playbooks/03-synthesis.md`](./playbooks/03-synthesis.md) | Write the lean onboarding docs under `docs/`, each dated and provenance-flagged. |
| 4. Verification | [`playbooks/04-verification.md`](./playbooks/04-verification.md) | Adversarial check that every claim traces to code or a named stakeholder; flag anything unsupported. |
| Finish | (this file) | Doc-drift summary + optionally generate/augment CLAUDE.md/AGENTS.md. |

Do not skip phases. In code-only mode, skip only Phase 2.

---

## Status / provenance model (exception-only)

Do **not** stamp settled knowledge as "confirmed" — accepted knowledge is unmarked, and a flag
means "attention needed here". Exceptions are flagged inline and tracked in
`docs/_discovery/assumptions-register.md`; every substantive claim links to its evidence in
`docs/_discovery/traceability-index.md`.

The vocabulary is exactly five flags — `[unchecked]`, `[unverified]`, `[assumption]`, `[outdated]`,
`[contradicted]` — and inventing a sixth fails the repo's verification gate.

[`references/provenance-and-status.md`](./references/provenance-and-status.md) defines what each
one means, the lifecycle a claim moves through, how flagging works in `code-only` mode, and the
no-invention rule. Follow it; don't restate it.

---

## Finish: doc-drift + agent file

When Phases 0–4 are complete:

1. **Doc-drift summary.** In the completion report, list where existing docs
   (README/CLAUDE.md/AGENTS.md) have drifted from the current code, with the updated statement.
2. **Reconcile contradictions with the user.** For every `[contradicted]` / `[outdated]`
   item, ask the user — one at a time — to confirm the correct version, **including a
   suggested wording derived from the code**. Do not silently pick a version.
3. **Agent file (optional).** Offer to create or augment an agent onboarding file:
   - **Detect and match** whatever already exists (`CLAUDE.md` or `AGENTS.md`).
   - If **neither** exists, offer **both**.
   - Never overwrite an existing file — propose additions (links to the new `docs/`),
     and note anything that no longer matches the current code. Ask before writing.
   - Keep it lean; link the project-root `README.md` as the entry point. See
     [`templates/agent-onboarding-file.md`](./templates/agent-onboarding-file.md).
4. **Working state (`docs/_discovery/`).** Leave the whole directory in place, then apply the
   disposition in [`references/output-conventions.md`](./references/output-conventions.md): the
   two audit files stay committed; **recommend** (never automatically apply) git-ignoring the two
   state files. Explain it in the completion report (below).

---

## Completion report

When done, report:

- Mode used (full / code-only) and what optional inputs were available.
- The system in two or three sentences (what it does, for whom).
- Documents created or updated under the output root — say which were **created**, which were
  **refreshed** from a previous run's output, and which pre-existing files you were given sign-off
  to change.
- Doc-drift findings (existing docs vs code).
- On a re-run: code drift since the last recon, and what the user chose to do about it.
- Open `[assumption]` / `[unverified]` / `[contradicted]` items and their impact.
- Coverage gaps: any claim still `[unchecked]` because its area was outside recon scope.
- Whether a `CLAUDE.md` / `AGENTS.md` was created or proposed.
- **`docs/_discovery/` disposition** per output-conventions: which files you're recommending be
  git-ignored, and that the audit files (assumptions register, traceability index) are committed
  because the docs they back are. Warn that deleting the state files makes the next run
  **start cold** — no resume, no staleness detection.
- Readiness for harness engineering / Spec Kit.

---

## Done when

- [ ] Mode and available inputs established
- [ ] Write target surveyed and output root agreed with the user (docs-site tooling and existing
      files at the target paths identified)
- [ ] Existing docs read and their statements captured for verification
- [ ] Recon complete: structure, data model, contracts, business-logic hotspots
- [ ] Existing-doc statements verified against code (any drift identified)
- [ ] (full mode) Interview complete; contradictions reconciled with the user
- [ ] Onboarding docs written under `docs/`, dated and provenance-flagged
- [ ] Verification pass complete; unsupported claims flagged
- [ ] Assumptions register and traceability index populated
- [ ] CLAUDE.md / AGENTS.md created or proposed
- [ ] docs/_discovery/ disposition explained per output-conventions (audit files committed, state files git-ignore recommended, cold-start cost flagged)
- [ ] Ready for harness engineering / Spec Kit
