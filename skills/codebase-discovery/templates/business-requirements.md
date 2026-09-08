# Business Requirements

> **Last updated:** YYYY-MM-DD
> **Scope:** Functional + non-functional requirements of <system>, reconstructed from code and validated where possible
> **Mode:** full | code-only
> **Status:** <full: accepted knowledge unless flagged | code-only: code-derived, not validated by a person> — see ../_discovery/assumptions-register.md

<!-- Reconstructed requirements: the outcomes the system must deliver, not a feature dump.
Keep to ~1–2 pages.

No Status or Source column on either table below: a flag goes inline in the requirement's own text
where it carries weight, sparingly, and the evidence goes in the traceability index, keyed by the
requirement's own ID (FR-1, NFR-1), not a second C-n minted for the same claim. -->

## Purpose & outcomes

<What the system must achieve for the business. 2–4 sentences.>

## Functional requirements

<!-- Grouped by capability. State the outcome/behaviour, not implementation. -->

| ID | Requirement |
|---|---|
| FR-1 | <the system shall …> |

## Non-functional requirements

<!-- The constraints that shape what's acceptable. Reconstruct from code (auth, caching,
retries, rate limits) and confirm targets with stakeholders. -->

| ID | Category | Requirement / constraint |
|---|---|---|
| NFR-1 | Performance | <expected volume / latency> |
| NFR-2 | Availability | <uptime expectation> |
| NFR-3 | Security | <access / data handling> |
| NFR-4 | Compliance | <regulatory / audit / retention> |

## Out of scope / known gaps

<What the system explicitly does not do, and expected requirements it doesn't yet meet.>
