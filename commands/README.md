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
   context.
3. It ships automatically — `commands` is registered as a directory in
   [`.claude-plugin/plugin.json`](../.claude-plugin/plugin.json).
4. Run the verification gate: `node scripts/validate.js`.

## Don't wrap a skill in a command

A skill with `user-invocable: true` already exposes `/<skill-name>`, so a command that only
says "go and run that skill" is redundant — and it collides with the skill for the same slash
name. Point users at the skill instead.

If a command genuinely does need to reach a file that ships in this repo, **never reference it
by a repo-relative path.** When the plugin is installed, the working directory is the
consumer's repo, not this one, so `skills/<name>/SKILL.md` doesn't exist there. Use
`${CLAUDE_PLUGIN_ROOT}/…`, or invoke the skill by name and let the host resolve it.

## Naming conventions

- Lowercase, hyphen-separated file names matching the `name` field (`review-pr.md` →
  `name: review-pr`).
- Prefer a verb or verb phrase (`review-pr`, `summarise-diff`) so the slash command reads
  naturally.
- Keep the body short and task-scoped; if it grows into a multi-phase workflow, make it a
  skill under `skills/` instead.
