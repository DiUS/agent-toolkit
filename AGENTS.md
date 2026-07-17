# AGENTS.md

Working context and rules for any AI agent (or human) contributing to **this** repository —
the `agent-toolkit` repo itself, not the components it ships. `CLAUDE.md` imports this file and
adds Claude-Code-specific notes. Keep it lean: it loads into an agent's context every session.

## What this repo is

`agent-toolkit` is DiUS's shared collection of **skills, commands, agents and hooks** for AI
coding agents. It ships two ways: as portable components installable with `npx skills`, and as
a single Claude Code plugin bundling skills, commands and agents.

For the catalogue of what's currently in the toolkit, see [README.md](README.md). For how any
one component works, read that component's own entry point (a skill's `SKILL.md`, a command or
agent's frontmatter). This file is about contributing to the repo.

## Repo map

```
skills/<name>/                 Self-contained skills; everything a skill needs lives inside it.
commands/                      Slash commands — single Markdown files with frontmatter.
agents/                        Claude Code subagents a skill can delegate work to.
hooks/                         Optional, opt-in Claude Code hooks — not wired into the plugin.
.claude-plugin/                Claude plugin + marketplace manifests.
docs/getting-started.md        Per-tool install notes.
scripts/validate.js            Verification gate (run before committing).
.github/workflows/validate.yml CI that runs the gate on push/PR.
```

## Principles

- **Host-agnostic first.** Components should run on any capable agent. Do **not** add hard
  dependencies on hooks, MCP servers, or a specific runtime. Optional integrations must degrade
  gracefully — used when present, skipped cleanly when absent. Claude-specific wiring stays
  confined to `.claude-plugin/`, `commands/`, `agents/` and `hooks/`.
- **Skills are self-contained.** Everything a skill's entry point references (playbooks,
  references, templates) lives **inside its own `skills/<name>/` directory** — that directory is
  the unit `npx skills` and the plugin install. Never point a skill file at something outside
  its own directory.
- **Lean docs.** Docs (including this file) earn their length by making a contributor
  productive. Prefer prose and small tables; push depth into the specific file, not the index.

## How to add each component type

- **Skill** → new `skills/<name>/SKILL.md` (or equivalent entry point) with `name` +
  `description` frontmatter, self-contained. The `./skills` path in
  `.claude-plugin/plugin.json` already covers new subdirectories; add a row to the skills table
  in [README.md](README.md).
- **Command** → new `commands/<name>.md` with `name` + `description` frontmatter. It ships
  automatically via the `commands` path in `.claude-plugin/plugin.json`. See
  [commands/README.md](commands/README.md).
- **Agent** → new `agents/<name>.md` with `name` + `description` frontmatter and a `tools`
  list scoped to the minimum it needs (read-only where the agent only inspects code). Add it to
  the `agents` array in `.claude-plugin/plugin.json` to ship it in the plugin.
- **Hook** → new `hooks/<name>/` with a `hooks.json` and its script(s), following
  [hooks/README.md](hooks/README.md). Do **not** wire it into `.claude-plugin/plugin.json` —
  hooks stay opt-in; consumers copy them into their own project.

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full mechanics.

## Verification gate (required)

Before committing, run:

```bash
node scripts/validate.js
```

It checks that the manifests are valid JSON with required keys, that every `SKILL.md`,
`agents/*.md` and `commands/*.md` (except its README) has `name` + `description` frontmatter,
that every path referenced by `plugin.json` exists, and that any `hooks/**/hooks.json` is valid
JSON. CI runs the same script on every push and PR — a red gate blocks merge.

## Do not

- Add hooks/MCP as a hard requirement, or otherwise break host-agnostic behaviour.
- Reference files outside a skill's own directory from within that skill.
- Wire a hook into `.claude-plugin/plugin.json` — hooks are opt-in only.
- Bloat the repo docs or this file.
- Commit with a failing `scripts/validate.js`.

## Pointers

- Repo overview & install: [README.md](README.md)
- Per-tool setup: [docs/getting-started.md](docs/getting-started.md)
- Adding a component: [CONTRIBUTING.md](CONTRIBUTING.md)
