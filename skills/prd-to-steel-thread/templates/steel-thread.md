# Steel Thread: <Feature / Capability Name>

**Source PRD:** <relative/path/to/prd.md>
**Source tasks:** <relative/path/to/tasks.md or "embedded in PRD">
**Date:** <YYYY-MM-DD>
**Architecture path:** <confirmed end-to-end layers>
**SDD workflow:** <confirmed framework or "standalone">
**Planning/design hand-off:** <confirmed command or step, or "none">
**Concurrent capacity:** <N> Dev+agent pair(s)
**Status:** Draft for review

## Outcome

<What product outcome the PRD seeks, what Slice 0 proves, and how later slices deliver the
remaining in-scope capability.>

## Confirmed planning context

- **Existing stack and services:** <confirmed context>
- **Deployment path:** <confirmed context>
- **Infrastructure ownership/provisioning:** <confirmed context>
- **Real data/integration path:** <confirmed context>
- **Constraints affecting sequence:** <confirmed constraints>

## Sequence at a glance

| # | Slice | Proves / delivers | JIT infrastructure | Demo-ready gate | Depends on | Parallel group | Dev+agent pairs | Recommended PRs |
|---|---|---|---|---|---|---|---:|---:|
| 0 | Steel thread: <name> | <end-to-end proof> | <only what is first needed> | <observable demo> | None | None | 1 | <N> |
| 1 | <name> | <user outcome> | <new infra or "None"> | <observable demo> | 0 | <group or "None"> | <N> | <N> |
| N | <name> | <user outcome> | <new infra or "None"> | <observable demo> | <slice numbers> | <group or "None"> | <N> | <N> |

## Slice 0 - Steel thread: <name>

**Goal:** <smallest credible end-to-end user-story fragment>

**Thins down:** <source story or requirement>

**Why this is the steel thread:** <why it is minimal and what risk it exposes>

**Proves:** <architecture, integration, deployment, and real-data claims>

**PRD requirements covered (verbatim):**

- <original requirement description>

**Original tasks mapped to this slice (verbatim):**

- <original task description>

**Infrastructure first needed here:** <JIT infrastructure or "None">

**Depends on:** None

**Dev+agent pairs:** 1

**Demo-ready gate:** <functional behaviour and how to demonstrate it>

**Recommended PR boundary:** <one PR or a short safe sequence>

## Slice 1 - <name>

**Goal:** <coherent user-facing capability>

**PRD requirements covered (verbatim):**

- <original requirement description>

**Original tasks mapped to this slice (verbatim):**

- <original task description>

**Infrastructure first needed here:** <JIT infrastructure or "None">

**Depends on:** <slice numbers>

**Parallel-safe with:** <slice numbers or "None">

**Parallel group:** <group or "None">

**Dev+agent pairs:** <N>

**Why this allocation is safe:** <dependency, contract, and ownership rationale>

**Demo-ready gate:** <functional behaviour and how to demonstrate it>

**Recommended PR boundary:** <one PR or a short safe sequence>

<!-- Repeat for Slice 2..N. -->

## Parallel execution plan

<!-- Omit this section when capacity is one pair or no safe parallel groups exist. -->

### Parallel group <N>

- **Starts after:** <prerequisite slices>
- **Slices:** <slice numbers>
- **Available capacity:** <N> Dev+agent pairs
- **Allocation:** <Slice X: N pairs; Slice Y: N pairs>
- **Why parallel-safe:** <independent contracts, files, modules, or infrastructure>
- **Synchronization point:** <what must be integrated or confirmed before dependent work>

## Deferred / pushed down

| PRD item or task (verbatim) | Moved to | Reason |
|---|---|---|
| <original wording> | <slice or future> | <not required earlier / dependency / risk order> |

## Excluded from this roadmap

- <out-of-scope or future PRD item, verbatim>

## Open questions and PRD gaps

- <unresolved question and its planning impact>

## SDD planning/design hand-off

**Selected workflow:** <framework or standalone>

**Confirmed planning/design command or step:** <command/step or N/A>

Use the source PRD as the product source of truth and this document as the confirmed delivery
sequence. Produce the technical plan/design for the whole feature while preserving:

- the steel thread as Slice 0;
- the flat Slice 0..N sequence;
- demo-ready gates and just-in-time infrastructure;
- PRD and original-task wording;
- dependencies, parallel groups, and synchronization points;
- total capacity of <N> Dev+agent pairs and each slice's allocation.

Do not broaden PRD scope or replace the confirmed architecture. Surface technical decisions,
trade-offs, and unresolved gaps for human review.

### Ready-to-paste invocation

```text
<confirmed framework planning/design command, if any>

Feature: <Feature / Capability Name>
Source PRD: <relative/path/to/prd.md>
Steel-thread roadmap: <relative/path/to/steel-thread.md>
Concurrent capacity: <N> Dev+agent pair(s)

Create the technical plan/design using steel-thread.md as the delivery sequence.
Preserve its Slice 0..N ordering, demo-ready gates, JIT infrastructure,
dependencies, parallel groups, synchronization points, and pair allocations.
```
