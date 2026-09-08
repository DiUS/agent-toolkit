# Integrations & Dependencies

> **Last updated:** YYYY-MM-DD
> **Scope:** External systems and dependencies of <system>
> **Mode:** full | code-only
> **Status:** <full: accepted knowledge unless flagged | code-only: code-derived, not validated by a person> — see ../_discovery/assumptions-register.md

<!-- What this system talks to, why, and which direction data flows. A table is usually enough.

SECRETS: this file is committed. Auth and endpoint details are exactly where credentials leak, so
re-read the secrets rule in `SKILL.md` before writing the auth/notes column. -->

## External systems

| System | Purpose | Direction | Protocol / mechanism | Notes |
|---|---|---|---|---|
| <name> | <why we integrate> | inbound / outbound / both | REST / queue / webhook / DB | <auth mechanism + config key name; criticality> |

## Key dependencies

<!-- Runtime dependencies that shape behaviour: managed services, message brokers, caches,
identity providers. Not every library, only the ones a new joiner must understand. -->

## Data feeds

<Scheduled imports/exports, batch jobs, file drops — source, cadence, format.>

## Failure & coupling notes

<What breaks if an integration is down; retries/fallbacks present in the code. Flag assumptions.>
