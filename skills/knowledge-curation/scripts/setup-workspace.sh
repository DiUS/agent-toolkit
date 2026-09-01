#!/usr/bin/env bash
# Idempotent, additive-by-construction workspace setup for the knowledge base.
#
# Replaces the prose "workspace setup" decision tree. The LLM's job shrinks to:
# run this, branch on the exit code.
#
# Invariant: NEVER overwrite. The copy loop creates only files that do not yet
# exist, so re-running is always safe — an interrupted first run is repaired by
# running it again, and a later scaffold version forward-migrates an existing
# corpus by adding only its new files. There is no destructive path to take.
#
# Usage:  setup-workspace.sh [workspace-root] [--adopt]
#   workspace-root  folder that holds (or will hold) ./knowledge/  (default: PWD)
#   --adopt         permission — granted by the human in chat, never by the LLM
#                   on its own — to add the scaffold into an existing ./knowledge/
#                   that is NOT one of this skill's corpora (the exit-3 case).
#
# Exit codes (branch on these):
#   0  ready       — scaffold ensured; STATE line says created|extended|adopted
#   2  blocked     — ./knowledge exists as a FILE or SYMLINK; stop, tell the user
#   3  needs-adopt — ./knowledge exists but is not this skill's corpus and --adopt
#                    was not given; ask the user, then (only on yes) re-run --adopt
#   1  usage/error — bad arguments or the scaffold source is missing
#
# Prints one machine-readable line to stdout:  STATE=<created|extended|adopted>
set -uo pipefail

root="$PWD"
adopt=0
for arg in "$@"; do
  case "$arg" in
    --adopt) adopt=1 ;;
    -*)      echo "error: unknown option '$arg'" >&2; exit 1 ;;
    *)       root="$arg" ;;
  esac
done

# The scaffold ships inside this skill, next to scripts/.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
scaffold="$script_dir/../assets/knowledge-base/knowledge"
if [ ! -d "$scaffold" ]; then
  echo "error: scaffold not found at $scaffold" >&2
  exit 1
fi

if [ ! -d "$root" ]; then
  echo "error: workspace root '$root' does not exist" >&2
  exit 1
fi

target="$root/knowledge"

# A file or symlink named 'knowledge' is not a directory we may write into — the
# case a prose check quietly walked past. Hard stop.
if [ -L "$target" ]; then
  echo "  BLOCKED  '$target' is a symlink (-> $(readlink "$target" 2>/dev/null)); refusing to write through it" >&2
  echo "STATE=blocked"
  exit 2
fi
if [ -e "$target" ] && [ ! -d "$target" ]; then
  echo "  BLOCKED  '$target' exists and is not a directory; refusing to write over it" >&2
  echo "STATE=blocked"
  exit 2
fi

# Classify the destination.
#   absent                     -> created
#   corpus markers present     -> extended   (this skill's own knowledge base)
#   only scaffold files present-> extended   (our own partial/interrupted scaffold;
#                                             re-running is the repair — no foreign
#                                             content, so nothing to adopt)
#   contains foreign files     -> needs --adopt (exit 3) unless --adopt -> adopted
state=""
if [ ! -e "$target" ]; then
  state="created"
elif [ -f "$target/platform/coverage.md" ] && [ -f "$target/sources/manifest.md" ]; then
  state="extended"
else
  # Is anything under target NOT part of our scaffold? If the folder holds only
  # scaffold paths (or is empty), it is our own interrupted run, not a stranger's
  # directory — extend it. A single foreign file means it belongs to someone else.
  foreign=0
  while IFS= read -r f; do
    rel="${f#"$target"/}"
    if [ ! -e "$scaffold/$rel" ]; then
      foreign=1
      break
    fi
  done < <(find "$target" -type f)

  if [ "$foreign" -eq 0 ]; then
    state="extended"
  elif [ "$adopt" -eq 1 ]; then
    state="adopted"
  else
    echo "  NEEDS-ADOPT  '$target' exists and holds content this skill did not create" >&2
    echo "               (no corpus markers, and files outside the scaffold)." >&2
    echo "               Ask the user; only on an explicit yes, re-run with --adopt." >&2
    echo "STATE=needs-adopt"
    exit 3
  fi
fi

# Additive copy: create only files that do not exist. Never overwrite.
created=0
while IFS= read -r src; do
  rel="${src#"$scaffold"/}"
  dest="$target/$rel"
  if [ -e "$dest" ]; then
    continue
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  created=$((created + 1))
done < <(find "$scaffold" -type f)

echo "  OK — state=$state, files created=$created, none overwritten."
echo "STATE=$state"
exit 0
