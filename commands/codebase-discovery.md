---
name: codebase-discovery
description: "Run the codebase-discovery skill against the current repo to reverse-engineer domain, architecture, business rules, workflows and a glossary into lean onboarding docs."
---

## User Input

```text
$ARGUMENTS
```

If provided, treat this as the mode (`full` or `code-only`) or a subsystem to scope the
analysis to. If empty, default to `full` and confirm with the user before proceeding.

## Instructions

Run the `codebase-discovery` skill against the current repository:

1. Read [`skills/codebase-discovery/SKILL.md`](../skills/codebase-discovery/SKILL.md) — it is
   the orchestrator and will sequence its phases (pre-check, deep recon, interview, synthesis,
   verification) itself.
2. Follow that skill's instructions exactly, including its own playbooks, references and
   templates under `skills/codebase-discovery/`.
3. Report back using the completion report format defined in the skill.

Do not duplicate or reinterpret the skill's logic here — this command exists only to give it a
convenient slash-command entry point.
