#!/usr/bin/env bash
# EXAMPLE ONLY — a no-op hook script referenced by hooks/examples/hooks.json.
#
# Not wired into this toolkit; nothing calls this unless you copy the example
# hooks.json into your own project's Claude Code settings and point it here.
#
# Hook scripts receive event context as JSON on stdin. This one just reads
# and discards it, then exits 0 (success — does not block the tool call).
# Replace this body with real logic (linting, notifications, guardrails, …).

cat >/dev/null

exit 0
