#!/usr/bin/env bash
# Structural invariants of the knowledge base that the other checks don't cover:
#   - every domain folder has an index.md
#   - every feature folder has an index.md (the feature pointer)
#   - rules/ and workflows/ live under a feature, never directly under a domain
# Read-only. Run from a workspace root (default: current dir), or pass a root as $1.
set -uo pipefail
cd "${1:-$PWD}"

fail=0
note() { echo "  VIOLATION  $1"; fail=1; }

if [ ! -d knowledge/domains ]; then
  echo "  OK — no domains yet (nothing to check)."
  exit 0
fi

echo "Checking knowledge structure..."

# Domains: each must have an index.md; rules/workflows must not sit directly under it.
for d in knowledge/domains/*/; do
  [ -d "$d" ] || continue
  [ -f "${d}index.md" ] || note "domain missing index.md: ${d}"
  [ -d "${d}rules" ]     && note "rules/ directly under a domain — belongs under a feature: ${d}rules"
  [ -d "${d}workflows" ] && note "workflows/ directly under a domain — belongs under a feature: ${d}workflows"
done

# Features: each must have its own index.md (feature pointer).
for f in knowledge/domains/*/features/*/; do
  [ -d "$f" ] || continue
  [ -f "${f}index.md" ] || note "feature missing index.md (feature pointer): ${f}"
done

[ "$fail" -eq 0 ] && echo "  OK — structure is valid."
exit "$fail"
