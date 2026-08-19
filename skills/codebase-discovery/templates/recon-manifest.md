# Recon Manifest

> **Last updated:** YYYY-MM-DD
> **Purpose:** Records what fed the recon so later runs can detect staleness. NOT an
> onboarding doc — local process state, so git-ignoring this file is recommended.

## Run info

- **Mode:** full | code-only
- **Scope:** <repo / subsystem>
- **Recon commit:** <git rev-parse HEAD> · **working tree:** clean | dirty (uncommitted changes
  were read, so the commit alone doesn't describe what recon saw)
- **Available inputs:** git for freshness (yes/no) · sub-agents (yes/no) · stakeholder (yes/no)
- **Navigation tiers used:** <which of declared manifests / repo toolchain / text search / AST search
  / LSP were actually available and used — and which answered the structural map. A graph from a
  manifest is fact; one inferred from imports is not.>

## Existing docs read (Phase 0)

| Doc | Path | Last modified |
|---|---|---|
| README | ./README.md | <date> |

## Areas covered (Phase 1)

<!-- The unit the freshness check works in: the next run diffs the recon commit against HEAD and
re-recons the areas whose paths changed. Keep this to areas, not one row per file. -->

| Area | Paths | Depth reached | Source tier |
|---|---|---|---|
| data model | src/models/, db/migrations/ | full | declared + text search |
| billing rules | src/billing/ | hotspots only | text search (inferred) |

## Files actually read (Phase 1)

<!-- The high-signal subset recon opened — bounded by design, not a listing of the repo. Only
needed for the no-git fallback, where these are hashed instead of diffed. -->

| Path | Area | Hash (no-git fallback only) |
|---|---|---|
| src/... | data model | <omit when git is available> |

## Freshness check log

| Date checked | Compared against | Files changed | Docs affected | User's decision |
|---|---|---|---|---|
| <date> | <recon commit sha> | <n> in <areas> | <docs> | re-recon'd <areas> / full re-run / proceeded as-is (claims reverted to [unchecked]) / report only |
