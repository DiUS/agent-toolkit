# Integrations & Dependencies

> **Last updated:** YYYY-MM-DD
> **Scope:** External systems and dependencies of <system>
> **Mode:** full | code-only
> **Status:** accepted knowledge unless flagged — see ../_discovery/assumptions-register.md

<!-- What this system talks to, why, and which direction data flows. A table is usually enough.

SECRETS: this file is committed. Auth and endpoint details are exactly where credentials leak —
re-read the secrets rule you were given before writing the auth/notes column. Delete these
guidance comments when you write the real file. -->

## External systems

| System | Purpose | Direction | Protocol / mechanism | Notes |
|---|---|---|---|---|
| <name> | <why we integrate> | inbound / outbound / both | REST / queue / webhook / DB | <auth mechanism + config key name; criticality> |

## Key dependencies

<!-- Runtime dependencies that shape behaviour: managed services, message brokers, caches,
identity providers. Not every library — the ones a new joiner must understand. -->

## Data feeds

<Scheduled imports/exports, batch jobs, file drops — source, cadence, format.>

## Failure & coupling notes

<What breaks if an integration is down; retries/fallbacks present in the code. Flag assumptions.>
