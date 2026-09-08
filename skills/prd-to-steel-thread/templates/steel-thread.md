# Steel Thread: <Feature / Capability Name>

**Source PRD:** <relative/path/to/prd.md>
**Source tasks:** <relative/path/to/tasks.md or "embedded in PRD">
**Date:** <YYYY-MM-DD>
**Architecture path:** <confirmed end-to-end layers>
**SDD workflow:** <confirmed framework or "standalone">
**Planning/design hand-off:** <confirmed command or step, or "none">
**Concurrent capacity:** <N> Dev+agent pair(s)
**Status:** Draft - incomplete; not ready for technical planning

## Planning progress

**Source context:** <revision identifiers, or dated summary of inputs reviewed>
**Last saved:** <YYYY-MM-DD>
**Next step:** <first unresolved procedure step and question/action>
**Resume confirmation:** <Not applicable for a new draft; Pending on every resume>

| Decision / gate | State | Confirmation record |
|---|---|---|
| Output path and create/resume/revise/version/replace action | Pending | <authorised path and action, date> |
| Source meaning and blocking gaps | Pending | <confirmed scope or unresolved gaps, date> |
| SDD workflow and planning/design hand-off | Pending | <confirmed choice, date> |
| Architecture, real data path, stack and deployment | Pending | <confirmed details or section reference, date> |
| Infrastructure ownership and provisioning | Pending | <confirmed details or section reference, date> |
| Dev+agent pair capacity | Pending | <confirmed count, date> |
| Slice 0 | Pending | <explicit approval of the current slice, date> |
| Complete roadmap | Pending | <explicit final approval of the current roadmap, date> |

Use `Pending`, `Confirmed`, or `Needs reconfirmation` for decision states. Save each answer
immediately, including partial confirmations while a gate remains pending. Store decision
values in the relevant sections below; reference them here rather than duplicating them.
Leave unknown values as `Pending`. Record unresolved questions in **Open questions and PRD
gaps**. On every resume, summarise saved decisions and obtain explicit reconfirmation before
using them, then record the reconfirmation and date in **Resume confirmation**. A populated
section alone is not evidence of approval.

Keep this document incomplete until the human approves the complete current roadmap and the
completion checks pass. Then set **Status** to `Approved - ready for technical planning` and
**Next step** to the confirmed planning/design hand-off. Revisions reopen final approval;
record the requested changes and downstream planning impact here.

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

| # | Slice | Proves / delivers |
|---|---|---|
| 0 | Steel thread: <name> | <end-to-end proof> |
| 1 | <name> | <user outcome> |
| N | <name> | <user outcome> |

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

**Parallel group:** <group or "None">

**Dev+agent pairs:** <N>

**Why this allocation is safe:** <dependency, contract, and ownership rationale>

**Demo-ready gate:** <functional behaviour and how to demonstrate it>

**Recommended PR boundary:** <one PR or a short safe sequence>

<!-- Repeat for Slice 2..N. -->

## Parallel execution plan

<!-- Omit this section when capacity is one pair or no safe parallel groups exist. -->

### Parallel group <N>

- **Slices:** <slice numbers>
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

**Readiness:** Not ready while this document is an incomplete draft. Use this hand-off only
when **Status** is `Approved - ready for technical planning` and current final approval is
recorded above.

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

Include the invocation only after final approval. Use the actual selected roadmap path,
including when the human chose a separate version instead of `steel-thread.md`.

```text
<confirmed framework planning/design command, if any>

Feature: <Feature / Capability Name>
Source PRD: <relative/path/to/prd.md>
Steel-thread roadmap: <relative/path/to/selected-roadmap.md>
Concurrent capacity: <N> Dev+agent pair(s)

Create the technical plan/design using the roadmap identified above as the delivery sequence.
Preserve every delivery constraint in its SDD planning/design hand-off section.
```
