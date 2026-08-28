# Freshness check: staleness detection (the mechanism, stated only here)

Prior findings are only trustworthy if the code hasn't moved. Phase 1 records what recon ran
against; Phase 0 of a later run compares and puts the choice to the user.

The check is **commit-based**, not timestamp-based.

---

## Recording (Phase 1)

Put the recon's commit in `recon-manifest.md`: `git rev-parse HEAD`, plus whether the working tree
was clean (`git status --porcelain`). A dirty tree means the SHA doesn't fully describe what was
read, so say so.

## Comparing (Phase 0 of a later run)

`git diff --name-only <recorded-sha> HEAD` gives the changed files exactly; add
`git status --porcelain` for uncommitted work. Intersect that with the areas the manifest recorded
and re-recon only those.

**Drop excluded paths from the changed set** before reporting anything. The manifest records the
exclusions in force, and drift in a directory the user told you to ignore is not drift. Otherwise a
churning generated tree reports the docs stale on every run.

## Never compare mtimes

A fresh clone rewrites every file's timestamp, so a timestamp check reports the whole tree as
drifted on any machine that didn't run the original recon, which is most of them. This is a trap;
don't "fix" the check back to timestamps.

## No git available?

Fall back to hashing just the files the manifest lists as read, a bounded set, since recon reads
the high-signal subset, not the repo. If hashing isn't possible either, record that staleness can't
be detected and re-recon the areas a change would have to touch rather than assuming the docs still
hold.

---

## Reporting drift, and what the user can do about it

Report it plainly and usefully, as in *"12 files changed in the billing area since the last recon at
`a1b2c3d`; `areas/billing/rules-refund-eligibility.md` and `areas/billing/workflow-invoice-run.md`
draw on that area"*,
naming the **areas** and the **documents that depend on them**, not just a file count. Then offer
the choice, with a recommendation, unless `--on-drift` already answered it, in which case say which
action you're taking and why it was chosen for you:

- **Re-recon the affected areas** (the default, and what to recommend for most drift) — targeted,
  cheap, and only the affected docs get rewritten.
- **Re-run recon from scratch** — recommend this instead when the drift spans most areas or the
  paths themselves moved, since patching area by area costs more than a clean pass.
- **Proceed as-is** — reasonable when the drift is in areas irrelevant to what the user is doing
  now. Not free: see the flag rule below.
- **Report only** — produce the drift list as a to-do and change nothing. Same flag rule.

If the user declines to re-recon, the affected claims no longer have verified backing: revert them
to `[unchecked]` and log them in the assumptions register, exactly as if they'd come from someone
else's stale documentation, which, as of now, they have. Never leave a claim reading as accepted
when the code beneath it has moved.

Record the decision in the manifest's freshness-check log, so the next session knows this was
chosen rather than missed.
