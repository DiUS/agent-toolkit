# Provenance and status model

How claims are tracked from "found in code" to "accepted onboarding knowledge", and how the
exceptions are flagged so a reader knows what not to trust yet.

---

## The rule: exception-only flagging

**Accepted knowledge is unmarked.** Do not stamp settled facts as "confirmed", which just adds
noise to every line. A reader should be able to assume that unflagged statements are accepted
current-state knowledge, and that **any flag means "attention needed here."**

These five flags exist, and no others:

| Flag | Meaning | Where it lives |
|---|---|---|
| `[unchecked]` | No current code check behind it — harvested from a doc and not yet compared, or the code has moved since it was | discovery state; register if it persists |
| `[unverified]` | Not validated by a person — code-derived, or a doc claim the code can't settle | inline + assumptions register |
| `[assumption]` | Inferred, not directly evidenced; record why + impact if wrong | inline + assumptions register |
| `[outdated]` | An existing doc/claim the code shows is no longer true | assumptions register + doc-drift summary |
| `[contradicted]` | Two sources disagree, unresolved | assumptions register |

There is intentionally **no `confirmed` flag**, and no others may be invented, because a flag the
reader hasn't been taught is just noise.

### `[unchecked]` vs `[unverified]`

These are the two easiest to conflate, and keeping them apart is what makes `[unverified]` mean
something:

- `[unchecked]` — **no current code check.** Either nobody has compared it yet (what an existing
  doc asserts, captured word for word in Phase 0 so Phase 1 can test it), or the check it once had
  is stale because the code moved.
- `[unverified]` — **somebody has looked**, and the claim is unconfirmed by a *person* rather
  than untested. Either the code supports it and no stakeholder has signed it off, or the code
  can't speak to it at all (intent, policy, ownership) and only a person could settle it.

Only the second is safe to act on with care; the first tells you nothing currently backs it. If
they shared a flag a reader couldn't tell "no current code check" from "checked, but unconfirmed by
a person".

### When a claim legitimately carries `[unchecked]`

Phase 1 re-statuses every `[unchecked]` claim it can. Two ways it legitimately can't, and one way
the flag comes back later:

- **The code can't settle it** — the claim is about intent, rationale, policy or ownership. It
  becomes `[unverified]` and goes to the interview; a person is the only thing that can resolve
  it. This is the normal outcome, not an exception.
- **Recon hasn't reached it yet** — its area is still pending in the coverage ledger, or a deep dive
  was deferred to a later session. It **stays `[unchecked]`**: pretending otherwise would claim an
  assessment that didn't happen. Record it in `assumptions-register.md` as *unresolved, area not yet
  covered*, with the area it belongs to, and name it in the completion report.
- **The code moved under it** — a later run's freshness check found drift and the user chose not to
  re-recon, so a claim that *was* verified no longer has a current code check behind it. It goes
  **back** to `[unchecked]`; the mechanism is in [`freshness.md`](freshness.md).

A persisting `[unchecked]` claim is a statement about what's been checked, not a finding. Prefer
leaving that statement out of the onboarding docs entirely; publish it only if a reader genuinely
needs it, flagged, so nobody mistakes it for something the code was checked against.

---

## Coverage states (the vocabulary, stated only here)

A flag describes a claim. **A coverage state describes an area**, and the two interlock: a claim in
an area recon never dived into has no current code check behind it, which is the second
`[unchecked]` cause above.

Phase 1 records one per area in the recon manifest's coverage ledger. The set is closed, on the same
terms as the flags:

| State | Means | Area docs expected |
|---|---|---|
| `full` | data model, contracts, hotspots and tests all worked | yes |
| `map only` | Tier 0 map only, dives judged not warranted | no; named in the architecture doc |
| `excluded` | the user excluded these paths, so nothing was read | no; named in the architecture doc |
| `pending` | not yet reached | no |

**Every area reaches the reader carrying its state.** Anything but `full` is a declared gap, and it
travels: the ledger, then the entry point's area list, then the completion report. Phase 4 checks
the entry point against the ledger.

`pending` already travels, and it's the honest gap. `map only` and `excluded` are the ones that
mislead, because the area is named in `current-architecture.md` and looks covered when nothing sits
behind it. That is the failure the synthesis playbook's partial-publish rule exists to stop.

---

## Lifecycle of a claim

```
Phase 0: harvested from existing docs        → [unchecked]
Phase 1: checked against code
            matches code                      → accepted (unmarked) + evidence recorded
            code says otherwise               → [outdated] (+ code-derived suggestion)
            sources disagree                  → [contradicted]
            code can't settle it              → [unverified], carried to interview
            area not yet covered               → stays [unchecked], logged as pending
         found in the code (no prior doc)     → [unverified]
Phase 2: stakeholder confirms/corrects        → accepted (unmarked), source = stakeholder
            stakeholder can't confirm          → stays [assumption]/[unverified]
Phase 4: any accepted claim without evidence   → demoted back to [assumption] or removed
Later run: drift, user declines re-recon      → accepted claim reverts to [unchecked]
```

Accepted knowledge always has a backing entry in the traceability index: either a code location
or a named stakeholder (or both).

---

## Flagging in `code-only` mode

In `code-only` mode nothing has been validated by a person, so a literal reading of the model
would flag `[unverified]` on virtually every sentence, which destroys the signal the
exception-only rule exists to create. Instead:

- **Say it once, in the header.** The document's `Status` line carries the caveat for the whole
  file: *code-derived, not validated by a person.* The reader learns it before the first
  sentence and doesn't need reminding per line.
- **Reserve inline flags for uncertainty that carries weight:** a claim where a reader who acted on
  it could get it materially wrong (a business rule, a threshold, a permission, an SLA). Not
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

**A claim gets its row as it's written, not reconstructed afterwards.** Whoever writes a claim into a
doc adds the row at that moment, while the evidence is in front of them. A batch reconstructed from
memory at the end produces rows nobody can check, and it's the failure Phase 4's first check exists
to catch. IDs run sequentially and stay stable across runs, so a doc that cites one keeps pointing
at the same claim.

**A claim that already carries an ID keeps it.** `C-n` is for claims this index mints. Requirements
arrive with their own from `business-requirements.md`, so index them as `FR-n` / `NFR-n` rather than
minting a second ID for the same statement, which would leave two rows nobody can reconcile.

Substantive claims get a row as the norm. For a claim that **carries real weight** (a rule,
threshold, permission, SLA or ownership statement) it isn't optional: Phase 4 treats a missing entry
there as material.

---

## Assumptions register

`docs/_discovery/assumptions-register.md` is the single list of everything still needing
attention: every `[assumption]`, `[unverified]`, `[outdated]`, `[contradicted]` item, with why
it matters and the impact if wrong. It drives the interview and the doc-drift summary, and it
is the first thing to resolve before relying on the docs for a change.

---

## No invention (the rule, stated only here)

If a statement isn't in the code and hasn't been confirmed by a person, it either carries a flag
or it doesn't get written. **Never invent a business rule**, a threshold, an actor, an SLA or a
rationale to fill a gap in the story. A plausible-sounding rule is worse than an admitted gap,
because the next reader acts on it and nothing in the repo contradicts them.

Where the code shows *what* but not *why*, that's an `[assumption]` with the evidence and the
question, not a guess dressed as a finding.

---

## Confidence (the calibration, stated only here)

Annotate High/Med/Low alongside a flag, especially on `[assumption]` items, so the
highest-impact, lowest-confidence items get validated first. It's also what the interview queue
sorts on.

Two things set it, and the lower of the two wins.

**How clearly the code states it:**

- **High** — behaviour is explicit and centralised: a single validation, a clear state machine, a
  documented enum.
- **Medium** — behaviour is spread across several places, or inferred from naming.
- **Low** — inferred from a comment or an ambiguous name, with nothing corroborating it.

**How the finding was obtained** (see the tier ladder in [`navigation.md`](navigation.md)):

- **High** — a declared source or a resolved symbol: a manifest, the repo's own toolchain, an LSP or
  AST query. The build system saying two modules are related is a fact.
- **Medium at best** — structure inferred from text patterns. Grepping imports can be wrong in both
  directions: a project can reference what it never uses, and DI or reflection couples things no
  import shows.
- Where a text-inferred claim **carries real weight** (a boundary, a rule, a permission) it's an
  `[assumption]`, not a Medium-confidence fact.

Recording the tier in the recon manifest is what makes this auditable later: a doc reads identically
whether its boundaries came from the build graph or from pattern-matching, so the manifest is the
only place that difference survives.
