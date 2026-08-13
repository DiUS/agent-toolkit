# Steel-Thread and Vertical-Slice Method

Use this reference to make slicing decisions. The procedure is in
[../SKILL.md](../SKILL.md), and the output scaffold is in
[../templates/steel-thread.md](../templates/steel-thread.md).

## Steel thread

The steel thread is the thinnest deployable vertical slice that proves the architecture works
end-to-end. In a web product that might be database -> API -> frontend; in another system it
might be event producer -> broker -> consumer -> observable result.

It is a real, demonstrable user-story fragment, not a collection of setup tasks. It should use
the actual integration path wherever practical, while carrying almost no business complexity.
Its purpose is to expose architectural, deployment, contract, and environment risk before the
team builds broader functionality.

Slice 0 is always completed by one Dev+agent pair before parallel work fans out. Other pairs
can help review or unblock it, but splitting ownership of the initial path usually weakens the
signal and increases coordination.

## Good vertical slices

A good slice:

- delivers a small but coherent user outcome;
- crosses every layer needed for that outcome;
- can be implemented and tested within a few days;
- is reviewable as a sensible PR or small PR sequence;
- ends in visible, functional behaviour suitable for a product demo;
- traces directly to the PRD and stays within its scope.

Horizontal phases such as "build all schemas", "create all endpoints", or "finish the UI"
delay integration feedback and are not demo-ready slices.

## Just-in-time infrastructure

Provision a table, topic, bucket, pipeline, environment setting, or service integration only
when the first demonstrable slice requires it. Put the setup and the behaviour that proves it
works in the same slice.

Reuse established platform patterns. Ask where infrastructure lives and how it is provisioned;
do not assume a repository, cloud, IaC tool, or ownership model.

## Story decomposition

Decompose when at least one of these is true:

- a smaller slice validates a risky assumption sooner;
- a smaller slice creates a meaningful product feedback loop sooner;
- the original story is too large for a few-day testable delivery;
- separating stable prerequisites unlocks safe parallel work without creating non-demoable
  fragments.

Keep a story whole when splitting it only creates hand-offs, partial layers, meaningless demos,
or extra coordination. More slices are not inherently leaner.

## Capacity-aware parallelism

Treat each Dev+agent pair as one concurrent workstream. The confirmed pair count is a capacity
ceiling, not a target that must always be filled.

Parallel slices should have:

- completed and stable prerequisites;
- no hard ordering between them;
- bounded ownership of code, migrations, interfaces, and infrastructure;
- contracts stable enough to avoid continual cross-stream changes;
- separate demo-ready outcomes;
- a clear synchronization point before downstream slices.

Avoid parallelism when slices modify the same unstable contract, depend on an unfinished data
model, repeatedly touch the same files, or require constant coordination. Prefer idle capacity
over concurrency that increases elapsed time.

Keep the roadmap as a flat `Slice 0..N` sequence. Use parallel-group annotations instead of
lanes or IDs such as `1a`, `1b`. Record how many pairs are allocated to each concurrent slice;
names are unnecessary.

## Demo-ready gate

Every slice must end with a functional result that an engineer can review and a product
stakeholder can demonstrate. "The component exists" or "the infrastructure was provisioned"
is insufficient. The gate must describe observable behaviour and how it can be exercised.

## Task mapping and PR boundaries

Preserve original PRD task descriptions verbatim. A slice normally maps to one PR, but a risky
or larger atomic slice may need a short sequence of independently safe PRs. Recommend the
boundary and ask the human to confirm it.

Tasks that do not support the current slice move later. Tasks outside the PRD remain excluded.

## SDD hand-off

`steel-thread.md` constrains delivery sequencing and planning; it does not replace technical
design. Pass it into the selected SDD workflow's technical planning/design step after product
scope is established.

The hand-off should preserve:

- Slice 0 and the later slice sequence;
- PRD traceability and verbatim task wording;
- demo-ready gates and JIT infrastructure;
- dependencies and parallel groups;
- total Dev+agent pair capacity and per-slice allocation.

Do not invent framework commands. Confirm them with the human or official documentation.
