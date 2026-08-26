---
id: "WF-{DOMAIN}-{TOPIC}"    # shared base for every workflow below; each appends -NNN
status: draft                # draft | verified
updated: "{YYYY-MM-DD} {your name}"
related: []                  # IDs only — include any upstream/downstream workflow
                              # ID cited via Trigger/Outcomes below, not just rules
---

# <Topic> — workflows

> One file per topic within a feature's `workflows/` folder — **never** directly
> under the domain (see `structure.md` for the tier layout, the `knowledge-curation` skill
> for how the feature gets decided). Not one file per workflow unless the feature only
> has one. Filename describes the topic/grouping, not the ID.
>
> **Scope:** contained within one domain. If any step hands off to another domain,
> this is a journey, not a workflow — move it to `platform/journeys/`.
>
> **Phrase it in business language**, even where the source is exact about the
> implementation — "products must be configured to allow refunds", not "set
> `refund_allowed_yn = 'Y'`". The literal field/value binding belongs in
> `tech/data-owned.md` or `tech/data-consumed.md`, not in a workflow's own wording.
>
> **Diagram participants are business-recognizable actors only** — a person/role,
> the domain's own system as a single actor, or another named domain/external
> system. Never an infrastructure/implementation layer as its own lane: no
> `Database`, no `Schema Validator`, no generic `Validation`/`Business Logic`
> engine, no cache or message queue. Those collapse into the responsible actor's
> own self-message (`CBIS->>CBIS: Validate fromAccountId`, not
> `Validation->>Database: Validate fromAccountId`) — the technical binding still
> gets captured, via the `touches:`/`calls:` Note annotation below, just not as a
> dedicated swimlane. A diagram that reproduces an internal call trace instead of
> a business flow is the thing this rule exists to prevent.
>
> **Match the diagram type to the shape of the flow — don't default to
> `sequenceDiagram`.** Three options:
>
> | shape | diagram type | fits when |
> |-------|--------------|-----------|
> | multi-actor interaction | `sequenceDiagram` | order of who-communicates-with-whom is itself the business fact (a submits, b approves, c is notified) |
> | single-system decision cascade | `flowchart` | one system works through a chain of business-rule checks; a sequence diagram would tempt you into inventing fake internal actors (`Database`, `Validation`) just to have somewhere to put the arrows |
> | entity lifecycle across triggers | `stateDiagram-v2` | the workflow is really about an entity's status over time (logged → active → closed/cancelled), especially when several `## WF-...` entries in this file are really different triggers on the *same* entity's lifecycle — one consolidated state diagram beats several fragments, each hiding the others' transitions |
>
> Every workflow entry states which type it used and why (`**Diagram type:**`
> below), and what that type structurally can't show for this workflow
> (`**Missing:**`) — not a generic tradeoffs essay, the specific thing a reader
> might otherwise assume is captured and isn't:
>
> - `sequenceDiagram` shows actors and message order but not the entity's status
>   across *other* triggers — if this entity has more than one, that's missing here.
> - `flowchart` shows the decision cascade but not *who* performs each step —
>   everything reads as "the system", even if a step is actually done by a
>   different actor.
> - `stateDiagram-v2` shows entity status transitions but not the individual
>   sub-steps within one transition (they collapse into a transition label/note),
>   and — like flowchart — not *who* triggers each transition beyond a label.
>
> If a `stateDiagram-v2` covers the whole entity's lifecycle across multiple
> triggers in this file, place it once, above the individual `## WF-...` entries,
> instead of repeating it per entry — each entry below still gets its own
> Trigger, Basis, business-language description, and Outcomes.
>
> **`stateDiagram-v2` note syntax:** always use the block form (`note right of X`
> / body / `end note`), never the single-line shorthand (`note right of X: text`)
> — the shorthand's parser breaks on any colon inside the note text, and this
> corpus's `touches:`/`calls:`/`BR-...` annotation convention always contains one.
>
> **Mermaid syntax safety — avoid these in labels, notes, and message text:**
>
> | Character | Why it breaks | Replace with |
> |-----------|---------------|--------------|
> | `(` and `)` inside Note text or `->>` message text | `(...)` opens a node shape and confuses the parser mid-label | Em dash `—`, or square brackets `[BR-...]` |
> | `<` and `>` | Parsed as HTML tags; kills the diagram | Plain text (`client system` not `<client system>`) or underscores (`client_system`) |
> | `:` in `->>` message text after the first `:` | The first `:` marks message start; a second ends the label early | Reword, use `#colon;`, or split into a Note |
> | Backticks in labels | Sometimes interpreted as code | Plain text |
> | Unquoted labels with special chars | Any of the above | Wrap in `"..."` |
>
> Examples:
> - ✗ `Note over MM: Trigger met\n(BR-MONEYMOVEMENT-CONFIRMATION-001)`
> - ✓ `Note over MM: Trigger met — BR-MONEYMOVEMENT-CONFIRMATION-001`
> - ✗ `MM->>Client: SEND_DOCUMENT_TO_<client system>`
> - ✓ `MM->>Client: SEND_DOCUMENT_TO client system`
> - ✗ `MM->>MM: Fire event\n(sequence 1: CREATE_DOCUMENT; sequence 50: SEND)`
> - ✓ `MM->>MM: Fire event — seq 1 CREATE_DOCUMENT, seq 50 SEND`
>
> **Preview every diagram before marking the file complete.** A file that fails
> to render is worse than no diagram.

## WF-{DOMAIN}-{TOPIC}-{NNN} — <Workflow name>

**Trigger:** <what starts it — event, schedule, user action. If the trigger is
another workflow's outcome, cite it by ID: "`WF-{DOMAIN}-{TOPIC}-{NNN}` completes
successfully with <the specific outcome that fires this one>" — not prose
describing the same thing without the ID.>
**Basis:** <documented|stated|inferred|assumed> — _<source citation>_
**Diagram type:** <sequenceDiagram|flowchart|stateDiagram-v2> — <one line: why this shape fits>
**Missing:** <what this diagram type can't show for this workflow specifically — see the three bullets above for the default per type, tailor if this instance differs>

<One or two sentences describing what the diagram shows — who's involved, what the
happy path is, what branches exist. The diagram is not self-explanatory to a
reader who hasn't traced it through yet; say in words what it's a diagram of.>

```mermaid
sequenceDiagram
    %% Participants = business-recognizable actors only (no separate Actors table
    %% needed) — never a technical/infrastructure layer, see note above.
    %% alt/else blocks show which branches exist (success/failure) natively —
    %% the consequences of each branch go in ### Outcomes below, not crammed in here.
    %% Note over X: BR-{DOMAIN}-{TOPIC}-{NNN} — annotate a rule applied at that step.
    %% Note over X: touches: <table> (read|write) / calls: <API or system name> —
    %% name only. Full column/mechanism detail lives in domains/<domain>/tech/
    %% (data-consumed.md / data-owned.md / integrations/), link to it if it matters.
```

### Outcomes

<What results from this workflow — side effects, downstream records
created/updated, documents/notifications triggered. A list of consequences reads
better as prose bullets than crammed into diagram notes; the diagram's alt/else
already shows which branch runs, this section says what happens as a result. If
an outcome is what triggers a downstream workflow, cite it inline: "<outcome> →
triggers `WF-{DOMAIN}-{TOPIC}-{NNN}`" — not a prose-only mention.>

- <e.g. "Transactions are created on both the servicing and receiving account.">

<A distinct compensating or reversal flow substantial enough to have its own
trigger and branching (e.g. "transactions can be reversed") is a separate
`## WF-{DOMAIN}-{TOPIC}-{NNN}` entry in this same file, not a bullet here — give
it its own Trigger, diagram, and Outcomes.>

**Open questions:** <`OQ-<NNN>` — the ambiguity, if any. Omit this line if none.>
