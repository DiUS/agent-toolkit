---
name: knowledge-curation
description: "Run the knowledge-curation skill to process a source document (functional spec, technical doc, ADR, meeting notes, interview, workshop, glossary) into curated, ID-referenced knowledge under /knowledge."
---

## User Input

```text
$ARGUMENTS
```

If provided, treat this as the source to curate — a file path, an attachment reference, or a
description of a non-document source (interview, workshop, walkthrough). If empty, ask the user
which source to curate before proceeding.

## Instructions

Run the `knowledge-curation` skill against the given source:

1. Read [`skills/knowledge-curation/SKILL.md`](../skills/knowledge-curation/SKILL.md) — it is
   the orchestrator and will sequence its own phases (classification, workspace setup,
   extraction, elicitation, verification) itself.
2. Follow that skill's instructions exactly, including its own conventions, references and
   templates under `skills/knowledge-curation/`.
3. Honour the skill's conversation rules — elicit in chat as gaps surface, one question at a
   time; never batch questions or record speculative answers.

Do not duplicate or reinterpret the skill's logic here — this command exists only to give it a
convenient slash-command entry point.
