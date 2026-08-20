# The write contract (the rule, stated only here)

The output lands in a repository this skill doesn't own, so the destination is **agreed, not
assumed**. Phase 0 surveys the write target and records the outcome in `discovery-state.md`; every
later phase is bound by it.

1. **`docs/` means the agreed output root.** It defaults to `docs/`, and becomes something else
   (usually `docs/discovery/`) when the repo's `docs/` is a published documentation site or is
   already occupied. Read every `docs/…` path in this skill as `<output root>/…`. The layout
   *underneath* the root never changes, so relative links between the output files are unaffected
   by which root was chosen.
2. **The root sits at the project root**, alongside `.git` and `.claude/`, not in the current
   directory when that's somewhere below it. "Project root" throughout this skill means that
   directory, so the project-root `README.md` is its README.
   `--output` names the root and is read relative to it; where the path given would land outside the
   project root, say so and confirm rather than writing there on the strength of a flag.
3. **Write nothing outside that root.** The one exception is the project-root `README.md`, which
   has its own rules in the synthesis playbook.
4. **Never overwrite a file you didn't write.** If something already occupies a target path, read
   it, show the user what would change, and get sign-off first. A generated doc must not silently
   replace a human-authored one, however stale that one looks.
5. **A previous run's own output may be refreshed in place**, recognisable by this skill's header
   block.
6. **Respect the published-site decision.** Where the root belongs to a docs generator, Phase 0
   recorded whether these pages go in its nav/sidebar. Never add pages to a public site's
   navigation without that decision.

What each file is *for*, meaning the layout, naming, header block and length, is
[`output-conventions.md`](output-conventions.md). This file is only about where you may write and
whether you may replace what's there.
