# Contributing

Thanks for adding to `agent-toolkit`. Please read [AGENTS.md](AGENTS.md) first — it holds the
working rules and principles this repo is built on. This file covers the mechanics of adding
each component type.

## Ground rules

- **Keep it host-agnostic.** No hard dependency on hooks, MCP servers, or a specific runtime.
  Optional integrations must degrade gracefully. Claude-specific wiring stays in
  `.claude-plugin/`, `commands/`, `agents/` and `hooks/`.
- **Keep skills self-contained.** Everything a skill's entry point references must live inside
  its own `skills/<name>/` directory, because that's what gets installed.
- **Keep docs onboarding-lean.** Add depth to the specific file, not the index; prefer prose
  and small tables.
- **Verify against the source, and mind the tone.** Reflect what the code does; never frame
  existing documentation as untrustworthy.

## Adding a skill

1. Create `skills/<name>/SKILL.md` (or equivalent entry point) with YAML frontmatter
   containing at least `name` and `description` (the `description` drives auto-discovery and
   triggering — make it specific).
2. Put any playbooks, references, and templates the skill needs inside `skills/<name>/`.
3. Register it under `skills` in `.claude-plugin/plugin.json` (the `./skills` path already
   covers new directories, so usually no change is needed there).
4. Add a row to the skills table in [README.md](README.md).
5. Run the verification gate (below).

## Adding a command

1. Create `commands/<name>.md` with `name` + `description` frontmatter — see
   [commands/README.md](commands/README.md) for the convention and
   [commands/codebase-discovery.md](commands/codebase-discovery.md) for a worked example.
2. It ships automatically via the `commands` path already registered in
   `.claude-plugin/plugin.json`.
3. Run the verification gate.

## Adding an agent

1. Create `agents/<name>.md` with `name` + `description` frontmatter and a `tools` list scoped
   to only what the agent needs — prefer read-only tools for recon/verification-style workers.
2. Add it to the `agents` array in `.claude-plugin/plugin.json` if it should ship with the
   plugin.
3. Run the verification gate.

## Adding a hook

1. Create `hooks/<name>/` with a `hooks.json` and any script(s) it calls — see
   [hooks/README.md](hooks/README.md) and [hooks/examples/](hooks/examples/).
2. Do **not** reference it from `.claude-plugin/plugin.json` — hooks stay opt-in; document how
   a consumer copies it into their own project.
3. Run the verification gate; any `hooks/**/hooks.json` must be valid JSON.

## Editing the `codebase-discovery` skill

- Behaviour lives in `skills/codebase-discovery/playbooks/*.md`. Preserve the five-phase flow
  and the exception-only status model (`[unverified]` / `[assumption]` / `[outdated]` /
  `[contradicted]`; accepted knowledge is unmarked).
- Discovery/output conventions live in `skills/codebase-discovery/references/`.
- Output scaffolds live in `skills/codebase-discovery/templates/`.

## Verification gate (run before every commit)

```bash
node scripts/validate.js
```

It checks that the manifests are valid JSON with required keys, that every `SKILL.md`,
`agents/*.md` and `commands/*.md` (except its README) has `name` + `description` frontmatter,
that every path referenced by `plugin.json` exists, and that any `hooks/**/hooks.json` is valid
JSON. CI runs the same check on push and PR; a failing gate blocks merge.

Optional smoke tests:

```bash
npx skills add . --list                 # confirm skill discovery
claude --plugin-dir /path/to/this/repo  # load the plugin locally
```

## Commits & PRs

Keep changes small and atomic, with a clear message. Ensure `scripts/validate.js` passes and,
if you changed behaviour or structure, update the relevant docs (`README.md`, a component's own
README, or `AGENTS.md`) in the same PR.
