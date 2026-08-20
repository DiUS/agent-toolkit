# Phase 2 — Interview

**Role:** Senior Business Analyst, supported by a Product Manager.
**Goal:** Validate the recon hypotheses and recover the **why** the code can't tell you —
intent, business rules, edge cases, and domain language — through a real conversation.

*Skipped in code-only mode.* In code-only mode, everything that would be confirmed here stays
`[unverified]` / `[assumption]`.

Entered directly by `--interview` when continuing a stopped queue, subject to that option's limits in
`SKILL.md`.

---

## Conversation rules (non-negotiable)

- **One question at a time.** Ask a single question, then wait for the answer.
- **Follow up on the answer.** Let each response shape the next question; dig where it's
  unclear, vague, or surprising.
- **Never present a questionnaire** or a batch of questions.
- **Seed every question with evidence.** Because recon ran first, ask to *validate*, not to
  fish: "The code applies a 2% fee when an account is overdue by 30+ days
  (`billing/fees.rb:44`). Is that the intended rule, and why 30 days?"
- **Confirm understanding before moving on** to a new area. Play back what you heard.
- **Capture, don't assume.** If something isn't confirmed, it stays flagged.

Use [`../references/question-bank.md`](../references/question-bank.md) for seed questions per
area — but adapt to what recon actually found.

---

## The queue — highest impact first

The stakeholder's attention is the scarcest input in this whole skill, so it goes to the questions
whose wrong answers cost the most. Don't work through the coverage areas in order.

**Ranking.** Take the open items from `docs/_discovery/assumptions-register.md` and sort by
**impact if wrong (descending), then confidence (ascending)**. A high-impact/low-confidence item
always outranks a high-impact/high-confidence one; a low-impact item never jumps the queue however
shaky it looks.

**Show the top 5.** Open the interview by showing the five that rank highest, in order, each with
its evidence and one line on why it matters — then keep the list in
`discovery-state.md` and refresh it every time an item is resolved or parked, so the next one
surfaces.

> Showing the list is **not** asking five questions. It's the agenda, so the stakeholder can see
> what you think matters and redirect you if they disagree — which is itself valuable. Then ask
> about **#1 only** and wait. Every conversation rule above still applies.

If the stakeholder reorders the list or adds something not on it, follow them: they know things the
register doesn't. Record the change of priority.

**Where areas have different owners, group the queue by who can answer.** Nobody knows a large system
end to end, and a top-5 that spans four owners can't be worked in one conversation. Sort within the
person in front of you, keep the rest for whoever owns it, and record in `discovery-state.md` which
SME covered which area so a later session doesn't re-ask them. The register's *who can confirm* column
is what makes this possible — an item with nobody against it doesn't get actioned.

**Offer an off-ramp at a seam the queue produces.** Two of them: when the top 5 has fully turned
over — every item from the last agenda resolved or parked — and when the person in front of you has
no items left. At either, say what's been covered, show the refreshed top 5, and ask whether to carry
on now or pick it up later. Don't ask more often than that — the refreshed list already shows the
stakeholder what's left, and repeatedly checking in reads as reluctance.

---

## Reconcile contradictions (important)

For every `[outdated]` or `[contradicted]` item from recon/pre-check, raise it with the user
**one at a time**, and always offer a code-derived suggested correction:

> "The README says refunds are handled by the billing service, but the code routes them
> through `payments/refunds/*` (`payments/refunds/handler.py:20`). I'd suggest the correct
> statement is: *refunds are owned by the Payments service*. Confirm, or adjust?"

On the user's confirmation, the item becomes accepted knowledge (unmarked) — record it in
`discovery-state.md` like any other fact, with the evidence and who confirmed it. Its traceability
row follows in Phase 3, when the claim reaches a doc. Do not silently pick a version.

---

## Coverage checklist — not a running order

Seven things to have touched by the end, used to spot what the queue never reached. The **queue**
decides what gets asked and when; this list only tells you where the gaps are.

1. **Business context & purpose** — why the system exists, what problem it solves, for whom.
2. **Users & stakeholders** — who uses it, who owns the processes, who's impacted.
3. **Domain language** — confirm the meaning of terms found in code (entities, enums,
   error messages). Resolve synonyms and conflicts; capture agreed definitions.
4. **Business rules** — validate the rules recon inferred; surface the ones code can't show
   (policy, regulation, "we always do X because…"), and the exceptions.
5. **How rules and flows group** — recon can only group them the way the code does, and that carve-up
   becomes the shape of the docs, so it's worth confirming explicitly: *"the code keeps these five
   rules together in `InvoicePolicy` — is that how the business thinks about them, or do some belong
   elsewhere?"* A confirmed grouping gets renamed to the agreed term; an unconfirmed one stays
   `[unverified]`.
6. **Workflows** — walk the key end-to-end flows: actors, triggers, states, decision points,
   exceptions/edge cases, hand-offs, SLAs.
7. **Requirements & constraints** — the outcomes the system must deliver, plus
   non-functional and compliance constraints (performance, availability, security,
   auditability, data handling, regulatory).

---

## Maintain working state as you go

After each meaningful exchange, update `docs/_discovery/discovery-state.md`:

- **Facts** — accepted (unmarked) knowledge, with source = the stakeholder (+ any code
  evidence).
- **Assumptions** — inferred but not confirmed; record why and the impact if wrong.
- **Unknowns / open questions** — prioritised by business, user, compliance, delivery impact.
- **Decisions** — with context and who validated them.
- **Glossary-in-progress** — terms, agreed meanings, related concepts.

Record who confirmed each fact (source/owner), and flag where different stakeholders
disagree.

Updating after **each** exchange is what makes stopping safe: if the stakeholder disappears
mid-conversation, everything up to that point is already recorded.

---

## Stopping, and resuming later

The interview ends when the queue is empty **or when the stakeholder decides it does.** Their time,
their call.

- **Say so once, up front**, before the first question: *"Stop whenever you like — say so and I'll
  record where we got to; we can pick this up in a later session."* Once is enough.
- **Recognise a stop for what it is.** "That's enough for now", "I need to go", "park the rest",
  "let's finish tomorrow", or several "I don't know"s in a row are all stops. Never treat one as an
  answer to the pending question, never argue, and never squeeze in one more question.
- **Park what's left, don't assume it.** Unasked items keep their flags and stay in
  `assumptions-register.md` with *needs SME* as the next step. They are not downgraded to accepted
  knowledge because nobody got to them.
- **Hand off clearly** rather than just stopping: what was covered, what's parked (name the
  highest-impact ones), and where it's recorded. Then ask the one question that remains — **proceed
  to synthesis now with the gaps flagged, or end the session here?** Both are valid.
- **Stopping the interview is not stopping the run.** Synthesis can write good onboarding docs from
  partial validation, as long as the gaps are flagged. Never abandon the run because the interview
  ended early.
- **Record where you stopped** in `discovery-state.md` (items addressed, items open), and tell the
  user how to come back: invoke the skill again and it resumes here — Phase 0 reads the state and
  re-enters at this phase rather than re-running recon. Continuing later in the *same* session
  needs no re-invocation; just pick the queue back up.

---

## Exit criteria

- Queue worked in impact order, **or** the stakeholder stopped and the remainder is parked in the
  register as *needs SME*.
- Contradictions/outdated items reconciled with confirmed, code-grounded wording — or parked.
- Coverage checklist reviewed: areas the queue never reached are named, not silently skipped.
- Stopping point recorded in `discovery-state.md` so a later session resumes rather than restarts.
- Working state current. Ready for synthesis.
