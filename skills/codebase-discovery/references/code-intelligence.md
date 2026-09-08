# Enabling code-intelligence / LSP navigation

**Tier E of the source ladder in [`navigation.md`](navigation.md)** covers symbol-level navigation:
go-to-definition, find-references, call hierarchy, type information. That file says where LSP sits
among the tiers and when recon reaches for it; this one covers only what the tier needs to
exist, and how to tell whether you have it.

It deliberately doesn't document any one bridge's configuration. That belongs in that project's own
README, changes without notice, and would rot here silently.

> ## Status: untested
>
> **Grep + sub-agents is the path this skill is exercised with.** No full discovery has been run
> end-to-end through an LSP bridge, so treat this as a promising option rather than a supported one:
> the bridges are third-party, their tool names and config vary, and the guidance below is derived
> from their documentation rather than from a run we've done.
>
> The downside is bounded by design: if the symbol tools aren't there, recon uses grep and the run
> proceeds. But don't plan around LSP being available, and don't spend long fighting the setup on a
> deadline.
>
> If you do get it working, name the bridge, version and language on the recon manifest's
> **Navigation tiers used** line and tell the toolkit maintainers, so this can stop being untested.

> ## A language server must be installed **and running** for this option to work
>
> LSP navigation is only actually available when **all** of the following are true:
>
> 1. A **language server** for your repo's language is installed (e.g. `gopls`,
>    `typescript-language-server`, `pylsp`).
> 2. An **MCP bridge** that speaks LSP is built and registered with your agent, and it can launch
>    that language server.
> 3. The language server can **start and index your project**.
>
> If any of these isn't in place, the symbol tools won't be present, so the skill will report that
> LSP isn't available and **fall back to grep**. LSP is opt-in, never a requirement, and the skill
> runs fine without it.

---

## What it gives the skill

Whatever the bridge calls them, recon wants four capabilities, and uses them for precise structure
and relationship tracing instead of text search:

| Capability | Use in recon |
|---|---|
| Go to definition | Resolve where a symbol is defined |
| Find references | Everywhere a rule/entity/service is used (workflow tracing, impact) |
| Hover / signature | Type, signature and doc for a symbol |
| Document or workspace symbols | Enumerate an API surface or a module's members |

**Don't assume specific tool names.** Bridges expose these under their own names. An `lsp_`-prefixed
set is common, but it's a convention, not a contract. Enumerate the tools the server actually
registers and map them to the capabilities above.

Text patterns (enum values, error and validation message strings) are still best found with grep, so
the two modes complement each other rather than competing.

---

## Setup

**This is prep work, done before a run and by choice.** Don't raise any of it during a discovery:
the recon playbook and Tier D of the ladder both say never ask the user to install anything mid-run,
and that stands. If the symbol tools are absent when recon starts, note it and carry on down the
ladder.

### 1. Install the language server(s) for your repo

Install only what your target codebase needs, one of these rather than all:

- **Go** — `go install golang.org/x/tools/gopls@latest`
- **TypeScript / JavaScript** — `npm install -g typescript-language-server typescript`
- **Python** — `pip install python-lsp-server`

Verify each is on your `PATH` (e.g. `gopls version`). **If the language server isn't installed and
runnable, the LSP option cannot work**, and that's the most common cause of "LSP unavailable".

### 2. Pick an LSP-backed MCP bridge

Two that are known to work, both third-party:

| Bridge | Shape |
|---|---|
| [lsp-mcp](https://github.com/mickeyinfoshan/lsp-mcp) | Small and transparent; you build it and point a config file at the language servers you installed |
| [Serena](https://github.com/oraios/serena) | Batteries-included, ~40 languages, manages language servers for you; more setup surface, less per-language wiring |

Follow that project's own README for building and configuring it, including which languages it
launches and how. Pin to a release or a known commit rather than tracking `main`: you're about to
grant this process tool access inside your agent, on whatever codebase you point it at. On client
work, check that's acceptable before you do.

### 3. Register it with your agent

**Claude Code.** The easiest route is the CLI:

```bash
claude mcp add --scope user lsp -- /absolute/path/to/the/bridge [its flags]
```

Or register it for one project by creating `.mcp.json` in that project's root:

```json
{
  "mcpServers": {
    "lsp": {
      "command": "/absolute/path/to/the/bridge",
      "args": ["--whatever", "flags", "the", "bridge", "documents"]
    }
  }
}
```

> `settings.json` is **not** the place for this — it holds permissions and hooks, not `mcpServers`.
> A server declared there simply won't appear, which looks exactly like the "language server isn't
> running" failure and wastes an hour.

**Cursor / Windsurf / any MCP client.** Point your MCP config at the same command, following that
client's own format.

### 4. Confirm it's live

Restart the agent and check the server is connected and its tools are listed. Match them against the
four capabilities above. If they're missing, the language server or the bridge isn't running, and
the skill will use grep until that's fixed.

---

## Troubleshooting

- **No symbol tools showing:** the bridge isn't registered or failed to start. Check the agent's
  MCP server list, then the bridge's own logs (location is up to that project).
- **Empty definition/references results:** point the position at the symbol itself, and make sure the
  project's build config (e.g. `tsconfig.json`, a Go module) is present so the server can index.
- **Language server won't start:** run its command manually to confirm it's installed and on `PATH`.
