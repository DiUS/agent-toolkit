---
name: "prd-to-steel-thread"
description: "Turn a product PRD into a lean steel-thread roadmap: first prove the thinnest end-to-end path, then sequence demo-ready vertical slices with just-in-time infrastructure and capacity-aware parallelism. Produces steel-thread.md for input to Spec Kit /speckit.plan or the equivalent technical planning step in another SDD workflow. Use when identifying a steel thread, vertically slicing a PRD, reorganising PRD tasks, planning parallel Dev+agent workstreams, or preparing product requirements for technical design."
argument-hint: "Path to the PRD; optionally include the existing tasks file and target SDD workflow"
compatibility: "Host-agnostic. No hooks, MCP servers, or specific SDD runtime required."
user-invocable: true
disable-model-invocation: false
---

## User Input

```text
$ARGUMENTS
```

Use the input to locate the source PRD and any existing task list. If a path is missing or
ambiguous, ask for it rather than guessing.

## Purpose

Convert a product-focused PRD into `steel-thread.md`, a delivery input for technical planning
and design. The document starts with the smallest real end-to-end user outcome that proves the
architecture works, then sequences the remaining scope as lean, demo-ready vertical slices.

`steel-thread.md` sits between product specification and technical planning:

```text
PRD -> steel-thread.md -> SDD plan/design -> implementation tasks
```

For Spec Kit, it is an input to `/speckit.plan` after the feature specification exists. For
another SDD tool, hand it to the equivalent planning or design step. Do not turn the PRD into a
technical design inside this skill.

Read [references/vertical-slice-method.md](references/vertical-slice-method.md) before slicing.
Use [templates/steel-thread.md](templates/steel-thread.md) for the output. If the source PRD
does not follow a known structure, use [templates/prd-input-template.md](templates/prd-input-template.md)
as an interpretation guide, not as permission to fill gaps.

## Non-negotiable rules

- The PRD is the product source of truth. Do not invent requirements or silently resolve gaps.
- Ask clarification questions **one at a time**. Do not assume architecture, infrastructure,
  team capacity, delivery assignments, framework commands, or task boundaries.
- Preserve original requirement and task descriptions verbatim when mapping them to slices.
- Slice 0 is the **steel thread**: solo, first, deployable, and end-to-end.
- Every slice ends with a functional result that an engineer can review and a product
  stakeholder can demo.
- Add infrastructure only in the first slice that needs it. Never create an infra-first phase.
- Decompose only when doing so accelerates feedback, reduces risk, or makes a large story
  deliverable within a few days.
- Parallelise only independent work. Capacity is not a reason to force unsafe concurrency.
- Record capacity as the number of **Dev+agent pairs**, not personal names.
- Keep the roadmap flat as `Slice 0..N`; express concurrency through dependencies,
  parallel-safe annotations, pair counts, and parallel groups.

## Procedure

### 1. Read and assess the inputs

Read the PRD and existing task file in full. Extract:

- desired outcome, users, scope, and explicit exclusions;
- user stories, functional requirements, acceptance criteria, and business rules;
- data, UX, non-functional, reporting, audit, and operational requirements;
- constraints, dependencies, risks, unresolved decisions, and future work;
- every task description that must be preserved verbatim.

Summarise the intended outcome and list gaps that would materially affect slicing. Ask about
each blocking gap one at a time. Do not start slicing while the source meaning is uncertain.

### 2. Confirm the SDD hand-off

Ask which SDD workflow will consume `steel-thread.md`: Spec Kit, another named workflow, or no
framework. If a framework is selected, confirm the command or step that performs technical
planning/design. Consult official documentation when tools permit and the mapping is unknown;
otherwise ask the human. Never invent framework commands or artifact contracts.

Record only the confirmed hand-off. Spec Kit commonly uses `/speckit.plan`, but use it only
when Spec Kit is selected and that mapping is valid for the project.

**Gate:** the target planning/design step is confirmed, or the human chooses a standalone
document.

### 3. Confirm architecture and just-in-time infrastructure

Ask, one question at a time:

1. Which layers define an end-to-end slice for this feature?
2. Which existing stack, services, repositories, and deployment path must be reused?
3. What real data path can prove those layers work together?
4. Where and how is infrastructure provisioned, and what already exists?

Use linked technical material when available, but have the human resolve ambiguity. Do not
design the architecture here.

**Gate:** the vertical architecture path and existing delivery constraints are confirmed.

### 4. Confirm capacity

Ask:

> How many Dev+agent pairs will work on this feature concurrently?

One human working with one coding agent counts as one pair. Record a positive whole number.
Do not ask for or emit personal names unless the human volunteers them and explicitly wants
them included.

Capacity informs the proposed schedule, not the number of slices. Slice 0 remains one pair
even when more pairs are available.

### 5. Propose and confirm Slice 0: the steel thread

Identify the thinnest real user-story fragment that:

- traverses every required layer;
- uses real integration and persistence where those are part of the architecture;
- can be built, deployed, tested, reviewed, and demonstrated;
- establishes only the infrastructure and contracts it immediately needs.

State the PRD items it thins down, what it proves, its demo-ready gate, its just-in-time
infrastructure, and why it is the smallest credible slice.

**Gate:** get explicit human confirmation of Slice 0 before decomposing the remaining scope.

### 6. Evaluate stories and form later slices

Evaluate each story against a few-days, testable-deliverable bar. Keep an atomic story whole
unless decomposition produces earlier learning, lowers risk, or creates a usable demo sooner.

For each proposed slice define:

- goal and user-visible outcome;
- source PRD requirements and original tasks, verbatim;
- dependencies and contracts it relies on;
- infrastructure first needed in this slice;
- demo-ready gate;
- recommended PR boundary;
- number of Dev+agent pairs required.

Push work later when it is not required for the steel thread or current user outcome. Keep
out-of-scope and future items out of the roadmap.

### 7. Plan safe parallelism

After Slice 0, build a dependency graph and identify slices that can proceed concurrently.
Use the confirmed pair capacity as an upper bound.

A parallel group is valid only when its slices have stable prerequisites and can be worked on
without conflicting ownership of the same unstable contracts, migrations, or files. Prefer a
linear sequence when concurrency would increase coordination or merge risk.

For every parallel group record:

- slices in the group;
- prerequisite slices;
- available Dev+agent pairs;
- pairs allocated to each slice;
- why the work is parallel-safe;
- the synchronization point before dependent work begins.

Do not create artificial sub-slices merely to occupy every pair.

### 8. Confirm the roadmap and write the artifact

Present the proposed Slice 0, later slice boundaries, deferred items, PR mapping, dependency
sequence, and parallel groups.

**Gate:** obtain explicit human confirmation before writing the final artifact.

Then write `steel-thread.md` next to the source PRD using
[templates/steel-thread.md](templates/steel-thread.md). Include a ready-to-paste hand-off for
the confirmed SDD planning/design step. The hand-off must carry forward the slice sequence,
demo gates, dependencies, pair capacity, parallel groups, and just-in-time infrastructure
without introducing technical design decisions.

## Completion checks

- [ ] The PRD and existing task file were read in full.
- [ ] Blocking gaps were resolved by asking one question at a time.
- [ ] The architecture path, infrastructure context, SDD hand-off, and Dev+agent pair count
      were confirmed.
- [ ] Slice 0 is the smallest credible end-to-end technical smoke test and is assigned one pair.
- [ ] Every later slice is traceable, demo-ready, and only decomposed for feedback or risk.
- [ ] Infrastructure appears only when first needed.
- [ ] Parallel groups respect dependencies, pair capacity, and merge/contract safety.
- [ ] Original PRD requirement and task descriptions are preserved verbatim.
- [ ] `steel-thread.md` and its confirmed SDD hand-off were produced for human review.
