"use strict";

/*
 * Content checks for the codebase-discovery skill.
 *
 * Loaded automatically by scripts/validate.js, which stays component-agnostic. Everything here is
 * specific to this one skill: it guards two invariants the skill's own docs declare, so a later
 * edit can't quietly break them.
 *
 * If the skill is ever removed from the repo, delete this file — the checks no-op rather than
 * fail when their targets are missing, so a partial removal doesn't produce a confusing red gate.
 */

const path = require("path");

/* ---------------------------------------------------------------------------------------------
 * 1. The secrets rule is worded identically everywhere it must be restated.
 *
 * It's normative in one place: the skill's SKILL.md. The bundled subagents can't resolve a path
 * into the skill, so they carry a standalone copy — the only permitted restatements. Anywhere
 * else must link the rule. Relaxing one copy must not silently leave the others behind.
 * ------------------------------------------------------------------------------------------- */
const SECRETS_RULE = "by name and location, never the value";
const SECRETS_RULE_FILES = [
  "skills/codebase-discovery/SKILL.md",
  "agents/codebase-recon-scout.md",
  "agents/codebase-doc-verifier.md",
];

function checkSecretsRule({ ROOT, err, read, isFile }) {
  const present = SECRETS_RULE_FILES.filter((f) => isFile(path.join(ROOT, f)));
  if (present.length === 0) return; // skill not installed in this tree
  for (const f of SECRETS_RULE_FILES) {
    const p = path.join(ROOT, f);
    if (!isFile(p)) {
      err(`secrets rule: expected file not found: ${f}`);
      continue;
    }
    // Whitespace-normalised so re-wrapping a paragraph doesn't fail the gate — only rewording does.
    if (!read(p).replace(/\s+/g, " ").includes(SECRETS_RULE)) {
      err(
        `${f}: missing the canonical secrets-rule wording "${SECRETS_RULE}". ` +
        `The rule is normative in skills/codebase-discovery/SKILL.md and restated only in the ` +
        `bundled subagents — if you reworded or relaxed it, update all of: ` +
        SECRETS_RULE_FILES.join(", ")
      );
    }
  }
}

/* ---------------------------------------------------------------------------------------------
 * 2. The status vocabulary is closed.
 *
 * Defined in the skill's references/provenance-and-status.md. A flag the reader was never taught
 * is noise, so catch a sixth one being invented in a playbook or template (as `[unverifiable]`
 * once was, silently unhandled by the verification phase).
 * ------------------------------------------------------------------------------------------- */
const STATUS_FLAGS = ["unchecked", "unverified", "assumption", "outdated", "contradicted"];
// Bracketed lowercase words that legitimately aren't status flags.
const NOT_A_FLAG = new Set(["redacted", "text", "name", "system"]);

function checkStatusFlags({ ROOT, err, rel, read, isDir, walkFiles }) {
  const skillDir = path.join(ROOT, "skills", "codebase-discovery");
  if (!isDir(skillDir)) return; // skill not installed in this tree

  const files = walkFiles(skillDir, (p) => p.endsWith(".md"));
  const agentsDir = path.join(ROOT, "agents");
  files.push(
    ...walkFiles(agentsDir, (p) => path.basename(p).startsWith("codebase-") && p.endsWith(".md"))
  );

  const allowed = new Set([...STATUS_FLAGS, ...NOT_A_FLAG]);
  for (const p of files) {
    // `[word]` not followed by `(` — a flag, not a markdown link. `[ ]`/`[x]` checkboxes and
    // mermaid `[*]` don't match the character class.
    for (const m of read(p).matchAll(/\[([a-z][a-z-]{2,})\](?!\()/g)) {
      if (!allowed.has(m[1])) {
        err(
          `${rel(p)}: unknown status flag "[${m[1]}]". The vocabulary is closed to ` +
          STATUS_FLAGS.map((f) => `[${f}]`).join(" / ") +
          " — see skills/codebase-discovery/references/provenance-and-status.md"
        );
      }
    }
  }
}

exports.run = (ctx) => {
  checkSecretsRule(ctx);
  checkStatusFlags(ctx);
};
