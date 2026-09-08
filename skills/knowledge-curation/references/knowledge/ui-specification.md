---
id: "ui-{domain}-{screen-name}"
status: draft
basis: documented
source: "{where it came from}"
updated: "{YYYY-MM-DD} {your name}"
related: []
---

# {Screen/Window Name} — UI specification

> `domains/<domain>/tech/ui/{screen-name}.md` — provisional UI specification from
> functional design. **This will be superseded by UI codebase analysis once repos
> are available.** Curating it now captures the intended design and creates a
> verification target.

## Purpose

{One line: what this screen does in business terms.}

## Fields

| Field | Type | Required | Validation | Default | Source |
|-------|------|----------|------------|---------|--------|
|       |      |          |            |         |        |

## Actions / Buttons

- **{Button name}:** {what it does, any enabled/disabled rules}

## Navigation

{How user reaches this screen, and where actions lead}

## Validations

{Screen-level or cross-field validations that occur on this screen — rule-level
validations should already be in `rules/`, link them here by ID if they surface on
this screen.}

## Notes

{Implementation details, references to mockups, anything that helps understand
intended behavior but doesn't fit above categories.}
