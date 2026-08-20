# Phase 5 — Finish

**Role:** Senior Software Engineer, handing over.
**Goal:** Close the loop — tell the user where their existing documentation had drifted, settle the
contradictions that need a human, and leave the repo set up so the next agent (or joiner) lands
somewhere useful.

Enter this once Phases 0–4 are complete. The completion report itself is specified in `SKILL.md`.

---

## 1. Doc-drift summary

List where the existing docs (`README`, `CLAUDE.md`, `AGENTS.md`, anything under `docs/`) have
drifted from the current code, each with the corrected statement derived from the code. This is the
payload of the whole exercise for a team that thought its docs were fine.

## 2. Reconcile contradictions with the user

For every `[contradicted]` / `[outdated]` item **still flagged** after recon and the interview, ask
the user — **one at a time** — to confirm the correct version, always including a **suggested wording
derived from the code**. Do not silently pick a version. Items Phase 2 already reconciled are
settled; don't re-walk them.

On confirmation a doc-vs-code item becomes accepted knowledge (unmarked), with the evidence recorded
— the code is what settles it, so whoever is here can. An item that turns on intent, policy or
ownership is a different matter: unless the person confirming owns it, it stays flagged and stays in
the register as *needs SME*, per
[`../references/provenance-and-status.md`](../references/provenance-and-status.md). This is the usual
case in `code-only` mode.

## 3. Agent file (optional)

Offer to create or augment an agent onboarding file:

- **Detect and match** whatever already exists (`CLAUDE.md` or `AGENTS.md`).
- If **neither** exists, offer **both**.
- Never overwrite an existing file — propose additions (links to the new docs), and note anything in
  it that no longer matches the current code. Ask before writing.
- Keep it lean; link the project-root `README.md` as the entry point. See
  [`../templates/agent-onboarding-file.md`](../templates/agent-onboarding-file.md).

## 4. Working state disposition

Leave the whole `_discovery/` directory in place, then follow the disposition in
[`../references/output-conventions.md`](../references/output-conventions.md) as written. Explain the
outcome in the completion report.

---

## Exit criteria

- Doc-drift summary produced, each item with a code-derived corrected statement.
- Every `[contradicted]` / `[outdated]` item either confirmed by the user or left flagged — none
  silently resolved.
- Agent file created, augmented or offered; nothing overwritten without sign-off.
- `_discovery/` left in place and its disposition explained.
- Completion report delivered as specified in `SKILL.md`.
