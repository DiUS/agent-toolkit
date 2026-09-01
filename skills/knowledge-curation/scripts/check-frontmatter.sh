#!/usr/bin/env bash
# Validate front matter across the knowledge base.
# Checks the required id and the status/basis/coverage vocabularies, plus ADR-specific
# shape (ADR- id, named deciders). If this passes, the corpus is machine-readable;
# if it fails, the message tells you exactly what to change.
set -uo pipefail
# Run against a workspace root (default: current directory). The knowledge base is
# expected at ./knowledge/. Pass the root as $1 if invoking from elsewhere.
cd "${1:-$PWD}"
python3 - <<'PY'
import glob, re, sys
try:
    import yaml
except ImportError:
    print("  SKIP — pyyaml not installed (pip3 install pyyaml)"); sys.exit(0)

BASIS    = ["documented", "stated", "inferred", "assumed"]
# draft/verified: curated content and ADRs. open/answered/unresolvable: question lifecycle.
STATUS   = ["draft", "verified", "open", "answered", "unresolvable"]
COVERAGE = ["curated", "partial", "name-only", "unknown"]

fail = 0
def bad(f, msg):
    global fail
    print(f"  {f}\n      {msg}")
    fail = 1

for f in sorted(glob.glob("knowledge/**/*.md", recursive=True)):
    f = f.replace("\\", "/")  # normalise Windows separators so the path checks below match
    if "_templates" in f:
        continue
    # sources/ is a workspace register (the manifest), not curated corpus. decisions/
    # (ADRs) ARE validated — they carry the same id/status front matter as content.
    if "/sources/" in f:
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
    # Take the block between the opening and closing '---' *lines*. Splitting on the
    # first two '---' substrings would truncate a value that itself contains '---'
    # (e.g. a citation like source: "spec.docx §3 --- appendix").
    m = re.match(r"^---[ \t]*\r?\n(.*?)\r?\n---[ \t]*(?:\r?\n|$)", txt, re.DOTALL)
    if not m:
        bad(f, "front matter has no closing '---' line")
        continue
    try:
        fm = yaml.safe_load(m.group(1)) or {}
    except Exception as e:
        bad(f, f"front matter is not valid YAML ({str(e).splitlines()[0]}). "
               "Usually an unquoted colon in a value.")
        continue

    if not fm.get("id"):
        bad(f, "missing 'id'")
    st = fm.get("status")
    if st not in STATUS:
        bad(f, f"status is {st!r} — must be one of: {', '.join(STATUS)}")

    # Provenance is mandatory on curated content: an unlabelled statement reads as
    # fact (ba-principles.md rule 2), and structure.md says do not omit basis. Two
    # kinds of file legitimately carry none, so they're exempt from the requirement
    # (but a basis they *do* set is still range-checked):
    #   - the platform registries, which aggregate the corpus rather than state a
    #     sourced fact;
    #   - ADRs (knowledge/decisions/), which record a decision and are held to
    #     'deciders' instead.
    REGISTRY_IDS = {"coverage", "data-ownership", "service-domains"}
    provenance_exempt = ("/decisions/" in f) or (str(fm.get("id") or "") in REGISTRY_IDS)

    b = fm.get("basis")
    if b is not None and b not in BASIS:
        bad(f, f"basis is {b!r} — must be one of: {', '.join(BASIS)}")
    elif b is None and not provenance_exempt:
        bad(f, "missing 'basis' — state how we know this "
               f"({'/'.join(BASIS)}); structure.md says do not omit it")
    if st == "verified" and b == "assumed":
        bad(f, "status 'verified' with basis 'assumed' — confirming an assumption "
               "changes its basis to 'stated' or 'documented'")
    src = str(fm.get("source", "")).strip()
    if not src and (b is not None or not provenance_exempt):
        bad(f, "missing 'source' — put something checkable, or '—'")
    cov = fm.get("coverage")
    if cov is not None and cov not in COVERAGE:
        bad(f, f"coverage is {cov!r} — must be one of: {', '.join(COVERAGE)}")

    # ADRs (knowledge/decisions/) are attributable decision records — hold them to
    # their own shape: an ADR- id (per the ID conventions) and named deciders.
    if "/decisions/" in f:
        adr_id = str(fm.get("id") or "")
        if adr_id and not re.fullmatch(r"ADR-\d+", adr_id):
            bad(f, f"id is {adr_id!r} — an ADR id must look like 'ADR-001' (ADR- then a number)")
        if not (fm.get("deciders") or []):
            bad(f, "'deciders' is empty or missing — an ADR must record who made the decision")

print("  OK — front matter is valid." if not fail else "")
sys.exit(fail)
PY
