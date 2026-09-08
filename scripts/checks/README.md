# Content checks

`scripts/validate.js` is the repo's **format** gate: manifests, frontmatter, referenced paths.
It is deliberately component-agnostic — it must not know that any particular skill, command or
agent exists.

Some components have invariants that only make sense for them: a rule that has to be worded
identically in several files, a closed vocabulary, a naming scheme. Those belong here. Each
module in this directory is loaded automatically by `validate.js` and runs as part of the same
gate, so CI needs no extra wiring and a component's rules ship in the component's own PR.

## Writing one

Create `scripts/checks/<component-name>.js` exporting a single `run(ctx)`:

```js
"use strict";

exports.run = ({ ROOT, err, rel, read, isFile, isDir, walkFiles }) => {
  const p = require("path").join(ROOT, "skills/my-skill/SKILL.md");
  if (!isFile(p)) return;              // component absent — no-op, don't fail
  if (!read(p).includes("the thing")) {
    err(`${rel(p)}: lost the canonical wording "the thing" — update X and Y together`);
  }
};
```

`ctx` provides:

| Helper | Purpose |
|---|---|
| `ROOT` | Absolute path to the repo root |
| `err(msg)` | Record a failure; the gate exits 1 if any were recorded |
| `rel(p)` | Repo-relative path, for readable messages |
| `read(p)` | File contents as UTF-8 |
| `isFile(p)` / `isDir(p)` | Existence checks |
| `walkFiles(dir, predicate)` | Recursively collect matching files |

## Rules

- **No-op when the component is missing.** Return early rather than erroring, so removing a
  component doesn't leave a confusing red gate behind.
- **Make the message say how to fix it.** Name every file that has to change together — the
  message is read by whoever's build just went red.
- **Match on meaning, not layout.** Normalise whitespace before comparing prose, so re-wrapping
  a paragraph doesn't fail the gate; only a genuine reword should.
- **Node stdlib only.** The gate is dependency-free so it runs anywhere, including CI.
- **Delete the module with the component.** These are maintenance aids, not artefacts to keep.
