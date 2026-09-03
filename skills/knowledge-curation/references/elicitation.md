# Elicitation

Ask throughout curation, not at the end. Extract-then-ask leaves questions
unasked. The point is turning `basis: inferred`/`assumed` into `basis: stated`.

**The failure mode this skill exists to prevent:** creating question files
without ever asking the user in chat. Writing a question in a file is not
asking. The user must see the question in the conversation and respond.
Everything below assumes that basic contract.

Conversation rules live in `SKILL.md` — don't repeat them here.

## When to ask

| Step | Ask about |
|------|-----------|
| 2 — read | Confusing passages, unclear terminology |
| 3 — identify | Domain or feature if uncertain |
| 4 — map | Sections that don't fit templates, generic-heading grouping |
| 6 — extract | Any gap that changes how you write the current file |
| 6.5 — review | Residual only. Bulk here means you deferred too much |

## Interview protocol

Elicitation is a conversation, not a form. The turn structure is:

1. **You** — one question in chat. Not two. Not three. One.
2. **User** — responds.
3. **You** — read the response. Is it clear, specific, complete?
   - **Clear** → fold into the curated content (`basis: stated`), close or
     create the OQ as a record, move to the next gap.
   - **Vague, incomplete, surprising, or opens a new question** → ask ONE
     follow-up. Repeat step 2 — but see the depth limit below.
4. Move on only when the answer is usable, **or the depth limit is hit.** Then
   next question.

### Termination budget (elicitation must be able to exit)

Ask-immediately and never-defer are about *when* to ask, not licence for an
unbounded loop. Three hard limits keep a run finite:

- **Follow-up depth: at most 2 follow-ups on one gap.** If a third would be
  needed — the answer is still vague, or every answer is "it depends" — stop
  following up. Record what you have: set the curated entry `basis: assumed`
  (or `inferred` if you're reasoning from stated facts), raise/keep the OQ at
  `status: open`, note the residual ambiguity in the OQ Context, and move to
  the next gap. This is the escape hatch — a gap that won't close is captured,
  not chased.
- **Per-run question budget: check in every 20 questions.** Count the questions
  you've actually asked in chat this run. On hitting 20 (then 40, …), stop and
  ask the user plainly: "We've covered 20 questions — want to keep going, or
  park the rest as `status: open` and wrap up what we have?" Honour the answer.
  Parked gaps become `status: open` OQs with `basis: assumed`/`inferred` on any
  affected entry, exactly like the depth-limit escape.
- **No re-asking a parked gap.** Once a gap is escaped or parked, it stays
  `open` — step 6.5 records it, it does not reopen the same question.

**What this looks like — a real exchange:**

> Agent: "The spec mentions account status requirements for transfer
> eligibility but doesn't list the values. What statuses are required — is it
> just Active, or are there others like Funded?"
>
> User: "Active and Funded."
>
> Agent: "Are there any conditions on Funded — e.g. an under-review flag that
> restricts what a Funded account can do?"
>
> User: "Funded accounts under review can receive transfers but not send."
>
> Agent: "Got it. So the rule is: servicing account must be Active, or
> Funded without the under-review flag. Receiving account can be Active or
> any Funded. Let me update the eligibility rule."

**What it doesn't look like:**

> Agent: "I have 10 questions:
> 1. What statuses qualify?
> 2. How are transactions linked?
> 3. ..."

That's a questionnaire, not an interview. If you catch yourself listing more
than one question in a chat turn, stop and pick the first one.

## Ask now vs. defer

**Ask now:** the answer changes how you write the current file, or it's a
judgement call (domain, feature, template fit).

**Defer:** only when the user needs to check something. Never "I'll ask later".

## Where questions live

| Scope | Location |
|-------|----------|
| Cross-cutting | `knowledge/questions/` |
| Domain-wide | `domains/<d>/questions/` |
| Feature-specific | `features/<f>/questions/` |

## Creating a question file

**An OQ file is created AFTER asking the user, not before.** The sequence is
always: ask in chat → get a response → create the file to record what
happened. If you find yourself writing an OQ file first, stop — you're
skipping the ask.

**ID and filename share the same form:** `OQ-<NNN>-<short-slug>` — e.g.
`OQ-001-account-status-values.md`. Slug is kebab-case, 2–5 words. `<NNN>` is a
global sequence.

**Content:** the question, its Context (why it matters), and the Resolution
from the conversation that already happened. Never Context-only with an empty
Resolution and no chat turn behind it.

## Asking the user

When you present the question to the user, you may offer candidate options if
that helps them respond quickly ("Is it A, B, or something else?"). That's
framing the ask, not speculating in the file.

**Follow up when the answer needs clarification** — one of the conversation
rules. Ambiguous, incomplete or surprising answers get a follow-up before you
record.

## Recording the answer

1. Update the rule/workflow/data file first. Set `basis: stated`. Remove the
   `OQ-<NNN>-<slug>` reference if the ambiguity is resolved.
2. Update the question file per `references/knowledge/open-question.md`:
   set `status`, fill Resolution with the initial question and the
   synthesised final answer (fold follow-ups in — don't record every Q/A).

Keep the question file after resolution — the context and reasoning matter.

## Don't

- Populate Resolution without asking — candidates in the *ask* are fine;
  candidates *in the file* are speculation
- Create an `OQ-<NNN>-<slug>` and never ask it
- Defer everything to step 6.5
- Batch multiple questions
- Only ask feature-tier questions — platform/domain gaps get lost
- Skip because "the user probably doesn't know" — ask anyway (but "ask anyway"
  governs *raising* a question once, not looping on the answer: the follow-up depth
  cap in the Termination budget still applies)
- Answer the question file but not the curated content

## When not to raise an OQ

- Requires code access the user doesn't have → coverage gap
- Already documented elsewhere → search first
- Not consequential → no curated content changes based on the answer
