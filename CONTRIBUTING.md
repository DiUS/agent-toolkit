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
   [commands/README.md](commands/README.md) for the convention.
2. It ships automatically via the `commands` path already registered in
   `.claude-plugin/plugin.json`.
3. Run the verification gate.

Don't add a command that only wraps a skill: a `user-invocable` skill already provides
`/<skill-name>`, and a same-named command collides with it. Commands must also never reference
repo files by repo-relative path — once installed, the working directory is the consumer's
repo. Use `${CLAUDE_PLUGIN_ROOT}/…` or invoke the skill by name.

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

## State each rule once

Skills are read by an agent that follows whatever it's told, so the same instruction in two files
is a latent contradiction: someone relaxes one copy, the other still says the old thing, and which
one wins depends on reading order. Copies also drift silently — nothing fails.

So, within a skill:

| Kind of content | Where it lives |
|---|---|
| **Rules** — what must always be true of the output | one reference file, marked as the only statement of it |
| **Procedure** — how to carry out a phase | that phase's playbook |
| **Facts** — what was decided or found this run | the working-state file |
| **Checks** — verify a rule was followed | the verification playbook, phrased as a check that *points at* the rule |

Everything else links. A playbook that needs a rule says "apply the X in `references/y.md`" rather
than repeating it — and a reference that owns a rule says so in its heading, so the next editor
knows not to fork it.

Two exceptions, both deliberate:

- **Subagents** (`agents/*.md`) can't resolve a path into a skill, so they carry standalone copies.
  Where the wording matters, pin it with a check under `scripts/checks/` so the copies can't
  diverge.
- **Templates** get rendered into someone else's repo, so a terse in-place reminder is fine —
  but keep the rule itself in the reference and point at it.

## Editing the `codebase-discovery` skill

- Behaviour lives in `skills/codebase-discovery/playbooks/*.md`. Preserve the five-phase flow
  and the exception-only status model (`[unchecked]` / `[unverified]` / `[assumption]` /
  `[outdated]` / `[contradicted]`; accepted knowledge is unmarked). The flag vocabulary is closed
  — `references/provenance-and-status.md` defines it, and `scripts/checks/codebase-discovery.js`
  enforces the set.
- Discovery/output conventions live in `skills/codebase-discovery/references/`.
- Output scaffolds live in `skills/codebase-discovery/templates/`.
- The **secrets rule** is normative in `SKILL.md` only; playbooks, references and templates link
  it rather than restating it. The two bundled subagents keep a standalone copy because they
  can't resolve a path into the skill — change the rule in `SKILL.md`,
  `agents/codebase-recon-scout.md` and `agents/codebase-doc-verifier.md` together, or the
  verification gate fails.

## Verification gate (run before every commit)

```bash
node scripts/validate.js
```

It checks that the manifests are valid JSON with required keys, that every `SKILL.md`,
`agents/*.md` and `commands/*.md` (except its README) has `name` + `description` frontmatter,
that every path referenced by `plugin.json` exists, that relative markdown links resolve and a
skill's links stay inside that skill, and that any `hooks/**/hooks.json` is valid JSON. CI runs the
same check on push and PR; a failing gate blocks merge.

Keep `validate.js` component-agnostic: it validates format, not any one component's content. If
your component needs its own invariants enforced, add `scripts/checks/<component>.js` — the gate
loads it automatically. See [scripts/checks/README.md](scripts/checks/README.md).

Optional smoke tests:

```bash
npx skills add . --list                 # confirm skill discovery
claude --plugin-dir /path/to/this/repo  # load the plugin locally
```

## Commits & PRs

Keep changes small and atomic, with a clear message. Ensure `scripts/validate.js` passes and,
if you changed behaviour or structure, update the relevant docs (`README.md`, a component's own
README, or `AGENTS.md`) in the same PR.
