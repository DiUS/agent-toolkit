# Phase 4 — Verification

**Role:** Code Reviewer (adversarial).
**Goal:** Hold the **generated** onboarding docs to a high bar — treat each claim as unproven
until it traces to code evidence or a named stakeholder; anything unsupported gets flagged,
not published as fact.

Run this as an **isolated pass** — a sub-agent where available — so the check is independent
of the work that produced the docs. On Claude Code, dispatch the **`codebase-doc-verifier`**
subagent; on other hosts use any generic sub-agent, or run the checks directly.

A sub-agent doesn't know where this skill is installed, so skill-relative paths mean nothing to
it: state the checks and the length ceilings in the dispatch prompt, or pass an **absolute**
path to `references/output-conventions.md`.

---

## Checks

1. **Traceability.** For each substantive claim in the `docs/` set, confirm there is an entry
   in `docs/_discovery/traceability-index.md` pointing to real code (`path:line` / symbol) or
   a named stakeholder. Spot-check the citations actually say what the doc claims.

2. **No unsupported facts.** Any statement with neither code evidence nor stakeholder
   confirmation must be demoted to `[assumption]` / `[unverified]` or removed. In particular,
   check that no business rule was invented.

3. **No leaked secrets.** Check the `docs/` set against the secrets rule in
   [`../SKILL.md`](../SKILL.md). Any breach is **blocking**: strip it from the docs and raise it
   with the user for rotation.

4. **Exception flags are honest.** Ensure accepted (unmarked) statements really are settled, and
   that every known `[outdated]` / `[contradicted]` item is either resolved or clearly flagged in
   both the doc and the assumptions register. Check the flags are the right ones: `[unchecked]`
   only where an area genuinely wasn't assessed (and logged as out-of-scope), `[unverified]` where
   it was. No flag outside the five in provenance-and-status.
   In `code-only` mode, confirm the caveat is in each `Status` header line rather than stamped
   over every sentence.

5. **Onboarding-lean, and scaffolding stripped.** Flag bloat: content that fails the "does this
   make a new joiner productive?" test, duplicated content across files, or docs exceeding the
   length ceilings in output-conventions. Also flag any leftover template scaffolding — `<!-- -->`
   guidance comments or unfilled `<placeholder>` markers.

6. **Freshness & consistency.** Every doc has a `Last updated` date; the recon manifest
   reflects the files actually read; terminology matches the glossary across all docs.

   **Every link resolves.** Check each link in the `docs/` set, the project-root `README.md` and the
   agent file points at a file that exists — skipped documents are the usual culprit, since the
   index templates list the full set.

   **Names use the agreed language.** Area directories and area filenames are glossary terms, not
   namespaces or codenames, with no catch-alls (`misc`, `other`, `general`). A file that couldn't be
   named specifically usually means the split was wrong.

7. **Write contract honoured.** Check the output against the write contract in
   [`../references/output-conventions.md`](../references/output-conventions.md), using the root,
   nav decision and pre-existing-file list Phase 0 recorded in `discovery-state.md`.

8. **Drift captured.** The doc-drift summary lists every place existing docs
   (README/CLAUDE.md/AGENTS.md) contradicted the code, each with a corrected statement.

---

## Output

Produce a short verification report:

- Claims checked; count supported vs demoted/removed.
- Any invented or unsupported statements found and how they were handled.
- Open `[assumption]` / `[unverified]` / `[contradicted]` items and their impact, plus any
  `[unchecked]` claims left because their area was out of recon scope.
- Bloat or duplication trimmed.
- Go / no-go for harness engineering / Spec Kit, with any caveats.

---

## What counts as material, and what to do about it

"Send it back" needs a threshold, or verification either waves real problems through or loops.

**Material — the docs must not ship as they are:**

- an invented claim, or an accepted (unmarked) statement with no evidence behind it
- a leaked credential value (check 3)
- a write-contract breach — written outside the agreed root, or a file overwritten without sign-off
- a load-bearing claim (rule, threshold, permission, SLA) with no traceability entry
- a flag that misrepresents reality — `[unchecked]` on something that was checked, or nothing where
  the code has moved on

**Not material — fix in place and carry on.** Bloat, duplication, a missing `Last updated`,
terminology drifting from the glossary, leftover scaffolding, a dead link. Edits, not grounds for a
round trip.

**One rework cycle, then stop.** Route material problems to where they can be fixed — synthesis for
anything the code can settle, the interview only where it genuinely needs a person — and re-verify
**only the affected documents**, not the whole set. If a second pass still finds material problems,
stop and report **no-go** with the specific unresolved items rather than starting a third lap. An
honest no-go is a useful result; an endless loop isn't.

---

## Exit criteria

- Every published claim is supported or explicitly flagged.
- No invented business rules remain.
- No credential values appear anywhere in the docs.
- Drift summary complete; assumptions register reconciled.
- Verification report written. Ready for the finish step (doc-drift + agent file).
