#!/usr/bin/env bash
# Structural / tier-discipline invariants of the knowledge base — the thing that
# keeps the ID scheme coherent, so a misplaced folder is a real defect, not cosmetics:
#   - every domain and feature folder carries its index.md
#   - tier-scoped directories live only at their tier. Directly under knowledge/ only
#     the known tiers; rules/ & workflows/ only under a feature; features/ & tech/ only
#     under a domain; questions/ only cross-cutting / domain / feature; constraints/
#     only at platform or domain tier; tech/ subfolders only data|integrations|
#     configurations|ui. The allowed sets below track knowledge/ conventions
#     (references/conventions/structure.md) — keep them in step if the tree changes.
# Read-only. Run from a workspace root (default: current dir), or pass a root as $1.
set -uo pipefail
cd "${1:-$PWD}"

fail=0
note() { echo "  VIOLATION  $1"; fail=1; }

if [ ! -d knowledge ]; then
  echo "  OK — no knowledge/ yet (nothing to check)."
  exit 0
fi

echo "Checking knowledge structure..."

# Flag every child directory of $1 whose name isn't in the allowed set $2 ($3 is the
# message hint). Underscore-prefixed directories are scaffolding and are skipped.
whitelist_dirs() {
  local parent=$1 allowed=$2 hint=$3 sub name
  [ -d "$parent" ] || return 0
  for sub in "$parent"/*/; do
    [ -d "$sub" ] || continue
    name=$(basename "$sub")
    case "$name" in _*) continue ;; esac
    case " $allowed " in
      *" $name "*) ;;
      *) note "${hint}: ${sub%/}" ;;
    esac
  done
}

# Only the known tiers live directly under knowledge/. Anything else is misplaced —
# most often a domain folder that skipped the domains/ tier.
whitelist_dirs knowledge "platform domains sources decisions questions" \
  "unexpected folder under knowledge/ — a domain belongs under domains/"

# Platform tier.
whitelist_dirs knowledge/platform "constraints data-schema journeys" \
  "unexpected folder at the platform tier"

# Domains: each carries an index.md, and only the known sub-tiers.
for d in knowledge/domains/*/; do
  [ -d "$d" ] || continue
  [ -f "${d}index.md" ] || note "domain missing index.md: ${d%/}"
  whitelist_dirs "${d%/}" "features tech questions constraints" \
    "unexpected folder under a domain — a feature belongs under features/, a rule/workflow under a feature"
  whitelist_dirs "${d%/}/tech" "data integrations configurations ui" \
    "unexpected folder under tech/"
done

# Features: each carries an index.md (the feature pointer), and only rules/workflows/questions.
for f in knowledge/domains/*/features/*/; do
  [ -d "$f" ] || continue
  [ -f "${f}index.md" ] || note "feature missing index.md (feature pointer): ${f%/}"
  whitelist_dirs "${f%/}" "rules workflows questions" \
    "unexpected folder under a feature — only rules/, workflows/, questions/"
done

[ "$fail" -eq 0 ] && echo "  OK — structure is valid."
exit "$fail"
