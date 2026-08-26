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
     follow-up. Repeat step 2.
4. Move on only when the answer is usable. Then next question.

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
- Skip because "the user probably doesn't know" — ask anyway
- Answer the question file but not the curated content

## When not to raise an OQ

- Requires code access the user doesn't have → coverage gap
- Already documented elsewhere → search first
- Not consequential → no curated content changes based on the answer
