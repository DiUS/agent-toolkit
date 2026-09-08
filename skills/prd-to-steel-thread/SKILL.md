---
name: "prd-to-steel-thread"
description: "Create or revise a product PRD's steel-thread roadmap: first prove the thinnest end-to-end path, then sequence demo-ready vertical slices with just-in-time infrastructure and capacity-aware parallelism. Saves a resumable steel-thread.md draft, approved for input to Spec Kit /speckit.plan or an equivalent SDD technical planning step. Use when identifying a steel thread, vertically slicing a PRD, revising a roadmap, reorganising PRD tasks, planning parallel Dev+agent workstreams, or preparing product requirements for technical design."
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
- Save progress in the roadmap itself, not only in conversation. An incomplete draft is not
  approved input to technical planning.

## Saving progress

Use the output template's **Planning progress** section as portable session state. After each
human answer or approval, save the confirmed value in its relevant section and record what
was confirmed, when, any unresolved questions, and the next step **before continuing**.
Save proposed slices and parallel groups as drafts as they are developed; a proposal is not
an approval. Use `Pending` for unknown values rather than filling them from assumptions.

Keep **Status** as `Draft - incomplete; not ready for technical planning` until step 8 is
approved and the completion checks pass. Record approval of Slice 0 separately from approval
of the whole roadmap. If a confirmed input or slice changes, mark affected decisions and
dependent approvals as needing confirmation and clear final approval. Preserve unaffected
content and human edits; do not regenerate the document wholesale unless replacement was
explicitly chosen.

Re-read the selected output before each save. If it appeared or changed unexpectedly, preserve
it and ask how to reconcile conflicting edits before writing. If a save fails, report it and
stop rather than treating conversation-only progress as durable. After an interruption,
compaction, or new session, follow steps 0 and 1 again; never infer approvals from populated
template fields or reconstruct missing decisions from memory.

## Procedure

### 0. Select the artifact and protect existing work

The default output is `steel-thread.md` next to the source PRD. Check whether it exists
**before any write**. If it does, read it in full and ask which action the human wants:

- resume an unfinished draft or revise the existing roadmap in place;
- save a separate version at a human-confirmed, unused path, leaving the original untouched;
- replace the existing file and discard its contents, only with explicit permission.

Do not change the existing file until the action is confirmed. If no action is authorised,
stop without writing. For a separate version, clarify whether to carry forward the existing
content or start fresh; carried-forward decisions still require reconfirmation. Check the
chosen path for collisions as well, and use that path consistently in all hand-off references.

For a new file, explain that it will be saved incrementally and confirm its path before
creating it. Once authorised, initialise or update the selected document using
[templates/steel-thread.md](templates/steel-thread.md), retaining existing content when
resuming or revising. Mark it as an incomplete draft, with any prior confirmations awaiting
reconfirmation and no current final approval. Do not carry over a ready-to-paste invocation
as usable while the document is a draft.

### 1. Read and assess the inputs

Read the PRD and existing task file in full. Extract:

- desired outcome, users, scope, and explicit exclusions;
- user stories, functional requirements, acceptance criteria, and business rules;
- data, UX, non-functional, reporting, audit, and operational requirements;
- constraints, dependencies, risks, unresolved decisions, and future work;
- every task description that must be preserved verbatim.

On every resume or revision, compare current inputs with the saved context before updating
that context, and summarise the saved decisions, approvals, progress, and relevant changes.
Ask the human to reconfirm the saved decisions before relying on them, even when inputs appear
unchanged. Clarify missing, changed, or conflicting decisions one at a time; reopen affected
gates and downstream slice or parallelism decisions rather than silently carrying them forward.
If the prior input version is unavailable, ask what changed rather than claiming it is unchanged.
Record the source paths and available revision identifiers, or a dated summary of the inputs
reviewed, in **Planning progress**, retaining enough prior context to explain revisions.

**Resume gate:** saved decisions are explicitly reconfirmed or corrected and persisted before
dependent work resumes. Continue from the first unresolved step; do not repeat unaffected work.
An already-approved roadmap still needs fresh final approval after revision.

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
- why the work is parallel-safe;
- the synchronization point before dependent work begins.

Keep dependencies, pair allocations, and group membership in each slice section rather than
repeating them in the parallel execution plan. The document header records total available
capacity.

Do not create artificial sub-slices merely to occupy every pair.

### 8. Confirm the roadmap and finalise the artifact

Present the proposed Slice 0, later slice boundaries, deferred items, PR mapping, dependency
sequence, and parallel groups. For a revision, also summarise changes from the previous roadmap
and their impact on any existing technical plan or tasks; do not update those downstream
artifacts as part of this skill.

**Gate:** obtain explicit human confirmation of the complete current roadmap before marking it
approved. Saving drafts earlier does not satisfy this gate.

Prepare the final hand-off and apply the completion checks. Once they pass and final approval
is recorded in **Planning progress**, set
**Status** to `Approved - ready for technical planning`, and save to the selected output path.
Include a ready-to-paste hand-off for the confirmed SDD planning/design step, pointing to that
path. Follow the template's SDD planning/design hand-off section; it is the canonical
definition of the information that the hand-off must preserve. If approval is withheld, save
the outstanding questions and next step, and leave the document as an incomplete draft.

## Completion checks

- [ ] The output path and any action on an existing file were explicitly authorised; unrelated
      content and human edits were preserved unless replacement was chosen.
- [ ] **Planning progress** durably records confirmed decisions, source context, Slice 0
      approval, and the next step; saved decisions were reconfirmed on any resume.
- [ ] The human explicitly approved the current roadmap, with no outstanding blocking gaps
      or invalidated approvals. Only then may the document be marked ready for planning.
- [ ] The source PRD and task paths in `steel-thread.md` identify the inputs that were read in
      full.
- [ ] Unresolved source gaps appear in **Open questions and PRD gaps** with their planning
      impact; the roadmap contains no silent assumptions.
- [ ] **Confirmed planning context** records the agreed architecture path, infrastructure
      context, SDD hand-off, and Dev+agent pair count.
- [ ] Slice 0 traverses the confirmed end-to-end path, has one pair, and names observable
      behaviour that proves the path works.
- [ ] Every in-scope PRD requirement and task appears in exactly one slice, or in
      **Deferred / pushed down** or **Excluded from this roadmap** with a reason.
- [ ] Every slice's demo-ready gate names observable behaviour and how to exercise it, rather
      than only confirming that a component exists.
- [ ] No slice provisions infrastructure that it does not exercise in its own demo-ready gate.
- [ ] Each parallel group fits within total pair capacity and its safety rationale addresses
      dependencies, contract stability, and conflicting ownership.
- [ ] The SDD hand-off is fully populated for the confirmed workflow and points technical
      planning to the completed roadmap.
