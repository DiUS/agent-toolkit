# <System name>

<!-- The project's front door AND the onboarding index. Follow the "Project-root README.md" rules
in the skill's synthesis playbook before writing: merge conservatively into an existing README,
get sign-off, and keep discovery metadata out of this file. Delete these guidance comments. -->

<!-- 2–3 sentences: what the system is, who it's for, what it does. This is the first thing
a new team member or AI harness reads. Keep it tight. -->

## What this system is

<one short paragraph>

## Documentation

<!-- Delete any row below whose document wasn't written, so this indexes only what exists. -->

Onboarding docs live under [`docs/`](./docs/):

| Doc | What's inside |
|---|---|
| [docs/tech/current-architecture.md](./docs/tech/current-architecture.md) | How the system is built, as-is |
| [docs/tech/integrations.md](./docs/tech/integrations.md) | External systems and dependencies |
| [docs/domain/domain-model.md](./docs/domain/domain-model.md) | Core entities and cross-area relationships |
| [docs/domain/domain-glossary.md](./docs/domain/domain-glossary.md) | Business language |
| [docs/domain/rules-&lt;concept&gt;.md](./docs/domain/) | Rules that apply system-wide — one row per file |
| [docs/business/workflow-&lt;concept&gt;.md](./docs/business/) | Flows that cross areas — one row per file |
| [docs/business/business-requirements.md](./docs/business/business-requirements.md) | Functional + non-functional requirements |
| [docs/business/user-personas.md](./docs/business/user-personas.md) | Who uses it |

<!-- If the system has areas, list them here, one line each, linking the directory, not every file
inside it. Omit this section entirely on a single-area system. List EVERY area, including any
discovery hasn't documented yet, so a reader can see the edge of what's covered; drop the link on a
pending one, since there's nothing to link to. -->

### Areas

| Area | What it covers | Documented |
|---|---|---|
| [docs/areas/<area>/](./docs/areas/<area>/) | <one line: what this part of the business does> | yes |
| <area> | <one line> | not yet |

## Getting started

<!-- Only where the code reveals it: how to install / run / test. Omit if unknown; don't invent. -->

## Open questions & risks

<!-- The few highest-impact unresolved items. Link the register for the full list. -->

- <top assumption/risk> — see [docs/_discovery/assumptions-register.md](./docs/_discovery/assumptions-register.md)
