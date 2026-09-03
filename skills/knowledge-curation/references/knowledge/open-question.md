---
id: "OQ-{NNN}-{short-slug}"      # ID and filename share the same form
status: open                      # open | answered | unresolvable
basis: documented                 # documented | stated | inferred | assumed
source: "{where it came from}"
updated: "{YYYY-MM-DD} {your name}"
related: []                       # IDs only
blocks: []                        # IDs that cannot be finalised until this is answered
---

# <Question>

> **ID and filename share the same form:** `OQ-<NNN>-<short-slug>` — e.g.
> `OQ-001-account-status-values`. Slug is kebab-case, 2–5 words, derived from
> the question's subject. `<NNN>` is a global sequence across all tiers.
>
> **Location signals scope:**
> - `knowledge/questions/` — cross-cutting
> - `domains/<domain>/questions/` — domain-scoped
> - `domains/<domain>/features/<feature>/questions/` — feature-scoped
>
> **This file records a conversation that already happened.** Ask the user in
> chat first, get a response, then create this file. Creating an OQ file
> without a corresponding chat turn is the failure mode the knowledge-curation skill
> exists to prevent.
>
> When *asking*, you may present candidate options to help the user respond
> ("Is it A, B, or something else?") — that's framing, not speculation. Never
> fill Resolution without the user having said it. Follow-ups are welcome when
> the initial answer needs clarification; fold them into the Final answer.

## Context

<What surfaced this, and why it matters — what's wrong or risky if we guess.
If nothing is at risk, close it; not every ambiguity deserves a file.>

## Resolution

<Empty until the user has answered or the question is confirmed unresolvable.>

**Date:** YYYY-MM-DD

**Initial question:** <the question as asked to the user>

**Final answer:** <the resolved answer — the user's initial response plus any
follow-up clarifications, synthesised into a coherent statement. Organise it
(sub-bullets, numbered points) if the exchange covered multiple aspects and
that helps readability. For unresolvable: "unresolvable — <reason>".>
