#!/usr/bin/env bash
# List files still carrying shipped example content.
# Run before showing anything to the client — example content cited as fact is the
# most embarrassing possible failure of a knowledge base.
set -uo pipefail
# Run against a workspace root (default: current directory). The knowledge base is
# expected at ./knowledge/. Pass the root as $1 if invoking from elsewhere.
cd "${1:-$PWD}"

found=$(grep -rl '^example: true' knowledge/ 2>/dev/null | grep -v '_templates' | sort)

if [ -z "$found" ]; then
  echo "OK — no example content remaining."
  exit 0
fi

n=$(echo "$found" | wc -l | tr -d ' ')
echo "$n file(s) still contain shipped example content:"
echo "$found" | sed 's/^/  /'
echo
echo "These are illustrative scaffolding, not real knowledge."
echo "Replace or delete them before the corpus is used in anger."
exit 1
