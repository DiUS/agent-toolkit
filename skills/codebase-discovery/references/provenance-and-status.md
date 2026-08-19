# Provenance & status model

How claims are tracked from "found in code" to "accepted onboarding knowledge" — and how the
exceptions are flagged so a reader knows what not to trust yet.

---

## The rule: exception-only flagging

**Accepted knowledge is unmarked.** Do not stamp settled facts as "confirmed" — that just adds
noise to every line. A reader should be able to assume that unflagged statements are accepted
current-state knowledge, and that **any flag means "attention needed here."**

These five flags exist, and no others:

| Flag | Meaning | Where it lives |
|---|---|---|
| `[unchecked]` | Harvested from an existing doc, not yet compared with the code | discovery state; register if it persists |
| `[unverified]` | Not validated by a person — code-derived, or a doc claim the code can't settle | inline + assumptions register |
| `[assumption]` | Inferred, not directly evidenced; record why + impact if wrong | inline + assumptions register |
| `[outdated]` | An existing doc/claim the code shows is no longer true | assumptions register + doc-drift summary |
| `[contradicted]` | Two sources disagree, unresolved | assumptions register |

There is intentionally **no `confirmed` flag**, and no others may be invented — a flag the
reader hasn't been taught is just noise.

### `[unchecked]` vs `[unverified]`

These are the two easiest to conflate, and keeping them apart is what makes `[unverified]` mean
something:

- `[unchecked]` — **nobody has looked at the code yet.** It's what an existing doc asserts,
  captured verbatim in Phase 0 so Phase 1 can test it.
- `[unverified]` — **somebody has looked**, and the claim is unconfirmed by a *person* rather
  than untested. Either the code supports it and no stakeholder has signed it off, or the code
  can't speak to it at all (intent, policy, ownership) and only a person could settle it.

Only the second is safe to act on with care; the first tells you nothing has been assessed. If
they shared a flag a reader couldn't tell "untested" from "tested but unconfirmed".

### When an `[unchecked]` claim can't be checked

Phase 1 re-statuses every `[unchecked]` claim it can. Two ways it legitimately can't:

- **The code can't settle it** — the claim is about intent, rationale, policy or ownership. It
  becomes `[unverified]` and goes to the interview; a person is the only thing that can resolve
  it. This is the normal outcome, not an exception.
- **Recon never reached it** — the claim concerns an area outside the run's scope, or a deep dive
  that was deferred. It **stays `[unchecked]`**: pretending otherwise would claim an assessment
  that didn't happen. Record it in `assumptions-register.md` as *unresolved — outside recon
  scope*, with the area it belongs to, and name it in the completion report.

A persisting `[unchecked]` claim is a scope statement, not a finding. Prefer leaving that
statement out of the onboarding docs entirely; publish it only if a reader genuinely needs it,
flagged, so nobody mistakes an unexamined doc claim for something the code was checked against.

---

## Lifecycle of a claim

```
Phase 0: harvested from existing docs        → [unchecked]
Phase 1: checked against code
            matches code                      → accepted (unmarked) + evidence recorded
            code says otherwise               → [outdated] (+ code-derived suggestion)
            sources disagree                  → [contradicted]
            code can't settle it              → [unverified], carried to interview
            area outside recon scope           → stays [unchecked], logged as out-of-scope
         found in the code (no prior doc)     → [unverified]
Phase 2: stakeholder confirms/corrects        → accepted (unmarked), source = stakeholder
            stakeholder can't confirm          → stays [assumption]/[unverified]
Phase 4: any accepted claim without evidence   → demoted back to [assumption] or removed
```

Accepted knowledge always has a backing entry in the traceability index — either a code location
or a named stakeholder (or both).

---

## Flagging in `code-only` mode

In `code-only` mode nothing has been validated by a person, so a literal reading of the model
would flag `[unverified]` on virtually every sentence — which destroys the signal the
exception-only rule exists to create. Instead:

- **Say it once, in the header.** The document's `Status` line carries the caveat for the whole
  file: *code-derived, not validated by a person.* The reader learns it before the first
  sentence and doesn't need reminding per line.
- **Reserve inline flags for load-bearing uncertainty** — a claim where a reader who acted on it
  could get it materially wrong (a business rule, a threshold, a permission, an SLA). Not
  descriptive statements the code plainly supports.
- **The register stays complete.** Nothing is lost by not stamping inline: every open item is in
  `assumptions-register.md` either way, and that's the list to work through.

The same judgement applies in `full` mode to anything the stakeholder couldn't confirm.

---

## Traceability index

`docs/_discovery/traceability-index.md` maps each substantive claim to its evidence. This
keeps citations **out of** the onboarding prose (which stays lean) while preserving the audit
trail. Reference it by claim ID from a doc only when a reader is likely to want the proof.

Recommended row: `claim-id | claim (short) | source (path:line / stakeholder) | confidence`.

---

## Assumptions register

`docs/_discovery/assumptions-register.md` is the single list of everything still needing
attention: every `[assumption]`, `[unverified]`, `[outdated]`, `[contradicted]` item, with why
it matters and the impact if wrong. It drives the interview and the doc-drift summary, and it
is the first thing to resolve before relying on the docs for a change.

---

## No invention (the rule — stated only here)

If a statement isn't in the code and hasn't been confirmed by a person, it either carries a flag
or it doesn't get written. **Never invent a business rule**, a threshold, an actor, an SLA or a
rationale to fill a gap in the story — a plausible-sounding rule is worse than an admitted gap,
because the next reader acts on it and nothing in the repo contradicts them.

Where the code shows *what* but not *why*, that's an `[assumption]` with the evidence and the
question, not a guess dressed as a finding.

---

## Confidence

Where useful, annotate High/Med/Low alongside a flag — especially on `[assumption]` items —
so the highest-impact, lowest-confidence items get validated first.
