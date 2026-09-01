# Where knowledge belongs

A knowledge base like this often has **no code access and no repositories** —
everything it knows lives in `/knowledge`. This file records why that is the right
home and the placement discipline that keeps it coherent.

## The principle

Business knowledge is durable; it outlives the code that implements it. A rule about
eligibility criteria will survive three rewrites of the service that enforces it, so
it belongs in a central, canonical store — `/knowledge` — not bound to any one
disposable artefact.

## Central, always

- Business rules, workflows, journeys, personas, glossary
- Table ownership and read coupling
- Platform constraints
- Anything spanning more than one domain
- **A domain's technology layer, while there is no code access.** Which tables
  this domain owns/reads (`tech/data/`), data-exchange mechanism and API contract
  shape (`tech/integrations/`), configuration values (`tech/configurations/`), and
  UI specifications — screen fields, validations, navigation (`tech/ui/`) — all
  curated from source material the same as business content, but kept in their
  own folder because they're *provisional*: they stand in for code access the
  workspace doesn't have, and a spec's description of them is often already stale
  by the time it's written down. See the tiers in `structure.md`.
- **Table schema.** A table's columns aren't scoped to any one domain (any domain
  may read any table, regardless of the platform's write-ownership rule), so `platform/data-schema/<table>.md` is central at
  the *platform* tier — the same reasoning used for `data-ownership.md`. Still
  provisional pending code access; it just isn't domain-scoped the way the rest of
  the technology layer is.

## Why distributing business knowledge would break this

1. **Cross-domain knowledge has no other valid home.** The table registry, journeys
   and personas belong to no single domain.
2. **The coverage model collapses.** A domain with no curated content becomes
   invisible rather than visibly unknown — and visible ignorance is the mechanism
   this workspace runs on.
3. **Pre-code analysis becomes impossible.** BA work is cross-domain and happens
   before implementation. Most domains here do not yet exist as anything but a name.

## Placement discipline within /knowledge

Every fact lives at the narrowest tier where it is actually true — platform vs.
domain vs. feature. See `structure.md` for the tiers and `front-matter.md` for
the ID conventions. **One fact, one home:** reference an ID rather than restating it,
because duplicated knowledge drifts and two answers cannot be adjudicated.

## When you are unsure

Tier placement (platform vs. domain vs. feature) follows `structure.md` — the
narrowest tier where the fact is actually true. This file's rule is the simpler one:
business knowledge is central, in `/knowledge`, always.

Mechanical check: the skill's `scripts/check-placement.sh` (run from the workspace
root: `bash <skill>/scripts/check-placement.sh`, where `<skill>` is wherever this
skill is installed).
