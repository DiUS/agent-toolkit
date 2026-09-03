---
id: "BR-{DOMAIN}-{TOPIC}"    # shared base for every rule below; each appends -NNN
status: draft                # draft | verified
basis: documented            # documented|stated|inferred|assumed — the file-level
                             # default; an entry whose provenance differs overrides it
                             # inline (the `· <basis> — _source_` on the bullet below)
source: "{where it came from}"   # file-level default source; entries may cite their own inline
updated: "{YYYY-MM-DD} {your name}"
related: []                  # IDs only
---

# <Topic> — rules

> One file per topic within a feature's `rules/` folder — **never** directly
> under the domain (see `structure.md` for the tier layout, the `knowledge-curation` skill
> for how the feature gets decided). Not one file per rule: filename describes the
> topic/grouping, not the ID. Group rules under `##` sub-headings where that
> helps a reader scan; skip the sub-heading if the topic is already narrow enough.
>
> **Phrase it in business language**, even where the source is exact about the
> implementation — "products must be configured to allow refunds", not "set
> `refund_allowed_yn = 'Y'`". The literal field/value binding belongs in
> `tech/data-owned.md` or `tech/data-consumed.md`, not in the rule's own wording.

## <Sub-heading>

- **<Short title>.** <Rule statement, present tense, testable. Fold conditions,
  exceptions and rationale into the same sentence or two — if it takes more than
  that, it's probably two rules; split them.>
  `BR-{DOMAIN}-{TOPIC}-{NNN}` · <documented|stated|inferred|assumed> — _<source citation>_
  <If open: `OQ-<NNN>` — the ambiguity, stated as a question.>
  <Only if it matters for ownership/conflict checks: `touches: <table> (read|write)`
  — table name only. Full column detail belongs in
  `domains/<domain>/tech/data/data-consumed.md` (read) or `data-owned.md`
  (write), not here — link to it if it matters.>
