# CLAUDE.md

Guidance for Claude Code when working on **this** repository. Everything in
**[AGENTS.md](AGENTS.md)** applies, so start there for the repo map, principles, and how to add
each component type. This file only adds what's specific to Claude Code.

@AGENTS.md

## Claude Code specifics

This repo is also a **Claude Code plugin** (single bundled plugin, `agent-toolkit`), which is
the primary target.

- **Plugin manifests** live in `.claude-plugin/` — `plugin.json` (registers `./skills`,
  `./commands`, and each bundled agent) and `marketplace.json` (marketplace
  `dius-agent-toolkit`, plugin `agent-toolkit`, sourced from GitHub `DiUS/agent-toolkit`). Keep
  both valid JSON; `scripts/validate.js` checks them.
- **Subagents** in `agents/` are Claude Code workers a skill can delegate to (for example, to
  keep the main context lean or to run an isolated pass). Each is registered in the `agents`
  array of `plugin.json`. On non-Claude hosts they're absent, and the skill falls back to a
  generic sub-agent or inline work. Keep that fallback path intact when editing skill
  behaviour.
- **Commands** in `commands/` register as slash commands automatically via the plugin. They're
  a Claude Code convention; other agents fall back to reading the referenced skill directly.
- **Hooks are opt-in.** Nothing under `hooks/` is wired into `plugin.json`. Don't make a hook a
  dependency of any skill, command or agent in this repo.

## Testing changes locally

```bash
# load the plugin from this working tree
claude --plugin-dir /path/to/agent-toolkit

# preview skill discovery for the npx-skills channel
npx skills add . --list
```

## Before committing

Run the verification gate (also enforced in CI):

```bash
node scripts/validate.js
```
