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
3. **Write nothing outside that root.** Two files are the exceptions, both at the project root, each
   with its own rules in the playbook that writes it: `README.md` (synthesis) and the agent
   onboarding file, `CLAUDE.md` or `AGENTS.md` (finish). Rule 5 below governs both, so being an
   exception to *where* buys no exception to *whether you may replace what's there*.
4. **Write nothing, and delete nothing, before the root is settled.** This binds Phase 0's own
   `_discovery/` files too: creating them under an assumed root puts the record of the decision in
   the directory the decision rejected, and `--fresh` would wipe a directory nobody has agreed is
   the right one. Locating and reading a previous run's state is read-only, so it comes first.
5. **Never overwrite a file you didn't write.** If something already occupies a target path, read
   it, show the user what would change, and get sign-off first. A generated doc must not silently
   replace a human-authored one, however stale that one looks.
6. **A previous run's own output may be refreshed in place**, recognisable by this skill's header
   block. Refreshed, never re-initialised: `assumptions-register.md` and `traceability-index.md` are
   the committed audit trail for docs still in the repo, so they are updated and never replaced with
   an empty template. Their presence is also evidence that a previous run happened, whatever the
   git-ignored state files do or don't show. The one way past this is `--fresh`, which deletes them
   outright and only on the user's confirmation, having said first what git can and cannot give back.
7. **Respect the published-site decision, and never edit the nav yourself.** Where the root belongs
   to a docs generator, Phase 0 recorded whether these pages belong in its nav or sidebar. That
   config usually sits outside the output root, which rule 3 puts out of reach, so record the
   decision and leave the edit to the team. Publishing pages to someone's site by editing its index
   is not a write this skill makes.

What each file is *for*, meaning the layout, naming, header block and length, is
[`output-conventions.md`](output-conventions.md). This file is only about where you may write and
whether you may replace what's there.
