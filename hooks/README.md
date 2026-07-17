# Hooks

Hooks are shell commands Claude Code runs automatically at specific points in a session (for
example, before a tool call, or after a file edit). They are the most host-specific component
in this toolkit — support outside Claude Code varies or doesn't exist — so the toolkit stays
**host-agnostic by default**: no hooks are wired into [`.claude-plugin/plugin.json`](../.claude-plugin/plugin.json),
and nothing in `skills/`, `commands/` or `agents/` depends on one being present.

Treat everything under `hooks/` as **opt-in**. Consultants who want a hook can copy it into
their own project and enable it there; it is not enabled by installing this toolkit.

## Why none are enabled by default

- Hooks run arbitrary commands with the same permissions as the session — reviewing and
  opting in per-project is safer than a toolkit silently wiring one up.
- Behaviour would otherwise differ between Claude Code and every other agent this toolkit
  supports, breaking the host-agnostic principle.

## Adding a hook

A hook is a `hooks.json` (the event → command mapping) plus the script(s) it calls:

1. Add your files under `hooks/<name>/` (a `hooks.json` and any scripts), following the
   pattern in [`examples/`](./examples/).
2. Document what it does, when it fires, and any prerequisites in a short header comment or a
   README alongside it.
3. Do **not** reference it from `.claude-plugin/plugin.json` — keep it available but inactive
   in this repo. Consumers copy `hooks.json` (or merge it) into their own `.claude/settings.json`
   / project hooks config to enable it.
4. If you add a `hooks.json` anywhere under `hooks/`, it must be valid JSON —
   `node scripts/validate.js` checks this.

See the [Claude Code hooks documentation](https://docs.claude.com/en/docs/claude-code/hooks)
for the full event list, `hooks.json` schema, and configuration precedence.

## Examples

[`examples/`](./examples/) contains a commented example `hooks.json` and a tiny no-op script.
Both are illustrative only — copy and adapt them, don't expect them to do anything on their
own.
