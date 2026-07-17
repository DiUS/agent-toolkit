# Getting started

Tool-by-tool setup notes for `agent-toolkit`. For the toolkit overview, the two install
routes (`npx skills` and the Claude Code plugin), the current skills table and the
component-type summary, start at the [README](../README.md) — this guide only adds the
per-tool detail that doesn't belong there.

Skills are the most portable component — plain Markdown any capable agent can follow.
Commands and hooks are Claude-Code-specific conventions (other agents may have their own
equivalents), and agents (subagents) are a Claude Code concept used by skills that fan out
work.

## Per-tool notes

<details open>
<summary><b>Claude Code</b></summary>

The primary target. Install as the plugin (skills + commands + agents) or with `npx skills`
for skills only — both routes are in the [README](../README.md#install). Slash commands
(`commands/`) and subagents (`agents/`) are Claude-Code-specific; hooks stay opt-in (see
[`hooks/README.md`](../hooks/README.md)).

</details>

<details>
<summary><b>Cursor</b></summary>

Copy the skill(s) you want (e.g. `skills/<name>/`) into `.cursor/rules/`, or reference the
whole directory so playbooks and templates stay reachable. Commands, agents and hooks have no
direct Cursor equivalent — use the skill's Markdown as instructions instead.

</details>

<details>
<summary><b>Gemini CLI</b></summary>

```bash
gemini skills install https://github.com/DiUS/agent-toolkit.git --path skills
```

Or add a skill's contents to `GEMINI.md` for persistent context.

</details>

<details>
<summary><b>Any other agent (Codex, Copilot, Windsurf, …)</b></summary>

Skills are plain Markdown with relative links. Point your agent at a skill's entry point (e.g.
`skills/<name>/SKILL.md`) and let it follow the phases — everything the skill needs lives
inside its own directory.

</details>

## Working on this repo

See [AGENTS.md](../AGENTS.md) for the repo map and principles, and
[CONTRIBUTING.md](../CONTRIBUTING.md) for how to add a new skill, command, agent or hook.
