#!/usr/bin/env bash
# Knowledge-typed definitions may exist only under /knowledge.
#
# The invariant: an ID DEFINITION (front matter `id: BR-...`) belongs in /knowledge.
# A REFERENCE to an ID in prose is fine anywhere — that is the point of ID-based
# referencing. Only definitions are checked.
set -uo pipefail
# Run against a workspace root (default: current directory). The knowledge base is
# expected at ./knowledge/. Pass the root as $1 if invoking from elsewhere.
cd "${1:-$PWD}"

fail=0
PREFIXES='BR|WF|JR|CN|IN'

echo "Checking knowledge placement..."

# 1. Definitions outside /knowledge
# Prune heavy/irrelevant trees (dependencies, VCS) and the directories we deliberately
# skip — the corpus itself and this skill's own files — in the find, so we never
# descend into them or spawn head/grep per file there.
while IFS= read -r f; do
  if head -20 "$f" | grep -Eq "^id: ($PREFIXES)-"; then
    echo "  VIOLATION  $f defines a knowledge ID outside /knowledge/"
    fail=1
  fi
done < <(find . \
  \( -path ./.git -o -path ./knowledge -o -name node_modules -o -name vendor -o -name knowledge-curation \) -prune \
  -o -type f -name '*.md' -print 2>/dev/null)

# 2. Duplicate ID definitions anywhere
dupes=$(grep -rhE "^id: ($PREFIXES)-" --exclude-dir=_templates knowledge/ 2>/dev/null \
        | sort | uniq -d)
if [ -n "$dupes" ]; then
  echo "  VIOLATION  duplicate ID definitions:"
  echo "$dupes" | sed 's/^/             /'
  fail=1
fi

# 3. Requirements leaking into knowledge
if grep -rlE "^id: REQ-" --exclude-dir=_templates knowledge/ 2>/dev/null | grep -q .; then
  echo "  VIOLATION  REQ- definitions found in /knowledge — requirements belong in engagement specs, not the corpus"
  fail=1
fi

[ "$fail" -eq 0 ] && echo "  OK — no placement violations."
exit $fail
