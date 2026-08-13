# agent-toolkit

**DiUS's shared toolkit of skills, commands, agents and hooks for AI coding agents.**

`agent-toolkit` is a monorepo where DiUS consultants publish and reuse the working pieces they
build for AI coding agents — day-to-day tools, not one-off prompts. It's a growing collection,
installable as a whole or one component at a time, that stays **tool-agnostic** wherever
possible and installs as a **Claude Code plugin** in one command.

---

## Install

<details open>
<summary><b>Any agent — <code>npx skills</code> (recommended)</b></summary>

Installs skills into any of ~55 supported agents (Claude Code, Cursor, Codex, OpenCode,
Gemini, Copilot…) straight from GitHub — the most tool-agnostic route:

```bash
# interactive — detects your agents and prompts, installs the whole toolkit
npx skills add DiUS/agent-toolkit

# install a single skill only
npx skills add DiUS/agent-toolkit --skill codebase-discovery

# preview what would be installed
npx skills add DiUS/agent-toolkit --list
```

</details>

<details>
<summary><b>Claude Code (plugin — skills + commands + agents)</b></summary>

```
/plugin marketplace add DiUS/agent-toolkit
/plugin install agent-toolkit@dius-agent-toolkit
```

Local / development:

```bash
git clone https://github.com/DiUS/agent-toolkit.git
claude --plugin-dir /path/to/agent-toolkit
```

</details>

See [docs/getting-started.md](docs/getting-started.md) for per-tool notes (Cursor, Gemini CLI,
and any other agent).

---

## What's in the toolkit

| Skill | Description |
|---|---|
| [`codebase-discovery`](skills/codebase-discovery/) | Reverse-engineers domain, architecture, business rules, workflows and a business glossary from an existing codebase into lean onboarding docs — ready for harness engineering / Spec Kit. |
| [`prd-to-steel-thread`](skills/prd-to-steel-thread/) | Converts a product PRD into a steel-thread-first roadmap of demo-ready vertical slices, with just-in-time infrastructure and capacity-aware parallelism for SDD technical planning. |

New skills, commands, agents and hooks are added over time — see
[CONTRIBUTING.md](CONTRIBUTING.md) to add your own.

---

## Component types

- **Skills** (`skills/`) — self-contained Markdown workflows (an orchestrator plus its own
  playbooks, references and templates). The most portable component; any capable agent can
  follow one.
- **Commands** (`commands/`) — single Markdown files with frontmatter that become slash
  commands in Claude Code and compatible agents.
- **Agents** (`agents/`) — Claude Code subagent definitions a skill can delegate work to
  (scoped to the minimum tools they need, read-only where they only inspect code).
- **Hooks** (`hooks/`) — optional, Claude-Code-specific automations. Not enabled by default;
  see [hooks/README.md](hooks/README.md).

---

## Repository structure

```
agent-toolkit/
├── .claude-plugin/
│   ├── marketplace.json          # /plugin marketplace add …
│   └── plugin.json               # registers ./skills, ./commands, and the bundled agents
├── skills/
│   └── <name>/                   # self-contained skill — travels as one unit
├── commands/                     # slash commands (README.md explains the convention)
├── agents/                       # Claude Code subagents a skill can delegate to
├── hooks/                        # optional, opt-in Claude Code hooks (not wired in)
├── docs/
│   └── getting-started.md        # per-tool install notes
├── scripts/validate.js           # verification gate (manifests, frontmatter, paths)
├── .github/workflows/validate.yml# CI: runs the gate on push/PR
├── AGENTS.md                      # working context for any agent contributing here
├── CLAUDE.md                      # Claude Code specifics (imports AGENTS.md)
├── CONTRIBUTING.md
├── README.md
├── LICENSE
└── .gitignore
```

---

## Contributing / working on this repo

This repo is itself harness-ready: [AGENTS.md](AGENTS.md) gives any agent the context and
guardrails to contribute (and [CLAUDE.md](CLAUDE.md) adds Claude Code specifics), while
[CONTRIBUTING.md](CONTRIBUTING.md) covers the mechanics of adding a skill, command, agent or
hook. Before committing, run the verification gate — also enforced in CI:

```bash
node scripts/validate.js
```

## License

[MIT](./LICENSE)
