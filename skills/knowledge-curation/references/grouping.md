# Grouping rules, workflows and configurations

**Preserve the source's grouping.** The BA/PO who authored the document already
grouped related content. That grouping is the topic decision — don't reinvent
it. Only the filename may need derivation.

## Naming

1. **Heading** — use it if specific: "§4. Eligibility Rules" →
   `rules/eligibility.md`.
2. **Sub-heading** — use it if the parent is a container ("Business Rules",
   "Workflows"):
   ```
   §9. Workflows
     §9.1 Submission     → workflows/submission.md
     §9.2 Approval       → workflows/approval.md
   ```
3. **Business context** — if both headings are generic, derive the name from
   the entity, trigger, phase, or distinguishing attribute of the grouped
   content:
   ```
   §9. Workflows and Processing
     §9.1 Submission
     §9.2 Approval
     §9.3 Execution
   → workflows/order-lifecycle.md   (entity + phase across §9)
   ```
4. **Still unclear? Ask** with 2–3 candidate names and a one-line rationale
   each.

## Repeatability

Curating the same source twice should produce the same files, topics, and names.
That is **not** something LLM naming converges on by itself — step 3 ("derive the
name from the entity, trigger, phase, or distinguishing attribute") will pick
different words on different runs. Repeatability comes from a mechanism, not a hope:
**persist the confirmed mapping and reuse it.**

- On the **first** curation, once the user confirms the grouping (Method step 4),
  write the agreed section → topic → path mapping to
  `knowledge/sources/<source-slug>.mapping.md` — a plain record, one row per grouped
  file. (It lives under `sources/`, so it is staging metadata, exempt from the
  frontmatter checks, not curated corpus.)
- On any **re-run** — a resume, a re-curation, or a new version of the same source —
  load that file first and **reuse the recorded names and paths**. Only sections the
  mapping doesn't cover get fresh names (then append them to the mapping). This is
  what makes re-runs actually converge; without the file, they don't.

If the mapping file is missing (an older corpus, or a hand-built one), fall back to
deriving names as above and write the mapping as you go, so the next run is stable.

## Recording a grouping convention

If a domain uses a consistent grouping rule (e.g. "workflows grouped by
lifecycle phase"), note it in the domain's `index.md` under `## Curation
conventions`. One line. No inline comments per file.
