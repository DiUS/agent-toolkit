#!/usr/bin/env bash
# Validate front matter across the knowledge base.
# Six fields, four enum values, two status values. If this passes, the corpus is
# machine-readable; if it fails, the message tells you exactly what to change.
set -uo pipefail
# Run against a workspace root (default: current directory). The knowledge base is
# expected at ./knowledge/. Pass the root as $1 if invoking from elsewhere.
cd "${1:-$PWD}"
python3 - <<'PY'
import glob, sys
try:
    import yaml
except ImportError:
    print("  SKIP — pyyaml not installed (pip3 install pyyaml)"); sys.exit(0)

BASIS    = ["documented", "stated", "inferred", "assumed"]
STATUS   = ["draft", "verified", "open", "answered", "accepted", "proposed", "superseded"]
COVERAGE = ["curated", "partial", "name-only", "unknown"]

fail = 0
def bad(f, msg):
    global fail
    print(f"  {f}\n      {msg}")
    fail = 1

for f in sorted(glob.glob("knowledge/**/*.md", recursive=True)):
    if "_templates" in f:
        continue
    # sources/ and decisions/ are workspace staging/records, not curated corpus.
    if "/sources/" in f or "/decisions/" in f:
        continue
    # README.md and AGENTS.md are folder explainers / the agent on-ramp, not curated content.
    if f.endswith("README.md") or f.endswith("AGENTS.md"):
        continue
    # Pure navigation pages carry no metadata by design — requiring it would be
    # ceremony with no reader. Domain indexes DO need it; they carry coverage.
    if f.endswith("index.md") and "/domains/" not in f:
        continue
    txt = open(f, encoding="utf-8").read()
    if not txt.startswith("---"):
        bad(f, "no front matter — add the six-line block from _templates/README.md")
        continue
    try:
        fm = yaml.safe_load(txt.split("---", 2)[1]) or {}
    except Exception as e:
        bad(f, f"front matter is not valid YAML ({str(e).splitlines()[0]}). "
               "Usually an unquoted colon in a value.")
        continue

    if not fm.get("id"):
        bad(f, "missing 'id'")
    st = fm.get("status")
    if st not in STATUS:
        bad(f, f"status is {st!r} — must be one of: {', '.join(STATUS)}")
    b = fm.get("basis")
    if b is not None and b not in BASIS:
        bad(f, f"basis is {b!r} — must be one of: {', '.join(BASIS)}")
    if st == "verified" and b == "assumed":
        bad(f, "status 'verified' with basis 'assumed' — confirming an assumption "
               "changes its basis to 'stated' or 'documented'")
    if b and not str(fm.get("source", "")).strip():
        bad(f, "basis is set but 'source' is empty — put something checkable, or '—'")
    cov = fm.get("coverage")
    if cov is not None and cov not in COVERAGE:
        bad(f, f"coverage is {cov!r} — must be one of: {', '.join(COVERAGE)}")

print("  OK — front matter is valid." if not fail else "")
sys.exit(fail)
PY
