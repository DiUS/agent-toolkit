# knowledge-curation — a Claude Code skill for building a knowledge base

Turns source documents (functional specs, technical docs, ADRs, meeting notes,
interviews, glossaries) into structured, provenance-tagged knowledge under a
`knowledge/` tree — acting as a senior BA that decomposes rather than summarises and
**asks rather than guesses**.

Self-contained: everything the skill needs lives in this folder. The only thing it
writes outside itself is the `knowledge/` corpus at the workspace root.

## What's in here

| path | what it is |
|------|------------|
| `SKILL.md` | the method Claude follows (the entry point) |
| `references/` | method docs (elicitation, grouping, completeness, business-vs-tech routing) |
| `references/conventions/` | the four always-load rule docs — see below |
| `references/knowledge/` | the per-type file templates (one per curated file type) |
| `references/registry-templates/` | templates for the platform registries and ADRs |
| `scripts/` | the four hygiene checks — see below |
| `assets/knowledge-base/` | the empty knowledge-base scaffold, laid down on first run |

The two smaller sets below are stable, so they're named individually. The per-type
templates in `references/knowledge/` are deliberately **not** listed one by one — the
folder already names them and each opens with its own purpose line, so a manifest
here would just be a second copy to keep in sync (the skill's own "pointers, not
summaries" rule).

**The four convention docs** (`references/conventions/`) — loaded before extracting:

| file | what it governs |
|------|-----------------|
| `structure.md` | the knowledge-base tree — platform/domain/feature tiers, and where each fact belongs |
| `ba-principles.md` | the non-negotiables — coverage first, label provenance, surface conflicts, don't invent |
| `knowledge-boundary.md` | the central-vs-provisional test for business vs. technology content |
| `front-matter.md` | the metadata schema — the six fields, `basis`/`status` vocabularies, ID conventions |

**The four checks** (`scripts/`) — read-only, run from the workspace root:

| script | enforces |
|--------|----------|
| `check-frontmatter.sh` | frontmatter parses and enum values are valid (needs `pyyaml`) |
| `check-placement.sh` | ID definitions live only under `knowledge/`; no duplicate IDs |
| `check-examples.sh` | no `example: true` placeholder content is cited as fact |
| `check-structure.sh` | tier discipline — domain/feature folders have an `index.md`, and every tier-scoped folder (`rules/`, `workflows/`, `questions/`, `tech/*`, `constraints/`) sits at its correct tier |

## Install

- **One project:** copy this `knowledge-curation/` folder to `<project>/.claude/skills/knowledge-curation/`.
- **All your projects:** copy it to `~/.claude/skills/knowledge-curation/` (Windows:
  `C:\Users\<you>\.claude\skills\knowledge-curation\`).

Restart / start a Claude Code session in the target project — skills load at session
start. Confirm with `/knowledge-curation`.

## Use

1. Put a source document somewhere in the project (the skill uses
   `knowledge/sources/<domain>/`).
2. Ask Claude to **curate** it, pointing at the file (path or attachment), or type
   `/knowledge-curation`.
3. On first run the skill scaffolds `knowledge/` at the workspace root from
   `assets/knowledge-base/`. Thereafter it registers the source, confirms domain and
   feature **with you in chat**, proposes a topic grouping, extracts into the right
   tiers, and updates the registries — every fact carrying an honest `basis`
   (`documented` / `stated` / `inferred` / `assumed`) and `status: draft` until a
   human confirms it.

## Hygiene checks

Run from the workspace root:

```bash
bash .claude/skills/knowledge-curation/scripts/check-placement.sh
bash .claude/skills/knowledge-curation/scripts/check-examples.sh
bash .claude/skills/knowledge-curation/scripts/check-structure.sh
bash .claude/skills/knowledge-curation/scripts/check-frontmatter.sh   # needs: pip3 install pyyaml
```

Requires Bash + `python3`; `check-frontmatter.sh` also needs `pyyaml` (it skips
gracefully if absent). On Windows, run them under Git Bash.
