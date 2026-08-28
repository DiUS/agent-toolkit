# Phase 4: Verification

**Role:** Code Reviewer (adversarial).
**Goal:** Hold the **generated** onboarding docs to a high bar. Treat each claim as unproven
until it traces to code evidence or a named stakeholder; anything unsupported gets flagged,
not published as fact.

Run this as an **isolated pass**, in a sub-agent where available, so the check is independent
of the work that produced the docs. On Claude Code, dispatch the **`codebase-doc-verifier`**
subagent; on other hosts use any generic sub-agent, or run the checks directly.

A sub-agent doesn't know where this skill is installed, so skill-relative paths mean nothing to it.
State the checks in the dispatch prompt, and for each one that leans on a file in this skill, either
pass an **absolute** path or put the substance in the prompt. The checks below reach for
`references/output-conventions.md` (layout, naming, ceilings), `references/provenance-and-status.md`
(the flags) and `references/write-contract.md`. The secrets rule is the exception: the bundled
`codebase-doc-verifier` carries a synced copy, so only a generic sub-agent needs it pasted from
`SKILL.md` verbatim.

> **Prediction rule** (`SKILL.md`): verify what the docs **claim**, not what you suspect is wrong.
> Scoping the check to your own hypotheses is how a defect survives a passing verification.

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
   both the doc and the assumptions register. Check each flag against what it means in
   [`../references/provenance-and-status.md`](../references/provenance-and-status.md); that file
   lists the causes, so don't judge them from a shorter list. No flag outside the five it defines.
   In `code-only` mode, confirm the caveat is in each `Status` header line rather than stamped
   over every sentence.

5. **Onboarding-lean, and scaffolding stripped.** Flag bloat: content that fails the "does this
   make a new joiner productive?" test, duplicated content across files, or docs exceeding the
   length ceilings in output-conventions. Also flag any leftover template scaffolding, meaning
   `<!-- -->` guidance comments or unfilled `<placeholder>` markers.

6. **Freshness & consistency.** Every doc **in the `docs/` set** has a `Last updated` date; the
   recon manifest reflects the files actually read; terminology matches the glossary across all
   docs. The project-root `README.md` and the agent file are exempt by design (output-conventions
   says why), so don't add one to either.

   **Every link resolves.** Check each link in the `docs/` set, the project-root `README.md` and the
   agent file points at a file that exists. Skipped documents are the usual culprit, since the
   index templates list the full set.

   **The glossary is one file.** Exactly one `domain-glossary.md`, at `domain/`, with no per-area
   variant beside it, and every term carrying an area or `cross-cutting`. A second glossary hides
   the cross-area clashes the single file exists to surface.

   **Names use the agreed language.** Area directories and concept filenames are glossary terms, not
   namespaces or codenames, with no catch-alls (`misc`, `other`, `general`). A file that couldn't be
   named specifically usually means the split was wrong. No output file is named `business-rules.md`
   or `workflows.md`; those are template names, and finding one means the split was skipped.

   **Groupings are evidenced, not invented.** A cluster named in business language must trace to a
   stakeholder who confirmed it; otherwise it should be named after the code unit and flagged
   `[unverified]`. An invented carve-up is worse than a technical one, because it becomes the
   structure everyone inherits.

7. **Markdown structure holds.** Check the source of every table: a header separator row directly
   below the header, and no blank line between rows. A blank line ends a Markdown table, so every
   row after it renders as literal pipe text. Confirm fences are balanced and any diagram block is
   well-formed. A register whose rows don't render is unusable however accurate it is, and no check
   that only reads content will catch it.

8. **Write contract honoured.** Check the output against
   [`../references/write-contract.md`](../references/write-contract.md), using the root, nav decision
   and pre-existing-file list Phase 0 recorded in `discovery-state.md`.

9. **Drift captured.** Every place existing docs (README/CLAUDE.md/AGENTS.md) contradicted the code
   is recorded in `docs/_discovery/assumptions-register.md` with a code-derived corrected statement.
   That register is what Phase 5 turns into the doc-drift summary, so it's the artefact to check
   here; the summary itself doesn't exist yet.

---

## Output

Produce a short verification report:

- Claims checked; count supported vs demoted/removed.
- Any invented or unsupported statements found and how they were handled.
- Open `[assumption]` / `[unverified]` / `[contradicted]` items and their impact, plus any
  `[unchecked]` claims and why each is still unchecked.
- Bloat or duplication trimmed.
- Go / no-go for harness engineering / Spec Kit, with any caveats.

---

## What counts as material, and what to do about it

"Send it back" needs a threshold, or verification either waves real problems through or loops.

**Material, so the docs must not ship as they are:**

- an invented claim, or an accepted (unmarked) statement with no evidence behind it
- a leaked credential value (check 3)
- a write-contract breach: written outside the agreed root, or a file overwritten without sign-off
- a claim carrying real weight (rule, threshold, permission, SLA) with no traceability entry
- a flag that misrepresents reality: a claim reading as accepted where the code has moved on, or a
  flag whose meaning doesn't match why it's there

**Not material, so fix in place and carry on.** Bloat, duplication, a missing `Last updated`,
terminology drifting from the glossary, leftover scaffolding, a dead link. Edits, not grounds for a
round trip.

**One rework cycle, then stop.** Route material problems to where they can be fixed (synthesis for
anything the code can settle, the interview only where it genuinely needs a person) and re-verify
**only the affected documents**, not the whole set. If a second pass still finds material problems,
stop and report **no-go** with the specific unresolved items rather than starting a third lap.

---

## Exit criteria

- Every published claim is supported or explicitly flagged.
- No invented business rules remain.
- No credential values appear anywhere in the docs.
- Every drift item captured in the register with a corrected statement; register reconciled.
- Verification report written. Ready for the finish step (doc-drift + agent file).
