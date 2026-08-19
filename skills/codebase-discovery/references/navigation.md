# Navigating the code — the source ladder (stated only here)

How recon finds things. **The principle: don't re-derive what the repo already states.** Most
codebases declare their own structure in files the build system reads; that's a fact, where a
pattern search over the same question is an inference. So read what's declared, ask the repo's own
toolchain, then search — and record which of those actually answered.

| Tier | Answers | Availability | Falls back to |
|---|---|---|---|
| **A. Declared manifests** | module boundaries, dependencies, externals, runtime topology | universal — `Read` only | C |
| **B. The repo's own toolchain** | the same graph, resolved exactly | needs a shell and the toolchain the developers use | A |
| **C. Text search (ripgrep)** | literals — enums, messages, config keys — and scoped/multiline patterns | always | — the floor |
| **D. AST search** | "what implements this", syntactic shapes | optional, if installed | C |
| **E. LSP** | precise symbol graph, call hierarchy | opt-in, untested | C |

Tier C is the floor because `Read` + `Grep` + `Glob` is the only toolset guaranteed on every host.
Everything above it is conditional — including B, since a host without shell access has A and C only.

**Who runs what.** Tiers A, B and D run in the **main agent**. Sub-agent scouts have no shell by
design, and their results shape which scopes exist, so the map is built centrally and scouts are then
handed scoped areas to read.

---

## Tier A — the declared manifests

Language-agnostic by construction: read whatever this repo declares.

| Ecosystem | Read | Yields |
|---|---|---|
| .NET | `*.sln`, `*.csproj` — `ProjectReference`, `PackageReference` | project graph, layering, externals |
| Java / Kotlin | `pom.xml` modules, `settings.gradle`, `build.gradle` | module graph, dependencies |
| JS / TS | `package.json` workspaces, `tsconfig.json` project refs, nx/turbo/lerna config | package graph, path aliases |
| Python | `pyproject.toml`, `setup.cfg`, requirements files | packages, externals |
| Go / Rust | `go.mod`, `go.work` / `Cargo.toml` workspace members | modules, crates |
| Ruby / PHP | `Gemfile`, `*.gemspec`, engines / `composer.json` | gems, autoload roots |
| **Any** | `docker-compose.yml`, k8s manifests, Terraform modules, `Procfile` | **runtime** boundaries |

That last row earns its place: deployment topology often reveals boundaries the code doesn't, and a
"monolith" that deploys as six services has six boundaries someone already decided.

**On large repos, read the index, not everything.** Take the project list from the solution or
workspace file, then extract only the reference elements from each project file. Ninety project files
read in full is the mistake this tier exists to avoid.

> **Report the boundaries the repo declares; don't infer where it should be cut.** Recon describes
> the system as-is. Deciding how to split it is design work, and a different job.

---

## Tier B — the repo's own toolchain

You don't need to install anything to get an exact graph — you need what the developers already have.
Probe first, and fall back to parsing the Tier A files if it's absent:

| Probe | Then |
|---|---|
| `command -v dotnet` | `dotnet sln list`, `dotnet list <proj> reference` |
| `command -v gradle` | `gradle projects` |
| `command -v npm` | `npm ls --depth=0`, `tsc --showConfig` |
| `command -v go` | `go list ./...`, `go mod graph` |
| `command -v cargo` | `cargo metadata` |

**Read-only, no-network invocations only.** Never trigger a restore, fetch or build without asking
first: `mvn dependency:tree` on an unprimed repo can download half the internet, and discovery must
not mutate the target or pull dependencies as a side effect. If the only route to the graph is a
build, ask, or drop to Tier A.

---

## Tier C — text search, used properly

The default, and the right tool for **literals**: enum values, error and validation message strings,
config keys, event and command names. Nothing beats it there, LSP included — those are strings, not
symbols.

Get more out of it than a bare pattern:

- `--type cs` / `-g '*.java'` — scope by language. On a polyglot repo this is the difference between
  a usable result and a wall of matches from generated code.
- `-U` — multiline, for constructs that span lines: an annotation plus the signature it decorates, a
  multi-line condition, a chained builder.
- `-C` / `-A` / `-B` — read the region around a match instead of opening the whole file.
- `-l` and `--count` first — size the problem before reading a single match, and decide whether it's
  worth a scout.

---

## Tier D — AST search (optional)

Finds code by syntactic shape rather than text: classes implementing an interface, conditionals on a
domain field, handlers carrying an authorization annotation. Regex approximates these and gets nested
and multi-line forms wrong.

Probe `command -v ast-grep`, then `command -v semgrep`; use the first present, otherwise Tier C and
note it. This tier is an optimisation, never a requirement — **never ask the user to install
anything mid-run.** Not exercised end-to-end.

---

## Tier E — LSP

Opt-in and untested; setup and its caveats are in
[`code-intelligence.md`](code-intelligence.md).

---

## Record what answered the question

A boundary read from `go.mod` and a boundary inferred by grepping imports produce the same sentence
in `current-architecture.md` — and one of them can be wrong in both directions, since a project can
reference what it never uses, and DI or reflection couples things no import shows.

So:

- **Note the tier that produced each area of the map** in `recon-manifest.md` — the
  **Navigation tiers used** line and the `Source tier` column on the areas table. Falling back is
  fine; falling back silently is not.
- **Let the tier set confidence** — see the confidence section in
  [`provenance-and-status.md`](provenance-and-status.md). Declared and symbol-resolved sources are
  High; text-inferred structure is Medium at best, and an `[assumption]` where the claim is
  load-bearing.
