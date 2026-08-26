---
id: "config-{domain}-{topic}"   # plain descriptive slug — entries are referenced
status: draft                    # by name, not by ID
basis: documented
source: "{where it came from}"
updated: "{YYYY-MM-DD} {your name}"
related: []                      # IDs only
---

# <Topic> — configuration

> `domains/<domain>/tech/configurations/` — domain-level, grouped by topic. This is
> technology we don't have code access to verify yet (see `knowledge-boundary.md`):
> curate what the source states, label `basis` honestly, and expect it to need
> re-verification once repos land.

## <Config name>

- **Value:** <the stated value, threshold, limit, or flag state>
- **Kind:** <business-threshold — a number/rule the spec states (timeout, retry
  count, retention period, feature flag) | environment — varies by
  deployment (env var, service endpoint, infra setting)>
- **Basis:** <documented|stated|inferred|assumed> — _<source citation>_
