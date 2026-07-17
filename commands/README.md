# Commands

A **command** is a Markdown file with YAML frontmatter that becomes a slash command in
Claude Code (and compatible agents). It's the lightest-weight component in this toolkit —
useful for a short, repeatable instruction that doesn't need the structure of a full skill
(playbooks, references, templates).

This is a **Claude Code / compatible-agent** feature. Agents that don't support slash
commands can still be pointed at the file's body as plain instructions, but the frontmatter
and `/name` invocation are specific to hosts that implement the convention.

## Anatomy

```markdown
---
name: my-command
description: One line — what it does and when to use it.
---

Body: the instructions the agent follows when the command is invoked.
```

Required frontmatter keys: `name`, `description`. The `name` becomes the slash command
(`/my-command`); the `description` is shown in command pickers and drives discovery, so make
it specific.

## Adding a command

1. Create `commands/<name>.md` with `name` + `description` frontmatter.
2. Write the body as clear, self-contained instructions — assume the agent has no other
   context. If the command wraps a skill in this toolkit, say so explicitly and point at the
   skill's entry point (e.g. `skills/codebase-discovery/SKILL.md`).
3. It ships automatically — `commands` is registered as a directory in
   [`.claude-plugin/plugin.json`](../.claude-plugin/plugin.json).
4. Run the verification gate: `node scripts/validate.js`.

## Naming conventions

- Lowercase, hyphen-separated file names matching the `name` field (`codebase-discovery.md` →
  `name: codebase-discovery`). When a command wraps a skill, match the skill's name.
- Prefer a verb or verb phrase (`review-pr`, `summarise-diff`) so the slash command reads
  naturally — unless it wraps a skill, in which case mirror the skill name.
- Keep the body short and task-scoped; if it grows into a multi-phase workflow, consider a
  skill under `skills/` instead.

See [`codebase-discovery.md`](./codebase-discovery.md) for a working command that wraps a skill.
